#include <iostream>
#include <limits.h>
#include "graph.h"

__global__ void relaxEdges(Edge* edges, int* distances, int E, bool* updated) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < E) {
        int u = edges[i].src;
        int v = edges[i].dest;
        int weight = edges[i].weight;

        printf("Checking edge %d %d\n", u, v);
        if (distances[u] != INT_MAX && distances[u] + weight < distances[v]) {
            printf("Relaxing edge %d %d\n", u, v);
            distances[v] = distances[u] + weight;
            *updated = true;
        }
    }
}

void sssp(Graph& graph, int src) {
    int V = graph.V;
    int E = graph.E;
    int* distances;
    Edge* d_edges;
    bool* d_updated;

    distances = new int[V];
    for (int i = 0; i < V; ++i) distances[i] = INT_MAX;
    distances[src] = 0;

    cudaMalloc(&d_edges, E * sizeof(Edge));
    cudaMalloc(&d_updated, sizeof(bool));
    cudaMemcpy(d_edges, graph.edges.data(), E * sizeof(Edge), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int numBlocks = (E + blockSize - 1) / blockSize;

    for (int i = 0; i < V - 1; ++i) {
        bool updated = false;
        cudaMemcpy(d_updated, &updated, sizeof(bool), cudaMemcpyHostToDevice);
        relaxEdges<<<numBlocks, blockSize>>>(d_edges, distances, E, d_updated);
        cudaMemcpy(&updated, d_updated, sizeof(bool), cudaMemcpyDeviceToHost);
        if (!updated) break;
    }

    std::cout << "Vertex Distance from Source\n";
    for (int i = 0; i < V; ++i)
        std::cout << i << "\t\t" << distances[i] << "\n";

    cudaFree(d_edges);
    cudaFree(d_updated);
    delete[] distances;
}

int main() {
    int V, E;
    std::cin>>V>>E;
    Graph graph(V, E);

    for (int i = 0; i < E; ++i) {
        int src, dest, weight;
        std::cin>>src>>dest>>weight;
        graph.addEdge(src, dest, weight);
    }

    sssp(graph, 0);

    return 0;
}