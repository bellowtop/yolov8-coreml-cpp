//
// yolov8n_face_relu6.m
//
// This file was automatically generated and should not be edited.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with automatic reference counting enabled (-fobjc-arc)
#endif

#import "yolov8n_face_relu6.h"

@implementation yolov8n_face_relu6Input

- (instancetype)initWithImage:(CVPixelBufferRef)image {
    self = [super init];
    if (self) {
        _image = image;
        CVPixelBufferRetain(_image);
    }
    return self;
}

- (void)dealloc {
    CVPixelBufferRelease(_image);
}

- (nullable instancetype)initWithImageFromCGImage:(CGImageRef)image error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    if (self) {
        NSError *localError;
        BOOL result = YES;
        id retVal = nil;
        @autoreleasepool {
            do {
                MLFeatureValue * __image = [MLFeatureValue featureValueWithCGImage:image pixelsWide:640 pixelsHigh:640 pixelFormatType:kCVPixelFormatType_32ARGB options:nil error:&localError];
                if (__image == nil) {
                    result = NO;
                    break;
                }
                retVal = [self initWithImage:(CVPixelBufferRef)__image.imageBufferValue];
            }
            while(0);
        }
        if (error != NULL) {
            *error = localError;
        }
        return result ? retVal : nil;
    }
    return self;
}

- (nullable instancetype)initWithImageAtURL:(NSURL *)imageURL error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    if (self) {
        NSError *localError;
        BOOL result = YES;
        id retVal = nil;
        @autoreleasepool {
            do {
                MLFeatureValue * __image = [MLFeatureValue featureValueWithImageAtURL:imageURL pixelsWide:640 pixelsHigh:640 pixelFormatType:kCVPixelFormatType_32ARGB options:nil error:&localError];
                if (__image == nil) {
                    result = NO;
                    break;
                }
                retVal = [self initWithImage:(CVPixelBufferRef)__image.imageBufferValue];
            }
            while(0);
        }
        if (error != NULL) {
            *error = localError;
        }
        return result ? retVal : nil;
    }
    return self;
}

-(BOOL)setImageWithCGImage:(CGImageRef)image error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSError *localError;
    BOOL result = NO;
    @autoreleasepool {
        MLFeatureValue * __image = [MLFeatureValue featureValueWithCGImage:image pixelsWide:640 pixelsHigh:640 pixelFormatType:kCVPixelFormatType_32ARGB options:nil error:&localError];
        if (__image != nil) {
            CVPixelBufferRelease(self.image);
            self.image =  (CVPixelBufferRef)__image.imageBufferValue;
            CVPixelBufferRetain(self.image);
            result = YES;
        }
    }
    if (error != NULL) {
        *error = localError;
    }
    return result;
}

-(BOOL)setImageWithURL:(NSURL *)imageURL error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSError *localError;
    BOOL result = NO;
    @autoreleasepool {
        MLFeatureValue * __image = [MLFeatureValue featureValueWithImageAtURL:imageURL pixelsWide:640 pixelsHigh:640 pixelFormatType:kCVPixelFormatType_32ARGB options:nil error:&localError];
        if (__image != nil) {
            CVPixelBufferRelease(self.image);
            self.image =  (CVPixelBufferRef)__image.imageBufferValue;
            CVPixelBufferRetain(self.image);
            result = YES;
        }
    }
    if (error != NULL) {
        *error = localError;
    }
    return result;
}

- (NSSet<NSString *> *)featureNames {
    return [NSSet setWithArray:@[@"image"]];
}

- (nullable MLFeatureValue *)featureValueForName:(NSString *)featureName {
    if ([featureName isEqualToString:@"image"]) {
        return [MLFeatureValue featureValueWithPixelBuffer:self.image];
    }
    return nil;
}

@end

@implementation yolov8n_face_relu6Output

- (instancetype)initWithVar_947:(MLMultiArray *)var_947 {
    self = [super init];
    if (self) {
        _var_947 = var_947;
    }
    return self;
}

