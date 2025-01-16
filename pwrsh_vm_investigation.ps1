# Script to Investigate VM Reboot Causes
# Collects Event Viewer logs, checks for updates, and examines reboot history

# Function to get system reboot history
function Get-RebootHistory {
    Write-Host "Fetching reboot history..." -ForegroundColor Cyan
    Get-WinEvent -FilterHashtable @{LogName='System'; Id=1074, 1076, 6005, 6006, 6008} | 
    Select-Object TimeCreated, Id, Message | 
    Sort-Object TimeCreated -Descending | 
    Format-Table -AutoSize
}

# Function to check for updates that may have caused the reboot
function Get-RecentUpdates {
    Write-Host "Checking for recent updates..." -ForegroundColor Cyan
    Get-WinEvent -FilterHashtable @{LogName='System'; Id=19, 20, 21} | 
    Where-Object { $_.Message -match "restart required" -or $_.Message -match "reboot" } | 
    Select-Object TimeCreated, Message | 
    Sort-Object TimeCreated -Descending | 
    Format-Table -AutoSize
}

# Function to get details on scheduled tasks that may have triggered a reboot
function Get-ScheduledReboots {
    Write-Host "Checking for scheduled tasks related to reboots..." -ForegroundColor Cyan
    schtasks.exe /query /FO LIST | 
    Select-String -Pattern "shutdown", "reboot", "restart" | 
    Format-Table -AutoSize
}

# Function to check crash dumps or critical events
function Get-CriticalEvents {
    Write-Host "Fetching critical errors and unexpected shutdown events..." -ForegroundColor Cyan
    Get-WinEvent -FilterHashtable @{LogName='System'; Level=1, 2; Id=41, 6008} | 
    Select-Object TimeCreated, Id, Message | 
    Sort-Object TimeCreated -Descending | 
    Format-Table -AutoSize
}

# Run all checks
Write-Host "Starting reboot investigation..." -ForegroundColor Green

# Get Reboot History
Get-RebootHistory

# Get Updates History
Get-RecentUpdates

# Check Scheduled Tasks
Get-ScheduledReboots

# Get Critical Errors and Crashes
Get-CriticalEvents

Write-Host "Investigation complete. Review the details above for potential causes." -ForegroundColor Green
