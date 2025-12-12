#Requires -Version 5.1

param (
    [Parameter(Mandatory = $true)] [string]$CarpetaObjetivo,
    [switch]$RenombradoInteligente,
    [switch]$Simulacion # DryRun
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Iniciando analisis de contenido en: $CarpetaObjetivo" -ForegroundColor Cyan

if (-not (Test-Path $CarpetaObjetivo)) {
    Write-Host "Carpeta no encontrada." -ForegroundColor Red
    exit 1
}

$archivos = Get-ChildItem -Path $CarpetaObjetivo -File

foreach ($archivo in $archivos) {
    $nuevoNombre = $archivo.Name
    
    # Logica 1: Fecha dd-mm-aaaa
    # Si el archivo ya tiene fecha, intentamos normalizarla. Si no, usamos la fecha de creacion.
    $fechaCreacion = $archivo.CreationTime.ToString("dd-mm-yyyy")
    
    # Logica 2: Renombrado Inteligente (Lectura de contenido basica para texto/pdf simulado)
    if ($RenombradoInteligente) {
        # Aqui iria la logica compleja de leer PDFs. Por ahora, simulamos leyendo archivos de texto
        if ($archivo.Extension -eq ".txt" -or $archivo.Extension -eq ".md") {
            try {
                $contenido = Get-Content -Path $archivo.FullName -TotalCount 5 -ErrorAction SilentlyContinue
                if ($contenido) {
                    # Heuristica simple: Usar la primera linea si parece un titulo
                    $posibleTitulo = $contenido[0] -replace '[^a-zA-Z0-9]', '_'
                    if ($posibleTitulo.Length -gt 3 -and $posibleTitulo.Length -lt 50) {
                        $nuevoNombre = "${fechaCreacion}_${posibleTitulo}$($archivo.Extension)"
                    }
                }
            }
            catch {}
        }
    }
    else {
        # Modo Estricto: Solo fecha + nombre original limpio
        $nombreLimpio = $archivo.Name -replace '[^a-zA-Z0-9\.]', '_'
        $nuevoNombre = "${fechaCreacion}_${nombreLimpio}"
    }

    # Aplicar cambio
    if ($nuevoNombre -ne $archivo.Name) {
        $rutaDestino = Join-Path $archivo.DirectoryName $nuevoNombre
        if ($Simulacion) {
            Write-Host "[Simulacion] Renombrar: $($archivo.Name) -> $nuevoNombre" -ForegroundColor Yellow
        }
        else {
            Rename-Item -Path $archivo.FullName -NewName $nuevoNombre -ErrorAction SilentlyContinue
            Write-Host "Renombrado: $($archivo.Name) -> $nuevoNombre" -ForegroundColor Green
        }
    }
}
