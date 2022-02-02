
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

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
  int fd, i;

  if(argc <= 1){
   c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  10:	7e 61                	jle    73 <main+0x73>
  12:	8b 45 0c             	mov    0xc(%ebp),%eax
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  15:	be 01 00 00 00       	mov    $0x1,%esi
  1a:	8d 78 04             	lea    0x4(%eax),%edi
  1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((fd = open(argv[i], 0)) < 0){
  20:	31 c0                	xor    %eax,%eax
  22:	89 44 24 04          	mov    %eax,0x4(%esp)
  26:	8b 07                	mov    (%edi),%eax
  28:	89 04 24             	mov    %eax,(%esp)
  2b:	e8 93 03 00 00       	call   3c3 <open>
  30:	85 c0                	test   %eax,%eax
  32:	89 c3                	mov    %eax,%ebx
  34:	78 1e                	js     54 <main+0x54>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  36:	89 04 24             	mov    %eax,(%esp)
  for(i = 1; i < argc; i++){
  39:	46                   	inc    %esi
  3a:	83 c7 04             	add    $0x4,%edi
    cat(fd);
  3d:	e8 4e 00 00 00       	call   90 <cat>
    close(fd);
  42:	89 1c 24             	mov    %ebx,(%esp)
  45:	e8 61 03 00 00       	call   3ab <close>
  for(i = 1; i < argc; i++){
  4a:	39 75 08             	cmp    %esi,0x8(%ebp)
  4d:	75 d1                	jne    20 <main+0x20>
  }
  exit();
  4f:	e8 2f 03 00 00       	call   383 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  54:	8b 07                	mov    (%edi),%eax
  56:	c7 44 24 04 8b 08 00 	movl   $0x88b,0x4(%esp)
  5d:	00 
  5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  65:	89 44 24 08          	mov    %eax,0x8(%esp)
  69:	e8 92 04 00 00       	call   500 <printf>
      exit();
  6e:	e8 10 03 00 00       	call   383 <exit>
    cat(0);
  73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7a:	e8 11 00 00 00       	call   90 <cat>
    exit();
  7f:	e8 ff 02 00 00       	call   383 <exit>
  84:	66 90                	xchg   %ax,%ax
  86:	66 90                	xchg   %ax,%ax
  88:	66 90                	xchg   %ax,%ax
  8a:	66 90                	xchg   %ax,%ax
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <cat>:
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	56                   	push   %esi
  94:	53                   	push   %ebx
  95:	83 ec 10             	sub    $0x10,%esp
  98:	8b 75 08             	mov    0x8(%ebp),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  9b:	eb 20                	jmp    bd <cat+0x2d>
  9d:	8d 76 00             	lea    0x0(%esi),%esi
    if (write(1, buf, n) != n) {
  a0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  a4:	b8 a0 0b 00 00       	mov    $0xba0,%eax
  a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b4:	e8 ea 02 00 00       	call   3a3 <write>
  b9:	39 d8                	cmp    %ebx,%eax
  bb:	75 29                	jne    e6 <cat+0x56>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  bd:	89 34 24             	mov    %esi,(%esp)
  c0:	b8 00 02 00 00       	mov    $0x200,%eax
  c5:	ba a0 0b 00 00       	mov    $0xba0,%edx
  ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  d2:	e8 c4 02 00 00       	call   39b <read>
  d7:	85 c0                	test   %eax,%eax
  d9:	89 c3                	mov    %eax,%ebx
  db:	7f c3                	jg     a0 <cat+0x10>
  if(n < 0){
  dd:	75 21                	jne    100 <cat+0x70>
}
  df:	83 c4 10             	add    $0x10,%esp
  e2:	5b                   	pop    %ebx
  e3:	5e                   	pop    %esi
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    
      printf(1, "cat: write error\n");
  e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ed:	b9 68 08 00 00       	mov    $0x868,%ecx
  f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  f6:	e8 05 04 00 00       	call   500 <printf>
      exit();
  fb:	e8 83 02 00 00       	call   383 <exit>
    printf(1, "cat: read error\n");
 100:	c7 44 24 04 7a 08 00 	movl   $0x87a,0x4(%esp)
 107:	00 
 108:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10f:	e8 ec 03 00 00       	call   500 <printf>
    exit();
 114:	e8 6a 02 00 00       	call   383 <exit>
 119:	66 90                	xchg   %ax,%ax
 11b:	66 90                	xchg   %ax,%ax
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 120:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 121:	31 c0                	xor    %eax,%eax
{
 123:	89 e5                	mov    %esp,%ebp
 125:	53                   	push   %ebx
 126:	8b 4d 08             	mov    0x8(%ebp),%ecx
 129:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 130:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 134:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 137:	40                   	inc    %eax
 138:	84 d2                	test   %dl,%dl
 13a:	75 f4                	jne    130 <strcpy+0x10>
    ;
  return os;
}
 13c:	5b                   	pop    %ebx
 13d:	89 c8                	mov    %ecx,%eax
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    
 141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	8b 5d 08             	mov    0x8(%ebp),%ebx
 157:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 15a:	0f b6 03             	movzbl (%ebx),%eax
 15d:	0f b6 0a             	movzbl (%edx),%ecx
 160:	84 c0                	test   %al,%al
 162:	75 19                	jne    17d <strcmp+0x2d>
 164:	eb 2a                	jmp    190 <strcmp+0x40>
 166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
 174:	43                   	inc    %ebx
 175:	42                   	inc    %edx
  while(*p && *p == *q)
 176:	0f b6 0a             	movzbl (%edx),%ecx
 179:	84 c0                	test   %al,%al
 17b:	74 13                	je     190 <strcmp+0x40>
 17d:	38 c8                	cmp    %cl,%al
 17f:	74 ef                	je     170 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
 181:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
 182:	29 c8                	sub    %ecx,%eax
}
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    
 186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18d:	8d 76 00             	lea    0x0(%esi),%esi
 190:	5b                   	pop    %ebx
 191:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 193:	29 c8                	sub    %ecx,%eax
}
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19e:	66 90                	xchg   %ax,%ax

000001a0 <strlen>:

uint
strlen(const char *s)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1a6:	80 3a 00             	cmpb   $0x0,(%edx)
 1a9:	74 15                	je     1c0 <strlen+0x20>
 1ab:	31 c0                	xor    %eax,%eax
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
 1b0:	40                   	inc    %eax
 1b1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1b5:	89 c1                	mov    %eax,%ecx
 1b7:	75 f7                	jne    1b0 <strlen+0x10>
    ;
  return n;
}
 1b9:	5d                   	pop    %ebp
 1ba:	89 c8                	mov    %ecx,%eax
 1bc:	c3                   	ret    
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
 1c0:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
 1c1:	31 c9                	xor    %ecx,%ecx
}
 1c3:	89 c8                	mov    %ecx,%eax
 1c5:	c3                   	ret    
 1c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cd:	8d 76 00             	lea    0x0(%esi),%esi

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 55 08             	mov    0x8(%ebp),%edx
 1d6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	89 d7                	mov    %edx,%edi
 1df:	fc                   	cld    
 1e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1e2:	5f                   	pop    %edi
 1e3:	89 d0                	mov    %edx,%eax
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fa:	0f b6 10             	movzbl (%eax),%edx
 1fd:	84 d2                	test   %dl,%dl
 1ff:	75 18                	jne    219 <strchr+0x29>
 201:	eb 1d                	jmp    220 <strchr+0x30>
 203:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 210:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 214:	40                   	inc    %eax
 215:	84 d2                	test   %dl,%dl
 217:	74 07                	je     220 <strchr+0x30>
    if(*s == c)
 219:	38 d1                	cmp    %dl,%cl
 21b:	75 f3                	jne    210 <strchr+0x20>
      return (char*)s;
  return 0;
}
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret    
 21f:	90                   	nop
 220:	5d                   	pop    %ebp
  return 0;
 221:	31 c0                	xor    %eax,%eax
}
 223:	c3                   	ret    
 224:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop

