
include:
{%- if pillar.mayan.server is defined %}
- mayan.server
{%- endif %}
{%- if pillar.mayan.api is defined %}
- mayan.api
{%- endif %}
