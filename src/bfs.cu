#include <iostream>
#include <vector>
#include <cuda_runtime.h>
#include "graph.h"

#define INF 999999

__global__ void bfs_kernel(int *adjList, int *adjListSizes, int *distances, int *frontier, int *newFrontier, int numNodes, bool *flag_continue) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx >= numNodes) return;

    if (frontier[idx]) {
        frontier[idx] = 0;
        int start = adjListSizes[idx];
        int end = adjListSizes[idx + 1];
        for (int i = start; i < end; ++i) {
            int neighbor = adjList[i];
            if (distances[neighbor] == INF) {
                distances[neighbor] = distances[idx] + 1;
                newFrontier[neighbor] = 1;
                *flag_continue = true;
            }
        }
    }
}

void bfs(int startNode, const Graph &graph) {
    int numNodes = graph.getNumNodes();
    const auto &adjListHost = graph.getAdjList();

    int totalEdges = 0;
    std::vector<int> adjList;
    std::vector<int> adjListSizes(numNodes + 1, 0);
    for (int i = 0; i < numNodes; ++i) {
        adjListSizes[i] = totalEdges;
        for (int neighbor : adjListHost[i]) {
            adjList.push_back(neighbor);
            ++totalEdges;
        }
    }
    adjListSizes[numNodes] = totalEdges;

    int *d_adjList, *d_adjListSizes, *d_distances, *d_frontier, *d_newFrontier;
    cudaMalloc(&d_adjList, adjList.size() * sizeof(int));
    cudaMalloc(&d_adjListSizes, adjListSizes.size() * sizeof(int));
    cudaMalloc(&d_distances, numNodes * sizeof(int));
    cudaMalloc(&d_frontier, numNodes * sizeof(int));
    cudaMalloc(&d_newFrontier, numNodes * sizeof(int));

    std::vector<int> distances(numNodes, INF);
    std::vector<int> frontier(numNodes, 0);
    distances[startNode] = 0;
    frontier[startNode] = 1;

    cudaMemcpy(d_adjList, adjList.data(), adjList.size() * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_adjListSizes, adjListSizes.data(), adjListSizes.size() * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_distances, distances.data(), numNodes * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_frontier, frontier.data(), numNodes * sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int numBlocks = (numNodes + blockSize - 1) / blockSize;

    bool *h_continue = new bool;
    bool *d_continue;
    cudaMalloc(&d_continue, sizeof(bool));
    do {
        *h_continue = false;
        cudaMemcpy(d_continue, h_continue, sizeof(bool), cudaMemcpyHostToDevice);

        bfs_kernel<<<numBlocks, blockSize>>>(d_adjList, d_adjListSizes, d_distances, d_frontier, d_newFrontier, numNodes, d_continue);

        cudaMemcpy(h_continue, d_continue, sizeof(bool), cudaMemcpyDeviceToHost);
        cudaMemcpy(d_frontier, d_newFrontier, numNodes * sizeof(int), cudaMemcpyDeviceToDevice);

    } while (*h_continue);

    cudaMemcpy(distances.data(), d_distances, numNodes * sizeof(int), cudaMemcpyDeviceToHost);

    for (int i = 0; i < numNodes; ++i) {
        std::cout << "Distance to node " << i << ": " << distances[i] << std::endl;
    }

    cudaFree(d_adjList);
    cudaFree(d_adjListSizes);
    cudaFree(d_distances);
    cudaFree(d_frontier);
    cudaFree(d_newFrontier);
    cudaFree(d_continue);
    delete h_continue;
}
