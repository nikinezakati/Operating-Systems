
_grep:     file format elf32-i386


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
   9:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;

  if(argc <= 1){
   c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
{
  10:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(argc <= 1){
  13:	7e 78                	jle    8d <main+0x8d>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];

  if(argc <= 2){
  15:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  pattern = argv[1];
  19:	8b 7a 04             	mov    0x4(%edx),%edi
  if(argc <= 2){
  1c:	0f 84 84 00 00 00    	je     a6 <main+0xa6>
  22:	8d 72 08             	lea    0x8(%edx),%esi
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  25:	bb 02 00 00 00       	mov    $0x2,%ebx
  2a:	eb 29                	jmp    55 <main+0x55>
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  30:	89 44 24 04          	mov    %eax,0x4(%esp)
  for(i = 2; i < argc; i++){
  34:	43                   	inc    %ebx
  35:	83 c6 04             	add    $0x4,%esi
    grep(pattern, fd);
  38:	89 3c 24             	mov    %edi,(%esp)
  3b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  3f:	e8 dc 01 00 00       	call   220 <grep>
    close(fd);
  44:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  48:	89 04 24             	mov    %eax,(%esp)
  4b:	e8 8b 05 00 00       	call   5db <close>
  for(i = 2; i < argc; i++){
  50:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  53:	7e 33                	jle    88 <main+0x88>
    if((fd = open(argv[i], 0)) < 0){
  55:	31 c0                	xor    %eax,%eax
  57:	89 44 24 04          	mov    %eax,0x4(%esp)
  5b:	8b 06                	mov    (%esi),%eax
  5d:	89 04 24             	mov    %eax,(%esp)
  60:	e8 8e 05 00 00       	call   5f3 <open>
  65:	85 c0                	test   %eax,%eax
  67:	79 c7                	jns    30 <main+0x30>
      printf(1, "grep: cannot open %s\n", argv[i]);
  69:	8b 06                	mov    (%esi),%eax
  6b:	c7 44 24 04 b8 0a 00 	movl   $0xab8,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  7e:	e8 ad 06 00 00       	call   730 <printf>
      exit();
  83:	e8 2b 05 00 00       	call   5b3 <exit>
  }
  exit();
  88:	e8 26 05 00 00       	call   5b3 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  8d:	c7 44 24 04 98 0a 00 	movl   $0xa98,0x4(%esp)
  94:	00 
  95:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  9c:	e8 8f 06 00 00       	call   730 <printf>
    exit();
  a1:	e8 0d 05 00 00       	call   5b3 <exit>
    grep(pattern, 0);
  a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ad:	00 
  ae:	89 3c 24             	mov    %edi,(%esp)
  b1:	e8 6a 01 00 00       	call   220 <grep>
    exit();
  b6:	e8 f8 04 00 00       	call   5b3 <exit>
  bb:	66 90                	xchg   %ax,%ax
  bd:	66 90                	xchg   %ax,%ax
  bf:	90                   	nop

000000c0 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	56                   	push   %esi
  c5:	53                   	push   %ebx
  c6:	83 ec 1c             	sub    $0x1c,%esp
  c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  e4:	89 34 24             	mov    %esi,(%esp)
  e7:	e8 34 00 00 00       	call   120 <matchhere>
  ec:	85 c0                	test   %eax,%eax
  ee:	75 20                	jne    110 <matchstar+0x50>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  f0:	0f be 17             	movsbl (%edi),%edx
  f3:	84 d2                	test   %dl,%dl
  f5:	74 0a                	je     101 <matchstar+0x41>
  f7:	47                   	inc    %edi
  f8:	39 da                	cmp    %ebx,%edx
  fa:	74 e4                	je     e0 <matchstar+0x20>
  fc:	83 fb 2e             	cmp    $0x2e,%ebx
  ff:	74 df                	je     e0 <matchstar+0x20>
  return 0;
}
 101:	83 c4 1c             	add    $0x1c,%esp
 104:	5b                   	pop    %ebx
 105:	5e                   	pop    %esi
 106:	5f                   	pop    %edi
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 110:	83 c4 1c             	add    $0x1c,%esp
      return 1;
 113:	b8 01 00 00 00       	mov    $0x1,%eax
}
 118:	5b                   	pop    %ebx
 119:	5e                   	pop    %esi
 11a:	5f                   	pop    %edi
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <matchhere>:
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	56                   	push   %esi
 124:	53                   	push   %ebx
 125:	83 ec 10             	sub    $0x10,%esp
 128:	8b 4d 08             	mov    0x8(%ebp),%ecx
 12b:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '\0')
 12e:	0f b6 01             	movzbl (%ecx),%eax
 131:	84 c0                	test   %al,%al
 133:	75 2a                	jne    15f <matchhere+0x3f>
 135:	eb 69                	jmp    1a0 <matchhere+0x80>
 137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13e:	66 90                	xchg   %ax,%ax
  if(re[0] == '$' && re[1] == '\0')
 140:	80 fa 24             	cmp    $0x24,%dl
 143:	0f b6 1e             	movzbl (%esi),%ebx
 146:	75 04                	jne    14c <matchhere+0x2c>
 148:	84 c0                	test   %al,%al
 14a:	74 60                	je     1ac <matchhere+0x8c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 14c:	84 db                	test   %bl,%bl
 14e:	74 40                	je     190 <matchhere+0x70>
 150:	80 fa 2e             	cmp    $0x2e,%dl
 153:	74 04                	je     159 <matchhere+0x39>
 155:	38 d3                	cmp    %dl,%bl
 157:	75 37                	jne    190 <matchhere+0x70>
    return matchhere(re+1, text+1);
 159:	46                   	inc    %esi
 15a:	41                   	inc    %ecx
  if(re[0] == '\0')
 15b:	84 c0                	test   %al,%al
 15d:	74 41                	je     1a0 <matchhere+0x80>
  if(re[1] == '*')
 15f:	0f be d0             	movsbl %al,%edx
 162:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
 166:	3c 2a                	cmp    $0x2a,%al
 168:	75 d6                	jne    140 <matchhere+0x20>
    return matchstar(re[0], re+2, text);
 16a:	89 74 24 08          	mov    %esi,0x8(%esp)
 16e:	83 c1 02             	add    $0x2,%ecx
 171:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 175:	89 14 24             	mov    %edx,(%esp)
 178:	e8 43 ff ff ff       	call   c0 <matchstar>
}
 17d:	83 c4 10             	add    $0x10,%esp
 180:	5b                   	pop    %ebx
 181:	5e                   	pop    %esi
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 18f:	90                   	nop
 190:	83 c4 10             	add    $0x10,%esp
  return 0;
 193:	31 c0                	xor    %eax,%eax
}
 195:	5b                   	pop    %ebx
 196:	5e                   	pop    %esi
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a0:	83 c4 10             	add    $0x10,%esp
    return 1;
 1a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1a8:	5b                   	pop    %ebx
 1a9:	5e                   	pop    %esi
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    
    return *text == '\0';
 1ac:	31 c0                	xor    %eax,%eax
 1ae:	84 db                	test   %bl,%bl
 1b0:	0f 94 c0             	sete   %al
 1b3:	eb c8                	jmp    17d <matchhere+0x5d>
 1b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001c0 <match>:
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
 1c5:	83 ec 10             	sub    $0x10,%esp
 1c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
 1ce:	80 3b 5e             	cmpb   $0x5e,(%ebx)
 1d1:	75 14                	jne    1e7 <match+0x27>
 1d3:	eb 3b                	jmp    210 <match+0x50>
 1d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }while(*text++ != '\0');
 1e0:	46                   	inc    %esi
 1e1:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 1e5:	74 15                	je     1fc <match+0x3c>
    if(matchhere(re, text))
 1e7:	89 74 24 04          	mov    %esi,0x4(%esp)
 1eb:	89 1c 24             	mov    %ebx,(%esp)
 1ee:	e8 2d ff ff ff       	call   120 <matchhere>
 1f3:	85 c0                	test   %eax,%eax
 1f5:	74 e9                	je     1e0 <match+0x20>
      return 1;
 1f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	5b                   	pop    %ebx
 200:	5e                   	pop    %esi
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    
 203:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
 210:	43                   	inc    %ebx
 211:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 214:	83 c4 10             	add    $0x10,%esp
 217:	5b                   	pop    %ebx
 218:	5e                   	pop    %esi
 219:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 21a:	e9 01 ff ff ff       	jmp    120 <matchhere>
 21f:	90                   	nop

