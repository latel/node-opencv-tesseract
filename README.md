# node-opencv-tesseract
self-host node docker image with built opencv and tesseract

## build

```sh
docker build . --platform linux/amd64 -t node-opencv-tesseract
```

## run

```sh
docker run -d -v $(pwd)/src:/app/ node-opencv-tesseract
```


## References

- https://docs.opencv.org/4.x/d7/d9f/tutorial_linux_install.html#tutorial_linux_install_detailed_basic_compiler
- https://github.com/opencv/opencv/wiki/BuildOpenCV4OpenVINO
- https://docs.openvino.ai/2022.3/openvino_docs_install_guides_installing_openvino_from_archive_linux.html#doxid-openvino-docs-install-guides-installing-openvino-from-archive-linux