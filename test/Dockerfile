FROM python:3.4.10-alpine3.8
LABEL maintainer="GP"
RUN pip3 install tavern
WORKDIR /test
COPY test_1.tavern.yaml /test/
COPY start-test.sh /test/
RUN chmod +x start-test.sh
ENTRYPOINT [ "sh", "start-test.sh" ]