00000220 <grep>:
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	53                   	push   %ebx
 226:	83 ec 2c             	sub    $0x2c,%esp
  m = 0;
 229:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
{
 230:	8b 75 08             	mov    0x8(%ebp),%esi
 233:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 240:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 243:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 248:	29 c8                	sub    %ecx,%eax
 24a:	89 44 24 08          	mov    %eax,0x8(%esp)
 24e:	8d 81 80 0e 00 00    	lea    0xe80(%ecx),%eax
 254:	89 44 24 04          	mov    %eax,0x4(%esp)
 258:	8b 45 0c             	mov    0xc(%ebp),%eax
 25b:	89 04 24             	mov    %eax,(%esp)
 25e:	e8 68 03 00 00       	call   5cb <read>
 263:	85 c0                	test   %eax,%eax
 265:	0f 8e d5 00 00 00    	jle    340 <grep+0x120>
    m += n;
 26b:	01 45 e4             	add    %eax,-0x1c(%ebp)
    p = buf;
 26e:	bf 80 0e 00 00       	mov    $0xe80,%edi
    m += n;
 273:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    buf[m] = '\0';
 276:	c6 81 80 0e 00 00 00 	movb   $0x0,0xe80(%ecx)
    while((q = strchr(p, '\n')) != 0){
 27d:	8d 76 00             	lea    0x0(%esi),%esi
 280:	89 3c 24             	mov    %edi,(%esp)
 283:	b8 0a 00 00 00       	mov    $0xa,%eax
 288:	89 44 24 04          	mov    %eax,0x4(%esp)
 28c:	e8 8f 01 00 00       	call   420 <strchr>
 291:	85 c0                	test   %eax,%eax
 293:	89 c3                	mov    %eax,%ebx
 295:	74 59                	je     2f0 <grep+0xd0>
      *q = 0;
 297:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 29a:	89 7c 24 04          	mov    %edi,0x4(%esp)
 29e:	89 34 24             	mov    %esi,(%esp)
 2a1:	e8 1a ff ff ff       	call   1c0 <match>
 2a6:	8d 53 01             	lea    0x1(%ebx),%edx
 2a9:	85 c0                	test   %eax,%eax
 2ab:	75 13                	jne    2c0 <grep+0xa0>
      p = q+1;
 2ad:	89 d7                	mov    %edx,%edi
 2af:	eb cf                	jmp    280 <grep+0x60>
 2b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop
        *q = '\n';
 2c0:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 2c3:	89 d0                	mov    %edx,%eax
 2c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
 2c9:	29 f8                	sub    %edi,%eax
 2cb:	89 44 24 08          	mov    %eax,0x8(%esp)
 2cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2d6:	89 55 e0             	mov    %edx,-0x20(%ebp)
 2d9:	e8 f5 02 00 00       	call   5d3 <write>
 2de:	8b 55 e0             	mov    -0x20(%ebp),%edx
      p = q+1;
 2e1:	89 d7                	mov    %edx,%edi
 2e3:	eb 9b                	jmp    280 <grep+0x60>
 2e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p == buf)
 2f0:	81 ff 80 0e 00 00    	cmp    $0xe80,%edi
 2f6:	74 38                	je     330 <grep+0x110>
    if(m > 0){
 2f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 2fb:	85 c9                	test   %ecx,%ecx
 2fd:	0f 8e 3d ff ff ff    	jle    240 <grep+0x20>
      memmove(buf, p, m);
 303:	89 7c 24 04          	mov    %edi,0x4(%esp)
      m -= p - buf;
 307:	89 f8                	mov    %edi,%eax
      memmove(buf, p, m);
 309:	c7 04 24 80 0e 00 00 	movl   $0xe80,(%esp)
      m -= p - buf;
 310:	2d 80 0e 00 00       	sub    $0xe80,%eax
 315:	29 c1                	sub    %eax,%ecx
      memmove(buf, p, m);
 317:	89 4c 24 08          	mov    %ecx,0x8(%esp)
      m -= p - buf;
 31b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      memmove(buf, p, m);
 31e:	e8 5d 02 00 00       	call   580 <memmove>
 323:	e9 18 ff ff ff       	jmp    240 <grep+0x20>
 328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32f:	90                   	nop
      m = 0;
 330:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 337:	e9 04 ff ff ff       	jmp    240 <grep+0x20>
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
 340:	83 c4 2c             	add    $0x2c,%esp
 343:	5b                   	pop    %ebx
 344:	5e                   	pop    %esi
 345:	5f                   	pop    %edi
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    
 348:	66 90                	xchg   %ax,%ax
 34a:	66 90                	xchg   %ax,%ax
 34c:	66 90                	xchg   %ax,%ax
 34e:	66 90                	xchg   %ax,%ax

00000350 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 350:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 351:	31 c0                	xor    %eax,%eax
{
 353:	89 e5                	mov    %esp,%ebp
 355:	53                   	push   %ebx
 356:	8b 4d 08             	mov    0x8(%ebp),%ecx
 359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 360:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 364:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 367:	40                   	inc    %eax
 368:	84 d2                	test   %dl,%dl
 36a:	75 f4                	jne    360 <strcpy+0x10>
    ;
  return os;
}
 36c:	5b                   	pop    %ebx
 36d:	89 c8                	mov    %ecx,%eax
 36f:	5d                   	pop    %ebp
 370:	c3                   	ret    
 371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37f:	90                   	nop

00000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
 384:	8b 5d 08             	mov    0x8(%ebp),%ebx
 387:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 38a:	0f b6 03             	movzbl (%ebx),%eax
 38d:	0f b6 0a             	movzbl (%edx),%ecx
 390:	84 c0                	test   %al,%al
 392:	75 19                	jne    3ad <strcmp+0x2d>
 394:	eb 2a                	jmp    3c0 <strcmp+0x40>
 396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi
 3a0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    p++, q++;
 3a4:	43                   	inc    %ebx
 3a5:	42                   	inc    %edx
  while(*p && *p == *q)
 3a6:	0f b6 0a             	movzbl (%edx),%ecx
 3a9:	84 c0                	test   %al,%al
 3ab:	74 13                	je     3c0 <strcmp+0x40>
 3ad:	38 c8                	cmp    %cl,%al
 3af:	74 ef                	je     3a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
 3b1:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
 3b2:	29 c8                	sub    %ecx,%eax
}
 3b4:	5d                   	pop    %ebp
 3b5:	c3                   	ret    
 3b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	5b                   	pop    %ebx
 3c1:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3c3:	29 c8                	sub    %ecx,%eax
}
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <strlen>:

