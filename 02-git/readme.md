# 02 - Git

Este módulo configura Git para dejar preparado el entorno de desarrollo.

## Objetivos

- Configurar el nombre y correo de Git.
- Establecer Visual Studio Code como editor por defecto.
- Configurar `main` como rama predeterminada.
- Activar opciones recomendadas para desarrollo.
- Generar una clave SSH si no existe.
- Mostrar la clave pública para añadirla a GitHub.
- Verificar la conexión con GitHub.

---

## Scripts

### 01-config.sh

Configura Git con las opciones recomendadas.

```bash
./01-config.sh
```

---

### 02-ssh.sh

Genera una clave SSH (si no existe) y verifica la conexión con GitHub.

```bash
./02-ssh.sh
```

---

## Orden recomendado

```text
01-config.sh
02-ssh.sh
```

---

## Resultado esperado

Al finalizar este módulo:

- Git estará completamente configurado.
- Visual Studio Code será el editor predeterminado.
- La rama principal será `main`.
- La autenticación mediante SSH estará lista para GitHub.