#!/usr/bin/bash

. /bin/ironic-common.sh

HTTP_PORT=${HTTP_PORT:-"80"}
MARIADB_PASSWORD=${MARIADB_PASSWORD:-"change_me"}
NUMPROC=$(cat /proc/cpuinfo  | grep "^processor" | wc -l)
NUMWORKERS=$(( NUMPROC < 12 ? NUMPROC : 12 ))

OVH_CONSUMER_KEY=${OVH_CONSUMER_KEY:-"change_me"}
OVH_APPLICATION_KEY=${OVH_APPLICATION_KEY:-"change_me"}
OVH_APPLICATION_SECRET=${OVH_APPLICATION_SECRET:-"change_me"}

# Whether to enable fast_track provisioning or not
IRONIC_FAST_TRACK=${IRONIC_FAST_TRACK:-true}

# Whether cleaning disks before and after deployment
IRONIC_AUTOMATED_CLEAN=${IRONIC_AUTOMATED_CLEAN:-true}

wait_for_interface_or_ip

cp /etc/ironic/ironic.conf /etc/ironic/ironic.conf_orig

crudini --merge /etc/ironic/ironic.conf <<EOF
[DEFAULT]
my_ip = $IRONIC_IP

[api]
host_ip = ::
api_workers = $NUMWORKERS

[conductor]
api_url = http://${IRONIC_URL_HOST}:6385
bootloader = http://${IRONIC_URL_HOST}:${HTTP_PORT}/uefi_esp.img
automated_clean = ${IRONIC_AUTOMATED_CLEAN}

[database]
connection = mysql+pymysql://ironic:${MARIADB_PASSWORD}@localhost/ironic?charset=utf8

[deploy]
http_url = http://${IRONIC_URL_HOST}:${HTTP_PORT}
fast_track = ${IRONIC_FAST_TRACK}

[inspector]
endpoint_override = http://${IRONIC_URL_HOST}:5050

[ovhapi]
consumer_key = '${OVH_CONSUMER_KEY}'
application_key = '${OVH_APPLICATION_KEY}'
application_secret = '${OVH_APPLICATION_SECRET}'

endpoint = ovh-eu
poweroff_script_id = poweroff.ipxe
boot_script_id = boot.ipxe
EOF

mkdir -p /shared/html
mkdir -p /shared/ironic_prometheus_exporter
