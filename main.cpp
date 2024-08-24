#include <stdlib.h>
#include <strings.h>

#include <iostream>
#include <vector>

#include "objcWrapper.h"
using namespace std;

struct DetectionBox {
    float centerX;
    float centerY;
    float width;
    float height;
    float confidence;
};

float computeIOU(const DetectionBox& boxA, const DetectionBox& boxB) {
    float xA =
        std::max(boxA.centerX - boxA.width / 2, boxB.centerX - boxB.width / 2);
    float yA = std::max(boxA.centerY - boxA.height / 2,
                        boxB.centerY - boxB.height / 2);
    float xB =
        std::min(boxA.centerX + boxA.width / 2, boxB.centerX + boxB.width / 2);
    float yB = std::min(boxA.centerY + boxA.height / 2,
                        boxB.centerY + boxB.height / 2);

    float interArea = std::max(0.0f, xB - xA) * std::max(0.0f, yB - yA);
    float boxAArea = boxA.width * boxA.height;
    float boxBArea = boxB.width * boxB.height;
    float iou = interArea / (boxAArea + boxBArea - interArea);

    return iou;
}

std::vector<int> nonMaxSuppression(const std::vector<DetectionBox>& boxes,
                                   float iouThreshold) {
    // std::vector<int> indices{static_cast<int>(boxes.size())};
    std::vector<int> indices(boxes.size());
    for (int i = 0; i < boxes.size(); i++) {
        indices[i] = i;
    }

    std::vector<int> keep;
    while (!indices.empty()) {
        int i = indices.front();
        keep.push_back(i);
        indices.erase(indices.begin());

        for (auto it = indices.begin(); it != indices.end();) {
            if (computeIOU(boxes[i], boxes[*it]) > iouThreshold) {
                indices.erase(it);
            } else {
                it++;
            }
        }
    }

    return keep;
}

int main() {
    const void* yolov8model = loadModel("coreml/yolov8n_face_relu6.mlmodelc");

    // alloc output buffer
    // output as 1 × 5 × 8400 3-dimensional array of floats
    float* outFloats = (float*)malloc(sizeof(float) * 1 * 5 * 8400);

    predictWith(yolov8model,
                "/Users/jiechen/Downloads/test_images/test_image_5_person.jpeg",
                outFloats);

    int batch = 1;
    int params = 5;
    int boxes = 8400;

    std::vector<DetectionBox> candidateBoxes;

    float threshold = 0.5;
    for (int i = 0; i < batch; i++) {
        std::cout << "Image " << i << std::endl;
        // for (int j = 0; j < params; j++) {
        for (int k = 0; k < boxes; k++) {
            float confidence = outFloats[i * 4 * boxes + 4 * boxes + k];
            if (confidence > threshold) {
                float centerX = outFloats[i * 0 * boxes + 0 * boxes + k];
                float centerY = outFloats[i * 1 * boxes + 1 * boxes + k];
                float width = outFloats[i * 2 * boxes + 2 * boxes + k];
                float height = outFloats[i * 3 * boxes + 3 * boxes + k];
                auto box =
                    DetectionBox{centerX, centerY, width, height, confidence};
                candidateBoxes.push_back(box);
            }
        }
        // }
    }

    auto keepIdx = nonMaxSuppression(candidateBoxes, 0.9);
    for (auto i : keepIdx) {
        auto box = candidateBoxes[i];
        std::cout << "Box[ centerX: " << box.centerX
                  << ", centerY: " << box.centerY << ", width: " << box.width
                  << ", height:" << box.height << " ], Conf: " << box.confidence
                  << std::endl;
    }

    closeModel(yolov8model);
}
