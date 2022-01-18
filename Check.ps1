$OS_TYPE=""
$OS_VERSION=""
if (($PSVersionTable).Platform) {
  $OS_TYPE = ($PSVersionTable).Platform
  $OS_VERSION = ($PSVersionTable).OS
} else {
  $OS_TYPE = $env:OS
  $OS_VERSION = (Get-WMIObject win32_operatingsystem).name.Split("|")[0]
}

if ($OS_TYPE -eq "Windows_NT" -or $OS_TYPE -eq "Win32NT") {
  Write-Host -ForegroundColor Green "Windows Detected"
} else {
  Write-Host -ForegroundColor Red "Non-Windows Detected"
}

$DOCKER_INFO=$(docker info 2> $null)
$DOCKER_STATUS=$?
$DOCKER_SERVER_VERSION=""
if (-not $DOCKER_STATUS) {
  Write-Host -ForegroundColor Red "Error when calling 'docker info'. Is Docker CLI installed?"
  Write-Host $DOCKER_INFO
} else {
  $DOCKER_SERVER_VERSION=($DOCKER_INFO | Select-String -Pattern "Server Version").ToString().Trim().Split()[2]
  Write-Host -ForegroundColor Green "Call to 'docker info' successful."
}

$CHOCO_VERSION=$(choco -v)
$CHOCO_DETECT=$?
if (-not $CHOCO_DETECT) {
  Write-Host -ForegroundColor Red "Problem detecting choco.  Check to see if it is installed."
} else {
  Write-Host -ForegroundColor Green "Choco install detected."
}

$GIT_VERSION=$((git version).ToString().Split()[2])
$GIT_DETECT=$?
if (-not $GIT_DETECT) {
  Write-Host -ForegroundColor Red "Problem detecting git.  Check to see if it is installed."
} else {
  Write-Host -ForegroundColor Green "Git install detected."
}

[PSCustomObject]@{
  OS = $OS_VERSION
  DOCKER = $DOCKER_SERVER_VERSION
  CHOCO = $CHOCO_VERSION
  GIT = $GIT_VERSION
} | Format-Table