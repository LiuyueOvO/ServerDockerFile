FROM centos/devtoolset-7-toolchain-centos7
USER root

# Some packages we need
RUN yum -y install epel-release && \
    yum -y install git && \
    yum -y install make && \
    yum -y update

# Install build tools
RUN yum -y install wget tree net-tools

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Script
ARG script=./script
ADD $script/ /opt/script

# Start
# ENV WORKSPACE /root
# WORKDIR $WORKSPACE
ENTRYPOINT ["/opt/script/start-service.sh"]
CMD ["start"]
