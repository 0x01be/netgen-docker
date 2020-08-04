FROM 0x01be/alpine:edge as builder

RUN apk add --no-cache --virtual netgen-build-dependencies \
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

FROM 0x01be/xpra

RUN apk add --no-cache --virtual netgen-runtime-dependencies \
    tcl \
    tk \
    bash \
    gtk+3.0

COPY --from=builder /opt/netgen/ /opt/netgen/

ENV PATH /opt/netgen/bin/:$PATH

EXPOSE 10000

CMD /usr/bin/xpra start --bind-tcp=0.0.0.0:10000 --html=on --start-child=netgen --exit-with-children --daemon=no --xvfb="/usr/bin/Xvfb +extension  Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no --mdns=no:

