cmake_minimum_required(VERSION 3.10)

# Set the C++ standard
set(CMAKE_C_COMPILER "gcc-6")
set(CMAKE_CXX_COMPILER "g++-6")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

project(BFS_CUDA)

# Find CUDA
find_package(CUDA REQUIRED)
set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS}")

# Include directories
include_directories(include)

# Set the source files
set(SOURCES
    src/testBFS.cpp
    src/graph.cpp
    src/bfs.cu
)

# Create the executable
cuda_add_executable(bfs ${SOURCES})

# Link necessary libraries
target_link_libraries(bfs ${CUDA_LIBRARIES})
