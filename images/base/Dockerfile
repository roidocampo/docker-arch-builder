FROM scratch

ARG root_date
ADD roots/archlinux-${root_date}.tar.xz /

RUN pacman -Syyuu --noconfirm

RUN pacman -S --noconfirm --needed \
        base-devel \
        sudo \
        bash-completion \
        bash-docs \
        tree \
        wget \
        htop \
        git \
        tig \
        mercurial \
        lua \
        python \
        python2 \
        ruby \
        tcl

RUN pacman -S --noconfirm vim vimpager \
 && ln -sf vim /usr/bin/vi \
 && ln -sf vim /usr/bin/view \
 && ln -sf vim /usr/bin/edit \
 && ln -sf vim.1.gz /usr/share/man/man1/vi.1.gz

ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini
ENTRYPOINT ["/bin/tini", "--"]

CMD [ "/bin/bash" ]
