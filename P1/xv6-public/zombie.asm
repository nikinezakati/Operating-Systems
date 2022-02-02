
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 7d 02 00 00       	call   28b <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 05 03 00 00       	call   323 <sleep>
  exit();
  1e:	e8 70 02 00 00       	call   293 <exit>
  23:	66 90                	xchg   %ax,%ax
  25:	66 90                	xchg   %ax,%ax
  27:	66 90                	xchg   %ax,%ax
  29:	66 90                	xchg   %ax,%ax
  2b:	66 90                	xchg   %ax,%ax
  2d:	66 90                	xchg   %ax,%ax
  2f:	90                   	nop

00000030 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  30:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  31:	31 c0                	xor    %eax,%eax
{
  33:	89 e5                	mov    %esp,%ebp
  35:	53                   	push   %ebx
  36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  47:	40                   	inc    %eax
  48:	84 d2                	test   %dl,%dl
  4a:	75 f4                	jne    40 <strcpy+0x10>
    ;
  return os;
}
  4c:	5b                   	pop    %ebx
  4d:	89 c8                	mov    %ecx,%eax
  4f:	5d                   	pop    %ebp
  50:	c3                   	ret    
  51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  5f:	90                   	nop

00000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 5d 08             	mov    0x8(%ebp),%ebx
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  6a:	0f b6 03             	movzbl (%ebx),%eax
  6d:	0f b6 0a             	movzbl (%edx),%ecx
  70:	84 c0                	test   %al,%al
  72:	75 19                	jne    8d <strcmp+0x2d>
  74:	eb 2a                	jmp    a0 <strcmp+0x40>
  76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7d:	8d 76 00             	lea    0x0(%esi),%esi
  80:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
  84:	43                   	inc    %ebx
  85:	42                   	inc    %edx
  while(*p && *p == *q)
  86:	0f b6 0a             	movzbl (%edx),%ecx
  89:	84 c0                	test   %al,%al
  8b:	74 13                	je     a0 <strcmp+0x40>
  8d:	38 c8                	cmp    %cl,%al
  8f:	74 ef                	je     80 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
  91:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
  92:	29 c8                	sub    %ecx,%eax
}
  94:	5d                   	pop    %ebp
  95:	c3                   	ret    
  96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	5b                   	pop    %ebx
  a1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  a3:	29 c8                	sub    %ecx,%eax
}
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    
  a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ae:	66 90                	xchg   %ax,%ax

000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b6:	80 3a 00             	cmpb   $0x0,(%edx)
  b9:	74 15                	je     d0 <strlen+0x20>
  bb:	31 c0                	xor    %eax,%eax
  bd:	8d 76 00             	lea    0x0(%esi),%esi
  c0:	40                   	inc    %eax
  c1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c5:	89 c1                	mov    %eax,%ecx
  c7:	75 f7                	jne    c0 <strlen+0x10>
    ;
  return n;
}
  c9:	5d                   	pop    %ebp
  ca:	89 c8                	mov    %ecx,%eax
  cc:	c3                   	ret    
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
  d1:	31 c9                	xor    %ecx,%ecx
}
  d3:	89 c8                	mov    %ecx,%eax
  d5:	c3                   	ret    
  d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dd:	8d 76 00             	lea    0x0(%esi),%esi

000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 55 08             	mov    0x8(%ebp),%edx
  e6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 d7                	mov    %edx,%edi
  ef:	fc                   	cld    
  f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f2:	5f                   	pop    %edi
  f3:	89 d0                	mov    %edx,%eax
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    
  f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fe:	66 90                	xchg   %ax,%ax

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	75 18                	jne    129 <strchr+0x29>
 111:	eb 1d                	jmp    130 <strchr+0x30>
 113:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 120:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 124:	40                   	inc    %eax
 125:	84 d2                	test   %dl,%dl
 127:	74 07                	je     130 <strchr+0x30>
    if(*s == c)
 129:	38 d1                	cmp    %dl,%cl
 12b:	75 f3                	jne    120 <strchr+0x20>
      return (char*)s;
  return 0;
}
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
 12f:	90                   	nop
 130:	5d                   	pop    %ebp
  return 0;
 131:	31 c0                	xor    %eax,%eax
}
 133:	c3                   	ret    
 134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 13f:	90                   	nop

