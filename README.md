# LimpiezaTotal (Edición Warp)

Bienvenido a **LimpiezaTotal**, tu asistente inteligente para mantener tu carpeta de Descargas (y otras) impecables en Windows 11.

Este proyecto está diseñado para ser usado **exclusivamente con Warp Terminal** mediante lenguaje natural.

## 🚀 Instalación Rápida

1. Asegúrate de tener [Warp Terminal](https://www.warp.dev/) instalado.
2. Copia los flujos de trabajo a tu carpeta de Warp:
   ```powershell
   Copy-Item -Path ".warp/workflows/*.yaml" -Destination "$HOME/.warp/workflows" -Force
   ```

## 🗣️ Cómo usar (Ejemplos de Prompts)

Abre Warp y simplemente escribe lo que quieres hacer. La IA de Warp (o la búsqueda de comandos `CMD+P`) reconocerá estas intenciones:

### 1. Organizar Descargas
> "Organiza mi carpeta de descargas por fecha"
> "Mueve mis archivos de descargas a carpetas por extensión"

### 2. Renombrado Inteligente
> "Renombra los PDFs de esta carpeta leyendo su contenido"
> *Nota: Esto intentará leer títulos dentro de los archivos para darles nombres como `12-12-2023_Factura_Luz.pdf`.*

### 3. Limpieza de Basura
> "Dame una lista de archivos basura para borrar en Descargas"
> *Nota: Esto NUNCA borra nada automáticamente. Genera un archivo `candidatos_a_borrar.txt` para que tú lo revises.*

### 4. Sugerencias
> "Analiza esta carpeta y sugiere cómo organizarla"

## ⚙️ Configuración
- Los scripts están en `scripts/` y usan PowerShell 5.1 (compatible con Windows 10/11 por defecto).
- Puedes ajustar las reglas editando los scripts directamente si eres usuario avanzado.

## 📅 Formato de Fecha
El sistema usa estrictamente el formato `dd-mm-aaaa` para carpetas y nombres de archivo.

---
Creado con ❤️ por tu Asistente de IA.
