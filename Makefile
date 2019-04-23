NVCC=/usr/local/cuda-9.1/bin/nvcc

funcuit: funcuit.cu
	${NVCC} -arch=sm_37 funcuit.cu -o funcuit

funnncuit: funnncuit.cu
	${NVCC} -arch=sm_37 funnncuit.cu -o funnncuit


clean:
	-rm $(objects) funcuit
