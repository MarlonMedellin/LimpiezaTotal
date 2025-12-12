#Requires -Version 5.1

param (
    [Parameter(Mandatory = $true)] [string]$CarpetaObjetivo
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Generando lista de limpieza segura para: $CarpetaObjetivo" -ForegroundColor Cyan

if (-not (Test-Path $CarpetaObjetivo)) {
    Write-Host "Carpeta no encontrada." -ForegroundColor Red
    exit 1
}

$archivoSalida = Join-Path $CarpetaObjetivo "candidatos_a_borrar.txt"
$lista = @()

# Criterios de limpieza (Basura comun)
$extensionesBasura = @(".tmp", ".log", ".bak", ".old")
$extensionesInstaladores = @(".exe", ".msi")

$archivos = Get-ChildItem -Path $CarpetaObjetivo -File

foreach ($archivo in $archivos) {
    $razon = ""
    
    # 1. Archivos temporales
    if ($extensionesBasura -contains $archivo.Extension.ToLower()) {
        $razon = "Archivo temporal o de log"
    }
    
    # 2. Instaladores viejos (> 30 dias)
    if ($extensionesInstaladores -contains $archivo.Extension.ToLower()) {
        if ($archivo.CreationTime -lt (Get-Date).AddDays(-30)) {
            $razon = "Instalador antiguo (> 30 dias)"
        }
    }

    # 3. Archivos muy viejos en Descargas (> 1 año)
    if ($archivo.CreationTime -lt (Get-Date).AddDays(-365)) {
        if (-not $razon) { $razon = "Archivo muy antiguo (> 1 año)" }
    }

    if ($razon) {
        $linea = "$($archivo.FullName) | Motivo: $razon | Tamaño: $([math]::Round($archivo.Length / 1MB, 2)) MB"
        $lista += $linea
        Write-Host "Candidato: $($archivo.Name) ($razon)" -ForegroundColor Yellow
    }
}

if ($lista.Count -gt 0) {
    $lista | Out-File $archivoSalida -Encoding UTF8
    Write-Host "`nLista generada en: $archivoSalida" -ForegroundColor Green
    Write-Host "REVISA ESTE ARCHIVO ANTES DE BORRAR NADA." -ForegroundColor Red
}
else {
    Write-Host "`nNo se encontraron archivos candidatos para borrar." -ForegroundColor Green
}