uint
strlen(const char *s)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3d6:	80 3a 00             	cmpb   $0x0,(%edx)
 3d9:	74 15                	je     3f0 <strlen+0x20>
 3db:	31 c0                	xor    %eax,%eax
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	40                   	inc    %eax
 3e1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3e5:	89 c1                	mov    %eax,%ecx
 3e7:	75 f7                	jne    3e0 <strlen+0x10>
    ;
  return n;
}
 3e9:	5d                   	pop    %ebp
 3ea:	89 c8                	mov    %ecx,%eax
 3ec:	c3                   	ret    
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
 3f0:	5d                   	pop    %ebp
  for(n = 0; s[n]; n++)
 3f1:	31 c9                	xor    %ecx,%ecx
}
 3f3:	89 c8                	mov    %ecx,%eax
 3f5:	c3                   	ret    
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 55 08             	mov    0x8(%ebp),%edx
 406:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 d7                	mov    %edx,%edi
 40f:	fc                   	cld    
 410:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 412:	5f                   	pop    %edi
 413:	89 d0                	mov    %edx,%eax
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
 417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41e:	66 90                	xchg   %ax,%ax

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 42a:	0f b6 10             	movzbl (%eax),%edx
 42d:	84 d2                	test   %dl,%dl
 42f:	75 18                	jne    449 <strchr+0x29>
 431:	eb 1d                	jmp    450 <strchr+0x30>
 433:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 440:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 444:	40                   	inc    %eax
 445:	84 d2                	test   %dl,%dl
 447:	74 07                	je     450 <strchr+0x30>
    if(*s == c)
 449:	38 d1                	cmp    %dl,%cl
 44b:	75 f3                	jne    440 <strchr+0x20>
      return (char*)s;
  return 0;
}
 44d:	5d                   	pop    %ebp
 44e:	c3                   	ret    
 44f:	90                   	nop
 450:	5d                   	pop    %ebp
  return 0;
 451:	31 c0                	xor    %eax,%eax
}
 453:	c3                   	ret    
 454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 466:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 468:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 46b:	83 ec 3c             	sub    $0x3c,%esp
 46e:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i=0; i+1 < max; ){
 471:	eb 3a                	jmp    4ad <gets+0x4d>
 473:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 480:	89 7c 24 04          	mov    %edi,0x4(%esp)
 484:	ba 01 00 00 00       	mov    $0x1,%edx
 489:	89 54 24 08          	mov    %edx,0x8(%esp)
 48d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 494:	e8 32 01 00 00       	call   5cb <read>
    if(cc < 1)
 499:	85 c0                	test   %eax,%eax
 49b:	7e 19                	jle    4b6 <gets+0x56>
      break;
    buf[i++] = c;
 49d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4a1:	46                   	inc    %esi
 4a2:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n' || c == '\r')
 4a5:	3c 0a                	cmp    $0xa,%al
 4a7:	74 27                	je     4d0 <gets+0x70>
 4a9:	3c 0d                	cmp    $0xd,%al
 4ab:	74 23                	je     4d0 <gets+0x70>
  for(i=0; i+1 < max; ){
 4ad:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4b0:	43                   	inc    %ebx
 4b1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4b4:	7c ca                	jl     480 <gets+0x20>
      break;
  }
  buf[i] = '\0';
 4b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4b9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	83 c4 3c             	add    $0x3c,%esp
 4c2:	5b                   	pop    %ebx
 4c3:	5e                   	pop    %esi
 4c4:	5f                   	pop    %edi
 4c5:	5d                   	pop    %ebp
 4c6:	c3                   	ret    
 4c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ce:	66 90                	xchg   %ax,%ax
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	01 c3                	add    %eax,%ebx
 4d5:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 4d8:	eb dc                	jmp    4b6 <gets+0x56>
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4e0:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e1:	31 c0                	xor    %eax,%eax
{
 4e3:	89 e5                	mov    %esp,%ebp
 4e5:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 4e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
{
 4ef:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 4f2:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 4f5:	89 04 24             	mov    %eax,(%esp)
 4f8:	e8 f6 00 00 00       	call   5f3 <open>
  if(fd < 0)
 4fd:	85 c0                	test   %eax,%eax
 4ff:	78 2f                	js     530 <stat+0x50>
 501:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 503:	8b 45 0c             	mov    0xc(%ebp),%eax
 506:	89 1c 24             	mov    %ebx,(%esp)
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	e8 f9 00 00 00       	call   60b <fstat>
  close(fd);
 512:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 515:	89 c6                	mov    %eax,%esi
  close(fd);
 517:	e8 bf 00 00 00       	call   5db <close>
  return r;
}
 51c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 51f:	89 f0                	mov    %esi,%eax
 521:	8b 75 fc             	mov    -0x4(%ebp),%esi
 524:	89 ec                	mov    %ebp,%esp
 526:	5d                   	pop    %ebp
 527:	c3                   	ret    
 528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52f:	90                   	nop
    return -1;
 530:	be ff ff ff ff       	mov    $0xffffffff,%esi
 535:	eb e5                	jmp    51c <stat+0x3c>
 537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53e:	66 90                	xchg   %ax,%ax

00000540 <atoi>:

int
atoi(const char *s)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	53                   	push   %ebx
 544:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 547:	0f be 02             	movsbl (%edx),%eax
 54a:	88 c1                	mov    %al,%cl
 54c:	80 e9 30             	sub    $0x30,%cl
 54f:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 552:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 557:	77 1c                	ja     575 <atoi+0x35>
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 560:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 563:	42                   	inc    %edx
 564:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 568:	0f be 02             	movsbl (%edx),%eax
 56b:	88 c3                	mov    %al,%bl
 56d:	80 eb 30             	sub    $0x30,%bl
 570:	80 fb 09             	cmp    $0x9,%bl
 573:	76 eb                	jbe    560 <atoi+0x20>
  return n;
}
 575:	5b                   	pop    %ebx
 576:	89 c8                	mov    %ecx,%eax
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000580 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	8b 45 10             	mov    0x10(%ebp),%eax
 587:	56                   	push   %esi
 588:	8b 55 08             	mov    0x8(%ebp),%edx
 58b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 58e:	85 c0                	test   %eax,%eax
 590:	7e 13                	jle    5a5 <memmove+0x25>
 592:	01 d0                	add    %edx,%eax
  dst = vdst;
 594:	89 d7                	mov    %edx,%edi
 596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 5a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5a1:	39 f8                	cmp    %edi,%eax
 5a3:	75 fb                	jne    5a0 <memmove+0x20>
  return vdst;
}
 5a5:	5e                   	pop    %esi
 5a6:	89 d0                	mov    %edx,%eax
 5a8:	5f                   	pop    %edi
 5a9:	5d                   	pop    %ebp
 5aa:	c3                   	ret    

