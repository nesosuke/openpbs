FROM debian:bullseye

SHELL [ "/bin/bash", "-c" ]
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata 
RUN apt-get install -y \
      git gcc make libtool libhwloc-dev libx11-dev \
      libxt-dev libedit-dev libical-dev ncurses-dev perl \
      tcl-dev tk-dev swig \
      libexpat-dev libssl-dev libxext-dev libxft-dev autoconf \
      automake g++ python3 python3-dev
RUN apt-get -y install postgresql-server-dev-all postgresql-contrib

WORKDIR /app
RUN git clone https://github.com/openpbs/openpbs
RUN cd openpbs && \
      ./autogen.sh && \
      ./configure --prefix=/opt/pbs --libexecdir=/opt/pbs/libexec && \
      make && \
      make install && \
      /opt/pbs/libexec/pbs_postinstall && \
      chmod  4755 /opt/pbs/sbin/pbs_iff /opt/pbs/sbin/pbs_rcp

# CMD [ "bash", "-c", "/etc/init.d/pbs start" ]
