
_proc_dump_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "proc.h"
#include "user.h"
#include "x86.h"


int main(int argc, const char *argv[]) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	81 ec 30 01 00 00    	sub    $0x130,%esp

    int pid[NPROC];
    int count = atoi(argv[1]);
   f:	8b 45 0c             	mov    0xc(%ebp),%eax
  12:	8b 40 04             	mov    0x4(%eax),%eax
  15:	89 04 24             	mov    %eax,(%esp)
  18:	e8 13 03 00 00       	call   330 <atoi>
    for(int i = 0; i < count; ++i) 
  1d:	85 c0                	test   %eax,%eax
    int count = atoi(argv[1]);
  1f:	89 c3                	mov    %eax,%ebx
    for(int i = 0; i < count; ++i) 
  21:	0f 8e d9 00 00 00    	jle    100 <main+0x100>
  27:	8d 7c 24 30          	lea    0x30(%esp),%edi
  2b:	31 f6                	xor    %esi,%esi
  2d:	eb 04                	jmp    33 <main+0x33>
  2f:	39 f3                	cmp    %esi,%ebx
  31:	74 3b                	je     6e <main+0x6e>
    {
        pid[i] = fork();
  33:	e8 63 03 00 00       	call   39b <fork>
  38:	89 f2                	mov    %esi,%edx
  3a:	89 04 b7             	mov    %eax,(%edi,%esi,4)
        if(!pid[i]) 
  3d:	46                   	inc    %esi
  3e:	85 c0                	test   %eax,%eax
  40:	75 ed                	jne    2f <main+0x2f>
        {
            int rand = ((i + 1) * 76235 + (count - i) * 42423);
  42:	69 f6 cb 29 01 00    	imul   $0x129cb,%esi,%esi
  48:	89 d8                	mov    %ebx,%eax
  4a:	29 d0                	sub    %edx,%eax
  4c:	69 c0 b7 a5 00 00    	imul   $0xa5b7,%eax,%eax
  52:	01 c6                	add    %eax,%esi
            char *data = malloc(sizeof(char) * rand);
  54:	89 34 24             	mov    %esi,(%esp)
  57:	e8 34 07 00 00       	call   790 <malloc>
            memset(data, rand, sizeof(char) * rand);
  5c:	89 74 24 08          	mov    %esi,0x8(%esp)
  60:	89 74 24 04          	mov    %esi,0x4(%esp)
  64:	89 04 24             	mov    %eax,(%esp)
  67:	e8 84 01 00 00       	call   1f0 <memset>
            while(1);
  6c:	eb fe                	jmp    6c <main+0x6c>
        }
    }
    sleep(50);
  6e:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
  75:	e8 b9 03 00 00       	call   433 <sleep>

    int size;
    struct proc_info *process = malloc(sizeof(struct proc_info) * NPROC);
  7a:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
  81:	e8 0a 07 00 00       	call   790 <malloc>
  86:	89 c6                	mov    %eax,%esi
    proc_dump(process, &size);
  88:	89 34 24             	mov    %esi,(%esp)
  8b:	8d 44 24 2c          	lea    0x2c(%esp),%eax
  8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  93:	e8 ab 03 00 00       	call   443 <proc_dump>
    for (int i = 0; i < size; ++i) 
  98:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  9d:	7e 35                	jle    d4 <main+0xd4>
  9f:	31 ff                	xor    %edi,%edi
        printf(1, "id: %d, memsize: %d\n", process[i].pid, process[i].memsize);
  a1:	8b 44 fe 04          	mov    0x4(%esi,%edi,8),%eax
  a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  a9:	8b 04 fe             	mov    (%esi,%edi,8),%eax
    for (int i = 0; i < size; ++i) 
  ac:	47                   	inc    %edi
        printf(1, "id: %d, memsize: %d\n", process[i].pid, process[i].memsize);
  ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  b8:	b8 88 08 00 00       	mov    $0x888,%eax
  bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  c1:	e8 5a 04 00 00       	call   520 <printf>
    for (int i = 0; i < size; ++i) 
  c6:	39 7c 24 2c          	cmp    %edi,0x2c(%esp)
  ca:	7f d5                	jg     a1 <main+0xa1>
    
    for(int i = 0; i < count; ++i) 
  cc:	85 db                	test   %ebx,%ebx
  ce:	7e 23                	jle    f3 <main+0xf3>
  d0:	8d 7c 24 30          	lea    0x30(%esp),%edi
    for (int i = 0; i < size; ++i) 
  d4:	31 d2                	xor    %edx,%edx
    {
        kill(pid[i]);
  d6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  da:	8b 04 97             	mov    (%edi,%edx,4),%eax
  dd:	89 04 24             	mov    %eax,(%esp)
  e0:	e8 ee 02 00 00       	call   3d3 <kill>
        wait();
  e5:	e8 c1 02 00 00       	call   3ab <wait>
    for(int i = 0; i < count; ++i) 
  ea:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  ee:	42                   	inc    %edx
  ef:	39 d3                	cmp    %edx,%ebx
  f1:	7f e3                	jg     d6 <main+0xd6>
    }
    free(process);
  f3:	89 34 24             	mov    %esi,(%esp)
  f6:	e8 05 06 00 00       	call   700 <free>
    
    exit();
  fb:	e8 a3 02 00 00       	call   3a3 <exit>
    sleep(50);
 100:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
 107:	e8 27 03 00 00       	call   433 <sleep>
    struct proc_info *process = malloc(sizeof(struct proc_info) * NPROC);
 10c:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
 113:	e8 78 06 00 00       	call   790 <malloc>
 118:	89 c6                	mov    %eax,%esi
    proc_dump(process, &size);
 11a:	89 34 24             	mov    %esi,(%esp)
 11d:	8d 44 24 2c          	lea    0x2c(%esp),%eax
 121:	89 44 24 04          	mov    %eax,0x4(%esp)
 125:	e8 19 03 00 00       	call   443 <proc_dump>
    for (int i = 0; i < size; ++i) 
 12a:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
 12f:	0f 8f 6a ff ff ff    	jg     9f <main+0x9f>
 135:	eb bc                	jmp    f3 <main+0xf3>
 137:	66 90                	xchg   %ax,%ax
 139:	66 90                	xchg   %ax,%ax
 13b:	66 90                	xchg   %ax,%ax
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 140:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 141:	31 c0                	xor    %eax,%eax
{
 143:	89 e5                	mov    %esp,%ebp
 145:	53                   	push   %ebx
 146:	8b 4d 08             	mov    0x8(%ebp),%ecx
 149:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 150:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 154:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 157:	40                   	inc    %eax
 158:	84 d2                	test   %dl,%dl
 15a:	75 f4                	jne    150 <strcpy+0x10>
    ;
  return os;
}
 15c:	5b                   	pop    %ebx
 15d:	89 c8                	mov    %ecx,%eax
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    
 161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop

