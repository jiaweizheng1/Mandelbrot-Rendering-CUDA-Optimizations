CC 			= gcc
CFLAGS 		= -Wall -g -std=gnu11
LFLAGS 		= -lX11 -lgomp -lm
XFLAG 		= -D SHOW_X
BFLAG 		= -D BENCHMARK
OPENMPFLAG	= -Xcompiler -fopenmp
NVCC 		= nvcc
CUDA_FLAGS 	= -gencode=arch=compute_75,code=sm_75 -g

all : mandelbrot XBenchmark benchmark fractal fractalmp \
	mandelbrot_shapeschecking benchmark_shapeschecking \
	mandelbrot_mathfunc benchmark_mathfunc \
	mathfunc_double benchmark_double \
	mathfunc_float benchmark_float \
	mandelbrot_w_openmp benchmark_w_openmp

mandelbrot : mandelbrot.cu
	$(NVCC) $(CUDA_FLAGS) $(XFLAG) mandelbrot.cu -o mandelbrot $(LFLAGS)

benchmark : mandelbrot.cu
	$(NVCC) $(CUDA_FLAGS) $(BFLAG) mandelbrot.cu -o benchmark $(LFLAGS)

XBenchmark : mandelbrot.cu
	$(NVCC) $(CUDA_FLAGS) $(BFLAG) $(XFLAG) mandelbrot.cu -o XBenchmark $(LFLAGS)

mandelbrot_shapeschecking : mandelbrot_shapeschecking.cu
	$(NVCC) $(CUDA_FLAGS) $(XFLAG) mandelbrot_shapeschecking.cu -o mandelbrot_shapeschecking $(LFLAGS)

benchmark_shapeschecking : mandelbrot_shapeschecking.cu
	$(NVCC) $(CUDA_FLAGS) $(BFLAG) mandelbrot_shapeschecking.cu -o benchmark_shapeschecking $(LFLAGS)

mandelbrot_mathfunc : mandelbrot_mathfunc.cu
	$(NVCC) $(CUDA_FLAGS) $(XFLAG) mandelbrot_mathfunc.cu -o mandelbrot_mathfunc $(LFLAGS)

benchmark_mathfunc : mandelbrot_mathfunc.cu
	$(NVCC) $(CUDA_FLAGS) $(BFLAG) mandelbrot_mathfunc.cu -o benchmark_mathfunc $(LFLAGS)

mathfunc_double : mathfunc_double.cu
	$(NVCC) $(CUDA_FLAGS) $(XFLAG) mathfunc_double.cu -o mathfunc_double $(LFLAGS)

benchmark_double : mathfunc_double.cu
	$(NVCC) $(CUDA_FLAGS) $(BFLAG) mathfunc_double.cu -o benchmark_double $(LFLAGS)

mathfunc_float : mathfunc_float.cu
	$(NVCC) $(CUDA_FLAGS) $(XFLAG) mathfunc_float.cu -o mathfunc_float $(LFLAGS)

benchmark_float : mathfunc_float.cu
	$(NVCC) $(CUDA_FLAGS) $(BFLAG) mathfunc_float.cu -o benchmark_float $(LFLAGS)

mandelbrot_w_openmp : mandelbrot_w_openmp.cu
	$(NVCC) $(CUDA_FLAGS) $(XFLAG) $(OPENMPFLAG) mandelbrot_w_openmp.cu -o mandelbrot_w_openmp $(LFLAGS)

benchmark_w_openmp : mandelbrot_w_openmp.cu
	$(NVCC) $(CUDA_FLAGS) $(BFLAG) $(OPENMPFLAG) mandelbrot_w_openmp.cu -o benchmark_w_openmp $(LFLAGS)

fractal: fractal.c gfx.c
	gcc fractal.c gfx.c -g -Wall --std=c99 -lX11 -lm -lgomp -o fractal

fractalmp: fractal_mp.c gfx.c
	gcc fractal_mp.c gfx.c -g -Wall --std=c99 -lX11 -lm -lgomp -fopenmp -o fractalmp

clean :
	rm -rf *.o mandelbrot XBenchmark benchmark fractal fractalmp \
		mandelbrot_shapeschecking benchmark_shapeschecking \
		mandelbrot_mathfunc benchmark_mathfunc \
		mathfunc_double mathfunc_float \
		benchmark_double benchmark_float \
		mandelbrot_w_openmp benchmark_w_openmp