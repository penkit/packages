FROM penkit/alpine:3.5

# always run as penkit user
ENV RUN_AS penkit

# install alpine sdk and create non-root user
RUN set -ex; \
  apk update; \
  apk add alpine-sdk ; \
  adduser -D penkit; \
  addgroup penkit abuild; \
  mkdir -p /home/penkit/work; \
  chown penkit:penkit /home/penkit/work;

# default to running build script in work directory
WORKDIR /home/penkit/work
COPY abuild-entrypoint.sh /usr/local/sbin/
ENTRYPOINT ["/usr/local/sbin/abuild-entrypoint.sh"]
CMD ["abuild", "-r"]

# copy trusted penkit public key
COPY config/penkit.rsa.pub /etc/apk/keys/
