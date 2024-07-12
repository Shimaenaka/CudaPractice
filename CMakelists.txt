cmake_minimum_required(VERSION 3.10)
project(BFS_CUDA)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Find CUDA
find_package(CUDA REQUIRED)
set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -O3 -gencode arch=compute_60,code=sm_60")

# Include directories
include_directories(include)

# Set the source files
set(SOURCES
    src/testbfs.cpp
    src/graph.cpp
    src/bfs.cu
)

# Create the executable
cuda_add_executable(bfs ${SOURCES})

# Link necessary libraries
target_link_libraries(bfs ${CUDA_LIBRARIES})