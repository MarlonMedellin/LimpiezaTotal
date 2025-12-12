#Requires -Version 5.1

param (
    [Parameter(Mandatory = $true)] [string]$CarpetaObjetivo
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Analizando estructura sugerida para: $CarpetaObjetivo" -ForegroundColor Cyan

if (-not (Test-Path $CarpetaObjetivo)) {
    Write-Host "Carpeta no encontrada." -ForegroundColor Red
    exit 1
}

$archivos = Get-ChildItem -Path $CarpetaObjetivo -File -Recurse
$extensiones = @{}
$fechas = @{}

foreach ($archivo in $archivos) {
    # Agrupar por extension
    $ext = $archivo.Extension.ToLower()
    if (-not $extensiones.ContainsKey($ext)) { $extensiones[$ext] = 0 }
    $extensiones[$ext]++

    # Agrupar por año
    $año = $archivo.CreationTime.Year.ToString()
    if (-not $fechas.ContainsKey($año)) { $fechas[$año] = 0 }
    $fechas[$año]++
}

Write-Host "`n--- Sugerencias Basadas en Extension ---" -ForegroundColor Yellow
foreach ($ext in $extensiones.Keys) {
    if ($extensiones[$ext] -gt 5) {
        Write-Host "Tienes $($extensiones[$ext]) archivos '$ext'. Sugiero crear una carpeta 'Documentos_$ext'"
    }
}

Write-Host "`n--- Sugerencias Basadas en Fecha ---" -ForegroundColor Yellow
foreach ($año in $fechas.Keys) {
    if ($fechas[$año] -gt 10) {
        Write-Host "Tienes $($fechas[$año]) archivos del año $año. Sugiero crear una carpeta 'Archivo_$año'"
    }
}

# Generar JSON de sugerencia (simulado)
$sugerencia = @{
    "Sugerencia" = "Estructura Dinamica"
    "Carpetas"   = @()
}
# Logica simple para el ejemplo
if ($extensiones['.pdf'] -gt 0) { $sugerencia.Carpetas += "Documentos_PDF" }
if ($extensiones['.jpg'] -gt 0) { $sugerencia.Carpetas += "Multimedia_Fotos" }

$sugerencia | ConvertTo-Json | Out-File (Join-Path $CarpetaObjetivo "sugerencia_estructura.json") -Encoding UTF8
Write-Host "`nSugerencia guardada en 'sugerencia_estructura.json'" -ForegroundColor Green
