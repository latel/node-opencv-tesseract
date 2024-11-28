FROM node:22.11.0-bullseye
WORKDIR /app
RUN echo "deb http://mirrors.aliyun.com/debian bullseye main" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian bullseye-updates main" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security bullseye-security main" >> /etc/apt/sources.list \
    rm -rf /var/lib/apt/lists/*
RUN apt update
RUN apt install -y tesseract-ocr
RUN apt install -y libopencv-dev
RUN pkg-config --modversion opencv4
ENV OPENCV4NODEJS_DISABLE_AUTOBUILD=1
ENV OPENCV_LIB_DIR=/usr/
# ENV OPENCV_INCLUDE_DIR=/usr/include/opencv4
RUN apt clean && rm -rf /var/lib/apt/lists/*
ADD src /app/
# RUN pkg-config --modversion opencv4
# RUN dpkg -l libopencv-dev
# RUN dpkg -L libopencv-dev
# RUN find /usr/include -name "opencv*"
RUN npm i