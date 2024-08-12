cmake_minimum_required(VERSION 3.10)
project(SSSP_CUDA)

find_package(CUDA REQUIRED)

include_directories(include)

set(SOURCE_FILES
    src/graph.cpp
    src/graph.cu
    src/sssp.cu
)

cuda_add_executable(sssp ${SOURCE_FILES})