- (NSSet<NSString *> *)featureNames {
    return [NSSet setWithArray:@[@"var_947"]];
}

- (nullable MLFeatureValue *)featureValueForName:(NSString *)featureName {
    if ([featureName isEqualToString:@"var_947"]) {
        return [MLFeatureValue featureValueWithMultiArray:self.var_947];
    }
    return nil;
}

@end

@implementation yolov8n_face_relu6


/**
    URL of the underlying .mlmodelc directory.
*/
+ (nullable NSURL *)URLOfModelInThisBundle {
    NSString *assetPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"yolov8n_face_relu6" ofType:@"mlmodelc"];
    if (nil == assetPath) { os_log_error(OS_LOG_DEFAULT, "Could not load yolov8n_face_relu6.mlmodelc in the bundle resource"); return nil; }
    return [NSURL fileURLWithPath:assetPath];
}


/**
    Initialize yolov8n_face_relu6 instance from an existing MLModel object.

    Usually the application does not use this initializer unless it makes a subclass of yolov8n_face_relu6.
    Such application may want to use `-[MLModel initWithContentsOfURL:configuration:error:]` and `+URLOfModelInThisBundle` to create a MLModel object to pass-in.
*/
- (instancetype)initWithMLModel:(MLModel *)model {
    self = [super init];
    if (!self) { return nil; }
    _model = model;
    if (_model == nil) { return nil; }
    return self;
}


/**
    Initialize yolov8n_face_relu6 instance with the model in this bundle.
*/
- (nullable instancetype)init {
    return [self initWithContentsOfURL:(NSURL * _Nonnull)self.class.URLOfModelInThisBundle error:nil];
}


/**
    Initialize yolov8n_face_relu6 instance with the model in this bundle.

    @param configuration The model configuration object
    @param error If an error occurs, upon return contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
*/
- (nullable instancetype)initWithConfiguration:(MLModelConfiguration *)configuration error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return [self initWithContentsOfURL:(NSURL * _Nonnull)self.class.URLOfModelInThisBundle configuration:configuration error:error];
}


/**
    Initialize yolov8n_face_relu6 instance from the model URL.

    @param modelURL URL to the .mlmodelc directory for yolov8n_face_relu6.
    @param error If an error occurs, upon return contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
*/
- (nullable instancetype)initWithContentsOfURL:(NSURL *)modelURL error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    MLModel *model = [MLModel modelWithContentsOfURL:modelURL error:error];
    if (model == nil) { return nil; }
    return [self initWithMLModel:model];
}


/**
    Initialize yolov8n_face_relu6 instance from the model URL.

    @param modelURL URL to the .mlmodelc directory for yolov8n_face_relu6.
    @param configuration The model configuration object
    @param error If an error occurs, upon return contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
*/
- (nullable instancetype)initWithContentsOfURL:(NSURL *)modelURL configuration:(MLModelConfiguration *)configuration error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    MLModel *model = [MLModel modelWithContentsOfURL:modelURL configuration:configuration error:error];
    if (model == nil) { return nil; }
    return [self initWithMLModel:model];
}


/**
    Construct yolov8n_face_relu6 instance asynchronously with configuration.
    Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

    @param configuration The model configuration
    @param handler When the model load completes successfully or unsuccessfully, the completion handler is invoked with a valid yolov8n_face_relu6 instance or NSError object.
*/
+ (void)loadWithConfiguration:(MLModelConfiguration *)configuration completionHandler:(void (^)(yolov8n_face_relu6 * _Nullable model, NSError * _Nullable error))handler {
    [self loadContentsOfURL:(NSURL * _Nonnull)[self URLOfModelInThisBundle]
              configuration:configuration
          completionHandler:handler];
}


