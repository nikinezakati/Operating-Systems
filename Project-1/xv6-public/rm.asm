
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 10             	sub    $0x10,%esp
   c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  if(argc < 2){
   f:	83 ff 01             	cmp    $0x1,%edi
  12:	7e 43                	jle    57 <main+0x57>
  14:	8b 45 0c             	mov    0xc(%ebp),%eax
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  17:	be 01 00 00 00       	mov    $0x1,%esi
  1c:	8d 58 04             	lea    0x4(%eax),%ebx
  1f:	90                   	nop
    if(unlink(argv[i]) < 0){
  20:	8b 03                	mov    (%ebx),%eax
  22:	89 04 24             	mov    %eax,(%esp)
  25:	e8 f9 02 00 00       	call   323 <unlink>
  2a:	85 c0                	test   %eax,%eax
  2c:	78 0d                	js     3b <main+0x3b>
  for(i = 1; i < argc; i++){
  2e:	46                   	inc    %esi
  2f:	83 c3 04             	add    $0x4,%ebx
  32:	39 f7                	cmp    %esi,%edi
  34:	75 ea                	jne    20 <main+0x20>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  36:	e8 98 02 00 00       	call   2d3 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  3b:	8b 03                	mov    (%ebx),%eax
  3d:	c7 44 24 04 cc 07 00 	movl   $0x7cc,0x4(%esp)
  44:	00 
  45:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  50:	e8 fb 03 00 00       	call   450 <printf>
      break;
  55:	eb df                	jmp    36 <main+0x36>
    printf(2, "Usage: rm files...\n");
  57:	c7 44 24 04 b8 07 00 	movl   $0x7b8,0x4(%esp)
  5e:	00 
  5f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  66:	e8 e5 03 00 00       	call   450 <printf>
    exit();
  6b:	e8 63 02 00 00       	call   2d3 <exit>

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  71:	31 c0                	xor    %eax,%eax
{
  73:	89 e5                	mov    %esp,%ebp
  75:	53                   	push   %ebx
  76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  80:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  84:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  87:	40                   	inc    %eax
  88:	84 d2                	test   %dl,%dl
  8a:	75 f4                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  8c:	5b                   	pop    %ebx
  8d:	89 c8                	mov    %ecx,%eax
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    
  91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9f:	90                   	nop

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  aa:	0f b6 03             	movzbl (%ebx),%eax
  ad:	0f b6 0a             	movzbl (%edx),%ecx
  b0:	84 c0                	test   %al,%al
  b2:	75 19                	jne    cd <strcmp+0x2d>
  b4:	eb 2a                	jmp    e0 <strcmp+0x40>
  b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bd:	8d 76 00             	lea    0x0(%esi),%esi
  c0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
  c4:	43                   	inc    %ebx
  c5:	42                   	inc    %edx
  while(*p && *p == *q)
  c6:	0f b6 0a             	movzbl (%edx),%ecx
  c9:	84 c0                	test   %al,%al
  cb:	74 13                	je     e0 <strcmp+0x40>
  cd:	38 c8                	cmp    %cl,%al
  cf:	74 ef                	je     c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
  d1:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
  d2:	29 c8                	sub    %ecx,%eax
}
  d4:	5d                   	pop    %ebp
  d5:	c3                   	ret    
  d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	5b                   	pop    %ebx
  e1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  e3:	29 c8                	sub    %ecx,%eax
}
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ee:	66 90                	xchg   %ax,%ax

000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 3a 00             	cmpb   $0x0,(%edx)
  f9:	74 15                	je     110 <strlen+0x20>
  fb:	31 c0                	xor    %eax,%eax
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	40                   	inc    %eax
 101:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 105:	89 c1                	mov    %eax,%ecx
 107:	75 f7                	jne    100 <strlen+0x10>
    ;
  return n;
}
 109:	5d                   	pop    %ebp
 10a:	89 c8                	mov    %ecx,%eax
 10c:	c3                   	ret    
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
 111:	31 c9                	xor    %ecx,%ecx
}
 113:	89 c8                	mov    %ecx,%eax
 115:	c3                   	ret    
 116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 55 08             	mov    0x8(%ebp),%edx
 126:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	5f                   	pop    %edi
 133:	89 d0                	mov    %edx,%eax
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13e:	66 90                	xchg   %ax,%ax

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 18                	jne    169 <strchr+0x29>
 151:	eb 1d                	jmp    170 <strchr+0x30>
 153:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 160:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 164:	40                   	inc    %eax
 165:	84 d2                	test   %dl,%dl
 167:	74 07                	je     170 <strchr+0x30>
    if(*s == c)
 169:	38 d1                	cmp    %dl,%cl
 16b:	75 f3                	jne    160 <strchr+0x20>
      return (char*)s;
  return 0;
}
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    
 16f:	90                   	nop
 170:	5d                   	pop    %ebp
  return 0;
 171:	31 c0                	xor    %eax,%eax
}
 173:	c3                   	ret    
 174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
 185:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 188:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 18b:	83 ec 3c             	sub    $0x3c,%esp
 18e:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 191:	eb 3a                	jmp    1cd <gets+0x4d>
 193:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1a4:	ba 01 00 00 00       	mov    $0x1,%edx
 1a9:	89 54 24 08          	mov    %edx,0x8(%esp)
 1ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b4:	e8 32 01 00 00       	call   2eb <read>
    if(cc < 1)
 1b9:	85 c0                	test   %eax,%eax
 1bb:	7e 19                	jle    1d6 <gets+0x56>
      break;
    buf[i++] = c;
 1bd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c1:	46                   	inc    %esi
 1c2:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 1c5:	3c 0a                	cmp    $0xa,%al
 1c7:	74 27                	je     1f0 <gets+0x70>
 1c9:	3c 0d                	cmp    $0xd,%al
 1cb:	74 23                	je     1f0 <gets+0x70>
  for(i=0; i+1 < max; ){
 1cd:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 1d0:	43                   	inc    %ebx
 1d1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1d4:	7c ca                	jl     1a0 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 1d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1d9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	83 c4 3c             	add    $0x3c,%esp
 1e2:	5b                   	pop    %ebx
 1e3:	5e                   	pop    %esi
 1e4:	5f                   	pop    %edi
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	01 c3                	add    %eax,%ebx
 1f5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 1f8:	eb dc                	jmp    1d6 <gets+0x56>
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 201:	31 c0                	xor    %eax,%eax
{
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 208:	89 44 24 04          	mov    %eax,0x4(%esp)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
{
 20f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 212:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 215:	89 04 24             	mov    %eax,(%esp)
 218:	e8 f6 00 00 00       	call   313 <open>
  if(fd < 0)
 21d:	85 c0                	test   %eax,%eax
 21f:	78 2f                	js     250 <stat+0x50>
 221:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 223:	8b 45 0c             	mov    0xc(%ebp),%eax
 226:	89 1c 24             	mov    %ebx,(%esp)
 229:	89 44 24 04          	mov    %eax,0x4(%esp)
 22d:	e8 f9 00 00 00       	call   32b <fstat>
  close(fd);
 232:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 235:	89 c6                	mov    %eax,%esi
  close(fd);
 237:	e8 bf 00 00 00       	call   2fb <close>
  return r;
}
 23c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 23f:	89 f0                	mov    %esi,%eax
 241:	8b 75 fc             	mov    -0x4(%ebp),%esi
 244:	89 ec                	mov    %ebp,%esp
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    
 248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24f:	90                   	nop
    return -1;
 250:	be ff ff ff ff       	mov    $0xffffffff,%esi
 255:	eb e5                	jmp    23c <stat+0x3c>
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax

00000260 <atoi>:

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 267:	0f be 02             	movsbl (%edx),%eax
 26a:	88 c1                	mov    %al,%cl
 26c:	80 e9 30             	sub    $0x30,%cl
 26f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 272:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 277:	77 1c                	ja     295 <atoi+0x35>
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 280:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 283:	42                   	inc    %edx
 284:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 288:	0f be 02             	movsbl (%edx),%eax
 28b:	88 c3                	mov    %al,%bl
 28d:	80 eb 30             	sub    $0x30,%bl
 290:	80 fb 09             	cmp    $0x9,%bl
 293:	76 eb                	jbe    280 <atoi+0x20>
  return n;
}
 295:	5b                   	pop    %ebx
 296:	89 c8                	mov    %ecx,%eax
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    
 29a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	8b 45 10             	mov    0x10(%ebp),%eax
 2a7:	56                   	push   %esi
 2a8:	8b 55 08             	mov    0x8(%ebp),%edx
 2ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	85 c0                	test   %eax,%eax
 2b0:	7e 13                	jle    2c5 <memmove+0x25>
 2b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2b4:	89 d7                	mov    %edx,%edi
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2c1:	39 f8                	cmp    %edi,%eax
 2c3:	75 fb                	jne    2c0 <memmove+0x20>
  return vdst;
}
 2c5:	5e                   	pop    %esi
 2c6:	89 d0                	mov    %edx,%eax
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    

