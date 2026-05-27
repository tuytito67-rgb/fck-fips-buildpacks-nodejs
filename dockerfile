FROM cgr.dev/chainguard/wolfi-base

RUN apk update && apk add python-3 py3-pip build-base posix-libc-utils

RUN pip install --break-system-packages pyinstaller

WORKDIR /app

COPY optimize_memory.py .
COPY inspector.py .

RUN pyinstaller --onefile optimize_memory.py && \
    pyinstaller --onefile inspector.py

RUN mkdir -p /app/exec.d && \
    cp dist/optimize_memory /app/exec.d/0-optimize-memory && \
    cp dist/inspector /app/exec.d/1-inspector

RUN apk del python-3 py3-pip build-base posix-libc-utils && rm -rf build dist optimize_memory.py inspector.py *.spec /root/.cache

ENV BPL_DEBUG_ENABLED=true
ENV BPL_DEBUG_PORT=9009
ENV NODE_OPTIONS=--use-openssl-ca

CMD ["/app/exec.d/1-inspector"]