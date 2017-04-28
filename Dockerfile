FROM jtulak/myfedora

ADD covscan-fedora.repo /etc/yum.repos.d/
ADD license.config /root/
RUN dnf install -y covscan-client

workdir /workdir
volume /workdir
