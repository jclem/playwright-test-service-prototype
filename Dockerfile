################################################
# Compile with:
#     sudo docker build -t microsoft/playwright:bionic -f Dockerfile.bionic .
#
# Run with:
#     sudo docker run -d -p --rm --name playwright microsoft/playwright:bionic
#
#################################################

FROM ubuntu:bionic

# 1. Install node12
RUN apt-get update && apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs

# 2. Install WebKit dependencies
RUN apt-get update && apt-get install -y libwoff1 \
                                         libopus0 \
                                         libwebp6 \
                                         libwebpdemux2 \
                                         libenchant1c2a \
                                         libgudev-1.0-0 \
                                         libsecret-1-0 \
                                         libhyphen0 \
                                         libgdk-pixbuf2.0-0 \
                                         libegl1 \
                                         libnotify4 \
                                         libxslt1.1 \
                                         libevent-2.1-6 \
                                         libgles2 \
                                         libvpx5

# 3. Install gstreamer and plugins to support video playback in WebKit.
RUN apt-get update && apt-get install -y gstreamer1.0-gl \
                                         gstreamer1.0-plugins-base \
                                         gstreamer1.0-plugins-good \
                                         gstreamer1.0-plugins-bad

# 4. Install Chromium dependencies

RUN apt-get update && apt-get install -y libnss3 \
                                         libxss1 \
                                         libasound2 \
                                         fonts-noto-color-emoji

# 5. Install Firefox dependencies

RUN apt-get update && apt-get install -y libdbus-glib-1-2 \
                                         libxt6

# 6. Install ffmpeg to bring in audio and video codecs necessary for playing videos in Firefox.

RUN apt-get update && apt-get install -y ffmpeg


# 7. (Optional) Install XVFB if there's a need to run browsers in headful mode
RUN apt-get update && apt-get install -y xvfb

COPY --chown=root:root . /app

RUN mkdir -p /app/artifacts
RUN mkdir -p /app/artifacts/screenshots

COPY scripts/test.sh /
USER root
ENTRYPOINT ["/test.sh"]
