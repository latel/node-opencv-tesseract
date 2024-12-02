# node-opencv-tesseract
self-host docker image with opencv(with opencv_contrib, intel_cl and openvino), tesseract and ffmpeg, tested only on x86.
personal use for node projects.

| module         | version |
|----------------|---------|
| node           |         |
| npm            |         |
| opencv_version |         |
| tesseract      |         |
| ffmpeg         |         |

## build

```shell
docker build . --platform linux/amd64 -t node-opencv-tesseract
```

## run

`$(pwd)` is your project directory with package.json(or package-lock.json), container will run `npm install` upon deployments.

```shell
docker run -d -v $(pwd):/app/ node-opencv-tesseract
```

### packages suggestions

- tesseract: use package 'tesseract.js'
- opencv: use package `opencv4nodejs-prebuilt-install` for node binding.

## References

- https://docs.opencv.org/4.x/d7/d9f/tutorial_linux_install.html#tutorial_linux_install_detailed_basic_compiler
- https://github.com/opencv/opencv/wiki/BuildOpenCV4OpenVINO
- https://docs.openvino.ai/2022.3/openvino_docs_install_guides_installing_openvino_from_archive_linux.html#doxid-openvino-docs-install-guides-installing-openvino-from-archive-linux