# 05 - Go

Instala Go utilizando el tarball oficial publicado por el equipo de Go.

## Objetivos

- Instalar la versión definida en `user.conf`.
- Configurar el entorno de desarrollo.
- Configurar `GOROOT`, `GOPATH` y `PATH`.
- Verificar la instalación.

---

## Scripts

### 01-install.sh

Instala Go desde el sitio oficial.

```bash
./01-install.sh
```

### 02-post-install.sh

Configura las variables de entorno del usuario.

```bash
./02-post-install.sh
```

---

## Variables necesarias

Agregar en `user.conf`:

```ini
GO_VERSION="1.26.6"
GO_ARCH="linux-amd64"
```

---

## Verificación

Después de ejecutar ambos scripts:

```bash
go version
go env
```

El comando `go version` debe mostrar la versión instalada.