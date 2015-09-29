testfile:
  file.managed:
    - name: /tmp/websame.txt
    - source: salt://test/websame.txt
    - template: jinja
