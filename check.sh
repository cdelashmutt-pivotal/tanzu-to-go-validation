#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "✅ 🍎 MacOS Detected"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then 
  echo "✅ 🐧 Linux Detected"
else
  echo "❌ ?? Unknown OS"
fi

DOCKER_INFO="$(docker info 2>/dev/null)"
DOCKER_STATUS=$?
DOCKER_SERVER_VERSION=""
if [ $DOCKER_STATUS -ne 0 ]; then
  echo "❌ Error when calling 'docker info'. Is Docker CLI installed?"
  echo "$DOCKER_INFO"
else
  DOCKER_SERVER_VERSION="$( echo "$DOCKER_INFO" | grep -e "Server Version" | xargs | cut -d' ' -f 3)"
  echo "✅ Call to 'docker info' successful."
fi

BREW_VERSION=$(brew -v | head -n 1 | xargs | cut -d' ' -f 2)
BREW_DETECT=$?
if [ $BREW_DETECT -ne 0 ]; then
  echo "❌ Problem detecting brew.  Check to see if it is installed."
else
  echo "✅ Brew install detected."
fi

GIT_VERSION=$(git --version | xargs | cut -d' ' -f 3)
GIT_DETECT=$?
if [ $GIT_DETECT -ne 0 ]; then
  echo "❌ Problem detecting git.  Check to see if it is installed."
else
  echo "✅ Git install detected."
fi

(printf "OS DOCKER BREW GIT\n$OSTYPE $DOCKER_SERVER_VERSION $BREW_VERSION $GIT_VERSION\n") | column -t