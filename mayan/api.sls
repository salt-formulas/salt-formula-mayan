{% from "mayan/map.jinja" import api with context %}

{%- if api.enabled %}

include:
- mayan.server

git@repo1.robotice.cz:django/mayan-pyro-api.git:
  git.latest:
  - target: {{ api.dir.base }}/app/mayan_pyro_api
  - require:
    - virtualenv: {{ api.dir.base }}
    - pkg: git_packages
  - require_in:
    - cmd: mayan_sync_database
    - file: {{ api.dir.base }}/app/mayan_pyro_api/pyro_api/settings_local.py

{{ api.dir.base }}/app/mayan/apps/pyro_api:
  file.symlink:
    - target: {{ api.dir.base }}/app/mayan_pyro_api/pyro_api

{{ api.dir.base }}/app/mayan_pyro_api/pyro_api/settings_local.py:
  file.managed:
  - source: salt://mayan/files/api_settings.py
  - template: jinja
  - mode: 644

mayan_api_service:
  supervisord.running:
  - names:
    - pyro_api
  - restart: True
  - user: root

{%- endif %}