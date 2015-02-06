FROM conjurinc/alpine

ADD rubygems.pem /usr/lib/ruby/2.0.0/rubygems/ssl_certs/rubygems.pem

RUN apk update && apk add ruby-bundler ruby-json

RUN gem install aws-sdk --no-rdoc --no-ri

ENV DEFAULT_VERSION 2015-02-03_215149

ADD download-link.rb /download-link.rb

ENTRYPOINT [ "ruby", "/download-link.rb" ]
