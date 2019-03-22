#!/usr/bin/env bash

sed -i 's/{{host}}/$HOST_ADDRESS/g' test_1.tavern.yaml
py.test test_1.tavern.yaml -v
