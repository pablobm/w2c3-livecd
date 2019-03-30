FROM debian:stretch-slim

WORKDIR /workspace

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y make live-build git imagemagick

COPY . /workspace

#CMD ["make"]
CMD make && mv live-image-*.iso /output/ && ls /output
