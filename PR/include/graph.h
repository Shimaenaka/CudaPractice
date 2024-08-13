#ifndef GRAPH_H
#define GRAPH_H

#include <vector>

class Graph {
public:
    int numNodes;
    std::vector<int> edges;
    std::vector<int> edgeOffsets;

    Graph(int nodes);
    void addEdge(int src, int dest);
};

#endif