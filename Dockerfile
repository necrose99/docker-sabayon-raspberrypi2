FROM sabayon/base-armhfp

MAINTAINER mudler <mudler@sabayonlinux.org>

RUN rsync -av -H -A -X --delete-during "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/" && \
    ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept

# Adding repository url
ADD ./confs/entropy_arm /etc/entropy/repositories.conf.d/entropy_arm

RUN equo up && equo u && equo i openssh networkmanager

# Cleaning accepted licenses
RUN rm -rf /etc/entropy/packages/license.accept

# Perform post-upgrade tasks (mirror sorting, updating repository db)
ADD ./script/setup.sh /setup.sh
RUN /bin/bash /setup.sh  && rm -rf /setup.sh

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /

# Define standard volumes
VOLUME ["/usr/portage", "/usr/portage/distfiles", "/usr/portage/packages", "/var/lib/entropy/client/packages"]
