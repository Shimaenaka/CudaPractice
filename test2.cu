#include<stdio.h>
#define N 1000

__global__ void add(double *a, double *b, double *c) {
    double idx = threadIdx.x + blockIdx.x * blockDim.x;
    if(idx < N) c[idx] = a[idx] + b[idx];
}

int main() {
    double a[N], b[N], c[N];
    double *dev_a, *dev_b, *dev_c;
    cudaMalloc((void**)&dev_a, N * sizeof(double));
    cudaMalloc((void**)&dev_b, N * sizeof(double));
    cudaMalloc((void**)&dev_c, N * sizeof(double));
    for(int i = 0; i < N; i++) {
        a[i] = i;
        b[i] = i * i;
    }
    cudaMemcpy(dev_a, a, N * sizeof(double), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N * sizeof(double), cudaMemcpyHostToDevice);
    int M = 128;
    add<<<(N + M - 1) / M, M>>>(a, b, c);
    cudaMemcpy(c, dev_c, N * sizeof(double), cudaMemcpyDeviceToHost);
    for(int i = 0; i < N; i++) printf("%lf + %lf = %lf\n", a[i], b[i], c[i]);
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);
    return 0;
}
