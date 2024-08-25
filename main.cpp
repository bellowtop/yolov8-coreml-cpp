#include "objc_wrapper.h"

#include <chrono>
#include <iostream>
#include <opencv2/opencv.hpp>
#include <stdlib.h>
#include <strings.h>
#include <vector>

template <typename clock_t = std::chrono::steady_clock,
          typename duration_t = std::chrono::milliseconds,
          typename timep_t = std::chrono::time_point<clock_t, duration_t>>
std::tuple<timep_t, duration_t> now_time_since(timep_t const& start) {
    auto now = clock_t::now();
    return {now, std::chrono::duration_cast<duration_t>(now - start)};
}

struct DetectionBox {
    float centerX;
    float centerY;
    float width;
    float height;
    float confidence;
};

float computeIOU(const DetectionBox& boxA, const DetectionBox& boxB) {
    float xA = std::max(boxA.centerX - boxA.width / 2, boxB.centerX - boxB.width / 2);
    float yA = std::max(boxA.centerY - boxA.height / 2, boxB.centerY - boxB.height / 2);
    float xB = std::min(boxA.centerX + boxA.width / 2, boxB.centerX + boxB.width / 2);
    float yB = std::min(boxA.centerY + boxA.height / 2, boxB.centerY + boxB.height / 2);

    float interArea = std::max(0.0f, xB - xA) * std::max(0.0f, yB - yA);
    float boxAArea = boxA.width * boxA.height;
    float boxBArea = boxB.width * boxB.height;
    float iou = interArea / (boxAArea + boxBArea - interArea);

    return iou;
}

std::vector<int> nonMaxSuppression(const std::vector<DetectionBox>& boxes, float iouThreshold) {
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

    std::string imagePath = "data/test_image_5_person.jpeg";
    cv::Mat mat = cv::imread(imagePath);

    auto t1 = std::chrono::steady_clock::now();
    predictWith(yolov8model, mat, outFloats);
    auto [t2, used_ms] = now_time_since(t1);
    printf("yolov8 coreml predict use time: %lld ms\n", used_ms.count());

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
                auto box = DetectionBox{centerX, centerY, width, height, confidence};
                candidateBoxes.push_back(box);
            }
        }
        // }
    }

    auto outMat = mat.clone();
    float factorX = mat.cols * 1.0f / 640;
    float factorY = mat.rows * 1.0f / 640;

    auto keep = nonMaxSuppression(candidateBoxes, 0.9);
    for (auto i : keep) {
        auto box = candidateBoxes[i];
        std::cout << "Box[ centerX: " << box.centerX << ", centerY: " << box.centerY << ", width: " << box.width
                  << ", height:" << box.height << " ], Conf: " << box.confidence << std::endl;

        cv::Point topLeft(box.centerX - box.width / 2, box.centerY - box.height / 2);
        cv::Point bottomRight(box.centerX + box.width / 2, box.centerY + box.height / 2);

        // actual image size is bigger than 640;
        topLeft.x = static_cast<int>(topLeft.x * factorX);
        topLeft.y = static_cast<int>(topLeft.y * factorY);
        bottomRight.x = static_cast<int>(bottomRight.x * factorX);
        bottomRight.y = static_cast<int>(bottomRight.y * factorY);

        cv::Scalar color(0, 0, 255);
        int thickness = 2;
        cv::rectangle(outMat, topLeft, bottomRight, color, thickness);
    }

    cv::imshow("Image 0", outMat);
    cv::waitKey(0); // 等待按键按下

    closeModel(yolov8model);
}
