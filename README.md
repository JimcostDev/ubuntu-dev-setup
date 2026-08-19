# Ubuntu Dev Setup

Configuración automatizada de un entorno de desarrollo sobre Ubuntu.

Este proyecto contiene scripts independientes para preparar un sistema Ubuntu desde cero con las herramientas, configuraciones y aplicaciones utilizadas para desarrollo de software.

La filosofía del proyecto es mantener el sistema:

- Reproducible
- Automatizado
- Modular
- Fácil de mantener
- Fácil de ejecutar nuevamente
- Sin configuraciones innecesarias

## Objetivo

El objetivo es poder instalar y configurar rápidamente un entorno de desarrollo completo después de una instalación limpia de Ubuntu.

En lugar de ejecutar manualmente decenas de comandos, cada área del sistema está organizada en su propio módulo.

Cada módulo tiene una responsabilidad concreta y puede ejecutarse de forma independiente.

## Filosofía

El proyecto sigue algunas reglas:

1. Automatizar todo lo que sea razonablemente automatizable.
2. Evitar configuraciones innecesarias.
3. Utilizar paquetes oficiales de Ubuntu siempre que sea posible.
4. Mantener los scripts independientes.
5. Evitar duplicar configuraciones.
6. Hacer los scripts idempotentes cuando sea posible.
7. Comprobar las instalaciones antes de modificar el sistema.
8. Verificar el resultado después de cada módulo.
9. Mantener las configuraciones específicas del equipo separadas de la lógica.
10. No instalar software solamente porque exista una alternativa más avanzada.

## Estructura

La estructura general del proyecto está organizada por módulos.

    ubuntu-dev-setup/
    ├── .editorconfig
    ├── .gitignore
    ├── README.md
    ├── bootstrap.sh
    ├── install.sh
    ├── user.conf
    ├── lib/
    │   └── utils.sh
    ├── 01-system/
    ├── 02-git/
    ├── 03-vscode/
    ├── 04-docker/
    ├── 05-go/
    ├── 06-python/
    ├── 07-node/
    ├── 08-flutter/
    ├── 09-mongodb-compass/
    ├── 10-insomnia/
    ├── 11-antigravity/
    ├── 12-obs/
    └── 13-gnome/

La numeración representa el orden lógico de preparación del sistema.

## Lib

El directorio lib contiene funciones reutilizables utilizadas por los diferentes scripts.

    lib/
    └── utils.sh

Entre otras funciones proporciona:

- Mensajes informativos
- Mensajes de éxito
- Advertencias
- Errores
- Separadores de pasos
- Comprobación de comandos
- Carga de configuración

Los módulos reutilizan estas funciones en lugar de implementar su propio sistema de salida.

## Configuración

Las configuraciones específicas del sistema se mantienen separadas de la lógica de los scripts.

Esto permite cambiar valores como:

- Nombre de usuario
- Nombre de Git
- Correo electrónico
- Rutas
- Discos
- Directorios
- Preferencias específicas

sin modificar todos los scripts.

Ejemplo de `user.conf`:

```ini
GIT_NAME="Nombre"
GIT_EMAIL="correo@ejemplo.com"
GO_VERSION="1.26.6"
NODE_VERSION="lts/*"
# ... otras variables
```

## Variables de entorno

Además de la configuración almacenada en `user.conf`, algunos proyectos de desarrollo utilizan variables de entorno globales.

Actualmente deben existir las siguientes variables:

- `MONGO_URI`
- `JWT_SECRET_KEY`

Estas variables se configuran de forma persistente para el usuario en:

    ~/.profile

### Configuración

Después de instalar y configurar el sistema, abrir `~/.profile` desde VS Code:

    code ~/.profile

Añadir al final del archivo:

```bash
# JimcostDev development environment
export MONGO_URI="mongodb+srv://<user>:<password>@<cluster>/<database>"
export JWT_SECRET_KEY="<secret>"
```

Los valores anteriores son únicamente ejemplos.

Deben sustituirse por los valores reales utilizados por los proyectos.

Después de guardar el archivo, cargar nuevamente la configuración:

```bash
source ~/.profile
```

### Verificación

Comprobar que las variables existen:

```bash
printenv MONGO_URI
printenv JWT_SECRET_KEY
```

También se puede comprobar:

```bash
echo "$MONGO_URI"
echo "$JWT_SECRET_KEY"
```

Si las variables aparecen correctamente, estarán disponibles para los procesos iniciados por el usuario.

### Importante después de reinstalar Ubuntu

Si se reinstala Ubuntu desde cero, recordar volver a crear estas dos variables en:

    ~/.profile

Crear:

    MONGO_URI
    JWT_SECRET_KEY

Estas variables no forman parte de `user.conf` porque contienen información sensible.

### Seguridad

Los valores reales nunca deben almacenarse en este repositorio.

No incluir valores reales de estas variables en:

- `README.md`
- `user.conf`
- Scripts
- Commits
- Issues
- Capturas de pantalla
- Archivos públicos

Nunca subir contraseñas, tokens, claves privadas o secretos a Git.

## Módulos

### System

Preparación básica del sistema Ubuntu.

Incluye tareas relacionadas con:

