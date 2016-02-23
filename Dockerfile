FROM alpine:3.3

ENV PACKER_VERSION 0.9.0
ENV PACKER_SHA256SUM 4119d711855e8b85edb37f2299311f08c215fca884d3e941433f85081387e17c

RUN apk add --update wget ca-certificates unzip build-base ruby-dev ruby && \
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