00000170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	8b 5d 08             	mov    0x8(%ebp),%ebx
 177:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 17a:	0f b6 03             	movzbl (%ebx),%eax
 17d:	0f b6 0a             	movzbl (%edx),%ecx
 180:	84 c0                	test   %al,%al
 182:	75 19                	jne    19d <strcmp+0x2d>
 184:	eb 2a                	jmp    1b0 <strcmp+0x40>
 186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18d:	8d 76 00             	lea    0x0(%esi),%esi
 190:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
 194:	43                   	inc    %ebx
 195:	42                   	inc    %edx
  while(*p && *p == *q)
 196:	0f b6 0a             	movzbl (%edx),%ecx
 199:	84 c0                	test   %al,%al
 19b:	74 13                	je     1b0 <strcmp+0x40>
 19d:	38 c8                	cmp    %cl,%al
 19f:	74 ef                	je     190 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
 1a1:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
 1a2:	29 c8                	sub    %ecx,%eax
}
 1a4:	5d                   	pop    %ebp
 1a5:	c3                   	ret    
 1a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
 1b0:	5b                   	pop    %ebx
 1b1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1b3:	29 c8                	sub    %ecx,%eax
}
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1be:	66 90                	xchg   %ax,%ax

000001c0 <strlen>:

uint
strlen(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1c6:	80 3a 00             	cmpb   $0x0,(%edx)
 1c9:	74 15                	je     1e0 <strlen+0x20>
 1cb:	31 c0                	xor    %eax,%eax
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
 1d0:	40                   	inc    %eax
 1d1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1d5:	89 c1                	mov    %eax,%ecx
 1d7:	75 f7                	jne    1d0 <strlen+0x10>
    ;
  return n;
}
 1d9:	5d                   	pop    %ebp
 1da:	89 c8                	mov    %ecx,%eax
 1dc:	c3                   	ret    
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
 1e0:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
 1e1:	31 c9                	xor    %ecx,%ecx
}
 1e3:	89 c8                	mov    %ecx,%eax
 1e5:	c3                   	ret    
 1e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ed:	8d 76 00             	lea    0x0(%esi),%esi

