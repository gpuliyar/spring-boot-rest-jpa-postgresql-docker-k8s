FROM python:3.4-alpine3.8
LABEL maintainer="GP"
RUN pip3 install tavern
WORKDIR /test
COPY test_1.tavern.yaml /test/
ENTRYPOINT [ "py.test", "test_1.tavern.yaml", "-v" ] 