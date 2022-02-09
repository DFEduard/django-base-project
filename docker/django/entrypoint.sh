#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo 'Waiting for postgres....'

    while ! nc -zvw3 $POSTGRES_HOST $POSTGRES_PORT; do
        sleep 0.1
    done
    echo 'PostgreSQL started'
fi

case $1 in 
    start)

        python manage.py migrate --no-input
        python manage.py collectstatic --no-input
        # python manage.py migrate django_celery_results

        gunicorn replaceprojectname.wsgi:application  \
        --bind 0.0.0.0:8888 
    ;;
    celery)
        celery -A replaceprojectname worker -l INFO
    ;;
esac

exec "$@"
