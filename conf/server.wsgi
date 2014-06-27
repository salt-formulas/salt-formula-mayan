"""
WSGI config for mayan project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/1.6/howto/deployment/wsgi/
"""
import sys
import os

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "mayan.settings")
sys.path.append('/srv/mayan/app/mayan_pyro_api/pyro_api')

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()