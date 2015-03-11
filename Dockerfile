FROM ruby:2.0

RUN apt-get update && \
    apt-get install build-essential -yqq && \
    gem install aws-sdk-v1 --no-rdoc --no-ri && \
    gem install gli --version 2.12.2 --no-rdoc --no-ri && \
    gem install conjur-cli --version 4.19.0 --no-rdoc --no-ri

ENV BUCKET_NAME     conjur-dev-lxc-images
ENV DEFAULT_VERSION 2015-03-05_165528
ENV CONJUR_ACCOUNT  conjurops
ENV CONJUR_APPLIANCE_URL  https://conjur-master.itp.conjur.net/api

WORKDIR /

ADD start.sh /start.sh
ADD app.rb /app.rb
ADD get.secrets /get.secrets

ENTRYPOINT [ "/start.sh" ]
