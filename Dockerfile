FROM jtulak/myfedora


ADD covscan-fedora.repo /etc/yum.repos.d/
ADD license.config /root/
RUN dnf -y install \
           libaio-devel \
           libuuid-devel \
           libattr-devel \
           libacl-devel \
           gettext \
           libblkid-devel \
           bc \
           covscan-client \
           cov-sa87 \
           csbuild

workdir /workdir
volume /workdir

ADD run-test.sh /
ENTRYPOINT ["/bin/bash","/run-test.sh", "/workdir"]
