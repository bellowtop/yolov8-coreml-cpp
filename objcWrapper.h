#include <opencv2/opencv.hpp>

#if __cplusplus
extern "C" {
#endif

const void* loadModel(const char* modelPath);
void closeModel(const void* model);
void predictWithImagePath(const void* model, const char* imagePath, float* encoderOutput);
void predictWith(const void* model, const cv::Mat& mat, float* encoderOutput);

#if __cplusplus
} // Extern C
#endif
