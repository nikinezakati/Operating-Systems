#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/shm.h>

void display(int array[], int length)
{
	for (int i = 0; i < length; i++)
		printf(" %d", array[i]);
	printf("\n");
}

void merge(int *left, int llength, int *right, int rlength)
{
	int *temp1 = (int *) malloc(llength * sizeof(int));
	int *temp2 = (int *) malloc(rlength * sizeof(int));
	int *leftP = temp1;
	int *rightP = temp2;
	int *result = left;

	memcpy(temp1, left, llength * sizeof(int));
	memcpy(temp2, right, rlength * sizeof(int));

	while (llength > 0 && rlength > 0) 
    {
		if (*leftP <= *rightP) 
        {
			*result = *leftP;
			++leftP;
			--llength;
		} 
        else 
        {
			*result = *rightP;
			++rightP;
			--rlength;
		}
		++result;
	}
	if (llength > 0)
    {
		while (llength > 0) 
        {
			*result = *leftP;
			++result;
			++leftP;
			--llength;
		}
    }    
	else
    {
		while (rlength > 0) 
        {
			*result = *rightP;
			++result;
			++rightP;
			--rlength;
		}
    }    
	free(temp1);
	free(temp2);
}

void mergesort(int array[], int length)
{
	int middle;
	int *left, *right;
	int llength;
	int lchild = -1;
	int rchild = -1;
	int status;

	if (length <= 1)
		return;

	middle = length / 2;
	llength = length - middle;
	left = array;
	right = array + llength;

	lchild = fork();
	if (lchild < 0) 
    {
		perror("fork");
		exit(1);
	}
	if (lchild == 0) 
    {
		mergesort(left, llength);
		exit(0);
	} 
    else 
    {
		rchild = fork();
		if (rchild < 0) 
        {
			perror("fork");
			exit(1);
		}
		if (rchild == 0) 
        {
			mergesort(right, middle);
			exit(0);
		}
	}
	waitpid(lchild, &status, 0);
	waitpid(rchild, &status, 0);
	merge(left, llength, right, middle);
}

int main(int argc, char *argv[])
{
	int *array = NULL;
	int length = 0;
	int data;
	int *shm_array;
	int shm_id;
	key_t key;
	int i;
	size_t shm_size;

	while (("%d", &data) != "\n") 
    {
		++length;
		array = (int *) realloc(array, length * sizeof(int));
		array[length - 1] = data;
	}
	printf("%d elements read\n", length);
	key = IPC_PRIVATE;
	shm_size = length * sizeof(int);
	if ((shm_id = shmget(key, shm_size, IPC_CREAT | 0666)) == -1) 
    {
		perror("shmget");
		exit(1);
	}
	if ((shm_array = shmat(shm_id, NULL, 0)) == (int *) -1) 
    {
		perror("shmat");
		exit(1);
	}
	for (i = 0; i < length; i++) 
		shm_array[i] = array[i];
	
	display(shm_array, length);
	mergesort(shm_array, length);
	printf("finished\n");
	display(shm_array, length);
	if (shmdt(shm_array) == -1) 
    {
		perror("shmdt");
		exit(1);
	}
	if (shmctl(shm_id, IPC_RMID, NULL) == -1) 
    {
		perror("shmctl");
		exit(1);
	}
	return 0;
}