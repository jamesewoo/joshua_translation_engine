FROM jwoo11/drogon:runtime AS server

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV NLTK_DATA /usr/local/share/nltk_data

WORKDIR "$HOME/drogon-server"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
        python-pip \
        unzip && \
    rm -rf /var/lib/apt/lists/* && \
    curl -O https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt.zip && \
    unzip punkt.zip && \
    rm punkt.zip && \
    mkdir -p "$NLTK_DATA/tokenizers" && \
    mv punkt "$NLTK_DATA/tokenizers/punkt"

COPY Pipfile* ./

RUN pip install pipenv && \
    pipenv install -d

COPY *.py entrypoint.sh README.md ./
COPY html html
COPY test test

EXPOSE 8000

ENTRYPOINT ["./entrypoint.sh"]
CMD ["deploy"]
