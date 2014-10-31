# Install Lsyncd
RUN apt-get install -y lsyncd

RUN mkdir -p 	/etc/service/lsyncd
RUN mkdir -p 	/var/log/lsyncd
RUN touch 	/var/log/lsyncd/lsyncd.{log,status}

ADD etc/my_init.d/88_lsyncd_setup.sh /etc/my_init.d/88_lsyncd_setup.sh
ADD build/lsyncd.sh /etc/service/lsyncd/run
RUN chmod +x        /etc/service/lsyncd/run
# END Lsyncd Installation
