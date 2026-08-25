#start log
$pathBackup = "E:\MSSQL\Backup\ESPDigital"
$pathFrom = "\\192.168.50.11\Backup"

Start-Transcript -path "E:\ESPDIGITAL\LOG\$(get-date -f yyyy-MM-dd_HHmm).txt" -append

#Delete old files
Get-ChildItem $pathBackup -Recurse -File | Where CreationTime -lt  (Get-Date).AddDays(-3)  | Remove-Item -Force

#Disconnect all connected files
net use * /delete /y

#Connect backup net
net use $pathFrom /user:$env:ESPDigitalUser $env:ESPDigitalPassord

#Copy new files
robocopy $pathFrom $pathBackup CC-ESPDDB*.bak CC-ESPDPMS*.bak  /ZB /XO /MAXAGE:3 /R:3 /W:30 /NP

#Disconnect backup net
net use $pathFrom /delete

#Database parameter
$username = $env:LocalDBUser
$password = $env:LocalDBPassword
$passwordConv = $password  | ConvertTo-SecureString -asPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $passwordConv
$Server = "localhost"

$sqlConnection = new-object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = 'server=' + $Server + ';User ID='+ $username +';Password='+ $password
$sqlConnection.Open()
$sqlCommand = new-object System.Data.SqlClient.SqlCommand
$sqlCommand.CommandTimeout = 120
$sqlCommand.Connection = $sqlConnection

#Disconnect all users
$sqlCommand.CommandText= "alter database [CC-ESPDDB] set offline with rollback immediate"
$result = $sqlCommand.ExecuteNonQuery()

$sqlCommand.CommandText= "alter database [CC-ESPDPMS] set offline with rollback immediate"
$result = $sqlCommand.ExecuteNonQuery()

$sqlConnection.Close()

#Restore last backup
$list = Get-ChildItem $pathBackup"\CC-ESPDDB*.bak" | Sort-Object -Descending -Property LastWriteTime | Select -First 1 -expand FullName

foreach($file in $list)
{
    Restore-SqlDatabase -ServerInstance $Server -Database "CC-ESPDDB" -Credential $credential -BackupFile $file -ReplaceDatabase 
}

$list = Get-ChildItem $pathBackup"\CC-ESPDPMS*.bak" | Sort-Object -Descending -Property LastWriteTime | Select -First 1 -expand FullName

foreach($file in $list)
{
    Restore-SqlDatabase -ServerInstance $Server -Database "CC-ESPDPMS" -Credential $credential -BackupFile $file -ReplaceDatabase 
}

#Set Online
$sqlConnection.Open()
$sqlCommand = new-object System.Data.SqlClient.SqlCommand
$sqlCommand.CommandTimeout = 120
$sqlCommand.Connection = $sqlConnection

$sqlCommand.CommandText= "alter database [CC-ESPDDB] set online"
$result = $sqlCommand.ExecuteNonQuery()

$sqlCommand.CommandText= "alter database [CC-ESPDPMS] set online"
$result = $sqlCommand.ExecuteNonQuery()

$sqlConnection.Close()

#Change owner user

$sqlConnection = new-object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = 'server=' + $Server + ';User ID='+ $username +';Password='+ $password +';database=' + "CC-ESPDDB" 
$sqlConnection.Open()
$sqlCommand = new-object System.Data.SqlClient.SqlCommand
$sqlCommand.CommandTimeout = 120
$sqlCommand.Connection = $sqlConnection

$sqlCommand.CommandText= "exec SP_changedbowner [ESPDigital]"
$result = $sqlCommand.ExecuteNonQuery()
$sqlConnection.Close()

$sqlConnection = new-object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = 'server=' + $Server + ';User ID='+ $username +';Password='+ $password +';database=' + "CC-ESPDPMS" 
$sqlConnection.Open()
$sqlCommand = new-object System.Data.SqlClient.SqlCommand
$sqlCommand.CommandTimeout = 120
$sqlCommand.Connection = $sqlConnection

$sqlCommand.CommandText= "exec SP_changedbowner [ESPDigital]"
$result = $sqlCommand.ExecuteNonQuery()
$sqlConnection.Close()

#Stop log
Stop-Transcript
