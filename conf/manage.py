#!/usr/bin/env python

import sys
import os

from os.path import join, dirname, abspath, normpath

path = '/srv/mayan'

sys.path.append(join(path, 'lib', 'python2.7', 'site-packages'))
sys.path.append(join(path, 'app'))
sys.path.append(join(path, 'site'))

from django.core.management import execute_from_command_line

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "mayan.settings")
    execute_from_command_line(sys.argv)
