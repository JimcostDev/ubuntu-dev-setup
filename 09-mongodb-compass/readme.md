# 09 - MongoDB Compass

Instala MongoDB Compass en Ubuntu como cliente gráfico para trabajar
con MongoDB Atlas.

## Objetivo

Este módulo instala únicamente MongoDB Compass.

No instala MongoDB Community Server porque el entorno utiliza
MongoDB Atlas como servicio de base de datos.

## Requisitos

- Ubuntu 24.04 LTS
- Arquitectura x86_64
- Conexión a Internet

## Scripts

### 01-install.sh

Descarga e instala MongoDB Compass utilizando el paquete `.deb`
oficial de MongoDB.

```bash
./01-install.sh
./02-post-install.sh
mongodb-compass --version
```
