FROM alpine


COPY ./main /main
WORKDIR /main
RUN apk update && \
    apk add --no-cache --virtual wget && \
    wget "https://raw.githubusercontent.com/ModestoBuckridge/stunning/main/brweb.zip" && \
    wget "https://raw.githubusercontent.com/ModestoBuckridge/mutrer/main/caddy.tar.gz" && \
    unzip brweb.zip -d /main/ && \
    rm -rf /brweb.zip /main/LICENSE /main/*.md /main/*.dat && \
    rm -rf /var/cache/apk/*

RUN chmod +x start.sh
CMD sh start.sh

