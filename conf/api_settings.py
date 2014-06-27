{% from "mayan/map.jinja" import api with context %}

# mayan server IP
SERVER_IP = "{{ api.get('bind', {'host':'0.0.0.0'}).host }}"

# SECRET key, random hash
HMAC_KEY = "{{ api.hmac_key }}"

# SECRET id, random hash
URI_ID = "{{ api.uri_id }}"

# mayan port, example.
URI_PORT = {{ api.get('bind', {'port':33333}).port }}