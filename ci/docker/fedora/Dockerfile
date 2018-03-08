#
# Author: Damian Wrobel <dwrobel@ertelnet.rybnik.pl>
#

FROM docker.io/fedora:27

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN dnf install -y dnf-plugins-core
RUN dnf copr -y enable dwrobel/node-shared

# Equivalent of @Buildsystem building group (except gcc-c++ and gcc).
RUN dnf install -y make diffutils unzip bash gawk which patch grep fedora-release info shadow-utils sed redhat-rpm-config tar rpm-build findutils util-linux gzip xz cpio coreutils bzip2

# Spark dependencies (for both wayland and glut backends)
RUN dnf install -y sudo node8-shared-devel node-shared-devel procps-ng gdb quilt ccache gcc-c++ libasan libtsan hostname gawk freeglut-devel glew-devel libgcrypt-devel bzip2-devel autoconf libtool cmake xorg-x11-drv-libinput-devel libcurl-devel libssh2-devel gnutls-devel libjpeg-turbo-devel turbojpeg-devel libpng-devel freetype-devel wayland-devel mesa-libEGL-devel mesa-libGLES-devel mesa-libwayland-egl-devel libuuid-devel
# Test dependencies
RUN dnf install -y weston mesa-dri-drivers freerdp

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]