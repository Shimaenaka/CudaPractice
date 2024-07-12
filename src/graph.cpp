#include "graph.h"

Graph::Graph(int numNodes, int numEdges, const std::vector<std::pair<int, int>> &edges) {
    adjList.resize(numNodes);
    for (const auto &edge : edges) {
        adjList[edge.first].push_back(edge.second);
        adjList[edge.second].push_back(edge.first);
    }
}

int Graph::getNumNodes() const {
    return numNodes;
}

const std::vector<std::vector<int>>& Graph::getAdjList() const {
    return adjList;
}