#!/usr/bin/env bash
set -e

if [ "$1" = 'pytest' ]; then

    pipenv run pytest

elif [ "$1" = 'es-test' ]; then

    pipenv run gunicorn -b "0.0.0.0:8000" --forwarded-allow-ips="*" "app:create_app()" &
    sleep 2
    curl localhost:8000/translate/english -iv -H "Content-Type: application/json" -X POST -d '{"inputLanguage": "Spanish", "inputText": "vuelo"}'

elif [ "$1" = 'deploy' ]; then

    exec pipenv run gunicorn -b "0.0.0.0:8000" --forwarded-allow-ips="*" "app:create_app()"

else
    exec "$@"
fi
