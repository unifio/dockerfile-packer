FROM alpine:latest

ENV PACKER_VERSION 0.10.1

RUN apk add --update wget ca-certificates unzip build-base ruby-dev ruby && \
    wget -q "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" && \
    wget -q "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS" && \
    wget -q "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
    wget -q "https://circle-artifacts.com/gh/unifio/packer-post-processor-vagrant-s3/22/artifacts/0/home/ubuntu/.go_workspace/bin/packer-post-processor-vagrant-s3" && \
    apk add --allow-untrusted glibc-2.21-r2.apk && \
    sed -i '/packer_${PACKER_VERSION}_linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS && \
    sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin && \
    gem install bundler --no-ri --no-rdoc && \
    chmod +x packer-post-processor-vagrant-s3 && \
    mv packer-post-processor-vagrant-s3 /bin && \
    apk del --purge wget unzip && \
    rm -rf /var/cache/apk/* glibc-2.21-r2.apk /packer.zip

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["/bin/packer"]

CMD ["--help"]
