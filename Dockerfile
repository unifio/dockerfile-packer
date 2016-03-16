FROM alpine:3.3

ENV PACKER_VERSION 0.10.0
ENV PACKER_SHA256SUM eadd33bc0f8fa42034059fc1cda5f43ed6f540746e767480f0706ebed49b45e5

RUN apk add --update wget ca-certificates unzip build-base ruby-dev ruby && \
    wget -q "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
    wget -q "https://circle-artifacts.com/gh/unifio/packer-post-processor-vagrant-s3/17/artifacts/0/home/ubuntu/.go_workspace/bin/packer-post-processor-vagrant-s3" && \
    apk add --allow-untrusted glibc-2.21-r2.apk && \
    gem install bundler --no-ri --no-rdoc && \
    wget -q -O /packer.zip "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" && \
    echo "${PACKER_SHA256SUM}  /packer.zip" | sha256sum -c && \
    unzip /packer.zip -d /bin && \
    chmod +x packer-post-processor-vagrant-s3 && \
    mv packer-post-processor-vagrant-s3 /bin && \
    apk del --purge wget unzip && \
    rm -rf /var/cache/apk/* glibc-2.21-r2.apk /packer.zip

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["/bin/packer"]

CMD ["--help"]
