FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install essentials: SSH, ngrok, curl, wget, etc.
RUN apt-get update && apt-get install -y     openssh-server     curl     wget     unzip     net-tools     nano     sudo     && rm -rf /var/lib/apt/lists/*

# Install ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null &&     echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list &&     apt-get update && apt-get install -y ngrok && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir /var/run/sshd
RUN echo 'root:Anony#234' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
RUN echo "AllowUsers root" >> /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
