FROM openjdk:8-jre-alpine

RUN apk add --no-cache \
            xvfb \
            ttf-freefont \
            fontconfig \
            dbus \
    && apk add qt5-qtbase-dev \
            wkhtmltopdf \
            --no-cache \
            --repository http://dl-3.alpinelinux.org/alpine/latest-stable/releases/ \
            --allow-untrusted \
    && mv /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf-origin && \
    echo $'#!/usr/bin/env sh\n\
Xvfb :0 -screen 0 1024x768x24 -ac +extension GLX +render -noreset & \n\
DISPLAY=:0.0 wkhtmltopdf-origin $@ \n\
killall Xvfb\
' > /usr/bin/wkhtmltopdf && \
    chmod +x /usr/bin/wkhtmltopdf

# Install Fonts
ADD fonts /usr/share/fonts/
RUN fc-cache -fv
