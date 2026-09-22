
$SoftwareFolder = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
$configFile = "$SoftwareFolder\config.txt"

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Unity Github automatic git push" -ForegroundColor Cyan
Write-Host "        Made by JAUSKI" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Warning this script does not create repo, git folder etc that is ready for unity"
Write-Host "This script only pushes changes to the repo"
Write-Host "Please setup the repo through unity hub when creating new project"
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# config file checkign and reading
if (Test-Path $configFile) {
    # if file is foudn reading first line to variable
    $ProjectFolder = Get-Content $configFile -TotalCount 1
    Write-Host "Config loaded. Targeting project: $ProjectFolder`n" -ForegroundColor DarkGray
}
else {
    # asking path and creating config file if there is no config file
    Write-Host "Config-file not found!" -ForegroundColor Yellow
    $ProjectFolder = Read-Host "Please enter your project folder path)"
    
    # saving and creating config file with project path
    $ProjectFolder | Out-File -FilePath $configFile -Encoding UTF8
    Write-Host "Saved to config.txt" -ForegroundColor Green
}


#if  config file contain project wrong project path then software does not start giving lot of red error instead it stops erro action and tell us nicely that project path is missing or wrong
try {
    Set-Location -Path $ProjectFolder -ErrorAction Stop
}
catch {
    Write-Host "Could not find the path: $ProjectFolder" -ForegroundColor Red
    Write-Host "Please fix the path inside the config.txt file" -ForegroundColor Yellow
    Pause
    exit
}


if (!(Test-Path "$ProjectFolder\.git")) {
    Write-Host "defined folder does not contain .git folder" -ForegroundColor Red
    Write-Host "Check that your defined folder path is right" -ForegroundColor Yellow
    Pause
    exit
}


if (git status --porcelain) {
    Write-Host "Modified files:" -ForegroundColor Yellow
    git status -s
    Write-Host ""
}
else {
    Write-Host "No Modified Files closing script"
    pause
    exit
}



$commitMessage = ""
while ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = Read-Host "Write commit-message"
    
    if ([string]::IsNullOrWhiteSpace($commitMessage)) {
        Write-Host "Commit-message cannot be empty Please type a message" -ForegroundColor Red
    }
}

# excecuting commands
Write-Host "`nAdding changed files to push " -ForegroundColor Cyan
git add .

Write-Host "making commit " -ForegroundColor Cyan
git commit -m "$commitMessage"

Write-Host "Sending to github " -ForegroundColor Cyan
git push origin HEAD

Write-Host "`n Files have been sent to GitHub!" -ForegroundColor Green
Pause

