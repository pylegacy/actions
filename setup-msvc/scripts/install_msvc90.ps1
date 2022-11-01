if (-not "$env:VS090URL") {
    Write-Warning "Missing environment variable VS090URL, using fallback"
    $env:VS090URL = "https://github.com/reider-roque/sulley-win-installer/raw/master/VCForPython27.msi"
}
Invoke-WebRequest "$env:VS090URL" -OutFile VCForPython27.msi

(Start-Process "msiexec" -NoNewWindow -PassThru -ArgumentList `
    "/i VCForPython27.msi /qn /l*! output.log").WaitForExit()
Remove-Item -Path VCForPython27.msi
