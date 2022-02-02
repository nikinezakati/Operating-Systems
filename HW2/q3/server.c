#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <pthread.h>
#include <pthread.h>
#include <assert.h>


// in your browser type: http://localhost:8090
// IF error: address in use then change the PORT number
#define PORT 8090

void *my_thread_funtion(void *new_socket)
{
    char buffer[30000] = {0};
    int valread;
    char *hello;
    valread = read(*(int*) new_socket , buffer, 30000);
    printf("%s\n",buffer);
    sleep(5);
    write(*(int*) new_socket , hello , strlen(hello));
    printf("-------------Hello message sent---------------");
    close(*(int*)new_socket);
    free((int*)new_socket);
    pthread_exit(NULL);
}

int main(int argc, char const *argv[])
{
    int server_fd; int* new_socket; long valread;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    
    char *hello = "HTTP/1.1 200 OK\nContent-Type: text/plain\nContent-Length: 12\n\nHello world!";
    
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
    {
        perror("In socket");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons( PORT );
    
    memset(address.sin_zero, '\0', sizeof address.sin_zero);
    
    
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address))<0)
    {
        perror("In bind");
        exit(EXIT_FAILURE);
    }
    if (listen(server_fd, 10) < 0)
    {
        perror("In listen");
        exit(EXIT_FAILURE);
    }
    while(1)
    {
        printf("\n+++++++ Waiting for new connection ++++++++\n\n");
        if ((* new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen))<0)
        {
            perror("In accept");
            exit(EXIT_FAILURE);
        }
        new_socket = (int *) malloc(sizeof(new_socket));
        pthread_t thread_id;
        int new_thread_status = pthread_create(&thread_id, NULL, *my_thread_funtion,(void*) &new_socket);
        assert(new_thread_status == 0); 
    }
    return 0;
}

