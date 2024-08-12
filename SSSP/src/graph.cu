#include "graph.h"
#include <cuda_runtime.h>
#include <iostream>

__global__ void relaxEdges(Edge* edges, int* distances, int E, bool* updated) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < E) {
        int u = edges[i].src;
        int v = edges[i].dest;
        int weight = edges[i].weight;

        if (distances[u] != INT_MAX && distances[u] + weight < distances[v]) {
            distances[v] = distances[u] + weight;
            *updated = true;
        }
    }
}