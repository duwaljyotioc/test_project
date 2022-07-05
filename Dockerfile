FROM python:3.9-alpine

ENV PYTHONUNBUFFERED=1

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    ca-certificates gcc linux-headers musl-dev \
    libffi-dev jpeg-dev zlib-dev libc-dev python3-dev \
    postgresql-dev cargo

RUN pip install --upgrade pip

RUN addgroup test_project_group && adduser -D test_project_user -G test_project_group -h /home/test_project

ENV HOME /home/test_project

ENV APP_DIR ${HOME}

WORKDIR ${APP_DIR}

ADD requirements.txt ${APP_DIR}/

RUN pip install -r ${APP_DIR}/requirements.txt

COPY ./ ${APP_DIR}

#chown linuxuser:group3 sample3
RUN chown -R test_project_user:test_project_group ${APP_DIR}

USER test_project_user

EXPOSE 8000

ENTRYPOINT sh -c "python manage.py runserver 0.0.0.0:8000"
#CMD exec gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers 3