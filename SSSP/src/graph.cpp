#include "graph.h"

Graph::Graph(int V, int E) : V(V), E(E) {}

void Graph::addEdge(int src, int dest, int weight) {
    edges.push_back({src, dest, weight});
}