{% from "mayan/map.jinja" import server with context %}

{%- if pillar.mayan.server.enabled %}

include:
- git

mayan_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/srv/mayan:
  virtualenv.manage:
  - system_site_packages: True
  - requirements: salt://mayan/conf/requirements.txt
  - require:
    - pkg: mayan_packages
    - pkg: git_packages

mayan_user:
  user.present:
  - name: mayan
  - system: True
  - shell: /bin/sh
  - home: /srv/mayan
  - require:
    - virtualenv: /srv/mayan

mayan_dirs:
  file.directory:
  - names:
    - /srv/mayan/static
    - /srv/mayan/media
    - /srv/mayan/logs
  - user: mayan
  - group: mayan
  - mode: 777
  - makedirs: true
  - require:
    - virtualenv: /srv/mayan

/srv/mayan/logs/mayan.log:
  file.managed:
  - template: jinja
  - user: mayan
  - group: mayan
  - mode: 755
  - require:
    - file: mayan_dirs

{{ pillar.mayan.server.source.address }}:
  git.latest:
  - target: /srv/mayan/site
  - rev: {{ pillar.mayan.server.source.rev }}
  - require:
    - virtualenv: /srv/mayan
    - pkg: git_packages

/srv/mayan/bin/gunicorn_start:
  file.managed:
  - source: salt://mayan/conf/gunicorn_start
  - mode: 700
  - user: mayan
  - group: mayan
  - template: jinja
  - require:
    - virtualenv: /srv/mayan

/srv/mayan/site/manage.py:
  file.managed:
  - source: salt://mayan/conf/manage.py
  - template: jinja
  - mode: 755
  - require:
    - git: {{ pillar.mayan.server.source.address }}

/srv/mayan/site/mayan/settings.py:
  file.managed:
  - source: salt://mayan/conf/settings.py
  - template: jinja
  - mode: 644
  - require:
    - file: /srv/mayan/site/manage.py
{#    - file: /srv/mayan/site/wsgi.py#}

mayan_sync_database:
  cmd.run:
  - name: python manage.py syncdb --noinput
  - cwd: /srv/mayan/site
  - require:
    - file: /srv/mayan/site/mayan/settings.py

mayan_migrate_database:
  cmd.run:
  - name: python manage.py migrate
  - cwd: /srv/mayan/site
  - require:
    - cmd: mayan_sync_database

mayan_collect_static:
  cmd.run:
  - name: python manage.py collectstatic --noinput
  - cwd: /srv/mayan/site
  - require:
    - cmd: mayan_migrate_database
    - file: /srv/mayan/static
{#
mayan_services:
  supervisord.running:
  - names:
    - mayan_web
    - mayan_worker
  - restart: True
  - user: root
  - cwd: /srv/mayan/site
  - require:
    - cmd: mayan_migrate_database
#}
{%- endif %}