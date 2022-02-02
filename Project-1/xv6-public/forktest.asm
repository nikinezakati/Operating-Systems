
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
   6:	e8 35 00 00 00       	call   40 <forktest>
  exit();
   b:	e8 b3 03 00 00       	call   3c3 <exit>

00000010 <printf>:
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	53                   	push   %ebx
  14:	83 ec 14             	sub    $0x14,%esp
  17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
  1a:	89 1c 24             	mov    %ebx,(%esp)
  1d:	e8 be 01 00 00       	call   1e0 <strlen>
  22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  26:	89 44 24 08          	mov    %eax,0x8(%esp)
  2a:	8b 45 08             	mov    0x8(%ebp),%eax
  2d:	89 04 24             	mov    %eax,(%esp)
  30:	e8 ae 03 00 00       	call   3e3 <write>
}
  35:	83 c4 14             	add    $0x14,%esp
  38:	5b                   	pop    %ebx
  39:	5d                   	pop    %ebp
  3a:	c3                   	ret    
  3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  3f:	90                   	nop

00000040 <forktest>:
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	53                   	push   %ebx
  for(n=0; n<N; n++){
  44:	31 db                	xor    %ebx,%ebx
{
  46:	83 ec 14             	sub    $0x14,%esp
  write(fd, s, strlen(s));
  49:	c7 04 24 6c 04 00 00 	movl   $0x46c,(%esp)
  50:	e8 8b 01 00 00       	call   1e0 <strlen>
  55:	b9 6c 04 00 00       	mov    $0x46c,%ecx
  5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  65:	89 44 24 08          	mov    %eax,0x8(%esp)
  69:	e8 75 03 00 00       	call   3e3 <write>
  for(n=0; n<N; n++){
  6e:	eb 16                	jmp    86 <forktest+0x46>
    if(pid == 0)
  70:	0f 84 92 00 00 00    	je     108 <forktest+0xc8>
  for(n=0; n<N; n++){
  76:	43                   	inc    %ebx
  77:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  7d:	8d 76 00             	lea    0x0(%esi),%esi
  80:	0f 84 b0 00 00 00    	je     136 <forktest+0xf6>
    pid = fork();
  86:	e8 30 03 00 00       	call   3bb <fork>
    if(pid < 0)
  8b:	85 c0                	test   %eax,%eax
  8d:	79 e1                	jns    70 <forktest+0x30>
  for(; n > 0; n--){
  8f:	85 db                	test   %ebx,%ebx
  91:	74 19                	je     ac <forktest+0x6c>
  93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
  a0:	e8 26 03 00 00       	call   3cb <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	78 3a                	js     e3 <forktest+0xa3>
  for(; n > 0; n--){
  a9:	4b                   	dec    %ebx
  aa:	75 f4                	jne    a0 <forktest+0x60>
  if(wait() != -1){
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  b0:	e8 16 03 00 00       	call   3cb <wait>
  b5:	40                   	inc    %eax
  b6:	75 55                	jne    10d <forktest+0xcd>
  write(fd, s, strlen(s));
  b8:	c7 04 24 9e 04 00 00 	movl   $0x49e,(%esp)
  bf:	e8 1c 01 00 00       	call   1e0 <strlen>
  c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  cf:	b8 9e 04 00 00       	mov    $0x49e,%eax
  d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  d8:	e8 06 03 00 00       	call   3e3 <write>
}
  dd:	83 c4 14             	add    $0x14,%esp
  e0:	5b                   	pop    %ebx
  e1:	5d                   	pop    %ebp
  e2:	c3                   	ret    
  write(fd, s, strlen(s));
  e3:	c7 04 24 77 04 00 00 	movl   $0x477,(%esp)
  ea:	e8 f1 00 00 00       	call   1e0 <strlen>
  ef:	ba 77 04 00 00       	mov    $0x477,%edx
  f4:	89 54 24 04          	mov    %edx,0x4(%esp)
  f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ff:	89 44 24 08          	mov    %eax,0x8(%esp)
 103:	e8 db 02 00 00       	call   3e3 <write>
      exit();
 108:	e8 b6 02 00 00       	call   3c3 <exit>
  write(fd, s, strlen(s));
 10d:	c7 04 24 8b 04 00 00 	movl   $0x48b,(%esp)
 114:	e8 c7 00 00 00       	call   1e0 <strlen>
 119:	c7 44 24 04 8b 04 00 	movl   $0x48b,0x4(%esp)
 120:	00 
 121:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 128:	89 44 24 08          	mov    %eax,0x8(%esp)
 12c:	e8 b2 02 00 00       	call   3e3 <write>
    exit();
 131:	e8 8d 02 00 00       	call   3c3 <exit>
  write(fd, s, strlen(s));
 136:	c7 04 24 ac 04 00 00 	movl   $0x4ac,(%esp)
 13d:	e8 9e 00 00 00       	call   1e0 <strlen>
 142:	c7 44 24 04 ac 04 00 	movl   $0x4ac,0x4(%esp)
 149:	00 
 14a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 151:	89 44 24 08          	mov    %eax,0x8(%esp)
 155:	e8 89 02 00 00       	call   3e3 <write>
    exit();
 15a:	e8 64 02 00 00       	call   3c3 <exit>
 15f:	90                   	nop

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 160:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 161:	31 c0                	xor    %eax,%eax
{
 163:	89 e5                	mov    %esp,%ebp
 165:	53                   	push   %ebx
 166:	8b 4d 08             	mov    0x8(%ebp),%ecx
 169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 170:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 174:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 177:	40                   	inc    %eax
 178:	84 d2                	test   %dl,%dl
 17a:	75 f4                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 17c:	5b                   	pop    %ebx
 17d:	89 c8                	mov    %ecx,%eax
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18f:	90                   	nop

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 5d 08             	mov    0x8(%ebp),%ebx
 197:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 19a:	0f b6 03             	movzbl (%ebx),%eax
 19d:	0f b6 0a             	movzbl (%edx),%ecx
 1a0:	84 c0                	test   %al,%al
 1a2:	75 19                	jne    1bd <strcmp+0x2d>
 1a4:	eb 2a                	jmp    1d0 <strcmp+0x40>
 1a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
 1b0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
 1b4:	43                   	inc    %ebx
 1b5:	42                   	inc    %edx
  while(*p && *p == *q)
 1b6:	0f b6 0a             	movzbl (%edx),%ecx
 1b9:	84 c0                	test   %al,%al
 1bb:	74 13                	je     1d0 <strcmp+0x40>
 1bd:	38 c8                	cmp    %cl,%al
 1bf:	74 ef                	je     1b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
 1c1:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
 1c2:	29 c8                	sub    %ecx,%eax
}
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    
 1c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
 1d0:	5b                   	pop    %ebx
 1d1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1d3:	29 c8                	sub    %ecx,%eax
}
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1de:	66 90                	xchg   %ax,%ax

000001e0 <strlen>:

uint
strlen(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	80 3a 00             	cmpb   $0x0,(%edx)
 1e9:	74 15                	je     200 <strlen+0x20>
 1eb:	31 c0                	xor    %eax,%eax
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	40                   	inc    %eax
 1f1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1f5:	89 c1                	mov    %eax,%ecx
 1f7:	75 f7                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1f9:	5d                   	pop    %ebp
 1fa:	89 c8                	mov    %ecx,%eax
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
 201:	31 c9                	xor    %ecx,%ecx
}
 203:	89 c8                	mov    %ecx,%eax
 205:	c3                   	ret    
 206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20d:	8d 76 00             	lea    0x0(%esi),%esi

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 55 08             	mov    0x8(%ebp),%edx
 216:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 217:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 d7                	mov    %edx,%edi
 21f:	fc                   	cld    
 220:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 222:	5f                   	pop    %edi
 223:	89 d0                	mov    %edx,%eax
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 23a:	0f b6 10             	movzbl (%eax),%edx
 23d:	84 d2                	test   %dl,%dl
 23f:	75 18                	jne    259 <strchr+0x29>
 241:	eb 1d                	jmp    260 <strchr+0x30>
 243:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 250:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 254:	40                   	inc    %eax
 255:	84 d2                	test   %dl,%dl
 257:	74 07                	je     260 <strchr+0x30>
    if(*s == c)
 259:	38 d1                	cmp    %dl,%cl
 25b:	75 f3                	jne    250 <strchr+0x20>
      return (char*)s;
  return 0;
}
 25d:	5d                   	pop    %ebp
 25e:	c3                   	ret    
 25f:	90                   	nop
 260:	5d                   	pop    %ebp
  return 0;
 261:	31 c0                	xor    %eax,%eax
}
 263:	c3                   	ret    
 264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 26f:	90                   	nop

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
 275:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 278:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 27b:	83 ec 3c             	sub    $0x3c,%esp
 27e:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 281:	eb 3a                	jmp    2bd <gets+0x4d>
 283:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 290:	89 7c 24 04          	mov    %edi,0x4(%esp)
 294:	ba 01 00 00 00       	mov    $0x1,%edx
 299:	89 54 24 08          	mov    %edx,0x8(%esp)
 29d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2a4:	e8 32 01 00 00       	call   3db <read>
    if(cc < 1)
 2a9:	85 c0                	test   %eax,%eax
 2ab:	7e 19                	jle    2c6 <gets+0x56>
      break;
    buf[i++] = c;
 2ad:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2b1:	46                   	inc    %esi
 2b2:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 2b5:	3c 0a                	cmp    $0xa,%al
 2b7:	74 27                	je     2e0 <gets+0x70>
 2b9:	3c 0d                	cmp    $0xd,%al
 2bb:	74 23                	je     2e0 <gets+0x70>
  for(i=0; i+1 < max; ){
 2bd:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 2c0:	43                   	inc    %ebx
 2c1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2c4:	7c ca                	jl     290 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 2c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	83 c4 3c             	add    $0x3c,%esp
 2d2:	5b                   	pop    %ebx
 2d3:	5e                   	pop    %esi
 2d4:	5f                   	pop    %edi
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
 2d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2de:	66 90                	xchg   %ax,%ax
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	01 c3                	add    %eax,%ebx
 2e5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 2e8:	eb dc                	jmp    2c6 <gets+0x56>
 2ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f0:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f1:	31 c0                	xor    %eax,%eax
{
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 2f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
{
 2ff:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 302:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 305:	89 04 24             	mov    %eax,(%esp)
 308:	e8 f6 00 00 00       	call   403 <open>
  if(fd < 0)
 30d:	85 c0                	test   %eax,%eax
 30f:	78 2f                	js     340 <stat+0x50>
 311:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 313:	8b 45 0c             	mov    0xc(%ebp),%eax
 316:	89 1c 24             	mov    %ebx,(%esp)
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	e8 f9 00 00 00       	call   41b <fstat>
  close(fd);
 322:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 325:	89 c6                	mov    %eax,%esi
  close(fd);
 327:	e8 bf 00 00 00       	call   3eb <close>
  return r;
}
 32c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 32f:	89 f0                	mov    %esi,%eax
 331:	8b 75 fc             	mov    -0x4(%ebp),%esi
 334:	89 ec                	mov    %ebp,%esp
 336:	5d                   	pop    %ebp
 337:	c3                   	ret    
 338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33f:	90                   	nop
    return -1;
 340:	be ff ff ff ff       	mov    $0xffffffff,%esi
 345:	eb e5                	jmp    32c <stat+0x3c>
 347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34e:	66 90                	xchg   %ax,%ax

00000350 <atoi>:

int
atoi(const char *s)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 357:	0f be 02             	movsbl (%edx),%eax
 35a:	88 c1                	mov    %al,%cl
 35c:	80 e9 30             	sub    $0x30,%cl
 35f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 362:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 367:	77 1c                	ja     385 <atoi+0x35>
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 370:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 373:	42                   	inc    %edx
 374:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 378:	0f be 02             	movsbl (%edx),%eax
 37b:	88 c3                	mov    %al,%bl
 37d:	80 eb 30             	sub    $0x30,%bl
 380:	80 fb 09             	cmp    $0x9,%bl
 383:	76 eb                	jbe    370 <atoi+0x20>
  return n;
}
 385:	5b                   	pop    %ebx
 386:	89 c8                	mov    %ecx,%eax
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	8b 45 10             	mov    0x10(%ebp),%eax
 397:	56                   	push   %esi
 398:	8b 55 08             	mov    0x8(%ebp),%edx
 39b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39e:	85 c0                	test   %eax,%eax
 3a0:	7e 13                	jle    3b5 <memmove+0x25>
 3a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3a4:	89 d7                	mov    %edx,%edi
 3a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 3b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3b1:	39 f8                	cmp    %edi,%eax
 3b3:	75 fb                	jne    3b0 <memmove+0x20>
  return vdst;
}
 3b5:	5e                   	pop    %esi
 3b6:	89 d0                	mov    %edx,%eax
 3b8:	5f                   	pop    %edi
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret    

000003bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3bb:	b8 01 00 00 00       	mov    $0x1,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <exit>:
SYSCALL(exit)
 3c3:	b8 02 00 00 00       	mov    $0x2,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <wait>:
SYSCALL(wait)
 3cb:	b8 03 00 00 00       	mov    $0x3,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <pipe>:
SYSCALL(pipe)
 3d3:	b8 04 00 00 00       	mov    $0x4,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <read>:
SYSCALL(read)
 3db:	b8 05 00 00 00       	mov    $0x5,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <write>:
SYSCALL(write)
 3e3:	b8 10 00 00 00       	mov    $0x10,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <close>:
SYSCALL(close)
 3eb:	b8 15 00 00 00       	mov    $0x15,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <kill>:
SYSCALL(kill)
 3f3:	b8 06 00 00 00       	mov    $0x6,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <exec>:
SYSCALL(exec)
 3fb:	b8 07 00 00 00       	mov    $0x7,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <open>:
SYSCALL(open)
 403:	b8 0f 00 00 00       	mov    $0xf,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mknod>:
SYSCALL(mknod)
 40b:	b8 11 00 00 00       	mov    $0x11,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <unlink>:
SYSCALL(unlink)
 413:	b8 12 00 00 00       	mov    $0x12,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <fstat>:
SYSCALL(fstat)
 41b:	b8 08 00 00 00       	mov    $0x8,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <link>:
SYSCALL(link)
 423:	b8 13 00 00 00       	mov    $0x13,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <mkdir>:
SYSCALL(mkdir)
 42b:	b8 14 00 00 00       	mov    $0x14,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <chdir>:
SYSCALL(chdir)
 433:	b8 09 00 00 00       	mov    $0x9,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <dup>:
SYSCALL(dup)
 43b:	b8 0a 00 00 00       	mov    $0xa,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <getpid>:
SYSCALL(getpid)
 443:	b8 0b 00 00 00       	mov    $0xb,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <sbrk>:
SYSCALL(sbrk)
 44b:	b8 0c 00 00 00       	mov    $0xc,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <sleep>:
SYSCALL(sleep)
 453:	b8 0d 00 00 00       	mov    $0xd,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <uptime>:
SYSCALL(uptime)
 45b:	b8 0e 00 00 00       	mov    $0xe,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <proc_dump>:
 463:	b8 16 00 00 00       	mov    $0x16,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    
