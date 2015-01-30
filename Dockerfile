# Set the base image to debian
FROM freshjones/phpfpm

# File Author / Maintainer
MAINTAINER William Jones <billy@freshjones.com>

ENV TERM=xterm

# Update the repository sources list
RUN apt-get update && \
    apt-get install -y \
    nano \
    nginx \
    supervisor

# set daemon to off
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

#add sites enabled dir
ADD nginx/sites-enabled/ /etc/nginx/sites-enabled/

#copy supervisor conf
COPY supervisor/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

# Create log directories
RUN mkdir -p /var/log/supervisor

COPY app/ /app/

# clean apt cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#expose port 80
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
