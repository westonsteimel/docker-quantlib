FROM quay.io/boost:alpine3.7
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
    && curl -sL --retry 3 https://github.com/lballabio/QuantLib/releases/download/QuantLib-v${QUANTLIB_VERSION}/QuantLib-${QUANTLIB_VERSION}.tar.gz | \
    tar -xz --strip 1 -C ${QUANTLIB_DIR}/ \
    && cd ${QUANTLIB_DIR} \
    && sh autogen.sh \
    && ./configure  --disable-benchmark CXXFLAGS=-O3 \
    && make -j ${CONCURRENT_PROCESSES} && make install && ldconfig ./ \
    && cd .. && rm -rf ${QUANTLIB_DIR} \
    && apk del .build-dependencies \
    && rm -rf /var/cache/*

CMD ["sh"]