00000230 <gets>:

char*
gets(char *buf, int max)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 236:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 238:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 23b:	83 ec 3c             	sub    $0x3c,%esp
 23e:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 241:	eb 3a                	jmp    27d <gets+0x4d>
 243:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 250:	89 7c 24 04          	mov    %edi,0x4(%esp)
 254:	ba 01 00 00 00       	mov    $0x1,%edx
 259:	89 54 24 08          	mov    %edx,0x8(%esp)
 25d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 264:	e8 32 01 00 00       	call   39b <read>
    if(cc < 1)
 269:	85 c0                	test   %eax,%eax
 26b:	7e 19                	jle    286 <gets+0x56>
      break;
    buf[i++] = c;
 26d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 271:	46                   	inc    %esi
 272:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 275:	3c 0a                	cmp    $0xa,%al
 277:	74 27                	je     2a0 <gets+0x70>
 279:	3c 0d                	cmp    $0xd,%al
 27b:	74 23                	je     2a0 <gets+0x70>
  for(i=0; i+1 < max; ){
 27d:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 280:	43                   	inc    %ebx
 281:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 284:	7c ca                	jl     250 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 286:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 289:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	83 c4 3c             	add    $0x3c,%esp
 292:	5b                   	pop    %ebx
 293:	5e                   	pop    %esi
 294:	5f                   	pop    %edi
 295:	5d                   	pop    %ebp
 296:	c3                   	ret    
 297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29e:	66 90                	xchg   %ax,%ax
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	01 c3                	add    %eax,%ebx
 2a5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 2a8:	eb dc                	jmp    286 <gets+0x56>
 2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b0:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b1:	31 c0                	xor    %eax,%eax
{
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 2b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
{
 2bf:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2c2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 2c5:	89 04 24             	mov    %eax,(%esp)
 2c8:	e8 f6 00 00 00       	call   3c3 <open>
  if(fd < 0)
 2cd:	85 c0                	test   %eax,%eax
 2cf:	78 2f                	js     300 <stat+0x50>
 2d1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d6:	89 1c 24             	mov    %ebx,(%esp)
 2d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2dd:	e8 f9 00 00 00       	call   3db <fstat>
  close(fd);
 2e2:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2e5:	89 c6                	mov    %eax,%esi
  close(fd);
 2e7:	e8 bf 00 00 00       	call   3ab <close>
  return r;
}
 2ec:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2ef:	89 f0                	mov    %esi,%eax
 2f1:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2f4:	89 ec                	mov    %ebp,%esp
 2f6:	5d                   	pop    %ebp
 2f7:	c3                   	ret    
 2f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop
    return -1;
 300:	be ff ff ff ff       	mov    $0xffffffff,%esi
 305:	eb e5                	jmp    2ec <stat+0x3c>
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 317:	0f be 02             	movsbl (%edx),%eax
 31a:	88 c1                	mov    %al,%cl
 31c:	80 e9 30             	sub    $0x30,%cl
 31f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 322:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 327:	77 1c                	ja     345 <atoi+0x35>
 329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 330:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 333:	42                   	inc    %edx
 334:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 338:	0f be 02             	movsbl (%edx),%eax
 33b:	88 c3                	mov    %al,%bl
 33d:	80 eb 30             	sub    $0x30,%bl
 340:	80 fb 09             	cmp    $0x9,%bl
 343:	76 eb                	jbe    330 <atoi+0x20>
  return n;
}
 345:	5b                   	pop    %ebx
 346:	89 c8                	mov    %ecx,%eax
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	8b 45 10             	mov    0x10(%ebp),%eax
 357:	56                   	push   %esi
 358:	8b 55 08             	mov    0x8(%ebp),%edx
 35b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35e:	85 c0                	test   %eax,%eax
 360:	7e 13                	jle    375 <memmove+0x25>
 362:	01 d0                	add    %edx,%eax
  dst = vdst;
 364:	89 d7                	mov    %edx,%edi
 366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 370:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 371:	39 f8                	cmp    %edi,%eax
 373:	75 fb                	jne    370 <memmove+0x20>
  return vdst;
}
 375:	5e                   	pop    %esi
 376:	89 d0                	mov    %edx,%eax
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    

