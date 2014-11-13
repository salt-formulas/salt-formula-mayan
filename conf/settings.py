{% from "mayan/map.jinja" import server with context %}
{% from "mayan/map.jinja" import api with context %}

from __future__ import absolute_import

from mayan.settings import *


# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'om^a(i8^6&h+umbd2%pt91cj!qu_@oztw117rgxmn(n2lp^*c!'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

ALLOWED_HOSTS = []

{%- if server.api is defined and api.enabled %}
INSTALLED_APPS +=('pyro_api',)
{%- endif %}

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ server.database.name }}',
        'USER': '{{ server.database.user }}',
        'PASSWORD': '{{ server.database.password }}',
        'HOST': '{{ server.database.host }}',
        'PORT': '{{ server.database.port }}',
    }
}

# Internationalization
# https://docs.djangoproject.com/en/1.6/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True

PROJECT_TITLE = 'Mayan EDMS'
PROJECT_NAME = 'mayan'

MEDIA_ROOT = "/srv/jachym/media" #document_storage

MAIN_DISABLE_HOME_VIEW = True

{%- if server.storage_location is defined %}
STORAGE_FILESTORAGE_LOCATION = "{{ server.storage_location }}" #"/srv/documents"
{%- endif %}

"""
# Supposing the 'Sample index' internal name is 'sample_index'
DOCUMENT_INDEXING_FILESYSTEM_SERVING = {
  'sample_index': '/srv/samba/tnsjachym/',
}
"""
