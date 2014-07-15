{% from "mayan/map.jinja" import api with context %}

{%- if api.enabled %}

include:
- mayan.server

https://github.com/openode/mayan_pyro_api.git:
  git.latest:
  - target: /srv/mayan/app/mayan_pyro_api
  - require:
    - virtualenv: /srv/mayan
    - pkg: git_packages
  - require_in:
    - cmd: mayan_sync_database

/srv/mayan/app/mayan/apps/pyro_api:
  file.symlink:
    - target: /srv/mayan/app/mayan_pyro_api/pyro_api

/srv/mayan/app/mayan_pyro_api/pyro_api/settings_local.py:
  file.managed:
  - source: salt://mayan/conf/api_settings.py
  - template: jinja
  - mode: 644
  - require:
    - git: https://github.com/openode/mayan_pyro_api.git

/srv/mayan/app/mayan/wsgi.py:
  file.managed:
  - source: salt://mayan/conf/server.wsgi
  - template: jinja
  - mode: 644
  - require:
    - git: https://github.com/openode/mayan_pyro_api.git

mayan_api_service:
  supervisord.running:
  - names:
    - pyro_api
  - restart: True
  - user: root

{%- endif %}