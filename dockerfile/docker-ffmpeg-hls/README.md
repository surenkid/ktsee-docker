This docker image is created for converting mp4 video files (.mp4) to HLS format (.ts) files. When running, it will auto convert and generate a playlist file (platflist.m3u8) and a html video player (index.html), so that it can be played online.

The HLS format is CDN-friendly, and can be used to build large video projects for personal use.

## Usage
First, go to the folder that the mp4 video is located on, and run docker container to convert the video. When the conversion is complete, docker container will be automatically be deleted.

### Running under Linux or Mac:
```
docker run -it --rm \ 
    -e FTP_SERVER=你的FTP服务器 \
    -e FTP_USER=你的FTP用户名 \
    -e FTP_PASSWORD=你的FTP密码 \
    -e FTP_UPLOAD_DIR=FTP上传目录 \
    -e FTP_UPLOAD_PARALLEL=FTP连接线程数 \
    -e VIDEO_SEGMENT_TIME=视频分片时间长度 \
    -v $(pwd):/root/input surenkid/ffmpeg-hls
```

### Running under Windows
```
docker run -it --rm ^
    -e FTP_SERVER=你的FTP服务器 ^
    -e FTP_USER=你的FTP用户名 ^
    -e FTP_PASSWORD=你的FTP密码 ^
    -e FTP_UPLOAD_DIR=FTP上传目录 ^
    -e FTP_UPLOAD_PARALLEL=FTP连接线程数 ^
    -e VIDEO_SEGMENT_TIME=视频分片时间长度 ^
    -v %cd%:/root/input surenkid/ffmpeg-hls
```
