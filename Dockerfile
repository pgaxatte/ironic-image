FROM ironic-base:latest

RUN yum install -y \
        gcc \
        git \
        python3-devel \
        python3-pip && \
    pip3 install \
        bindep \
        ironic-prometheus-exporter \
        git+https://github.com/pixelb/crudini.git@0.9.3 && \
    git clone https://github.com/pgaxatte/ironic.git /tmp/ironic && \
    cd /tmp/ironic && \
    git checkout ovh/train && \
    yum install -y $(bindep -b) && \
    pip3 install .

COPY ./ironic.conf /etc/ironic/ironic.conf

COPY ./runironic-api.sh /bin/runironic-api
COPY ./runironic-conductor.sh /bin/runironic-conductor
COPY ./runironic-exporter.sh /bin/runironic-exporter
COPY ./rundnsmasq.sh /bin/rundnsmasq
COPY ./runhttpd.sh /bin/runhttpd
COPY ./runmariadb.sh /bin/runmariadb
COPY ./configure-ironic.sh /bin/configure-ironic.sh
COPY ./ironic-common.sh /bin/ironic-common.sh

# TODO(dtantsur): remove this script when we stop supporting running both
# API and conductor processes via one entry point.
COPY ./runironic.sh /bin/runironic

COPY ./dnsmasq.conf.j2 /etc/dnsmasq.conf.j2
COPY ./inspector.ipxe /tmp/inspector.ipxe
COPY ./dualboot.ipxe /tmp/dualboot.ipxe

ENTRYPOINT ["/bin/runironic"]
