#!/usr/bin/env bash
set -e

if [ "$1" = 'test' ]; then

    pipenv run pytest

elif [ "$1" = 'es-test' ]; then

    pipenv run python app.py \
        --bundle-dir "$MODELS_DIR/es-en/1/tune/model" \
        --source-lang es \
        --target-lang en\
        --port 8001 &

else
    exec "$@"
fi
