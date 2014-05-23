#!/usr/bin/env bash
docker run -i -t -P -v ~/shared:/home/jboss/shared:rw jbossfuse:6.1.0base /home/jboss/startall.sh

