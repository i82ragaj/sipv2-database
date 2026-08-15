
CREATE PROCEDURE [dbo].[NavExportCSV]
    @company VARCHAR(40) = null, 
    @genDate DATE = null
AS
BEGIN
    -- Declaración de variables
    DECLARE @cmd VARCHAR(8000);

	-- Por si queremos usar la fecha de hoy para el nombre del archivo
    DECLARE @currentDate DATE = COALESCE(@genDate, DATEADD(dd, -1, CAST(GETDATE() as date)));
    DECLARE @currentDateStr NVARCHAR(8) = FORMAT(@currentDate, 'yyyyMMdd');

	DECLARE @dateFormat NVARCHAR(20) = 'dd/MM/yyyy HH:mm'; -- Formato para datos tipo DateTime2

    DECLARE @dirRoot NVARCHAR(255) = 'E:\ERP\SIPTOP\';
    DECLARE @dirTmp NVARCHAR(255) = 'E:\ERP\TMP\';

    DECLARE @filePathTmp NVARCHAR(255) =  null;
    DECLARE @filePathPending NVARCHAR(255) =  null;
    DECLARE @filePathGenerated NVARCHAR(255) = null;
        
    DECLARE @fileName NVARCHAR(255);
    DECLARE @companyVar NVARCHAR(40);
	DECLARE @parkingVar NVARCHAR(40);

    DECLARE c CURSOR FOR
        SELECT [Company], [Dacode]
        FROM [AA-ADMIN].[dbo].[MDParking]
        WHERE Active = 1 and ([Company] = @company or @company is null)

    OPEN c

    FETCH NEXT FROM c
    INTO @companyVar, @parkingVar
        
    WHILE @@FETCH_STATUS = 0
    BEGIN

        BEGIN TRY
            set @fileName = + @currentDateStr + '-' + @companyVar + '-' + @parkingVar + '.csv';
            set @filePathTmp = @dirTmp  + '\' + @fileName;
            set @filePathGenerated = @dirRoot + @companyVar + '\Generados\' + @fileName;
            set @filePathPending = @dirRoot + @companyVar + '\Pendientes\' + @fileName;

            -- Construcción de la consulta SQL
            DECLARE @sqlQuery VARCHAR(MAX) = '
                SET NOCOUNT ON;
                SELECT [IDPK]
                    ,[NombreParking]
                    ,[Departamento]
                    ,[FechaEmision]
                    ,[TipoDocumento]
                    ,[NoDocumento]
                    ,[FormaPago]
                    ,[LineaNo]
                    ,[Expendedor]
                    ,[Cantidad]
                    ,[Total]
                    ,[Alias]
                    ,[Dispositivo]
                    ,[FacturaSimplificadaDesde]
                    ,[FacturaSimplificadaHasta]
                FROM [dbo].[VNavSummary]
                WHERE [SumaryDate] = ''' +  @currentDateStr + ''' and [Company] = ''' + @companyVar + ''' and [Departamento] = ''' + @parkingVar + '''
                ORDER BY [IDPK], [LineaNo]';

            PRINT @sqlQuery;
		    PRINT @filePathTmp

            SET @sqlQuery = REPLACE(REPLACE(@sqlQuery, CHAR(13), ''), CHAR(10), '');


            -- Ejecuta sqlcmd y guarda temporalmente el archivo Pending con encabezados
            SET @cmd = 'sqlcmd -S localhost -d AA-ERPINT -U icca -P Icca2025 -Q "' + @sqlQuery + '" -s ";" -o "' + @filePathTmp + '" -W -w 1024';
            PRINT @cmd;
            EXEC sys.xp_cmdshell @cmd;

            -- Limpieza de separadores (líneas que no comienzan con dos guiones (--) y guarda archivo limpio para Pending
            SET @cmd = 'powershell -Command "Get-Content ' + @filePathTmp + ' | Where-Object {$_ -notmatch ''^-{2,}''} | Set-Content ' + @filePathGenerated + '"';
            PRINT @cmd;
            EXEC sys.xp_cmdshell @cmd;

            -- Duplica el archivo limpio en la ruta de History
            SET @cmd = 'copy /Y ' + @filePathGenerated + ' ' + @filePathPending;
            PRINT @cmd;
            EXEC sys.xp_cmdshell @cmd;

			-- Elimina el archivo temporal
            SET @cmd = 'del ' + @filePathTmp;
            PRINT @cmd;
            EXEC sys.xp_cmdshell @cmd;

            --PRINT 'Archivo CSV creado correctamente en ' + @filePath + ' y ' + @filePath2;
        END TRY
        BEGIN CATCH
            PRINT 'Error: ' + ERROR_MESSAGE();
        END CATCH


        FETCH NEXT FROM c
        INTO @companyVar, @parkingVar

    END

    CLOSE c
    DEALLOCATE c
END;