FROM westonsteimel/boost:alpineedge
LABEL description="QuantLib on Alpine Linux."

ARG QUANTLIB_VERSION=1.16
ARG QUANTLIB_CHECKSUM=204ad5822259f9a9146eaf660f0b756100604e3adb85c501d41d201bf09dec94
ARG CONCURRENT_PROCESSES=1
ARG QUANTLIB_DIR=QuantLib
ENV QUANTLIB_VERSION ${QUANTLIB_VERSION}

RUN mkdir -p ${QUANTLIB_DIR} \
    && addgroup quantlib \
    && adduser -G quantlib -s /bin/sh -D quantlib \
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

LABEL org.opencontainers.image.title="QuantLib" \
    org.opencontainers.image.description="QuantLib on Alpine Linux in Docker" \ 
    org.opencontainers.image.url="https://github.com/westonsteimel/docker-quantlib" \ 
    org.opencontainers.image.source="https://github.com/westonsteimel/docker-quantlib" \
    org.opencontainers.image.version="${QUANTLIB_VERSION}"

