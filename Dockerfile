FROM debian:11-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y samba

COPY ./samba/smb.conf /etc/samba/smb.conf

# ユーザ登録
RUN adduser --disabled-password --gecos "" samba-user
RUN echo "samba-user:samba-pass" | chpasswd
RUN printf 'samba-pass\nsamba-pass\n' | pdbedit -a -t -u samba-user

RUN mkdir -p /samba/share && \
    chown -R samba-user:samba-user /samba/share && \
    chmod -R 777 /samba/share

EXPOSE 137/udp 138/udp 139/tcp 445/tcp

COPY docker-healthcheck.sh /docker-healthcheck.sh
RUN chmod +x /docker-healthcheck.sh
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD exec /docker-healthcheck.sh

CMD [ "bash", "-c", "nmbd -D && smbd -F </dev/null" ]