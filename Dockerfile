FROM fedora:25
MAINTAINER CTA LAPP <cta-pipeline-lapp@in2p3.fr>

RUN echo 'check-update' ; dnf check-update -yv \
 && echo 'distro-sync' ; dnf distro-sync -yv \
 && echo 'install C Dev' ; dnf group install -yv 'C Development Tools and Libraries' \
 && echo 'install dDev tools'; dnf group install -yv 'Development Tools' \
 && dnf install -y wget bzip2 bzip2-devel libXext libSM libXrender cmake graphviz hdf5 hdf5-devel

ARG MINICONDA_VERSION=4.3.11

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` \
 && curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.rpm" > tini.rpm \
 && rpm -i tini.rpm \
 && rm tini.rpm

ENV PATH /opt/conda/bin:$PATH
ENV LANG en_US.utf8

ENTRYPOINT [ "/usr/bin/tini", "--" ]
