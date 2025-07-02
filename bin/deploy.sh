#!/bin/bash

# Script de despliegue para contenedor Docker SENA
set -e  # Sale inmediatamente si cualquier comando falla

# Configuración
PROJECT_DIR="/opt/sena"
CONTAINER_NAME="sena"
IMAGE_NAME="sena"
PORT_MAPPING="3001:3000"

# Función para limpiar en caso de error
cleanup() {
  echo "Error durante el despliegue. Realizando limpieza..."
  # Intenta detener y remover el contenedor si existe
  if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    docker stop "$CONTAINER_NAME" || true
    docker rm "$CONTAINER_NAME" || true
  fi
  exit 1
}

# Registrar el manejador de errores
trap cleanup ERR

echo "Iniciando proceso de despliegue..."

# 1. Cambiar al directorio del proyecto
echo "Cambiando al directorio $PROJECT_DIR..."
cd "$PROJECT_DIR" || {
  echo "Error: No se pudo cambiar al directorio $PROJECT_DIR"
  exit 1
}

# 2. Detener el contenedor si está en ejecución
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Deteniendo contenedor existente..."
  docker stop "$CONTAINER_NAME"
fi

# 3. Eliminar el contenedor si existe
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Eliminando contenedor existente..."
  docker rm "$CONTAINER_NAME"
fi

echo "Pulling desde github"
git pull

# 4. Construir la nueva imagen
echo "Construyendo nueva imagen Docker..."
docker build -t "$IMAGE_NAME" .

# 5. Ejecutar el contenedor
echo "Iniciando nuevo contenedor..."
docker run -d -p "$PORT_MAPPING" --name "$CONTAINER_NAME" "$IMAGE_NAME"

# Verificación final
sleep 2  # Espera breve para que el contenedor se inicie
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Despliegue completado con éxito!"
  echo "El contenedor ${CONTAINER_NAME} está en ejecución y escuchando en el puerto ${PORT_MAPPING}"
else
  echo "Error: El contenedor no se inició correctamente"
  exit 1
fi

exit 0