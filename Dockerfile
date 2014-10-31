FROM phusion/baseimage:0.9.15

MAINTAINER alex@visionlabs.pro

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# Nginx-PHP Installation
RUN apt-get update
RUN apt-get install -y curl \
                       wget \
                       bash-completion

RUN apt-get update >
RUN echo 'Installing php4-fpm...'
RUN apt-get install -y php5-cli php5-fpm php5-mysql php5-curl \
		       php5-gd php5-mcrypt php5-intl php5-imap php5-tidy > /dev/null
RUN echo 'Finiched installing php4-fpm'

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini

RUN apt-get install -y nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

RUN mkdir           /var/www
ADD build/default   /etc/nginx/sites-available/default
RUN mkdir           /etc/service/nginx
ADD build/nginx.sh  /etc/service/nginx/run
RUN chmod +x        /etc/service/nginx/run
RUN mkdir           /etc/service/phpfpm
ADD build/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x        /etc/service/phpfpm/run

EXPOSE 80
# End Nginx-PHP

# MySQL Installation
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y mysql-server

ADD build/my.cnf    /etc/mysql/my.cnf

RUN mkdir           /etc/service/mysql
ADD build/mysql.sh  /etc/service/mysql/run
RUN chmod +x        /etc/service/mysql/run

RUN mkdir -p        /var/lib/mysql/
RUN chmod -R 755    /var/lib/mysql/

ADD etc/my_init.d/99_mysql_setup.sh /etc/my_init.d/99_mysql_setup.sh
RUN chmod +x /etc/my_init.d/99_mysql_setup.sh

# EXPOSE 3306
# END MySQL Installation

# Install Memcached
RUN apt-get install -y php5-memcache memcached

RUN mkdir -p 		/etc/service/memcached
ADD build/memcached.sh /etc/service/memcached/run
RUN chmod +x        	/etc/service/memcached/run
# END Memcached Installation

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
