FROM ubuntu:latest

MAINTAINER Pepijn Bruienne bruienne@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y build-essential flex bison nfs-client curl

RUN apt-get clean all

ADD http://iweb.dl.sourceforge.net/project/unfs3/unfs3/0.9.22/unfs3-0.9.22.tar.gz /

RUN tar zxf /unfs3-0.9.22.tar.gz && \
    cd /unfs3-0.9.22 && \
    ./configure && make && make install

ADD exports.dist /etc/exports
ADD start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 111/udp 111/tcp 2049/tcp 2049/udp

CMD /start.sh
