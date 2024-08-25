cmake_minimum_required(VERSION 3.29)

project(coremlapp)
set(cmake_export_compile_commands ON)

add_executable(coremlapp
    main.cpp
    objc_wrapper.h
    objc_wrapper.mm
    coreml/yolov8n_face_relu6.h
    coreml/yolov8n_face_relu6.m
)


target_compile_options(${PROJECT_NAME}
    PUBLIC
    "-fobjc-arc"
)

target_link_libraries(${PROJECT_NAME}
    "-framework Foundation"
    "-framework CoreML"
    "-framework CoreVideo"
    "-framework Accelerate"
)


find_package(OpenCV REQUIRED)
message("OpenCV_INCLUDE_DIRS: ${OpenCV_INCLUDE_DIRS}")
message("OpenCV_LIBRARIES: ${OpenCV_LIBRARIES}")

target_link_libraries(${PROJECT_NAME}
    "${OpenCV_LIBRARIES}"
)



