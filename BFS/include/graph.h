#ifndef GRAPH_H
#define GRAPH_H

#include <vector>
#include <set>

class Graph {
public:
    Graph(int numNodes, int numEdges, const std::vector<std::pair<int, int>> &edges);
    int getNumNodes() const;
    const std::vector<std::vector<int>>& getAdjList() const;

private:
    int numNodes;
    std::vector<std::vector<int>> adjList;
};

#endif