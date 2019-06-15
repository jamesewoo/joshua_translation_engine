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

    until curl http://localhost:5000; do
        sleep 2
    done

    curl http://localhost:5000/joshua/translate/english \
        -H "Content-Type: application/json" \
        -X POST -d '{"inputLanguage": "Spanish", "inputText": "vuelo"}'

else
    exec "$@"
fi
