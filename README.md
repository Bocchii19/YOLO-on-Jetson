# YOLO-on-Jetson-Nano
## Prepare Ultralytics Jetpack 4 Docker
 <pre>
  t=ultralytics/ultralytics:latest-jetson-jetpack4
  sudo docker pull $t && sudo docker run -it --ipc=host --runtime=nvidia $t </pre>

## Build OpenCV in Docker container
<pre> ./build_opencv </pre>
