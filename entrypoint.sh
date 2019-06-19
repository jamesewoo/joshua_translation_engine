#!/usr/bin/env bash
set -e

if [ "$1" = 'pytest' ]; then

    pipenv run pytest

elif [ "$1" = 'es-test' ]; then

    pipenv run python app.py \
        --bundle-dir "$MODELS_DIR/es-en/1/tune/model" \
        --source-lang es \
        --target-lang en\
        --port 8001 &

    sleep 2
    curl http://localhost:5000/translate/english -iv -H "Content-Type: application/json" -X POST -d '{"inputLanguage": "Spanish", "inputText": "vuelo"}'

elif [ "$1" = 'deploy' ]; then

    pipenv run gunicorn -b "0.0.0.0:8000" --forwarded-allow-ips="*" "app:create_app()"

else
    exec "$@"
fi
