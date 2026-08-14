# 01 - Sistema Base

Este módulo prepara Ubuntu 24.04 LTS para convertirlo en una estación de trabajo orientada al desarrollo de software.

## Objetivos

- Actualizar completamente el sistema operativo.
- Instalar los paquetes esenciales para desarrollo.
- Limpiar paquetes y caché innecesarios.
- Dejar una base sólida antes de instalar cualquier herramienta adicional.

---

## Scripts

### 01-update.sh

Actualiza los repositorios de Ubuntu e instala todas las actualizaciones disponibles.

```bash
./01-update.sh
```

---

### 02-packages.sh

Instala las herramientas básicas necesarias para cualquier desarrollador.

Incluye:

- Git
- Curl
- Wget
- Build Essential
- Unzip
- Zip
- Certificados CA
- Software Properties Common
- APT Transport HTTPS
- GnuPG
- LSB Release
- Tree
- Htop
- Vim

```bash
./02-packages.sh
```

---

### 03-cleanup.sh

Elimina paquetes que ya no son necesarios y limpia la caché de APT.

```bash
./03-cleanup.sh
```

---

## Orden recomendado

Ejecutar los scripts en el siguiente orden:

```text
01-update.sh
02-packages.sh
03-cleanup.sh
```

---

## Requisitos

- Ubuntu 24.04 LTS
- Permisos de administrador (sudo)
- Conexión a Internet

---

## Resultado esperado

Al finalizar este módulo el sistema estará:

- Totalmente actualizado.
- Con las herramientas base instaladas.
- Libre de paquetes innecesarios.
- Preparado para instalar el resto del entorno de desarrollo.