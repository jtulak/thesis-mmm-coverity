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

RUN mv /usr/bin/cppcheck /usr/bin/cppcheck.disabled

RUN echo "PATH=$PATH:/opt/coverity/bin" > /etc/profile.d/coverity.sh

workdir /workdir
volume /workdir
workdir /output
volume /output

ADD run-test.sh /
ENTRYPOINT ["/bin/bash","/run-test.sh"]
