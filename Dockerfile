FROM ubuntu:18.04

ENV gid 1000
ENV uid 1000
ENV USER s3cmd

RUN apt-get -y update \
    && apt-get -y install locales software-properties-common sudo \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && dpkg-reconfigure --frontend=noninteractive locales

RUN add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get -y install python3.7 python3-pip p7zip-full \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd -m -u $uid $USER \
    && chown -R 1000:1000 /home/$USER \
    && echo "%${USER} ALL=(ALL) ALL" >> /etc/sudoers \
    && echo "%${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && pip3 install s3cmd \
    && mkdir -p /data \
    && chown -R 1000:1000 /data

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ADD --chown=1000:1000 ./.s3cfg /home/$USER
ADD --chown=1000:1000 ./entrypoint.sh /usr/local/bin

RUN chmod 777 /usr/local/bin/entrypoint.sh \
    && ln -s /usr/local/bin/entrypoint.sh /

USER $USER
WORKDIR /home/$USER

ENTRYPOINT [ "entrypoint.sh" ]