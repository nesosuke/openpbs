FROM python:slim-buster

SHELL [ "/bin/bash", "-c" ]
ENV DEBIAN_FRONTCND=noninteractive
RUN apt-get update && apt-get install -y tzdata 
RUN apt-get install -y \
      gcc make libtool libhwloc-dev libx11-dev \
      libxt-dev libedit-dev libical-dev ncurses-dev perl \
      tcl-dev tk-dev swig \
      libexpat-dev libssl-dev libxext-dev libxft-dev autoconf \
      automake g++

WORKDIR /app/openpbs
COPY . /app/openpbs
RUN ./autogen.sh && \
      ./configure --prefix=/opt/pbs --libexecdir=/opt/pbs/libexec && \
      make && \
      make install && \
      /opt/pbs/libexec/pbs_postinstall && \
      chmod  4755 /opt/pbs/sbin/pbs_iff /opt/pbs/sbin/pbs_rcp

CMD [ "bash", "-c", "/etc/init.d/pbs start" ]
