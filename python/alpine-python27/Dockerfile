FROM slpcat/alpine:3.19

ENV PATH="/usr/local/bin:$PATH" \
    PYTHONIOENCODING="UTF-8" \
    PYTHON_VERSION="2.7.18" \
    PYTHON_PIP_VERSION="19.0.3"

RUN apk add --virtual .build-deps ca-certificates bzip2-dev coreutils dpkg-dev dpkg findutils gcc gdbm-dev libc-dev libnsl-dev libressl-dev libtirpc-dev linux-headers make ncurses-dev pax-utils readline-dev sqlite-dev tcl-dev tk tk-dev zlib-dev \
 && wget -O /python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
 && mkdir -p /usr/src/python \
 && tar -xJC /usr/src/python --strip-components=1 -f /python.tar.xz \
 && rm /python.tar.xz \
 && cd /usr/src/python \
 && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && ./configure --build="$gnuArch" --enable-shared --enable-unicode=ucs4 \
 && make -j "$(nproc)" EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000" \
 && make install \
 && find /usr/local -type f -executable ! -name '*tkinter*' -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' | xargs -rt apk add --virtual .python-rundeps \
 && find /usr/local -depth \( -type d -a \( -name test -o -name tests \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) -exec rm -rf '{}' + \
 && cd / \
 && rm -rf /usr/src/python \
 && wget -O /get-pip.py "https://bootstrap.pypa.io/get-pip.py" \
 && python /get-pip.py --disable-pip-version-check --no-cache-dir "pip==$PYTHON_PIP_VERSION" \
 && find /usr/local -depth \( -type d -a \( -name test -o -name tests \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) -exec rm -rf '{}' + \
 && rm -f /get-pip.py \
 && apk del .build-deps

ONBUILD RUN apk update \
     && apk upgrade \
     && pip --no-cache-dir install --upgrade pip
