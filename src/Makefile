CC 			= gcc
CFLAGS 		= -Wall -g
LFLAGS 		= -lX11 -lgomp -lm
XFLAG 		= -D SHOW_X
BFLAG 		= -D BENCHMARK
NVCC 		= nvcc
CUDA_FLAGS 	= -gencode arch=compute_20,code=sm_20 -g

all : fractal # mandelbrot XBenchmark benchmark

# mandelbrot : mandelbrot.cu
# 	$(NVCC) $(CUDA_FLAGS) $(XFLAG) mandelbrot.cu -o mandelbrot $(LFLAGS)

# benchmark : mandelbrot.cu
# 	$(NVCC) $(CUDA_FLAGS) $(BFLAG) mandelbrot.cu -o benchmark $(LFLAGS)

# XBenchmark : mandelbrot.cu
# 	$(NVCC) $(CUDA_FLAGS) $(BFLAG) $(XFLAG) mandelbrot.cu -o XBenchmark $(LFLAGS)

fractal: fractal.c gfx.c
	gcc fractal.c gfx.c -g -Wall --std=c99 -lX11 -lm -o fractal

clean :
	rm -rf *.o fractal 