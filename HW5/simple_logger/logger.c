#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
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
    char buffer [MAX][256];
    int index;
    int printIndex;
};

void error (char *msg);
int main (int argc, char **argv)
{
    struct shared_memory *memoryPtr;
    sem_t *mutexSem, *bufferCnt, *spoolSignal;
    int fd_shm, fd_log;
    char currbuffer [256];
    
    if ((fd_log = open (LOGFILE, O_CREAT | O_WRONLY 
                    | O_APPEND | O_SYNC, 0666)) == -1)
        error ("fopen");
    
    if ((mutexSem = sem_open (MUTEX, O_CREAT, 0660, 0)) == SEM_FAILED)
        error ("sem_open");

    if ((fd_shm = shm_open (SHARED_MEMORY, O_RDWR 
                        | O_CREAT | O_EXCL, 0660)) == -1)
        error("shm_open");
    if (ftruncate (fd_shm, sizeof (struct shared_memory)) == -1)
       error ("ftruncate");
    
    if ((memoryPtr = mmap (NULL, sizeof (struct shared_memory), PROT_READ \
                    | PROT_WRITE, MAP_SHARED,
            fd_shm, 0)) == MAP_FAILED)
       error("mmap");

    memoryPtr -> index = memoryPtr -> printIndex = 0;
    if ((bufferCnt = sem_open (BUFFER_COUNT, O_CREAT 
                | O_EXCL, 0660, MAX)) == SEM_FAILED)
        error ("sem_open");

    if ((spoolSignal = sem_open (SPOOL_SIGNAL, O_CREAT 
                    | O_EXCL, 0660, 0)) == SEM_FAILED)
        error ("sem_open");
    if (sem_post (mutexSem) == -1)
        error ("sem_post: mutexSem");

    while (1) 
    { 
        if (sem_wait(spoolSignal) == -1)
            error ("sem_wait: spoolSignal");

        strcpy (currbuffer, memoryPtr -> buffer[memoryPtr -> printIndex]);
        (memoryPtr -> printIndex)++;
        if (memoryPtr -> printIndex == MAX)
           memoryPtr -> printIndex = 0;
        if (sem_post(bufferCnt) == -1)
            error("sem_post: bufferCnt");
        
        if (write(fd_log, currbuffer, strlen (currbuffer)) != strlen (currbuffer))
            error("write: logfile");
    }
}

void error(char *msg)
{
    perror (msg);
    exit (1);
}