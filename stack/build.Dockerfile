FROM cgr.dev/chainguard/wolfi-base

RUN apk update && apk add python-3 py3-pip build-base posix-libc-utils git bash

RUN pip install --break-system-packages pyinstaller semantic_version pyyaml

ENV CNB_USER_ID=1000
ENV CNB_GROUP_ID=1000

RUN addgroup -g 1000 cnb && \
    adduser -u 1000 -G cnb -s /bin/bash -D cnb
LABEL io.buildpacks.stack.id="io.mycompany.stacks.wolfi"

RUN mkdir /workspace /layers /platform && \
    chown -R cnb:cnb /workspace /layers /platform

USER cnb