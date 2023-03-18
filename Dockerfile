FROM debian:11-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y samba

COPY ./samba/smb.conf /etc/samba/smb.conf

COPY ./samba_user.txt /samba_user.txt

# ユーザ登録
RUN cat /samba_user.txt | awk '{print "adduser --disabled-password --gecos \"\" ", $1}' | /bin/sh && \
    cat /samba_user.txt | awk '{print "(echo ",$2,"; echo ",$2,") | pdbedit -a ",$1, "-t" }' | /bin/sh && \
    rm /samba_user.txt

RUN mkdir -p /samba/share && \
    chown -R samba-user:samba-user /samba/share && \
    chmod -R 777 /samba/share

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

COPY docker-healthcheck.sh /docker-healthcheck.sh
RUN chmod +x /docker-healthcheck.sh
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD exec /docker-healthcheck.sh

CMD ["smbd", "--foreground", "--log-stdout"]