- Actualizaciones
- Paquetes básicos
- Limpieza del sistema
- Herramientas necesarias para desarrollo

### Git

Configuración de Git.

Incluye:

- Nombre de usuario
- Correo electrónico
- Rama principal
- Editor
- Configuración básica

### SSH

Configuración de claves SSH para servicios como GitHub.

El script comprueba si existe una clave antes de generar una nueva.

### Docker

Instalación y configuración de Docker para desarrollo.

### OBS

Configuración de OBS Studio.

Incluye:

- Instalación de OBS Studio
- Restauración de configuración
- Perfil de OBS
- Colección de escenas
- Assets
- Cámara
- NVENC
- Rutas adaptadas al sistema
- Eliminación de credenciales heredadas

La configuración está adaptada al hardware del AORUS.

El encoder utilizado es NVIDIA NVENC.

### GNOME

Configuración básica del entorno GNOME.

Incluye los siguientes atajos:

| Atajo | Acción |
|---|---|
| Super + E | Archivos |
| Super + X | Power Menu |
| Super + T | Terminal |
| Ctrl + Shift + Esc | Monitor del sistema |

Super + V no se modifica y mantiene el comportamiento original de GNOME.

No se instala ningún gestor externo de portapapeles.

## Ejecución individual

Cada módulo puede ejecutarse independientemente.

Por ejemplo:

    ./13-gnome/01-check-gnome.sh
    ./13-gnome/02-configure-keybindings.sh
    ./13-gnome/03-post-install.sh

Esto permite instalar, comprobar o volver a ejecutar solamente una parte del setup.

## Verificación

Los módulos siguen una estructura basada en:

1. Verificación de requisitos.
2. Instalación o configuración.
3. Adaptación al sistema.
4. Validación final.

Esto permite detectar rápidamente qué parte del setup ha fallado.

## Idempotencia

Los scripts deben intentar ser idempotentes siempre que sea posible.

Ejecutar un script nuevamente no debería:

- Crear configuraciones duplicadas.
- Generar claves innecesarias.
- Sobrescribir configuraciones válidas sin necesidad.
- Instalar paquetes que ya están instalados.
- Duplicar atajos de teclado.

Por ejemplo, el módulo de GNOME comprueba los atajos existentes antes de crear nuevos.

## Seguridad

El proyecto evita almacenar credenciales directamente en el repositorio.

Las configuraciones restauradas desde otros equipos deben eliminar cualquier credencial heredada que pueda comprometer la seguridad del nuevo sistema.

En particular, la configuración restaurada de OBS elimina credenciales antiguas antes de utilizarla.

Nunca se deben incluir en Git:

- Contraseñas
- Tokens
- Claves privadas
- Credenciales de servicios
- Cookies
- Secrets
- Archivos personales

## Requisitos

El proyecto está diseñado principalmente para Ubuntu.

El sistema debe disponer de:

- Bash
- Git
- sudo
- apt
- herramientas básicas de GNU/Linux

Algunos módulos pueden requerir herramientas adicionales.

Los propios scripts deben comprobar sus dependencias antes de ejecutarse.

## Instalación completa

El proyecto está diseñado para poder ofrecer una instalación completa mediante un script principal.

La intención es disponer de:

    ./install.sh

Este script actuará únicamente como orquestador.

No contendrá la lógica de instalación de cada componente.

Su responsabilidad será:

1. Ejecutar los módulos en orden.
2. Detener la ejecución si un módulo crítico falla.
3. Mostrar el progreso.
4. Mostrar un resumen final.

Los módulos seguirán siendo ejecutables individualmente.

## Por qué existe install.sh

El proyecto tiene dos niveles de ejecución:

### Ejecución modular

Permite trabajar únicamente con una parte del sistema.

    ./13-gnome/02-configure-keybindings.sh

### Ejecución completa

Permite preparar un sistema desde cero.

    ./install.sh

Esto proporciona simplicidad para una instalación nueva sin sacrificar la modularidad del proyecto.

## Reinstalación

Los scripts están diseñados para poder ejecutarse nuevamente después de una reinstalación de Ubuntu.

El objetivo es que el sistema pueda volver a un estado de desarrollo funcional sin tener que recordar manualmente todos los pasos realizados anteriormente.

Después de una reinstalación también se deben recuperar las variables de entorno personales descritas en la sección `Variables de entorno`.

## Estado del proyecto

El setup actualmente incluye configuraciones para:

- Sistema Ubuntu
- Git y SSH
- Visual Studio Code
- Docker
- Go
- Python
- Node.js
- Flutter
- MongoDB Compass
- Insomnia
- Antigravity IDE y CLI
- OBS Studio
- GNOME y Atajos de teclado
- Configuraciones específicas del AORUS

El proyecto continúa evolucionando a medida que se incorporan nuevas herramientas al entorno de desarrollo.

## Principios

Este proyecto no pretende instalar absolutamente todo.

Pretende instalar y configurar solamente lo que realmente se necesita.

Menos software innecesario significa:

- Menos mantenimiento
- Menos dependencias
- Menos superficie de ataque
- Menos configuraciones que mantener
- Un sistema más limpio

La prioridad es tener un entorno de desarrollo reproducible, estable y fácil de reconstruir.
