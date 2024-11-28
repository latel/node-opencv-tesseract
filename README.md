# node-opencv-tesseract
self-host node docker image with built opencv and tesseract

## build

```sh
docker build . --platform linux/amd64 -t node-opencv-tesseract
```

## run

```sh
docker run -d -v $(pwd)/index.js:/app/index.js node-opencv-tesseract
```