FROM alpine as build

RUN apk add --no-cache --virtual netgen-build-dependencies \
    git \
    build-base \
    tk-dev \
    m4 \
    python3-dev

ENV REVISION master
RUN git clone --depth 1 --branch ${REVISION} git://opencircuitdesign.com/netgen /netgen

WORKDIR /netgen

RUN ./configure --prefix=/opt/netgen/
RUN make
RUN make install

FROM 0x01be/xpra

RUN apk add --no-cache --virtual netgen-runtime-dependencies \
    tcl \
    tk \
    bash \
    gtk+3.0

COPY --from=builder /opt/netgen/ /opt/netgen/

ENV USER=${USER} \
    PATH ${PATH}:/opt/netgen/bin/

