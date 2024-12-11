#!/bin/bash

# Çıkışta hata olduğunda script duracak
set -e

# Komut satırından parametre kontrolü
if [ "$#" -ne 2 ]; then
  echo "Hatalı kullanım! Doğru format: bash $0 <image_name> <dockerfile_path>"
  exit 1
fi

# Parametreler
IMAGE_NAME="$1"
DOCKERFILE_PATH="$2"

# Docker Hub'a giriş yap
echo "Lütfen Docker Hub kullanıcı adınızı ve şifrenizi girin:"
docker login

# Buildx kurulumunu kontrol et
if ! docker buildx version &>/dev/null; then
  echo "Docker buildx mevcut değil. Lütfen Docker'ın buildx desteğini aktif hale getirin."
  exit 1
fi

# Buildx builder'ı ayarla (varsayılan değilse yeni bir builder oluşturulabilir)
if ! docker buildx inspect builder &>/dev/null; then
  docker buildx create --use
fi

# Çoklu platform için Docker imajını build et ve pushla
echo "Docker imajı build ediliyor ve pushlanıyor..."
DOCKER_BUILDKIT=1 docker buildx build --platform linux/amd64,linux/arm64 --cache-to=type=local,dest=/tmp/.buildx-cache,mode=max --cache-from=type=local,src=/tmp/.buildx-cache -t "$IMAGE_NAME" --push "$DOCKERFILE_PATH"

if [ $? -eq 0 ]; then
  echo "İşlem tamamlandı. İmaj: $IMAGE_NAME"
else
  echo "Docker build işlemi sırasında bir hata oluştu. Lütfen girdilerinizi kontrol edin."
  exit 1
fi
