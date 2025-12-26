#!/usr/bin/env pwsh

$maxthreads = [int]([math]::Max(1, [math]::Floor([Environment]::ProcessorCount)))

$models = @(
    "slimrect"
    "origrect"
    "cruciform"
    "cobblewall"
    "hengestone"
    "stalagmite"
    "log"
    "woodbeam"
    "slimbeam"
    "slimhengestone"
)

$variants = @(
    "end"
    "corner"
    "straight"
    "tee"
    "allways"
)


# Locate OpenSCAD
# Prefer openscad.com (CLI) over openscad.exe (GUI) for proper blocking/output
$openscad = Get-Command openscad.com -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source

if (-not $openscad) {
    $openscad = Get-Command openscad.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
    # If we found the exe, check if the com exists next to it
    if ($openscad -and (Test-Path ($openscad -replace '\.exe$', '.com'))) {
        $openscad = $openscad -replace '\.exe$', '.com'
    }
}

if (-not $openscad) {
    $possiblePaths = @(
        "C:\Program Files\OpenSCAD\openscad.com"
        "C:\Program Files (x86)\OpenSCAD\openscad.com"
        "$env:LOCALAPPDATA\Programs\OpenSCAD\openscad.com"
    )
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $openscad = $path
            break
        }
    }
}

if (-not $openscad) {
    # Fallback to exe if com not found (though unlikely)
    $possiblePathsExe = @(
        "C:\Program Files\OpenSCAD\openscad.exe"
        "C:\Program Files (x86)\OpenSCAD\openscad.exe"
        "$env:LOCALAPPDATA\Programs\OpenSCAD\openscad.exe"
    )
    foreach ($path in $possiblePathsExe) {
        if (Test-Path $path) {
            $openscad = $path
            break
        }
    }
}

if (-not $openscad) {
    Write-Error "OpenSCAD executable not found. Please install OpenSCAD or add it to your PATH."
    exit 1
}

Write-Host "Using OpenSCAD at: $openscad with max threads: $maxthreads"


$jobs =
    foreach ($model in $models) {
        foreach ($variant in $variants) {
            [pscustomobject]@{
                Model   = $model
                Variant = $variant
            }
        }
    }

$jobs | ForEach-Object -Parallel {
    $outFile = "built_stls\output_$($_.Model)_$($_.Variant).stl"
    Write-Host "Building $outFile..."

    & $using:openscad `
        -o $outFile `
        -D "model=""$($_.Model)""" `
        -D "variant=""$($_.Variant)""" `
        build.scad

} -ThrottleLimit $maxthreads
