FROM conjurinc/s3-url-signer

WORKDIR /app

ADD . /app

ENTRYPOINT [ "./start.sh" ]
