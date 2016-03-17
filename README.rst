=====
Mayan
=====

Document management without the headaches.

Automated OCR of documents, automatic categorization, flexible metadata, extensive access control, Mayan EDMS has all this to offers and many more features to help you tame your documents.

Sample pillar
-------------

.. code-block:: yaml

    mayan:
      server:
        enabled: true
        workers: 3
        bind:
          address: 0.0.0.0
          port: 9753
        source:
          type: git
            address: git@github.com:mayan-edms/mayan-edms.git
            rev: master
        database:
          engine: 'postgresql'
          host: 'localhost'
          port: 5672
          name: 'mayan'
          password: 'pass'
          user: 'mayan'
      api:
        enabled: true
        hmac_key: d2d00896183011e28eb950e5493b99d90
        uri_id: 1sadfasfg468h7j9g7j9h78gk6g54fg6f
        bind:
          port: 33333
          host: 0.0.0.0


Sample pillar with specific folder for documents
------------------------------------------------

.. code-block:: yaml

    mayan:
      server:
        enabled: true
        workers: 3
        storage_location: "/share"
        bind:
          address: 0.0.0.0
          port: 9753
        source:
          type: git
            address: git@github.com:mayan-edms/mayan-edms.git
            rev: master
        database:
          engine: 'postgresql'
          host: 'localhost'
          port: 5672
          name: 'mayan'
          password: 'pass'
          user: 'mayan'
      api:
        enabled: true
        hmac_key: d2d00896183011e28eb950e5493b99d90
        uri_id: 1sadfasfg468h7j9g7j9h78gk6g54fg6f
        bind:
          port: 33333
          host: 0.0.0.0

Read more
---------

* http://www.mayan-edms.com/
* http://openode.readthedocs.org/
* https://github.com/openode/mayan_pyro_api
* http://mayan.readthedocs.org/en/latest/intro/installation.html
* https://openode.readthedocs.org/en/latest/install_mayan_server.html