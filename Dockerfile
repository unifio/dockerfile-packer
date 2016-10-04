FROM alpine:3.4
MAINTAINER "Unif.io, Inc. <support@unif.io>"

ENV PACKER_VERSION 0.10.2

RUN apk add --no-cache --update ca-certificates gnupg openssl git wget unzip && \
    gpg --recv-keys 91A6E7F85D05C65630BEF18951852D87348FFC4C && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget -q "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" && \
    wget -q "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS" && \
    wget -q "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS.sig" && \
    gpg --batch --verify packer_${PACKER_VERSION}_SHA256SUMS.sig packer_${PACKER_VERSION}_SHA256SUMS && \
    grep packer_${PACKER_VERSION}_linux_amd64.zip packer_${PACKER_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip -d /bin packer_${PACKER_VERSION}_linux_amd64.zip && \
    cd /tmp && \
    rm -rf /tmp/build && \
    rm -rf /root/.gnupg

ENV DOCKER_VERSION 1.9.1
ENV DOCKER_SHA256 6a095ccfd095b1283420563bd315263fa40015f1cee265de023efef144c7e52d

RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget -q -O docker.tgz "https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" && \
    echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - && \
    tar -C / -xzvf docker.tgz && \
    cd /tmp && \
    rm -rf /tmp/build && \
    docker -v

RUN apk add --no-cache --update build-base ruby-dev ruby && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget -q "https://circle-artifacts.com/gh/unifio/packer-post-processor-vagrant-s3/22/artifacts/0/home/ubuntu/.go_workspace/bin/packer-post-processor-vagrant-s3" && \
    wget -q "https://circle-artifacts.com/gh/unifio/packer-provisioner-serverspec/26/artifacts/0/home/ubuntu/.go_workspace/bin/packer-provisioner-serverspec" && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub "https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub" && \
    wget -q "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk" && \
    apk add glibc-2.23-r3.apk && \
    chmod +x packer-post-processor-vagrant-s3 packer-provisioner-serverspec && \
    mv packer-post-processor-vagrant-s3 packer-provisioner-serverspec /bin && \
    gem install io-console bundler --no-ri --no-rdoc && \
    cd /tmp && \
    rm -rf /tmp/build

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["/bin/packer"]

CMD ["--help"]
