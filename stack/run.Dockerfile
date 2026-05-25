FROM ghcr.io/taha2samy/wolfi-openssl-fips:3.5.5 AS fips_source

FROM cgr.dev/chainguard/wolfi-base

RUN apk update && apk add bash libuv c-ares brotli nghttp2 icu

COPY --from=fips_source /usr/local /usr/local
RUN mkdir -p /usr/lib/ossl-modules /etc/ssl && \
    ln -sf /usr/local/lib/ossl-modules/fips.so /usr/lib/ossl-modules/fips.so && \
    ln -sf /usr/local/ssl/openssl.cnf /etc/ssl/openssl.cnf

ENV CNB_USER_ID=1000
ENV CNB_GROUP_ID=1000

RUN addgroup -g 1000 cnb && \
    adduser -u 1000 -G cnb -s /bin/bash -D cnb

LABEL io.buildpacks.stack.id="io.fckfips.stacks.wolfi"

USER cnb