# Ubuntu Dev Setup

> 🚀 Automatización completa de una estación de trabajo para desarrollo de software sobre Ubuntu 24.04 LTS.

---

## Objetivo

Este proyecto nace con un único propósito:

Poder instalar y configurar un entorno completo de desarrollo en un equipo nuevo mediante scripts reproducibles, documentados y fáciles de mantener.

Cada módulo tiene una única responsabilidad y puede ejecutarse de forma independiente o como parte de la instalación completa.

---

## Tecnologías incluidas

- Ubuntu 24.04 LTS
- Git
- Docker
- Go
- Python
- Node.js (NVM)
- Flutter
- Visual Studio Code
- GNOME
- Herramientas de productividad
- Aplicaciones de desarrollo

---

## Filosofía

Este proyecto sigue varios principios:

- Scripts pequeños y reutilizables.
- Una única responsabilidad por script.
- Configuración modular.
- Documentación de cada módulo.
- Automatización reproducible.
- Idempotencia siempre que sea posible.

---

## Estructura

```
ubuntu-dev-setup/

├── install.sh
├── lib/
│   └── utils.sh
│
├── 01-system/
├── 02-git/
├── 03-docker/
├── 04-go/
├── 05-node/
├── 06-python/
├── 07-flutter/
├── 08-vscode/
├── 09-gnome/
└── 10-apps/
```

---

## Instalación

Clonar el repositorio:

```bash
git clone git@github.com:JimcostDev/ubuntu-dev-setup.git
```

Entrar en el proyecto:

```bash
cd ubuntu-dev-setup
```

Dar permisos:

```bash
chmod +x install.sh
```

Ejecutar:

```bash
./install.sh
```

---

## Orden de los módulos

Los módulos se ejecutan automáticamente según su numeración.

```
01-system
02-git
03-docker
04-go
05-node
06-python
07-flutter
08-vscode
09-gnome
10-apps
```

---

## Estado del proyecto

- ✅ Sistema Base
- 🚧 Git
- ⏳ Docker
- ⏳ Go
- ⏳ Node.js
- ⏳ Python
- ⏳ Flutter
- ⏳ VS Code
- ⏳ GNOME
- ⏳ Aplicaciones

---

