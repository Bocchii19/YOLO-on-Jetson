#!/bin/bash
set -e

# ==== Cấu hình phiên bản ====
OPENCV_VERSION="4.11.0"
NUMPY_VERSION="1.26.4"  # Tương thích với OpenCV

echo "Clean the previous build"
sudo apt remove -y libopencv-dev python3-opencv || true
sudo rm -rf ~/opencv ~/opencv_contrib ~/opencv_build

echo "Installing depencies"
sudo apt update
sudo apt install -y \
  build-essential cmake git pkg-config unzip yasm \
  libjpeg-dev libpng-dev libtiff-dev \
  libavcodec-dev libavformat-dev libswscale-dev \
  libxvidcore-dev libx264-dev libx265-dev \
  libgtk-3-dev libcanberra-gtk* \
  libatlas-base-dev gfortran \
  libv4l-dev v4l-utils \
  python3-dev python3-numpy python3-pip \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools

pip3 install --force-reinstall numpy==${NUMPY_VERSION}

cd ~
git clone -b ${OPENCV_VERSION} https://github.com/opencv/opencv.git
git clone -b ${OPENCV_VERSION} https://github.com/opencv/opencv_contrib.git

echo "Configuration"
mkdir -p ~/opencv_build && cd ~/opencv_build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
#      -D WITH_CUDA=ON \  #We cant build with cuda and cudnn in docker container, uncomment it if you build on host
#      -D WITH_CUDNN=ON \
      -D OPENCV_DNN_CUDA=ON \
      -D ENABLE_FAST_MATH=1 \
      -D CUDA_FAST_MATH=1 \
      -D WITH_CUBLAS=1 \
      -D WITH_GSTREAMER=ON \
      -D WITH_LIBV4L=ON \
      -D BUILD_opencv_python3=ON \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D PYTHON3_EXECUTABLE=$(which python3) \
      -D PYTHON3_INCLUDE_DIR=$(python3 -c "from sysconfig import get_paths as gp; print(gp()['include'])") \
      -D PYTHON3_PACKAGES_PATH=$(python3 -c "from sysconfig import get_paths as gp; print(gp()['purelib'])") \
      ..


make -j$(nproc)
sudo make install
sudo ldconfig
