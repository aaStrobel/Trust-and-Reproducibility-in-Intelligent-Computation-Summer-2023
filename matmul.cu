#include <stdio.h>

// Compute C = A * B
__global__ void matrixMultiply(float *A, float *B, float *C, int numARows,
                               int numAColumns, int numBRows,
                               int numBColumns, int numCRows,
                               int numCColumns) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < numCRows && col < numCColumns) {
        float sum = 0.0f;
        for (int i = 0; i < numAColumns; ++i) {
            sum += A[row * numAColumns + i] * B[i * numBColumns + col];
        }
        C[row * numCColumns + col] = sum;
    }
}

int main(int argc, char **argv) {
    float *hostA; // The A matrix
    float *hostB; // The B matrix
    float *hostC; // The output C matrix
    float *deviceA;
    float *deviceB;
    float *deviceC;
    int numARows = 1024;    // number of rows in matrix A
    int numAColumns = 1024; // number of columns in matrix A
    int numBRows = 1024;    // number of rows in matrix B
    int numBColumns = 1024; // number of columns in matrix B
    int numCRows = numARows; // number of rows in matrix C
    int numCColumns = numBColumns; // number of columns in matrix C

    hostA = (float *)malloc(numARows * numAColumns * sizeof(float));
    hostB = (float *)malloc(numBRows * numBColumns * sizeof(float));
    hostC = (float *)malloc(numCRows * numCColumns * sizeof(float));

    // Allocate the hostC matrix
    // Allocate GPU memory here
    cudaMalloc((void **)&deviceA, numARows * numAColumns * sizeof(float));
    cudaMalloc((void **)&deviceB, numBRows * numBColumns * sizeof(float));
    cudaMalloc((void **)&deviceC, numCRows * numCColumns * sizeof(float));

    // Copy memory to the GPU here
    cudaMemcpy(deviceA, hostA, numARows * numAColumns * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(deviceB, hostB, numBRows * numBColumns * sizeof(float), cudaMemcpyHostToDevice);

    // Initialize the grid and block dimensions here
    dim3 blockDim(16, 16);
    dim3 gridDim((numCColumns + blockDim.x - 1) / blockDim.x, (numCRows + blockDim.y - 1) / blockDim.y);

    // Launch the GPU Kernel here
    matrixMultiply<<<gridDim, blockDim>>>(deviceA, deviceB, deviceC, numARows, numAColumns, numBRows, numBColumns, numCRows, numCColumns);

    cudaDeviceSynchronize();

    // Copy the GPU memory back to the CPU here
    cudaMemcpy(hostC, deviceC, numCRows * numCColumns * sizeof(float), cudaMemcpyDeviceToHost);

    // Free the GPU memory here
    cudaFree(deviceA);
    cudaFree(deviceB);
    cudaFree(deviceC);

    free(hostA);
    free(hostB);
    free(hostC);

    return 0;
}
