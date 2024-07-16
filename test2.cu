#include<stdio.h>
#define N 1000

__global__ void add(int *a, int *b, int *c) {
    int idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < N) c[idx] = a[idx] + b[idx];
}

int main() {
    int a[N], b[N], c[N];
    int *dev_a, *dev_b, *dev_c;
    cudaMalloc((void**)&dev_a, N * sizeof(int));
    cudaMalloc((void**)&dev_b, N * sizeof(int));
    cudaMalloc((void**)&dev_c, N * sizeof(int));
    for(int i = 0; i < N; i++) {
        a[i] = i;
        b[i] = i * i;
    }
    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);
    int M = 256;
    add<<<(N + M - 1) / M, M>>>(dev_a, dev_b, dev_c);
    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < N; i++) printf("%d + %d = %d\n", a[i], b[i], c[i]);
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    return 0;
}