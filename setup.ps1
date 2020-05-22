Write-Host "Starting Setup"
# check if we've already run the setup
if((Test-Path env:WBUILD_RUNNER_SETUP))
{
if($env:WBUILD_RUNNER_SETUP == 1)
{
  Write-Host "env:WBUILD_RUNNER_SETUP is set to 1, nothing to setup"
  exit
}
elseif($env:WBUILD_RUNNER_SETUP == 0)
{
  Write-Host "env:WBUILD_RUNNER_SETUP is set to 1, re-running script"
}
}
else 
{
  Write-Host "env:WBUILD_RUNNER_SETUP is not defined, running script"  
}

if(-not (Get-Command -Name choco -ErrorAction SilentlyContinue))
{ 
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  refreshenv
}
if(-not (Get-Command -Name python3 -ErrorAction SilentlyContinue))
{
  choco install python3
}
pip3 install conan
refreshenv 
conan remote add conan-bincrafters https://api.bintray.com/conan/bincrafters/public-conan
conan remote add darcamo-bintray  https://api.bintray.com/conan/darcamo/cppsim

[System.Environment]::SetEnvironmentVariable('WBUILD_RUNNER_SETUP', '1', [System.EnvironmentVariableTarget]::User)
Write-Host "Setup complete"