
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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

  for(i = 1; i < argc; i++)
  11:	83 f8 01             	cmp    $0x1,%eax
  14:	7e 68                	jle    7e <main+0x7e>
  16:	8d 5a 04             	lea    0x4(%edx),%ebx
  19:	8d 34 82             	lea    (%edx,%eax,4),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1c:	83 c3 04             	add    $0x4,%ebx
  1f:	8b 43 fc             	mov    -0x4(%ebx),%eax
  22:	39 f3                	cmp    %esi,%ebx
  24:	74 36                	je     5c <main+0x5c>
  26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2d:	8d 76 00             	lea    0x0(%esi),%esi
  30:	89 44 24 08          	mov    %eax,0x8(%esp)
  34:	ba d8 07 00 00       	mov    $0x7d8,%edx
  39:	b9 da 07 00 00       	mov    $0x7da,%ecx
  3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  42:	83 c3 04             	add    $0x4,%ebx
  45:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  50:	e8 1b 04 00 00       	call   470 <printf>
  55:	39 f3                	cmp    %esi,%ebx
  57:	8b 43 fc             	mov    -0x4(%ebx),%eax
  5a:	75 d4                	jne    30 <main+0x30>
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	ba df 07 00 00       	mov    $0x7df,%edx
  65:	b9 da 07 00 00       	mov    $0x7da,%ecx
  6a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  79:	e8 f2 03 00 00       	call   470 <printf>
  exit();
  7e:	e8 70 02 00 00       	call   2f3 <exit>
  83:	66 90                	xchg   %ax,%ax
  85:	66 90                	xchg   %ax,%ax
  87:	66 90                	xchg   %ax,%ax
  89:	66 90                	xchg   %ax,%ax
  8b:	66 90                	xchg   %ax,%ax
  8d:	66 90                	xchg   %ax,%ax
  8f:	90                   	nop

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  90:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  91:	31 c0                	xor    %eax,%eax
{
  93:	89 e5                	mov    %esp,%ebp
  95:	53                   	push   %ebx
  96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  a7:	40                   	inc    %eax
  a8:	84 d2                	test   %dl,%dl
  aa:	75 f4                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  ac:	5b                   	pop    %ebx
  ad:	89 c8                	mov    %ecx,%eax
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    
  b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bf:	90                   	nop

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ca:	0f b6 03             	movzbl (%ebx),%eax
  cd:	0f b6 0a             	movzbl (%edx),%ecx
  d0:	84 c0                	test   %al,%al
  d2:	75 19                	jne    ed <strcmp+0x2d>
  d4:	eb 2a                	jmp    100 <strcmp+0x40>
  d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
  e4:	43                   	inc    %ebx
  e5:	42                   	inc    %edx
  while(*p && *p == *q)
  e6:	0f b6 0a             	movzbl (%edx),%ecx
  e9:	84 c0                	test   %al,%al
  eb:	74 13                	je     100 <strcmp+0x40>
  ed:	38 c8                	cmp    %cl,%al
  ef:	74 ef                	je     e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
  f1:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
  f2:	29 c8                	sub    %ecx,%eax
}
  f4:	5d                   	pop    %ebp
  f5:	c3                   	ret    
  f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	5b                   	pop    %ebx
 101:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 103:	29 c8                	sub    %ecx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    
 107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10e:	66 90                	xchg   %ax,%ax

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 3a 00             	cmpb   $0x0,(%edx)
 119:	74 15                	je     130 <strlen+0x20>
 11b:	31 c0                	xor    %eax,%eax
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	40                   	inc    %eax
 121:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 125:	89 c1                	mov    %eax,%ecx
 127:	75 f7                	jne    120 <strlen+0x10>
    ;
  return n;
}
 129:	5d                   	pop    %ebp
 12a:	89 c8                	mov    %ecx,%eax
 12c:	c3                   	ret    
 12d:	8d 76 00             	lea    0x0(%esi),%esi
 130:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
 131:	31 c9                	xor    %ecx,%ecx
}
 133:	89 c8                	mov    %ecx,%eax
 135:	c3                   	ret    
 136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13d:	8d 76 00             	lea    0x0(%esi),%esi

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 55 08             	mov    0x8(%ebp),%edx
 146:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 152:	5f                   	pop    %edi
 153:	89 d0                	mov    %edx,%eax
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15e:	66 90                	xchg   %ax,%ax

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	75 18                	jne    189 <strchr+0x29>
 171:	eb 1d                	jmp    190 <strchr+0x30>
 173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 180:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 184:	40                   	inc    %eax
 185:	84 d2                	test   %dl,%dl
 187:	74 07                	je     190 <strchr+0x30>
    if(*s == c)
 189:	38 d1                	cmp    %dl,%cl
 18b:	75 f3                	jne    180 <strchr+0x20>
      return (char*)s;
  return 0;
}
 18d:	5d                   	pop    %ebp
 18e:	c3                   	ret    
 18f:	90                   	nop
 190:	5d                   	pop    %ebp
  return 0;
 191:	31 c0                	xor    %eax,%eax
}
 193:	c3                   	ret    
 194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 19f:	90                   	nop

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a6:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1a8:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1ab:	83 ec 3c             	sub    $0x3c,%esp
 1ae:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 1b1:	eb 3a                	jmp    1ed <gets+0x4d>
 1b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1c4:	ba 01 00 00 00       	mov    $0x1,%edx
 1c9:	89 54 24 08          	mov    %edx,0x8(%esp)
 1cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1d4:	e8 32 01 00 00       	call   30b <read>
    if(cc < 1)
 1d9:	85 c0                	test   %eax,%eax
 1db:	7e 19                	jle    1f6 <gets+0x56>
      break;
    buf[i++] = c;
 1dd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e1:	46                   	inc    %esi
 1e2:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 1e5:	3c 0a                	cmp    $0xa,%al
 1e7:	74 27                	je     210 <gets+0x70>
 1e9:	3c 0d                	cmp    $0xd,%al
 1eb:	74 23                	je     210 <gets+0x70>
  for(i=0; i+1 < max; ){
 1ed:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 1f0:	43                   	inc    %ebx
 1f1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1f4:	7c ca                	jl     1c0 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 1f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	83 c4 3c             	add    $0x3c,%esp
 202:	5b                   	pop    %ebx
 203:	5e                   	pop    %esi
 204:	5f                   	pop    %edi
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	01 c3                	add    %eax,%ebx
 215:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 218:	eb dc                	jmp    1f6 <gets+0x56>
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000220 <stat>:

int
stat(const char *n, struct stat *st)
{
 220:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 221:	31 c0                	xor    %eax,%eax
{
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 228:	89 44 24 04          	mov    %eax,0x4(%esp)
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
{
 22f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 232:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 235:	89 04 24             	mov    %eax,(%esp)
 238:	e8 f6 00 00 00       	call   333 <open>
  if(fd < 0)
 23d:	85 c0                	test   %eax,%eax
 23f:	78 2f                	js     270 <stat+0x50>
 241:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	89 1c 24             	mov    %ebx,(%esp)
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	e8 f9 00 00 00       	call   34b <fstat>
  close(fd);
 252:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 255:	89 c6                	mov    %eax,%esi
  close(fd);
 257:	e8 bf 00 00 00       	call   31b <close>
  return r;
}
 25c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 25f:	89 f0                	mov    %esi,%eax
 261:	8b 75 fc             	mov    -0x4(%ebp),%esi
 264:	89 ec                	mov    %ebp,%esp
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
 268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26f:	90                   	nop
    return -1;
 270:	be ff ff ff ff       	mov    $0xffffffff,%esi
 275:	eb e5                	jmp    25c <stat+0x3c>
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax

00000280 <atoi>:

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 02             	movsbl (%edx),%eax
 28a:	88 c1                	mov    %al,%cl
 28c:	80 e9 30             	sub    $0x30,%cl
 28f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 292:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 297:	77 1c                	ja     2b5 <atoi+0x35>
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 2a0:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2a3:	42                   	inc    %edx
 2a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2a8:	0f be 02             	movsbl (%edx),%eax
 2ab:	88 c3                	mov    %al,%bl
 2ad:	80 eb 30             	sub    $0x30,%bl
 2b0:	80 fb 09             	cmp    $0x9,%bl
 2b3:	76 eb                	jbe    2a0 <atoi+0x20>
  return n;
}
 2b5:	5b                   	pop    %ebx
 2b6:	89 c8                	mov    %ecx,%eax
 2b8:	5d                   	pop    %ebp
 2b9:	c3                   	ret    
 2ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 45 10             	mov    0x10(%ebp),%eax
 2c7:	56                   	push   %esi
 2c8:	8b 55 08             	mov    0x8(%ebp),%edx
 2cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ce:	85 c0                	test   %eax,%eax
 2d0:	7e 13                	jle    2e5 <memmove+0x25>
 2d2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2d4:	89 d7                	mov    %edx,%edi
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e1:	39 f8                	cmp    %edi,%eax
 2e3:	75 fb                	jne    2e0 <memmove+0x20>
  return vdst;
}
 2e5:	5e                   	pop    %esi
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    

000002eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2eb:	b8 01 00 00 00       	mov    $0x1,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exit>:
SYSCALL(exit)
 2f3:	b8 02 00 00 00       	mov    $0x2,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <wait>:
SYSCALL(wait)
 2fb:	b8 03 00 00 00       	mov    $0x3,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <pipe>:
SYSCALL(pipe)
 303:	b8 04 00 00 00       	mov    $0x4,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <read>:
SYSCALL(read)
 30b:	b8 05 00 00 00       	mov    $0x5,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <write>:
SYSCALL(write)
 313:	b8 10 00 00 00       	mov    $0x10,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <close>:
SYSCALL(close)
 31b:	b8 15 00 00 00       	mov    $0x15,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <kill>:
SYSCALL(kill)
 323:	b8 06 00 00 00       	mov    $0x6,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <exec>:
SYSCALL(exec)
 32b:	b8 07 00 00 00       	mov    $0x7,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <open>:
SYSCALL(open)
 333:	b8 0f 00 00 00       	mov    $0xf,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mknod>:
SYSCALL(mknod)
 33b:	b8 11 00 00 00       	mov    $0x11,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <unlink>:
SYSCALL(unlink)
 343:	b8 12 00 00 00       	mov    $0x12,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <fstat>:
SYSCALL(fstat)
 34b:	b8 08 00 00 00       	mov    $0x8,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <link>:
SYSCALL(link)
 353:	b8 13 00 00 00       	mov    $0x13,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <mkdir>:
SYSCALL(mkdir)
 35b:	b8 14 00 00 00       	mov    $0x14,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <chdir>:
SYSCALL(chdir)
 363:	b8 09 00 00 00       	mov    $0x9,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <dup>:
SYSCALL(dup)
 36b:	b8 0a 00 00 00       	mov    $0xa,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getpid>:
SYSCALL(getpid)
 373:	b8 0b 00 00 00       	mov    $0xb,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <sbrk>:
SYSCALL(sbrk)
 37b:	b8 0c 00 00 00       	mov    $0xc,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <sleep>:
SYSCALL(sleep)
 383:	b8 0d 00 00 00       	mov    $0xd,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <uptime>:
SYSCALL(uptime)
 38b:	b8 0e 00 00 00       	mov    $0xe,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <proc_dump>:
 393:	b8 16 00 00 00       	mov    $0x16,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	89 cf                	mov    %ecx,%edi
 3a6:	56                   	push   %esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3a7:	89 d1                	mov    %edx,%ecx
{
 3a9:	53                   	push   %ebx
 3aa:	83 ec 4c             	sub    $0x4c,%esp
 3ad:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3b0:	89 d0                	mov    %edx,%eax
 3b2:	c1 e8 1f             	shr    $0x1f,%eax
 3b5:	84 c0                	test   %al,%al
 3b7:	0f 84 a3 00 00 00    	je     460 <printint+0xc0>
 3bd:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3c1:	0f 84 99 00 00 00    	je     460 <printint+0xc0>
    neg = 1;
 3c7:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3ce:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3d0:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3d7:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3da:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3e3:	31 d2                	xor    %edx,%edx
 3e5:	8b 5d c0             	mov    -0x40(%ebp),%ebx
 3e8:	f7 f7                	div    %edi
 3ea:	8d 4b 01             	lea    0x1(%ebx),%ecx
 3ed:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 3f0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  }while((x /= base) != 0);
 3f3:	39 cf                	cmp    %ecx,%edi
 3f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    buf[i++] = digits[x % base];
 3f8:	0f b6 92 e8 07 00 00 	movzbl 0x7e8(%edx),%edx
 3ff:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 403:	76 db                	jbe    3e0 <printint+0x40>
  if(neg)
 405:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 408:	85 c9                	test   %ecx,%ecx
 40a:	74 0c                	je     418 <printint+0x78>
    buf[i++] = '-';
 40c:	8b 45 c0             	mov    -0x40(%ebp),%eax
 40f:	b2 2d                	mov    $0x2d,%dl
 411:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    buf[i++] = digits[x % base];
 416:	89 c3                	mov    %eax,%ebx

  while(--i >= 0)
 418:	8b 7d b8             	mov    -0x48(%ebp),%edi
 41b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 41f:	eb 13                	jmp    434 <printint+0x94>
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop
 430:	0f b6 13             	movzbl (%ebx),%edx
 433:	4b                   	dec    %ebx
  write(fd, &c, 1);
 434:	89 74 24 04          	mov    %esi,0x4(%esp)
 438:	b8 01 00 00 00       	mov    $0x1,%eax
 43d:	89 44 24 08          	mov    %eax,0x8(%esp)
 441:	89 3c 24             	mov    %edi,(%esp)
 444:	88 55 d7             	mov    %dl,-0x29(%ebp)
 447:	e8 c7 fe ff ff       	call   313 <write>
  while(--i >= 0)
 44c:	39 de                	cmp    %ebx,%esi
 44e:	75 e0                	jne    430 <printint+0x90>
    putc(fd, buf[i]);
}
 450:	83 c4 4c             	add    $0x4c,%esp
 453:	5b                   	pop    %ebx
 454:	5e                   	pop    %esi
 455:	5f                   	pop    %edi
 456:	5d                   	pop    %ebp
 457:	c3                   	ret    
 458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop
  neg = 0;
 460:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 467:	e9 64 ff ff ff       	jmp    3d0 <printint+0x30>
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 479:	8b 75 0c             	mov    0xc(%ebp),%esi
 47c:	0f b6 1e             	movzbl (%esi),%ebx
 47f:	84 db                	test   %bl,%bl
 481:	0f 84 c8 00 00 00    	je     54f <printf+0xdf>
  ap = (uint*)(void*)&fmt + 1;
 487:	8d 45 10             	lea    0x10(%ebp),%eax
 48a:	46                   	inc    %esi
 48b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  write(fd, &c, 1);
 48e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 491:	31 d2                	xor    %edx,%edx
 493:	eb 3e                	jmp    4d3 <printf+0x63>
 495:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4a3:	83 f8 25             	cmp    $0x25,%eax
        state = '%';
 4a6:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4ab:	74 1e                	je     4cb <printf+0x5b>
  write(fd, &c, 1);
 4ad:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4b1:	b8 01 00 00 00       	mov    $0x1,%eax
 4b6:	89 44 24 08          	mov    %eax,0x8(%esp)
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4c0:	89 04 24             	mov    %eax,(%esp)
 4c3:	e8 4b fe ff ff       	call   313 <write>
 4c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 4cb:	0f b6 1e             	movzbl (%esi),%ebx
 4ce:	46                   	inc    %esi
 4cf:	84 db                	test   %bl,%bl
 4d1:	74 7c                	je     54f <printf+0xdf>
    if(state == 0){
 4d3:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 4d5:	0f be cb             	movsbl %bl,%ecx
 4d8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4db:	74 c3                	je     4a0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4dd:	83 fa 25             	cmp    $0x25,%edx
 4e0:	75 e9                	jne    4cb <printf+0x5b>
      if(c == 'd'){
 4e2:	83 f8 64             	cmp    $0x64,%eax
 4e5:	0f 84 a5 00 00 00    	je     590 <printf+0x120>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4eb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4f1:	83 f9 70             	cmp    $0x70,%ecx
 4f4:	74 6a                	je     560 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f6:	83 f8 73             	cmp    $0x73,%eax
 4f9:	0f 84 e1 00 00 00    	je     5e0 <printf+0x170>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ff:	83 f8 63             	cmp    $0x63,%eax
 502:	0f 84 98 00 00 00    	je     5a0 <printf+0x130>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 508:	83 f8 25             	cmp    $0x25,%eax
 50b:	74 1c                	je     529 <printf+0xb9>
  write(fd, &c, 1);
 50d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	ba 01 00 00 00       	mov    $0x1,%edx
 519:	89 54 24 08          	mov    %edx,0x8(%esp)
 51d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 521:	89 04 24             	mov    %eax,(%esp)
 524:	e8 ea fd ff ff       	call   313 <write>
 529:	89 7c 24 04          	mov    %edi,0x4(%esp)
 52d:	b8 01 00 00 00       	mov    $0x1,%eax
 532:	46                   	inc    %esi
 533:	89 44 24 08          	mov    %eax,0x8(%esp)
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	88 5d e7             	mov    %bl,-0x19(%ebp)
 53d:	89 04 24             	mov    %eax,(%esp)
 540:	e8 ce fd ff ff       	call   313 <write>
  for(i = 0; fmt[i]; i++){
 545:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 549:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 54b:	84 db                	test   %bl,%bl
 54d:	75 84                	jne    4d3 <printf+0x63>
    }
  }
}
 54f:	83 c4 3c             	add    $0x3c,%esp
 552:	5b                   	pop    %ebx
 553:	5e                   	pop    %esi
 554:	5f                   	pop    %edi
 555:	5d                   	pop    %ebp
 556:	c3                   	ret    
 557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 567:	b9 10 00 00 00       	mov    $0x10,%ecx
 56c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	8b 13                	mov    (%ebx),%edx
 574:	e8 27 fe ff ff       	call   3a0 <printint>
        ap++;
 579:	89 d8                	mov    %ebx,%eax
      state = 0;
 57b:	31 d2                	xor    %edx,%edx
        ap++;
 57d:	83 c0 04             	add    $0x4,%eax
 580:	89 45 d0             	mov    %eax,-0x30(%ebp)
 583:	e9 43 ff ff ff       	jmp    4cb <printf+0x5b>
 588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop
        printint(fd, *ap, 10, 1);
 590:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 597:	b9 0a 00 00 00       	mov    $0xa,%ecx
 59c:	eb ce                	jmp    56c <printf+0xfc>
 59e:	66 90                	xchg   %ax,%ax
        putc(fd, *ap);
 5a0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5a3:	b9 01 00 00 00       	mov    $0x1,%ecx
        putc(fd, *ap);
 5a8:	8b 03                	mov    (%ebx),%eax
        ap++;
 5aa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 5ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 5b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
        putc(fd, *ap);
 5b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5b8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
 5bc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	89 04 24             	mov    %eax,(%esp)
 5c5:	e8 49 fd ff ff       	call   313 <write>
      state = 0;
 5ca:	31 d2                	xor    %edx,%edx
        ap++;
 5cc:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5cf:	e9 f7 fe ff ff       	jmp    4cb <printf+0x5b>
 5d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop
        s = (char*)*ap;
 5e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5e3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5e5:	83 c0 04             	add    $0x4,%eax
 5e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5eb:	85 db                	test   %ebx,%ebx
 5ed:	74 11                	je     600 <printf+0x190>
        while(*s != 0){
 5ef:	0f b6 03             	movzbl (%ebx),%eax
 5f2:	84 c0                	test   %al,%al
 5f4:	74 44                	je     63a <printf+0x1ca>
 5f6:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5f9:	89 de                	mov    %ebx,%esi
 5fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5fe:	eb 10                	jmp    610 <printf+0x1a0>
 600:	89 75 d4             	mov    %esi,-0x2c(%ebp)
          s = "(null)";
 603:	bb e1 07 00 00       	mov    $0x7e1,%ebx
        while(*s != 0){
 608:	b0 28                	mov    $0x28,%al
 60a:	89 de                	mov    %ebx,%esi
 60c:	8b 5d 08             	mov    0x8(%ebp),%ebx
 60f:	90                   	nop
          putc(fd, *s);
 610:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 613:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 618:	46                   	inc    %esi
  write(fd, &c, 1);
 619:	89 44 24 08          	mov    %eax,0x8(%esp)
 61d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 621:	89 1c 24             	mov    %ebx,(%esp)
 624:	e8 ea fc ff ff       	call   313 <write>
        while(*s != 0){
 629:	0f b6 06             	movzbl (%esi),%eax
 62c:	84 c0                	test   %al,%al
 62e:	75 e0                	jne    610 <printf+0x1a0>
 630:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 633:	31 d2                	xor    %edx,%edx
 635:	e9 91 fe ff ff       	jmp    4cb <printf+0x5b>
 63a:	31 d2                	xor    %edx,%edx
 63c:	e9 8a fe ff ff       	jmp    4cb <printf+0x5b>
 641:	66 90                	xchg   %ax,%ax
 643:	66 90                	xchg   %ax,%ax
 645:	66 90                	xchg   %ax,%ax
 647:	66 90                	xchg   %ax,%ax
 649:	66 90                	xchg   %ax,%ax
 64b:	66 90                	xchg   %ax,%ax
 64d:	66 90                	xchg   %ax,%ax
 64f:	90                   	nop

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	a1 80 0a 00 00       	mov    0xa80,%eax
{
 656:	89 e5                	mov    %esp,%ebp
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	53                   	push   %ebx
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 65e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 660:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 663:	39 c8                	cmp    %ecx,%eax
 665:	73 19                	jae    680 <free+0x30>
 667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66e:	66 90                	xchg   %ax,%ax
 670:	39 d1                	cmp    %edx,%ecx
 672:	72 14                	jb     688 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 674:	39 d0                	cmp    %edx,%eax
 676:	73 10                	jae    688 <free+0x38>
{
 678:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	39 c8                	cmp    %ecx,%eax
 67c:	8b 10                	mov    (%eax),%edx
 67e:	72 f0                	jb     670 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 680:	39 d0                	cmp    %edx,%eax
 682:	72 f4                	jb     678 <free+0x28>
 684:	39 d1                	cmp    %edx,%ecx
 686:	73 f0                	jae    678 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 688:	8b 73 fc             	mov    -0x4(%ebx),%esi
 68b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 68e:	39 fa                	cmp    %edi,%edx
 690:	74 1e                	je     6b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 692:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 695:	8b 50 04             	mov    0x4(%eax),%edx
 698:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 69b:	39 f1                	cmp    %esi,%ecx
 69d:	74 2a                	je     6c9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 69f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 6a1:	5b                   	pop    %ebx
  freep = p;
 6a2:	a3 80 0a 00 00       	mov    %eax,0xa80
}
 6a7:	5e                   	pop    %esi
 6a8:	5f                   	pop    %edi
 6a9:	5d                   	pop    %ebp
 6aa:	c3                   	ret    
 6ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6af:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 6b0:	8b 7a 04             	mov    0x4(%edx),%edi
 6b3:	01 fe                	add    %edi,%esi
 6b5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	8b 10                	mov    (%eax),%edx
 6ba:	8b 12                	mov    (%edx),%edx
 6bc:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6bf:	8b 50 04             	mov    0x4(%eax),%edx
 6c2:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6c5:	39 f1                	cmp    %esi,%ecx
 6c7:	75 d6                	jne    69f <free+0x4f>
  freep = p;
 6c9:	a3 80 0a 00 00       	mov    %eax,0xa80
    p->s.size += bp->s.size;
 6ce:	8b 4b fc             	mov    -0x4(%ebx),%ecx
 6d1:	01 ca                	add    %ecx,%edx
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6d9:	89 10                	mov    %edx,(%eax)
}
 6db:	5b                   	pop    %ebx
 6dc:	5e                   	pop    %esi
 6dd:	5f                   	pop    %edi
 6de:	5d                   	pop    %ebp
 6df:	c3                   	ret    

000006e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ec:	8b 3d 80 0a 00 00    	mov    0xa80,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	8d 70 07             	lea    0x7(%eax),%esi
 6f5:	c1 ee 03             	shr    $0x3,%esi
 6f8:	46                   	inc    %esi
  if((prevp = freep) == 0){
 6f9:	85 ff                	test   %edi,%edi
 6fb:	0f 84 9f 00 00 00    	je     7a0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 701:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 703:	8b 48 04             	mov    0x4(%eax),%ecx
 706:	39 f1                	cmp    %esi,%ecx
 708:	73 6c                	jae    776 <malloc+0x96>
 70a:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 710:	bb 00 10 00 00       	mov    $0x1000,%ebx
 715:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 718:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 71f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 722:	eb 1d                	jmp    741 <malloc+0x61>
 724:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 72f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 730:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 732:	8b 4a 04             	mov    0x4(%edx),%ecx
 735:	39 f1                	cmp    %esi,%ecx
 737:	73 47                	jae    780 <malloc+0xa0>
 739:	8b 3d 80 0a 00 00    	mov    0xa80,%edi
 73f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 741:	39 c7                	cmp    %eax,%edi
 743:	75 eb                	jne    730 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 748:	89 04 24             	mov    %eax,(%esp)
 74b:	e8 2b fc ff ff       	call   37b <sbrk>
  if(p == (char*)-1)
 750:	83 f8 ff             	cmp    $0xffffffff,%eax
 753:	74 17                	je     76c <malloc+0x8c>
  hp->s.size = nu;
 755:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 758:	83 c0 08             	add    $0x8,%eax
 75b:	89 04 24             	mov    %eax,(%esp)
 75e:	e8 ed fe ff ff       	call   650 <free>
  return freep;
 763:	a1 80 0a 00 00       	mov    0xa80,%eax
      if((p = morecore(nunits)) == 0)
 768:	85 c0                	test   %eax,%eax
 76a:	75 c4                	jne    730 <malloc+0x50>
        return 0;
  }
}
 76c:	83 c4 2c             	add    $0x2c,%esp
        return 0;
 76f:	31 c0                	xor    %eax,%eax
}
 771:	5b                   	pop    %ebx
 772:	5e                   	pop    %esi
 773:	5f                   	pop    %edi
 774:	5d                   	pop    %ebp
 775:	c3                   	ret    
    if(p->s.size >= nunits){
 776:	89 c2                	mov    %eax,%edx
 778:	89 f8                	mov    %edi,%eax
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 780:	39 ce                	cmp    %ecx,%esi
 782:	74 4c                	je     7d0 <malloc+0xf0>
        p->s.size -= nunits;
 784:	29 f1                	sub    %esi,%ecx
 786:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 789:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 78c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 78f:	a3 80 0a 00 00       	mov    %eax,0xa80
      return (void*)(p + 1);
 794:	8d 42 08             	lea    0x8(%edx),%eax
}
 797:	83 c4 2c             	add    $0x2c,%esp
 79a:	5b                   	pop    %ebx
 79b:	5e                   	pop    %esi
 79c:	5f                   	pop    %edi
 79d:	5d                   	pop    %ebp
 79e:	c3                   	ret    
 79f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 7a0:	b8 84 0a 00 00       	mov    $0xa84,%eax
 7a5:	ba 84 0a 00 00       	mov    $0xa84,%edx
 7aa:	a3 80 0a 00 00       	mov    %eax,0xa80
    base.s.size = 0;
 7af:	31 c9                	xor    %ecx,%ecx
 7b1:	bf 84 0a 00 00       	mov    $0xa84,%edi
    base.s.ptr = freep = prevp = &base;
 7b6:	89 15 84 0a 00 00    	mov    %edx,0xa84
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 7be:	89 0d 88 0a 00 00    	mov    %ecx,0xa88
    if(p->s.size >= nunits){
 7c4:	e9 41 ff ff ff       	jmp    70a <malloc+0x2a>
 7c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7d0:	8b 0a                	mov    (%edx),%ecx
 7d2:	89 08                	mov    %ecx,(%eax)
 7d4:	eb b9                	jmp    78f <malloc+0xaf>
