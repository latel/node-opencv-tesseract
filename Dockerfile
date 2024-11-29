FROM ubuntu:24.10

WORKDIR /app

# RUN echo "deb http://mirrors.aliyun.com/debian bookworm main" > /etc/apt/sources.list && \
#     echo "deb http://mirrors.aliyun.com/debian bookworm-updates main" >> /etc/apt/sources.list && \
#     echo "deb http://mirrors.aliyun.com/debian-security bookworm-security main" >> /etc/apt/sources.list && \
#     rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install -y \
    tesseract-ocr \
    cmake \
    wget

# nodejs 22.x
WORKDIR /build/node
# RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
#     apt-get install -y nodejs
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash && \
#     export NVM_DIR="$HOME/.nvm" && \
#     [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
#     nvm install 22
# ENV NVM_DIR="$HOME/.nvm"
ADD node-v22.11.0-linux-x64.tar.xz /build/node
RUN cp -R /build/node/node-v22.11.0-linux-x64/* /usr/
RUN rm -rf /build/node

WORKDIR /build/intel_opencl
RUN wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17791.9/intel-igc-core_1.0.17791.9_amd64.deb && \
    wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17791.9/intel-igc-opencl_1.0.17791.9_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-level-zero-gpu-dbgsym_1.6.31294.12_amd64.ddeb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-level-zero-gpu_1.6.31294.12_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-opencl-icd-dbgsym_24.39.31294.12_amd64.ddeb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-opencl-icd_24.39.31294.12_amd64.deb && \
    wget https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/libigdgmm12_22.5.2_amd64.deb
RUN apt-get install -y ocl-icd-libopencl1
RUN dpkg -i *.deb
RUN rm -rf /build/intel_opencl

WORKDIR /build/openvino
RUN apt-get install -y gnupg
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN echo "deb https://apt.repos.intel.com/openvino/2024 ubuntu24 main" | tee /etc/apt/sources.list.d/intel-openvino-2024.list
RUN apt-get update
RUN apt-get install -y openvino-2024.5.0
RUN rm -rf /build/openvino

# build OpenCV
WORKDIR /build/opencv
RUN apt-get install -y unzip
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.x.zip && unzip opencv.zip && rm opencv.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.x.zip && unzip opencv_contrib.zip && rm opencv_contrib.zip
WORKDIR /build/opencv/build
RUN cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.x/modules \
          -DWITH_OPENCL=ON \
          -DWITH_OPENCL_SVM=ON \
          -DWITH_OPENCLAMDFFT=ON \
          -DWITH_OPENCLAMDBLAS=ON \
          -DWITH_VA_INTEL=ON \
          -DWITH_OPENVINO=ON \
          -DBUILD_opencv_python3=ON \
          -DBUILD_opencv_java=ON \
          -DBUILD_opencv_js=ON \
          -DWITH_FFMPEG=ON \
          -DWITH_TBB=ON \
          -DOPENCV_GENERATE_PKGCONFIG=ON \
    ../opencv-4.x
RUN cmake --build .
RUN make install
RUN rm -rf /build/opencv

ENV OPENCV4NODEJS_DISABLE_AUTOBUILD=1
ENV OPENCV_INCLUDE_DIR=/usr/local/include/opencv4/
ENV OPENCV_LIB_DIR=/usr/local/lib/
ENV OPENCV_BIN_DIR=/usr/local/bin/
ENV OPENCV4NODES_DEBUG_REQUIRE=1

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN npm cache clean --force

ADD src /app/
WORKDIR /app
CMD ["npm i && npm start"]