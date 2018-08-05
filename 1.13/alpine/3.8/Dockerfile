FROM quay.io/westonsteimel/boost:alpine3.8
LABEL description="QuantLib on Alpine Linux."

ARG QUANTLIB_VERSION=1.13
ARG QUANTLIB_CHECKSUM=bb52df179781f9c19ef8e976780c4798b0cdc4d21fa72a7a386016e24d1a86e6
ARG CONCURRENT_PROCESSES=1
ARG QUANTLIB_DIR=QuantLib
ENV QUANTLIB_VERSION ${QUANTLIB_VERSION}

RUN mkdir -p ${QUANTLIB_DIR} \
    && addgroup -g 1000 quantlib \
    && adduser -u 1000 -G quantlib -s /bin/sh -D quantlib \
    && apk --no-cache add libstdc++ \
    && apk --no-cache add --virtual .build-dependencies \
    linux-headers \
    build-base \
    automake \
    autoconf \
    libtool \
    curl \
    tar \
    && cd ${QUANTLIB_DIR} \
    && curl -L --retry 3 "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v${QUANTLIB_VERSION}/QuantLib-${QUANTLIB_VERSION}.tar.gz" -o quantlib.tar.gz \
    && echo "${QUANTLIB_CHECKSUM}  quantlib.tar.gz" | sha256sum -c \
    && tar -xzf quantlib.tar.gz --strip 1 \
    && sh autogen.sh \
    && ./configure --disable-static --disable-benchmark CXXFLAGS=-O3 \
    && make -j ${CONCURRENT_PROCESSES} && make install && ldconfig ./ \
    && cd .. && rm -rf ${QUANTLIB_DIR} \
    && apk del .build-dependencies \
    && rm -rf /var/cache/*

USER quantlib

CMD ["sh"]
