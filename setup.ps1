Write-Host "[SETUP] Starting Setup"
# check if we've already run the setup
if((Test-Path env:WBUILD_RUNNER_SETUP))
{
if($env:WBUILD_RUNNER_SETUP == 1)
{
  Write-Host "[SETUP] env:WBUILD_RUNNER_SETUP is set to 1, nothing to setup"
  exit
}
elseif($env:WBUILD_RUNNER_SETUP == 0)
{
  Write-Host "[SETUP] env:WBUILD_RUNNER_SETUP is set to 1, re-running script"
}
}
else 
{
  Write-Host "[SETUP] env:WBUILD_RUNNER_SETUP is not defined, running full script"  
}

if(-not (Get-Command -Name choco -ErrorAction SilentlyContinue))
{ 
  Write-Host "[SETUP] Installing Chocolatey"
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  refreshenv
}
if(-not (Get-Command -Name python3 -ErrorAction SilentlyContinue))
{
  Write-Host "[SETUP] Installing Python3 with Chocolatey"
  choco install python3
}
refreshenv

Write-Host "[SETUP] Installing conan with pip3"
pip3 install conan
refreshenv
conan profile new default --detect
Write-Host "[SETUP] Adding remotes to conan" 
conan remote add conan-bincrafters https://api.bintray.com/conan/bincrafters/public-conan
conan remote add darcamo-bintray  https://api.bintray.com/conan/darcamo/cppsim

[System.Environment]::SetEnvironmentVariable('WBUILD_RUNNER_SETUP', '1', [System.EnvironmentVariableTarget]::User)
Write-Host "[SETUP] Setup complete"