000005ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ab:	b8 01 00 00 00       	mov    $0x1,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <exit>:
SYSCALL(exit)
 5b3:	b8 02 00 00 00       	mov    $0x2,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <wait>:
SYSCALL(wait)
 5bb:	b8 03 00 00 00       	mov    $0x3,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <pipe>:
SYSCALL(pipe)
 5c3:	b8 04 00 00 00       	mov    $0x4,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <read>:
SYSCALL(read)
 5cb:	b8 05 00 00 00       	mov    $0x5,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <write>:
SYSCALL(write)
 5d3:	b8 10 00 00 00       	mov    $0x10,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <close>:
SYSCALL(close)
 5db:	b8 15 00 00 00       	mov    $0x15,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <kill>:
SYSCALL(kill)
 5e3:	b8 06 00 00 00       	mov    $0x6,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <exec>:
SYSCALL(exec)
 5eb:	b8 07 00 00 00       	mov    $0x7,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <open>:
SYSCALL(open)
 5f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <mknod>:
SYSCALL(mknod)
 5fb:	b8 11 00 00 00       	mov    $0x11,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <unlink>:
SYSCALL(unlink)
 603:	b8 12 00 00 00       	mov    $0x12,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <fstat>:
SYSCALL(fstat)
 60b:	b8 08 00 00 00       	mov    $0x8,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <link>:
