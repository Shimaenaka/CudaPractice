#ifndef GRAPH_H
#define GRAPH_H

#include <vector>

struct Edge {
    int src;
    int dest;
    int weight;
};

class Graph {
public:
    int V, E;
    std::vector<Edge> edges;

    Graph(int V, int E);
    void addEdge(int src, int dest, int weight);
};

#endif