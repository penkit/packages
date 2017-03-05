#!/bin/sh
set -e

# fix permisisons of build/package directories
mkdir -p /var/cache/distfiles /home/penkit/packages
chgrp -R abuild /var/cache/distfiles
chgrp -R penkit /home/penkit/packages
chmod -R g+w /var/cache/distfiles
chmod -R g+w /home/penkit/packages

# run original command through alpine entrypoint
exec alpine-entrypoint.sh $@
