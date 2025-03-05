
$PROJECT = "C://Users/iei/Documents/Embarcadero/Studio/Projekte/Project3.dproj"
$MSBUILD_DIR = [System.Environment]::GetEnvironmentVariable('FrameworkDir', [System.EnvironmentVariableTarget]::Process)

& $MSBUILD_DIR\MSBuild.exe $PROJECT "/t:Clean,Make"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host ""

# Check if an argument is provided
if ($args.Count -eq 0) {
    exit 0
}


Write-Host "Running Project3..."
$exePath = "C:\Users\iei\Documents\Embarcadero\Studio\Projekte\Win32\Debug\Project3.exe"
$process = Start-Process -FilePath $exePath -PassThru

Wait-Process -Id $process.Id
