FROM python:3.6-buster
LABEL maintainer="Florentin-Eduard Decu"
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_FILE=replaceprojectname.settings.py
ENV PROJECT_DIR /project
ENV GUNICORN_PORT=8888

WORKDIR ${PROJECT_DIR}/

COPY ./src/Pipfile /${PROJECT_DIR}/
COPY ./src/Pipfile.lock /${PROJECT_DIR}/

RUN apt-get update && apt-get -y dist-upgrade \
    && apt-get -y install build-essential libssl-dev libffi-dev libblas3 libc6 liblapack3 gcc python3-dev python3-pip cython3 \
    && apt-get -y install python3-numpy python3-scipy \
    && apt install -y netcat \
    && pip install pipenv \
    && pipenv install --system --deploy

# RUN groupadd django
RUN useradd django \
    && usermod -a -G django django \
    && mkdir /shared \
    && chown -R django:django /shared \
    && chmod 755 /shared 

VOLUME /shared

COPY ./docker/django/entrypoint.sh /entrypoint.sh

COPY ./src .

RUN chown -R django:django .

EXPOSE $GUNICORN_PORT
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["start"]