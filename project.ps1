<#
.SYNOPSIS
    A helper script for managing the Macross-CAN firmware project.
#>
[CmdletBinding()]
param (
    [switch]$build,
    [switch]$clean,
    [switch]$flash,
    [switch]$submodules,
    [switch]$lint,
    [switch]$format
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

function Invoke-Lint {
    Write-Host "--- Linting with clang-tidy ---"
    if (-not (Test-Path $BuildDir)) {
        # We need to configure cmake first to create the build files
        Invoke-Build
    }
    
    Push-Location $BuildDir
    cmake --build . --target lint
    Pop-Location
}

function Invoke-Format {
    Write-Host "--- Formatting C/C++ Files ---"
    $files = Get-ChildItem -Path "src", "include" -Recurse -Include "*.c", "*.h"
    if ($null -eq $files) {
        Write-Host "No source files found to format."
        return
    }
    foreach ($file in $files) {
        Write-Host "Formatting $($file.FullName)..."
        clang-format.exe -i -style=file $file.FullName
    }
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
elseif ($lint) {
    Invoke-Lint
}
elseif ($format) {
    Invoke-Format
}
else {
    Get-Help $MyInvocation.MyCommand.Definition -Full
}
