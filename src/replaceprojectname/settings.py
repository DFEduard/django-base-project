from pathlib import Path
import environ
import os

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

env = environ.Env()

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = env.str('DJANGO_SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = env.str('DJANGO_DEBUG')

ALLOWED_HOSTS = env.str("DJANGO_ALLOWED_HOSTS", default="*")


# Application definition

APPS_DJANGO_DEFAULT = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    # 'app',
    # 'django_celery_results',
]

APPS_CREATED = [
    'app',
]

APPS_3RD_PARTY = [
    'django_celery_results',
]

INSTALLED_APPS = APPS_DJANGO_DEFAULT + APPS_3RD_PARTY + APPS_CREATED

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'replaceprojectname.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'replaceprojectname.wsgi.application'


# Database
# https://docs.djangoproject.com/en/3.1/ref/settings/#databases

# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.sqlite3',
#         'NAME': BASE_DIR / 'db.sqlite3',
#     }
# }

DATABASES = {
    "default" : {
        "ENGINE": env.str("DB_ENGINE", default="django.db.backends.sqlite3"),
        "NAME": env.str("POSTGRES_DB", os.path.join(BASE_DIR, "db.sqlite3")),
        "USER": env.str("POSTGRES_USER", "user"),
        "PASSWORD": env.str("POSTGRES_PASSWORD", "password"),
        "HOST": env.str("POSTGRES_HOST", "localhost"),
        "PORT": env.str("POSTGRES_PORT", "5432"),
    }
}


# Password validation
# https://docs.djangoproject.com/en/3.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/3.1/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.1/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, '/shared/static')


# MEDIA_ROOT = 'shared/uploads'

################## Cache settings ##############

REDIS_HOST = env.str('REDIS_HOST', default='redis')
REDIS_PORT = env.int('REDIS_PORT', default=6379)
REDIS_URL = "redis://{}:{}/0".format(REDIS_HOST, REDIS_PORT)


CACHES = {
    "default" : {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION":REDIS_URL,
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}
################## Celery settings #############

# CELERY_BROKER_URL = os.environ.get('CELERY_BROKER', REDIS_URL)
# CELERY_RESULT_BACKEND = os.environ.get('CELERY_BACKEND', REDIS_URL)

CELERY_BROKER_URL = env.str('CELERY_BROKER')
CELERY_RESULT_BACKEND = 'django-db'
# CELERY_RESULT_BACKEND = env.str('CELERY_BACKEND')
