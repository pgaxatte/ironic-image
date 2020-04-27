#!/usr/bin/bash

. /bin/configure-ironic.sh

exec /usr/local/bin/ironic-api --config-file /etc/ironic/ironic.conf
