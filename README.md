# OS
Operating Systems Course - Fall 2021

In this course I implemented questions like implementing Threads, using Fork and ... in C. 

For our projects, in the phase 1, I had to add a new system call to xv6. This system call will return the running processes (RUNNING & RUNNABLE) in the form of an array of proc_info structs.

In the phase 2 of the project, we added add real kernel threads to xv6. First, I defined a new system call to create a kernel thread, called clone(). Then, I used clone() to build a little thread library, with a thread_create() call, a thread_join() call, and lock_acquire() and lock_release() functions. Finally, I showed these things work by writing a test program in which multiple threads are created by the parent, and each adds values to a shared counter.
