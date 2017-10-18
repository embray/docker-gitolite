FROM alpine:3.5

# Create the 'git' user with UID 1000 (instead of the default 100)
RUN adduser -D -u 1000 -h /var/lib/git -g '' -s /bin/sh git

# Install OpenSSH server and Gitolite
RUN set -x \
 && apk add --update gitolite openssh \
 && rm -rf /var/cache/apk/* \
 && passwd -u git

# Volume used to store SSH host keys, generated on first run
VOLUME /etc/ssh/keys

# Volume used to store all Gitolite data (keys, config and repositories), initialized on first run
VOLUME /var/lib/git

# Entrypoint responsible for SSH host keys generation, and Gitolite data initialization
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

# Expose port 22 to access SSH
EXPOSE 22

# Default command is to run the SSH server
CMD ["sshd"]