0000037b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37b:	b8 01 00 00 00       	mov    $0x1,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <exit>:
SYSCALL(exit)
 383:	b8 02 00 00 00       	mov    $0x2,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <wait>:
SYSCALL(wait)
 38b:	b8 03 00 00 00       	mov    $0x3,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <pipe>:
SYSCALL(pipe)
 393:	b8 04 00 00 00       	mov    $0x4,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <read>:
SYSCALL(read)
 39b:	b8 05 00 00 00       	mov    $0x5,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <write>:
SYSCALL(write)
 3a3:	b8 10 00 00 00       	mov    $0x10,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <close>:
SYSCALL(close)
 3ab:	b8 15 00 00 00       	mov    $0x15,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <kill>:
SYSCALL(kill)
 3b3:	b8 06 00 00 00       	mov    $0x6,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <exec>:
SYSCALL(exec)
 3bb:	b8 07 00 00 00       	mov    $0x7,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <open>:
SYSCALL(open)
 3c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mknod>:
SYSCALL(mknod)
 3cb:	b8 11 00 00 00       	mov    $0x11,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <unlink>:
SYSCALL(unlink)
 3d3:	b8 12 00 00 00       	mov    $0x12,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <fstat>:
SYSCALL(fstat)
 3db:	b8 08 00 00 00       	mov    $0x8,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <link>:
