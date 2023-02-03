FROM python:3.11-slim-buster AS build
WORKDIR /srv/misago

ENV PYTHONUNBUFFERED 1
ENV IN_MISAGO_DOCKER 1
ENV C_FORCE_ROOT 1

RUN apt-get update && apt-get install -y \
    vim \
    gcc \
    libffi-dev \
    libssl-dev \
    libpq-dev \
    libjpeg-dev\
    libopenjp2-7-dev\
    locales \
    cron \
    postgresql-client \
    gettext

COPY . /srv/misago

RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt

FROM python:3.11-slim-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq-dev libjpeg-dev

WORKDIR /srv/misago

COPY --from=build /srv/misago /srv/misago
COPY --from=build /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
COPY --from=build /usr/local/bin/ /usr/local/bin
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord
EXPOSE 8000
CMD /usr/local/bin/supervisord
