/*
fractal.c - Sample Mandelbrot Fractal Display
Starting code for CSE 30341 Project 3.
*/

#include "gfx.h"

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <errno.h>
#include <string.h>
#include <complex.h>

#include <omp.h>

/*
Compute the number of iterations at point x, y
in the complex space, up to a maximum of maxiter.
Return the number of iterations at that point.

This example computes the Mandelbrot fractal:
z = z^2 + alpha

Where z is initially zero, and alpha is the location x + iy
in the complex plane.  Note that we are using the "complex"
numeric type in C, which has the special functions cabs()
and cpow() to compute the absolute values and powers of
complex values.
*/

static int compute_point( double x, double y, int max )
{
	double complex z = 0;
	double complex alpha = x + I*y;

	int iter = 0;

	while( cabs(z)<4 && iter < max ) {
		z = cpow(z,2) + alpha;
		iter++;
	}

	return iter;
}

/*
Compute an entire image, writing each point to the given bitmap.
Scale the image to the range (xmin-xmax,ymin-ymax).
*/

void compute_image( double xmin, double xmax, double ymin, double ymax, int maxiter, int thread_count )
{
	int i,j;

	int width = gfx_xsize();
	int height = gfx_ysize();

	// For every pixel i,j, in the image...

	# pragma omp parallel for num_threads(thread_count) \
		schedule(dynamic) collapse(2)
	for(j=0;j<height;j++) {
		for(i=0;i<width;i++) {

			// Scale from pixels i,j to coordinates x,y
			double x = xmin + i*(xmax-xmin)/width;
			double y = ymin + j*(ymax-ymin)/height;

			// Compute the iterations at x,y
			int iter = compute_point(x,y,maxiter);

			// Convert a iteration number to an RGB color.
			// (Change this bit to get more interesting colors.)
			int gray = 255 * iter / maxiter;
			# pragma omp critical
			gfx_color(gray,gray,gray);

			// Plot the point on the screen.
			# pragma omp critical
			gfx_point(i,j);
		}
	}
}

void Usage (char* prog_name) {
   fprintf(stderr, "usage: %s <thread_count> <dim> <maxIter>\n", prog_name);
   exit(0);
}  /* Usage */

int main( int argc, char *argv[] )
{
	// The initial boundaries of the fractal image in x,y space.

	double xmin=-2;
	double xmax= 1;
	double ymin=-1.5;
	double ymax= 1.5;

	int dim;
	int thread_count;
	int maxiter;

	if (argc != 4) Usage(argv[0]);
	thread_count = strtol(argv[1], NULL, 10);
	dim = strtol(argv[2], NULL, 10);
	maxiter = strtol(argv[3], NULL, 10);

	// Maximum number of iterations to compute.
	// Higher values take longer but have more detail.
	//int maxiter=1000;

	// Open a new window.
	gfx_open(dim,dim,"Mandelbrot Fractal");

	// Show the configuration, just in case you want to recreate it.
	printf("coordinates: %lf %lf %lf %lf\n",xmin,xmax,ymin,ymax);

	// Fill it with a dark blue initially.
	gfx_clear_color(0,0,255);
	gfx_clear();

	double start = omp_get_wtime();
	// Display the fractal image
	compute_image(xmin,xmax,ymin,ymax,maxiter,thread_count);
	double stop = omp_get_wtime();
	double elapsed = stop - start;
	printf("Elapsed time (openmp, %d threads, %d size, %d depth) = %e seconds\n", thread_count, dim, maxiter, elapsed);

	while(1) {
		// Wait for a key or mouse click.
		int c = gfx_wait();

		// Quit if q is pressed.
		if(c=='q') exit(0);
	}

	return 0;
}
