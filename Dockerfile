FROM ubuntu:devel

WORKDIR /data
COPY ./ /data

RUN ln -snf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime && echo Asia/Bangkok > /etc/timezone
RUN apt-get update --allow-unauthenticated
RUN apt-get install ffmpeg youtube-dl libopus-dev libsodium-dev curl -y
RUN curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh && mv luvi lit luvit /usr/local/bin
RUN lit install

CMD ["luvit", "main.lua"]