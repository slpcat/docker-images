#upstream https://github.com/docker-library/tomcat/tree/master/8.5/jre8
FROM slpcat/oraclejdk:8-centos7

MAINTAINER 若虚 <slpcat@qq.com>

RUN \
    yum update -y \
    && yum install -y gcc gcc-c++ autoconf automake make which zlib zlib-devel pcre-devel apr-devel openssl-devel wget curl gnupg

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
# see also "versions.sh" (https://github.com/docker-library/tomcat/blob/master/versions.sh)
ENV GPG_KEYS 05AB33110949707C93A279E3D3EFE6B686867BA6 07E48665A34DCAFAE522E5E6266191C37C037D42 47309207D818FFD8DCD3F83F1931D684307A10A5 541FBE7D8F78B25E055DDEE13C370389288584E7 5C3C5F3E314C866292F359A8F3AD5C94A67F707E 765908099ACF92702C7D949BFA0C35EA8AA299F1 79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED 9BA44C2621385CB966EBA586F72C284D731FABEE A27677289986DB50844682F8ACB77FC2E86E29AC A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.95
ENV TOMCAT_SHA512 1c36d0de6ef0c1bab090bfb30908f8cf848510ab83d6140890e2e1db001e8a4d0d5982a53c92e4cc7a736de304b22f461706689c48160e24c299dae7a148a673

RUN set -eux; \
	\
# http://yum.baseurl.org/wiki/YumDB.html
	if ! command -v yumdb > /dev/null; then \
		yum install -y --setopt=skip_missing_names_on_install=False yum-utils; \
		yumdb set reason dep yum-utils; \
	fi; \
# a helper function to "yum install" things, but only if they aren't installed (and to set their "reason" to "dep" so "yum autoremove" can purge them for us)
	_yum_install_temporary() { ( set -eu +x; \
		local pkg todo=''; \
		for pkg; do \
			if ! rpm --query "$pkg" > /dev/null 2>&1; then \
				todo="$todo $pkg"; \
			fi; \
		done; \
		if [ -n "$todo" ]; then \
			set -x; \
			yum install -y --setopt=skip_missing_names_on_install=False $todo; \
			yumdb set reason dep $todo; \
		fi; \
	) }; \
	_yum_install_temporary gzip tar; \
	\
	ddist() { \
		local f="$1"; shift; \
		local distFile="$1"; shift; \
		local mvnFile="${1:-}"; \
		local success=; \
		local distUrl=; \
		for distUrl in \
# https://issues.apache.org/jira/browse/INFRA-8753?focusedCommentId=14735394#comment-14735394
			"https://www.apache.org/dyn/closer.cgi?action=download&filename=$distFile" \
# if the version is outdated (or we're grabbing the .asc file), we might have to pull from the dist/archive :/
			"https://downloads.apache.org/$distFile" \
			"https://www-us.apache.org/dist/$distFile" \
			"https://www.apache.org/dist/$distFile" \
			"https://archive.apache.org/dist/$distFile" \
# if all else fails, let's try Maven (https://www.mail-archive.com/users@tomcat.apache.org/msg134940.html; https://mvnrepository.com/artifact/org.apache.tomcat/tomcat; https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/)
			${mvnFile:+"https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/$mvnFile"} \
		; do \
			if curl -fL -o "$f" "$distUrl" && [ -s "$f" ]; then \
				success=1; \
				break; \
			fi; \
		done; \
		[ -n "$success" ]; \
	}; \
	\
	ddist 'tomcat.tar.gz' "tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz" "$TOMCAT_VERSION/tomcat-$TOMCAT_VERSION.tar.gz"; \
	echo "$TOMCAT_SHA512 *tomcat.tar.gz" | sha512sum --strict --check -; \
	ddist 'tomcat.tar.gz.asc' "tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc" "$TOMCAT_VERSION/tomcat-$TOMCAT_VERSION.tar.gz.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	for key in $GPG_KEYS; do \
		gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
	done; \
	gpg --batch --verify tomcat.tar.gz.asc tomcat.tar.gz; \
	tar -xf tomcat.tar.gz --strip-components=1; \
	rm bin/*.bat; \
	rm tomcat.tar.gz*; \
	rm -rf "$GNUPGHOME"; \
	\
# https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Default_web_applications
	mv webapps webapps.dist; \
	mkdir webapps; \
# we don't delete them completely because they're frankly a pain to get back for users who do want them, and they're generally tiny (~7MB)
	\
	nativeBuildDir="$(mktemp -d)"; \
	tar -xf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1; \
	_yum_install_temporary \
		apr-devel \
		gcc \
		make \
		openssl11-devel \
	; \
	( \
		export CATALINA_HOME="$PWD"; \
		cd "$nativeBuildDir/native"; \
		aprConfig="$(command -v apr-1-config)"; \
		./configure \
			--libdir="$TOMCAT_NATIVE_LIBDIR" \
			--prefix="$CATALINA_HOME" \
			--with-apr="$aprConfig" \
			--with-java-home="$JAVA_HOME" \
			--with-ssl \
		; \
		nproc="$(nproc)"; \
		make -j "$nproc"; \
		make install; \
	); \
	rm -rf "$nativeBuildDir"; \
	rm bin/tomcat-native.tar.gz; \
	\
# mark any explicit dependencies as manually installed
	find "$TOMCAT_NATIVE_LIBDIR" -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ && $(NF-1) != "=>" { print $(NF-1) }' \
		| xargs -rt readlink -e \
		| sort -u \
		| xargs -rt rpm --query --whatprovides \
		| sort -u \
		| tee "$TOMCAT_NATIVE_LIBDIR/.dependencies.txt" \
		| xargs -r yumdb set reason user \
	; \
	\
# clean up anything added temporarily and not later marked as necessary
	yum autoremove -y; \
	yum clean all; \
	rm -rf /var/cache/yum; \
	\
# sh removes env vars it doesn't support (ones with periods)
# https://github.com/docker-library/tomcat/issues/77
	find ./bin/ -name '*.sh' -exec sed -ri 's|^#!/bin/sh$|#!/usr/bin/env bash|' '{}' +; \
	\
# fix permissions (especially for running as non-root)
# https://github.com/docker-library/tomcat/issues/35
	chmod -R +rX .; \
	chmod 1777 logs temp work; \
	\
# smoke test
	catalina.sh version

# verify Tomcat Native is working properly
RUN set -eux; \
	nativeLines="$(catalina.sh configtest 2>&1)"; \
	nativeLines="$(echo "$nativeLines" | grep 'Apache Tomcat Native')"; \
	nativeLines="$(echo "$nativeLines" | sort -u)"; \
	if ! echo "$nativeLines" | grep -E 'INFO: Loaded( APR based)? Apache Tomcat Native library' >&2; then \
		echo >&2 "$nativeLines"; \
		exit 1; \
	fi

EXPOSE 8080
CMD ["catalina.sh", "run"]
