#
# Setup Stage: install apps
#

FROM ubuntu:24.10 AS builder

ARG VERSION
ARG CHANNEL

ENV IB_GATEWAY_VERSION=${VERSION}
ENV IB_GATEWAY_RELEASE_CHANNEL=${CHANNEL}
ENV IBC_VERSION=3.23.0

# Prepare system
RUN apt-get update -y
RUN apt-get install --no-install-recommends --yes \
  wget \
  ca-certificates \
  unzip

WORKDIR /tmp/setup

# Install IB Gateway
RUN wget -O ibgateway-installer.sh \
  "https://github.com/sucsessyan/ib-gateway-docker/releases/download/ibgateway-${CHANNEL}%40${VERSION}/ibgateway-${VERSION}-standalone-linux-x64.sh"

RUN chmod a+x ./ibgateway-installer.sh
RUN ./ibgateway-installer.sh -q -dir /root/Jts/ibgateway/${VERSION}

COPY ./config/ibgateway/jts.ini /root/Jts/jts.ini

# Install IBC
RUN wget https://github.com/IbcAlpha/IBC/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip
RUN mkdir /root/ibc
RUN unzip ./IBCLinux-${IBC_VERSION}.zip -d /root/ibc
RUN chmod -R u+x /root/ibc/*.sh
RUN chmod -R u+x /root/ibc/scripts/*.sh
COPY ./config/ibc/config.ini.tmpl /root/ibc/config.ini.tmpl

# Copy scripts
COPY ./scripts /root/scripts

#
# Build Stage: production image
#

FROM ubuntu:24.10

ARG VERSION
ARG CHANNEL

ENV IB_GATEWAY_VERSION=${VERSION}
ENV IB_GATEWAY_RELEASE_CHANNEL=${CHANNEL}

WORKDIR /root

# Prepare system
RUN apt-get update -y
RUN apt-get install --no-install-recommends --yes \
  gettext \
  xvfb \
  libxslt-dev \
  libxrender1 \
  libxtst6 \
  libxi6 \
  libgtk2.0-bin \
  socat \
  x11vnc

# Copy files
COPY --from=builder /root/ .
RUN chmod a+x /root/scripts/*.sh
COPY --from=builder /usr/local/i4j_jres/ /usr/local/i4j_jres

# IBC env vars
ENV TWS_MAJOR_VRSN=${VERSION}
ENV TWS_PATH=/root/Jts
ENV IBC_PATH=/root/ibc
ENV IBC_INI=/root/ibc/config.ini
ENV TWOFA_TIMEOUT_ACTION=exit

# Start run script
CMD ["/root/scripts/run.sh"]