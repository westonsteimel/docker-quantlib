FROM westonsteimel/boost:1.66.0-alpine3.7
LABEL description="QuantLib on Alpine Linux."

ARG QUANTLIB_VERSION=1.11
ARG QUANTLIB_DIR=QuantLib
ENV QUANTLIB_VERSION ${QUANTLIB_VERSION}

RUN mkdir -p ${QUANTLIB_DIR} \
    && apk add --no-cache --virtual .build-dependencies \
    linux-headers \
    build-base \
    automake \
    autoconf \
    libtool \
    curl \
    && curl -sL --retry 3 http://downloads.sourceforge.net/project/quantlib/QuantLib/${QUANTLIB_VERSION}/QuantLib-${QUANTLIB_VERSION}.tar.gz | \
    tar -xz --strip 1 -C ${QUANTLIB_DIR}/ \
    && cd ${QUANTLIB_DIR} \
    && sh autogen.sh \
    && ./configure --prefix=/usr --disable-static --disable-examples --disable-benchmark CXXFLAGS=-O3 \
    && make -j 4 && make install && ldconfig ./ \
    && cd .. && rm -rf ${QUANTLIB_DIR} \
    && apk del .build-dependencies

CMD sh
