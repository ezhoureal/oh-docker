# OpenHarmony Build Environment

Dockerfile for building OpenHarmony projects with a complete development environment.

## Image

The built image is available at:
- Docker Hub: `ezhoureal/openharmony-build`
- [View on Docker Hub](https://hub.docker.com/repository/docker/ezhoureal/openharmony-build/general)

## Usage

### 1. Pull the image

```bash
docker pull ezhoureal/openharmony-build
```

### 2. Run container with persistent volume

```bash
docker run -it -v <volume_name>:/home/oh ezhoureal/openharmony-build
```

Replace `<volume_name>` with your chosen volume name for persistent storage.

### 3. Inside the container: sync repository

```bash
cd /home/oh
repo sync -c <repository_name>
```

Example for graphic_graphic_2d:
```bash
repo sync -c graphic_graphic_2d
```

### 4. Download build dependencies

```bash
bash build/prebuilts_config.sh
```

### 5. Build

Basic build:
```bash
hb build -i
```

With compile_commands.json for clangd:
```bash
hb build -i --gn-flags=--export-compile-commands
```

Skip downloading for rebuilds:
```bash
hb build -i --skip-download
```

## Build Directory

The working directory is `/home/oh`, where the OpenHarmony build environment is initialized.
