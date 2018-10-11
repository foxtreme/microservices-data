FROM ubuntu
RUN apt-get update && apt-get install -y curl
COPY bashrc /root/.bashrc
