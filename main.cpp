#include <stdlib.h>

#include <iostream>

#include "objcWrapper.h"
using namespace std;

int main() {
    const void* yolov8model = loadModel("coreml/yolov8n_face_relu6.mlmodelc");

    // alloc output buffer
    // output as 1 × 5 × 8400 3-dimensional array of floats
    float* outFloats = (float*)malloc(sizeof(float) * 1 * 5 * 8400);

    predictWith(yolov8model,
                "/Users/jiechen/Downloads/test_images/test_image.png",
                outFloats);

    // it should match
    // pytorch output: {'output': array([[[-0.28637695, -0.25561523, ...,
    // -0.10253906]]], dtype=float32)

    cout << outFloats[0] << " " << outFloats[1] << " ";

    closeModel(yolov8model);
}
