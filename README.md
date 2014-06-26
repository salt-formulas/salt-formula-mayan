# Mayan

Document management without the headaches.

Automated OCR of documents, automatic categorization, flexible metadata, extensive access control, Mayan EDMS has all this to offers and many more features to help you tame your documents.

## Sample pillar

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

## Read more

* http://www.mayan-edms.com/
* http://openode.readthedocs.org/
* https://github.com/openode/mayan_pyro_api
* http://mayan.readthedocs.org/en/latest/intro/installation.html