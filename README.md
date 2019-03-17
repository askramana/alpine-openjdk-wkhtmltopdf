# alpine-openjdk-wkhtmltopdf

Base Docker image having `openjdk:8-jre-alpine` with `wkhtmltopdf` dependency

### This repository is for you, if
- You're building over [openjdk:8-jre-alpine](https://github.com/docker-library/openjdk/blob/dd54ae37bc44d19ecb5be702d36d664fed2c68e4/8/jre/alpine/Dockerfile),
- And need [wkhtmltopdf](http://wkhtmltopdf.org) to convert an HTML to PDF file.

### Usage

#### Dockerfile
```dockerfile
FROM openjdk:8-jre-alpine

# Install wkhtmltopdf
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
```

With this, your application can use command `wkhtmltopdf html-file-path pdf-file-path` to convert an HTML file to PDF.

#### Java Usage
```java
void wkHtmlToPdf(File inputHtml, File outputPdf) throws IOException, InterruptedException {
    int exitCode = new ProcessBuilder("wkhtmltopdf", inputHtml.getPath(), outputPdf.getPath())
                .redirectErrorStream(true)
                .start()
                .waitFor();
    assert exitCode == 0;
}
```

### References

- [LoicMahieu/alpine-wkhtmltopdf](https://github.com/LoicMahieu/alpine-wkhtmltopdf/blob/master/Dockerfile)
