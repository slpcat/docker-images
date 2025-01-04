FROM buildpack-deps:jessie-curl
RUN wget -O omnicore.tar.gz https://github.com/OmniLayer/omnicore/releases/download/v0.8.0/omnicore-0.8.0-x86_64-linux-gnu.tar.gz \
        && tar -xzvf omnicore.tar.gz \
        && cd omnicore-0.8.0/bin \
        && mv bitcoin-tx omnicore-cli omnicored omnicore-qt  /usr/local/bin \
        && apt-get update \
        && apt-get install net-tools
EXPOSE 8333 8332
WORKDIR /root/.bitcoin
ENTRYPOINT ["omnicored"]
