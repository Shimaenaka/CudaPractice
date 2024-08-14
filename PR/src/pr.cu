#include <iostream>
#include <vector>
#include <cuda_runtime.h>
#include "graph.h"

void allocateGraphOnGPU(Graph &graph, int **d_edges, int **d_offsets) {
    cudaMalloc((void **)d_edges, graph.edges.size() * sizeof(int));
    cudaMalloc((void **)d_offsets, graph.edgeOffsets.size() * sizeof(int));

    cudaMemcpy(*d_edges, graph.edges.data(), graph.edges.size() * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(*d_offsets, graph.edgeOffsets.data(), graph.edgeOffsets.size() * sizeof(int), cudaMemcpyHostToDevice);
}

void freeGraphOnGPU(int *d_edges, int *d_offsets) {
    cudaFree(d_edges);
    cudaFree(d_offsets);
}

__global__ void pageRankKernel(int numNodes, int *d_edges, int *d_offsets, float *d_pr, float *d_prNext, float damping, float equalProb) {
    int node = blockIdx.x * blockDim.x + threadIdx.x;
    if (node < numNodes) {
        float sum = 0.0f;
        int start = d_offsets[node];
        int end = d_offsets[node + 1];
        for (int edge = start; edge < end; ++edge) {
            int neighbor = d_edges[edge];
            sum += d_pr[neighbor] / (d_offsets[neighbor + 1] - d_offsets[neighbor]);
        }
        d_prNext[node] = damping * sum + (1.0f - damping) * equalProb;
    }
}

void pageRank(Graph &graph, int iterations = 100, float damping = 0.85) {
    int *d_edges, *d_offsets;
    allocateGraphOnGPU(graph, &d_edges, &d_offsets);

    float *d_pr, *d_prNext;
    cudaMalloc((void **)&d_pr, graph.numNodes * sizeof(float));
    cudaMalloc((void **)&d_prNext, graph.numNodes * sizeof(float));

    std::vector<float> pr(graph.numNodes, 1.0f / graph.numNodes);
    cudaMemcpy(d_pr, pr.data(), graph.numNodes * sizeof(float), cudaMemcpyHostToDevice);

    float equalProb = 1.0f / graph.numNodes;
    int blockSize = 256;
    int numBlocks = (graph.numNodes + blockSize - 1) / blockSize;

    for (int i = 0; i < iterations; ++i) {
        pageRankKernel<<<numBlocks, blockSize>>>(graph.numNodes, d_edges, d_offsets, d_pr, d_prNext, damping, equalProb);
        std::swap(d_pr, d_prNext);
    }

    cudaMemcpy(pr.data(), d_pr, graph.numNodes * sizeof(float), cudaMemcpyDeviceToHost);

    for (int i = 0; i < graph.numNodes; ++i) {
        std::cout << "Node " << i << ": " << pr[i] << std::endl;
    }

    cudaFree(d_pr);
    cudaFree(d_prNext);
    freeGraphOnGPU(d_edges, d_offsets);
}

int main(){
    int v, e;
    std::cin >> v;
    Graph graph(v);

    std::cin >> e;
    for(int i = 0; i < e; i++){
        int src, dest;
        std::cin >> src >> dest;
        graph.addEdge(src, dest);
    }
    
    pageRank(graph);

    return 0;
}