FROM --platform=linux/amd64 ubuntu:24.04

ARG userid
ARG groupid
ARG username

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install openjdk-11-jdk git python3 bison flex git bc build-essential curl g++-multilib gcc-multilib lib32ncurses-dev lib32readline-dev


RUN groupadd -g $groupid $username \
    && useradd -m -u $userid -g $groupid $username \
    && echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo $username >/root/username \
    && echo "$username:$username" | chpasswd && adduser $username sudo


ENV HOME=/home/$username \
    USER=$username \
    PATH=/src/.repo/repo:/src/prebuilts/jdk/jdk21/linux-x86/bin/:$PATH


ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i
