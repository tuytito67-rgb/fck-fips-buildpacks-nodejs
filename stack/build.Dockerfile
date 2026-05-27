FROM ghcr.io/taha2samy/wolfi-openssl-fips:3.5.5-dev AS fips_source

FROM cgr.dev/chainguard/wolfi-base

RUN apk update && apk add python-3 py3-pip build-base posix-libc-utils git bash libuv c-ares brotli nghttp2 icu

RUN pip install --break-system-packages pyinstaller semantic_version pyyaml

COPY --from=fips_source /usr/local /usr/local

RUN mkdir -p /usr/lib/ossl-modules /etc/ssl && \
    ln -sf /usr/local/lib/ossl-modules/fips.so /usr/lib/ossl-modules/fips.so && \
    ln -sf /usr/local/ssl/openssl.cnf /etc/ssl/openssl.cnf

ENV CNB_USER_ID=1000
ENV CNB_GROUP_ID=1000

RUN addgroup -g 1000 cnb && \
    adduser -u 1000 -G cnb -s /bin/bash -D cnb

LABEL io.buildpacks.stack.id="io.mycompany.stacks.wolfi"

RUN mkdir /workspace /layers /platform && \
    chown -R cnb:cnb /workspace /layers /platform

USER cnb