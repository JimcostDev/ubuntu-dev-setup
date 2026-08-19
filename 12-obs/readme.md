# OBS Studio

Instala y configura OBS Studio en Ubuntu, restaurando la configuración de grabación y streaming utilizada anteriormente y adaptándola al hardware y rutas de la máquina actual.

## Estructura

### 01-install-obs.sh

Instala OBS Studio desde los repositorios de Ubuntu y comprueba que la instalación funciona.

### 02-restore-config.sh

Restaura la configuración principal de OBS desde el backup almacenado en el SSD de datos.

Durante la restauración:

- Crea un backup de la configuración actual antes de modificarla.
- Restaura el perfil `jimcostdev`.
- Restaura la colección de escenas `jimcostdevcode`.
- Adapta el encoder a NVIDIA NVENC.
- Adapta las rutas de los assets.
- Configura la cámara disponible en la máquina.
- Adapta las capturas de pantalla y ventanas mediante PipeWire.

### 03-post-install.sh

Comprueba que OBS quedó correctamente configurado después de la restauración.

Verifica:

- Instalación de OBS.
- Perfil.
- Colección de escenas.
- Assets.
- NVIDIA NVENC.
- Cámara.
- Micrófono.
- Captura de VS Code.
- Captura de pantalla completa.
- Captura de Chrome.
- Fuentes de prueba.
- Configuración de PipeWire.

## Backup

El backup completo de OBS no se almacena en Git.

La copia se encuentra en:

`/media/jimcostdev/data/OBS/obs-studio`

Los assets utilizados por las escenas se encuentran en:

`/media/jimcostdev/data/OBS`

Esta ubicación contiene recursos multimedia como máscaras, transiciones, vídeos y otros archivos utilizados por OBS.

El SSD de datos funciona como backup local. Los archivos multimedia pueden mantenerse además en una copia externa, como Google Drive.

## Configuración restaurada

Se conserva principalmente:

- Perfil `jimcostdev`.
- Colección de escenas `jimcostdevcode`.
- Configuración de grabación.
- Configuración de streaming.
- Encoder NVIDIA NVENC.
- Resolución y FPS configurados.
- Fuentes de cámara y micrófono.
- Capturas de VS Code.
- Captura de pantalla completa.
- Captura de Chrome.
- Transiciones.
- Assets.

Las configuraciones temporales, cachés y datos generados automáticamente por OBS no forman parte del backup necesario.

## Hardware actual

La configuración fue adaptada al AORUS actual.

**GPU:** NVIDIA GeForce RTX 3070 Ti Laptop GPU

**Encoder:** NVIDIA NVENC

**Cámara:** USB Camera mediante V4L2

**Dispositivo:** `/dev/video0`

**Captura de escritorio:** PipeWire

## Assets

Las escenas originalmente utilizaban rutas del equipo anterior, como:

`/home/jimcostdev/Documents/OBS/`

Durante la restauración estas rutas se adaptan a la nueva ubicación:

`/media/jimcostdev/data/OBS/`

De esta forma, el repositorio solamente contiene los scripts de instalación y restauración, mientras que los archivos multimedia permanecen fuera de Git.

## Notas

Los `RestoreToken` de las fuentes PipeWire pueden aparecer después de restaurar una colección creada en otra instalación.

Esto no se considera un error mientras OBS pueda recuperar correctamente las capturas.

La configuración fue comprobada en la máquina actual y funcionan correctamente:

- Cámara.
- Micrófono.
- Transiciones.
- VS Code.
- Captura de pantalla completa.
- Chrome.
- NVIDIA NVENC.
