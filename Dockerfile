FROM debian:11-slim

RUN apt -y update && \
		apt -y install samba

COPY ./samba/smb.conf /etc/samba/smb.conf

EXPOSE 139/tcp 445/tcp

# ユーザ登録
RUN adduser --disabled-password --gecos "" samba-user
RUN echo "samba-user:samba-pass" | chpasswd
RUN printf 'samba-pass\nsamba-pass\n' | pdbedit -a -t -u samba-user

RUN mkdir -p /samba/share && \
		chown -R samba-user:samba-user /samba/share && \
		chmod -R 777 /samba/share

COPY docker-healthcheck.sh /docker-healthcheck.sh
RUN chmod +x /docker-healthcheck.sh
HEALTHCHECK CMD ["/docker-healthcheck.sh"]

ENTRYPOINT [ "bash", "-c", "nmbd -D && smbd -F </dev/null" ]
