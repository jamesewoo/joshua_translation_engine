FROM jwoo11/drogon:runtime AS server

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV NLTK_DATA /usr/local/share/nltk_data

WORKDIR "$HOME/joshua_server"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
        python-pip && \
    pip install pipenv

COPY Pipfile* ./

RUN pipenv install -d && \
    pipenv run \
        python -m nltk.downloader -d $NLTK_DATA all

COPY *.py entrypoint.sh README.md ./
COPY html html
COPY test test


FROM server AS server-test

EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]

CMD ["pytest"]
