#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <semaphore.h>
#include <sys/mman.h>


#define MAX 10
#define MUTEX "/sem-mutex"
#define BUFFER_COUNT "/sem-buffer-count"
#define SPOOL_SIGNAL "/sem-spool-signal"
#define SHARED_MEMORY "/posix-shared-mem-example"
#define LOGFILE "/Users/nikinezakati/Desktop/OS/HW5/simple_logger/example.txt"

struct shared_memory 
{
    char buffer[MAX][256];
    int index;
    int printIndex;
};

void error (char *msg);

int main (int argc, char **argv)
{
    struct shared_memory *memoryPtr;
    sem_t *mutexSem, *bufferCnt, *spoolSignal;
    int fd_shm;
    char currBuff[200];
    
    if ((mutexSem = sem_open (MUTEX, 0, 0, 0)) == SEM_FAILED)
        error ("sem_open");
    if ((fd_shm = shm_open (SHARED_MEMORY, O_RDWR, 0)) == -1)
        error ("shm_open");

    if ((memoryPtr = mmap (NULL, sizeof (struct shared_memory), PROT_READ 
        | PROT_WRITE, MAP_SHARED,fd_shm, 0)) == MAP_FAILED)
       error ("mmap");
    if ((bufferCnt = sem_open (BUFFER_COUNT, 0, 0, 0)) == SEM_FAILED)
        error ("sem_open");

    if ((spoolSignal = sem_open (SPOOL_SIGNAL, 0, 0, 0)) == SEM_FAILED)
        error ("sem_open");
    printf ("input string: ");

    while (fgets (currBuff, 198, stdin)) 
    {
        int length = strlen (currBuff);
        if (currBuff [length - 1] == '\n')
           currBuff [length - 1] = '\0';

        if (sem_wait (bufferCnt) == -1)
            error ("sem_wait: bufferCnt");
        if (sem_wait (mutexSem) == -1)
            error ("sem_wait: mutexSem");
        sprintf (memoryPtr -> buffer[memoryPtr -> index], "%d: %s\n", getpid (), 
                    currBuff);
        (memoryPtr -> index)++;
        if (memoryPtr -> index == MAX)
            memoryPtr -> index = 0;
        if (sem_post (mutexSem) == -1)
            error ("sem_post: mutexSem");
        if (sem_post (spoolSignal) == -1)
            error ("sem_post: (spoolSignal");

        printf ("input string: ");
    }
 
    if (munmap (memoryPtr, sizeof (struct shared_memory)) == -1)
        error ("munmap");
    exit (0);
}

void error (char *msg)
{
    perror (msg);
    exit (1);
}