{% from "mayan/map.jinja" import server with context %}

{%- if server.enabled %}

include:
- git

mayan_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

{{ server.dir.base }}:
  virtualenv.manage:
  - system_site_packages: False
  - requirements: salt://mayan/files/requirements.txt
  - require:
    - pkg: mayan_packages
    - pkg: git_packages

mayan_user:
  user.present:
  - name: mayan
  - system: True
  - shell: /bin/sh
  - home: {{ server.dir.base }}
  - require:
    - virtualenv: {{ server.dir.base }}

mayan_dirs:
  file.directory:
  - names:
    - {{ server.dir.base }}/static
    - {{ server.dir.base }}/media
    - /var/log/mayan-edms
    - {{ server.dir.base }}/site
    - {{ server.dir.base }}/media/document_storage
    - {{ server.dir.base }}/media/document_storage/document_storage
    - {{ server.dir.base }}/media/document_storage/image_cache
    - {{ server.dir.base }}/media/document_storage/gpg_home
    - {{ server.dir.base }}/media/gpg_home
    {%- if server.storage_location is defined %}
    - {{ server.storage_location }}
    {%- endif %}
    - {{ server.dir.base }}/site
  - user: mayan
  - group: mayan
  - makedirs: true
  - require:
    - virtualenv:  {{ server.dir.base }}

{{ server.source.address }}:
  git.latest:
  - target: {{ server.dir.base }}/app
  - branch: {{ server.source.revision }}
  - require:
    - virtualenv: {{ server.dir.base }}
    - pkg: git_packages
  - require_in:
    - file: mayan_dirs

{{ server.dir.base }}/bin/gunicorn_start:
  file.managed:
  - source: salt://mayan/files/gunicorn_start
  - mode: 700
  - user: mayan
  - group: mayan
  - template: jinja
  - require:
    - virtualenv: {{ server.dir.base }}

{{ server.dir.base }}/site/manage.py:
  file.managed:
  - source: salt://mayan/files/manage.py
  - template: jinja
  - mode: 755
  - require:
    - git: {{ server.source.address }}
    - file: mayan_dirs

{{ server.dir.base }}/site/local_settings.py:
  file.managed:
  - source: salt://mayan/files/settings.py
  - template: jinja
  - mode: 644
  - require:
    - file: {{ server.dir.base }}/site/manage.py

{{ server.dir.base }}/site/wsgi.py:
  file.managed:
  - source: salt://mayan/files/server.wsgi
  - template: jinja
  - mode: 644
  - require:
    - file: {{ server.dir.base }}/site/local_settings.py

mayan_sync_database:
  cmd.run:
  - name: source {{ server.dir.base }}/bin/activate; python manage.py migrate --noinput
  - cwd: {{ server.dir.base }}/site

mayan_migrate_database:
  cmd.run:
  - name: source {{ server.dir.base }}/bin/activate; python manage.py migrate
  - cwd: {{ server.dir.base }}/site
  - require:
    - cmd: mayan_sync_database

mayan_collect_static:
  cmd.run:
  - name: source {{ server.dir.base }}/bin/activate; python manage.py collectstatic --noinput && chown mayan:mayan {{ server.dir.base }} -R
  - cwd: {{ server.dir.base }}/site
  - require:
    - cmd: mayan_migrate_database
    - file: {{ server.dir.base }}/static

mayan_web_service:
  supervisord.running:
  - names:
    - mayan_server
  - restart: True
  - user: root

{%- endif %}