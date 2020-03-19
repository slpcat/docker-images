FROM centos:centos7
MAINTAINER schachr <schachr@github.com>

RUN \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y tar wget git libxml2-devel libxslt-devel mariadb mariadb-devel postgresql-devel wkhtmltopdf && \
    yum clean all && \
    # Prepare ruby for Snorby
    curl -#LO https://rvm.io/mpapis.asc && \
    gpg --import mpapis.asc && \
    curl --silent -L "https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer" | bash -s stable --ruby=1.9.3 && \
    source /usr/local/rvm/scripts/rvm && \
    source /etc/profile.d/rvm.sh && \
    export PATH=$PATH:/usr/local/rvm/rubies/ruby-1.9.3-p551/bin && \
    gem update --system && \
    # Install DAQ and Snort
    yum install -y https://snort.org/downloads/snort/daq-2.0.6-1.centos7.x86_64.rpm && \
    yum install -y https://snort.org/downloads/snort/snort-2.9.11.1-1.centos7.x86_64.rpm && \
    # Install Community rules
    wget -O /tmp/community-rules.tar.gz https://www.snort.org/downloads/community/community-rules.tar.gz && \
    mkdir -p /etc/snort/rules && \
    tar zxvf /tmp/community-rules.tar.gz -C /etc/snort/rules --strip-components=1 && \
    rm -f /tmp/community-rules.tar.gz && \
    # Install Snorby
    source /usr/local/rvm/scripts/rvm && \
    source /etc/profile.d/rvm.sh && \
    export PATH=$PATH:/usr/local/rvm/rubies/ruby-1.9.3-p551/bin && \
    git clone git://github.com/Snorby/snorby.git /usr/local/src/snorby && \
    sed -i "s/gem 'byebug'/gem 'pry-byebug', platform: [:ruby_20]/g" /usr/local/src/snorby/Gemfile && \
    cd /usr/local/src/snorby && bundle install ; bundle update do_mysql ; bundle update dm-mysql-adapter

    # Try to fix wkhtmltopdf
RUN \
    yum install -y https://bitbucket.org/wkhtmltopdf/wkhtmltopdf/downloads/wkhtmltox-0.13.0-alpha-7b36694_linux-centos7-amd64.rpm

COPY container-files /

ENV DB_ADDRESS=127.0.0.1 DB_USER=user DB_PASS=password SNORBY_CONFIG=/usr/local/src/snorby/config/snorby_config.yml OINKCODE=community

ENTRYPOINT ["/bootstrap.sh"]
