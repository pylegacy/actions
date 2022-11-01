param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $arch,

    [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $toolset
)


$VCVARS = "INCLUDE", "LIB", "LIBPATH", "PATH", "VCINSTALLDIR", "WindowsSdkDir"
Switch ("${toolset}") {
    "v90" {
        $VSINSTALLDIR =`
            "$env:LOCALAPPDATA\Programs\Common\Microsoft\Visual C++ for Python\9.0"
        $VCVARSALL =`
            "${VSINSTALLDIR}\vcvarsall.bat"
    }
    "v140" {
        $VSINSTALLDIR =`
            "C:\Program Files (x86)\Microsoft Visual Studio 14.0"
        $VCVARSALL =`
            "${VSINSTALLDIR}\VC\vcvarsall.bat"
        $VCVARS +=`
            "VSINSTALLDIR", "VS140COMNTOOLS", "VisualStudioVersion",          `
            "WindowsLibPath", "UCRTVersion", "UniversalCRTSdkDir", "Platform",`
            "CommandPromptType", "WindowsSDKLibVersion", "WindowsSDKVersion", `
            "FrameworkDir", "FrameworkVersion", "Framework40Version",         `
            "FrameworkDIR32", "FrameworkVersion32",                           `
            "FrameworkDIR64", "FrameworkVersion64"                            `
    }
    default {
        Write-Error "Invalid MSVC toolset: '${toolset}'" -ErrorAction Stop
    }
}

cmd.exe /c "`"${VCVARSALL}`" ${arch} && set" | ForEach-Object {
    $name, $value = $_ -split '=', 2
    if (${VCVARS} -contains $name) {
        Write-Output $_
    }
}
