# FROM rafaelsoares/archlinux
# FROM pritunl/archlinux
FROM scratch

ARG root_date
ADD roots/archlinux-${root_date}.tar.xz /

RUN pacman -S --noconfirm \
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

RUN pacman -S --noconfirm \
        imagemagick \
        ghostscript \
        ffmpeg

RUN pacman -S --noconfirm \
        texlive-most \
        texlive-lang \
        biber \
        rubber

RUN pacman -S --noconfirm \
        sagemath

# RUN pacman -S --noconfirm texlive-core
# RUN pacman -S --noconfirm --needed texlive-fontsextra
# RUN pacman -S --noconfirm --needed texlive-most
# RUN pacman -S --noconfirm texlive-lang
# RUN pacman -S --noconfirm biber rubber

RUN pacman -S --noconfirm \
        julia

RUN pacman -S --noconfirm \
        ipython \
        python-matplotlib \
        python-numpy \
        python-scipy \
        python-sympy \
        python-ipykernel \
        python2-ipykernel \
        jupyter \
        jupyter-notebook \
        ipython2-notebook \
        jupyter-nbconvert

RUN pacman -S --noconfirm \
        cython2 \
        gap-data \
        jmol \
        mathjax \
        python2-pkgconfig \
        sage-notebook \
        sage-notebook-exporter \
        sagemath-doc

RUN pacman -S --noconfirm vim vimpager \
 && ln -sf vim /usr/bin/vi \
 && ln -sf vim /usr/bin/view \
 && ln -sf vim /usr/bin/edit \
 && ln -sf vim.1.gz /usr/share/man/man1/vi.1.gz

ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini
ENTRYPOINT ["/bin/tini", "--"]

COPY python2.kernelspec /usr/share/jupyter/kernels/python2/kernel.json
COPY tinistart.sh /etc/tinistart.sh

ARG user=roi
#RUN groupadd -g 20 staff \
#RUN useradd -u 501 -g 20 -m ${user}
RUN useradd -m ${user}
USER ${user}
WORKDIR /home/${user}

RUN mkdir .sage \
 && sage -c "print 0"

EXPOSE 8888

CMD [ "/bin/bash", "/etc/tinistart.sh" ]
# CMD [ "/usr/sbin/jupyter", \
#         "notebook", \
#         "--no-browser", \
#         "--port=8888" , \
#         "--ip=0.0.0.0" ]
