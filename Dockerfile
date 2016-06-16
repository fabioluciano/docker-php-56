FROM centos:latest

MAINTAINER Fábio Luciano <fabioluciano@php.net>

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN yum groupinstall 'Development Tools' -y && yum install -y httpd mod_ssl openssl php56w-pear php56w-common php56w-opcache php56w-mbstring php56w-opcache php56w-mcrypt php56w-intl php56w-devel php56w-gd php56w-ldap php56w-mysqlphp56w-pdo php56w-pgsql php56w-xml initscripts &&  yum clean all

# PHP Related
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY config/definepath.sh /etc/profile.d/definepath.sh

COPY packages/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm /tmp/
COPY packages/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm /tmp/
COPY packages/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm /tmp/
RUN yum install -y /tmp/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
RUN yum install -y /tmp/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
RUN yum install -y /tmp/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm

RUN printf "\n" | pecl install oci8-2.0.11
RUN echo "extension=oci8.so" > /etc/php.d/oci8.ini

EXPOSE 80 443

VOLUME ["/var/www", "/var/log/apache2", "/etc/apache2"]
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
