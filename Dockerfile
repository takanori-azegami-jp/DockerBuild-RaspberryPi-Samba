FROM debian:11-slim
RUN apt update && \
       apt -y install samba
RUN mkdir -p /samba/share && \
        chmod -R 0777 /samba/share && \
       chown -R nobody:nobody /samba/share

COPY ./smaba/smb.conf /etc/samba/smb.conf

EXPOSE 139/tcp 445/tcp

HEALTHCHECK CMD ["docker-healthcheck.sh"]

CMD ["/usr/sbin/smbd", "-FS"]

