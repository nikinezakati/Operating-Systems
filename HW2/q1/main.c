#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>   
#include <stdbool.h>    
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

bool file_exists (char *filename) 
{
  struct stat   buffer;   
  return (stat (filename, &buffer) == 0);
}

int main( int argc, char *argv[] )
{
    char *my_args[3];
    if(argc<3)
    {
        printf("Not Enough Arguments\n" );
        exit(1);
    }        

    if (file_exists(argv[1]))
    {
        int r = fork();
        if (r < 0)
        {
            printf("fork failed!\n");
            exit(1);
	    } 
        else if (r == 0)
        { 
            int fd = open(argv[2], O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
            dup2(fd, 1);   
            my_args[0] = argv[1];
            if(argc<4)
                my_args[1] = "";
            else
                my_args[1] = argv[3]; 
           
            my_args[2] = NULL; 		
            execvp(my_args[0], my_args);
            close(fd);
	    } 
        else
        {
            int w = wait(NULL);
        }
    }
    else
    {
        printf("Command File Doesn't Exist Or Is Not Executable\n" );
        exit(1);
    }    

    return 0;
}