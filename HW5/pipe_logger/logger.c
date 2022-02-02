#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <stdlib.h>
#include <string.h>
#include "queue.h"
#include <sys/stat.h>   
#include <stdbool.h>    
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define LOGFILE "/Users/nikinezakati/Desktop/OS/HW5/pipe_logger/example.txt"

void error(const char* msg) 
{
  perror(msg);
  exit(-1); 
}

int main() 
{
    key_t key= ftok(path, id); 
    if (key < 0) 
        error("keyfetchfailed");

    int qid = msgget(key, 0666 | IPC_CREAT); 
    if (qid < 0) 
        error("queueaccesfailed");

    int tags[] = {3, 2, 1, 3};
    for (int i = 0; i < Count; i++) 
    {
        queue msg;
        if (msgrcv(qid, &msg, sizeof(msg), tags[i], MSG_NOERROR 
                    | IPC_NOWAIT) < 0)
            puts("msgrcvfailed");
        int fd = open(LOGFILE, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
        fprintf(fd,"%i %s:\n", msg.payload, (int) msg.type);
        close(fd);
    }

    if (msgctl(qid, IPC_RMID, NULL) < 0)  
        error("queueremovefailed");

  return 0;
}