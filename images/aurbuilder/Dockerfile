
FROM roidocampo/arch-base

RUN useradd -m aurbuilder
RUN echo "aurbuilder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER aurbuilder
WORKDIR /home/aurbuilder

COPY aur_build.sh /home/aurbuilder/aur_build.sh

CMD [ "/bin/bash" ]
