FROM cgr.dev/chainguard/wolfi-base

RUN apk update && apk add bash

ENV CNB_USER_ID=1000
ENV CNB_GROUP_ID=1000

RUN addgroup -g 1000 cnb && \
    adduser -u 1000 -G cnb -s /bin/bash -D cnb

LABEL io.buildpacks.stack.id="io.mycompany.stacks.wolfi"

USER cnb