#include <opencv2/opencv.hpp>
#include <iostream>

// g++ test.cpp -o test -I/usr/local/include/opencv4 -L/usr/local/lib -lopencv_core -lopencv_imgcodecs -lopencv_highgui

int main() {
    cv::Mat img(100, 100, CV_8UC3, cv::Scalar(255, 0, 0));
    if (!img.empty()) {
        std::cout << "OpenCV is working!" << std::endl;
        return 0;
    }
    return -1;
}