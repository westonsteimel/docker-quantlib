FROM alpine:3.4
LABEL description="QuantLib on Alpine Linux."

ARG QUANTLIB_VERSION=1.12
ARG CONCURRENT_PROCESSES
ARG QUANTLIB_DIR=QuantLib
ENV QUANTLIB_VERSION ${QUANTLIB_VERSION}

RUN mkdir -p ${QUANTLIB_DIR} \
    && apk --no-cache add --virtual .build-dependencies \
    linux-headers \
    build-base \
    automake \
    autoconf \
    libtool \
    curl \
    tar \
    boost-dev \
    && curl -sL --retry 3 http://downloads.sourceforge.net/project/quantlib/QuantLib/${QUANTLIB_VERSION}/QuantLib-${QUANTLIB_VERSION}.tar.gz | \
    tar -xz --strip 1 -C ${QUANTLIB_DIR}/ \
    && cd ${QUANTLIB_DIR} \
    && sh autogen.sh \
    && ./configure  --disable-benchmark CXXFLAGS=-O3 \
    && make -j ${CONCURRENT_PROCESSES} && make install && ldconfig ./ \
    && cd .. && rm -rf ${QUANTLIB_DIR} \
    && apk del .build-dependencies \
    && rm -rf /var/cache/*

CMD ["sh"]