000002cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cb:	b8 01 00 00 00       	mov    $0x1,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <exit>:
SYSCALL(exit)
 2d3:	b8 02 00 00 00       	mov    $0x2,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <wait>:
SYSCALL(wait)
 2db:	b8 03 00 00 00       	mov    $0x3,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <pipe>:
SYSCALL(pipe)
 2e3:	b8 04 00 00 00       	mov    $0x4,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <read>:
SYSCALL(read)
 2eb:	b8 05 00 00 00       	mov    $0x5,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <write>:
SYSCALL(write)
 2f3:	b8 10 00 00 00       	mov    $0x10,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <close>:
SYSCALL(close)
 2fb:	b8 15 00 00 00       	mov    $0x15,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <kill>:
SYSCALL(kill)
 303:	b8 06 00 00 00       	mov    $0x6,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <exec>:
SYSCALL(exec)
 30b:	b8 07 00 00 00       	mov    $0x7,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <open>:
SYSCALL(open)
 313:	b8 0f 00 00 00       	mov    $0xf,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mknod>:
SYSCALL(mknod)
 31b:	b8 11 00 00 00       	mov    $0x11,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <unlink>:
SYSCALL(unlink)
 323:	b8 12 00 00 00       	mov    $0x12,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <fstat>:
SYSCALL(fstat)
 32b:	b8 08 00 00 00       	mov    $0x8,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <link>:
