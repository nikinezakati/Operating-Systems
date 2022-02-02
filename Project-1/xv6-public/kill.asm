
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 e4 f0             	and    $0xfffffff0,%esp
   8:	83 ec 10             	sub    $0x10,%esp
   b:	8b 45 08             	mov    0x8(%ebp),%eax
   e:	8b 55 0c             	mov    0xc(%ebp),%edx
  int i;

  if(argc < 2){
  11:	83 f8 01             	cmp    $0x1,%eax
  14:	7e 28                	jle    3e <main+0x3e>
  16:	8d 5a 04             	lea    0x4(%edx),%ebx
  19:	8d 34 82             	lea    (%edx,%eax,4),%esi
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  20:	8b 03                	mov    (%ebx),%eax
  22:	83 c3 04             	add    $0x4,%ebx
  25:	89 04 24             	mov    %eax,(%esp)
  28:	e8 23 02 00 00       	call   250 <atoi>
  2d:	89 04 24             	mov    %eax,(%esp)
  30:	e8 be 02 00 00       	call   2f3 <kill>
  for(i=1; i<argc; i++)
  35:	39 f3                	cmp    %esi,%ebx
  37:	75 e7                	jne    20 <main+0x20>
  exit();
  39:	e8 85 02 00 00       	call   2c3 <exit>
    printf(2, "usage: kill pid...\n");
  3e:	c7 44 24 04 a8 07 00 	movl   $0x7a8,0x4(%esp)
  45:	00 
  46:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  4d:	e8 ee 03 00 00       	call   440 <printf>
    exit();
  52:	e8 6c 02 00 00       	call   2c3 <exit>
  57:	66 90                	xchg   %ax,%ax
  59:	66 90                	xchg   %ax,%ax
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  61:	31 c0                	xor    %eax,%eax
{
  63:	89 e5                	mov    %esp,%ebp
  65:	53                   	push   %ebx
  66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  70:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  74:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  77:	40                   	inc    %eax
  78:	84 d2                	test   %dl,%dl
  7a:	75 f4                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7c:	5b                   	pop    %ebx
  7d:	89 c8                	mov    %ecx,%eax
  7f:	5d                   	pop    %ebp
  80:	c3                   	ret    
  81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8f:	90                   	nop

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 5d 08             	mov    0x8(%ebp),%ebx
  97:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9a:	0f b6 03             	movzbl (%ebx),%eax
  9d:	0f b6 0a             	movzbl (%edx),%ecx
  a0:	84 c0                	test   %al,%al
  a2:	75 19                	jne    bd <strcmp+0x2d>
  a4:	eb 2a                	jmp    d0 <strcmp+0x40>
  a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ad:	8d 76 00             	lea    0x0(%esi),%esi
  b0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
  b4:	43                   	inc    %ebx
  b5:	42                   	inc    %edx
  while(*p && *p == *q)
  b6:	0f b6 0a             	movzbl (%edx),%ecx
  b9:	84 c0                	test   %al,%al
  bb:	74 13                	je     d0 <strcmp+0x40>
  bd:	38 c8                	cmp    %cl,%al
  bf:	74 ef                	je     b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
  c1:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
  c2:	29 c8                	sub    %ecx,%eax
}
  c4:	5d                   	pop    %ebp
  c5:	c3                   	ret    
  c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	5b                   	pop    %ebx
  d1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  d3:	29 c8                	sub    %ecx,%eax
}
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  de:	66 90                	xchg   %ax,%ax

000000e0 <strlen>:

