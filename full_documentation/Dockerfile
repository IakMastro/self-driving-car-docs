FROM hub.swarmlab.io:5480/xelatex-base:latest

ARG build_dir

LABEL \
  org.opencontainers.image.title="Docker Image of TeXLive" \
  org.opencontainers.image.authors="Swarmlab.io <rootapostolos@swarmlab.io>"

ENV PATH=/usr/local/texlive/bin/x86_64-linuxmusl:/usr/local/texlive/2020/bin/x86_64-linuxmusl:${PATH}

COPY \
  setup.sh \
  ${build_dir}/extrapackages \
  /

COPY ${build_dir}/fonts-extra/ /usr/share/fonts
COPY ${build_dir}/cls/ /usr/local/texlive/texmf-local/tex/latex/local
RUN /setup.sh

WORKDIR /home
VOLUME ["/home"]

CMD ["tail","-f","/dev/null"]
