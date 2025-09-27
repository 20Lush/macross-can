<#
.SYNOPSIS
    A helper script for managing the Macross-CAN firmware project.
#>
[CmdletBinding()]
param (
    [switch]$build,
    [switch]$clean,
    [switch]$flash,
    [switch]$submodules
)

# --- Project Configuration ---
$ProjectName = "macross-can"
$BuildDir = "build"
$Mcu = "imxrt1062"

# --- Helper Functions ---
function Invoke-Build {
    Write-Host "--- Building Firmware ---"
    if (-not (Test-Path $BuildDir)) {
        New-Item -ItemType Directory -Path $BuildDir | Out-Null
    }
    
    Push-Location $BuildDir
    cmake -G "MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE="../cmake/arm-none-eabi-gcc.cmake" ..
    cmake --build .
    Pop-Location
}

function Invoke-Clean {
    Write-Host "--- Cleaning Build Directory ---"
    if (Test-Path $BuildDir) {
        Remove-Item -Recurse -Force $BuildDir
    }
}

function Invoke-Flash {
    Write-Host "--- Flashing Firmware ---"
    $hexFile = Join-Path -Path $BuildDir -ChildPath "$($ProjectName).hex"
    if (-not (Test-Path $hexFile)) {
        Write-Error "Hex file not found. Please build the project first."
        return
    }
    teensy_loader_cli.exe -v -w --mcu=$Mcu $hexFile
}

function Invoke-Submodules {
    Write-Host "--- Updating Git Submodules ---"
    git submodule update --init --recursive
}

# --- Main Logic ---
if ($build) {
    Invoke-Build
}
elseif ($clean) {
    Invoke-Clean
}
elseif ($flash) {
    Invoke-Flash
}
elseif ($submodules) {
    Invoke-Submodules
}
else {
    Get-Help $MyInvocation.MyCommand.Definition -Full
}
