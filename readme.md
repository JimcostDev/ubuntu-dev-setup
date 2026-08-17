# Ubuntu Dev Setup

Scripts personales para configurar y reconstruir mi entorno de desarrollo en Ubuntu.

El objetivo de este proyecto es automatizar la instalación y configuración de las herramientas que utilizo habitualmente para desarrollo de software, evitando tener que recordar o repetir manualmente todo el proceso cada vez que instalo Ubuntu en un equipo nuevo.

## ¿Qué configura?

El proyecto cubre principalmente:

- Sistema base y herramientas esenciales.
- Git y SSH.
- Visual Studio Code.
- Docker y Docker Compose.
- Go.
- Python.
- Node.js mediante NVM.
- Flutter y Dart.
- MongoDB Compass.
- Herramientas de creación de contenido.
- Aplicaciones y personalización de Ubuntu.

## Uso

El proyecto está pensado para uso personal.

Los scripts están organizados por módulos para poder ejecutar únicamente lo que necesite en cada instalación.

El punto de entrada general es:

```bash
./install.sh
```

## Configuración personal

Los valores específicos de mi entorno se mantienen en:

```bash
user.conf
```

## Filosofía

El proyecto busca que una instalación limpia de Ubuntu pueda convertirse rápidamente en mi entorno habitual de desarrollo de forma reproducible, sencilla y mantenible.

No pretende ser un instalador universal para cualquier usuario.
