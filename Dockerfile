FROM centos:7.7.1908
ENV container docker

RUN yum -y install epel-release
RUN yum -y install \
    gcc \
    make \
    httpd \
    mysql \
    php \
    php-devel \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-gd \
    php-pear \
    ImageMagick \
    ImageMagick-devel \
    sendmail \
    xinetd \
    phpmyadmin
RUN printf "\n" | pecl install imagick

# Remove xinetd services
RUN /bin/rm -f /etc/xinetd.d/*

# App setup
RUN mkdir /base
RUN mkdir /base/application
RUN mkdir /base/public_html

COPY ./assets/httpd.conf /etc/httpd/conf/
COPY ./assets/php.conf   /etc/httpd/conf.d/
COPY ./assets/phpMyAdmin.conf   /etc/httpd/conf.d/
COPY ./assets/php.ini    /etc/
COPY ./assets/index.php  /base/public_html/
COPY ./assets/smtp       /etc/xinetd.d/smtp
COPY ./assets/phpMyAdmin/config.inc.php /etc/phpMyAdmin/

EXPOSE 80

CMD exec httpd -DFOREGROUND "$@"
