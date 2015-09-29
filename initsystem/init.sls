init:
  file.managed:
    - name: /tmp/initsystem.sh
    - unless: test -e /tmp/initsystem.sh
    - mode: 755
    - source: salt://initsystem/initsystem.sh
  cmd.run:
    - cwd: /tmp
    - name: /bin/bash initsystem.sh

#delete_file:
#  cmd.run:
#    - cwd: /tmp
#    - name: rm -rf initsystem.sh
#    - require:
#      - cmd: init
