FROM alpine:3.2

ENV PACKER_VERSION 0.8.6
ENV PACKER_SHA256SUM 2f1ca794e51de831ace30792ab0886aca516bf6b407f6027e816ba7ca79703b5

RUN apk add --update wget ca-certificates unzip build-base ruby-dev && \
    wget -q "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" && \
    apk add --allow-untrusted glibc-2.21-r2.apk && \
    gem install bundler --no-ri --no-rdoc && \
    wget -q -O /packer.zip "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" && \
    echo "${PACKER_SHA256SUM}  /packer.zip" | sha256sum -c && \
    unzip /packer.zip -d /bin && \
    apk del --purge wget unzip && \
    rm -rf /var/cache/apk/* glibc-2.21-r2.apk /packer.zip

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["/bin/packer"]

CMD ["--help"]
