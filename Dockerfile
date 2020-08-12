FROM alpine:3

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="James Hunt <images@huntprod.com>" \
      summary="A lightweight SSH+git container image" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/filefrog/ssh-git.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0"

RUN apk update \
 && apk add openssh git \
 && rm -rf /var/cache/apk/*

ADD init /init
CMD ["/init"]
