FROM arizonatribe/centos
MAINTAINER David Nunez <arizonatribe@gmail.com>

# Install mariadb and additional tools it will use
RUN yum install -y --setopt=tsflags=nodocs \
    bind-utils \
    hostname \
    psmisc \
    pwgen

RUN yum -y clean all

# Scripts in this directory overlay the container's natural directory structure
COPY docker /

RUN mkdir /var/log/mariadb
RUN yum install MariaDB-server -y

RUN /opt/bin/permissions.sh /var/lib/mysql/  \
    && /opt/bin/permissions.sh /var/log/mariadb/ \
    && /opt/bin/permissions.sh /var/run/

ENTRYPOINT ["/usr/bin/start"]

# Will run as mysql user (27)
USER 27

CMD ["mysqld_safe"]
