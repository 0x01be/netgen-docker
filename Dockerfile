FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    tk-dev \
    m4 \
    python3-dev

RUN git clone git://opencircuitdesign.com/netgen /netgen

WORKDIR /netgen

RUN ./configure --prefix=/opt/netgen/
RUN make
RUN make install

FROM alpine:3.12.0

RUN apk add --no-cache --virtual runtime-dependencies \
    tcl \
    tk \
    xf86-video-dummy \
    xorg-server \
    bash

COPY ./xorg.conf /xorg.conf
#Xorg -noreset +extension GLX +extension RANDR +extension RENDER -logfile ./0.log -config ./xorg.conf :0
#ENV DISPLAY :0

COPY --from=builder /opt/netgen/ /opt/netgen/

ENV PATH /opt/netgen/bin/:$PATH

