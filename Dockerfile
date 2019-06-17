FROM jwoo11/drogon:runtime AS server

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV NLTK_DATA /usr/local/share/nltk_data

WORKDIR "$HOME/drogon-server"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
        python-pip \
        gunicorn && \
    rm -rf /var/lib/apt/lists/*

COPY Pipfile* ./

RUN pip install pipenv && \
    pipenv install -d && \
    pipenv run \
        python -m nltk.downloader -d $NLTK_DATA all

COPY *.py entrypoint.sh README.md ./
COPY config/nginx.conf /etc/nginx/
COPY html html
COPY test test

EXPOSE 80

ENTRYPOINT ["./entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
