#include <iostream>
#include <math.h>
// Kernel function to add the elements of two arrays
__global__ 
void add(int n, float *x, float *y)
{
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;

  for (int i = tid; i < n; i += stride)
    y[i] = x[i] + y[i];
}
int main(void)
{
  int N = 1 << 20;
  float *x, *y;
  cudaMallocManaged(&x, N * sizeof(float));
  cudaMallocManaged(&y, N * sizeof(float));
  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }
  int tpb = 256;
  int bpg = (N + tpb - 1) / tpb;
  add<<<bpg, tpb>>>(N, x, y);
  cudaDeviceSynchronize();
  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = fmax(maxError, fabs(y[i] - 3.0f));
  std::cout << "Max error: " << maxError << std::endl;
  cudaFree(x);
  cudaFree(y);
  return 0;
}
