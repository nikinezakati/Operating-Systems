#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
#include <assert.h>
#include<math.h>
#include<unistd.h>

#define NUM_THREADS 10
typedef struct 
{
	int depth;
    double sum;
} thread_data;

thread_data data[NUM_THREADS];

void* sigma_func(void *level) 
{
	int thread_level = *(int *)level;
	double plus = 0;
	int sign;
    int n = thread_level;
	if (n % 2) 
		sign = -1;
	else 
		sign = 1;
	data[thread_level].sum = 4*((double)sign/(2 * thread_level + 1));
	do 
    {
		n += NUM_THREADS;
		if (n % 2) 
			sign = -1;
		else 
			sign = 1;

		plus = (double)sign / (2 * n + 1);
		data[thread_level].sum += 4 * plus;
	}while(fabs(plus) > 1e-6);

	return NULL;
}

int main(){

	int level = 0;
	double pi = 0;
	pthread_t thread_ids[NUM_THREADS];
	while(level < NUM_THREADS) 
    {
		data[level].depth = level;
		int new_thread_status = pthread_create(&(thread_ids[level]),NULL,sigma_func,(void*)&data[level].depth);
		assert(new_thread_status == 0); 
		level++;
	}
	level = 0;
	while(level < NUM_THREADS) 
    {
		pthread_join(thread_ids[level], NULL);
		level++;
	}
	level = 0;
	while(level < NUM_THREADS) 
    {
        pi += data[level].sum;
		level++;
	}

    printf("%f\n",pi);

  return 0;
}