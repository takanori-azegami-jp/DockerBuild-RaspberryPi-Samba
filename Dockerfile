FROM debian:11-slim
RUN apt -y update && \
		apt -y install samba
RUN mkdir -p /samba/homes && \
		chmod -R 0700 /samba/homes
RUN mkdir -p /samba/share && \
		chmod -R 0777 /samba/share

COPY ./samba/smb.conf /etc/samba/smb.conf

EXPOSE 139/tcp 445/tcp

# ユーザ登録用シェル
COPY ./user.list  ./user.list
COPY ./user_add.sh ./user_add.sh
RUN chmod 777 ./user_add.sh
RUN sh ./user_add.sh
RUN rm ./user_add.sh

HEALTHCHECK CMD ["docker-healthcheck.sh"]

CMD [ "bash", "-c", "nmbd -D && smbd -F </dev/null" ]
