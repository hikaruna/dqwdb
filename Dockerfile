FROM ubuntu as jq

RUN apt-get update && apt-get install -y \
jq \
&& apt-get clean
