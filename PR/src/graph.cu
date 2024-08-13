// #include "graph.h"
// #include <cuda_runtime.h>

// void allocateGraphOnGPU(Graph &graph, int **d_edges, int **d_offsets) {
//     cudaMalloc((void **)d_edges, graph.edges.size() * sizeof(int));
//     cudaMalloc((void **)d_offsets, graph.edgeOffsets.size() * sizeof(int));

//     cudaMemcpy(*d_edges, graph.edges.data(), graph.edges.size() * sizeof(int), cudaMemcpyHostToDevice);
//     cudaMemcpy(*d_offsets, graph.edgeOffsets.data(), graph.edgeOffsets.size() * sizeof(int), cudaMemcpyHostToDevice);
// }

// void freeGraphOnGPU(int *d_edges, int *d_offsets) {
//     cudaFree(d_edges);
//     cudaFree(d_offsets);
// }