SYSCALL(link)
 613:	b8 13 00 00 00       	mov    $0x13,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <mkdir>:
SYSCALL(mkdir)
 61b:	b8 14 00 00 00       	mov    $0x14,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <chdir>:
SYSCALL(chdir)
 623:	b8 09 00 00 00       	mov    $0x9,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <dup>:
SYSCALL(dup)
 62b:	b8 0a 00 00 00       	mov    $0xa,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <getpid>:
SYSCALL(getpid)
 633:	b8 0b 00 00 00       	mov    $0xb,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <sbrk>:
SYSCALL(sbrk)
 63b:	b8 0c 00 00 00       	mov    $0xc,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <sleep>:
SYSCALL(sleep)
 643:	b8 0d 00 00 00       	mov    $0xd,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <uptime>:
SYSCALL(uptime)
 64b:	b8 0e 00 00 00       	mov    $0xe,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <proc_dump>:
 653:	b8 16 00 00 00       	mov    $0x16,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    
 65b:	66 90                	xchg   %ax,%ax
 65d:	66 90                	xchg   %ax,%ax
 65f:	90                   	nop

00000660 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	89 cf                	mov    %ecx,%edi
 666:	56                   	push   %esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 667:	89 d1                	mov    %edx,%ecx
{
 669:	53                   	push   %ebx
 66a:	83 ec 4c             	sub    $0x4c,%esp
 66d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 670:	89 d0                	mov    %edx,%eax
 672:	c1 e8 1f             	shr    $0x1f,%eax
 675:	84 c0                	test   %al,%al
 677:	0f 84 a3 00 00 00    	je     720 <printint+0xc0>
 67d:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 681:	0f 84 99 00 00 00    	je     720 <printint+0xc0>
    neg = 1;
 687:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 68e:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 690:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 697:	8d 75 d7             	lea    -0x29(%ebp),%esi
 69a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 69d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6a3:	31 d2                	xor    %edx,%edx
 6a5:	8b 5d c0             	mov    -0x40(%ebp),%ebx
 6a8:	f7 f7                	div    %edi
 6aa:	8d 4b 01             	lea    0x1(%ebx),%ecx
 6ad:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 6b0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  }while((x /= base) != 0);
 6b3:	39 cf                	cmp    %ecx,%edi
 6b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    buf[i++] = digits[x % base];
 6b8:	0f b6 92 d8 0a 00 00 	movzbl 0xad8(%edx),%edx
 6bf:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 6c3:	76 db                	jbe    6a0 <printint+0x40>
  if(neg)
 6c5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 6c8:	85 c9                	test   %ecx,%ecx
 6ca:	74 0c                	je     6d8 <printint+0x78>
    buf[i++] = '-';
 6cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
 6cf:	b2 2d                	mov    $0x2d,%dl
 6d1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    buf[i++] = digits[x % base];
 6d6:	89 c3                	mov    %eax,%ebx

  while(--i >= 0)
 6d8:	8b 7d b8             	mov    -0x48(%ebp),%edi
 6db:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 6df:	eb 13                	jmp    6f4 <printint+0x94>
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ef:	90                   	nop
 6f0:	0f b6 13             	movzbl (%ebx),%edx
 6f3:	4b                   	dec    %ebx
  write(fd, &c, 1);
 6f4:	89 74 24 04          	mov    %esi,0x4(%esp)
 6f8:	b8 01 00 00 00       	mov    $0x1,%eax
 6fd:	89 44 24 08          	mov    %eax,0x8(%esp)
 701:	89 3c 24             	mov    %edi,(%esp)
 704:	88 55 d7             	mov    %dl,-0x29(%ebp)
 707:	e8 c7 fe ff ff       	call   5d3 <write>
  while(--i >= 0)
 70c:	39 de                	cmp    %ebx,%esi
 70e:	75 e0                	jne    6f0 <printint+0x90>
    putc(fd, buf[i]);
}
 710:	83 c4 4c             	add    $0x4c,%esp
 713:	5b                   	pop    %ebx
 714:	5e                   	pop    %esi
 715:	5f                   	pop    %edi
 716:	5d                   	pop    %ebp
 717:	c3                   	ret    
 718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
  neg = 0;
 720:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 727:	e9 64 ff ff ff       	jmp    690 <printint+0x30>
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 739:	8b 75 0c             	mov    0xc(%ebp),%esi
 73c:	0f b6 1e             	movzbl (%esi),%ebx
 73f:	84 db                	test   %bl,%bl
 741:	0f 84 c8 00 00 00    	je     80f <printf+0xdf>
  ap = (uint*)(void*)&fmt + 1;
 747:	8d 45 10             	lea    0x10(%ebp),%eax
 74a:	46                   	inc    %esi
 74b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  write(fd, &c, 1);
 74e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 751:	31 d2                	xor    %edx,%edx
 753:	eb 3e                	jmp    793 <printf+0x63>
 755:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 760:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 763:	83 f8 25             	cmp    $0x25,%eax
        state = '%';
 766:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 76b:	74 1e                	je     78b <printf+0x5b>
  write(fd, &c, 1);
 76d:	89 7c 24 04          	mov    %edi,0x4(%esp)
 771:	b8 01 00 00 00       	mov    $0x1,%eax
 776:	89 44 24 08          	mov    %eax,0x8(%esp)
 77a:	8b 45 08             	mov    0x8(%ebp),%eax
 77d:	88 5d e7             	mov    %bl,-0x19(%ebp)
 780:	89 04 24             	mov    %eax,(%esp)
 783:	e8 4b fe ff ff       	call   5d3 <write>
 788:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(i = 0; fmt[i]; i++){
 78b:	0f b6 1e             	movzbl (%esi),%ebx
 78e:	46                   	inc    %esi
 78f:	84 db                	test   %bl,%bl
 791:	74 7c                	je     80f <printf+0xdf>
    if(state == 0){
 793:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 795:	0f be cb             	movsbl %bl,%ecx
 798:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 79b:	74 c3                	je     760 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 79d:	83 fa 25             	cmp    $0x25,%edx
 7a0:	75 e9                	jne    78b <printf+0x5b>
      if(c == 'd'){
 7a2:	83 f8 64             	cmp    $0x64,%eax
 7a5:	0f 84 a5 00 00 00    	je     850 <printf+0x120>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7ab:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7b1:	83 f9 70             	cmp    $0x70,%ecx
 7b4:	74 6a                	je     820 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7b6:	83 f8 73             	cmp    $0x73,%eax
 7b9:	0f 84 e1 00 00 00    	je     8a0 <printf+0x170>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7bf:	83 f8 63             	cmp    $0x63,%eax
 7c2:	0f 84 98 00 00 00    	je     860 <printf+0x130>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7c8:	83 f8 25             	cmp    $0x25,%eax
 7cb:	74 1c                	je     7e9 <printf+0xb9>
  write(fd, &c, 1);
 7cd:	89 7c 24 04          	mov    %edi,0x4(%esp)
 7d1:	8b 45 08             	mov    0x8(%ebp),%eax
 7d4:	ba 01 00 00 00       	mov    $0x1,%edx
 7d9:	89 54 24 08          	mov    %edx,0x8(%esp)
 7dd:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7e1:	89 04 24             	mov    %eax,(%esp)
 7e4:	e8 ea fd ff ff       	call   5d3 <write>
 7e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
 7ed:	b8 01 00 00 00       	mov    $0x1,%eax
 7f2:	46                   	inc    %esi
 7f3:	89 44 24 08          	mov    %eax,0x8(%esp)
 7f7:	8b 45 08             	mov    0x8(%ebp),%eax
 7fa:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7fd:	89 04 24             	mov    %eax,(%esp)
 800:	e8 ce fd ff ff       	call   5d3 <write>
  for(i = 0; fmt[i]; i++){
 805:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 809:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 80b:	84 db                	test   %bl,%bl
 80d:	75 84                	jne    793 <printf+0x63>
    }
  }
}
 80f:	83 c4 3c             	add    $0x3c,%esp
 812:	5b                   	pop    %ebx
 813:	5e                   	pop    %esi
 814:	5f                   	pop    %edi
 815:	5d                   	pop    %ebp
 816:	c3                   	ret    
 817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 81e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 820:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 827:	b9 10 00 00 00       	mov    $0x10,%ecx
 82c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 82f:	8b 45 08             	mov    0x8(%ebp),%eax
 832:	8b 13                	mov    (%ebx),%edx
 834:	e8 27 fe ff ff       	call   660 <printint>
        ap++;
 839:	89 d8                	mov    %ebx,%eax
      state = 0;
 83b:	31 d2                	xor    %edx,%edx
        ap++;
 83d:	83 c0 04             	add    $0x4,%eax
 840:	89 45 d0             	mov    %eax,-0x30(%ebp)
 843:	e9 43 ff ff ff       	jmp    78b <printf+0x5b>
 848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 84f:	90                   	nop
        printint(fd, *ap, 10, 1);
 850:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 857:	b9 0a 00 00 00       	mov    $0xa,%ecx
 85c:	eb ce                	jmp    82c <printf+0xfc>
 85e:	66 90                	xchg   %ax,%ax
        putc(fd, *ap);
 860:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 863:	b9 01 00 00 00       	mov    $0x1,%ecx
        putc(fd, *ap);
 868:	8b 03                	mov    (%ebx),%eax
        ap++;
 86a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 86d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 871:	89 7c 24 04          	mov    %edi,0x4(%esp)
        putc(fd, *ap);
 875:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 878:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
 87c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	89 04 24             	mov    %eax,(%esp)
 885:	e8 49 fd ff ff       	call   5d3 <write>
      state = 0;
 88a:	31 d2                	xor    %edx,%edx
        ap++;
 88c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 88f:	e9 f7 fe ff ff       	jmp    78b <printf+0x5b>
 894:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 89b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 89f:	90                   	nop
        s = (char*)*ap;
 8a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8a3:	8b 18                	mov    (%eax),%ebx
        ap++;
 8a5:	83 c0 04             	add    $0x4,%eax
 8a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 8ab:	85 db                	test   %ebx,%ebx
 8ad:	74 11                	je     8c0 <printf+0x190>
        while(*s != 0){
 8af:	0f b6 03             	movzbl (%ebx),%eax
 8b2:	84 c0                	test   %al,%al
 8b4:	74 44                	je     8fa <printf+0x1ca>
 8b6:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8b9:	89 de                	mov    %ebx,%esi
 8bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8be:	eb 10                	jmp    8d0 <printf+0x1a0>
 8c0:	89 75 d4             	mov    %esi,-0x2c(%ebp)
          s = "(null)";
 8c3:	bb ce 0a 00 00       	mov    $0xace,%ebx
        while(*s != 0){
 8c8:	b0 28                	mov    $0x28,%al
 8ca:	89 de                	mov    %ebx,%esi
 8cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8cf:	90                   	nop
          putc(fd, *s);
 8d0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8d3:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 8d8:	46                   	inc    %esi
  write(fd, &c, 1);
 8d9:	89 44 24 08          	mov    %eax,0x8(%esp)
 8dd:	89 7c 24 04          	mov    %edi,0x4(%esp)
 8e1:	89 1c 24             	mov    %ebx,(%esp)
 8e4:	e8 ea fc ff ff       	call   5d3 <write>
        while(*s != 0){
 8e9:	0f b6 06             	movzbl (%esi),%eax
 8ec:	84 c0                	test   %al,%al
 8ee:	75 e0                	jne    8d0 <printf+0x1a0>
 8f0:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 8f3:	31 d2                	xor    %edx,%edx
 8f5:	e9 91 fe ff ff       	jmp    78b <printf+0x5b>
 8fa:	31 d2                	xor    %edx,%edx
 8fc:	e9 8a fe ff ff       	jmp    78b <printf+0x5b>
 901:	66 90                	xchg   %ax,%ax
 903:	66 90                	xchg   %ax,%ax
 905:	66 90                	xchg   %ax,%ax
 907:	66 90                	xchg   %ax,%ax
 909:	66 90                	xchg   %ax,%ax
 90b:	66 90                	xchg   %ax,%ax
 90d:	66 90                	xchg   %ax,%ax
 90f:	90                   	nop

00000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 911:	a1 60 0e 00 00       	mov    0xe60,%eax
{
 916:	89 e5                	mov    %esp,%ebp
 918:	57                   	push   %edi
 919:	56                   	push   %esi
 91a:	53                   	push   %ebx
 91b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 91e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 920:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 923:	39 c8                	cmp    %ecx,%eax
 925:	73 19                	jae    940 <free+0x30>
 927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 92e:	66 90                	xchg   %ax,%ax
 930:	39 d1                	cmp    %edx,%ecx
 932:	72 14                	jb     948 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 934:	39 d0                	cmp    %edx,%eax
 936:	73 10                	jae    948 <free+0x38>
{
 938:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93a:	39 c8                	cmp    %ecx,%eax
 93c:	8b 10                	mov    (%eax),%edx
 93e:	72 f0                	jb     930 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 940:	39 d0                	cmp    %edx,%eax
 942:	72 f4                	jb     938 <free+0x28>
 944:	39 d1                	cmp    %edx,%ecx
 946:	73 f0                	jae    938 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 948:	8b 73 fc             	mov    -0x4(%ebx),%esi
 94b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 94e:	39 fa                	cmp    %edi,%edx
 950:	74 1e                	je     970 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 952:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 955:	8b 50 04             	mov    0x4(%eax),%edx
 958:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 95b:	39 f1                	cmp    %esi,%ecx
 95d:	74 2a                	je     989 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 95f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 961:	5b                   	pop    %ebx
  freep = p;
 962:	a3 60 0e 00 00       	mov    %eax,0xe60
}
 967:	5e                   	pop    %esi
 968:	5f                   	pop    %edi
 969:	5d                   	pop    %ebp
 96a:	c3                   	ret    
 96b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 96f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 970:	8b 7a 04             	mov    0x4(%edx),%edi
 973:	01 fe                	add    %edi,%esi
 975:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 978:	8b 10                	mov    (%eax),%edx
 97a:	8b 12                	mov    (%edx),%edx
 97c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 97f:	8b 50 04             	mov    0x4(%eax),%edx
 982:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 985:	39 f1                	cmp    %esi,%ecx
 987:	75 d6                	jne    95f <free+0x4f>
  freep = p;
 989:	a3 60 0e 00 00       	mov    %eax,0xe60
    p->s.size += bp->s.size;
 98e:	8b 4b fc             	mov    -0x4(%ebx),%ecx
 991:	01 ca                	add    %ecx,%edx
 993:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 996:	8b 53 f8             	mov    -0x8(%ebx),%edx
 999:	89 10                	mov    %edx,(%eax)
}
 99b:	5b                   	pop    %ebx
 99c:	5e                   	pop    %esi
 99d:	5f                   	pop    %edi
 99e:	5d                   	pop    %ebp
 99f:	c3                   	ret    

000009a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	57                   	push   %edi
 9a4:	56                   	push   %esi
 9a5:	53                   	push   %ebx
 9a6:	83 ec 2c             	sub    $0x2c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9ac:	8b 3d 60 0e 00 00    	mov    0xe60,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b2:	8d 70 07             	lea    0x7(%eax),%esi
 9b5:	c1 ee 03             	shr    $0x3,%esi
 9b8:	46                   	inc    %esi
  if((prevp = freep) == 0){
 9b9:	85 ff                	test   %edi,%edi
 9bb:	0f 84 9f 00 00 00    	je     a60 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c1:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 9c3:	8b 48 04             	mov    0x4(%eax),%ecx
 9c6:	39 f1                	cmp    %esi,%ecx
 9c8:	73 6c                	jae    a36 <malloc+0x96>
 9ca:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9d0:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9d5:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 9d8:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 9df:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 9e2:	eb 1d                	jmp    a01 <malloc+0x61>
 9e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9ef:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 9f2:	8b 4a 04             	mov    0x4(%edx),%ecx
 9f5:	39 f1                	cmp    %esi,%ecx
 9f7:	73 47                	jae    a40 <malloc+0xa0>
 9f9:	8b 3d 60 0e 00 00    	mov    0xe60,%edi
 9ff:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a01:	39 c7                	cmp    %eax,%edi
 a03:	75 eb                	jne    9f0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a08:	89 04 24             	mov    %eax,(%esp)
 a0b:	e8 2b fc ff ff       	call   63b <sbrk>
  if(p == (char*)-1)
 a10:	83 f8 ff             	cmp    $0xffffffff,%eax
 a13:	74 17                	je     a2c <malloc+0x8c>
  hp->s.size = nu;
 a15:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a18:	83 c0 08             	add    $0x8,%eax
 a1b:	89 04 24             	mov    %eax,(%esp)
 a1e:	e8 ed fe ff ff       	call   910 <free>
  return freep;
 a23:	a1 60 0e 00 00       	mov    0xe60,%eax
      if((p = morecore(nunits)) == 0)
 a28:	85 c0                	test   %eax,%eax
 a2a:	75 c4                	jne    9f0 <malloc+0x50>
        return 0;
  }
}
 a2c:	83 c4 2c             	add    $0x2c,%esp
        return 0;
 a2f:	31 c0                	xor    %eax,%eax
}
 a31:	5b                   	pop    %ebx
 a32:	5e                   	pop    %esi
 a33:	5f                   	pop    %edi
 a34:	5d                   	pop    %ebp
 a35:	c3                   	ret    
    if(p->s.size >= nunits){
 a36:	89 c2                	mov    %eax,%edx
 a38:	89 f8                	mov    %edi,%eax
 a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a40:	39 ce                	cmp    %ecx,%esi
 a42:	74 4c                	je     a90 <malloc+0xf0>
        p->s.size -= nunits;
 a44:	29 f1                	sub    %esi,%ecx
 a46:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 a49:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 a4c:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 a4f:	a3 60 0e 00 00       	mov    %eax,0xe60
      return (void*)(p + 1);
 a54:	8d 42 08             	lea    0x8(%edx),%eax
}
 a57:	83 c4 2c             	add    $0x2c,%esp
 a5a:	5b                   	pop    %ebx
 a5b:	5e                   	pop    %esi
 a5c:	5f                   	pop    %edi
 a5d:	5d                   	pop    %ebp
 a5e:	c3                   	ret    
 a5f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 a60:	b8 64 0e 00 00       	mov    $0xe64,%eax
 a65:	ba 64 0e 00 00       	mov    $0xe64,%edx
 a6a:	a3 60 0e 00 00       	mov    %eax,0xe60
    base.s.size = 0;
 a6f:	31 c9                	xor    %ecx,%ecx
 a71:	bf 64 0e 00 00       	mov    $0xe64,%edi
    base.s.ptr = freep = prevp = &base;
 a76:	89 15 64 0e 00 00    	mov    %edx,0xe64
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7c:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 a7e:	89 0d 68 0e 00 00    	mov    %ecx,0xe68
    if(p->s.size >= nunits){
 a84:	e9 41 ff ff ff       	jmp    9ca <malloc+0x2a>
 a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 a90:	8b 0a                	mov    (%edx),%ecx
 a92:	89 08                	mov    %ecx,(%eax)
 a94:	eb b9                	jmp    a4f <malloc+0xaf>
