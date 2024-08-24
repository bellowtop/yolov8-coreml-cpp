this repo is an example to show how to use apple CoreML to run yolov8-face model inference.
although it use [yolo-face] (https://github.com/akanametov/yolo-face),
but it should be applicable to other yolo family models as well.



## Build app

```
git clone https://github.com/sekirocc/yolov8-coreml-cpp.git
cd yolov8-coreml-cpp

# build
cmake -B build .
cmake --build build

# run inference
./build/coremlapp
```

note that this repo already contains `yolov8n_face_relu6` coreml model, so it's ready to inference

## Prepare model

below are the steps I use to prepare the coreml model.

first download model file from [link]( https://github.com/akanametov/yolov8-face/releases/download/v0.0.0/yolov8m-face.pt )

```
from ultralytics import YOLO
model = YOLO("/path/to/downloaded/yolov8n_face_relu6.pt")
model.export(format="coreml")
```

this will export ml model to file `/path/to/downloaded/yolov8n_face_relu6.mlpackage`,
just alongside the original `pt` model.

copy the model file to `coreml` folder and compile the model.

```
cd yolov8-coreml-cpp
cd coreml
cp -r /path/to/downloaded/yolov8n_face_relu6.mlpackage .

xcrun coremlc compile yolov8n_face_relu6.mlpackage .
xcrun coremlc generate yolov8n_face_relu6.mlpackage .
```

now xcrun will generate two files,

* yolov8n_face_relu6.h
* yolov8n_face_relu6.m

they containing the model input/output definitions.

our `objcWrapper.mm` use these definitions to interact with model.