uint
strlen(const char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  e6:	80 3a 00             	cmpb   $0x0,(%edx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 c0                	xor    %eax,%eax
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	40                   	inc    %eax
  f1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  f5:	89 c1                	mov    %eax,%ecx
  f7:	75 f7                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  f9:	5d                   	pop    %ebp
  fa:	89 c8                	mov    %ecx,%eax
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
 101:	31 c9                	xor    %ecx,%ecx
}
 103:	89 c8                	mov    %ecx,%eax
 105:	c3                   	ret    
 106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10d:	8d 76 00             	lea    0x0(%esi),%esi

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
 116:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 d7                	mov    %edx,%edi
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 122:	5f                   	pop    %edi
 123:	89 d0                	mov    %edx,%eax
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12e:	66 90                	xchg   %ax,%ax

00000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 13a:	0f b6 10             	movzbl (%eax),%edx
 13d:	84 d2                	test   %dl,%dl
 13f:	75 18                	jne    159 <strchr+0x29>
 141:	eb 1d                	jmp    160 <strchr+0x30>
 143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 150:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 154:	40                   	inc    %eax
 155:	84 d2                	test   %dl,%dl
 157:	74 07                	je     160 <strchr+0x30>
    if(*s == c)
 159:	38 d1                	cmp    %dl,%cl
 15b:	75 f3                	jne    150 <strchr+0x20>
      return (char*)s;
  return 0;
}
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret    
 15f:	90                   	nop
 160:	5d                   	pop    %ebp
  return 0;
 161:	31 c0                	xor    %eax,%eax
}
 163:	c3                   	ret    
 164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 178:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 17b:	83 ec 3c             	sub    $0x3c,%esp
 17e:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 181:	eb 3a                	jmp    1bd <gets+0x4d>
 183:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 190:	89 7c 24 04          	mov    %edi,0x4(%esp)
 194:	ba 01 00 00 00       	mov    $0x1,%edx
 199:	89 54 24 08          	mov    %edx,0x8(%esp)
 19d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a4:	e8 32 01 00 00       	call   2db <read>
    if(cc < 1)
 1a9:	85 c0                	test   %eax,%eax
 1ab:	7e 19                	jle    1c6 <gets+0x56>
      break;
    buf[i++] = c;
 1ad:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b1:	46                   	inc    %esi
 1b2:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 1b5:	3c 0a                	cmp    $0xa,%al
 1b7:	74 27                	je     1e0 <gets+0x70>
 1b9:	3c 0d                	cmp    $0xd,%al
 1bb:	74 23                	je     1e0 <gets+0x70>
  for(i=0; i+1 < max; ){
 1bd:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 1c0:	43                   	inc    %ebx
 1c1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1c4:	7c ca                	jl     190 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 1c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	83 c4 3c             	add    $0x3c,%esp
 1d2:	5b                   	pop    %ebx
 1d3:	5e                   	pop    %esi
 1d4:	5f                   	pop    %edi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1de:	66 90                	xchg   %ax,%ax
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	01 c3                	add    %eax,%ebx
 1e5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1e8:	eb dc                	jmp    1c6 <gets+0x56>
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f1:	31 c0                	xor    %eax,%eax
{
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 1f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
{
 1ff:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 202:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 205:	89 04 24             	mov    %eax,(%esp)
 208:	e8 f6 00 00 00       	call   303 <open>
  if(fd < 0)
 20d:	85 c0                	test   %eax,%eax
 20f:	78 2f                	js     240 <stat+0x50>
 211:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 213:	8b 45 0c             	mov    0xc(%ebp),%eax
 216:	89 1c 24             	mov    %ebx,(%esp)
 219:	89 44 24 04          	mov    %eax,0x4(%esp)
 21d:	e8 f9 00 00 00       	call   31b <fstat>
  close(fd);
 222:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 225:	89 c6                	mov    %eax,%esi
  close(fd);
 227:	e8 bf 00 00 00       	call   2eb <close>
  return r;
}
 22c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 22f:	89 f0                	mov    %esi,%eax
 231:	8b 75 fc             	mov    -0x4(%ebp),%esi
 234:	89 ec                	mov    %ebp,%esp
 236:	5d                   	pop    %ebp
 237:	c3                   	ret    
 238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb e5                	jmp    22c <stat+0x3c>
 247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24e:	66 90                	xchg   %ax,%ax

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 02             	movsbl (%edx),%eax
 25a:	88 c1                	mov    %al,%cl
 25c:	80 e9 30             	sub    $0x30,%cl
 25f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 262:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 267:	77 1c                	ja     285 <atoi+0x35>
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 270:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 273:	42                   	inc    %edx
 274:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 278:	0f be 02             	movsbl (%edx),%eax
 27b:	88 c3                	mov    %al,%bl
 27d:	80 eb 30             	sub    $0x30,%bl
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	5b                   	pop    %ebx
 286:	89 c8                	mov    %ecx,%eax
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	56                   	push   %esi
 298:	8b 55 08             	mov    0x8(%ebp),%edx
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7e 13                	jle    2b5 <memmove+0x25>
 2a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2a4:	89 d7                	mov    %edx,%edi
 2a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b1:	39 f8                	cmp    %edi,%eax
 2b3:	75 fb                	jne    2b0 <memmove+0x20>
  return vdst;
}
 2b5:	5e                   	pop    %esi
 2b6:	89 d0                	mov    %edx,%eax
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret    

000002bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bb:	b8 01 00 00 00       	mov    $0x1,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <exit>:
SYSCALL(exit)
 2c3:	b8 02 00 00 00       	mov    $0x2,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <wait>:
SYSCALL(wait)
 2cb:	b8 03 00 00 00       	mov    $0x3,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <pipe>:
SYSCALL(pipe)
 2d3:	b8 04 00 00 00       	mov    $0x4,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <read>:
SYSCALL(read)
 2db:	b8 05 00 00 00       	mov    $0x5,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <write>:
SYSCALL(write)
 2e3:	b8 10 00 00 00       	mov    $0x10,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <close>:
SYSCALL(close)
 2eb:	b8 15 00 00 00       	mov    $0x15,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <kill>:
SYSCALL(kill)
 2f3:	b8 06 00 00 00       	mov    $0x6,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <exec>:
SYSCALL(exec)
 2fb:	b8 07 00 00 00       	mov    $0x7,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <open>:
SYSCALL(open)
 303:	b8 0f 00 00 00       	mov    $0xf,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <mknod>:
SYSCALL(mknod)
 30b:	b8 11 00 00 00       	mov    $0x11,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <unlink>:
SYSCALL(unlink)
 313:	b8 12 00 00 00       	mov    $0x12,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <fstat>:
SYSCALL(fstat)
 31b:	b8 08 00 00 00       	mov    $0x8,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <link>:
SYSCALL(link)
 323:	b8 13 00 00 00       	mov    $0x13,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <mkdir>:
SYSCALL(mkdir)
 32b:	b8 14 00 00 00       	mov    $0x14,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <chdir>:
SYSCALL(chdir)
 333:	b8 09 00 00 00       	mov    $0x9,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <dup>:
SYSCALL(dup)
 33b:	b8 0a 00 00 00       	mov    $0xa,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getpid>:
SYSCALL(getpid)
 343:	b8 0b 00 00 00       	mov    $0xb,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <sbrk>:
SYSCALL(sbrk)
 34b:	b8 0c 00 00 00       	mov    $0xc,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sleep>:
SYSCALL(sleep)
 353:	b8 0d 00 00 00       	mov    $0xd,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <uptime>:
SYSCALL(uptime)
 35b:	b8 0e 00 00 00       	mov    $0xe,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <proc_dump>:
 363:	b8 16 00 00 00       	mov    $0x16,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    
 36b:	66 90                	xchg   %ax,%ax
 36d:	66 90                	xchg   %ax,%ax
 36f:	90                   	nop

00000370 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	89 cf                	mov    %ecx,%edi
 376:	56                   	push   %esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 377:	89 d1                	mov    %edx,%ecx
{
 379:	53                   	push   %ebx
 37a:	83 ec 4c             	sub    $0x4c,%esp
 37d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 380:	89 d0                	mov    %edx,%eax
 382:	c1 e8 1f             	shr    $0x1f,%eax
 385:	84 c0                	test   %al,%al
 387:	0f 84 a3 00 00 00    	je     430 <printint+0xc0>
 38d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 391:	0f 84 99 00 00 00    	je     430 <printint+0xc0>
    neg = 1;
 397:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 39e:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3a0:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3a7:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3aa:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3b0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3b3:	31 d2                	xor    %edx,%edx
 3b5:	8b 5d c0             	mov    -0x40(%ebp),%ebx
 3b8:	f7 f7                	div    %edi
 3ba:	8d 4b 01             	lea    0x1(%ebx),%ecx
 3bd:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 3c0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  }while((x /= base) != 0);
 3c3:	39 cf                	cmp    %ecx,%edi
 3c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    buf[i++] = digits[x % base];
 3c8:	0f b6 92 c4 07 00 00 	movzbl 0x7c4(%edx),%edx
 3cf:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 3d3:	76 db                	jbe    3b0 <printint+0x40>
  if(neg)
 3d5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3d8:	85 c9                	test   %ecx,%ecx
 3da:	74 0c                	je     3e8 <printint+0x78>
    buf[i++] = '-';
 3dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
 3df:	b2 2d                	mov    $0x2d,%dl
 3e1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    buf[i++] = digits[x % base];
 3e6:	89 c3                	mov    %eax,%ebx

  while(--i >= 0)
 3e8:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3eb:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3ef:	eb 13                	jmp    404 <printint+0x94>
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop
 400:	0f b6 13             	movzbl (%ebx),%edx
 403:	4b                   	dec    %ebx
  write(fd, &c, 1);
 404:	89 74 24 04          	mov    %esi,0x4(%esp)
 408:	b8 01 00 00 00       	mov    $0x1,%eax
 40d:	89 44 24 08          	mov    %eax,0x8(%esp)
 411:	89 3c 24             	mov    %edi,(%esp)
 414:	88 55 d7             	mov    %dl,-0x29(%ebp)
 417:	e8 c7 fe ff ff       	call   2e3 <write>
  while(--i >= 0)
 41c:	39 de                	cmp    %ebx,%esi
 41e:	75 e0                	jne    400 <printint+0x90>
    putc(fd, buf[i]);
}
 420:	83 c4 4c             	add    $0x4c,%esp
 423:	5b                   	pop    %ebx
 424:	5e                   	pop    %esi
 425:	5f                   	pop    %edi
 426:	5d                   	pop    %ebp
 427:	c3                   	ret    
 428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop
  neg = 0;
 430:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 437:	e9 64 ff ff ff       	jmp    3a0 <printint+0x30>
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 449:	8b 75 0c             	mov    0xc(%ebp),%esi
 44c:	0f b6 1e             	movzbl (%esi),%ebx
 44f:	84 db                	test   %bl,%bl
 451:	0f 84 c8 00 00 00    	je     51f <printf+0xdf>
  ap = (uint*)(void*)&fmt + 1;
 457:	8d 45 10             	lea    0x10(%ebp),%eax
 45a:	46                   	inc    %esi
 45b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  write(fd, &c, 1);
 45e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 461:	31 d2                	xor    %edx,%edx
 463:	eb 3e                	jmp    4a3 <printf+0x63>
 465:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 470:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 473:	83 f8 25             	cmp    $0x25,%eax
        state = '%';
 476:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 47b:	74 1e                	je     49b <printf+0x5b>
  write(fd, &c, 1);
 47d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 481:	b8 01 00 00 00       	mov    $0x1,%eax
 486:	89 44 24 08          	mov    %eax,0x8(%esp)
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	88 5d e7             	mov    %bl,-0x19(%ebp)
 490:	89 04 24             	mov    %eax,(%esp)
 493:	e8 4b fe ff ff       	call   2e3 <write>
 498:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 49b:	0f b6 1e             	movzbl (%esi),%ebx
 49e:	46                   	inc    %esi
 49f:	84 db                	test   %bl,%bl
 4a1:	74 7c                	je     51f <printf+0xdf>
    if(state == 0){
 4a3:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 4a5:	0f be cb             	movsbl %bl,%ecx
 4a8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4ab:	74 c3                	je     470 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ad:	83 fa 25             	cmp    $0x25,%edx
 4b0:	75 e9                	jne    49b <printf+0x5b>
      if(c == 'd'){
 4b2:	83 f8 64             	cmp    $0x64,%eax
 4b5:	0f 84 a5 00 00 00    	je     560 <printf+0x120>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4bb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4c1:	83 f9 70             	cmp    $0x70,%ecx
 4c4:	74 6a                	je     530 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c6:	83 f8 73             	cmp    $0x73,%eax
 4c9:	0f 84 e1 00 00 00    	je     5b0 <printf+0x170>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4cf:	83 f8 63             	cmp    $0x63,%eax
 4d2:	0f 84 98 00 00 00    	je     570 <printf+0x130>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d8:	83 f8 25             	cmp    $0x25,%eax
 4db:	74 1c                	je     4f9 <printf+0xb9>
  write(fd, &c, 1);
 4dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	ba 01 00 00 00       	mov    $0x1,%edx
 4e9:	89 54 24 08          	mov    %edx,0x8(%esp)
 4ed:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4f1:	89 04 24             	mov    %eax,(%esp)
 4f4:	e8 ea fd ff ff       	call   2e3 <write>
 4f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4fd:	b8 01 00 00 00       	mov    $0x1,%eax
 502:	46                   	inc    %esi
 503:	89 44 24 08          	mov    %eax,0x8(%esp)
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	88 5d e7             	mov    %bl,-0x19(%ebp)
 50d:	89 04 24             	mov    %eax,(%esp)
 510:	e8 ce fd ff ff       	call   2e3 <write>
  for(i = 0; fmt[i]; i++){
 515:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 519:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 51b:	84 db                	test   %bl,%bl
 51d:	75 84                	jne    4a3 <printf+0x63>
    }
  }
}
 51f:	83 c4 3c             	add    $0x3c,%esp
 522:	5b                   	pop    %ebx
 523:	5e                   	pop    %esi
 524:	5f                   	pop    %edi
 525:	5d                   	pop    %ebp
 526:	c3                   	ret    
 527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 537:	b9 10 00 00 00       	mov    $0x10,%ecx
 53c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
 542:	8b 13                	mov    (%ebx),%edx
 544:	e8 27 fe ff ff       	call   370 <printint>
        ap++;
 549:	89 d8                	mov    %ebx,%eax
      state = 0;
 54b:	31 d2                	xor    %edx,%edx
        ap++;
 54d:	83 c0 04             	add    $0x4,%eax
 550:	89 45 d0             	mov    %eax,-0x30(%ebp)
 553:	e9 43 ff ff ff       	jmp    49b <printf+0x5b>
 558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop
        printint(fd, *ap, 10, 1);
 560:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 567:	b9 0a 00 00 00       	mov    $0xa,%ecx
 56c:	eb ce                	jmp    53c <printf+0xfc>
 56e:	66 90                	xchg   %ax,%ax
        putc(fd, *ap);
 570:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 573:	b9 01 00 00 00       	mov    $0x1,%ecx
        putc(fd, *ap);
 578:	8b 03                	mov    (%ebx),%eax
        ap++;
 57a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 57d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 581:	89 7c 24 04          	mov    %edi,0x4(%esp)
        putc(fd, *ap);
 585:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 588:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
 58c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 49 fd ff ff       	call   2e3 <write>
      state = 0;
 59a:	31 d2                	xor    %edx,%edx
        ap++;
 59c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 59f:	e9 f7 fe ff ff       	jmp    49b <printf+0x5b>
 5a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop
        s = (char*)*ap;
 5b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5b3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5b5:	83 c0 04             	add    $0x4,%eax
 5b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5bb:	85 db                	test   %ebx,%ebx
 5bd:	74 11                	je     5d0 <printf+0x190>
        while(*s != 0){
 5bf:	0f b6 03             	movzbl (%ebx),%eax
 5c2:	84 c0                	test   %al,%al
 5c4:	74 44                	je     60a <printf+0x1ca>
 5c6:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5c9:	89 de                	mov    %ebx,%esi
 5cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ce:	eb 10                	jmp    5e0 <printf+0x1a0>
 5d0:	89 75 d4             	mov    %esi,-0x2c(%ebp)
          s = "(null)";
 5d3:	bb bc 07 00 00       	mov    $0x7bc,%ebx
        while(*s != 0){
 5d8:	b0 28                	mov    $0x28,%al
 5da:	89 de                	mov    %ebx,%esi
 5dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5df:	90                   	nop
          putc(fd, *s);
 5e0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5e3:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 5e8:	46                   	inc    %esi
  write(fd, &c, 1);
 5e9:	89 44 24 08          	mov    %eax,0x8(%esp)
 5ed:	89 7c 24 04          	mov    %edi,0x4(%esp)
 5f1:	89 1c 24             	mov    %ebx,(%esp)
 5f4:	e8 ea fc ff ff       	call   2e3 <write>
        while(*s != 0){
 5f9:	0f b6 06             	movzbl (%esi),%eax
 5fc:	84 c0                	test   %al,%al
 5fe:	75 e0                	jne    5e0 <printf+0x1a0>
 600:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 603:	31 d2                	xor    %edx,%edx
 605:	e9 91 fe ff ff       	jmp    49b <printf+0x5b>
 60a:	31 d2                	xor    %edx,%edx
 60c:	e9 8a fe ff ff       	jmp    49b <printf+0x5b>
 611:	66 90                	xchg   %ax,%ax
 613:	66 90                	xchg   %ax,%ax
 615:	66 90                	xchg   %ax,%ax
 617:	66 90                	xchg   %ax,%ax
 619:	66 90                	xchg   %ax,%ax
 61b:	66 90                	xchg   %ax,%ax
 61d:	66 90                	xchg   %ax,%ax
 61f:	90                   	nop

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 5c 0a 00 00       	mov    0xa5c,%eax
{
 626:	89 e5                	mov    %esp,%ebp
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 62e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 630:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 633:	39 c8                	cmp    %ecx,%eax
 635:	73 19                	jae    650 <free+0x30>
 637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63e:	66 90                	xchg   %ax,%ax
 640:	39 d1                	cmp    %edx,%ecx
 642:	72 14                	jb     658 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 644:	39 d0                	cmp    %edx,%eax
 646:	73 10                	jae    658 <free+0x38>
{
 648:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64a:	39 c8                	cmp    %ecx,%eax
 64c:	8b 10                	mov    (%eax),%edx
 64e:	72 f0                	jb     640 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 d0                	cmp    %edx,%eax
 652:	72 f4                	jb     648 <free+0x28>
 654:	39 d1                	cmp    %edx,%ecx
 656:	73 f0                	jae    648 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 658:	8b 73 fc             	mov    -0x4(%ebx),%esi
 65b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 65e:	39 fa                	cmp    %edi,%edx
 660:	74 1e                	je     680 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 662:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 66b:	39 f1                	cmp    %esi,%ecx
 66d:	74 2a                	je     699 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 66f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 671:	5b                   	pop    %ebx
  freep = p;
 672:	a3 5c 0a 00 00       	mov    %eax,0xa5c
}
 677:	5e                   	pop    %esi
 678:	5f                   	pop    %edi
 679:	5d                   	pop    %ebp
 67a:	c3                   	ret    
 67b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 680:	8b 7a 04             	mov    0x4(%edx),%edi
 683:	01 fe                	add    %edi,%esi
 685:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 688:	8b 10                	mov    (%eax),%edx
 68a:	8b 12                	mov    (%edx),%edx
 68c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68f:	8b 50 04             	mov    0x4(%eax),%edx
 692:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 695:	39 f1                	cmp    %esi,%ecx
 697:	75 d6                	jne    66f <free+0x4f>
  freep = p;
 699:	a3 5c 0a 00 00       	mov    %eax,0xa5c
    p->s.size += bp->s.size;
 69e:	8b 4b fc             	mov    -0x4(%ebx),%ecx
 6a1:	01 ca                	add    %ecx,%edx
 6a3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6a9:	89 10                	mov    %edx,(%eax)
}
 6ab:	5b                   	pop    %ebx
 6ac:	5e                   	pop    %esi
 6ad:	5f                   	pop    %edi
 6ae:	5d                   	pop    %ebp
 6af:	c3                   	ret    

000006b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6bc:	8b 3d 5c 0a 00 00    	mov    0xa5c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	8d 70 07             	lea    0x7(%eax),%esi
 6c5:	c1 ee 03             	shr    $0x3,%esi
 6c8:	46                   	inc    %esi
  if((prevp = freep) == 0){
 6c9:	85 ff                	test   %edi,%edi
 6cb:	0f 84 9f 00 00 00    	je     770 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d1:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 6d3:	8b 48 04             	mov    0x4(%eax),%ecx
 6d6:	39 f1                	cmp    %esi,%ecx
 6d8:	73 6c                	jae    746 <malloc+0x96>
 6da:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6e0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6e5:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6e8:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6ef:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6f2:	eb 1d                	jmp    711 <malloc+0x61>
 6f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ff:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 700:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 702:	8b 4a 04             	mov    0x4(%edx),%ecx
 705:	39 f1                	cmp    %esi,%ecx
 707:	73 47                	jae    750 <malloc+0xa0>
 709:	8b 3d 5c 0a 00 00    	mov    0xa5c,%edi
 70f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 711:	39 c7                	cmp    %eax,%edi
 713:	75 eb                	jne    700 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 718:	89 04 24             	mov    %eax,(%esp)
 71b:	e8 2b fc ff ff       	call   34b <sbrk>
  if(p == (char*)-1)
 720:	83 f8 ff             	cmp    $0xffffffff,%eax
 723:	74 17                	je     73c <malloc+0x8c>
  hp->s.size = nu;
 725:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 728:	83 c0 08             	add    $0x8,%eax
 72b:	89 04 24             	mov    %eax,(%esp)
 72e:	e8 ed fe ff ff       	call   620 <free>
  return freep;
 733:	a1 5c 0a 00 00       	mov    0xa5c,%eax
      if((p = morecore(nunits)) == 0)
 738:	85 c0                	test   %eax,%eax
 73a:	75 c4                	jne    700 <malloc+0x50>
        return 0;
  }
}
 73c:	83 c4 2c             	add    $0x2c,%esp
        return 0;
 73f:	31 c0                	xor    %eax,%eax
}
 741:	5b                   	pop    %ebx
 742:	5e                   	pop    %esi
 743:	5f                   	pop    %edi
 744:	5d                   	pop    %ebp
 745:	c3                   	ret    
    if(p->s.size >= nunits){
 746:	89 c2                	mov    %eax,%edx
 748:	89 f8                	mov    %edi,%eax
 74a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 750:	39 ce                	cmp    %ecx,%esi
 752:	74 4c                	je     7a0 <malloc+0xf0>
        p->s.size -= nunits;
 754:	29 f1                	sub    %esi,%ecx
 756:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 759:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 75c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 75f:	a3 5c 0a 00 00       	mov    %eax,0xa5c
      return (void*)(p + 1);
 764:	8d 42 08             	lea    0x8(%edx),%eax
}
 767:	83 c4 2c             	add    $0x2c,%esp
 76a:	5b                   	pop    %ebx
 76b:	5e                   	pop    %esi
 76c:	5f                   	pop    %edi
 76d:	5d                   	pop    %ebp
 76e:	c3                   	ret    
 76f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 770:	b8 60 0a 00 00       	mov    $0xa60,%eax
 775:	ba 60 0a 00 00       	mov    $0xa60,%edx
 77a:	a3 5c 0a 00 00       	mov    %eax,0xa5c
    base.s.size = 0;
 77f:	31 c9                	xor    %ecx,%ecx
 781:	bf 60 0a 00 00       	mov    $0xa60,%edi
    base.s.ptr = freep = prevp = &base;
 786:	89 15 60 0a 00 00    	mov    %edx,0xa60
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 78e:	89 0d 64 0a 00 00    	mov    %ecx,0xa64
    if(p->s.size >= nunits){
 794:	e9 41 ff ff ff       	jmp    6da <malloc+0x2a>
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7a0:	8b 0a                	mov    (%edx),%ecx
 7a2:	89 08                	mov    %ecx,(%eax)
 7a4:	eb b9                	jmp    75f <malloc+0xaf>
