FROM node:22.11.0-bookworm

# 设置工作目录
WORKDIR /app

# 更新 apt 源并安装必要的工具
RUN echo "deb http://mirrors.aliyun.com/debian bookworm main" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian bookworm-updates main" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security bookworm-security main" >> /etc/apt/sources.list && \
    rm -rf /var/lib/apt/lists/*
RUN apt update
RUN apt install -y \
    tesseract-ocr \
    cmake

WORKDIR /build/intel_opencl
RUN wget -q https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17791.9/intel-igc-core_1.0.17791.9_amd64.deb && \
    wget -q https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.17791.9/intel-igc-opencl_1.0.17791.9_amd64.deb && \
    wget -q https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-level-zero-gpu-dbgsym_1.6.31294.12_amd64.ddeb && \
    wget -q https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-level-zero-gpu_1.6.31294.12_amd64.deb && \
    wget -q https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-opencl-icd-dbgsym_24.39.31294.12_amd64.ddeb && \
    wget -q https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/intel-opencl-icd_24.39.31294.12_amd64.deb && \
    wget -q https://github.com/intel/compute-runtime/releases/download/24.39.31294.12/libigdgmm12_22.5.2_amd64.deb
RUN apt install -y ocl-icd-libopencl1
RUN dpkg -i *.deb

# 构建 OpenCV
WORKDIR /build/opencv
RUN wget -qO opencv.zip https://github.com/opencv/opencv/archive/4.x.zip && unzip opencv.zip && rm opencv.zip
RUN wget -qO opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.x.zip && unzip opencv_contrib.zip && rm opencv_contrib.zip
WORKDIR /build/opencv/build
RUN cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.x/modules \
          -DWITH_OPENCL=ON \
          -DWITH_OPENCL_SVM=ON \
          -DWITH_OPENCLAMDFFT=ON \
          -DWITH_OPENCLAMDBLAS=ON \
          -DWITH_VA_INTEL=ON \
          ../opencv-4.x
RUN cmake --build .
RUN make install

# 设置环境变量
ENV OPENCV4NODEJS_DISABLE_AUTOBUILD=1
ENV OPENCV_INCLUDE_DIR=/build/opencv-4.x/include
ENV OPENCV_LIB_DIR=/build/build/lib
RUN apt clean && rm -rf /var/lib/apt/lists/*

# 应用部署
ADD src /app/
WORKDIR /app
RUN npm i
CMD ["npm", "start"]