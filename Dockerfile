FROM ubuntu:14.04
ARG mapr_host
ENV mapr_host "10.3.64.102"
ARG mapr_name
ENV mapr_name "cluster2"
RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common wget openjdk-7-jdk
RUN add-apt-repository -y "deb http://package.mapr.com/releases/v5.2.1/ubuntu/ binary trusty"
RUN add-apt-repository -y "deb http://package.mapr.com/releases/MEP/MEP-3.0/ubuntu binary trusty"
RUN wget -O - http://package.mapr.com/releases/pub/maprgpg.key | apt-key add - 
RUN apt-get update
RUN apt-get -y install mapr-client mapr-spark nfs-common
RUN mkdir /mapr
RUN /opt/mapr/server/configure.sh -N ${mapr_name} -c -C ${mapr_host}
RUN groupadd -g 5000 mapr
RUN useradd -g 5000 -u 5000 -p mapr -m -d /home/mapr mapr
RUN echo "echo 10.3.64.101 node1 cluster1 >> /etc/hosts" >> /root/.bashrc
RUN echo "echo 10.3.64.102 node2 cluster2 >> /etc/hosts" >> /root/.bashrc
RUN echo "mount -o nolock 10.3.64.102:/mapr /mapr" >> /root/.bashrc
RUN apt-get install -y nodejs
COPY . /opt/app
ENV APPDIR=opt/app
ENTRYPOINT nodejs /opt/app/bin/www
