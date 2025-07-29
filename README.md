# YOLO-on-Jetson-Nano
This repository can be use for Jetson Nano, AGX Xavier, Orin Nano super (developer kit)
## Prepare Ultralytics Docker
You can find it on Ultralytics website (based on your device's jetpack)
 <pre>
  t=ultralytics/ultralytics:latest-jetson-jetpack4
  sudo docker pull $t && sudo docker run -it --ipc=host --runtime=nvidia $t </pre>
Or you can download my Docker Image, I built OpenCV with Gstreamer in it 
<prep></prep>

## Build OpenCV in Docker container
<pre> ./build_opencv </pre>

After these two setting, you can use YOLO on your Jetson nano 
