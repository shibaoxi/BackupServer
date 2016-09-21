# ##############此脚本为备份系统状态、磁盘卷#############################

#定义用于存放备份的文件服务器
$FileServer="DC.UC.COM"
#定义备份根目录
$HomeWBDir="\\$FileServer\Share\backup"
#定义备份文件夹名称
$time=Get-Date -Format MMddyyyy_hhmmss
$hostname=hostname
$FileName=("$hostname"+"_"+"$time")
#定义账户
"abcd1234," | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\Password.txt"
$pass = Get-Content "C:\Password.txt" | ConvertTo-SecureString
$User = "UC\itadmin"
$File = "C:\Password.txt"
$MyCredential=New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

#获取所有备份卷
$Volumes=Get-WBVolume -AllVolumes
#创建备份目标
New-Item ($HomeWBDir+"\"+$FileName) -ItemType Directory
$Backuplocation=New-WBBackupTarget -NetworkPath ($HomeWBDir+"\"+$FileName) 

#创建备份策略
$WBPolicy=New-WBPolicy
Add-WBBareMetalRecovery -Policy $WBPolicy
Add-WBSystemState -Policy $WBPolicy
Add-WBBackupTarget -Policy $WBPolicy -Target $Backuplocation -Force
Add-WBVolume -Policy $WBPolicy -Volume $Volumes

##############启动备份#####################
Start-WBBackup -Policy $WBPolicy
