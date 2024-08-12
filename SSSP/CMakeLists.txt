cmake_minimum_required(VERSION 3.10)

# Set the C++ standard
set(CMAKE_C_COMPILER "gcc-6")
set(CMAKE_CXX_COMPILER "g++-6")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

project(SSSP_CUDA)

find_package(CUDA REQUIRED)

include_directories(include)

set(SOURCE_FILES
    src/graph.cpp
    src/graph.cu
    src/sssp.cu
)

cuda_add_executable(sssp ${SOURCE_FILES})