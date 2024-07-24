#!/bin/bash
set -e

# Setup getopt.
long_opts="train:,val:,classes:,batch_size:,epoch:,weights:,save_model_path:"
getopt_cmd=$(getopt -o da: --long "$long_opts" \
            -n $(basename $0) -- "$@") || \
            { echo -e "\nERROR: Getopt failed. Extra args\n"; exit 1;}

eval set -- "$getopt_cmd"
while true; do
    case "$1" in
        -t|--train) echo "train is $2" && train=$2;;
        -v|--val) echo "val is $2" && val=$2;;
        -c|--classes) echo "classes is $2" && classes=$2;;
        -b|--batch_size) echo "batch_size is $2" && batch_size=$2;;
        -e|--epoch) echo "epoch is $2" && epoch=$2;;
        -w|--weights) echo "weights is $2" && weights=$2;;
        -s|--save_model_path) echo "save_model_path is $2" && save_model_path=$2;;
        --) shift; break;;
    esac
    shift
done

# Assuming save_config.py is compatible or has been adjusted for YOLOv5.
python3 save_config.py --train $train --val $val --classes $classes

# Training command for YOLOv5.
python train.py --img 640 --batch $batch_size --epochs $epoch --data $train --weights $weights

# Cleanup and saving the model.
rm -rf $save_model_path
mkdir -p $(dirname $save_model_path)
cp runs/train/exp/weights/best.pt $save_model_path
