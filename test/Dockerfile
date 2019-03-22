FROM python:3.4.10-alpine3.8
LABEL maintainer="GP"
RUN pip3 install tavern
WORKDIR /test
COPY test_1.tavern.yaml /test/
RUN sed -i 's/{{host}}/$HOST_ADDRESS/g'
ENTRYPOINT [ "py.test", "test_1.tavern.yaml", "-v" ]
