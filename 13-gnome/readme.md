# GNOME

Configuración básica de GNOME para Ubuntu.

Este módulo configura únicamente los componentes necesarios para trabajar con el entorno GNOME y añade los atajos de teclado personalizados utilizados en el sistema.

## Requisitos

- Ubuntu con GNOME
- GNOME Shell
- GNOME Settings
- Nautilus
- GNOME Terminal
- GNOME System Monitor

El setup está probado con:

- GNOME Shell 46.0

## Estructura

13-gnome/
├── 01-check-gnome.sh
├── 02-configure-keybindings.sh
└── 03-post-install.sh

## Scripts

### 01-check-gnome.sh

Comprueba que:

- GNOME está disponible.
- La versión de GNOME Shell está disponible.
- Nautilus está instalado.
- GNOME Terminal está instalado.
- GNOME System Monitor está instalado.
- gnome-session-quit está disponible.

No instala extensiones ni gestores adicionales.

### 02-configure-keybindings.sh

Configura los atajos personalizados de GNOME.

| Atajo | Acción |
|---|---|
| Super + E | Abrir Archivos |
| Super + X | Power Menu |
| Super + T | Abrir Terminal |
| Ctrl + Shift + Esc | Monitor del sistema |

El script comprueba si el atajo ya existe antes de crear uno nuevo.

Si una combinación ya está ocupada por otro atajo personalizado, actualiza esa configuración en lugar de crear entradas duplicadas.

### 03-post-install.sh

Realiza una comprobación final de:

- GNOME
- GNOME Shell
- Herramientas necesarias
- Atajos configurados

También muestra un resumen final de la configuración.

## Ejecución

Ejecutar los scripts en orden:

    ./13-gnome/01-check-gnome.sh
    ./13-gnome/02-configure-keybindings.sh
    ./13-gnome/03-post-install.sh

## Atajos

Después de ejecutar el setup:

    Super + E
        → Archivos

    Super + X
        → Power Menu

    Super + T
        → Terminal

    Ctrl + Shift + Esc
        → Monitor del sistema

### Super + V

No se modifica.

Se mantiene el comportamiento original de GNOME.

No se instala ningún gestor externo de portapapeles.

## Filosofía

Este módulo mantiene la configuración de GNOME lo más sencilla posible.

No añade:

- CopyQ
- Clipboard Indicator
- Extensiones innecesarias
- Gestores de portapapeles externos
- Configuraciones adicionales que no sean necesarias

La idea es utilizar las herramientas que Ubuntu y GNOME ya proporcionan y automatizar únicamente la configuración que realmente necesitamos.
