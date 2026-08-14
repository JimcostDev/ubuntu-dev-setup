# 07 - Node.js

Instala Node.js utilizando NVM (Node Version Manager).

## Objetivos

- Instalar NVM.
- Instalar la versión de Node definida en `user.conf`.
- Configurar npm.
- Configurar Corepack.
- Verificar la instalación.

---

## Scripts

### 01-install.sh

```bash
./01-install.sh
```

Instala NVM y Node.js.

### 02-post-install.sh

```bash
./02-post-install.sh
```

Verifica la instalación y habilita Corepack.

---

## Variables necesarias

Agregar en `user.conf`:

```ini
NODE_VERSION="lts/*"
```

---

## Verificación

```bash
node -v
npm -v
npx -v
corepack --version
```