/**
    Construct yolov8n_face_relu6 instance asynchronously with URL of .mlmodelc directory and optional configuration.

    Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

    @param modelURL The model URL.
    @param configuration The model configuration
    @param handler When the model load completes successfully or unsuccessfully, the completion handler is invoked with a valid yolov8n_face_relu6 instance or NSError object.
*/
+ (void)loadContentsOfURL:(NSURL *)modelURL configuration:(MLModelConfiguration *)configuration completionHandler:(void (^)(yolov8n_face_relu6 * _Nullable model, NSError * _Nullable error))handler {
    [MLModel loadContentsOfURL:modelURL
                 configuration:configuration
             completionHandler:^(MLModel *model, NSError *error) {
        if (model != nil) {
            yolov8n_face_relu6 *typedModel = [[yolov8n_face_relu6 alloc] initWithMLModel:model];
            handler(typedModel, nil);
        } else {
            handler(nil, error);
        }
    }];
}

- (nullable yolov8n_face_relu6Output *)predictionFromFeatures:(yolov8n_face_relu6Input *)input error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return [self predictionFromFeatures:input options:[[MLPredictionOptions alloc] init] error:error];
}

- (nullable yolov8n_face_relu6Output *)predictionFromFeatures:(yolov8n_face_relu6Input *)input options:(MLPredictionOptions *)options error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    id<MLFeatureProvider> outFeatures = [self.model predictionFromFeatures:input options:options error:error];
    if (!outFeatures) { return nil; }
    return [[yolov8n_face_relu6Output alloc] initWithVar_947:(MLMultiArray *)[outFeatures featureValueForName:@"var_947"].multiArrayValue];
}

- (void)predictionFromFeatures:(yolov8n_face_relu6Input *)input completionHandler:(void (^)(yolov8n_face_relu6Output * _Nullable output, NSError * _Nullable error))completionHandler {
    [self.model predictionFromFeatures:input completionHandler:^(id<MLFeatureProvider> prediction, NSError *predictionError) {
        if (!prediction) {
            completionHandler(nil, predictionError);
        } else {
            yolov8n_face_relu6Output *output = [[yolov8n_face_relu6Output alloc] initWithVar_947:(MLMultiArray *)[prediction featureValueForName:@"var_947"].multiArrayValue];
            completionHandler(output, predictionError);
        }
    }];
}

- (void)predictionFromFeatures:(yolov8n_face_relu6Input *)input options:(MLPredictionOptions *)options completionHandler:(void (^)(yolov8n_face_relu6Output * _Nullable output, NSError * _Nullable error))completionHandler {
    [self.model predictionFromFeatures:input options:options completionHandler:^(id<MLFeatureProvider> prediction, NSError *predictionError) {
        if (!prediction) {
            completionHandler(nil, predictionError);
        } else {
            yolov8n_face_relu6Output *output = [[yolov8n_face_relu6Output alloc] initWithVar_947:(MLMultiArray *)[prediction featureValueForName:@"var_947"].multiArrayValue];
            completionHandler(output, predictionError);
        }
    }];
}

- (nullable yolov8n_face_relu6Output *)predictionFromImage:(CVPixelBufferRef)image error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    yolov8n_face_relu6Input *input_ = [[yolov8n_face_relu6Input alloc] initWithImage:image];
    return [self predictionFromFeatures:input_ error:error];
}

- (nullable NSArray<yolov8n_face_relu6Output *> *)predictionsFromInputs:(NSArray<yolov8n_face_relu6Input*> *)inputArray options:(MLPredictionOptions *)options error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    id<MLBatchProvider> inBatch = [[MLArrayBatchProvider alloc] initWithFeatureProviderArray:inputArray];
    id<MLBatchProvider> outBatch = [self.model predictionsFromBatch:inBatch options:options error:error];
    if (!outBatch) { return nil; }
    NSMutableArray<yolov8n_face_relu6Output*> *results = [NSMutableArray arrayWithCapacity:(NSUInteger)outBatch.count];
    for (NSInteger i = 0; i < outBatch.count; i++) {
        id<MLFeatureProvider> resultProvider = [outBatch featuresAtIndex:i];
        yolov8n_face_relu6Output * result = [[yolov8n_face_relu6Output alloc] initWithVar_947:(MLMultiArray *)[resultProvider featureValueForName:@"var_947"].multiArrayValue];
        [results addObject:result];
    }
    return results;
}

@end
