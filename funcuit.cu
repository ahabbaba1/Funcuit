#include <sys/time.h>
#include <stdio.h>


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GPU CODE
//
            

//Normal C function to convert equation into tree
void normal(char* a, long N) //a is the array, N is the size of the array
{

  
		char input[] = "AB+CD+abd+jbn+";
                             //[2,5,9,13];
    int indexes [sizeof(input)/2];                
		int count = 0;
    int index = 0;
		struct t
    { 
      struct t *OR;

    }
long i = 0;
 for(i = 0; i < sizeof(input); i++)
		{
                    
                    //'h' 'e' '+' 'l' 'l' '+'
                                          //count = 2, i = 5;
			if (input[i] != '+')
			{
				count++;
                                indexes[index] = i;
                                index++;
			}
			else
			{
                            //send to gpu child
                                //loop through indexes array
                                    //if i = 0, send 0 - i-1
                                    //else send indexes[i]+1 to indexes[i+1]-1 
                                //send OR
                                                       
                          //  struct t AND*;
                            //OR.addChild(AND);
                   
                            for (int c = count; c > 0; c--)
                            {
                                AND.addChild(new GenericTreeNode<Character>(inputArray[i-c]));
                            }
                            count = 0;
                            
                            System.out.println(AND.toStringVerbose());
			}
		}
}

//Normal C function to co\
// GPU function to square root values
__global__ void gpu_sqrt(float* a, long N) {
   long element = blockIdx.x*blockDim.x + threadIdx.x; // Each thread must get a different element
   if (element < N) a[element] = sqrt(a[element]);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                                                                                                                               

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// HELPER CODE TO INITIALIZE, PRINT AND TIME
struct timeval start, end;
void initialize(float *a, long N) {
  long i;
  for (i = 0; i < N; ++i) { 
    a[i] = pow(rand() % 10, 2); 
  }                                                                                                                                                                                       
}

void print(float* a, long N) {
   if (doPrint) {
   long i;
   for (i = 0; i < N; ++i)
      printf("%d ", (int) a[i]);
   printf("\n");
   }
}  

void starttime() {
  gettimeofday( &start, 0 );
}

void endtime(const char* c) {
   gettimeofday( &end, 0 );
   double elapsed = ( end.tv_sec - start.tv_sec ) * 1000.0 + ( end.tv_usec - start.tv_usec ) / 1000.0;
   printf("%s: %f ms\n", c, elapsed); 
}

void init(float* a, long N, const char* c) {
  printf("***************** %s **********************\n", c);
  printf("Initializing array....\n");
  initialize(a, N); 
  printf("Done.\n");
  print(a, N);
  printf("Running %s...\n", c);
  starttime();
}

void finish(float* a, long N, const char* c) {
  endtime(c);
  printf("Done.\n");
  print(a, N);
  printf("***************************************************\n");
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////



int main()                                                                                                                                                                                  
{
  float* a = (float*) malloc(N*sizeof(float));
  ///////////////////////////////////////////////
  // Test 1: Sequential For Loop
  init(a, N, "Normal");
  normal(a, N); 
  finish(a, N, "Normal"); 
  ///////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Test 2: GPU
  init(a, N, "GPU");

  // How many threads, how many cores?
  int numThreads = 1024; // This can vary, up to 1024
  long numCores = N / 1024 + 1;

  float* gpuA;

  cudaMalloc(&gpuA, N*sizeof(float)); // 1. Allocate enough memory on the GPU
  cudaMemcpy(gpuA, a, N*sizeof(float), cudaMemcpyHostToDevice); // 2. Copy original array from CPU to GPU
  gpu_sqrt<<<numCores, numThreads>>>(gpuA, N);  // 3. Each GPU thread square roots its value
  cudaMemcpy(a, gpuA, N*sizeof(float), cudaMemcpyDeviceToHost); // 4. Copy square rooted values from GPU to CPU
  cudaFree(&gpuA); // 5. Free the memory on the GPU


  finish(a, N, "GPU");
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  free(a);
  return 0;
}