SYSCALL(link)
 3e3:	b8 13 00 00 00       	mov    $0x13,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mkdir>:
SYSCALL(mkdir)
 3eb:	b8 14 00 00 00       	mov    $0x14,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <chdir>:
SYSCALL(chdir)
 3f3:	b8 09 00 00 00       	mov    $0x9,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <dup>:
SYSCALL(dup)
 3fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <getpid>:
SYSCALL(getpid)
 403:	b8 0b 00 00 00       	mov    $0xb,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <sbrk>:
SYSCALL(sbrk)
 40b:	b8 0c 00 00 00       	mov    $0xc,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <sleep>:
SYSCALL(sleep)
 413:	b8 0d 00 00 00       	mov    $0xd,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <uptime>:
SYSCALL(uptime)
 41b:	b8 0e 00 00 00       	mov    $0xe,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <proc_dump>:
 423:	b8 16 00 00 00       	mov    $0x16,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    
 42b:	66 90                	xchg   %ax,%ax
 42d:	66 90                	xchg   %ax,%ax
 42f:	90                   	nop

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	89 cf                	mov    %ecx,%edi
 436:	56                   	push   %esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 437:	89 d1                	mov    %edx,%ecx
{
 439:	53                   	push   %ebx
 43a:	83 ec 4c             	sub    $0x4c,%esp
 43d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 440:	89 d0                	mov    %edx,%eax
 442:	c1 e8 1f             	shr    $0x1f,%eax
 445:	84 c0                	test   %al,%al
 447:	0f 84 a3 00 00 00    	je     4f0 <printint+0xc0>
 44d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 451:	0f 84 99 00 00 00    	je     4f0 <printint+0xc0>
    neg = 1;
 457:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 45e:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 460:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 467:	8d 75 d7             	lea    -0x29(%ebp),%esi
 46a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 46d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 470:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 473:	31 d2                	xor    %edx,%edx
 475:	8b 5d c0             	mov    -0x40(%ebp),%ebx
 478:	f7 f7                	div    %edi
 47a:	8d 4b 01             	lea    0x1(%ebx),%ecx
 47d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 480:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  }while((x /= base) != 0);
 483:	39 cf                	cmp    %ecx,%edi
 485:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    buf[i++] = digits[x % base];
 488:	0f b6 92 a8 08 00 00 	movzbl 0x8a8(%edx),%edx
 48f:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 493:	76 db                	jbe    470 <printint+0x40>
  if(neg)
 495:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 498:	85 c9                	test   %ecx,%ecx
 49a:	74 0c                	je     4a8 <printint+0x78>
    buf[i++] = '-';
 49c:	8b 45 c0             	mov    -0x40(%ebp),%eax
 49f:	b2 2d                	mov    $0x2d,%dl
 4a1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    buf[i++] = digits[x % base];
 4a6:	89 c3                	mov    %eax,%ebx

  while(--i >= 0)
 4a8:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4ab:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 4af:	eb 13                	jmp    4c4 <printint+0x94>
 4b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop
 4c0:	0f b6 13             	movzbl (%ebx),%edx
 4c3:	4b                   	dec    %ebx
  write(fd, &c, 1);
 4c4:	89 74 24 04          	mov    %esi,0x4(%esp)
 4c8:	b8 01 00 00 00       	mov    $0x1,%eax
 4cd:	89 44 24 08          	mov    %eax,0x8(%esp)
 4d1:	89 3c 24             	mov    %edi,(%esp)
 4d4:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4d7:	e8 c7 fe ff ff       	call   3a3 <write>
  while(--i >= 0)
 4dc:	39 de                	cmp    %ebx,%esi
 4de:	75 e0                	jne    4c0 <printint+0x90>
    putc(fd, buf[i]);
}
 4e0:	83 c4 4c             	add    $0x4c,%esp
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret    
 4e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop
  neg = 0;
 4f0:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4f7:	e9 64 ff ff ff       	jmp    460 <printint+0x30>
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 509:	8b 75 0c             	mov    0xc(%ebp),%esi
 50c:	0f b6 1e             	movzbl (%esi),%ebx
 50f:	84 db                	test   %bl,%bl
 511:	0f 84 c8 00 00 00    	je     5df <printf+0xdf>
  ap = (uint*)(void*)&fmt + 1;
 517:	8d 45 10             	lea    0x10(%ebp),%eax
 51a:	46                   	inc    %esi
 51b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  write(fd, &c, 1);
 51e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 521:	31 d2                	xor    %edx,%edx
 523:	eb 3e                	jmp    563 <printf+0x63>
 525:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 530:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 533:	83 f8 25             	cmp    $0x25,%eax
        state = '%';
 536:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 53b:	74 1e                	je     55b <printf+0x5b>
  write(fd, &c, 1);
 53d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 541:	b8 01 00 00 00       	mov    $0x1,%eax
 546:	89 44 24 08          	mov    %eax,0x8(%esp)
 54a:	8b 45 08             	mov    0x8(%ebp),%eax
 54d:	88 5d e7             	mov    %bl,-0x19(%ebp)
 550:	89 04 24             	mov    %eax,(%esp)
 553:	e8 4b fe ff ff       	call   3a3 <write>
 558:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 55b:	0f b6 1e             	movzbl (%esi),%ebx
 55e:	46                   	inc    %esi
 55f:	84 db                	test   %bl,%bl
 561:	74 7c                	je     5df <printf+0xdf>
    if(state == 0){
 563:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 565:	0f be cb             	movsbl %bl,%ecx
 568:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 56b:	74 c3                	je     530 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 56d:	83 fa 25             	cmp    $0x25,%edx
 570:	75 e9                	jne    55b <printf+0x5b>
      if(c == 'd'){
 572:	83 f8 64             	cmp    $0x64,%eax
 575:	0f 84 a5 00 00 00    	je     620 <printf+0x120>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 57b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 581:	83 f9 70             	cmp    $0x70,%ecx
 584:	74 6a                	je     5f0 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 586:	83 f8 73             	cmp    $0x73,%eax
 589:	0f 84 e1 00 00 00    	je     670 <printf+0x170>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58f:	83 f8 63             	cmp    $0x63,%eax
 592:	0f 84 98 00 00 00    	je     630 <printf+0x130>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 598:	83 f8 25             	cmp    $0x25,%eax
 59b:	74 1c                	je     5b9 <printf+0xb9>
  write(fd, &c, 1);
 59d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	ba 01 00 00 00       	mov    $0x1,%edx
 5a9:	89 54 24 08          	mov    %edx,0x8(%esp)
 5ad:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 ea fd ff ff       	call   3a3 <write>
 5b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
 5bd:	b8 01 00 00 00       	mov    $0x1,%eax
 5c2:	46                   	inc    %esi
 5c3:	89 44 24 08          	mov    %eax,0x8(%esp)
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 ce fd ff ff       	call   3a3 <write>
  for(i = 0; fmt[i]; i++){
 5d5:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5db:	84 db                	test   %bl,%bl
 5dd:	75 84                	jne    563 <printf+0x63>
    }
  }
}
 5df:	83 c4 3c             	add    $0x3c,%esp
 5e2:	5b                   	pop    %ebx
 5e3:	5e                   	pop    %esi
 5e4:	5f                   	pop    %edi
 5e5:	5d                   	pop    %ebp
 5e6:	c3                   	ret    
 5e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 5f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5f7:	b9 10 00 00 00       	mov    $0x10,%ecx
 5fc:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
 602:	8b 13                	mov    (%ebx),%edx
 604:	e8 27 fe ff ff       	call   430 <printint>
        ap++;
 609:	89 d8                	mov    %ebx,%eax
      state = 0;
 60b:	31 d2                	xor    %edx,%edx
        ap++;
 60d:	83 c0 04             	add    $0x4,%eax
 610:	89 45 d0             	mov    %eax,-0x30(%ebp)
 613:	e9 43 ff ff ff       	jmp    55b <printf+0x5b>
 618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop
        printint(fd, *ap, 10, 1);
 620:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 627:	b9 0a 00 00 00       	mov    $0xa,%ecx
 62c:	eb ce                	jmp    5fc <printf+0xfc>
 62e:	66 90                	xchg   %ax,%ax
        putc(fd, *ap);
 630:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 633:	b9 01 00 00 00       	mov    $0x1,%ecx
        putc(fd, *ap);
 638:	8b 03                	mov    (%ebx),%eax
        ap++;
 63a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 63d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 641:	89 7c 24 04          	mov    %edi,0x4(%esp)
        putc(fd, *ap);
 645:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 648:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
 64c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 64f:	8b 45 08             	mov    0x8(%ebp),%eax
 652:	89 04 24             	mov    %eax,(%esp)
 655:	e8 49 fd ff ff       	call   3a3 <write>
      state = 0;
 65a:	31 d2                	xor    %edx,%edx
        ap++;
 65c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 65f:	e9 f7 fe ff ff       	jmp    55b <printf+0x5b>
 664:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop
        s = (char*)*ap;
 670:	8b 45 d0             	mov    -0x30(%ebp),%eax
 673:	8b 18                	mov    (%eax),%ebx
        ap++;
 675:	83 c0 04             	add    $0x4,%eax
 678:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 67b:	85 db                	test   %ebx,%ebx
 67d:	74 11                	je     690 <printf+0x190>
        while(*s != 0){
 67f:	0f b6 03             	movzbl (%ebx),%eax
 682:	84 c0                	test   %al,%al
 684:	74 44                	je     6ca <printf+0x1ca>
 686:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 689:	89 de                	mov    %ebx,%esi
 68b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 68e:	eb 10                	jmp    6a0 <printf+0x1a0>
 690:	89 75 d4             	mov    %esi,-0x2c(%ebp)
          s = "(null)";
 693:	bb a0 08 00 00       	mov    $0x8a0,%ebx
        while(*s != 0){
 698:	b0 28                	mov    $0x28,%al
 69a:	89 de                	mov    %ebx,%esi
 69c:	8b 5d 08             	mov    0x8(%ebp),%ebx
 69f:	90                   	nop
          putc(fd, *s);
 6a0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6a3:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 6a8:	46                   	inc    %esi
  write(fd, &c, 1);
 6a9:	89 44 24 08          	mov    %eax,0x8(%esp)
 6ad:	89 7c 24 04          	mov    %edi,0x4(%esp)
 6b1:	89 1c 24             	mov    %ebx,(%esp)
 6b4:	e8 ea fc ff ff       	call   3a3 <write>
        while(*s != 0){
 6b9:	0f b6 06             	movzbl (%esi),%eax
 6bc:	84 c0                	test   %al,%al
 6be:	75 e0                	jne    6a0 <printf+0x1a0>
 6c0:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 6c3:	31 d2                	xor    %edx,%edx
 6c5:	e9 91 fe ff ff       	jmp    55b <printf+0x5b>
 6ca:	31 d2                	xor    %edx,%edx
 6cc:	e9 8a fe ff ff       	jmp    55b <printf+0x5b>
 6d1:	66 90                	xchg   %ax,%ax
 6d3:	66 90                	xchg   %ax,%ax
 6d5:	66 90                	xchg   %ax,%ax
 6d7:	66 90                	xchg   %ax,%ax
 6d9:	66 90                	xchg   %ax,%ax
 6db:	66 90                	xchg   %ax,%ax
 6dd:	66 90                	xchg   %ax,%ax
 6df:	90                   	nop

000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	a1 80 0b 00 00       	mov    0xb80,%eax
{
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	57                   	push   %edi
 6e9:	56                   	push   %esi
 6ea:	53                   	push   %ebx
 6eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6ee:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 6f0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f3:	39 c8                	cmp    %ecx,%eax
 6f5:	73 19                	jae    710 <free+0x30>
 6f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fe:	66 90                	xchg   %ax,%ax
 700:	39 d1                	cmp    %edx,%ecx
 702:	72 14                	jb     718 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	39 d0                	cmp    %edx,%eax
 706:	73 10                	jae    718 <free+0x38>
{
 708:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	39 c8                	cmp    %ecx,%eax
 70c:	8b 10                	mov    (%eax),%edx
 70e:	72 f0                	jb     700 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	39 d0                	cmp    %edx,%eax
 712:	72 f4                	jb     708 <free+0x28>
 714:	39 d1                	cmp    %edx,%ecx
 716:	73 f0                	jae    708 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 718:	8b 73 fc             	mov    -0x4(%ebx),%esi
 71b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 71e:	39 fa                	cmp    %edi,%edx
 720:	74 1e                	je     740 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 722:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 725:	8b 50 04             	mov    0x4(%eax),%edx
 728:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 72b:	39 f1                	cmp    %esi,%ecx
 72d:	74 2a                	je     759 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 72f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 731:	5b                   	pop    %ebx
  freep = p;
 732:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 737:	5e                   	pop    %esi
 738:	5f                   	pop    %edi
 739:	5d                   	pop    %ebp
 73a:	c3                   	ret    
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 740:	8b 7a 04             	mov    0x4(%edx),%edi
 743:	01 fe                	add    %edi,%esi
 745:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 748:	8b 10                	mov    (%eax),%edx
 74a:	8b 12                	mov    (%edx),%edx
 74c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 74f:	8b 50 04             	mov    0x4(%eax),%edx
 752:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 755:	39 f1                	cmp    %esi,%ecx
 757:	75 d6                	jne    72f <free+0x4f>
  freep = p;
 759:	a3 80 0b 00 00       	mov    %eax,0xb80
    p->s.size += bp->s.size;
 75e:	8b 4b fc             	mov    -0x4(%ebx),%ecx
 761:	01 ca                	add    %ecx,%edx
 763:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 766:	8b 53 f8             	mov    -0x8(%ebx),%edx
 769:	89 10                	mov    %edx,(%eax)
}
 76b:	5b                   	pop    %ebx
 76c:	5e                   	pop    %esi
 76d:	5f                   	pop    %edi
 76e:	5d                   	pop    %ebp
 76f:	c3                   	ret    

00000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 779:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 77c:	8b 3d 80 0b 00 00    	mov    0xb80,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	8d 70 07             	lea    0x7(%eax),%esi
 785:	c1 ee 03             	shr    $0x3,%esi
 788:	46                   	inc    %esi
  if((prevp = freep) == 0){
 789:	85 ff                	test   %edi,%edi
 78b:	0f 84 9f 00 00 00    	je     830 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 791:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 793:	8b 48 04             	mov    0x4(%eax),%ecx
 796:	39 f1                	cmp    %esi,%ecx
 798:	73 6c                	jae    806 <malloc+0x96>
 79a:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7a0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7a5:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7a8:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 7af:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 7b2:	eb 1d                	jmp    7d1 <malloc+0x61>
 7b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7bf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 7c2:	8b 4a 04             	mov    0x4(%edx),%ecx
 7c5:	39 f1                	cmp    %esi,%ecx
 7c7:	73 47                	jae    810 <malloc+0xa0>
 7c9:	8b 3d 80 0b 00 00    	mov    0xb80,%edi
 7cf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d1:	39 c7                	cmp    %eax,%edi
 7d3:	75 eb                	jne    7c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 7d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 2b fc ff ff       	call   40b <sbrk>
  if(p == (char*)-1)
 7e0:	83 f8 ff             	cmp    $0xffffffff,%eax
 7e3:	74 17                	je     7fc <malloc+0x8c>
  hp->s.size = nu;
 7e5:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7e8:	83 c0 08             	add    $0x8,%eax
 7eb:	89 04 24             	mov    %eax,(%esp)
 7ee:	e8 ed fe ff ff       	call   6e0 <free>
  return freep;
 7f3:	a1 80 0b 00 00       	mov    0xb80,%eax
      if((p = morecore(nunits)) == 0)
 7f8:	85 c0                	test   %eax,%eax
 7fa:	75 c4                	jne    7c0 <malloc+0x50>
        return 0;
  }
}
 7fc:	83 c4 2c             	add    $0x2c,%esp
        return 0;
 7ff:	31 c0                	xor    %eax,%eax
}
 801:	5b                   	pop    %ebx
 802:	5e                   	pop    %esi
 803:	5f                   	pop    %edi
 804:	5d                   	pop    %ebp
 805:	c3                   	ret    
    if(p->s.size >= nunits){
 806:	89 c2                	mov    %eax,%edx
 808:	89 f8                	mov    %edi,%eax
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 810:	39 ce                	cmp    %ecx,%esi
 812:	74 4c                	je     860 <malloc+0xf0>
        p->s.size -= nunits;
 814:	29 f1                	sub    %esi,%ecx
 816:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 819:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 81c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 81f:	a3 80 0b 00 00       	mov    %eax,0xb80
      return (void*)(p + 1);
 824:	8d 42 08             	lea    0x8(%edx),%eax
}
 827:	83 c4 2c             	add    $0x2c,%esp
 82a:	5b                   	pop    %ebx
 82b:	5e                   	pop    %esi
 82c:	5f                   	pop    %edi
 82d:	5d                   	pop    %ebp
 82e:	c3                   	ret    
 82f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 830:	b8 84 0b 00 00       	mov    $0xb84,%eax
 835:	ba 84 0b 00 00       	mov    $0xb84,%edx
 83a:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 83f:	31 c9                	xor    %ecx,%ecx
 841:	bf 84 0b 00 00       	mov    $0xb84,%edi
    base.s.ptr = freep = prevp = &base;
 846:	89 15 84 0b 00 00    	mov    %edx,0xb84
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84c:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 84e:	89 0d 88 0b 00 00    	mov    %ecx,0xb88
    if(p->s.size >= nunits){
 854:	e9 41 ff ff ff       	jmp    79a <malloc+0x2a>
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 860:	8b 0a                	mov    (%edx),%ecx
 862:	89 08                	mov    %ecx,(%eax)
 864:	eb b9                	jmp    81f <malloc+0xaf>
