#Requires -Version 5.1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

param (
    [Parameter(Mandatory = $true)] [string]$CarpetaObjetivo,
    [ValidateSet("Fecha", "Extension")] [string]$Modo = "Fecha",
    [switch]$Simulacion # DryRun
)

Write-Host "Organizando carpeta: $CarpetaObjetivo (Modo: $Modo)" -ForegroundColor Cyan

if (-not (Test-Path $CarpetaObjetivo)) {
    Write-Host "Carpeta no encontrada." -ForegroundColor Red
    exit 1
}

$archivos = Get-ChildItem -Path $CarpetaObjetivo -File

foreach ($archivo in $archivos) {
    $nombreCarpeta = ""
    
    if ($Modo -eq "Fecha") {
        # Formato dd-mm-aaaa (Agrupacion por Mes-Año para no crear demasiadas carpetas)
        # Ejemplo: 12-2023
        $nombreCarpeta = $archivo.CreationTime.ToString("MM-yyyy")
    }
    elseif ($Modo -eq "Extension") {
        $ext = $archivo.Extension.TrimStart('.').ToUpper()
        if ([string]::IsNullOrWhiteSpace($ext)) { $ext = "SIN_EXT" }
        $nombreCarpeta = $ext
    }

    if ($nombreCarpeta) {
        $rutaDestino = Join-Path $CarpetaObjetivo $nombreCarpeta
        if (-not (Test-Path $rutaDestino)) {
            if ($Simulacion) {
                Write-Host "[Simulacion] Crear carpeta: $rutaDestino" -ForegroundColor Yellow
            }
            else {
                New-Item -ItemType Directory -Path $rutaDestino | Out-Null
            }
        }

        $archivoDestino = Join-Path $rutaDestino $archivo.Name
        if ($Simulacion) {
            Write-Host "[Simulacion] Mover: $($archivo.Name) -> $nombreCarpeta" -ForegroundColor Yellow
        }
        else {
            Move-Item -Path $archivo.FullName -Destination $archivoDestino -Force
            Write-Host "Movido: $($archivo.Name) -> $nombreCarpeta" -ForegroundColor Green
        }
    }
}
