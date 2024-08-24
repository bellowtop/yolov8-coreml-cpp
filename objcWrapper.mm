#import "objcWrapper.h"

#import "coreml/yolov8n_face_relu6.h"

#import <Accelerate/Accelerate.h>
#import <AppKit/AppKit.h>
#import <CoreImage/CoreImage.h>
#import <CoreML/CoreML.h>
#include <opencv2/opencv.hpp>
#include <stdlib.h>

#if __cplusplus
extern "C" {
#endif

CVPixelBufferRef pixelBufferFromMat(const cv::Mat& mat) {
    // Ensure the cv::Mat is valid
    if (mat.empty()) {
        return NULL;
    }

    // Step 1: Determine the pixel format and size
    size_t width = mat.cols;
    size_t height = mat.rows;
    OSType pixelFormat = kCVPixelFormatType_32BGRA; // Assuming we are working with BGRA 8-bit format (OpenCV default)

    // Step 2: Create a CVPixelBufferRef
    CVPixelBufferRef pixelBuffer = NULL;

    NSDictionary* pixelBufferAttributes =
        @{(id)kCVPixelBufferCGImageCompatibilityKey : @YES,
          (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES};

    CVReturn status = CVPixelBufferCreate(
        kCFAllocatorDefault, width, height, pixelFormat, (__bridge CFDictionaryRef)pixelBufferAttributes, &pixelBuffer);

    if (status != kCVReturnSuccess || pixelBuffer == NULL) {
        NSLog(@"Failed to create CVPixelBuffer");
        return NULL;
    }

    // Step 3: Lock the pixel buffer
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);

    // Step 4: Get the pixel buffer base address and copy the data
    void* pixelBufferData = CVPixelBufferGetBaseAddress(pixelBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);

    // Ensure the cv::Mat data is continuous (important when copying)
    cv::Mat contiguousMat;
    if (!mat.isContinuous()) {
        contiguousMat = mat.clone();
    } else {
        contiguousMat = mat;
    }

    // Convert cv::Mat to the correct format if necessary (BGRA format for CVPixelBuffer)
    if (contiguousMat.type() == CV_8UC3) {
        // Convert BGR to BGRA
        cv::cvtColor(contiguousMat, contiguousMat, cv::COLOR_BGR2BGRA);
    }

    // Copy the data row by row from cv::Mat to CVPixelBufferRef
    for (size_t y = 0; y < height; y++) {
        memcpy((uint8_t*)pixelBufferData + y * bytesPerRow,
               contiguousMat.ptr(y),
               contiguousMat.cols * 4); // Assuming 4 channels per pixel
    }

    // Step 5: Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return pixelBuffer;
}

const void* loadModel(const char* modelPath) {
    NSString* modelPathStr = [[NSString alloc] initWithUTF8String:modelPath];
    NSURL* modelURL = [NSURL fileURLWithPath:modelPathStr];

    const void* model = CFBridgingRetain([[yolov8n_face_relu6 alloc] initWithContentsOfURL:modelURL error:nil]);
    return model;
}

void predictWithImagePath(const void* model, const char* imagePath, float* yoloOutput) {
    cv::Mat mat = cv::imread(imagePath);
    predictWith(model, mat, yoloOutput);
}

void predictWith(const void* model, const cv::Mat& mat, float* yoloOutput) {
    cv::Mat image;
    if (mat.cols != 640 || mat.rows != 640) {
        image = mat.clone();
        cv::resize(image, image, cv::Size(640, 640));
    } else {
        image = mat;
    }

    CVPixelBufferRef pixelBuffer = pixelBufferFromMat(image);
    yolov8n_face_relu6Output* modelOutput = [(__bridge id)model predictionFromImage:pixelBuffer error:nil];

    MLMultiArray* outMA = modelOutput.var_947;
    cblas_scopy((int)outMA.count, (float*)outMA.dataPointer, 1, yoloOutput, 1);
}

void closeModel(const void* model) { CFRelease(model); }

#if __cplusplus
} // Extern C
#endif