000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 55 08             	mov    0x8(%ebp),%edx
 1f6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	89 d7                	mov    %edx,%edi
 1ff:	fc                   	cld    
 200:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 202:	5f                   	pop    %edi
 203:	89 d0                	mov    %edx,%eax
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax

00000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 21a:	0f b6 10             	movzbl (%eax),%edx
 21d:	84 d2                	test   %dl,%dl
 21f:	75 18                	jne    239 <strchr+0x29>
 221:	eb 1d                	jmp    240 <strchr+0x30>
 223:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 230:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 234:	40                   	inc    %eax
 235:	84 d2                	test   %dl,%dl
 237:	74 07                	je     240 <strchr+0x30>
    if(*s == c)
 239:	38 d1                	cmp    %dl,%cl
 23b:	75 f3                	jne    230 <strchr+0x20>
      return (char*)s;
  return 0;
}
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret    
 23f:	90                   	nop
 240:	5d                   	pop    %ebp
  return 0;
 241:	31 c0                	xor    %eax,%eax
}
 243:	c3                   	ret    
 244:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 24f:	90                   	nop

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	56                   	push   %esi
 255:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 258:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 25b:	83 ec 3c             	sub    $0x3c,%esp
 25e:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 261:	eb 3a                	jmp    29d <gets+0x4d>
 263:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 270:	89 7c 24 04          	mov    %edi,0x4(%esp)
 274:	ba 01 00 00 00       	mov    $0x1,%edx
 279:	89 54 24 08          	mov    %edx,0x8(%esp)
 27d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 284:	e8 32 01 00 00       	call   3bb <read>
    if(cc < 1)
 289:	85 c0                	test   %eax,%eax
 28b:	7e 19                	jle    2a6 <gets+0x56>
      break;
    buf[i++] = c;
 28d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 291:	46                   	inc    %esi
 292:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 295:	3c 0a                	cmp    $0xa,%al
 297:	74 27                	je     2c0 <gets+0x70>
 299:	3c 0d                	cmp    $0xd,%al
 29b:	74 23                	je     2c0 <gets+0x70>
  for(i=0; i+1 < max; ){
 29d:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 2a0:	43                   	inc    %ebx
 2a1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2a4:	7c ca                	jl     270 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 2a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	83 c4 3c             	add    $0x3c,%esp
 2b2:	5b                   	pop    %ebx
 2b3:	5e                   	pop    %esi
 2b4:	5f                   	pop    %edi
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    
 2b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2be:	66 90                	xchg   %ax,%ax
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	01 c3                	add    %eax,%ebx
 2c5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 2c8:	eb dc                	jmp    2a6 <gets+0x56>
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d0:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d1:	31 c0                	xor    %eax,%eax
{
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 2d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
{
 2df:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2e2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 2e5:	89 04 24             	mov    %eax,(%esp)
 2e8:	e8 f6 00 00 00       	call   3e3 <open>
  if(fd < 0)
 2ed:	85 c0                	test   %eax,%eax
 2ef:	78 2f                	js     320 <stat+0x50>
 2f1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f6:	89 1c 24             	mov    %ebx,(%esp)
 2f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fd:	e8 f9 00 00 00       	call   3fb <fstat>
  close(fd);
 302:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 305:	89 c6                	mov    %eax,%esi
  close(fd);
 307:	e8 bf 00 00 00       	call   3cb <close>
  return r;
}
 30c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 30f:	89 f0                	mov    %esi,%eax
 311:	8b 75 fc             	mov    -0x4(%ebp),%esi
 314:	89 ec                	mov    %ebp,%esp
 316:	5d                   	pop    %ebp
 317:	c3                   	ret    
 318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31f:	90                   	nop
    return -1;
 320:	be ff ff ff ff       	mov    $0xffffffff,%esi
 325:	eb e5                	jmp    30c <stat+0x3c>
 327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32e:	66 90                	xchg   %ax,%ax

00000330 <atoi>:

int
atoi(const char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 337:	0f be 02             	movsbl (%edx),%eax
 33a:	88 c1                	mov    %al,%cl
 33c:	80 e9 30             	sub    $0x30,%cl
 33f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 342:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 347:	77 1c                	ja     365 <atoi+0x35>
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 350:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 353:	42                   	inc    %edx
 354:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 358:	0f be 02             	movsbl (%edx),%eax
 35b:	88 c3                	mov    %al,%bl
 35d:	80 eb 30             	sub    $0x30,%bl
 360:	80 fb 09             	cmp    $0x9,%bl
 363:	76 eb                	jbe    350 <atoi+0x20>
  return n;
}
 365:	5b                   	pop    %ebx
 366:	89 c8                	mov    %ecx,%eax
 368:	5d                   	pop    %ebp
 369:	c3                   	ret    
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000370 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	8b 45 10             	mov    0x10(%ebp),%eax
 377:	56                   	push   %esi
 378:	8b 55 08             	mov    0x8(%ebp),%edx
 37b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 37e:	85 c0                	test   %eax,%eax
 380:	7e 13                	jle    395 <memmove+0x25>
 382:	01 d0                	add    %edx,%eax
  dst = vdst;
 384:	89 d7                	mov    %edx,%edi
 386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 38d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 390:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 391:	39 f8                	cmp    %edi,%eax
 393:	75 fb                	jne    390 <memmove+0x20>
  return vdst;
}
 395:	5e                   	pop    %esi
 396:	89 d0                	mov    %edx,%eax
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    

0000039b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39b:	b8 01 00 00 00       	mov    $0x1,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <exit>:
SYSCALL(exit)
 3a3:	b8 02 00 00 00       	mov    $0x2,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <wait>:
SYSCALL(wait)
 3ab:	b8 03 00 00 00       	mov    $0x3,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <pipe>:
SYSCALL(pipe)
 3b3:	b8 04 00 00 00       	mov    $0x4,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <read>:
SYSCALL(read)
 3bb:	b8 05 00 00 00       	mov    $0x5,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <write>:
SYSCALL(write)
 3c3:	b8 10 00 00 00       	mov    $0x10,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <close>:
SYSCALL(close)
 3cb:	b8 15 00 00 00       	mov    $0x15,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <kill>:
SYSCALL(kill)
 3d3:	b8 06 00 00 00       	mov    $0x6,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <exec>:
SYSCALL(exec)
 3db:	b8 07 00 00 00       	mov    $0x7,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <open>:
SYSCALL(open)
 3e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mknod>:
SYSCALL(mknod)
 3eb:	b8 11 00 00 00       	mov    $0x11,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <unlink>:
SYSCALL(unlink)
 3f3:	b8 12 00 00 00       	mov    $0x12,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <fstat>:
SYSCALL(fstat)
 3fb:	b8 08 00 00 00       	mov    $0x8,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <link>:
SYSCALL(link)
 403:	b8 13 00 00 00       	mov    $0x13,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mkdir>:
SYSCALL(mkdir)
 40b:	b8 14 00 00 00       	mov    $0x14,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <chdir>:
SYSCALL(chdir)
 413:	b8 09 00 00 00       	mov    $0x9,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <dup>:
SYSCALL(dup)
 41b:	b8 0a 00 00 00       	mov    $0xa,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <getpid>:
SYSCALL(getpid)
 423:	b8 0b 00 00 00       	mov    $0xb,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <sbrk>:
SYSCALL(sbrk)
 42b:	b8 0c 00 00 00       	mov    $0xc,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sleep>:
SYSCALL(sleep)
 433:	b8 0d 00 00 00       	mov    $0xd,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <uptime>:
SYSCALL(uptime)
 43b:	b8 0e 00 00 00       	mov    $0xe,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <proc_dump>:
 443:	b8 16 00 00 00       	mov    $0x16,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    
 44b:	66 90                	xchg   %ax,%ax
 44d:	66 90                	xchg   %ax,%ax
 44f:	90                   	nop

00000450 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	89 cf                	mov    %ecx,%edi
 456:	56                   	push   %esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 457:	89 d1                	mov    %edx,%ecx
{
 459:	53                   	push   %ebx
 45a:	83 ec 4c             	sub    $0x4c,%esp
 45d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 460:	89 d0                	mov    %edx,%eax
 462:	c1 e8 1f             	shr    $0x1f,%eax
 465:	84 c0                	test   %al,%al
 467:	0f 84 a3 00 00 00    	je     510 <printint+0xc0>
 46d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 471:	0f 84 99 00 00 00    	je     510 <printint+0xc0>
    neg = 1;
 477:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 47e:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 480:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 487:	8d 75 d7             	lea    -0x29(%ebp),%esi
 48a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 48d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 490:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 493:	31 d2                	xor    %edx,%edx
 495:	8b 5d c0             	mov    -0x40(%ebp),%ebx
 498:	f7 f7                	div    %edi
 49a:	8d 4b 01             	lea    0x1(%ebx),%ecx
 49d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 4a0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  }while((x /= base) != 0);
 4a3:	39 cf                	cmp    %ecx,%edi
 4a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    buf[i++] = digits[x % base];
 4a8:	0f b6 92 a4 08 00 00 	movzbl 0x8a4(%edx),%edx
 4af:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 4b3:	76 db                	jbe    490 <printint+0x40>
  if(neg)
 4b5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4b8:	85 c9                	test   %ecx,%ecx
 4ba:	74 0c                	je     4c8 <printint+0x78>
    buf[i++] = '-';
 4bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
 4bf:	b2 2d                	mov    $0x2d,%dl
 4c1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    buf[i++] = digits[x % base];
 4c6:	89 c3                	mov    %eax,%ebx

  while(--i >= 0)
 4c8:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4cb:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 4cf:	eb 13                	jmp    4e4 <printint+0x94>
 4d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop
 4e0:	0f b6 13             	movzbl (%ebx),%edx
 4e3:	4b                   	dec    %ebx
  write(fd, &c, 1);
 4e4:	89 74 24 04          	mov    %esi,0x4(%esp)
 4e8:	b8 01 00 00 00       	mov    $0x1,%eax
 4ed:	89 44 24 08          	mov    %eax,0x8(%esp)
 4f1:	89 3c 24             	mov    %edi,(%esp)
 4f4:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4f7:	e8 c7 fe ff ff       	call   3c3 <write>
  while(--i >= 0)
 4fc:	39 de                	cmp    %ebx,%esi
 4fe:	75 e0                	jne    4e0 <printint+0x90>
    putc(fd, buf[i]);
}
 500:	83 c4 4c             	add    $0x4c,%esp
 503:	5b                   	pop    %ebx
 504:	5e                   	pop    %esi
 505:	5f                   	pop    %edi
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    
 508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50f:	90                   	nop
  neg = 0;
 510:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 517:	e9 64 ff ff ff       	jmp    480 <printint+0x30>
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000520 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 529:	8b 75 0c             	mov    0xc(%ebp),%esi
 52c:	0f b6 1e             	movzbl (%esi),%ebx
 52f:	84 db                	test   %bl,%bl
 531:	0f 84 c8 00 00 00    	je     5ff <printf+0xdf>
  ap = (uint*)(void*)&fmt + 1;
 537:	8d 45 10             	lea    0x10(%ebp),%eax
 53a:	46                   	inc    %esi
 53b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  write(fd, &c, 1);
 53e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 541:	31 d2                	xor    %edx,%edx
 543:	eb 3e                	jmp    583 <printf+0x63>
 545:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 550:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 553:	83 f8 25             	cmp    $0x25,%eax
        state = '%';
 556:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 55b:	74 1e                	je     57b <printf+0x5b>
  write(fd, &c, 1);
 55d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 561:	b8 01 00 00 00       	mov    $0x1,%eax
 566:	89 44 24 08          	mov    %eax,0x8(%esp)
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	88 5d e7             	mov    %bl,-0x19(%ebp)
 570:	89 04 24             	mov    %eax,(%esp)
 573:	e8 4b fe ff ff       	call   3c3 <write>
 578:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 57b:	0f b6 1e             	movzbl (%esi),%ebx
 57e:	46                   	inc    %esi
 57f:	84 db                	test   %bl,%bl
 581:	74 7c                	je     5ff <printf+0xdf>
    if(state == 0){
 583:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 585:	0f be cb             	movsbl %bl,%ecx
 588:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 58b:	74 c3                	je     550 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 58d:	83 fa 25             	cmp    $0x25,%edx
 590:	75 e9                	jne    57b <printf+0x5b>
      if(c == 'd'){
 592:	83 f8 64             	cmp    $0x64,%eax
 595:	0f 84 a5 00 00 00    	je     640 <printf+0x120>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 59b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5a1:	83 f9 70             	cmp    $0x70,%ecx
 5a4:	74 6a                	je     610 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5a6:	83 f8 73             	cmp    $0x73,%eax
 5a9:	0f 84 e1 00 00 00    	je     690 <printf+0x170>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5af:	83 f8 63             	cmp    $0x63,%eax
 5b2:	0f 84 98 00 00 00    	je     650 <printf+0x130>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5b8:	83 f8 25             	cmp    $0x25,%eax
 5bb:	74 1c                	je     5d9 <printf+0xb9>
  write(fd, &c, 1);
 5bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	ba 01 00 00 00       	mov    $0x1,%edx
 5c9:	89 54 24 08          	mov    %edx,0x8(%esp)
 5cd:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 ea fd ff ff       	call   3c3 <write>
 5d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
 5dd:	b8 01 00 00 00       	mov    $0x1,%eax
 5e2:	46                   	inc    %esi
 5e3:	89 44 24 08          	mov    %eax,0x8(%esp)
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ed:	89 04 24             	mov    %eax,(%esp)
 5f0:	e8 ce fd ff ff       	call   3c3 <write>
  for(i = 0; fmt[i]; i++){
 5f5:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5f9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5fb:	84 db                	test   %bl,%bl
 5fd:	75 84                	jne    583 <printf+0x63>
    }
  }
}
 5ff:	83 c4 3c             	add    $0x3c,%esp
 602:	5b                   	pop    %ebx
 603:	5e                   	pop    %esi
 604:	5f                   	pop    %edi
 605:	5d                   	pop    %ebp
 606:	c3                   	ret    
 607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 610:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 617:	b9 10 00 00 00       	mov    $0x10,%ecx
 61c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	8b 13                	mov    (%ebx),%edx
 624:	e8 27 fe ff ff       	call   450 <printint>
        ap++;
 629:	89 d8                	mov    %ebx,%eax
      state = 0;
 62b:	31 d2                	xor    %edx,%edx
        ap++;
 62d:	83 c0 04             	add    $0x4,%eax
 630:	89 45 d0             	mov    %eax,-0x30(%ebp)
 633:	e9 43 ff ff ff       	jmp    57b <printf+0x5b>
 638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop
        printint(fd, *ap, 10, 1);
 640:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 647:	b9 0a 00 00 00       	mov    $0xa,%ecx
 64c:	eb ce                	jmp    61c <printf+0xfc>
 64e:	66 90                	xchg   %ax,%ax
        putc(fd, *ap);
 650:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 653:	b9 01 00 00 00       	mov    $0x1,%ecx
        putc(fd, *ap);
 658:	8b 03                	mov    (%ebx),%eax
        ap++;
 65a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 65d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 661:	89 7c 24 04          	mov    %edi,0x4(%esp)
        putc(fd, *ap);
 665:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 668:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
 66c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	89 04 24             	mov    %eax,(%esp)
 675:	e8 49 fd ff ff       	call   3c3 <write>
      state = 0;
 67a:	31 d2                	xor    %edx,%edx
        ap++;
 67c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 67f:	e9 f7 fe ff ff       	jmp    57b <printf+0x5b>
 684:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop
        s = (char*)*ap;
 690:	8b 45 d0             	mov    -0x30(%ebp),%eax
 693:	8b 18                	mov    (%eax),%ebx
        ap++;
 695:	83 c0 04             	add    $0x4,%eax
 698:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 69b:	85 db                	test   %ebx,%ebx
 69d:	74 11                	je     6b0 <printf+0x190>
        while(*s != 0){
 69f:	0f b6 03             	movzbl (%ebx),%eax
 6a2:	84 c0                	test   %al,%al
 6a4:	74 44                	je     6ea <printf+0x1ca>
 6a6:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6a9:	89 de                	mov    %ebx,%esi
 6ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6ae:	eb 10                	jmp    6c0 <printf+0x1a0>
 6b0:	89 75 d4             	mov    %esi,-0x2c(%ebp)
          s = "(null)";
 6b3:	bb 9d 08 00 00       	mov    $0x89d,%ebx
        while(*s != 0){
 6b8:	b0 28                	mov    $0x28,%al
 6ba:	89 de                	mov    %ebx,%esi
 6bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6bf:	90                   	nop
          putc(fd, *s);
 6c0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6c3:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 6c8:	46                   	inc    %esi
  write(fd, &c, 1);
 6c9:	89 44 24 08          	mov    %eax,0x8(%esp)
 6cd:	89 7c 24 04          	mov    %edi,0x4(%esp)
 6d1:	89 1c 24             	mov    %ebx,(%esp)
 6d4:	e8 ea fc ff ff       	call   3c3 <write>
        while(*s != 0){
 6d9:	0f b6 06             	movzbl (%esi),%eax
 6dc:	84 c0                	test   %al,%al
 6de:	75 e0                	jne    6c0 <printf+0x1a0>
 6e0:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 6e3:	31 d2                	xor    %edx,%edx
 6e5:	e9 91 fe ff ff       	jmp    57b <printf+0x5b>
 6ea:	31 d2                	xor    %edx,%edx
 6ec:	e9 8a fe ff ff       	jmp    57b <printf+0x5b>
 6f1:	66 90                	xchg   %ax,%ax
 6f3:	66 90                	xchg   %ax,%ax
 6f5:	66 90                	xchg   %ax,%ax
 6f7:	66 90                	xchg   %ax,%ax
 6f9:	66 90                	xchg   %ax,%ax
 6fb:	66 90                	xchg   %ax,%ax
 6fd:	66 90                	xchg   %ax,%ax
 6ff:	90                   	nop

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	a1 3c 0b 00 00       	mov    0xb3c,%eax
{
 706:	89 e5                	mov    %esp,%ebp
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	53                   	push   %ebx
 70b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 70e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 710:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 713:	39 c8                	cmp    %ecx,%eax
 715:	73 19                	jae    730 <free+0x30>
 717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71e:	66 90                	xchg   %ax,%ax
 720:	39 d1                	cmp    %edx,%ecx
 722:	72 14                	jb     738 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	39 d0                	cmp    %edx,%eax
 726:	73 10                	jae    738 <free+0x38>
{
 728:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	39 c8                	cmp    %ecx,%eax
 72c:	8b 10                	mov    (%eax),%edx
 72e:	72 f0                	jb     720 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	39 d0                	cmp    %edx,%eax
 732:	72 f4                	jb     728 <free+0x28>
 734:	39 d1                	cmp    %edx,%ecx
 736:	73 f0                	jae    728 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 738:	8b 73 fc             	mov    -0x4(%ebx),%esi
 73b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 73e:	39 fa                	cmp    %edi,%edx
 740:	74 1e                	je     760 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 742:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 745:	8b 50 04             	mov    0x4(%eax),%edx
 748:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 74b:	39 f1                	cmp    %esi,%ecx
 74d:	74 2a                	je     779 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 74f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 751:	5b                   	pop    %ebx
  freep = p;
 752:	a3 3c 0b 00 00       	mov    %eax,0xb3c
}
 757:	5e                   	pop    %esi
 758:	5f                   	pop    %edi
 759:	5d                   	pop    %ebp
 75a:	c3                   	ret    
 75b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 760:	8b 7a 04             	mov    0x4(%edx),%edi
 763:	01 fe                	add    %edi,%esi
 765:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	8b 10                	mov    (%eax),%edx
 76a:	8b 12                	mov    (%edx),%edx
 76c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 76f:	8b 50 04             	mov    0x4(%eax),%edx
 772:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 775:	39 f1                	cmp    %esi,%ecx
 777:	75 d6                	jne    74f <free+0x4f>
  freep = p;
 779:	a3 3c 0b 00 00       	mov    %eax,0xb3c
    p->s.size += bp->s.size;
 77e:	8b 4b fc             	mov    -0x4(%ebx),%ecx
 781:	01 ca                	add    %ecx,%edx
 783:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 786:	8b 53 f8             	mov    -0x8(%ebx),%edx
 789:	89 10                	mov    %edx,(%eax)
}
 78b:	5b                   	pop    %ebx
 78c:	5e                   	pop    %esi
 78d:	5f                   	pop    %edi
 78e:	5d                   	pop    %ebp
 78f:	c3                   	ret    

00000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 79c:	8b 3d 3c 0b 00 00    	mov    0xb3c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	8d 70 07             	lea    0x7(%eax),%esi
 7a5:	c1 ee 03             	shr    $0x3,%esi
 7a8:	46                   	inc    %esi
  if((prevp = freep) == 0){
 7a9:	85 ff                	test   %edi,%edi
 7ab:	0f 84 9f 00 00 00    	je     850 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b1:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 7b3:	8b 48 04             	mov    0x4(%eax),%ecx
 7b6:	39 f1                	cmp    %esi,%ecx
 7b8:	73 6c                	jae    826 <malloc+0x96>
 7ba:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7c0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7c5:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7c8:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 7cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 7d2:	eb 1d                	jmp    7f1 <malloc+0x61>
 7d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7df:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 7e2:	8b 4a 04             	mov    0x4(%edx),%ecx
 7e5:	39 f1                	cmp    %esi,%ecx
 7e7:	73 47                	jae    830 <malloc+0xa0>
 7e9:	8b 3d 3c 0b 00 00    	mov    0xb3c,%edi
 7ef:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f1:	39 c7                	cmp    %eax,%edi
 7f3:	75 eb                	jne    7e0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 7f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f8:	89 04 24             	mov    %eax,(%esp)
 7fb:	e8 2b fc ff ff       	call   42b <sbrk>
  if(p == (char*)-1)
 800:	83 f8 ff             	cmp    $0xffffffff,%eax
 803:	74 17                	je     81c <malloc+0x8c>
  hp->s.size = nu;
 805:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 808:	83 c0 08             	add    $0x8,%eax
 80b:	89 04 24             	mov    %eax,(%esp)
 80e:	e8 ed fe ff ff       	call   700 <free>
  return freep;
 813:	a1 3c 0b 00 00       	mov    0xb3c,%eax
      if((p = morecore(nunits)) == 0)
 818:	85 c0                	test   %eax,%eax
 81a:	75 c4                	jne    7e0 <malloc+0x50>
        return 0;
  }
}
 81c:	83 c4 2c             	add    $0x2c,%esp
        return 0;
 81f:	31 c0                	xor    %eax,%eax
}
 821:	5b                   	pop    %ebx
 822:	5e                   	pop    %esi
 823:	5f                   	pop    %edi
 824:	5d                   	pop    %ebp
 825:	c3                   	ret    
    if(p->s.size >= nunits){
 826:	89 c2                	mov    %eax,%edx
 828:	89 f8                	mov    %edi,%eax
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 830:	39 ce                	cmp    %ecx,%esi
 832:	74 4c                	je     880 <malloc+0xf0>
        p->s.size -= nunits;
 834:	29 f1                	sub    %esi,%ecx
 836:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 839:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 83c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 83f:	a3 3c 0b 00 00       	mov    %eax,0xb3c
      return (void*)(p + 1);
 844:	8d 42 08             	lea    0x8(%edx),%eax
}
 847:	83 c4 2c             	add    $0x2c,%esp
 84a:	5b                   	pop    %ebx
 84b:	5e                   	pop    %esi
 84c:	5f                   	pop    %edi
 84d:	5d                   	pop    %ebp
 84e:	c3                   	ret    
 84f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 850:	b8 40 0b 00 00       	mov    $0xb40,%eax
 855:	ba 40 0b 00 00       	mov    $0xb40,%edx
 85a:	a3 3c 0b 00 00       	mov    %eax,0xb3c
    base.s.size = 0;
 85f:	31 c9                	xor    %ecx,%ecx
 861:	bf 40 0b 00 00       	mov    $0xb40,%edi
    base.s.ptr = freep = prevp = &base;
 866:	89 15 40 0b 00 00    	mov    %edx,0xb40
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 86e:	89 0d 44 0b 00 00    	mov    %ecx,0xb44
    if(p->s.size >= nunits){
 874:	e9 41 ff ff ff       	jmp    7ba <malloc+0x2a>
 879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 880:	8b 0a                	mov    (%edx),%ecx
 882:	89 08                	mov    %ecx,(%eax)
 884:	eb b9                	jmp    83f <malloc+0xaf>