00000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 146:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 148:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 14b:	83 ec 3c             	sub    $0x3c,%esp
 14e:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 151:	eb 3a                	jmp    18d <gets+0x4d>
 153:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 160:	89 7c 24 04          	mov    %edi,0x4(%esp)
 164:	ba 01 00 00 00       	mov    $0x1,%edx
 169:	89 54 24 08          	mov    %edx,0x8(%esp)
 16d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 174:	e8 32 01 00 00       	call   2ab <read>
    if(cc < 1)
 179:	85 c0                	test   %eax,%eax
 17b:	7e 19                	jle    196 <gets+0x56>
      break;
    buf[i++] = c;
 17d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 181:	46                   	inc    %esi
 182:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 185:	3c 0a                	cmp    $0xa,%al
 187:	74 27                	je     1b0 <gets+0x70>
 189:	3c 0d                	cmp    $0xd,%al
 18b:	74 23                	je     1b0 <gets+0x70>
  for(i=0; i+1 < max; ){
 18d:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 190:	43                   	inc    %ebx
 191:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 194:	7c ca                	jl     160 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 196:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 199:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	83 c4 3c             	add    $0x3c,%esp
 1a2:	5b                   	pop    %ebx
 1a3:	5e                   	pop    %esi
 1a4:	5f                   	pop    %edi
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ae:	66 90                	xchg   %ax,%ax
 1b0:	8b 45 08             	mov    0x8(%ebp),%eax
 1b3:	01 c3                	add    %eax,%ebx
 1b5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1b8:	eb dc                	jmp    196 <gets+0x56>
 1ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c1:	31 c0                	xor    %eax,%eax
{
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
{
 1cf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1d2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 f6 00 00 00       	call   2d3 <open>
  if(fd < 0)
 1dd:	85 c0                	test   %eax,%eax
 1df:	78 2f                	js     210 <stat+0x50>
 1e1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	89 1c 24             	mov    %ebx,(%esp)
 1e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ed:	e8 f9 00 00 00       	call   2eb <fstat>
  close(fd);
 1f2:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1f5:	89 c6                	mov    %eax,%esi
  close(fd);
 1f7:	e8 bf 00 00 00       	call   2bb <close>
  return r;
}
 1fc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 1ff:	89 f0                	mov    %esi,%eax
 201:	8b 75 fc             	mov    -0x4(%ebp),%esi
 204:	89 ec                	mov    %ebp,%esp
 206:	5d                   	pop    %ebp
 207:	c3                   	ret    
 208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20f:	90                   	nop
    return -1;
 210:	be ff ff ff ff       	mov    $0xffffffff,%esi
 215:	eb e5                	jmp    1fc <stat+0x3c>
 217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21e:	66 90                	xchg   %ax,%ax

00000220 <atoi>:

int
atoi(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	53                   	push   %ebx
 224:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 227:	0f be 02             	movsbl (%edx),%eax
 22a:	88 c1                	mov    %al,%cl
 22c:	80 e9 30             	sub    $0x30,%cl
 22f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 232:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 237:	77 1c                	ja     255 <atoi+0x35>
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 240:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 243:	42                   	inc    %edx
 244:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 248:	0f be 02             	movsbl (%edx),%eax
 24b:	88 c3                	mov    %al,%bl
 24d:	80 eb 30             	sub    $0x30,%bl
 250:	80 fb 09             	cmp    $0x9,%bl
 253:	76 eb                	jbe    240 <atoi+0x20>
  return n;
}
 255:	5b                   	pop    %ebx
 256:	89 c8                	mov    %ecx,%eax
 258:	5d                   	pop    %ebp
 259:	c3                   	ret    
 25a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000260 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	8b 45 10             	mov    0x10(%ebp),%eax
 267:	56                   	push   %esi
 268:	8b 55 08             	mov    0x8(%ebp),%edx
 26b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26e:	85 c0                	test   %eax,%eax
 270:	7e 13                	jle    285 <memmove+0x25>
 272:	01 d0                	add    %edx,%eax
  dst = vdst;
 274:	89 d7                	mov    %edx,%edi
 276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 280:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 281:	39 f8                	cmp    %edi,%eax
 283:	75 fb                	jne    280 <memmove+0x20>
  return vdst;
}
 285:	5e                   	pop    %esi
 286:	89 d0                	mov    %edx,%eax
 288:	5f                   	pop    %edi
 289:	5d                   	pop    %ebp
 28a:	c3                   	ret    

0000028b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28b:	b8 01 00 00 00       	mov    $0x1,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <exit>:
SYSCALL(exit)
 293:	b8 02 00 00 00       	mov    $0x2,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <wait>:
SYSCALL(wait)
 29b:	b8 03 00 00 00       	mov    $0x3,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <pipe>:
SYSCALL(pipe)
 2a3:	b8 04 00 00 00       	mov    $0x4,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <read>:
SYSCALL(read)
 2ab:	b8 05 00 00 00       	mov    $0x5,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <write>:
SYSCALL(write)
 2b3:	b8 10 00 00 00       	mov    $0x10,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <close>:
SYSCALL(close)
 2bb:	b8 15 00 00 00       	mov    $0x15,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <kill>:
SYSCALL(kill)
 2c3:	b8 06 00 00 00       	mov    $0x6,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exec>:
SYSCALL(exec)
 2cb:	b8 07 00 00 00       	mov    $0x7,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <open>:
SYSCALL(open)
 2d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <mknod>:
SYSCALL(mknod)
 2db:	b8 11 00 00 00       	mov    $0x11,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <unlink>:
SYSCALL(unlink)
 2e3:	b8 12 00 00 00       	mov    $0x12,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <fstat>:
SYSCALL(fstat)
 2eb:	b8 08 00 00 00       	mov    $0x8,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <link>:
SYSCALL(link)
 2f3:	b8 13 00 00 00       	mov    $0x13,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mkdir>:
SYSCALL(mkdir)
 2fb:	b8 14 00 00 00       	mov    $0x14,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <chdir>:
SYSCALL(chdir)
 303:	b8 09 00 00 00       	mov    $0x9,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <dup>:
SYSCALL(dup)
 30b:	b8 0a 00 00 00       	mov    $0xa,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <getpid>:
SYSCALL(getpid)
 313:	b8 0b 00 00 00       	mov    $0xb,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <sbrk>:
SYSCALL(sbrk)
 31b:	b8 0c 00 00 00       	mov    $0xc,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <sleep>:
SYSCALL(sleep)
 323:	b8 0d 00 00 00       	mov    $0xd,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <uptime>:
SYSCALL(uptime)
 32b:	b8 0e 00 00 00       	mov    $0xe,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <proc_dump>:
 333:	b8 16 00 00 00       	mov    $0x16,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    
 33b:	66 90                	xchg   %ax,%ax
 33d:	66 90                	xchg   %ax,%ax
 33f:	90                   	nop

00000340 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	89 cf                	mov    %ecx,%edi
 346:	56                   	push   %esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 347:	89 d1                	mov    %edx,%ecx
{
 349:	53                   	push   %ebx
 34a:	83 ec 4c             	sub    $0x4c,%esp
 34d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 350:	89 d0                	mov    %edx,%eax
 352:	c1 e8 1f             	shr    $0x1f,%eax
 355:	84 c0                	test   %al,%al
 357:	0f 84 a3 00 00 00    	je     400 <printint+0xc0>
 35d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 361:	0f 84 99 00 00 00    	je     400 <printint+0xc0>
    neg = 1;
 367:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 36e:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 370:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 377:	8d 75 d7             	lea    -0x29(%ebp),%esi
 37a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 37d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 380:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 383:	31 d2                	xor    %edx,%edx
 385:	8b 5d c0             	mov    -0x40(%ebp),%ebx
 388:	f7 f7                	div    %edi
 38a:	8d 4b 01             	lea    0x1(%ebx),%ecx
 38d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 390:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  }while((x /= base) != 0);
 393:	39 cf                	cmp    %ecx,%edi
 395:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    buf[i++] = digits[x % base];
 398:	0f b6 92 80 07 00 00 	movzbl 0x780(%edx),%edx
 39f:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 3a3:	76 db                	jbe    380 <printint+0x40>
  if(neg)
 3a5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3a8:	85 c9                	test   %ecx,%ecx
 3aa:	74 0c                	je     3b8 <printint+0x78>
    buf[i++] = '-';
 3ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
 3af:	b2 2d                	mov    $0x2d,%dl
 3b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    buf[i++] = digits[x % base];
 3b6:	89 c3                	mov    %eax,%ebx

  while(--i >= 0)
 3b8:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3bb:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3bf:	eb 13                	jmp    3d4 <printint+0x94>
 3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop
 3d0:	0f b6 13             	movzbl (%ebx),%edx
 3d3:	4b                   	dec    %ebx
  write(fd, &c, 1);
 3d4:	89 74 24 04          	mov    %esi,0x4(%esp)
 3d8:	b8 01 00 00 00       	mov    $0x1,%eax
 3dd:	89 44 24 08          	mov    %eax,0x8(%esp)
 3e1:	89 3c 24             	mov    %edi,(%esp)
 3e4:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3e7:	e8 c7 fe ff ff       	call   2b3 <write>
  while(--i >= 0)
 3ec:	39 de                	cmp    %ebx,%esi
 3ee:	75 e0                	jne    3d0 <printint+0x90>
    putc(fd, buf[i]);
}
 3f0:	83 c4 4c             	add    $0x4c,%esp
 3f3:	5b                   	pop    %ebx
 3f4:	5e                   	pop    %esi
 3f5:	5f                   	pop    %edi
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    
 3f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop
  neg = 0;
 400:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 407:	e9 64 ff ff ff       	jmp    370 <printint+0x30>
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000410 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 419:	8b 75 0c             	mov    0xc(%ebp),%esi
 41c:	0f b6 1e             	movzbl (%esi),%ebx
 41f:	84 db                	test   %bl,%bl
 421:	0f 84 c8 00 00 00    	je     4ef <printf+0xdf>
  ap = (uint*)(void*)&fmt + 1;
 427:	8d 45 10             	lea    0x10(%ebp),%eax
 42a:	46                   	inc    %esi
 42b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  write(fd, &c, 1);
 42e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 431:	31 d2                	xor    %edx,%edx
 433:	eb 3e                	jmp    473 <printf+0x63>
 435:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 440:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 443:	83 f8 25             	cmp    $0x25,%eax
        state = '%';
 446:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 44b:	74 1e                	je     46b <printf+0x5b>
  write(fd, &c, 1);
 44d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 451:	b8 01 00 00 00       	mov    $0x1,%eax
 456:	89 44 24 08          	mov    %eax,0x8(%esp)
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	88 5d e7             	mov    %bl,-0x19(%ebp)
 460:	89 04 24             	mov    %eax,(%esp)
 463:	e8 4b fe ff ff       	call   2b3 <write>
 468:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 46b:	0f b6 1e             	movzbl (%esi),%ebx
 46e:	46                   	inc    %esi
 46f:	84 db                	test   %bl,%bl
 471:	74 7c                	je     4ef <printf+0xdf>
    if(state == 0){
 473:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 475:	0f be cb             	movsbl %bl,%ecx
 478:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 47b:	74 c3                	je     440 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47d:	83 fa 25             	cmp    $0x25,%edx
 480:	75 e9                	jne    46b <printf+0x5b>
      if(c == 'd'){
 482:	83 f8 64             	cmp    $0x64,%eax
 485:	0f 84 a5 00 00 00    	je     530 <printf+0x120>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 48b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 491:	83 f9 70             	cmp    $0x70,%ecx
 494:	74 6a                	je     500 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 496:	83 f8 73             	cmp    $0x73,%eax
 499:	0f 84 e1 00 00 00    	je     580 <printf+0x170>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 49f:	83 f8 63             	cmp    $0x63,%eax
 4a2:	0f 84 98 00 00 00    	je     540 <printf+0x130>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4a8:	83 f8 25             	cmp    $0x25,%eax
 4ab:	74 1c                	je     4c9 <printf+0xb9>
  write(fd, &c, 1);
 4ad:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	ba 01 00 00 00       	mov    $0x1,%edx
 4b9:	89 54 24 08          	mov    %edx,0x8(%esp)
 4bd:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4c1:	89 04 24             	mov    %eax,(%esp)
 4c4:	e8 ea fd ff ff       	call   2b3 <write>
 4c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4cd:	b8 01 00 00 00       	mov    $0x1,%eax
 4d2:	46                   	inc    %esi
 4d3:	89 44 24 08          	mov    %eax,0x8(%esp)
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4dd:	89 04 24             	mov    %eax,(%esp)
 4e0:	e8 ce fd ff ff       	call   2b3 <write>
  for(i = 0; fmt[i]; i++){
 4e5:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4eb:	84 db                	test   %bl,%bl
 4ed:	75 84                	jne    473 <printf+0x63>
    }
  }
}
 4ef:	83 c4 3c             	add    $0x3c,%esp
 4f2:	5b                   	pop    %ebx
 4f3:	5e                   	pop    %esi
 4f4:	5f                   	pop    %edi
 4f5:	5d                   	pop    %ebp
 4f6:	c3                   	ret    
 4f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 500:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 507:	b9 10 00 00 00       	mov    $0x10,%ecx
 50c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	8b 13                	mov    (%ebx),%edx
 514:	e8 27 fe ff ff       	call   340 <printint>
        ap++;
 519:	89 d8                	mov    %ebx,%eax
      state = 0;
 51b:	31 d2                	xor    %edx,%edx
        ap++;
 51d:	83 c0 04             	add    $0x4,%eax
 520:	89 45 d0             	mov    %eax,-0x30(%ebp)
 523:	e9 43 ff ff ff       	jmp    46b <printf+0x5b>
 528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52f:	90                   	nop
        printint(fd, *ap, 10, 1);
 530:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 537:	b9 0a 00 00 00       	mov    $0xa,%ecx
 53c:	eb ce                	jmp    50c <printf+0xfc>
 53e:	66 90                	xchg   %ax,%ax
        putc(fd, *ap);
 540:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 543:	b9 01 00 00 00       	mov    $0x1,%ecx
        putc(fd, *ap);
 548:	8b 03                	mov    (%ebx),%eax
        ap++;
 54a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 54d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 551:	89 7c 24 04          	mov    %edi,0x4(%esp)
        putc(fd, *ap);
 555:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 558:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
 55c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 49 fd ff ff       	call   2b3 <write>
      state = 0;
 56a:	31 d2                	xor    %edx,%edx
        ap++;
 56c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 56f:	e9 f7 fe ff ff       	jmp    46b <printf+0x5b>
 574:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop
        s = (char*)*ap;
 580:	8b 45 d0             	mov    -0x30(%ebp),%eax
 583:	8b 18                	mov    (%eax),%ebx
        ap++;
 585:	83 c0 04             	add    $0x4,%eax
 588:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 58b:	85 db                	test   %ebx,%ebx
 58d:	74 11                	je     5a0 <printf+0x190>
        while(*s != 0){
 58f:	0f b6 03             	movzbl (%ebx),%eax
 592:	84 c0                	test   %al,%al
 594:	74 44                	je     5da <printf+0x1ca>
 596:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 599:	89 de                	mov    %ebx,%esi
 59b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 59e:	eb 10                	jmp    5b0 <printf+0x1a0>
 5a0:	89 75 d4             	mov    %esi,-0x2c(%ebp)
          s = "(null)";
 5a3:	bb 78 07 00 00       	mov    $0x778,%ebx
        while(*s != 0){
 5a8:	b0 28                	mov    $0x28,%al
 5aa:	89 de                	mov    %ebx,%esi
 5ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5af:	90                   	nop
          putc(fd, *s);
 5b0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b3:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 5b8:	46                   	inc    %esi
  write(fd, &c, 1);
 5b9:	89 44 24 08          	mov    %eax,0x8(%esp)
 5bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
 5c1:	89 1c 24             	mov    %ebx,(%esp)
 5c4:	e8 ea fc ff ff       	call   2b3 <write>
        while(*s != 0){
 5c9:	0f b6 06             	movzbl (%esi),%eax
 5cc:	84 c0                	test   %al,%al
 5ce:	75 e0                	jne    5b0 <printf+0x1a0>
 5d0:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5d3:	31 d2                	xor    %edx,%edx
 5d5:	e9 91 fe ff ff       	jmp    46b <printf+0x5b>
 5da:	31 d2                	xor    %edx,%edx
 5dc:	e9 8a fe ff ff       	jmp    46b <printf+0x5b>
 5e1:	66 90                	xchg   %ax,%ax
 5e3:	66 90                	xchg   %ax,%ax
 5e5:	66 90                	xchg   %ax,%ax
 5e7:	66 90                	xchg   %ax,%ax
 5e9:	66 90                	xchg   %ax,%ax
 5eb:	66 90                	xchg   %ax,%ax
 5ed:	66 90                	xchg   %ax,%ax
 5ef:	90                   	nop

000005f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	a1 14 0a 00 00       	mov    0xa14,%eax
{
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	53                   	push   %ebx
 5fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5fe:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 600:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 603:	39 c8                	cmp    %ecx,%eax
 605:	73 19                	jae    620 <free+0x30>
 607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60e:	66 90                	xchg   %ax,%ax
 610:	39 d1                	cmp    %edx,%ecx
 612:	72 14                	jb     628 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 614:	39 d0                	cmp    %edx,%eax
 616:	73 10                	jae    628 <free+0x38>
{
 618:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61a:	39 c8                	cmp    %ecx,%eax
 61c:	8b 10                	mov    (%eax),%edx
 61e:	72 f0                	jb     610 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 d0                	cmp    %edx,%eax
 622:	72 f4                	jb     618 <free+0x28>
 624:	39 d1                	cmp    %edx,%ecx
 626:	73 f0                	jae    618 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 628:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62e:	39 fa                	cmp    %edi,%edx
 630:	74 1e                	je     650 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 632:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 635:	8b 50 04             	mov    0x4(%eax),%edx
 638:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 63b:	39 f1                	cmp    %esi,%ecx
 63d:	74 2a                	je     669 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 63f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 641:	5b                   	pop    %ebx
  freep = p;
 642:	a3 14 0a 00 00       	mov    %eax,0xa14
}
 647:	5e                   	pop    %esi
 648:	5f                   	pop    %edi
 649:	5d                   	pop    %ebp
 64a:	c3                   	ret    
 64b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 650:	8b 7a 04             	mov    0x4(%edx),%edi
 653:	01 fe                	add    %edi,%esi
 655:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 658:	8b 10                	mov    (%eax),%edx
 65a:	8b 12                	mov    (%edx),%edx
 65c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 65f:	8b 50 04             	mov    0x4(%eax),%edx
 662:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 665:	39 f1                	cmp    %esi,%ecx
 667:	75 d6                	jne    63f <free+0x4f>
  freep = p;
 669:	a3 14 0a 00 00       	mov    %eax,0xa14
    p->s.size += bp->s.size;
 66e:	8b 4b fc             	mov    -0x4(%ebx),%ecx
 671:	01 ca                	add    %ecx,%edx
 673:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 676:	8b 53 f8             	mov    -0x8(%ebx),%edx
 679:	89 10                	mov    %edx,(%eax)
}
 67b:	5b                   	pop    %ebx
 67c:	5e                   	pop    %esi
 67d:	5f                   	pop    %edi
 67e:	5d                   	pop    %ebp
 67f:	c3                   	ret    

00000680 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 689:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 68c:	8b 3d 14 0a 00 00    	mov    0xa14,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 692:	8d 70 07             	lea    0x7(%eax),%esi
 695:	c1 ee 03             	shr    $0x3,%esi
 698:	46                   	inc    %esi
  if((prevp = freep) == 0){
 699:	85 ff                	test   %edi,%edi
 69b:	0f 84 9f 00 00 00    	je     740 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a1:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 6a3:	8b 48 04             	mov    0x4(%eax),%ecx
 6a6:	39 f1                	cmp    %esi,%ecx
 6a8:	73 6c                	jae    716 <malloc+0x96>
 6aa:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6b0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6b5:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6b8:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6c2:	eb 1d                	jmp    6e1 <malloc+0x61>
 6c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6cf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 6d2:	8b 4a 04             	mov    0x4(%edx),%ecx
 6d5:	39 f1                	cmp    %esi,%ecx
 6d7:	73 47                	jae    720 <malloc+0xa0>
 6d9:	8b 3d 14 0a 00 00    	mov    0xa14,%edi
 6df:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e1:	39 c7                	cmp    %eax,%edi
 6e3:	75 eb                	jne    6d0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 6e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e8:	89 04 24             	mov    %eax,(%esp)
 6eb:	e8 2b fc ff ff       	call   31b <sbrk>
  if(p == (char*)-1)
 6f0:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f3:	74 17                	je     70c <malloc+0x8c>
  hp->s.size = nu;
 6f5:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6f8:	83 c0 08             	add    $0x8,%eax
 6fb:	89 04 24             	mov    %eax,(%esp)
 6fe:	e8 ed fe ff ff       	call   5f0 <free>
  return freep;
 703:	a1 14 0a 00 00       	mov    0xa14,%eax
      if((p = morecore(nunits)) == 0)
 708:	85 c0                	test   %eax,%eax
 70a:	75 c4                	jne    6d0 <malloc+0x50>
        return 0;
  }
}
 70c:	83 c4 2c             	add    $0x2c,%esp
        return 0;
 70f:	31 c0                	xor    %eax,%eax
}
 711:	5b                   	pop    %ebx
 712:	5e                   	pop    %esi
 713:	5f                   	pop    %edi
 714:	5d                   	pop    %ebp
 715:	c3                   	ret    
    if(p->s.size >= nunits){
 716:	89 c2                	mov    %eax,%edx
 718:	89 f8                	mov    %edi,%eax
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 720:	39 ce                	cmp    %ecx,%esi
 722:	74 4c                	je     770 <malloc+0xf0>
        p->s.size -= nunits;
 724:	29 f1                	sub    %esi,%ecx
 726:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 729:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 72c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 72f:	a3 14 0a 00 00       	mov    %eax,0xa14
      return (void*)(p + 1);
 734:	8d 42 08             	lea    0x8(%edx),%eax
}
 737:	83 c4 2c             	add    $0x2c,%esp
 73a:	5b                   	pop    %ebx
 73b:	5e                   	pop    %esi
 73c:	5f                   	pop    %edi
 73d:	5d                   	pop    %ebp
 73e:	c3                   	ret    
 73f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 740:	b8 18 0a 00 00       	mov    $0xa18,%eax
 745:	ba 18 0a 00 00       	mov    $0xa18,%edx
 74a:	a3 14 0a 00 00       	mov    %eax,0xa14
    base.s.size = 0;
 74f:	31 c9                	xor    %ecx,%ecx
 751:	bf 18 0a 00 00       	mov    $0xa18,%edi
    base.s.ptr = freep = prevp = &base;
 756:	89 15 18 0a 00 00    	mov    %edx,0xa18
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75c:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 75e:	89 0d 1c 0a 00 00    	mov    %ecx,0xa1c
    if(p->s.size >= nunits){
 764:	e9 41 ff ff ff       	jmp    6aa <malloc+0x2a>
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 770:	8b 0a                	mov    (%edx),%ecx
 772:	89 08                	mov    %ecx,(%eax)
 774:	eb b9                	jmp    72f <malloc+0xaf>
