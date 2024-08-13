#include "graph.h"

Graph::Graph(int nodes) : numNodes(nodes), edgeOffsets(nodes + 1, 0) {}

void Graph::addEdge(int src, int dest) {
    edges.push_back(dest);
    edgeOffsets[src + 1]++;
    for (int i = src + 1; i <= numNodes; ++i) {
        edgeOffsets[i]++;
    }
}