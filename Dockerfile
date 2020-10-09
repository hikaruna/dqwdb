FROM ubuntu as jq

RUN apt-get update && apt-get install -y \
locales \
&& apt-get clean -y && rm -rf /var/lib/apt/lists/* \
&& sed -i -e 's/# \(ja_JP.UTF-8\)/\1/' /etc/locale.gen \
&& locale-gen \
&& update-locale LANG=ja_JP.UTF-8

RUN apt-get update && apt-get install -y \
jq \
&& apt-get clean -y && rm -rf /var/lib/apt/lists/* \
