FROM sabayon/base-armhfp

MAINTAINER mudler <mudler@sabayonlinux.org>

# Set locales to en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN rsync -av "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/" && \
	ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept

# Adding repository url
ADD ./confs/entropy_arm /etc/entropy/repositories.conf.d/entropy_arm

ADD ./ext/qemu-arm-static /usr/bin/qemu-arm-binfmt

RUN equo rescue spmsync &&  equo up && equo u && \
  equo i app-admin/sudo net-misc/openssh net-misc/networkmanager \
	app-misc/sabayon-live app-misc/sabayon-skel net-misc/ntp \
	sys-apps/keyboard-configuration-helpers media-libs/raspberrypi-userland-0_pre20150921 \
	sys-apps/systemd sys-kernel/raspberrypi-sources-3.10.1_pre-r20130719 app-misc/sabayon-version \
        sys-process/vixie-cron


# Cleaning accepted license2s
RUN rm -rf /etc/entropy/packages/license.accept

RUN echo -5 | equo conf update

RUN wget https://raw.githubusercontent.com/Hexxeh/rpi-update/master/rpi-update -O /usr/sbin/rpi-update && chmod +x /usr/sbin/rpi-update

# Perform post-upgrade tasks (mirror sorting, updating repository db)
ADD ./scripts/setup.sh /setup.sh
RUN /bin/bash /setup.sh  && rm -rf /setup.sh

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /

# Define standard volumes
#VOLUME ["/usr/portage", "/usr/portage/distfiles", "/usr/portage/packages", "/var/lib/entropy/client/packages"]
