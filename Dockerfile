FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  doxygen \
  git \
  libgeographic-dev \
  libgomp1 \
  libopenmpi-dev \
  openmpi-bin \
  openmpi-common \
  libhdf5-openmpi-10 \
  libhdf5-openmpi-dev \
  libpython2.7-dev \
  libpython2.7 \
  python2.7 \
  python-h5py \
  python-matplotlib \
  python-mpltoolkits.basemap \
  swig \
  vim \
  nano

RUN groupadd \
    --system \
    virtualquake \
  && useradd \
    --create-home \
    --gid virtualquake \
    --no-log-init \
    --system \
    virtualquake

WORKDIR /home/virtualquake

COPY . /home/virtualquake/vq

RUN cd vq \
  && mkdir -p build \
  && cd build \
  && cmake \
    -DGeographicLib_INCLUDE_DIRS="/usr/include/GeographicLib" \
    -DGeographicLib_LIBRARY_DIRS="/usr/lib/x86_64-linux-gnu/" \
    .. \
  && cmake --build . -- all  \
  && cmake --build . -- install \
  && mkdir /home/virtualquake/external_volume

COPY docker/virtualquake/entrypoint.sh /etc

ENTRYPOINT ["/bin/bash", "/etc/entrypoint.sh"]