SYSCALL(link)
 333:	b8 13 00 00 00       	mov    $0x13,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mkdir>:
SYSCALL(mkdir)
 33b:	b8 14 00 00 00       	mov    $0x14,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <chdir>:
SYSCALL(chdir)
 343:	b8 09 00 00 00       	mov    $0x9,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <dup>:
SYSCALL(dup)
 34b:	b8 0a 00 00 00       	mov    $0xa,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <getpid>:
SYSCALL(getpid)
 353:	b8 0b 00 00 00       	mov    $0xb,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sbrk>:
SYSCALL(sbrk)
 35b:	b8 0c 00 00 00       	mov    $0xc,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <sleep>:
SYSCALL(sleep)
 363:	b8 0d 00 00 00       	mov    $0xd,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <uptime>:
SYSCALL(uptime)
 36b:	b8 0e 00 00 00       	mov    $0xe,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <proc_dump>:
 373:	b8 16 00 00 00       	mov    $0x16,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    
 37b:	66 90                	xchg   %ax,%ax
 37d:	66 90                	xchg   %ax,%ax
 37f:	90                   	nop

00000380 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	89 cf                	mov    %ecx,%edi
 386:	56                   	push   %esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 387:	89 d1                	mov    %edx,%ecx
{
 389:	53                   	push   %ebx
 38a:	83 ec 4c             	sub    $0x4c,%esp
 38d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 390:	89 d0                	mov    %edx,%eax
 392:	c1 e8 1f             	shr    $0x1f,%eax
 395:	84 c0                	test   %al,%al
 397:	0f 84 a3 00 00 00    	je     440 <printint+0xc0>
 39d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3a1:	0f 84 99 00 00 00    	je     440 <printint+0xc0>
    neg = 1;
 3a7:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3ae:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3b0:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3b7:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3ba:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3c3:	31 d2                	xor    %edx,%edx
 3c5:	8b 5d c0             	mov    -0x40(%ebp),%ebx
 3c8:	f7 f7                	div    %edi
 3ca:	8d 4b 01             	lea    0x1(%ebx),%ecx
 3cd:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 3d0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  }while((x /= base) != 0);
 3d3:	39 cf                	cmp    %ecx,%edi
 3d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    buf[i++] = digits[x % base];
 3d8:	0f b6 92 ec 07 00 00 	movzbl 0x7ec(%edx),%edx
 3df:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 3e3:	76 db                	jbe    3c0 <printint+0x40>
  if(neg)
 3e5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3e8:	85 c9                	test   %ecx,%ecx
 3ea:	74 0c                	je     3f8 <printint+0x78>
    buf[i++] = '-';
 3ec:	8b 45 c0             	mov    -0x40(%ebp),%eax
 3ef:	b2 2d                	mov    $0x2d,%dl
 3f1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    buf[i++] = digits[x % base];
 3f6:	89 c3                	mov    %eax,%ebx

  while(--i >= 0)
 3f8:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3fb:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3ff:	eb 13                	jmp    414 <printint+0x94>
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop
 410:	0f b6 13             	movzbl (%ebx),%edx
 413:	4b                   	dec    %ebx
  write(fd, &c, 1);
 414:	89 74 24 04          	mov    %esi,0x4(%esp)
 418:	b8 01 00 00 00       	mov    $0x1,%eax
 41d:	89 44 24 08          	mov    %eax,0x8(%esp)
 421:	89 3c 24             	mov    %edi,(%esp)
 424:	88 55 d7             	mov    %dl,-0x29(%ebp)
 427:	e8 c7 fe ff ff       	call   2f3 <write>
  while(--i >= 0)
 42c:	39 de                	cmp    %ebx,%esi
 42e:	75 e0                	jne    410 <printint+0x90>
    putc(fd, buf[i]);
}
 430:	83 c4 4c             	add    $0x4c,%esp
 433:	5b                   	pop    %ebx
 434:	5e                   	pop    %esi
 435:	5f                   	pop    %edi
 436:	5d                   	pop    %ebp
 437:	c3                   	ret    
 438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop
  neg = 0;
 440:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 447:	e9 64 ff ff ff       	jmp    3b0 <printint+0x30>
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 459:	8b 75 0c             	mov    0xc(%ebp),%esi
 45c:	0f b6 1e             	movzbl (%esi),%ebx
 45f:	84 db                	test   %bl,%bl
 461:	0f 84 c8 00 00 00    	je     52f <printf+0xdf>
  ap = (uint*)(void*)&fmt + 1;
 467:	8d 45 10             	lea    0x10(%ebp),%eax
 46a:	46                   	inc    %esi
 46b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  write(fd, &c, 1);
 46e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 471:	31 d2                	xor    %edx,%edx
 473:	eb 3e                	jmp    4b3 <printf+0x63>
 475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 480:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 483:	83 f8 25             	cmp    $0x25,%eax
        state = '%';
 486:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 48b:	74 1e                	je     4ab <printf+0x5b>
  write(fd, &c, 1);
 48d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 491:	b8 01 00 00 00       	mov    $0x1,%eax
 496:	89 44 24 08          	mov    %eax,0x8(%esp)
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4a0:	89 04 24             	mov    %eax,(%esp)
 4a3:	e8 4b fe ff ff       	call   2f3 <write>
 4a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 4ab:	0f b6 1e             	movzbl (%esi),%ebx
 4ae:	46                   	inc    %esi
 4af:	84 db                	test   %bl,%bl
 4b1:	74 7c                	je     52f <printf+0xdf>
    if(state == 0){
 4b3:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 4b5:	0f be cb             	movsbl %bl,%ecx
 4b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4bb:	74 c3                	je     480 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4bd:	83 fa 25             	cmp    $0x25,%edx
 4c0:	75 e9                	jne    4ab <printf+0x5b>
      if(c == 'd'){
 4c2:	83 f8 64             	cmp    $0x64,%eax
 4c5:	0f 84 a5 00 00 00    	je     570 <printf+0x120>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4cb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4d1:	83 f9 70             	cmp    $0x70,%ecx
 4d4:	74 6a                	je     540 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4d6:	83 f8 73             	cmp    $0x73,%eax
 4d9:	0f 84 e1 00 00 00    	je     5c0 <printf+0x170>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4df:	83 f8 63             	cmp    $0x63,%eax
 4e2:	0f 84 98 00 00 00    	je     580 <printf+0x130>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4e8:	83 f8 25             	cmp    $0x25,%eax
 4eb:	74 1c                	je     509 <printf+0xb9>
  write(fd, &c, 1);
 4ed:	89 7c 24 04          	mov    %edi,0x4(%esp)
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	ba 01 00 00 00       	mov    $0x1,%edx
 4f9:	89 54 24 08          	mov    %edx,0x8(%esp)
 4fd:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 501:	89 04 24             	mov    %eax,(%esp)
 504:	e8 ea fd ff ff       	call   2f3 <write>
 509:	89 7c 24 04          	mov    %edi,0x4(%esp)
 50d:	b8 01 00 00 00       	mov    $0x1,%eax
 512:	46                   	inc    %esi
 513:	89 44 24 08          	mov    %eax,0x8(%esp)
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	88 5d e7             	mov    %bl,-0x19(%ebp)
 51d:	89 04 24             	mov    %eax,(%esp)
 520:	e8 ce fd ff ff       	call   2f3 <write>
  for(i = 0; fmt[i]; i++){
 525:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 529:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 52b:	84 db                	test   %bl,%bl
 52d:	75 84                	jne    4b3 <printf+0x63>
    }
  }
}
 52f:	83 c4 3c             	add    $0x3c,%esp
 532:	5b                   	pop    %ebx
 533:	5e                   	pop    %esi
 534:	5f                   	pop    %edi
 535:	5d                   	pop    %ebp
 536:	c3                   	ret    
 537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 540:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 547:	b9 10 00 00 00       	mov    $0x10,%ecx
 54c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	8b 13                	mov    (%ebx),%edx
 554:	e8 27 fe ff ff       	call   380 <printint>
        ap++;
 559:	89 d8                	mov    %ebx,%eax
      state = 0;
 55b:	31 d2                	xor    %edx,%edx
        ap++;
 55d:	83 c0 04             	add    $0x4,%eax
 560:	89 45 d0             	mov    %eax,-0x30(%ebp)
 563:	e9 43 ff ff ff       	jmp    4ab <printf+0x5b>
 568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop
        printint(fd, *ap, 10, 1);
 570:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 577:	b9 0a 00 00 00       	mov    $0xa,%ecx
 57c:	eb ce                	jmp    54c <printf+0xfc>
 57e:	66 90                	xchg   %ax,%ax
        putc(fd, *ap);
 580:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 583:	b9 01 00 00 00       	mov    $0x1,%ecx
        putc(fd, *ap);
 588:	8b 03                	mov    (%ebx),%eax
        ap++;
 58a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 58d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 591:	89 7c 24 04          	mov    %edi,0x4(%esp)
        putc(fd, *ap);
 595:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 598:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
 59c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 59f:	8b 45 08             	mov    0x8(%ebp),%eax
 5a2:	89 04 24             	mov    %eax,(%esp)
 5a5:	e8 49 fd ff ff       	call   2f3 <write>
      state = 0;
 5aa:	31 d2                	xor    %edx,%edx
        ap++;
 5ac:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5af:	e9 f7 fe ff ff       	jmp    4ab <printf+0x5b>
 5b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop
        s = (char*)*ap;
 5c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5c3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5c5:	83 c0 04             	add    $0x4,%eax
 5c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5cb:	85 db                	test   %ebx,%ebx
 5cd:	74 11                	je     5e0 <printf+0x190>
        while(*s != 0){
 5cf:	0f b6 03             	movzbl (%ebx),%eax
 5d2:	84 c0                	test   %al,%al
 5d4:	74 44                	je     61a <printf+0x1ca>
 5d6:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5d9:	89 de                	mov    %ebx,%esi
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5de:	eb 10                	jmp    5f0 <printf+0x1a0>
 5e0:	89 75 d4             	mov    %esi,-0x2c(%ebp)
          s = "(null)";
 5e3:	bb e5 07 00 00       	mov    $0x7e5,%ebx
        while(*s != 0){
 5e8:	b0 28                	mov    $0x28,%al
 5ea:	89 de                	mov    %ebx,%esi
 5ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ef:	90                   	nop
          putc(fd, *s);
 5f0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5f3:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 5f8:	46                   	inc    %esi
  write(fd, &c, 1);
 5f9:	89 44 24 08          	mov    %eax,0x8(%esp)
 5fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
 601:	89 1c 24             	mov    %ebx,(%esp)
 604:	e8 ea fc ff ff       	call   2f3 <write>
        while(*s != 0){
 609:	0f b6 06             	movzbl (%esi),%eax
 60c:	84 c0                	test   %al,%al
 60e:	75 e0                	jne    5f0 <printf+0x1a0>
 610:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 613:	31 d2                	xor    %edx,%edx
 615:	e9 91 fe ff ff       	jmp    4ab <printf+0x5b>
 61a:	31 d2                	xor    %edx,%edx
 61c:	e9 8a fe ff ff       	jmp    4ab <printf+0x5b>
 621:	66 90                	xchg   %ax,%ax
 623:	66 90                	xchg   %ax,%ax
 625:	66 90                	xchg   %ax,%ax
 627:	66 90                	xchg   %ax,%ax
 629:	66 90                	xchg   %ax,%ax
 62b:	66 90                	xchg   %ax,%ax
 62d:	66 90                	xchg   %ax,%ax
 62f:	90                   	nop

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	a1 84 0a 00 00       	mov    0xa84,%eax
{
 636:	89 e5                	mov    %esp,%ebp
 638:	57                   	push   %edi
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
 63b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 63e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 640:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 643:	39 c8                	cmp    %ecx,%eax
 645:	73 19                	jae    660 <free+0x30>
 647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64e:	66 90                	xchg   %ax,%ax
 650:	39 d1                	cmp    %edx,%ecx
 652:	72 14                	jb     668 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 654:	39 d0                	cmp    %edx,%eax
 656:	73 10                	jae    668 <free+0x38>
{
 658:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65a:	39 c8                	cmp    %ecx,%eax
 65c:	8b 10                	mov    (%eax),%edx
 65e:	72 f0                	jb     650 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 660:	39 d0                	cmp    %edx,%eax
 662:	72 f4                	jb     658 <free+0x28>
 664:	39 d1                	cmp    %edx,%ecx
 666:	73 f0                	jae    658 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 668:	8b 73 fc             	mov    -0x4(%ebx),%esi
 66b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 66e:	39 fa                	cmp    %edi,%edx
 670:	74 1e                	je     690 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 672:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 675:	8b 50 04             	mov    0x4(%eax),%edx
 678:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 67b:	39 f1                	cmp    %esi,%ecx
 67d:	74 2a                	je     6a9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 67f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 681:	5b                   	pop    %ebx
  freep = p;
 682:	a3 84 0a 00 00       	mov    %eax,0xa84
}
 687:	5e                   	pop    %esi
 688:	5f                   	pop    %edi
 689:	5d                   	pop    %ebp
 68a:	c3                   	ret    
 68b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 690:	8b 7a 04             	mov    0x4(%edx),%edi
 693:	01 fe                	add    %edi,%esi
 695:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	8b 10                	mov    (%eax),%edx
 69a:	8b 12                	mov    (%edx),%edx
 69c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 69f:	8b 50 04             	mov    0x4(%eax),%edx
 6a2:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6a5:	39 f1                	cmp    %esi,%ecx
 6a7:	75 d6                	jne    67f <free+0x4f>
  freep = p;
 6a9:	a3 84 0a 00 00       	mov    %eax,0xa84
    p->s.size += bp->s.size;
 6ae:	8b 4b fc             	mov    -0x4(%ebx),%ecx
 6b1:	01 ca                	add    %ecx,%edx
 6b3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b9:	89 10                	mov    %edx,(%eax)
}
 6bb:	5b                   	pop    %ebx
 6bc:	5e                   	pop    %esi
 6bd:	5f                   	pop    %edi
 6be:	5d                   	pop    %ebp
 6bf:	c3                   	ret    

000006c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6cc:	8b 3d 84 0a 00 00    	mov    0xa84,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d2:	8d 70 07             	lea    0x7(%eax),%esi
 6d5:	c1 ee 03             	shr    $0x3,%esi
 6d8:	46                   	inc    %esi
  if((prevp = freep) == 0){
 6d9:	85 ff                	test   %edi,%edi
 6db:	0f 84 9f 00 00 00    	je     780 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e1:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 6e3:	8b 48 04             	mov    0x4(%eax),%ecx
 6e6:	39 f1                	cmp    %esi,%ecx
 6e8:	73 6c                	jae    756 <malloc+0x96>
 6ea:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6f0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6f5:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6f8:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 702:	eb 1d                	jmp    721 <malloc+0x61>
 704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 710:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 712:	8b 4a 04             	mov    0x4(%edx),%ecx
 715:	39 f1                	cmp    %esi,%ecx
 717:	73 47                	jae    760 <malloc+0xa0>
 719:	8b 3d 84 0a 00 00    	mov    0xa84,%edi
 71f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 721:	39 c7                	cmp    %eax,%edi
 723:	75 eb                	jne    710 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 728:	89 04 24             	mov    %eax,(%esp)
 72b:	e8 2b fc ff ff       	call   35b <sbrk>
  if(p == (char*)-1)
 730:	83 f8 ff             	cmp    $0xffffffff,%eax
 733:	74 17                	je     74c <malloc+0x8c>
  hp->s.size = nu;
 735:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 738:	83 c0 08             	add    $0x8,%eax
 73b:	89 04 24             	mov    %eax,(%esp)
 73e:	e8 ed fe ff ff       	call   630 <free>
  return freep;
 743:	a1 84 0a 00 00       	mov    0xa84,%eax
      if((p = morecore(nunits)) == 0)
 748:	85 c0                	test   %eax,%eax
 74a:	75 c4                	jne    710 <malloc+0x50>
        return 0;
  }
}
 74c:	83 c4 2c             	add    $0x2c,%esp
        return 0;
 74f:	31 c0                	xor    %eax,%eax
}
 751:	5b                   	pop    %ebx
 752:	5e                   	pop    %esi
 753:	5f                   	pop    %edi
 754:	5d                   	pop    %ebp
 755:	c3                   	ret    
    if(p->s.size >= nunits){
 756:	89 c2                	mov    %eax,%edx
 758:	89 f8                	mov    %edi,%eax
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 760:	39 ce                	cmp    %ecx,%esi
 762:	74 4c                	je     7b0 <malloc+0xf0>
        p->s.size -= nunits;
 764:	29 f1                	sub    %esi,%ecx
 766:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 769:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 76c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 76f:	a3 84 0a 00 00       	mov    %eax,0xa84
      return (void*)(p + 1);
 774:	8d 42 08             	lea    0x8(%edx),%eax
}
 777:	83 c4 2c             	add    $0x2c,%esp
 77a:	5b                   	pop    %ebx
 77b:	5e                   	pop    %esi
 77c:	5f                   	pop    %edi
 77d:	5d                   	pop    %ebp
 77e:	c3                   	ret    
 77f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 780:	b8 88 0a 00 00       	mov    $0xa88,%eax
 785:	ba 88 0a 00 00       	mov    $0xa88,%edx
 78a:	a3 84 0a 00 00       	mov    %eax,0xa84
    base.s.size = 0;
 78f:	31 c9                	xor    %ecx,%ecx
 791:	bf 88 0a 00 00       	mov    $0xa88,%edi
    base.s.ptr = freep = prevp = &base;
 796:	89 15 88 0a 00 00    	mov    %edx,0xa88
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79c:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 79e:	89 0d 8c 0a 00 00    	mov    %ecx,0xa8c
    if(p->s.size >= nunits){
 7a4:	e9 41 ff ff ff       	jmp    6ea <malloc+0x2a>
 7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7b0:	8b 0a                	mov    (%edx),%ecx
 7b2:	89 08                	mov    %ecx,(%eax)
 7b4:	eb b9                	jmp    76f <malloc+0xaf>
