#include <iostream>
#include <vector>
#include "graph.h"

void bfs(int startNode, const Graph &graph);

int main() {
    int numNodes, numEdges;
    std::cout << "Enter the number of nodes: ";
    std::cin >> numNodes;
    std::cout << "Enter the number of edges: ";
    std::cin >> numEdges;

    std::vector<std::pair<int, int>> edges(numEdges);
    std::cout << "Enter the edges (u v):" << std::endl;
    for (int i = 0; i < numEdges; ++i) {
        int u, v;
        std::cin >> u >> v;
        edges[i] = {u, v};
    }

    Graph graph(numNodes, numEdges, edges);

    int startNode;
    std::cout << "Enter the starting node: ";
    std::cin >> startNode;

    bfs(startNode, graph);

    return 0;
}