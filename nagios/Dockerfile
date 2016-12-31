FROM php:5-apache

ENV DEBIAN_FRONTEND noninteractive
ENV NAGIOS_VERSION nagios-4.2.2

# Install dependencies
RUN addgroup nagcmd \
  && useradd nagios \
  && usermod -a -G nagcmd nagios \
  && apt-get update \
  && apt-get install -y --no-install-recommends build-essential libgd2-xpm-dev openssl libssl-dev xinetd unzip libgd-tools libwww-perl libcrypt-ssleay-perl git mailutils ssmtp dnsutils smbclient python3\
  && a2enmod rewrite cgi ssl

# Build and install nagios
RUN git clone -b $NAGIOS_VERSION https://github.com/NagiosEnterprises/nagioscore.git \
  && cd nagioscore \
  && ./configure --with-nagios-group=nagios --with-command-group=nagcmd \
  && make all install install-commandmode install-init install-config \
  && /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf \
  && usermod -G nagcmd www-data \
  && a2ensite nagios

# Install Nagios Plugins
RUN git clone -b release-2.1.1 https://github.com/nagios-plugins/nagios-plugins.git \
  && apt-get install -y --no-install-recommends m4 gettext automake autoconf \
  && cd nagios-plugins \
  && ./tools/setup \
  && ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl \
  && make \
  && make install

# Configuration Files
COPY nagios.cfg /usr/local/nagios/etc/nagios.cfg
COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY docker-entrypoint.sh /usr/bin/
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

# Icons
COPY logos /usr/local/nagios/share/images/logos

# Entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# Mount points for servers and objects
VOLUME /usr/local/nagios/etc/servers /usr/local/nagios/etc/objects

# HTTP port
EXPOSE 80
