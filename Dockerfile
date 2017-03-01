FROM alpine:3.5

# install alpine sdk and create non-root user
RUN set -ex; \
  apk update; \
  apk add alpine-sdk ; \
  adduser -D penkit; \
  addgroup penkit abuild; \
  mkdir -p /home/penkit/work; \
  chown penkit:penkit /home/penkit/work; \
  chgrp abuild /var/cache/distfiles;

# default to running build script in work directory
WORKDIR /home/penkit/work
CMD ["abuild", "-r"]

# copy trusted penkit public key
COPY config/penkit.rsa.pub /etc/apk/keys/

# run as non-root user
USER penkit
