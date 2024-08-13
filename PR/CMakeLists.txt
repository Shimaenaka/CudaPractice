cmake_minimum_required(VERSION 3.10)
project(PageRankCUDA LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CUDA_STANDARD 14)

include_directories(include)

add_executable(pagerank
    src/graph.cpp
    src/graph.cu
    src/pr.cu
)

set_target_properties(pagerank PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)