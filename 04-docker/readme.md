# 04 - Docker

Instala Docker Engine utilizando el repositorio oficial de Docker.

## Objetivos

- Instalar Docker Engine.
- Instalar Docker CLI.
- Instalar Docker Compose.
- Configurar el usuario para ejecutar Docker sin sudo.
- Verificar la instalación.

---

## Scripts

### 01-install.sh

Instala Docker.

```bash
./01-install.sh
```

### 02-post-install.sh

Configura el grupo docker y verifica la instalación.

```bash
./02-post-install.sh
```

---

## Resultado esperado

Al finalizar:

- Docker Engine estará instalado.
- Docker Compose estará disponible.
- El usuario podrá ejecutar Docker sin `sudo` (tras volver a iniciar sesión).