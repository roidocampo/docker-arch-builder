
FROM rafaelsoares/archlinux
# FROM dock0/build

RUN pacman -S --noconfirm \
        arch-install-scripts \
        expect

ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini
ENTRYPOINT ["/bin/tini", "--"]

COPY mkimage_src /root/mkimage_src

WORKDIR /root/mkimage_src

CMD [ "/bin/bash" ]
