FROM debian
WORKDIR /usr/src
RUN apt-get update && apt-get install -y wget tini
RUN wget http://soft.vpser.net/lnmp/lnmp1.9.tar.gz -cO lnmp1.9.tar.gz && tar zxf lnmp1.9.tar.gz && cd lnmp1.9 && LNMP_Auto="y" DBSelect="0" PHPSelect="12" SelectMalloc="1" ./install.sh lnmp
COPY start.sh /start.sh
RUN chmod 755 /start.sh
CMD /start.sh
ENTRYPOINT ["/usr/bin/tini", "--"]
