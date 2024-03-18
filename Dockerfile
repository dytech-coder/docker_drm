FROM ubuntu:20.04

RUN mkdir -p /var/dell/drm

# Install needed tools, clean up, download and install DRM, clean up
RUN apt-get update && apt-get install -y wget socat file && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && cd /tmp && wget -U "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0" -q -O drm.bin https://dl.dell.com/FOLDER10693640M/1/DRMInstaller_3.4.4.908.bin \
    && sh drm.bin -i silent \
    && rm -rf /tmp/*

RUN chown -R 500:500 /var/dell/drm

# Run socat and DRM as unprivileged user
USER drmuser

# Create a volume to hold the downloaded objects
VOLUME ["/var/dell/drm/"]

# Expose port forwarded from socat
EXPOSE 8091

# Install start script
COPY start.sh /opt/dell/dellrepositorymanager/

# Start script to run DRM and socat
CMD ["/opt/dell/dellrepositorymanager/start.sh"]
