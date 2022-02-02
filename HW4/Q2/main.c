#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <stdbool.h>
#include <time.h>

#define M 10000
#define UNIT_COUNT 5

pthread_mutex_t lock;

typedef struct { 
    int id;
    int value;
    int atime;
    int unit_count;
    int *unit_id;
} Task;

Task queue[M];
int front = 0;
int rear = -1;
int count = 0;
int  Size() {return count;}  

Task Peek() {return queue[front];}
bool Empty() {return count == 0;}

Task dequeue() 
{
   Task t = queue[front++];	
   if(front == M)
      front = 0;
   count--;
   return t;  
}

void enqueue(Task data) 
{
    if(rear == M - 1) 
        rear = -1;
    queue[++rear] = data;
    count++;
}

void *func_thread(void *_arg) 
{
    pthread_mutex_lock(&lock);
    Task task = *((Task *) _arg);
    if (task.unit_id[task.unit_count - 1] == 0) 
        task.value = (task.value+7)%M;

    else if (task.unit_id[task.unit_count - 1] == 1) 
        task.value = (task.value*2)%M;
        
    else if (task.unit_id[task.unit_count - 1] == 2) 
        task.value = (task.value * task.value * task.value * task.value * task.value)%M;

    else if (task.unit_id[task.unit_count - 1] == 3) 
        task.value = 19-task.value;

    else if (task.unit_id[task.unit_count - 1] == 4) 
    {
        struct tm * timeinfo;
        time_t elapse;
        time (&elapse);
        timeinfo = localtime (&elapse);
        printf("%s tid: %d value: %d", asctime(timeinfo), task.id, task.value);
    } 
    task.unit_count--;
    pthread_mutex_unlock(&lock);
    sleep(0.5);
} 

int main (int argc, char *argv[]) {
    FILE *fp;
    fp = fopen("/Users/nikinezakati/Desktop/OS/HW4/Q2/input.txt", "r");
    if (fp == NULL) 
    {
        printf("Error! opening file");
        exit(1);
    }
    int task_id;
    while (true)
    {
        Task new_task;
        fscanf(fp, "%d", &task_id);
        if (feof(fp))
             break;
        new_task.id = task_id;

        fscanf(fp, "%d", &new_task.value);
        fscanf(fp, "%d", &new_task.unit_count);
        int units[new_task.unit_count];
        new_task.unit_id = units;

        for (int i = 0; i < new_task.unit_count; ++i) 
            fscanf(fp, "%d", &new_task.unit_id[i]);

        enqueue(new_task);
    }
    fclose(fp);

    pthread_mutex_init(&lock, NULL);
    while (!Empty())
    {
        Task task = dequeue();
        if (task.unit_count == 0)
            continue;
        pthread_t thread_id;
        pthread_create(&thread_id, NULL, func_thread, (void *)&task);
        enqueue(task);
    }
    return 0;
}