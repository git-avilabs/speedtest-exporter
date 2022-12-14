FROM python:3.10.4-alpine3.15

ARG SPEEDTEST_VERSION=1.2.0
RUN adduser -D speedtest

WORKDIR /app
COPY . .

RUN pip3 install -r requirements.txt
RUN ARCHITECTURE=$(uname -m) && \
    export ARCHITECTURE && \
    if [ "$ARCHITECTURE" = 'armv7l' ];then ARCHITECTURE="armhf";fi && \
    wget -nv -O /tmp/speedtest.tgz "https://install.speedtest.net/app/cli/ookla-speedtest-${SPEEDTEST_VERSION}-linux-${ARCHITECTURE}.tgz" && \
    tar zxvf /tmp/speedtest.tgz -C /tmp && \
    cp /tmp/speedtest /usr/local/bin && \
    chown -R speedtest:speedtest /app && \
    rm -rf \
     /tmp/* \
     /app/requirements

USER speedtest
CMD [ "python3", "main.py" ]
