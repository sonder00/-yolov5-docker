FROM ccr.ccs.tencentyun.com/cube-studio/ubuntu-gpu:cuda11.8.0-cudnn8-python3.9
COPY sources.list /etc/apt/sources.list
RUN apt update -y
RUN git clone -b v7.0 --single-branch https://github.com/ultralytics/yolov5.git
WORKDIR /yolov5
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple
RUN pip cache purge && apt-get install -y python3-opencv && pip install -r requirements.txt
RUN pip install gradio==4.15.0 uvicorn --index-url https://mirrors.aliyun.com/pypi/simple
# 下载预训练模型
RUN mkdir -p weights && wget -O weights/yolov5m.pt https://github.com/ultralytics/yolov5/releases/download/v7.0/yolov5m.pt
# 拷贝配置文件
COPY . /yolov5/

RUN chmod 777 launcher.sh
ENTRYPOINT ["bash","launcher.sh"]

# 测试预训练模型推理
# python detect.py --weights weights/yolov5m.pt --img 640 --conf 0.25 --source data/images

# 测试微调
# python train.py --img 640 --batch 16 --epochs 3 --data coco128.yaml --weights weights/yolov5m.pt

# 微调后推理
# python detect.py --weights runs/train/exp/weights/best.pt --img 640 --conf 0.25 --source data/images


