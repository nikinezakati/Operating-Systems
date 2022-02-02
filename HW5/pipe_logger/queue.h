#define id 123
#define path "queue.h" 
#define Len    4
#define Count  4

typedef struct {
  long type;               
  char payload[Len + 1]; 
} queue;
