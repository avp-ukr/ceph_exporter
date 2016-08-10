FROM golang:1.6.3

ENV APP_PATH ${GOPATH}/src/github.com/digitalocean/ceph_exporter

RUN apt-get update \
    && apt-get install -y apt-transport-https lsb-release \
    && wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add - \
    && echo "deb https://download.ceph.com/debian-jewel $(lsb_release -cs) main" >>/etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y librados-dev librbd-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD . ${APP_PATH}
WORKDIR ${APP_PATH}
RUN go get -d && \
    go build -o /bin/ceph_exporter

EXPOSE 9128
ENTRYPOINT ["/bin/ceph_exporter"]
