FROM python:3.9-alpine

RUN apk add --update gcc python3-dev libffi-dev musl-dev expect
RUN pip install --no-cache-dir \
    devpi-server==5.5.1 devpi-client==5.2.2 ruamel.yaml==0.17.9

ENV DEVPISERVER_SERVERDIR=/srv/devpi

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
