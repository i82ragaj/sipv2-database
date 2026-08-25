<#
.SYNOPSIS
    Busca carpetas "pendientes" dentro de una carpeta local base, sube su contenido
    a un contenedor de Azure Blob Storage (SAS token) manteniendo la ruta relativa,
    y mueve los archivos subidos con éxito a una carpeta "subidos" hermana.

.NOTES
    Requiere el módulo Az.Storage.
    Ejecutar en PowerShell 7.
#>

# ============================================================
# CONFIGURACIÓN — ajusta estos valores
# ============================================================
$LocalBaseFolder     = "E:\ERP\DATA"                        # Carpeta local raíz donde buscar
$LogFolder		     = "E:\ERP\LOG"                        # Carpeta local raíz donde buscar
$StorageAccountName  = "espdigital"
$ContainerName       = "datalake-golden"
$SasToken            = $env:AZURE_DATALAKE_SAS_TOKEN        # Recomendado: variable de entorno, no en texto plano
$PendientesFolderName = "pendientes"
$SubidosFolderName    = "subidos"
$LogFile             = Join-Path $LogFolder "upload_log.txt"

# ============================================================
# FUNCIÓN: subir un archivo a Azure Blob Storage
# ============================================================
function Copy-FileToAzureBlob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$LocalFilePath,

        [Parameter(Mandatory = $true)]
        [string]$RemotePath,

        [Parameter(Mandatory = $true)]
        [string]$StorageAccountName,

        [Parameter(Mandatory = $true)]
        [string]$ContainerName,

        [Parameter(Mandatory = $true)]
        [string]$SasToken
    )

    try {
        $context = New-AzStorageContext -StorageAccountName $StorageAccountName -SasToken $SasToken

        $result = Set-AzStorageBlobContent `
            -File $LocalFilePath `
            -Container $ContainerName `
            -Blob $RemotePath `
            -Context $context `
            -Force `
            -ErrorAction Stop

        return $true
    }
    catch {
        Write-Warning "Error al subir '$LocalFilePath': $_"
        return $false
    }
}

# ============================================================
# FUNCIÓN: procesar una carpeta "pendientes" encontrada
# ============================================================
function Invoke-ProcesarCarpetaPendientes {
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$PendientesFolder,

        [Parameter(Mandatory = $true)]
        [string]$LocalBaseFolder,

        [Parameter(Mandatory = $true)]
        [string]$StorageAccountName,

        [Parameter(Mandatory = $true)]
        [string]$ContainerName,

        [Parameter(Mandatory = $true)]
        [string]$SasToken,

        [Parameter(Mandatory = $true)]
        [string]$SubidosFolderName
    )

    # Carpeta "subidos" hermana de "pendientes" (mismo nivel)
    $subidosFolder = Join-Path $PendientesFolder.Parent.FullName $SubidosFolderName
    if (-not (Test-Path $subidosFolder)) {
        New-Item -Path $subidosFolder -ItemType Directory -Force | Out-Null
    }

    # Todos los archivos dentro de "pendientes" (incluye subcarpetas, si las hubiera)
    $archivos = Get-ChildItem -Path $PendientesFolder.FullName -File -Recurse

    if ($archivos.Count -eq 0) {
        Write-Host "  Sin archivos en: $($PendientesFolder.FullName)" -ForegroundColor DarkGray
        return
    }

    foreach ($archivo in $archivos) {
        # Ruta relativa respecto a la carpeta base local -> se usa igual en el contenedor
		$nombreCarpetaBase = Split-Path $LocalBaseFolder -Leaf
		$rutaRelativa = $archivo.FullName.Substring($LocalBaseFolder.Length).TrimStart('\','/')
		$rutaRemota = "$nombreCarpetaBase/$rutaRelativa" -replace '\\', '/'
        Write-Host "  Subiendo: $rutaRelativa" -ForegroundColor Cyan

        $subidaOk = Copy-FileToAzureBlob `
            -LocalFilePath $archivo.FullName `
            -RemotePath $rutaRemota `
            -StorageAccountName $StorageAccountName `
            -ContainerName $ContainerName `
            -SasToken $SasToken
		
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        if ($subidaOk) {
            # Mantener la misma subestructura de carpetas dentro de "subidos", si "pendientes" tenía subcarpetas
            $rutaRelativaDentroDePendientes = $archivo.FullName.Substring($PendientesFolder.FullName.Length).TrimStart('\','/')
            $destinoEnSubidos = Join-Path $subidosFolder $rutaRelativaDentroDePendientes
            $destinoCarpeta   = Split-Path $destinoEnSubidos -Parent

            if (-not (Test-Path $destinoCarpeta)) {
                New-Item -Path $destinoCarpeta -ItemType Directory -Force | Out-Null
            }

            try {
                Move-Item -Path $archivo.FullName -Destination $destinoEnSubidos -Force -ErrorAction Stop
                Write-Host "    OK -> movido a subidos" -ForegroundColor Green
                "$timestamp`tOK`t$rutaRelativa" | Add-Content -Path $LogFile
            }
            catch {
                Write-Warning "    Subido pero fallo al mover: $_"
                "$timestamp`tSUBIDO_SIN_MOVER`t$rutaRelativa`t$_" | Add-Content -Path $LogFile
            }
        }
        else {
            Write-Host "    FALLO -> se deja en pendientes" -ForegroundColor Red
            "$timestamp`tFALLO`t$rutaRelativa" | Add-Content -Path $LogFile
        }
    }
}

# ============================================================
# SCRIPT PRINCIPAL
# ============================================================

# Comprobaciones previas
if (-not (Get-Module -ListAvailable -Name Az.Storage)) {
    throw "El módulo Az.Storage no está instalado. Instálalo con: Install-Module -Name Az.Storage -Scope AllUsers -Force -AllowClobber"
}
Import-Module Az.Storage -ErrorAction Stop

if ([string]::IsNullOrWhiteSpace($SasToken)) {
    throw "No se ha definido el SAS token. Configura la variable de entorno AZURE_DATALAKE_SAS_TOKEN o edita `$SasToken en el script."
}

if (-not (Test-Path $LocalBaseFolder)) {
    throw "La carpeta base local no existe: $LocalBaseFolder"
}

Write-Host "Buscando carpetas '$PendientesFolderName' dentro de: $LocalBaseFolder" -ForegroundColor Yellow

# Buscar todas las carpetas "pendientes" en cualquier nivel dentro de la carpeta base
$carpetasPendientes = Get-ChildItem -Path $LocalBaseFolder -Directory -Recurse -Filter $PendientesFolderName

if ($carpetasPendientes.Count -eq 0) {
    Write-Host "No se ha encontrado ninguna carpeta '$PendientesFolderName'." -ForegroundColor Yellow
    return
}

Write-Host "Encontradas $($carpetasPendientes.Count) carpeta(s) '$PendientesFolderName'.`n" -ForegroundColor Yellow

foreach ($carpeta in $carpetasPendientes) {
    Write-Host "Procesando: $($carpeta.FullName)" -ForegroundColor Magenta

    Invoke-ProcesarCarpetaPendientes `
        -PendientesFolder $carpeta `
        -LocalBaseFolder $LocalBaseFolder `
        -StorageAccountName $StorageAccountName `
        -ContainerName $ContainerName `
        -SasToken $SasToken `
        -SubidosFolderName $SubidosFolderName

    Write-Host ""
}

Write-Host "Proceso completado. Revisa el log en: $LogFile" -ForegroundColor Yellow