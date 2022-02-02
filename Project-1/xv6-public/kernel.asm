
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 30 10 80       	mov    $0x801030e0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80100041:	ba 60 72 10 80       	mov    $0x80107260,%edx
{
80100046:	89 e5                	mov    %esp,%ebp
80100048:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100049:	bb bc fc 10 80       	mov    $0x8010fcbc,%ebx
{
8010004e:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
80100051:	89 54 24 04          	mov    %edx,0x4(%esp)
80100055:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005c:	e8 bf 44 00 00       	call   80104520 <initlock>
  bcache.head.prev = &bcache.head;
80100061:	b9 bc fc 10 80       	mov    $0x8010fcbc,%ecx
  bcache.head.next = &bcache.head;
80100066:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
8010006b:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100071:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  bcache.head.prev = &bcache.head;
80100076:	89 0d 0c fd 10 80    	mov    %ecx,0x8010fd0c
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007c:	eb 04                	jmp    80100082 <binit+0x42>
8010007e:	66 90                	xchg   %ax,%ax
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	b8 67 72 10 80       	mov    $0x80107267,%eax
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 44 24 04          	mov    %eax,0x4(%esp)
80100095:	8d 43 0c             	lea    0xc(%ebx),%eax
80100098:	89 04 24             	mov    %eax,(%esp)
8010009b:	e8 40 43 00 00       	call   801043e0 <initsleeplock>
    bcache.head.next->prev = b;
801000a0:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a5:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000ab:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
    bcache.head.next->prev = b;
801000b1:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000b4:	89 d8                	mov    %ebx,%eax
801000b6:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	83 c4 14             	add    $0x14,%esp
801000c1:	5b                   	pop    %ebx
801000c2:	5d                   	pop    %ebp
801000c3:	c3                   	ret    
801000c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000cf:	90                   	nop

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&bcache.lock);
801000d9:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e0:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e6:	e8 a5 45 00 00       	call   80104690 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000ff:	90                   	nop
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	ff 43 4c             	incl   0x4c(%ebx)
      release(&bcache.lock);
80100118:	eb 40                	jmp    8010015a <bread+0x8a>
8010011a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 da 45 00 00       	call   80104740 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 af 42 00 00       	call   80104420 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	74 0a                	je     80100180 <bread+0xb0>
    iderw(b);
  }
  return b;
}
80100176:	83 c4 1c             	add    $0x1c,%esp
80100179:	89 d8                	mov    %ebx,%eax
8010017b:	5b                   	pop    %ebx
8010017c:	5e                   	pop    %esi
8010017d:	5f                   	pop    %edi
8010017e:	5d                   	pop    %ebp
8010017f:	c3                   	ret    
    iderw(b);
80100180:	89 1c 24             	mov    %ebx,(%esp)
80100183:	e8 18 22 00 00       	call   801023a0 <iderw>
}
80100188:	83 c4 1c             	add    $0x1c,%esp
8010018b:	89 d8                	mov    %ebx,%eax
8010018d:	5b                   	pop    %ebx
8010018e:	5e                   	pop    %esi
8010018f:	5f                   	pop    %edi
80100190:	5d                   	pop    %ebp
80100191:	c3                   	ret    
80100192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  panic("bget: no buffers");
801001a0:	c7 04 24 6e 72 10 80 	movl   $0x8010726e,(%esp)
801001a7:	e8 b4 01 00 00       	call   80100360 <panic>
801001ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 14             	sub    $0x14,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	89 04 24             	mov    %eax,(%esp)
801001c0:	e8 fb 42 00 00       	call   801044c0 <holdingsleep>
801001c5:	85 c0                	test   %eax,%eax
801001c7:	74 10                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001c9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001cf:	83 c4 14             	add    $0x14,%esp
801001d2:	5b                   	pop    %ebx
801001d3:	5d                   	pop    %ebp
  iderw(b);
801001d4:	e9 c7 21 00 00       	jmp    801023a0 <iderw>
    panic("bwrite");
801001d9:	c7 04 24 7f 72 10 80 	movl   $0x8010727f,(%esp)
801001e0:	e8 7b 01 00 00       	call   80100360 <panic>
801001e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	83 ec 10             	sub    $0x10,%esp
801001f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fe:	89 34 24             	mov    %esi,(%esp)
80100201:	e8 ba 42 00 00       	call   801044c0 <holdingsleep>
80100206:	85 c0                	test   %eax,%eax
80100208:	74 5a                	je     80100264 <brelse+0x74>
    panic("brelse");

  releasesleep(&b->lock);
8010020a:	89 34 24             	mov    %esi,(%esp)
8010020d:	e8 6e 42 00 00       	call   80104480 <releasesleep>

  acquire(&bcache.lock);
80100212:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100219:	e8 72 44 00 00       	call   80104690 <acquire>
  b->refcnt--;
8010021e:	ff 4b 4c             	decl   0x4c(%ebx)
  if (b->refcnt == 0) {
80100221:	75 2f                	jne    80100252 <brelse+0x62>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100223:	8b 43 54             	mov    0x54(%ebx),%eax
80100226:	8b 53 50             	mov    0x50(%ebx),%edx
80100229:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022c:	8b 43 50             	mov    0x50(%ebx),%eax
8010022f:	8b 53 54             	mov    0x54(%ebx),%edx
80100232:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010023a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100241:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100244:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100249:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024c:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100252:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100259:	83 c4 10             	add    $0x10,%esp
8010025c:	5b                   	pop    %ebx
8010025d:	5e                   	pop    %esi
8010025e:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025f:	e9 dc 44 00 00       	jmp    80104740 <release>
    panic("brelse");
80100264:	c7 04 24 86 72 10 80 	movl   $0x80107286,(%esp)
8010026b:	e8 f0 00 00 00       	call   80100360 <panic>

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 2c             	sub    $0x2c,%esp
80100279:	8b 75 08             	mov    0x8(%ebp),%esi
8010027c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 34 24             	mov    %esi,(%esp)
80100282:	e8 59 16 00 00       	call   801018e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
  target = n;
8010028e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100291:	e8 fa 43 00 00       	call   80104690 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100296:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100299:	01 df                	add    %ebx,%edi
  while(n > 0){
8010029b:	85 db                	test   %ebx,%ebx
8010029d:	7f 32                	jg     801002d1 <consoleread+0x61>
8010029f:	eb 64                	jmp    80100305 <consoleread+0x95>
801002a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801002a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801002af:	90                   	nop
      if(myproc()->killed){
801002b0:	e8 4b 37 00 00       	call   80103a00 <myproc>
801002b5:	8b 50 24             	mov    0x24(%eax),%edx
801002b8:	85 d2                	test   %edx,%edx
801002ba:	75 74                	jne    80100330 <consoleread+0xc0>
      sleep(&input.r, &cons.lock);
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	b8 20 a5 10 80       	mov    $0x8010a520,%eax
801002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801002cc:	e8 bf 3c 00 00       	call   80103f90 <sleep>
    while(input.r == input.w){
801002d1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002d6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
    c = input.buf[input.r++ % INPUT_BUF];
801002de:	8d 50 01             	lea    0x1(%eax),%edx
801002e1:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002e7:	89 c2                	mov    %eax,%edx
801002e9:	83 e2 7f             	and    $0x7f,%edx
801002ec:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
801002f3:	80 f9 04             	cmp    $0x4,%cl
801002f6:	74 59                	je     80100351 <consoleread+0xe1>
    *dst++ = c;
801002f8:	89 d8                	mov    %ebx,%eax
    --n;
801002fa:	4b                   	dec    %ebx
    *dst++ = c;
801002fb:	f7 d8                	neg    %eax
    if(c == '\n')
801002fd:	83 f9 0a             	cmp    $0xa,%ecx
    *dst++ = c;
80100300:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100303:	75 96                	jne    8010029b <consoleread+0x2b>
      break;
  }
  release(&cons.lock);
80100305:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030c:	e8 2f 44 00 00       	call   80104740 <release>
  ilock(ip);
80100311:	89 34 24             	mov    %esi,(%esp)
80100314:	e8 e7 14 00 00       	call   80101800 <ilock>

  return target - n;
80100319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
8010031c:	83 c4 2c             	add    $0x2c,%esp
  return target - n;
8010031f:	29 d8                	sub    %ebx,%eax
}
80100321:	5b                   	pop    %ebx
80100322:	5e                   	pop    %esi
80100323:	5f                   	pop    %edi
80100324:	5d                   	pop    %ebp
80100325:	c3                   	ret    
80100326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010032d:	8d 76 00             	lea    0x0(%esi),%esi
        release(&cons.lock);
80100330:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100337:	e8 04 44 00 00       	call   80104740 <release>
        ilock(ip);
8010033c:	89 34 24             	mov    %esi,(%esp)
8010033f:	e8 bc 14 00 00       	call   80101800 <ilock>
}
80100344:	83 c4 2c             	add    $0x2c,%esp
        return -1;
80100347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010034c:	5b                   	pop    %ebx
8010034d:	5e                   	pop    %esi
8010034e:	5f                   	pop    %edi
8010034f:	5d                   	pop    %ebp
80100350:	c3                   	ret    
      if(n < target){
80100351:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100354:	73 af                	jae    80100305 <consoleread+0x95>
        input.r--;
80100356:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010035b:	eb a8                	jmp    80100305 <consoleread+0x95>
8010035d:	8d 76 00             	lea    0x0(%esi),%esi

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  getcallerpcs(&s, pcs);
80100369:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cons.locking = 0;
8010036c:	31 d2                	xor    %edx,%edx
8010036e:	89 15 54 a5 10 80    	mov    %edx,0x8010a554
  cprintf("lapicid %d: panic: ", lapicid());
80100374:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100377:	e8 44 26 00 00       	call   801029c0 <lapicid>
8010037c:	c7 04 24 8d 72 10 80 	movl   $0x8010728d,(%esp)
80100383:	89 44 24 04          	mov    %eax,0x4(%esp)
80100387:	e8 f4 02 00 00       	call   80100680 <cprintf>
  cprintf(s);
8010038c:	8b 45 08             	mov    0x8(%ebp),%eax
8010038f:	89 04 24             	mov    %eax,(%esp)
80100392:	e8 e9 02 00 00       	call   80100680 <cprintf>
  cprintf("\n");
80100397:	c7 04 24 bb 7b 10 80 	movl   $0x80107bbb,(%esp)
8010039e:	e8 dd 02 00 00       	call   80100680 <cprintf>
  getcallerpcs(&s, pcs);
801003a3:	8d 45 08             	lea    0x8(%ebp),%eax
801003a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003aa:	89 04 24             	mov    %eax,(%esp)
801003ad:	e8 8e 41 00 00       	call   80104540 <getcallerpcs>
    cprintf(" %p", pcs[i]);
801003b2:	8b 03                	mov    (%ebx),%eax
801003b4:	83 c3 04             	add    $0x4,%ebx
801003b7:	c7 04 24 a1 72 10 80 	movl   $0x801072a1,(%esp)
801003be:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c2:	e8 b9 02 00 00       	call   80100680 <cprintf>
  for(i=0; i<10; i++)
801003c7:	39 f3                	cmp    %esi,%ebx
801003c9:	75 e7                	jne    801003b2 <panic+0x52>
  panicked = 1; // freeze other CPU
801003cb:	b8 01 00 00 00       	mov    $0x1,%eax
801003d0:	a3 58 a5 10 80       	mov    %eax,0x8010a558
  for(;;)
801003d5:	eb fe                	jmp    801003d5 <panic+0x75>
801003d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003de:	66 90                	xchg   %ax,%ax

801003e0 <consputc.part.0>:
consputc(int c)
801003e0:	55                   	push   %ebp
801003e1:	89 e5                	mov    %esp,%ebp
801003e3:	57                   	push   %edi
801003e4:	56                   	push   %esi
801003e5:	53                   	push   %ebx
801003e6:	89 c3                	mov    %eax,%ebx
801003e8:	83 ec 2c             	sub    $0x2c,%esp
  if(c == BACKSPACE){
801003eb:	3d 00 01 00 00       	cmp    $0x100,%eax
801003f0:	0f 84 ea 00 00 00    	je     801004e0 <consputc.part.0+0x100>
    uartputc(c);
801003f6:	89 04 24             	mov    %eax,(%esp)
801003f9:	e8 12 5a 00 00       	call   80105e10 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003fe:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100403:	b0 0e                	mov    $0xe,%al
80100405:	89 fa                	mov    %edi,%edx
80100407:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100408:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010040d:	89 ca                	mov    %ecx,%edx
8010040f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100410:	0f b6 f0             	movzbl %al,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100413:	89 fa                	mov    %edi,%edx
80100415:	c1 e6 08             	shl    $0x8,%esi
80100418:	b0 0f                	mov    $0xf,%al
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	89 ca                	mov    %ecx,%edx
8010041d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010041e:	0f b6 c8             	movzbl %al,%ecx
80100421:	09 f1                	or     %esi,%ecx
  if(c == '\n')
80100423:	83 fb 0a             	cmp    $0xa,%ebx
80100426:	0f 84 94 00 00 00    	je     801004c0 <consputc.part.0+0xe0>
  else if(c == BACKSPACE){
8010042c:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100432:	74 6c                	je     801004a0 <consputc.part.0+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100434:	8d 51 01             	lea    0x1(%ecx),%edx
80100437:	0f b6 db             	movzbl %bl,%ebx
8010043a:	81 cb 00 07 00 00    	or     $0x700,%ebx
80100440:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
80100447:	80 
  if(pos < 0 || pos > 25*80)
80100448:	81 fa d0 07 00 00    	cmp    $0x7d0,%edx
8010044e:	0f 8f 0f 01 00 00    	jg     80100563 <consputc.part.0+0x183>
  if((pos/80) >= 24){  // Scroll up.
80100454:	81 fa 7f 07 00 00    	cmp    $0x77f,%edx
8010045a:	0f 8f b0 00 00 00    	jg     80100510 <consputc.part.0+0x130>
80100460:	88 55 e4             	mov    %dl,-0x1c(%ebp)
80100463:	8d bc 12 00 80 0b 80 	lea    -0x7ff48000(%edx,%edx,1),%edi
8010046a:	0f b6 ce             	movzbl %dh,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010046d:	be d4 03 00 00       	mov    $0x3d4,%esi
80100472:	b0 0e                	mov    $0xe,%al
80100474:	89 f2                	mov    %esi,%edx
80100476:	ee                   	out    %al,(%dx)
80100477:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010047c:	88 c8                	mov    %cl,%al
8010047e:	89 da                	mov    %ebx,%edx
80100480:	ee                   	out    %al,(%dx)
80100481:	b0 0f                	mov    $0xf,%al
80100483:	89 f2                	mov    %esi,%edx
80100485:	ee                   	out    %al,(%dx)
80100486:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
8010048a:	89 da                	mov    %ebx,%edx
8010048c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010048d:	66 c7 07 20 07       	movw   $0x720,(%edi)
}
80100492:	83 c4 2c             	add    $0x2c,%esp
80100495:	5b                   	pop    %ebx
80100496:	5e                   	pop    %esi
80100497:	5f                   	pop    %edi
80100498:	5d                   	pop    %ebp
80100499:	c3                   	ret    
8010049a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pos > 0) --pos;
801004a0:	8d 51 ff             	lea    -0x1(%ecx),%edx
801004a3:	85 c9                	test   %ecx,%ecx
801004a5:	75 a1                	jne    80100448 <consputc.part.0+0x68>
801004a7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004ab:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
801004b0:	31 c9                	xor    %ecx,%ecx
801004b2:	eb b9                	jmp    8010046d <consputc.part.0+0x8d>
801004b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004bf:	90                   	nop
    pos += 80 - pos%80;
801004c0:	89 c8                	mov    %ecx,%eax
801004c2:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004c7:	f7 e2                	mul    %edx
801004c9:	c1 ea 06             	shr    $0x6,%edx
801004cc:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004cf:	c1 e0 04             	shl    $0x4,%eax
801004d2:	8d 50 50             	lea    0x50(%eax),%edx
801004d5:	e9 6e ff ff ff       	jmp    80100448 <consputc.part.0+0x68>
801004da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004e7:	e8 24 59 00 00       	call   80105e10 <uartputc>
801004ec:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f3:	e8 18 59 00 00       	call   80105e10 <uartputc>
801004f8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004ff:	e8 0c 59 00 00       	call   80105e10 <uartputc>
80100504:	e9 f5 fe ff ff       	jmp    801003fe <consputc.part.0+0x1e>
80100509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100510:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100513:	b8 60 0e 00 00       	mov    $0xe60,%eax
80100518:	ba a0 80 0b 80       	mov    $0x800b80a0,%edx
8010051d:	89 54 24 04          	mov    %edx,0x4(%esp)
80100521:	89 44 24 08          	mov    %eax,0x8(%esp)
80100525:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
8010052c:	e8 1f 43 00 00       	call   80104850 <memmove>
    pos -= 80;
80100531:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100534:	b8 80 07 00 00       	mov    $0x780,%eax
80100539:	31 c9                	xor    %ecx,%ecx
8010053b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    pos -= 80;
8010053f:	8d 5a b0             	lea    -0x50(%edx),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100542:	8d bc 12 60 7f 0b 80 	lea    -0x7ff480a0(%edx,%edx,1),%edi
80100549:	29 d8                	sub    %ebx,%eax
8010054b:	89 3c 24             	mov    %edi,(%esp)
8010054e:	01 c0                	add    %eax,%eax
80100550:	89 44 24 08          	mov    %eax,0x8(%esp)
80100554:	e8 37 42 00 00       	call   80104790 <memset>
80100559:	b1 07                	mov    $0x7,%cl
8010055b:	88 5d e4             	mov    %bl,-0x1c(%ebp)
8010055e:	e9 0a ff ff ff       	jmp    8010046d <consputc.part.0+0x8d>
    panic("pos under/overflow");
80100563:	c7 04 24 a5 72 10 80 	movl   $0x801072a5,(%esp)
8010056a:	e8 f1 fd ff ff       	call   80100360 <panic>
8010056f:	90                   	nop

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	53                   	push   %ebx
80100576:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
80100579:	85 c9                	test   %ecx,%ecx
{
8010057b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010057e:	74 04                	je     80100584 <printint+0x14>
80100580:	85 c0                	test   %eax,%eax
80100582:	78 6e                	js     801005f2 <printint+0x82>
    x = xx;
80100584:	89 c1                	mov    %eax,%ecx
80100586:	31 ff                	xor    %edi,%edi
  i = 0;
80100588:	89 7d cc             	mov    %edi,-0x34(%ebp)
8010058b:	8d 75 d7             	lea    -0x29(%ebp),%esi
8010058e:	31 db                	xor    %ebx,%ebx
    buf[i++] = digits[x % base];
80100590:	89 c8                	mov    %ecx,%eax
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 75 d4             	divl   -0x2c(%ebp)
80100597:	89 cf                	mov    %ecx,%edi
80100599:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010059c:	0f b6 92 d0 72 10 80 	movzbl -0x7fef8d30(%edx),%edx
801005a3:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);
801005a5:	8b 4d d0             	mov    -0x30(%ebp),%ecx
    buf[i++] = digits[x % base];
801005a8:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005ab:	89 7d d0             	mov    %edi,-0x30(%ebp)
801005ae:	8b 7d d4             	mov    -0x2c(%ebp),%edi
801005b1:	39 7d d0             	cmp    %edi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005b4:	88 54 06 01          	mov    %dl,0x1(%esi,%eax,1)
  }while((x /= base) != 0);
801005b8:	73 d6                	jae    80100590 <printint+0x20>
801005ba:	8b 7d cc             	mov    -0x34(%ebp),%edi
  if(sign)
801005bd:	85 ff                	test   %edi,%edi
801005bf:	74 09                	je     801005ca <printint+0x5a>
    buf[i++] = '-';
801005c1:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005c6:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005c8:	b2 2d                	mov    $0x2d,%dl
  while(--i >= 0)
801005ca:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
  if(panicked){
801005ce:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801005d3:	85 c0                	test   %eax,%eax
801005d5:	74 09                	je     801005e0 <printint+0x70>
  asm volatile("cli");
801005d7:	fa                   	cli    
    for(;;)
801005d8:	eb fe                	jmp    801005d8 <printint+0x68>
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005e0:	0f be c2             	movsbl %dl,%eax
801005e3:	e8 f8 fd ff ff       	call   801003e0 <consputc.part.0>
  while(--i >= 0)
801005e8:	39 f3                	cmp    %esi,%ebx
801005ea:	74 0e                	je     801005fa <printint+0x8a>
801005ec:	0f b6 13             	movzbl (%ebx),%edx
801005ef:	4b                   	dec    %ebx
801005f0:	eb dc                	jmp    801005ce <printint+0x5e>
    x = -xx;
801005f2:	f7 d8                	neg    %eax
801005f4:	89 cf                	mov    %ecx,%edi
801005f6:	89 c1                	mov    %eax,%ecx
801005f8:	eb 8e                	jmp    80100588 <printint+0x18>
}
801005fa:	83 c4 2c             	add    $0x2c,%esp
801005fd:	5b                   	pop    %ebx
801005fe:	5e                   	pop    %esi
801005ff:	5f                   	pop    %edi
80100600:	5d                   	pop    %ebp
80100601:	c3                   	ret    
80100602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100610 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100610:	55                   	push   %ebp
80100611:	89 e5                	mov    %esp,%ebp
80100613:	57                   	push   %edi
80100614:	56                   	push   %esi
80100615:	53                   	push   %ebx
80100616:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
80100619:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010061c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
8010061f:	89 04 24             	mov    %eax,(%esp)
80100622:	e8 b9 12 00 00       	call   801018e0 <iunlock>
  acquire(&cons.lock);
80100627:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010062e:	e8 5d 40 00 00       	call   80104690 <acquire>
  for(i = 0; i < n; i++)
80100633:	85 db                	test   %ebx,%ebx
80100635:	7e 26                	jle    8010065d <consolewrite+0x4d>
80100637:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010063a:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
8010063d:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100642:	85 c0                	test   %eax,%eax
80100644:	74 0a                	je     80100650 <consolewrite+0x40>
80100646:	fa                   	cli    
    for(;;)
80100647:	eb fe                	jmp    80100647 <consolewrite+0x37>
80100649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i] & 0xff);
80100650:	0f b6 07             	movzbl (%edi),%eax
80100653:	47                   	inc    %edi
80100654:	e8 87 fd ff ff       	call   801003e0 <consputc.part.0>
  for(i = 0; i < n; i++)
80100659:	39 fe                	cmp    %edi,%esi
8010065b:	75 e0                	jne    8010063d <consolewrite+0x2d>
  release(&cons.lock);
8010065d:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100664:	e8 d7 40 00 00       	call   80104740 <release>
  ilock(ip);
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	89 04 24             	mov    %eax,(%esp)
8010066f:	e8 8c 11 00 00       	call   80101800 <ilock>

  return n;
}
80100674:	83 c4 1c             	add    $0x1c,%esp
80100677:	89 d8                	mov    %ebx,%eax
80100679:	5b                   	pop    %ebx
8010067a:	5e                   	pop    %esi
8010067b:	5f                   	pop    %edi
8010067c:	5d                   	pop    %ebp
8010067d:	c3                   	ret    
8010067e:	66 90                	xchg   %ax,%ax

80100680 <cprintf>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 2c             	sub    $0x2c,%esp
  locking = cons.locking;
80100689:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010068e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100691:	85 c0                	test   %eax,%eax
80100693:	0f 85 f4 00 00 00    	jne    8010078d <cprintf+0x10d>
  if (fmt == 0)
80100699:	8b 75 08             	mov    0x8(%ebp),%esi
8010069c:	85 f6                	test   %esi,%esi
8010069e:	0f 84 6d 01 00 00    	je     80100811 <cprintf+0x191>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a4:	0f b6 06             	movzbl (%esi),%eax
801006a7:	85 c0                	test   %eax,%eax
801006a9:	74 3d                	je     801006e8 <cprintf+0x68>
801006ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  argp = (uint*)(void*)(&fmt + 1);
801006b2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
    if(c != '%'){
801006b5:	83 f8 25             	cmp    $0x25,%eax
801006b8:	74 46                	je     80100700 <cprintf+0x80>
  if(panicked){
801006ba:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006c0:	85 c9                	test   %ecx,%ecx
801006c2:	74 11                	je     801006d5 <cprintf+0x55>
801006c4:	fa                   	cli    
    for(;;)
801006c5:	eb fe                	jmp    801006c5 <cprintf+0x45>
801006c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006ce:	66 90                	xchg   %ax,%ax
801006d0:	b8 25 00 00 00       	mov    $0x25,%eax
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	ff 45 e4             	incl   -0x1c(%ebp)
801006dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006e0:	0f b6 04 06          	movzbl (%esi,%eax,1),%eax
801006e4:	85 c0                	test   %eax,%eax
801006e6:	75 cd                	jne    801006b5 <cprintf+0x35>
  if(locking)
801006e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006eb:	85 c0                	test   %eax,%eax
801006ed:	0f 85 0d 01 00 00    	jne    80100800 <cprintf+0x180>
}
801006f3:	83 c4 2c             	add    $0x2c,%esp
801006f6:	5b                   	pop    %ebx
801006f7:	5e                   	pop    %esi
801006f8:	5f                   	pop    %edi
801006f9:	5d                   	pop    %ebp
801006fa:	c3                   	ret    
801006fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006ff:	90                   	nop
    c = fmt[++i] & 0xff;
80100700:	ff 45 e4             	incl   -0x1c(%ebp)
80100703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100706:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
    if(c == 0)
8010070a:	85 ff                	test   %edi,%edi
8010070c:	74 da                	je     801006e8 <cprintf+0x68>
    switch(c){
8010070e:	83 ff 70             	cmp    $0x70,%edi
80100711:	74 62                	je     80100775 <cprintf+0xf5>
80100713:	7f 2a                	jg     8010073f <cprintf+0xbf>
80100715:	83 ff 25             	cmp    $0x25,%edi
80100718:	0f 84 94 00 00 00    	je     801007b2 <cprintf+0x132>
8010071e:	83 ff 64             	cmp    $0x64,%edi
80100721:	0f 85 a9 00 00 00    	jne    801007d0 <cprintf+0x150>
      printint(*argp++, 10, 1);
80100727:	8b 03                	mov    (%ebx),%eax
80100729:	8d 7b 04             	lea    0x4(%ebx),%edi
8010072c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100731:	ba 0a 00 00 00       	mov    $0xa,%edx
80100736:	89 fb                	mov    %edi,%ebx
80100738:	e8 33 fe ff ff       	call   80100570 <printint>
      break;
8010073d:	eb 9b                	jmp    801006da <cprintf+0x5a>
    switch(c){
8010073f:	83 ff 73             	cmp    $0x73,%edi
80100742:	75 2c                	jne    80100770 <cprintf+0xf0>
      if((s = (char*)*argp++) == 0)
80100744:	8d 7b 04             	lea    0x4(%ebx),%edi
80100747:	8b 1b                	mov    (%ebx),%ebx
80100749:	85 db                	test   %ebx,%ebx
8010074b:	75 57                	jne    801007a4 <cprintf+0x124>
        s = "(null)";
8010074d:	bb b8 72 10 80       	mov    $0x801072b8,%ebx
      for(; *s; s++)
80100752:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100757:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010075d:	85 d2                	test   %edx,%edx
8010075f:	74 3d                	je     8010079e <cprintf+0x11e>
80100761:	fa                   	cli    
    for(;;)
80100762:	eb fe                	jmp    80100762 <cprintf+0xe2>
80100764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010076b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010076f:	90                   	nop
    switch(c){
80100770:	83 ff 78             	cmp    $0x78,%edi
80100773:	75 5b                	jne    801007d0 <cprintf+0x150>
      printint(*argp++, 16, 0);
80100775:	8b 03                	mov    (%ebx),%eax
80100777:	8d 7b 04             	lea    0x4(%ebx),%edi
8010077a:	31 c9                	xor    %ecx,%ecx
8010077c:	ba 10 00 00 00       	mov    $0x10,%edx
80100781:	89 fb                	mov    %edi,%ebx
80100783:	e8 e8 fd ff ff       	call   80100570 <printint>
      break;
80100788:	e9 4d ff ff ff       	jmp    801006da <cprintf+0x5a>
    acquire(&cons.lock);
8010078d:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100794:	e8 f7 3e 00 00       	call   80104690 <acquire>
80100799:	e9 fb fe ff ff       	jmp    80100699 <cprintf+0x19>
8010079e:	e8 3d fc ff ff       	call   801003e0 <consputc.part.0>
      for(; *s; s++)
801007a3:	43                   	inc    %ebx
801007a4:	0f be 03             	movsbl (%ebx),%eax
801007a7:	84 c0                	test   %al,%al
801007a9:	75 ac                	jne    80100757 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007ab:	89 fb                	mov    %edi,%ebx
801007ad:	e9 28 ff ff ff       	jmp    801006da <cprintf+0x5a>
  if(panicked){
801007b2:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007b8:	85 ff                	test   %edi,%edi
801007ba:	0f 84 10 ff ff ff    	je     801006d0 <cprintf+0x50>
801007c0:	fa                   	cli    
    for(;;)
801007c1:	eb fe                	jmp    801007c1 <cprintf+0x141>
801007c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(panicked){
801007d0:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007d6:	85 c9                	test   %ecx,%ecx
801007d8:	74 06                	je     801007e0 <cprintf+0x160>
801007da:	fa                   	cli    
    for(;;)
801007db:	eb fe                	jmp    801007db <cprintf+0x15b>
801007dd:	8d 76 00             	lea    0x0(%esi),%esi
801007e0:	b8 25 00 00 00       	mov    $0x25,%eax
801007e5:	e8 f6 fb ff ff       	call   801003e0 <consputc.part.0>
  if(panicked){
801007ea:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801007f0:	85 d2                	test   %edx,%edx
801007f2:	74 2c                	je     80100820 <cprintf+0x1a0>
801007f4:	fa                   	cli    
    for(;;)
801007f5:	eb fe                	jmp    801007f5 <cprintf+0x175>
801007f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007fe:	66 90                	xchg   %ax,%ax
    release(&cons.lock);
80100800:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100807:	e8 34 3f 00 00       	call   80104740 <release>
}
8010080c:	e9 e2 fe ff ff       	jmp    801006f3 <cprintf+0x73>
    panic("null fmt");
80100811:	c7 04 24 bf 72 10 80 	movl   $0x801072bf,(%esp)
80100818:	e8 43 fb ff ff       	call   80100360 <panic>
8010081d:	8d 76 00             	lea    0x0(%esi),%esi
80100820:	89 f8                	mov    %edi,%eax
80100822:	e8 b9 fb ff ff       	call   801003e0 <consputc.part.0>
80100827:	e9 ae fe ff ff       	jmp    801006da <cprintf+0x5a>
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100830 <consoleintr>:
{
80100830:	55                   	push   %ebp
80100831:	89 e5                	mov    %esp,%ebp
80100833:	57                   	push   %edi
80100834:	56                   	push   %esi
  int c, doprocdump = 0;
80100835:	31 f6                	xor    %esi,%esi
{
80100837:	53                   	push   %ebx
80100838:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&cons.lock);
8010083b:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
{
80100842:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100845:	e8 46 3e 00 00       	call   80104690 <acquire>
  while((c = getc()) >= 0){
8010084a:	eb 17                	jmp    80100863 <consoleintr+0x33>
    switch(c){
8010084c:	83 fb 08             	cmp    $0x8,%ebx
8010084f:	0f 84 fb 00 00 00    	je     80100950 <consoleintr+0x120>
80100855:	83 fb 10             	cmp    $0x10,%ebx
80100858:	0f 85 22 01 00 00    	jne    80100980 <consoleintr+0x150>
8010085e:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100863:	ff d7                	call   *%edi
80100865:	85 c0                	test   %eax,%eax
80100867:	89 c3                	mov    %eax,%ebx
80100869:	0f 88 40 01 00 00    	js     801009af <consoleintr+0x17f>
    switch(c){
8010086f:	83 fb 15             	cmp    $0x15,%ebx
80100872:	74 7c                	je     801008f0 <consoleintr+0xc0>
80100874:	7e d6                	jle    8010084c <consoleintr+0x1c>
80100876:	83 fb 7f             	cmp    $0x7f,%ebx
80100879:	0f 84 d1 00 00 00    	je     80100950 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010087f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100884:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
8010088a:	89 c2                	mov    %eax,%edx
8010088c:	29 ca                	sub    %ecx,%edx
8010088e:	83 fa 7f             	cmp    $0x7f,%edx
80100891:	77 d0                	ja     80100863 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
80100893:	8d 48 01             	lea    0x1(%eax),%ecx
80100896:	83 e0 7f             	and    $0x7f,%eax
80100899:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008a5:	83 fb 0d             	cmp    $0xd,%ebx
801008a8:	0f 84 19 01 00 00    	je     801009c7 <consoleintr+0x197>
        input.buf[input.e++ % INPUT_BUF] = c;
801008ae:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008b4:	85 d2                	test   %edx,%edx
801008b6:	0f 85 16 01 00 00    	jne    801009d2 <consoleintr+0x1a2>
801008bc:	89 d8                	mov    %ebx,%eax
801008be:	e8 1d fb ff ff       	call   801003e0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 fb 0a             	cmp    $0xa,%ebx
801008c6:	0f 84 2a 01 00 00    	je     801009f6 <consoleintr+0x1c6>
801008cc:	83 fb 04             	cmp    $0x4,%ebx
801008cf:	0f 84 21 01 00 00    	je     801009f6 <consoleintr+0x1c6>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 7a ff ff ff    	jne    80100863 <consoleintr+0x33>
801008e9:	e9 0d 01 00 00       	jmp    801009fb <consoleintr+0x1cb>
801008ee:	66 90                	xchg   %ax,%ax
      while(input.e != input.w &&
801008f0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008f5:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008fb:	0f 84 62 ff ff ff    	je     80100863 <consoleintr+0x33>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100901:	48                   	dec    %eax
80100902:	89 c2                	mov    %eax,%edx
80100904:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100907:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010090e:	0f 84 4f ff ff ff    	je     80100863 <consoleintr+0x33>
        input.e--;
80100914:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100919:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010091e:	85 c0                	test   %eax,%eax
80100920:	74 0e                	je     80100930 <consoleintr+0x100>
80100922:	fa                   	cli    
    for(;;)
80100923:	eb fe                	jmp    80100923 <consoleintr+0xf3>
80100925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010092c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100930:	b8 00 01 00 00       	mov    $0x100,%eax
80100935:	e8 a6 fa ff ff       	call   801003e0 <consputc.part.0>
      while(input.e != input.w &&
8010093a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100945:	75 ba                	jne    80100901 <consoleintr+0xd1>
80100947:	e9 17 ff ff ff       	jmp    80100863 <consoleintr+0x33>
8010094c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100950:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100955:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010095b:	0f 84 02 ff ff ff    	je     80100863 <consoleintr+0x33>
  if(panicked){
80100961:	8b 1d 58 a5 10 80    	mov    0x8010a558,%ebx
        input.e--;
80100967:	48                   	dec    %eax
80100968:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010096d:	85 db                	test   %ebx,%ebx
8010096f:	74 2f                	je     801009a0 <consoleintr+0x170>
80100971:	fa                   	cli    
    for(;;)
80100972:	eb fe                	jmp    80100972 <consoleintr+0x142>
80100974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100980:	85 db                	test   %ebx,%ebx
80100982:	0f 84 db fe ff ff    	je     80100863 <consoleintr+0x33>
80100988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010098f:	90                   	nop
80100990:	e9 ea fe ff ff       	jmp    8010087f <consoleintr+0x4f>
80100995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009a0:	b8 00 01 00 00       	mov    $0x100,%eax
801009a5:	e8 36 fa ff ff       	call   801003e0 <consputc.part.0>
801009aa:	e9 b4 fe ff ff       	jmp    80100863 <consoleintr+0x33>
  release(&cons.lock);
801009af:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801009b6:	e8 85 3d 00 00       	call   80104740 <release>
  if(doprocdump) {
801009bb:	85 f6                	test   %esi,%esi
801009bd:	75 21                	jne    801009e0 <consoleintr+0x1b0>
}
801009bf:	83 c4 1c             	add    $0x1c,%esp
801009c2:	5b                   	pop    %ebx
801009c3:	5e                   	pop    %esi
801009c4:	5f                   	pop    %edi
801009c5:	5d                   	pop    %ebp
801009c6:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009c7:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ce:	85 d2                	test   %edx,%edx
801009d0:	74 1a                	je     801009ec <consoleintr+0x1bc>
801009d2:	fa                   	cli    
    for(;;)
801009d3:	eb fe                	jmp    801009d3 <consoleintr+0x1a3>
801009d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801009e0:	83 c4 1c             	add    $0x1c,%esp
801009e3:	5b                   	pop    %ebx
801009e4:	5e                   	pop    %esi
801009e5:	5f                   	pop    %edi
801009e6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009e7:	e9 54 38 00 00       	jmp    80104240 <procdump>
801009ec:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f1:	e8 ea f9 ff ff       	call   801003e0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009f6:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
801009fb:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
80100a02:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a07:	e8 54 37 00 00       	call   80104160 <wakeup>
80100a0c:	e9 52 fe ff ff       	jmp    80100863 <consoleintr+0x33>
80100a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a1f:	90                   	nop

80100a20 <consoleinit>:

void
consoleinit(void)
{
80100a20:	55                   	push   %ebp
  initlock(&cons.lock, "console");
80100a21:	b8 c8 72 10 80       	mov    $0x801072c8,%eax
{
80100a26:	89 e5                	mov    %esp,%ebp
80100a28:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a2f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100a36:	e8 e5 3a 00 00       	call   80104520 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
80100a3b:	b8 01 00 00 00       	mov    $0x1,%eax
  devsw[CONSOLE].write = consolewrite;
80100a40:	ba 10 06 10 80       	mov    $0x80100610,%edx
  cons.locking = 1;
80100a45:	a3 54 a5 10 80       	mov    %eax,0x8010a554

  ioapicenable(IRQ_KBD, 0);
80100a4a:	31 c0                	xor    %eax,%eax
  devsw[CONSOLE].read = consoleread;
80100a4c:	b9 70 02 10 80       	mov    $0x80100270,%ecx
  ioapicenable(IRQ_KBD, 0);
80100a51:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100a5c:	89 15 6c 09 11 80    	mov    %edx,0x8011096c
  devsw[CONSOLE].read = consoleread;
80100a62:	89 0d 68 09 11 80    	mov    %ecx,0x80110968
  ioapicenable(IRQ_KBD, 0);
80100a68:	e8 d3 1a 00 00       	call   80102540 <ioapicenable>
}
80100a6d:	c9                   	leave  
80100a6e:	c3                   	ret    
80100a6f:	90                   	nop

80100a70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	57                   	push   %edi
80100a74:	56                   	push   %esi
80100a75:	53                   	push   %ebx
80100a76:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a7c:	e8 7f 2f 00 00       	call   80103a00 <myproc>
80100a81:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a87:	e8 84 23 00 00       	call   80102e10 <begin_op>

  if((ip = namei(path)) == 0){
80100a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80100a8f:	89 04 24             	mov    %eax,(%esp)
80100a92:	e8 d9 16 00 00       	call   80102170 <namei>
80100a97:	85 c0                	test   %eax,%eax
80100a99:	0f 84 39 03 00 00    	je     80100dd8 <exec+0x368>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a9f:	89 04 24             	mov    %eax,(%esp)
80100aa2:	89 c3                	mov    %eax,%ebx
80100aa4:	e8 57 0d 00 00       	call   80101800 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aa9:	b8 34 00 00 00       	mov    $0x34,%eax
80100aae:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100ab2:	31 c0                	xor    %eax,%eax
80100ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ab8:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100abe:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac2:	89 1c 24             	mov    %ebx,(%esp)
80100ac5:	e8 26 10 00 00       	call   80101af0 <readi>
80100aca:	83 f8 34             	cmp    $0x34,%eax
80100acd:	74 21                	je     80100af0 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100acf:	89 1c 24             	mov    %ebx,(%esp)
80100ad2:	e8 c9 0f 00 00       	call   80101aa0 <iunlockput>
    end_op();
80100ad7:	e8 a4 23 00 00       	call   80102e80 <end_op>
  }
  return -1;
80100adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ae1:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100ae7:	5b                   	pop    %ebx
80100ae8:	5e                   	pop    %esi
80100ae9:	5f                   	pop    %edi
80100aea:	5d                   	pop    %ebp
80100aeb:	c3                   	ret    
80100aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100af7:	45 4c 46 
80100afa:	75 d3                	jne    80100acf <exec+0x5f>
  if((pgdir = setupkvm()) == 0)
80100afc:	e8 8f 64 00 00       	call   80106f90 <setupkvm>
80100b01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b07:	85 c0                	test   %eax,%eax
80100b09:	74 c4                	je     80100acf <exec+0x5f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b0b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b12:	00 
80100b13:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b19:	0f 84 d4 02 00 00    	je     80100df3 <exec+0x383>
  sz = 0;
80100b1f:	31 c0                	xor    %eax,%eax
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b21:	31 ff                	xor    %edi,%edi
  sz = 0;
80100b23:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b29:	e9 99 00 00 00       	jmp    80100bc7 <exec+0x157>
80100b2e:	66 90                	xchg   %ax,%ax
    if(ph.type != ELF_PROG_LOAD)
80100b30:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b37:	75 7f                	jne    80100bb8 <exec+0x148>
    if(ph.memsz < ph.filesz)
80100b39:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b3f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b45:	0f 82 a4 00 00 00    	jb     80100bef <exec+0x17f>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b4b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b51:	0f 82 98 00 00 00    	jb     80100bef <exec+0x17f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b57:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b5b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b61:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b65:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b6b:	89 04 24             	mov    %eax,(%esp)
80100b6e:	e8 2d 62 00 00       	call   80106da0 <allocuvm>
80100b73:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b79:	85 c0                	test   %eax,%eax
80100b7b:	74 72                	je     80100bef <exec+0x17f>
    if(ph.vaddr % PGSIZE != 0)
80100b7d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b83:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b88:	75 65                	jne    80100bef <exec+0x17f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8e:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100b94:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b98:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b9e:	89 54 24 10          	mov    %edx,0x10(%esp)
80100ba2:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100ba8:	89 04 24             	mov    %eax,(%esp)
80100bab:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100baf:	e8 1c 61 00 00       	call   80106cd0 <loaduvm>
80100bb4:	85 c0                	test   %eax,%eax
80100bb6:	78 37                	js     80100bef <exec+0x17f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbf:	47                   	inc    %edi
80100bc0:	83 c6 20             	add    $0x20,%esi
80100bc3:	39 f8                	cmp    %edi,%eax
80100bc5:	7e 49                	jle    80100c10 <exec+0x1a0>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc7:	89 74 24 08          	mov    %esi,0x8(%esp)
80100bcb:	b8 20 00 00 00       	mov    $0x20,%eax
80100bd0:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bd4:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bda:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bde:	89 1c 24             	mov    %ebx,(%esp)
80100be1:	e8 0a 0f 00 00       	call   80101af0 <readi>
80100be6:	83 f8 20             	cmp    $0x20,%eax
80100be9:	0f 84 41 ff ff ff    	je     80100b30 <exec+0xc0>
    freevm(pgdir);
80100bef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bf5:	89 04 24             	mov    %eax,(%esp)
80100bf8:	e8 13 63 00 00       	call   80106f10 <freevm>
  if(ip){
80100bfd:	e9 cd fe ff ff       	jmp    80100acf <exec+0x5f>
80100c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c10:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c16:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c1c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c22:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c28:	89 1c 24             	mov    %ebx,(%esp)
80100c2b:	e8 70 0e 00 00       	call   80101aa0 <iunlockput>
  end_op();
80100c30:	e8 4b 22 00 00       	call   80102e80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c35:	89 7c 24 04          	mov    %edi,0x4(%esp)
80100c39:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c3f:	89 74 24 08          	mov    %esi,0x8(%esp)
80100c43:	89 3c 24             	mov    %edi,(%esp)
80100c46:	e8 55 61 00 00       	call   80106da0 <allocuvm>
80100c4b:	85 c0                	test   %eax,%eax
80100c4d:	89 c6                	mov    %eax,%esi
80100c4f:	0f 84 9b 00 00 00    	je     80100cf0 <exec+0x280>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c55:	89 3c 24             	mov    %edi,(%esp)
80100c58:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c5e:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  for(argc = 0; argv[argc]; argc++) {
80100c64:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c66:	e8 d5 63 00 00       	call   80107040 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c74:	8b 00                	mov    (%eax),%eax
80100c76:	85 c0                	test   %eax,%eax
80100c78:	0f 84 90 00 00 00    	je     80100d0e <exec+0x29e>
80100c7e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c84:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c8a:	eb 21                	jmp    80100cad <exec+0x23d>
80100c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ustack[3+argc] = sp;
80100c90:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c9a:	47                   	inc    %edi
    ustack[3+argc] = sp;
80100c9b:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ca1:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ca4:	85 c0                	test   %eax,%eax
80100ca6:	74 60                	je     80100d08 <exec+0x298>
    if(argc >= MAXARG)
80100ca8:	83 ff 20             	cmp    $0x20,%edi
80100cab:	74 43                	je     80100cf0 <exec+0x280>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cad:	89 04 24             	mov    %eax,(%esp)
80100cb0:	e8 fb 3c 00 00       	call   801049b0 <strlen>
80100cb5:	f7 d0                	not    %eax
80100cb7:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cbc:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cbf:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc2:	89 04 24             	mov    %eax,(%esp)
80100cc5:	e8 e6 3c 00 00       	call   801049b0 <strlen>
80100cca:	40                   	inc    %eax
80100ccb:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cd2:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cd5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100cd9:	89 34 24             	mov    %esi,(%esp)
80100cdc:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ce0:	e8 cb 64 00 00       	call   801071b0 <copyout>
80100ce5:	85 c0                	test   %eax,%eax
80100ce7:	79 a7                	jns    80100c90 <exec+0x220>
80100ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100cf0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100cf6:	89 04 24             	mov    %eax,(%esp)
80100cf9:	e8 12 62 00 00       	call   80106f10 <freevm>
  return -1;
80100cfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d03:	e9 d9 fd ff ff       	jmp    80100ae1 <exec+0x71>
80100d08:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d0e:	89 54 24 08          	mov    %edx,0x8(%esp)
  ustack[3+argc] = 0;
80100d12:	31 c9                	xor    %ecx,%ecx
  ustack[0] = 0xffffffff;  // fake return PC
80100d14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ustack[3+argc] = 0;
80100d19:	89 8c bd 64 ff ff ff 	mov    %ecx,-0x9c(%ebp,%edi,4)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d20:	89 d9                	mov    %ebx,%ecx
  ustack[0] = 0xffffffff;  // fake return PC
80100d22:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d28:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
  ustack[1] = argc;
80100d2f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d35:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d37:	83 c0 0c             	add    $0xc,%eax
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  sp -= (3+argc+1) * 4;
80100d3e:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d50:	89 04 24             	mov    %eax,(%esp)
80100d53:	e8 58 64 00 00       	call   801071b0 <copyout>
80100d58:	85 c0                	test   %eax,%eax
80100d5a:	78 94                	js     80100cf0 <exec+0x280>
  for(last=s=path; *s; s++)
80100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80100d5f:	8b 55 08             	mov    0x8(%ebp),%edx
80100d62:	0f b6 00             	movzbl (%eax),%eax
80100d65:	84 c0                	test   %al,%al
80100d67:	74 14                	je     80100d7d <exec+0x30d>
80100d69:	89 d1                	mov    %edx,%ecx
80100d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d6f:	90                   	nop
    if(*s == '/')
80100d70:	41                   	inc    %ecx
80100d71:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d73:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d76:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d79:	84 c0                	test   %al,%al
80100d7b:	75 f3                	jne    80100d70 <exec+0x300>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d7d:	89 54 24 04          	mov    %edx,0x4(%esp)
80100d81:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d87:	b8 10 00 00 00       	mov    $0x10,%eax
80100d8c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d90:	89 f8                	mov    %edi,%eax
80100d92:	83 c0 6c             	add    $0x6c,%eax
80100d95:	89 04 24             	mov    %eax,(%esp)
80100d98:	e8 d3 3b 00 00       	call   80104970 <safestrcpy>
  curproc->pgdir = pgdir;
80100d9d:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100da3:	89 f8                	mov    %edi,%eax
80100da5:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100da8:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100daa:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dad:	89 c1                	mov    %eax,%ecx
80100daf:	8b 40 18             	mov    0x18(%eax),%eax
80100db2:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100db8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dbb:	8b 41 18             	mov    0x18(%ecx),%eax
80100dbe:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc1:	89 0c 24             	mov    %ecx,(%esp)
80100dc4:	e8 77 5d 00 00       	call   80106b40 <switchuvm>
  freevm(oldpgdir);
80100dc9:	89 3c 24             	mov    %edi,(%esp)
80100dcc:	e8 3f 61 00 00       	call   80106f10 <freevm>
  return 0;
80100dd1:	31 c0                	xor    %eax,%eax
80100dd3:	e9 09 fd ff ff       	jmp    80100ae1 <exec+0x71>
    end_op();
80100dd8:	e8 a3 20 00 00       	call   80102e80 <end_op>
    cprintf("exec: fail\n");
80100ddd:	c7 04 24 e1 72 10 80 	movl   $0x801072e1,(%esp)
80100de4:	e8 97 f8 ff ff       	call   80100680 <cprintf>
    return -1;
80100de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dee:	e9 ee fc ff ff       	jmp    80100ae1 <exec+0x71>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100df3:	31 ff                	xor    %edi,%edi
80100df5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dfa:	e9 29 fe ff ff       	jmp    80100c28 <exec+0x1b8>
80100dff:	90                   	nop

80100e00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e00:	55                   	push   %ebp
  initlock(&ftable.lock, "ftable");
80100e01:	b8 ed 72 10 80       	mov    $0x801072ed,%eax
{
80100e06:	89 e5                	mov    %esp,%ebp
80100e08:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e0f:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e16:	e8 05 37 00 00       	call   80104520 <initlock>
}
80100e1b:	c9                   	leave  
80100e1c:	c3                   	ret    
80100e1d:	8d 76 00             	lea    0x0(%esi),%esi

80100e20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e24:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e29:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100e2c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e33:	e8 58 38 00 00       	call   80104690 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e38:	eb 11                	jmp    80100e4b <filealloc+0x2b>
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e40:	83 c3 18             	add    $0x18,%ebx
80100e43:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e49:	74 25                	je     80100e70 <filealloc+0x50>
    if(f->ref == 0){
80100e4b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e4e:	85 c0                	test   %eax,%eax
80100e50:	75 ee                	jne    80100e40 <filealloc+0x20>
      f->ref = 1;
80100e52:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e59:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e60:	e8 db 38 00 00       	call   80104740 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e65:	83 c4 14             	add    $0x14,%esp
80100e68:	89 d8                	mov    %ebx,%eax
80100e6a:	5b                   	pop    %ebx
80100e6b:	5d                   	pop    %ebp
80100e6c:	c3                   	ret    
80100e6d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100e70:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  return 0;
80100e77:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e79:	e8 c2 38 00 00       	call   80104740 <release>
}
80100e7e:	83 c4 14             	add    $0x14,%esp
80100e81:	89 d8                	mov    %ebx,%eax
80100e83:	5b                   	pop    %ebx
80100e84:	5d                   	pop    %ebp
80100e85:	c3                   	ret    
80100e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e8d:	8d 76 00             	lea    0x0(%esi),%esi

80100e90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	53                   	push   %ebx
80100e94:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100e97:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
{
80100e9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ea1:	e8 ea 37 00 00       	call   80104690 <acquire>
  if(f->ref < 1)
80100ea6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ea9:	85 c0                	test   %eax,%eax
80100eab:	7e 18                	jle    80100ec5 <filedup+0x35>
    panic("filedup");
  f->ref++;
80100ead:	40                   	inc    %eax
80100eae:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eb1:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100eb8:	e8 83 38 00 00       	call   80104740 <release>
  return f;
}
80100ebd:	83 c4 14             	add    $0x14,%esp
80100ec0:	89 d8                	mov    %ebx,%eax
80100ec2:	5b                   	pop    %ebx
80100ec3:	5d                   	pop    %ebp
80100ec4:	c3                   	ret    
    panic("filedup");
80100ec5:	c7 04 24 f4 72 10 80 	movl   $0x801072f4,(%esp)
80100ecc:	e8 8f f4 ff ff       	call   80100360 <panic>
80100ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100edf:	90                   	nop

80100ee0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	83 ec 38             	sub    $0x38,%esp
80100ee6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80100ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100eec:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
{
80100ef3:	89 75 f8             	mov    %esi,-0x8(%ebp)
80100ef6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&ftable.lock);
80100ef9:	e8 92 37 00 00       	call   80104690 <acquire>
  if(f->ref < 1)
80100efe:	8b 53 04             	mov    0x4(%ebx),%edx
80100f01:	85 d2                	test   %edx,%edx
80100f03:	0f 8e b4 00 00 00    	jle    80100fbd <fileclose+0xdd>
    panic("fileclose");
  if(--f->ref > 0){
80100f09:	4a                   	dec    %edx
80100f0a:	89 53 04             	mov    %edx,0x4(%ebx)
80100f0d:	75 41                	jne    80100f50 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f0f:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f13:	8b 3b                	mov    (%ebx),%edi
  f->ref = 0;
  f->type = FD_NONE;
80100f15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f1b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f1e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f21:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f24:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100f2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f2e:	e8 0d 38 00 00       	call   80104740 <release>

  if(ff.type == FD_PIPE)
80100f33:	83 ff 01             	cmp    $0x1,%edi
80100f36:	74 68                	je     80100fa0 <fileclose+0xc0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f38:	83 ff 02             	cmp    $0x2,%edi
80100f3b:	74 33                	je     80100f70 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f3d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100f40:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f43:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100f46:	89 ec                	mov    %ebp,%esp
80100f48:	5d                   	pop    %ebp
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f50:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    release(&ftable.lock);
80100f53:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100f60:	89 ec                	mov    %ebp,%esp
80100f62:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f63:	e9 d8 37 00 00       	jmp    80104740 <release>
80100f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6f:	90                   	nop
    begin_op();
80100f70:	e8 9b 1e 00 00       	call   80102e10 <begin_op>
    iput(ff.ip);
80100f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f78:	89 04 24             	mov    %eax,(%esp)
80100f7b:	e8 b0 09 00 00       	call   80101930 <iput>
}
80100f80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100f83:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100f86:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100f89:	89 ec                	mov    %ebp,%esp
80100f8b:	5d                   	pop    %ebp
    end_op();
80100f8c:	e9 ef 1e 00 00       	jmp    80102e80 <end_op>
80100f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fa0:	89 34 24             	mov    %esi,(%esp)
80100fa3:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100fab:	e8 e0 25 00 00       	call   80103590 <pipeclose>
}
80100fb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80100fb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
80100fb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
80100fb9:	89 ec                	mov    %ebp,%esp
80100fbb:	5d                   	pop    %ebp
80100fbc:	c3                   	ret    
    panic("fileclose");
80100fbd:	c7 04 24 fc 72 10 80 	movl   $0x801072fc,(%esp)
80100fc4:	e8 97 f3 ff ff       	call   80100360 <panic>
80100fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 14             	sub    $0x14,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	8b 43 10             	mov    0x10(%ebx),%eax
80100fe2:	89 04 24             	mov    %eax,(%esp)
80100fe5:	e8 16 08 00 00       	call   80101800 <ilock>
    stati(f->ip, st);
80100fea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fed:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ff1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ff4:	89 04 24             	mov    %eax,(%esp)
80100ff7:	e8 c4 0a 00 00       	call   80101ac0 <stati>
    iunlock(f->ip);
80100ffc:	8b 43 10             	mov    0x10(%ebx),%eax
80100fff:	89 04 24             	mov    %eax,(%esp)
80101002:	e8 d9 08 00 00       	call   801018e0 <iunlock>
    return 0;
  }
  return -1;
}
80101007:	83 c4 14             	add    $0x14,%esp
    return 0;
8010100a:	31 c0                	xor    %eax,%eax
}
8010100c:	5b                   	pop    %ebx
8010100d:	5d                   	pop    %ebp
8010100e:	c3                   	ret    
8010100f:	90                   	nop
80101010:	83 c4 14             	add    $0x14,%esp
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	5b                   	pop    %ebx
80101019:	5d                   	pop    %ebp
8010101a:	c3                   	ret    
8010101b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010101f:	90                   	nop

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	83 ec 38             	sub    $0x38,%esp
80101026:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010102f:	8b 75 0c             	mov    0xc(%ebp),%esi
80101032:	89 7d fc             	mov    %edi,-0x4(%ebp)
80101035:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101038:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010103c:	0f 84 7e 00 00 00    	je     801010c0 <fileread+0xa0>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 03                	mov    (%ebx),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	74 57                	je     801010a0 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101049:	83 f8 02             	cmp    $0x2,%eax
8010104c:	75 79                	jne    801010c7 <fileread+0xa7>
    ilock(f->ip);
8010104e:	8b 43 10             	mov    0x10(%ebx),%eax
80101051:	89 04 24             	mov    %eax,(%esp)
80101054:	e8 a7 07 00 00       	call   80101800 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101059:	89 7c 24 0c          	mov    %edi,0xc(%esp)
8010105d:	8b 43 14             	mov    0x14(%ebx),%eax
80101060:	89 74 24 04          	mov    %esi,0x4(%esp)
80101064:	89 44 24 08          	mov    %eax,0x8(%esp)
80101068:	8b 43 10             	mov    0x10(%ebx),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 7d 0a 00 00       	call   80101af0 <readi>
80101073:	85 c0                	test   %eax,%eax
80101075:	7e 03                	jle    8010107a <fileread+0x5a>
      f->off += r;
80101077:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010107a:	8b 53 10             	mov    0x10(%ebx),%edx
8010107d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101080:	89 14 24             	mov    %edx,(%esp)
80101083:	e8 58 08 00 00       	call   801018e0 <iunlock>
    return r;
80101088:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
8010108b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010108e:	8b 75 f8             	mov    -0x8(%ebp),%esi
80101091:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101094:	89 ec                	mov    %ebp,%esp
80101096:	5d                   	pop    %ebp
80101097:	c3                   	ret    
80101098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
}
801010a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
801010a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801010a9:	8b 7d fc             	mov    -0x4(%ebp),%edi
    return piperead(f->pipe, addr, n);
801010ac:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010af:	89 ec                	mov    %ebp,%esp
801010b1:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010b2:	e9 89 26 00 00       	jmp    80103740 <piperead>
801010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010be:	66 90                	xchg   %ax,%ax
    return -1;
801010c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010c5:	eb c4                	jmp    8010108b <fileread+0x6b>
  panic("fileread");
801010c7:	c7 04 24 06 73 10 80 	movl   $0x80107306,(%esp)
801010ce:	e8 8d f2 ff ff       	call   80100360 <panic>
801010d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 2c             	sub    $0x2c,%esp
801010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010ec:	8b 7d 08             	mov    0x8(%ebp),%edi
801010ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010f5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
801010f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010fc:	0f 84 c5 00 00 00    	je     801011c7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101102:	8b 07                	mov    (%edi),%eax
80101104:	83 f8 01             	cmp    $0x1,%eax
80101107:	0f 84 c7 00 00 00    	je     801011d4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010110d:	83 f8 02             	cmp    $0x2,%eax
80101110:	0f 85 d0 00 00 00    	jne    801011e6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101119:	31 f6                	xor    %esi,%esi
    while(i < n){
8010111b:	85 c0                	test   %eax,%eax
8010111d:	7f 35                	jg     80101154 <filewrite+0x74>
8010111f:	e9 9c 00 00 00       	jmp    801011c0 <filewrite+0xe0>
80101124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010112b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010112f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101130:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101133:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
80101136:	01 47 14             	add    %eax,0x14(%edi)
      iunlock(f->ip);
80101139:	89 0c 24             	mov    %ecx,(%esp)
8010113c:	e8 9f 07 00 00       	call   801018e0 <iunlock>
      end_op();
80101141:	e8 3a 1d 00 00       	call   80102e80 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101146:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101149:	39 c3                	cmp    %eax,%ebx
8010114b:	75 67                	jne    801011b4 <filewrite+0xd4>
        panic("short filewrite");
      i += r;
8010114d:	01 de                	add    %ebx,%esi
    while(i < n){
8010114f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101152:	7e 6c                	jle    801011c0 <filewrite+0xe0>
      int n1 = n - i;
80101154:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101157:	b8 00 06 00 00       	mov    $0x600,%eax
8010115c:	29 f3                	sub    %esi,%ebx
      if(n1 > max)
8010115e:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101164:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101167:	e8 a4 1c 00 00       	call   80102e10 <begin_op>
      ilock(f->ip);
8010116c:	8b 47 10             	mov    0x10(%edi),%eax
8010116f:	89 04 24             	mov    %eax,(%esp)
80101172:	e8 89 06 00 00       	call   80101800 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101177:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010117b:	8b 47 14             	mov    0x14(%edi),%eax
8010117e:	89 44 24 08          	mov    %eax,0x8(%esp)
80101182:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101185:	01 f0                	add    %esi,%eax
80101187:	89 44 24 04          	mov    %eax,0x4(%esp)
8010118b:	8b 47 10             	mov    0x10(%edi),%eax
8010118e:	89 04 24             	mov    %eax,(%esp)
80101191:	e8 8a 0a 00 00       	call   80101c20 <writei>
80101196:	85 c0                	test   %eax,%eax
80101198:	7f 96                	jg     80101130 <filewrite+0x50>
8010119a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      iunlock(f->ip);
8010119d:	8b 57 10             	mov    0x10(%edi),%edx
801011a0:	89 14 24             	mov    %edx,(%esp)
801011a3:	e8 38 07 00 00       	call   801018e0 <iunlock>
      end_op();
801011a8:	e8 d3 1c 00 00       	call   80102e80 <end_op>
      if(r < 0)
801011ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011b0:	85 c0                	test   %eax,%eax
801011b2:	75 13                	jne    801011c7 <filewrite+0xe7>
        panic("short filewrite");
801011b4:	c7 04 24 0f 73 10 80 	movl   $0x8010730f,(%esp)
801011bb:	e8 a0 f1 ff ff       	call   80100360 <panic>
    }
    return i == n ? n : -1;
801011c0:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801011c3:	89 f0                	mov    %esi,%eax
801011c5:	74 05                	je     801011cc <filewrite+0xec>
801011c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011cc:	83 c4 2c             	add    $0x2c,%esp
801011cf:	5b                   	pop    %ebx
801011d0:	5e                   	pop    %esi
801011d1:	5f                   	pop    %edi
801011d2:	5d                   	pop    %ebp
801011d3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011d4:	8b 47 0c             	mov    0xc(%edi),%eax
801011d7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011da:	83 c4 2c             	add    $0x2c,%esp
801011dd:	5b                   	pop    %ebx
801011de:	5e                   	pop    %esi
801011df:	5f                   	pop    %edi
801011e0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011e1:	e9 4a 24 00 00       	jmp    80103630 <pipewrite>
  panic("filewrite");
801011e6:	c7 04 24 15 73 10 80 	movl   $0x80107315,(%esp)
801011ed:	e8 6e f1 ff ff       	call   80100360 <panic>
801011f2:	66 90                	xchg   %ax,%ax
801011f4:	66 90                	xchg   %ax,%ax
801011f6:	66 90                	xchg   %ax,%ax
801011f8:	66 90                	xchg   %ax,%ax
801011fa:	66 90                	xchg   %ax,%ax
801011fc:	66 90                	xchg   %ax,%ax
801011fe:	66 90                	xchg   %ax,%ax

80101200 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101200:	55                   	push   %ebp
80101201:	89 c1                	mov    %eax,%ecx
80101203:	89 e5                	mov    %esp,%ebp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101205:	89 d0                	mov    %edx,%eax
{
80101207:	56                   	push   %esi
80101208:	53                   	push   %ebx
80101209:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010120b:	c1 e8 0c             	shr    $0xc,%eax
{
8010120e:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101211:	89 0c 24             	mov    %ecx,(%esp)
80101214:	8b 15 d8 09 11 80    	mov    0x801109d8,%edx
8010121a:	01 d0                	add    %edx,%eax
8010121c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101220:	e8 ab ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101225:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101227:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010122a:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010122d:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101233:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101235:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
8010123a:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
  m = 1 << (bi % 8);
8010123f:	d3 e0                	shl    %cl,%eax
80101241:	89 c1                	mov    %eax,%ecx
  if((bp->data[bi/8] & m) == 0)
80101243:	85 c2                	test   %eax,%edx
80101245:	74 1f                	je     80101266 <bfree+0x66>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101247:	f6 d1                	not    %cl
80101249:	20 d1                	and    %dl,%cl
8010124b:	88 4c 1e 5c          	mov    %cl,0x5c(%esi,%ebx,1)
  log_write(bp);
8010124f:	89 34 24             	mov    %esi,(%esp)
80101252:	e8 59 1d 00 00       	call   80102fb0 <log_write>
  brelse(bp);
80101257:	89 34 24             	mov    %esi,(%esp)
8010125a:	e8 91 ef ff ff       	call   801001f0 <brelse>
}
8010125f:	83 c4 10             	add    $0x10,%esp
80101262:	5b                   	pop    %ebx
80101263:	5e                   	pop    %esi
80101264:	5d                   	pop    %ebp
80101265:	c3                   	ret    
    panic("freeing free block");
80101266:	c7 04 24 1f 73 10 80 	movl   $0x8010731f,(%esp)
8010126d:	e8 ee f0 ff ff       	call   80100360 <panic>
80101272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101280 <balloc>:
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	83 ec 2c             	sub    $0x2c,%esp
80101289:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010128c:	8b 35 c0 09 11 80    	mov    0x801109c0,%esi
80101292:	85 f6                	test   %esi,%esi
80101294:	0f 84 7e 00 00 00    	je     80101318 <balloc+0x98>
8010129a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012a4:	8b 1d d8 09 11 80    	mov    0x801109d8,%ebx
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	c1 f8 0c             	sar    $0xc,%eax
801012af:	01 d8                	add    %ebx,%eax
801012b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801012b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801012b8:	89 04 24             	mov    %eax,(%esp)
801012bb:	e8 10 ee ff ff       	call   801000d0 <bread>
801012c0:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012c2:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801012c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012ca:	31 c0                	xor    %eax,%eax
801012cc:	eb 2b                	jmp    801012f9 <balloc+0x79>
801012ce:	66 90                	xchg   %ax,%ax
      m = 1 << (bi % 8);
801012d0:	89 c1                	mov    %eax,%ecx
801012d2:	bf 01 00 00 00       	mov    $0x1,%edi
801012d7:	83 e1 07             	and    $0x7,%ecx
801012da:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012dc:	89 c1                	mov    %eax,%ecx
      m = 1 << (bi % 8);
801012de:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012e1:	c1 f9 03             	sar    $0x3,%ecx
801012e4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801012e9:	85 7d e4             	test   %edi,-0x1c(%ebp)
801012ec:	89 fa                	mov    %edi,%edx
801012ee:	74 40                	je     80101330 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012f0:	40                   	inc    %eax
801012f1:	46                   	inc    %esi
801012f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012f7:	74 05                	je     801012fe <balloc+0x7e>
801012f9:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012fc:	77 d2                	ja     801012d0 <balloc+0x50>
    brelse(bp);
801012fe:	89 1c 24             	mov    %ebx,(%esp)
80101301:	e8 ea ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101306:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
8010130d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101310:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
80101316:	77 89                	ja     801012a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101318:	c7 04 24 32 73 10 80 	movl   $0x80107332,(%esp)
8010131f:	e8 3c f0 ff ff       	call   80100360 <panic>
80101324:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010132b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010132f:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
80101330:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80101334:	08 c2                	or     %al,%dl
80101336:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 6e 1c 00 00       	call   80102fb0 <log_write>
        brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010134a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010134d:	89 74 24 04          	mov    %esi,0x4(%esp)
80101351:	89 04 24             	mov    %eax,(%esp)
80101354:	e8 77 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101359:	ba 00 02 00 00       	mov    $0x200,%edx
8010135e:	31 c9                	xor    %ecx,%ecx
80101360:	89 54 24 08          	mov    %edx,0x8(%esp)
80101364:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  bp = bread(dev, bno);
80101368:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010136a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010136d:	89 04 24             	mov    %eax,(%esp)
80101370:	e8 1b 34 00 00       	call   80104790 <memset>
  log_write(bp);
80101375:	89 1c 24             	mov    %ebx,(%esp)
80101378:	e8 33 1c 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010137d:	89 1c 24             	mov    %ebx,(%esp)
80101380:	e8 6b ee ff ff       	call   801001f0 <brelse>
}
80101385:	83 c4 2c             	add    $0x2c,%esp
80101388:	89 f0                	mov    %esi,%eax
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
8010138f:	90                   	nop

80101390 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	89 d7                	mov    %edx,%edi
80101396:	56                   	push   %esi
80101397:	89 c6                	mov    %eax,%esi
80101399:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010139f:	83 ec 2c             	sub    $0x2c,%esp
  acquire(&icache.lock);
801013a2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801013a9:	e8 e2 32 00 00       	call   80104690 <acquire>
  empty = 0;
801013ae:	31 c0                	xor    %eax,%eax
801013b0:	eb 20                	jmp    801013d2 <iget+0x42>
801013b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 33                	cmp    %esi,(%ebx)
801013c2:	74 7c                	je     80101440 <iget+0xb0>
801013c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ca:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013d0:	73 2e                	jae    80101400 <iget+0x70>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013d5:	85 c9                	test   %ecx,%ecx
801013d7:	7f e7                	jg     801013c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013d9:	85 c0                	test   %eax,%eax
801013db:	75 e7                	jne    801013c4 <iget+0x34>
801013dd:	89 da                	mov    %ebx,%edx
801013df:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013e5:	85 c9                	test   %ecx,%ecx
801013e7:	75 7a                	jne    80101463 <iget+0xd3>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e9:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013ef:	89 d0                	mov    %edx,%eax
801013f1:	72 df                	jb     801013d2 <iget+0x42>
801013f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101400:	85 c0                	test   %eax,%eax
80101402:	74 77                	je     8010147b <iget+0xeb>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101404:	89 30                	mov    %esi,(%eax)
  ip->inum = inum;
80101406:	89 78 04             	mov    %edi,0x4(%eax)
  ip->ref = 1;
80101409:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101410:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101417:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
  ip->valid = 0;
8010141e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  release(&icache.lock);
80101421:	e8 1a 33 00 00       	call   80104740 <release>
80101426:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return ip;
}
80101429:	83 c4 2c             	add    $0x2c,%esp
8010142c:	5b                   	pop    %ebx
8010142d:	5e                   	pop    %esi
8010142e:	5f                   	pop    %edi
8010142f:	5d                   	pop    %ebp
80101430:	c3                   	ret    
80101431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010143f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101440:	39 7b 04             	cmp    %edi,0x4(%ebx)
80101443:	0f 85 7b ff ff ff    	jne    801013c4 <iget+0x34>
      release(&icache.lock);
80101449:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101450:	41                   	inc    %ecx
80101451:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101454:	e8 e7 32 00 00       	call   80104740 <release>
}
80101459:	83 c4 2c             	add    $0x2c,%esp
      return ip;
8010145c:	89 d8                	mov    %ebx,%eax
}
8010145e:	5b                   	pop    %ebx
8010145f:	5e                   	pop    %esi
80101460:	5f                   	pop    %edi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101463:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101469:	73 10                	jae    8010147b <iget+0xeb>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010146b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010146e:	85 c9                	test   %ecx,%ecx
80101470:	0f 8f 4a ff ff ff    	jg     801013c0 <iget+0x30>
80101476:	e9 62 ff ff ff       	jmp    801013dd <iget+0x4d>
    panic("iget: no inodes");
8010147b:	c7 04 24 48 73 10 80 	movl   $0x80107348,(%esp)
80101482:	e8 d9 ee ff ff       	call   80100360 <panic>
80101487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148e:	66 90                	xchg   %ax,%ax

80101490 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	83 ec 38             	sub    $0x38,%esp
80101496:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101499:	83 fa 0b             	cmp    $0xb,%edx
{
8010149c:	89 c6                	mov    %eax,%esi
8010149e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801014a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(bn < NDIRECT){
801014a4:	0f 86 96 00 00 00    	jbe    80101540 <bmap+0xb0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014aa:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014ad:	83 fb 7f             	cmp    $0x7f,%ebx
801014b0:	0f 87 ab 00 00 00    	ja     80101561 <bmap+0xd1>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014b6:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014bc:	8b 16                	mov    (%esi),%edx
801014be:	85 c0                	test   %eax,%eax
801014c0:	74 5e                	je     80101520 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801014c6:	89 14 24             	mov    %edx,(%esp)
801014c9:	e8 02 ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014ce:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014d2:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014d4:	8b 03                	mov    (%ebx),%eax
801014d6:	85 c0                	test   %eax,%eax
801014d8:	74 26                	je     80101500 <bmap+0x70>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014da:	89 3c 24             	mov    %edi,(%esp)
801014dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801014e0:	e8 0b ed ff ff       	call   801001f0 <brelse>
    return addr;
801014e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }

  panic("bmap: out of range");
}
801014e8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801014eb:	8b 75 f8             	mov    -0x8(%ebp),%esi
801014ee:	8b 7d fc             	mov    -0x4(%ebp),%edi
801014f1:	89 ec                	mov    %ebp,%esp
801014f3:	5d                   	pop    %ebp
801014f4:	c3                   	ret    
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a[bn] = addr = balloc(ip->dev);
80101500:	8b 06                	mov    (%esi),%eax
80101502:	e8 79 fd ff ff       	call   80101280 <balloc>
80101507:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101509:	89 3c 24             	mov    %edi,(%esp)
      a[bn] = addr = balloc(ip->dev);
8010150c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      log_write(bp);
8010150f:	e8 9c 1a 00 00       	call   80102fb0 <log_write>
80101514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101517:	eb c1                	jmp    801014da <bmap+0x4a>
80101519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101520:	89 d0                	mov    %edx,%eax
80101522:	e8 59 fd ff ff       	call   80101280 <balloc>
80101527:	8b 16                	mov    (%esi),%edx
80101529:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010152f:	eb 91                	jmp    801014c2 <bmap+0x32>
80101531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101540:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101543:	8b 47 5c             	mov    0x5c(%edi),%eax
80101546:	85 c0                	test   %eax,%eax
80101548:	75 9e                	jne    801014e8 <bmap+0x58>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010154a:	8b 06                	mov    (%esi),%eax
8010154c:	e8 2f fd ff ff       	call   80101280 <balloc>
80101551:	89 47 5c             	mov    %eax,0x5c(%edi)
}
80101554:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101557:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010155a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010155d:	89 ec                	mov    %ebp,%esp
8010155f:	5d                   	pop    %ebp
80101560:	c3                   	ret    
  panic("bmap: out of range");
80101561:	c7 04 24 58 73 10 80 	movl   $0x80107358,(%esp)
80101568:	e8 f3 ed ff ff       	call   80100360 <panic>
8010156d:	8d 76 00             	lea    0x0(%esi),%esi

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
  bp = bread(dev, 1);
80101571:	b8 01 00 00 00       	mov    $0x1,%eax
{
80101576:	89 e5                	mov    %esp,%ebp
80101578:	83 ec 18             	sub    $0x18,%esp
  bp = bread(dev, 1);
8010157b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010157f:	8b 45 08             	mov    0x8(%ebp),%eax
{
80101582:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80101585:	89 75 fc             	mov    %esi,-0x4(%ebp)
80101588:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010158b:	89 04 24             	mov    %eax,(%esp)
8010158e:	e8 3d eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101593:	ba 1c 00 00 00       	mov    $0x1c,%edx
80101598:	89 34 24             	mov    %esi,(%esp)
8010159b:	89 54 24 08          	mov    %edx,0x8(%esp)
  bp = bread(dev, 1);
8010159f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015a1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801015a8:	e8 a3 32 00 00       	call   80104850 <memmove>
}
801015ad:	8b 75 fc             	mov    -0x4(%ebp),%esi
  brelse(bp);
801015b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801015b3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801015b6:	89 ec                	mov    %ebp,%esp
801015b8:	5d                   	pop    %ebp
  brelse(bp);
801015b9:	e9 32 ec ff ff       	jmp    801001f0 <brelse>
801015be:	66 90                	xchg   %ax,%ax

801015c0 <iinit>:
{
801015c0:	55                   	push   %ebp
  initlock(&icache.lock, "icache");
801015c1:	b9 6b 73 10 80       	mov    $0x8010736b,%ecx
{
801015c6:	89 e5                	mov    %esp,%ebp
801015c8:	53                   	push   %ebx
801015c9:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801015ce:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
801015d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801015d5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801015dc:	e8 3f 2f 00 00       	call   80104520 <initlock>
  for(i = 0; i < NINODE; i++) {
801015e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ef:	90                   	nop
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	89 1c 24             	mov    %ebx,(%esp)
801015f3:	ba 72 73 10 80       	mov    $0x80107372,%edx
801015f8:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101602:	e8 d9 2d 00 00       	call   801043e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101607:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x30>
  readsb(dev, &sb);
8010160f:	b8 c0 09 11 80       	mov    $0x801109c0,%eax
80101614:	89 44 24 04          	mov    %eax,0x4(%esp)
80101618:	8b 45 08             	mov    0x8(%ebp),%eax
8010161b:	89 04 24             	mov    %eax,(%esp)
8010161e:	e8 4d ff ff ff       	call   80101570 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101623:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101628:	c7 04 24 d8 73 10 80 	movl   $0x801073d8,(%esp)
8010162f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101633:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101638:	89 44 24 18          	mov    %eax,0x18(%esp)
8010163c:	a1 d0 09 11 80       	mov    0x801109d0,%eax
80101641:	89 44 24 14          	mov    %eax,0x14(%esp)
80101645:	a1 cc 09 11 80       	mov    0x801109cc,%eax
8010164a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010164e:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101653:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101657:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010165c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101660:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101665:	89 44 24 04          	mov    %eax,0x4(%esp)
80101669:	e8 12 f0 ff ff       	call   80100680 <cprintf>
}
8010166e:	83 c4 24             	add    $0x24,%esp
80101671:	5b                   	pop    %ebx
80101672:	5d                   	pop    %ebp
80101673:	c3                   	ret    
80101674:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010167f:	90                   	nop

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 2c             	sub    $0x2c,%esp
80101689:	0f bf 45 0c          	movswl 0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168d:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101694:	8b 75 08             	mov    0x8(%ebp),%esi
80101697:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010169a:	0f 86 91 00 00 00    	jbe    80101731 <ialloc+0xb1>
801016a0:	bf 01 00 00 00       	mov    $0x1,%edi
801016a5:	eb 1a                	jmp    801016c1 <ialloc+0x41>
801016a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ae:	66 90                	xchg   %ax,%ax
    brelse(bp);
801016b0:	89 1c 24             	mov    %ebx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	47                   	inc    %edi
    brelse(bp);
801016b4:	e8 37 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016b9:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
801016bf:	73 70                	jae    80101731 <ialloc+0xb1>
    bp = bread(dev, IBLOCK(inum, sb));
801016c1:	89 34 24             	mov    %esi,(%esp)
801016c4:	8b 0d d4 09 11 80    	mov    0x801109d4,%ecx
801016ca:	89 f8                	mov    %edi,%eax
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	01 c8                	add    %ecx,%eax
801016d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801016d5:	e8 f6 e9 ff ff       	call   801000d0 <bread>
801016da:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016dc:	89 f8                	mov    %edi,%eax
801016de:	83 e0 07             	and    $0x7,%eax
801016e1:	c1 e0 06             	shl    $0x6,%eax
801016e4:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016e8:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016ec:	75 c2                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016ee:	89 0c 24             	mov    %ecx,(%esp)
801016f1:	31 d2                	xor    %edx,%edx
801016f3:	b8 40 00 00 00       	mov    $0x40,%eax
801016f8:	89 54 24 04          	mov    %edx,0x4(%esp)
801016fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80101700:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101703:	e8 88 30 00 00       	call   80104790 <memset>
      dip->type = type;
80101708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010170b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170e:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101711:	89 1c 24             	mov    %ebx,(%esp)
80101714:	e8 97 18 00 00       	call   80102fb0 <log_write>
      brelse(bp);
80101719:	89 1c 24             	mov    %ebx,(%esp)
8010171c:	e8 cf ea ff ff       	call   801001f0 <brelse>
}
80101721:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
80101724:	89 f0                	mov    %esi,%eax
}
80101726:	5b                   	pop    %ebx
      return iget(dev, inum);
80101727:	89 fa                	mov    %edi,%edx
}
80101729:	5e                   	pop    %esi
8010172a:	5f                   	pop    %edi
8010172b:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172c:	e9 5f fc ff ff       	jmp    80101390 <iget>
  panic("ialloc: no inodes");
80101731:	c7 04 24 78 73 10 80 	movl   $0x80107378,(%esp)
80101738:	e8 23 ec ff ff       	call   80100360 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	83 ec 10             	sub    $0x10,%esp
80101748:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174b:	8b 15 d4 09 11 80    	mov    0x801109d4,%edx
80101751:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101754:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101757:	c1 e8 03             	shr    $0x3,%eax
8010175a:	01 d0                	add    %edx,%eax
8010175c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101760:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101763:	89 04 24             	mov    %eax,(%esp)
80101766:	e8 65 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
8010176b:	0f bf 53 f4          	movswl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176f:	b9 34 00 00 00       	mov    $0x34,%ecx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101774:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101776:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101779:	83 e0 07             	and    $0x7,%eax
8010177c:	c1 e0 06             	shl    $0x6,%eax
8010177f:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101783:	66 89 10             	mov    %dx,(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101786:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101789:	0f bf 53 f6          	movswl -0xa(%ebx),%edx
8010178d:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101791:	0f bf 53 f8          	movswl -0x8(%ebx),%edx
80101795:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101799:	0f bf 53 fa          	movswl -0x6(%ebx),%edx
8010179d:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017a1:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017a4:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801017ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801017af:	89 04 24             	mov    %eax,(%esp)
801017b2:	e8 99 30 00 00       	call   80104850 <memmove>
  log_write(bp);
801017b7:	89 34 24             	mov    %esi,(%esp)
801017ba:	e8 f1 17 00 00       	call   80102fb0 <log_write>
  brelse(bp);
801017bf:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c2:	83 c4 10             	add    $0x10,%esp
801017c5:	5b                   	pop    %ebx
801017c6:	5e                   	pop    %esi
801017c7:	5d                   	pop    %ebp
  brelse(bp);
801017c8:	e9 23 ea ff ff       	jmp    801001f0 <brelse>
801017cd:	8d 76 00             	lea    0x0(%esi),%esi

801017d0 <idup>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	53                   	push   %ebx
801017d4:	83 ec 14             	sub    $0x14,%esp
  acquire(&icache.lock);
801017d7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
801017de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017e1:	e8 aa 2e 00 00       	call   80104690 <acquire>
  ip->ref++;
801017e6:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
801017e9:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f0:	e8 4b 2f 00 00       	call   80104740 <release>
}
801017f5:	83 c4 14             	add    $0x14,%esp
801017f8:	89 d8                	mov    %ebx,%eax
801017fa:	5b                   	pop    %ebx
801017fb:	5d                   	pop    %ebp
801017fc:	c3                   	ret    
801017fd:	8d 76 00             	lea    0x0(%esi),%esi

80101800 <ilock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	83 ec 10             	sub    $0x10,%esp
80101808:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010180b:	85 db                	test   %ebx,%ebx
8010180d:	0f 84 be 00 00 00    	je     801018d1 <ilock+0xd1>
80101813:	8b 43 08             	mov    0x8(%ebx),%eax
80101816:	85 c0                	test   %eax,%eax
80101818:	0f 8e b3 00 00 00    	jle    801018d1 <ilock+0xd1>
  acquiresleep(&ip->lock);
8010181e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101821:	89 04 24             	mov    %eax,(%esp)
80101824:	e8 f7 2b 00 00       	call   80104420 <acquiresleep>
  if(ip->valid == 0){
80101829:	8b 73 4c             	mov    0x4c(%ebx),%esi
8010182c:	85 f6                	test   %esi,%esi
8010182e:	74 10                	je     80101840 <ilock+0x40>
}
80101830:	83 c4 10             	add    $0x10,%esp
80101833:	5b                   	pop    %ebx
80101834:	5e                   	pop    %esi
80101835:	5d                   	pop    %ebp
80101836:	c3                   	ret    
80101837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183e:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101840:	8b 43 04             	mov    0x4(%ebx),%eax
80101843:	8b 15 d4 09 11 80    	mov    0x801109d4,%edx
80101849:	c1 e8 03             	shr    $0x3,%eax
8010184c:	01 d0                	add    %edx,%eax
8010184e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101852:	8b 03                	mov    (%ebx),%eax
80101854:	89 04 24             	mov    %eax,(%esp)
80101857:	e8 74 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	b9 34 00 00 00       	mov    $0x34,%ecx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101861:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101863:	8b 43 04             	mov    0x4(%ebx),%eax
80101866:	83 e0 07             	and    $0x7,%eax
80101869:	c1 e0 06             	shl    $0x6,%eax
8010186c:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101870:	0f bf 10             	movswl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101873:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101876:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010187a:	0f bf 50 f6          	movswl -0xa(%eax),%edx
8010187e:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101882:	0f bf 50 f8          	movswl -0x8(%eax),%edx
80101886:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010188a:	0f bf 50 fa          	movswl -0x6(%eax),%edx
8010188e:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101892:	8b 50 fc             	mov    -0x4(%eax),%edx
80101895:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101898:	89 44 24 04          	mov    %eax,0x4(%esp)
8010189c:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010189f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801018a3:	89 04 24             	mov    %eax,(%esp)
801018a6:	e8 a5 2f 00 00       	call   80104850 <memmove>
    brelse(bp);
801018ab:	89 34 24             	mov    %esi,(%esp)
801018ae:	e8 3d e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018b3:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018b8:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018bf:	0f 85 6b ff ff ff    	jne    80101830 <ilock+0x30>
      panic("ilock: no type");
801018c5:	c7 04 24 90 73 10 80 	movl   $0x80107390,(%esp)
801018cc:	e8 8f ea ff ff       	call   80100360 <panic>
    panic("ilock");
801018d1:	c7 04 24 8a 73 10 80 	movl   $0x8010738a,(%esp)
801018d8:	e8 83 ea ff ff       	call   80100360 <panic>
801018dd:	8d 76 00             	lea    0x0(%esi),%esi

801018e0 <iunlock>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	83 ec 18             	sub    $0x18,%esp
801018e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
801018e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801018ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018ef:	85 db                	test   %ebx,%ebx
801018f1:	74 27                	je     8010191a <iunlock+0x3a>
801018f3:	8d 73 0c             	lea    0xc(%ebx),%esi
801018f6:	89 34 24             	mov    %esi,(%esp)
801018f9:	e8 c2 2b 00 00       	call   801044c0 <holdingsleep>
801018fe:	85 c0                	test   %eax,%eax
80101900:	74 18                	je     8010191a <iunlock+0x3a>
80101902:	8b 43 08             	mov    0x8(%ebx),%eax
80101905:	85 c0                	test   %eax,%eax
80101907:	7e 11                	jle    8010191a <iunlock+0x3a>
  releasesleep(&ip->lock);
80101909:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010190c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
8010190f:	8b 75 fc             	mov    -0x4(%ebp),%esi
80101912:	89 ec                	mov    %ebp,%esp
80101914:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101915:	e9 66 2b 00 00       	jmp    80104480 <releasesleep>
    panic("iunlock");
8010191a:	c7 04 24 9f 73 10 80 	movl   $0x8010739f,(%esp)
80101921:	e8 3a ea ff ff       	call   80100360 <panic>
80101926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010192d:	8d 76 00             	lea    0x0(%esi),%esi

80101930 <iput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	83 ec 38             	sub    $0x38,%esp
80101936:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80101939:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010193c:	89 7d fc             	mov    %edi,-0x4(%ebp)
8010193f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquiresleep(&ip->lock);
80101942:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101945:	89 3c 24             	mov    %edi,(%esp)
80101948:	e8 d3 2a 00 00       	call   80104420 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010194d:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101950:	85 d2                	test   %edx,%edx
80101952:	74 07                	je     8010195b <iput+0x2b>
80101954:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101959:	74 35                	je     80101990 <iput+0x60>
  releasesleep(&ip->lock);
8010195b:	89 3c 24             	mov    %edi,(%esp)
8010195e:	e8 1d 2b 00 00       	call   80104480 <releasesleep>
  acquire(&icache.lock);
80101963:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010196a:	e8 21 2d 00 00       	call   80104690 <acquire>
  ip->ref--;
8010196f:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
80101972:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101979:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010197c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010197f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80101982:	89 ec                	mov    %ebp,%esp
80101984:	5d                   	pop    %ebp
  release(&icache.lock);
80101985:	e9 b6 2d 00 00       	jmp    80104740 <release>
8010198a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101990:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101997:	e8 f4 2c 00 00       	call   80104690 <acquire>
    int r = ip->ref;
8010199c:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
8010199f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801019a6:	e8 95 2d 00 00       	call   80104740 <release>
    if(r == 1){
801019ab:	4e                   	dec    %esi
801019ac:	75 ad                	jne    8010195b <iput+0x2b>
801019ae:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019b1:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019b7:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019ba:	89 cf                	mov    %ecx,%edi
801019bc:	eb 09                	jmp    801019c7 <iput+0x97>
801019be:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 fe                	cmp    %edi,%esi
801019c5:	74 19                	je     801019e0 <iput+0xb0>
    if(ip->addrs[i]){
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 2c f8 ff ff       	call   80101200 <bfree>
      ip->addrs[i] = 0;
801019d4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019da:	eb e4                	jmp    801019c0 <iput+0x90>
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019e0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019e9:	85 c0                	test   %eax,%eax
801019eb:	75 33                	jne    80101a20 <iput+0xf0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801019ed:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019f4:	89 1c 24             	mov    %ebx,(%esp)
801019f7:	e8 44 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019fc:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101a02:	89 1c 24             	mov    %ebx,(%esp)
80101a05:	e8 36 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
80101a0a:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a11:	e9 45 ff ff ff       	jmp    8010195b <iput+0x2b>
80101a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a24:	8b 03                	mov    (%ebx),%eax
80101a26:	89 04 24             	mov    %eax,(%esp)
80101a29:	e8 a2 e6 ff ff       	call   801000d0 <bread>
80101a2e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a34:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a3a:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a3d:	89 cf                	mov    %ecx,%edi
80101a3f:	eb 16                	jmp    80101a57 <iput+0x127>
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a4f:	90                   	nop
80101a50:	83 c6 04             	add    $0x4,%esi
80101a53:	39 f7                	cmp    %esi,%edi
80101a55:	74 19                	je     80101a70 <iput+0x140>
      if(a[j])
80101a57:	8b 16                	mov    (%esi),%edx
80101a59:	85 d2                	test   %edx,%edx
80101a5b:	74 f3                	je     80101a50 <iput+0x120>
        bfree(ip->dev, a[j]);
80101a5d:	8b 03                	mov    (%ebx),%eax
80101a5f:	e8 9c f7 ff ff       	call   80101200 <bfree>
80101a64:	eb ea                	jmp    80101a50 <iput+0x120>
80101a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a73:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a76:	89 04 24             	mov    %eax,(%esp)
80101a79:	e8 72 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a7e:	8b 03                	mov    (%ebx),%eax
80101a80:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a86:	e8 75 f7 ff ff       	call   80101200 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a8b:	31 c0                	xor    %eax,%eax
80101a8d:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101a93:	e9 55 ff ff ff       	jmp    801019ed <iput+0xbd>
80101a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a9f:	90                   	nop

80101aa0 <iunlockput>:
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	53                   	push   %ebx
80101aa4:	83 ec 14             	sub    $0x14,%esp
80101aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101aaa:	89 1c 24             	mov    %ebx,(%esp)
80101aad:	e8 2e fe ff ff       	call   801018e0 <iunlock>
  iput(ip);
80101ab2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ab5:	83 c4 14             	add    $0x14,%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5d                   	pop    %ebp
  iput(ip);
80101aba:	e9 71 fe ff ff       	jmp    80101930 <iput>
80101abf:	90                   	nop

80101ac0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ac9:	8b 0a                	mov    (%edx),%ecx
80101acb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ace:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ad1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ad4:	0f bf 4a 50          	movswl 0x50(%edx),%ecx
80101ad8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101adb:	0f bf 4a 56          	movswl 0x56(%edx),%ecx
80101adf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ae3:	8b 52 58             	mov    0x58(%edx),%edx
80101ae6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ae9:	5d                   	pop    %ebp
80101aea:	c3                   	ret    
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 2c             	sub    $0x2c,%esp
80101af9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101afc:	8b 7d 08             	mov    0x8(%ebp),%edi
80101aff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101b02:	8b 45 10             	mov    0x10(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b05:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
80101b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b0d:	8b 45 14             	mov    0x14(%ebp),%eax
80101b10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b13:	0f 84 c7 00 00 00    	je     80101be0 <readi+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 47 58             	mov    0x58(%edi),%eax
80101b1c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101b1f:	39 c1                	cmp    %eax,%ecx
80101b21:	0f 87 dd 00 00 00    	ja     80101c04 <readi+0x114>
80101b27:	89 ca                	mov    %ecx,%edx
80101b29:	31 f6                	xor    %esi,%esi
80101b2b:	03 55 e0             	add    -0x20(%ebp),%edx
80101b2e:	0f 82 d7 00 00 00    	jb     80101c0b <readi+0x11b>
80101b34:	85 f6                	test   %esi,%esi
80101b36:	0f 85 c8 00 00 00    	jne    80101c04 <readi+0x114>
    return -1;
  if(off + n > ip->size)
80101b3c:	39 d0                	cmp    %edx,%eax
80101b3e:	0f 82 8c 00 00 00    	jb     80101bd0 <readi+0xe0>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b47:	85 c0                	test   %eax,%eax
80101b49:	74 71                	je     80101bbc <readi+0xcc>
80101b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b53:	89 f8                	mov    %edi,%eax
80101b55:	89 da                	mov    %ebx,%edx
80101b57:	c1 ea 09             	shr    $0x9,%edx
80101b5a:	e8 31 f9 ff ff       	call   80101490 <bmap>
80101b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b63:	8b 07                	mov    (%edi),%eax
80101b65:	89 04 24             	mov    %eax,(%esp)
80101b68:	e8 63 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b72:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b75:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	89 d8                	mov    %ebx,%eax
80101b79:	8b 5d e0             	mov    -0x20(%ebp),%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b7c:	89 55 d8             	mov    %edx,-0x28(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7f:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b84:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b86:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8e:	29 f3                	sub    %esi,%ebx
80101b90:	39 d9                	cmp    %ebx,%ecx
80101b92:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b95:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101b98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9c:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b9e:	89 0c 24             	mov    %ecx,(%esp)
80101ba1:	e8 aa 2c 00 00       	call   80104850 <memmove>
    brelse(bp);
80101ba6:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101ba9:	89 14 24             	mov    %edx,(%esp)
80101bac:	e8 3f e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb1:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bb4:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bb7:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101bba:	77 94                	ja     80101b50 <readi+0x60>
  }
  return n;
80101bbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bbf:	83 c4 2c             	add    $0x2c,%esp
80101bc2:	5b                   	pop    %ebx
80101bc3:	5e                   	pop    %esi
80101bc4:	5f                   	pop    %edi
80101bc5:	5d                   	pop    %ebp
80101bc6:	c3                   	ret    
80101bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bce:	66 90                	xchg   %ax,%ax
    n = ip->size - off;
80101bd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101bd3:	29 d0                	sub    %edx,%eax
80101bd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101bd8:	e9 67 ff ff ff       	jmp    80101b44 <readi+0x54>
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101be0:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 1a                	ja     80101c04 <readi+0x114>
80101bea:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 0f                	je     80101c04 <readi+0x114>
    return devsw[ip->major].read(ip, dst, n);
80101bf5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bf8:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bfb:	83 c4 2c             	add    $0x2c,%esp
80101bfe:	5b                   	pop    %ebx
80101bff:	5e                   	pop    %esi
80101c00:	5f                   	pop    %edi
80101c01:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c02:	ff e0                	jmp    *%eax
      return -1;
80101c04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c09:	eb b4                	jmp    80101bbf <readi+0xcf>
80101c0b:	be 01 00 00 00       	mov    $0x1,%esi
80101c10:	e9 1f ff ff ff       	jmp    80101b34 <readi+0x44>
80101c15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 2c             	sub    $0x2c,%esp
80101c29:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2c:	8b 7d 08             	mov    0x8(%ebp),%edi
80101c2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c35:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
80101c3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101c3d:	8b 45 14             	mov    0x14(%ebp),%eax
80101c40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(ip->type == T_DEV){
80101c43:	0f 84 d7 00 00 00    	je     80101d20 <writei+0x100>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c49:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c4c:	39 77 58             	cmp    %esi,0x58(%edi)
80101c4f:	0f 82 0b 01 00 00    	jb     80101d60 <writei+0x140>
80101c55:	31 c0                	xor    %eax,%eax
80101c57:	03 75 dc             	add    -0x24(%ebp),%esi
80101c5a:	89 f2                	mov    %esi,%edx
80101c5c:	0f 82 05 01 00 00    	jb     80101d67 <writei+0x147>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c62:	85 c0                	test   %eax,%eax
80101c64:	0f 85 f6 00 00 00    	jne    80101d60 <writei+0x140>
80101c6a:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c70:	0f 87 ea 00 00 00    	ja     80101d60 <writei+0x140>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c7d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101c80:	85 c9                	test   %ecx,%ecx
80101c82:	0f 84 85 00 00 00    	je     80101d0d <writei+0xed>
80101c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c93:	89 f8                	mov    %edi,%eax
80101c95:	89 da                	mov    %ebx,%edx
80101c97:	c1 ea 09             	shr    $0x9,%edx
80101c9a:	e8 f1 f7 ff ff       	call   80101490 <bmap>
80101c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ca3:	8b 07                	mov    (%edi),%eax
80101ca5:	89 04 24             	mov    %eax,(%esp)
80101ca8:	e8 23 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cb0:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cb5:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb8:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cba:	89 d8                	mov    %ebx,%eax
80101cbc:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101cbf:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cc4:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cc6:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101cca:	89 04 24             	mov    %eax,(%esp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ccd:	29 d3                	sub    %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ccf:	8b 55 d8             	mov    -0x28(%ebp),%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101cd2:	39 d9                	cmp    %ebx,%ecx
80101cd4:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101cdb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cdf:	e8 6c 2b 00 00       	call   80104850 <memmove>
    log_write(bp);
80101ce4:	89 34 24             	mov    %esi,(%esp)
80101ce7:	e8 c4 12 00 00       	call   80102fb0 <log_write>
    brelse(bp);
80101cec:	89 34 24             	mov    %esi,(%esp)
80101cef:	e8 fc e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf4:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cf7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cfa:	01 5d d8             	add    %ebx,-0x28(%ebp)
80101cfd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d00:	39 4d dc             	cmp    %ecx,-0x24(%ebp)
80101d03:	77 8b                	ja     80101c90 <writei+0x70>
  }

  if(n > 0 && off > ip->size){
80101d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d08:	3b 47 58             	cmp    0x58(%edi),%eax
80101d0b:	77 43                	ja     80101d50 <writei+0x130>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80101d10:	83 c4 2c             	add    $0x2c,%esp
80101d13:	5b                   	pop    %ebx
80101d14:	5e                   	pop    %esi
80101d15:	5f                   	pop    %edi
80101d16:	5d                   	pop    %ebp
80101d17:	c3                   	ret    
80101d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1f:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d20:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101d24:	66 83 f8 09          	cmp    $0x9,%ax
80101d28:	77 36                	ja     80101d60 <writei+0x140>
80101d2a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101d31:	85 c0                	test   %eax,%eax
80101d33:	74 2b                	je     80101d60 <writei+0x140>
    return devsw[ip->major].write(ip, src, n);
80101d35:	8b 7d dc             	mov    -0x24(%ebp),%edi
80101d38:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d3b:	83 c4 2c             	add    $0x2c,%esp
80101d3e:	5b                   	pop    %ebx
80101d3f:	5e                   	pop    %esi
80101d40:	5f                   	pop    %edi
80101d41:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d42:	ff e0                	jmp    *%eax
80101d44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
    ip->size = off;
80101d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d53:	89 47 58             	mov    %eax,0x58(%edi)
    iupdate(ip);
80101d56:	89 3c 24             	mov    %edi,(%esp)
80101d59:	e8 e2 f9 ff ff       	call   80101740 <iupdate>
80101d5e:	eb ad                	jmp    80101d0d <writei+0xed>
      return -1;
80101d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d65:	eb a9                	jmp    80101d10 <writei+0xf0>
80101d67:	b8 01 00 00 00       	mov    $0x1,%eax
80101d6c:	e9 f1 fe ff ff       	jmp    80101c62 <writei+0x42>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d80:	55                   	push   %ebp
  return strncmp(s, t, DIRSIZ);
80101d81:	b8 0e 00 00 00       	mov    $0xe,%eax
{
80101d86:	89 e5                	mov    %esp,%ebp
80101d88:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101d8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80101d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d92:	89 44 24 04          	mov    %eax,0x4(%esp)
80101d96:	8b 45 08             	mov    0x8(%ebp),%eax
80101d99:	89 04 24             	mov    %eax,(%esp)
80101d9c:	e8 1f 2b 00 00       	call   801048c0 <strncmp>
}
80101da1:	c9                   	leave  
80101da2:	c3                   	ret    
80101da3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101db0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	83 ec 2c             	sub    $0x2c,%esp
80101db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101dc1:	0f 85 a4 00 00 00    	jne    80101e6b <dirlookup+0xbb>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101dc7:	8b 43 58             	mov    0x58(%ebx),%eax
80101dca:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dcd:	31 ff                	xor    %edi,%edi
80101dcf:	85 c0                	test   %eax,%eax
80101dd1:	74 59                	je     80101e2c <dirlookup+0x7c>
80101dd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101de0:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101de4:	b9 10 00 00 00       	mov    $0x10,%ecx
80101de9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101ded:	89 74 24 04          	mov    %esi,0x4(%esp)
80101df1:	89 1c 24             	mov    %ebx,(%esp)
80101df4:	e8 f7 fc ff ff       	call   80101af0 <readi>
80101df9:	83 f8 10             	cmp    $0x10,%eax
80101dfc:	75 61                	jne    80101e5f <dirlookup+0xaf>
      panic("dirlookup read");
    if(de.inum == 0)
80101dfe:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e03:	74 1f                	je     80101e24 <dirlookup+0x74>
  return strncmp(s, t, DIRSIZ);
80101e05:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e08:	ba 0e 00 00 00       	mov    $0xe,%edx
80101e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e11:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e14:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e18:	89 04 24             	mov    %eax,(%esp)
80101e1b:	e8 a0 2a 00 00       	call   801048c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e20:	85 c0                	test   %eax,%eax
80101e22:	74 1c                	je     80101e40 <dirlookup+0x90>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e24:	83 c7 10             	add    $0x10,%edi
80101e27:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e2a:	72 b4                	jb     80101de0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e2c:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101e2f:	31 c0                	xor    %eax,%eax
}
80101e31:	5b                   	pop    %ebx
80101e32:	5e                   	pop    %esi
80101e33:	5f                   	pop    %edi
80101e34:	5d                   	pop    %ebp
80101e35:	c3                   	ret    
80101e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e3d:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101e40:	8b 45 10             	mov    0x10(%ebp),%eax
80101e43:	85 c0                	test   %eax,%eax
80101e45:	74 05                	je     80101e4c <dirlookup+0x9c>
        *poff = off;
80101e47:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e4c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e50:	8b 03                	mov    (%ebx),%eax
80101e52:	e8 39 f5 ff ff       	call   80101390 <iget>
}
80101e57:	83 c4 2c             	add    $0x2c,%esp
80101e5a:	5b                   	pop    %ebx
80101e5b:	5e                   	pop    %esi
80101e5c:	5f                   	pop    %edi
80101e5d:	5d                   	pop    %ebp
80101e5e:	c3                   	ret    
      panic("dirlookup read");
80101e5f:	c7 04 24 b9 73 10 80 	movl   $0x801073b9,(%esp)
80101e66:	e8 f5 e4 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101e6b:	c7 04 24 a7 73 10 80 	movl   $0x801073a7,(%esp)
80101e72:	e8 e9 e4 ff ff       	call   80100360 <panic>
80101e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e7e:	66 90                	xchg   %ax,%ax

80101e80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	89 c3                	mov    %eax,%ebx
80101e88:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e94:	0f 84 66 01 00 00    	je     80102000 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e9a:	e8 61 1b 00 00       	call   80103a00 <myproc>
80101e9f:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ea2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ea9:	e8 e2 27 00 00       	call   80104690 <acquire>
  ip->ref++;
80101eae:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101eb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101eb8:	e8 83 28 00 00       	call   80104740 <release>
  return ip;
80101ebd:	89 df                	mov    %ebx,%edi
80101ebf:	eb 10                	jmp    80101ed1 <namex+0x51>
80101ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecf:	90                   	nop
    path++;
80101ed0:	47                   	inc    %edi
  while(*path == '/')
80101ed1:	0f b6 07             	movzbl (%edi),%eax
80101ed4:	3c 2f                	cmp    $0x2f,%al
80101ed6:	74 f8                	je     80101ed0 <namex+0x50>
  if(*path == 0)
80101ed8:	84 c0                	test   %al,%al
80101eda:	0f 84 f0 00 00 00    	je     80101fd0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101ee0:	0f b6 07             	movzbl (%edi),%eax
80101ee3:	84 c0                	test   %al,%al
80101ee5:	0f 84 05 01 00 00    	je     80101ff0 <namex+0x170>
80101eeb:	3c 2f                	cmp    $0x2f,%al
80101eed:	89 fb                	mov    %edi,%ebx
80101eef:	0f 84 fb 00 00 00    	je     80101ff0 <namex+0x170>
80101ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101f04:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80101f05:	3c 2f                	cmp    $0x2f,%al
80101f07:	74 04                	je     80101f0d <namex+0x8d>
80101f09:	84 c0                	test   %al,%al
80101f0b:	75 f3                	jne    80101f00 <namex+0x80>
  len = path - s;
80101f0d:	89 d8                	mov    %ebx,%eax
80101f0f:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101f11:	83 f8 0d             	cmp    $0xd,%eax
80101f14:	0f 8e 86 00 00 00    	jle    80101fa0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101f1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101f1e:	b8 0e 00 00 00       	mov    $0xe,%eax
    path++;
80101f23:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101f25:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f2c:	89 04 24             	mov    %eax,(%esp)
80101f2f:	e8 1c 29 00 00       	call   80104850 <memmove>
  while(*path == '/')
80101f34:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f37:	75 0d                	jne    80101f46 <namex+0xc6>
80101f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f40:	47                   	inc    %edi
  while(*path == '/')
80101f41:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f44:	74 fa                	je     80101f40 <namex+0xc0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f46:	89 34 24             	mov    %esi,(%esp)
80101f49:	e8 b2 f8 ff ff       	call   80101800 <ilock>
    if(ip->type != T_DIR){
80101f4e:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f53:	0f 85 c7 00 00 00    	jne    80102020 <namex+0x1a0>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f59:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f5c:	85 db                	test   %ebx,%ebx
80101f5e:	74 09                	je     80101f69 <namex+0xe9>
80101f60:	80 3f 00             	cmpb   $0x0,(%edi)
80101f63:	0f 84 f7 00 00 00    	je     80102060 <namex+0x1e0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f69:	89 34 24             	mov    %esi,(%esp)
80101f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f6f:	31 c9                	xor    %ecx,%ecx
80101f71:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101f75:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f79:	e8 32 fe ff ff       	call   80101db0 <dirlookup>
  iunlock(ip);
80101f7e:	89 34 24             	mov    %esi,(%esp)
    if((next = dirlookup(ip, name, 0)) == 0){
80101f81:	85 c0                	test   %eax,%eax
80101f83:	89 c3                	mov    %eax,%ebx
80101f85:	0f 84 b5 00 00 00    	je     80102040 <namex+0x1c0>
  iunlock(ip);
80101f8b:	e8 50 f9 ff ff       	call   801018e0 <iunlock>
  iput(ip);
80101f90:	89 34 24             	mov    %esi,(%esp)
80101f93:	89 de                	mov    %ebx,%esi
80101f95:	e8 96 f9 ff ff       	call   80101930 <iput>
  while(*path == '/')
80101f9a:	e9 32 ff ff ff       	jmp    80101ed1 <namex+0x51>
80101f9f:	90                   	nop
80101fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fa3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101fa6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101fa9:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fb0:	89 7c 24 04          	mov    %edi,0x4(%esp)
    name[len] = 0;
80101fb4:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101fb6:	89 04 24             	mov    %eax,(%esp)
80101fb9:	e8 92 28 00 00       	call   80104850 <memmove>
    name[len] = 0;
80101fbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fc1:	c6 00 00             	movb   $0x0,(%eax)
80101fc4:	e9 6b ff ff ff       	jmp    80101f34 <namex+0xb4>
80101fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fd3:	85 d2                	test   %edx,%edx
80101fd5:	0f 85 a5 00 00 00    	jne    80102080 <namex+0x200>
    iput(ip);
    return 0;
  }
  return ip;
}
80101fdb:	83 c4 2c             	add    $0x2c,%esp
80101fde:	89 f0                	mov    %esi,%eax
80101fe0:	5b                   	pop    %ebx
80101fe1:	5e                   	pop    %esi
80101fe2:	5f                   	pop    %edi
80101fe3:	5d                   	pop    %ebp
80101fe4:	c3                   	ret    
80101fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101ff0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ff3:	89 fb                	mov    %edi,%ebx
80101ff5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ff8:	31 c0                	xor    %eax,%eax
80101ffa:	eb ad                	jmp    80101fa9 <namex+0x129>
80101ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = iget(ROOTDEV, ROOTINO);
80102000:	ba 01 00 00 00       	mov    $0x1,%edx
80102005:	b8 01 00 00 00       	mov    $0x1,%eax
8010200a:	e8 81 f3 ff ff       	call   80101390 <iget>
8010200f:	89 c6                	mov    %eax,%esi
80102011:	e9 a7 fe ff ff       	jmp    80101ebd <namex+0x3d>
80102016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010201d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlock(ip);
80102020:	89 34 24             	mov    %esi,(%esp)
80102023:	e8 b8 f8 ff ff       	call   801018e0 <iunlock>
  iput(ip);
80102028:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010202b:	31 f6                	xor    %esi,%esi
  iput(ip);
8010202d:	e8 fe f8 ff ff       	call   80101930 <iput>
}
80102032:	83 c4 2c             	add    $0x2c,%esp
80102035:	89 f0                	mov    %esi,%eax
80102037:	5b                   	pop    %ebx
80102038:	5e                   	pop    %esi
80102039:	5f                   	pop    %edi
8010203a:	5d                   	pop    %ebp
8010203b:	c3                   	ret    
8010203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102040:	e8 9b f8 ff ff       	call   801018e0 <iunlock>
  iput(ip);
80102045:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102048:	31 f6                	xor    %esi,%esi
  iput(ip);
8010204a:	e8 e1 f8 ff ff       	call   80101930 <iput>
}
8010204f:	83 c4 2c             	add    $0x2c,%esp
80102052:	89 f0                	mov    %esi,%eax
80102054:	5b                   	pop    %ebx
80102055:	5e                   	pop    %esi
80102056:	5f                   	pop    %edi
80102057:	5d                   	pop    %ebp
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      iunlock(ip);
80102060:	89 34 24             	mov    %esi,(%esp)
80102063:	e8 78 f8 ff ff       	call   801018e0 <iunlock>
}
80102068:	83 c4 2c             	add    $0x2c,%esp
8010206b:	89 f0                	mov    %esi,%eax
8010206d:	5b                   	pop    %ebx
8010206e:	5e                   	pop    %esi
8010206f:	5f                   	pop    %edi
80102070:	5d                   	pop    %ebp
80102071:	c3                   	ret    
80102072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iput(ip);
80102080:	89 34 24             	mov    %esi,(%esp)
    return 0;
80102083:	31 f6                	xor    %esi,%esi
    iput(ip);
80102085:	e8 a6 f8 ff ff       	call   80101930 <iput>
    return 0;
8010208a:	e9 4c ff ff ff       	jmp    80101fdb <namex+0x15b>
8010208f:	90                   	nop

80102090 <dirlink>:
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102096:	31 db                	xor    %ebx,%ebx
{
80102098:	83 ec 2c             	sub    $0x2c,%esp
  if((ip = dirlookup(dp, name, 0)) != 0){
8010209b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
{
8010209f:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
801020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a5:	89 3c 24             	mov    %edi,(%esp)
801020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ac:	e8 ff fc ff ff       	call   80101db0 <dirlookup>
801020b1:	85 c0                	test   %eax,%eax
801020b3:	0f 85 8e 00 00 00    	jne    80102147 <dirlink+0xb7>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020b9:	8b 5f 58             	mov    0x58(%edi),%ebx
801020bc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020bf:	85 db                	test   %ebx,%ebx
801020c1:	74 3a                	je     801020fd <dirlink+0x6d>
801020c3:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020c6:	31 db                	xor    %ebx,%ebx
801020c8:	eb 0e                	jmp    801020d8 <dirlink+0x48>
801020ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020d0:	83 c3 10             	add    $0x10,%ebx
801020d3:	3b 5f 58             	cmp    0x58(%edi),%ebx
801020d6:	73 25                	jae    801020fd <dirlink+0x6d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801020dc:	b9 10 00 00 00       	mov    $0x10,%ecx
801020e1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801020e5:	89 74 24 04          	mov    %esi,0x4(%esp)
801020e9:	89 3c 24             	mov    %edi,(%esp)
801020ec:	e8 ff f9 ff ff       	call   80101af0 <readi>
801020f1:	83 f8 10             	cmp    $0x10,%eax
801020f4:	75 60                	jne    80102156 <dirlink+0xc6>
    if(de.inum == 0)
801020f6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020fb:	75 d3                	jne    801020d0 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
801020fd:	b8 0e 00 00 00       	mov    $0xe,%eax
80102102:	89 44 24 08          	mov    %eax,0x8(%esp)
80102106:	8b 45 0c             	mov    0xc(%ebp),%eax
80102109:	89 44 24 04          	mov    %eax,0x4(%esp)
8010210d:	8d 45 da             	lea    -0x26(%ebp),%eax
80102110:	89 04 24             	mov    %eax,(%esp)
80102113:	e8 f8 27 00 00       	call   80104910 <strncpy>
  de.inum = inum;
80102118:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010211b:	ba 10 00 00 00       	mov    $0x10,%edx
80102120:	89 54 24 0c          	mov    %edx,0xc(%esp)
80102124:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102128:	89 74 24 04          	mov    %esi,0x4(%esp)
8010212c:	89 3c 24             	mov    %edi,(%esp)
  de.inum = inum;
8010212f:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102133:	e8 e8 fa ff ff       	call   80101c20 <writei>
80102138:	83 f8 10             	cmp    $0x10,%eax
8010213b:	75 25                	jne    80102162 <dirlink+0xd2>
  return 0;
8010213d:	31 c0                	xor    %eax,%eax
}
8010213f:	83 c4 2c             	add    $0x2c,%esp
80102142:	5b                   	pop    %ebx
80102143:	5e                   	pop    %esi
80102144:	5f                   	pop    %edi
80102145:	5d                   	pop    %ebp
80102146:	c3                   	ret    
    iput(ip);
80102147:	89 04 24             	mov    %eax,(%esp)
8010214a:	e8 e1 f7 ff ff       	call   80101930 <iput>
    return -1;
8010214f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102154:	eb e9                	jmp    8010213f <dirlink+0xaf>
      panic("dirlink read");
80102156:	c7 04 24 c8 73 10 80 	movl   $0x801073c8,(%esp)
8010215d:	e8 fe e1 ff ff       	call   80100360 <panic>
    panic("dirlink");
80102162:	c7 04 24 a2 79 10 80 	movl   $0x801079a2,(%esp)
80102169:	e8 f2 e1 ff ff       	call   80100360 <panic>
8010216e:	66 90                	xchg   %ax,%ax

80102170 <namei>:

struct inode*
namei(char *path)
{
80102170:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102171:	31 d2                	xor    %edx,%edx
{
80102173:	89 e5                	mov    %esp,%ebp
80102175:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102178:	8b 45 08             	mov    0x8(%ebp),%eax
8010217b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010217e:	e8 fd fc ff ff       	call   80101e80 <namex>
}
80102183:	c9                   	leave  
80102184:	c3                   	ret    
80102185:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102190 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102190:	55                   	push   %ebp
  return namex(path, 1, name);
80102191:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102196:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010219b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010219e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010219f:	e9 dc fc ff ff       	jmp    80101e80 <namex>
801021a4:	66 90                	xchg   %ax,%ax
801021a6:	66 90                	xchg   %ax,%ax
801021a8:	66 90                	xchg   %ax,%ax
801021aa:	66 90                	xchg   %ax,%ax
801021ac:	66 90                	xchg   %ax,%ax
801021ae:	66 90                	xchg   %ax,%ax

801021b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	56                   	push   %esi
801021b4:	53                   	push   %ebx
801021b5:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
801021b8:	85 c0                	test   %eax,%eax
801021ba:	0f 84 a8 00 00 00    	je     80102268 <idestart+0xb8>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021c0:	8b 48 08             	mov    0x8(%eax),%ecx
801021c3:	89 c6                	mov    %eax,%esi
801021c5:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
801021cb:	0f 87 8b 00 00 00    	ja     8010225c <idestart+0xac>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d1:	bb f7 01 00 00       	mov    $0x1f7,%ebx
801021d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021dd:	8d 76 00             	lea    0x0(%esi),%esi
801021e0:	89 da                	mov    %ebx,%edx
801021e2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e3:	24 c0                	and    $0xc0,%al
801021e5:	3c 40                	cmp    $0x40,%al
801021e7:	75 f7                	jne    801021e0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e9:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021ee:	31 c0                	xor    %eax,%eax
801021f0:	ee                   	out    %al,(%dx)
801021f1:	b0 01                	mov    $0x1,%al
801021f3:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021f8:	ee                   	out    %al,(%dx)
801021f9:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021fe:	88 c8                	mov    %cl,%al
80102200:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102201:	c1 f9 08             	sar    $0x8,%ecx
80102204:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102209:	89 c8                	mov    %ecx,%eax
8010220b:	ee                   	out    %al,(%dx)
8010220c:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102211:	31 c0                	xor    %eax,%eax
80102213:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102214:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102218:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221d:	c0 e0 04             	shl    $0x4,%al
80102220:	24 10                	and    $0x10,%al
80102222:	0c e0                	or     $0xe0,%al
80102224:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102225:	f6 06 04             	testb  $0x4,(%esi)
80102228:	75 16                	jne    80102240 <idestart+0x90>
8010222a:	b0 20                	mov    $0x20,%al
8010222c:	89 da                	mov    %ebx,%edx
8010222e:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010222f:	83 c4 10             	add    $0x10,%esp
80102232:	5b                   	pop    %ebx
80102233:	5e                   	pop    %esi
80102234:	5d                   	pop    %ebp
80102235:	c3                   	ret    
80102236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223d:	8d 76 00             	lea    0x0(%esi),%esi
80102240:	b0 30                	mov    $0x30,%al
80102242:	89 da                	mov    %ebx,%edx
80102244:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102245:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010224a:	83 c6 5c             	add    $0x5c,%esi
8010224d:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102252:	fc                   	cld    
80102253:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102255:	83 c4 10             	add    $0x10,%esp
80102258:	5b                   	pop    %ebx
80102259:	5e                   	pop    %esi
8010225a:	5d                   	pop    %ebp
8010225b:	c3                   	ret    
    panic("incorrect blockno");
8010225c:	c7 04 24 34 74 10 80 	movl   $0x80107434,(%esp)
80102263:	e8 f8 e0 ff ff       	call   80100360 <panic>
    panic("idestart");
80102268:	c7 04 24 2b 74 10 80 	movl   $0x8010742b,(%esp)
8010226f:	e8 ec e0 ff ff       	call   80100360 <panic>
80102274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <ideinit>:
{
80102280:	55                   	push   %ebp
  initlock(&idelock, "ide");
80102281:	ba 46 74 10 80       	mov    $0x80107446,%edx
{
80102286:	89 e5                	mov    %esp,%ebp
80102288:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
8010228b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010228f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102296:	e8 85 22 00 00       	call   80104520 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010229b:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801022a0:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801022a7:	48                   	dec    %eax
801022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ac:	e8 8f 02 00 00       	call   80102540 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022bd:	8d 76 00             	lea    0x0(%esi),%esi
801022c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c1:	24 c0                	and    $0xc0,%al
801022c3:	3c 40                	cmp    $0x40,%al
801022c5:	75 f9                	jne    801022c0 <ideinit+0x40>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022c7:	b0 f0                	mov    $0xf0,%al
801022c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ce:	ee                   	out    %al,(%dx)
801022cf:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d4:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d9:	eb 08                	jmp    801022e3 <ideinit+0x63>
801022db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop
  for(i=0; i<1000; i++){
801022e0:	49                   	dec    %ecx
801022e1:	74 0f                	je     801022f2 <ideinit+0x72>
801022e3:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022e4:	84 c0                	test   %al,%al
801022e6:	74 f8                	je     801022e0 <ideinit+0x60>
      havedisk1 = 1;
801022e8:	b8 01 00 00 00       	mov    $0x1,%eax
801022ed:	a3 60 a5 10 80       	mov    %eax,0x8010a560
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022f2:	b0 e0                	mov    $0xe0,%al
801022f4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022f9:	ee                   	out    %al,(%dx)
}
801022fa:	c9                   	leave  
801022fb:	c3                   	ret    
801022fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102300 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	57                   	push   %edi
80102304:	56                   	push   %esi
80102305:	53                   	push   %ebx
80102306:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102309:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102310:	e8 7b 23 00 00       	call   80104690 <acquire>

  if((b = idequeue) == 0){
80102315:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010231b:	85 db                	test   %ebx,%ebx
8010231d:	74 60                	je     8010237f <ideintr+0x7f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010231f:	8b 43 58             	mov    0x58(%ebx),%eax
80102322:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102327:	8b 33                	mov    (%ebx),%esi
80102329:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010232f:	75 30                	jne    80102361 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102331:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233d:	8d 76 00             	lea    0x0(%esi),%esi
80102340:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102341:	88 c1                	mov    %al,%cl
80102343:	80 e1 c0             	and    $0xc0,%cl
80102346:	80 f9 40             	cmp    $0x40,%cl
80102349:	75 f5                	jne    80102340 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010234b:	a8 21                	test   $0x21,%al
8010234d:	75 12                	jne    80102361 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010234f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102352:	b9 80 00 00 00       	mov    $0x80,%ecx
80102357:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010235c:	fc                   	cld    
8010235d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010235f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102361:	83 e6 fb             	and    $0xfffffffb,%esi
80102364:	83 ce 02             	or     $0x2,%esi
80102367:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102369:	89 1c 24             	mov    %ebx,(%esp)
8010236c:	e8 ef 1d 00 00       	call   80104160 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102371:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102376:	85 c0                	test   %eax,%eax
80102378:	74 05                	je     8010237f <ideintr+0x7f>
    idestart(idequeue);
8010237a:	e8 31 fe ff ff       	call   801021b0 <idestart>
    release(&idelock);
8010237f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102386:	e8 b5 23 00 00       	call   80104740 <release>

  release(&idelock);
}
8010238b:	83 c4 1c             	add    $0x1c,%esp
8010238e:	5b                   	pop    %ebx
8010238f:	5e                   	pop    %esi
80102390:	5f                   	pop    %edi
80102391:	5d                   	pop    %ebp
80102392:	c3                   	ret    
80102393:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	53                   	push   %ebx
801023a4:	83 ec 14             	sub    $0x14,%esp
801023a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801023ad:	89 04 24             	mov    %eax,(%esp)
801023b0:	e8 0b 21 00 00       	call   801044c0 <holdingsleep>
801023b5:	85 c0                	test   %eax,%eax
801023b7:	0f 84 c2 00 00 00    	je     8010247f <iderw+0xdf>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023bd:	8b 03                	mov    (%ebx),%eax
801023bf:	83 e0 06             	and    $0x6,%eax
801023c2:	83 f8 02             	cmp    $0x2,%eax
801023c5:	0f 84 a8 00 00 00    	je     80102473 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023cb:	8b 4b 04             	mov    0x4(%ebx),%ecx
801023ce:	85 c9                	test   %ecx,%ecx
801023d0:	74 0e                	je     801023e0 <iderw+0x40>
801023d2:	8b 15 60 a5 10 80    	mov    0x8010a560,%edx
801023d8:	85 d2                	test   %edx,%edx
801023da:	0f 84 87 00 00 00    	je     80102467 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023e0:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801023e7:	e8 a4 22 00 00       	call   80104690 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ec:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801023f1:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023f8:	85 c0                	test   %eax,%eax
801023fa:	74 64                	je     80102460 <iderw+0xc0>
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102400:	89 c2                	mov    %eax,%edx
80102402:	8b 40 58             	mov    0x58(%eax),%eax
80102405:	85 c0                	test   %eax,%eax
80102407:	75 f7                	jne    80102400 <iderw+0x60>
80102409:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010240c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010240e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102414:	75 1b                	jne    80102431 <iderw+0x91>
80102416:	eb 38                	jmp    80102450 <iderw+0xb0>
80102418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80102420:	89 1c 24             	mov    %ebx,(%esp)
80102423:	b8 80 a5 10 80       	mov    $0x8010a580,%eax
80102428:	89 44 24 04          	mov    %eax,0x4(%esp)
8010242c:	e8 5f 1b 00 00       	call   80103f90 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102431:	8b 03                	mov    (%ebx),%eax
80102433:	83 e0 06             	and    $0x6,%eax
80102436:	83 f8 02             	cmp    $0x2,%eax
80102439:	75 e5                	jne    80102420 <iderw+0x80>
  }


  release(&idelock);
8010243b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102442:	83 c4 14             	add    $0x14,%esp
80102445:	5b                   	pop    %ebx
80102446:	5d                   	pop    %ebp
  release(&idelock);
80102447:	e9 f4 22 00 00       	jmp    80104740 <release>
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 59 fd ff ff       	call   801021b0 <idestart>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102457:	eb d8                	jmp    80102431 <iderw+0x91>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102465:	eb a5                	jmp    8010240c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102467:	c7 04 24 75 74 10 80 	movl   $0x80107475,(%esp)
8010246e:	e8 ed de ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102473:	c7 04 24 60 74 10 80 	movl   $0x80107460,(%esp)
8010247a:	e8 e1 de ff ff       	call   80100360 <panic>
    panic("iderw: buf not locked");
8010247f:	c7 04 24 4a 74 10 80 	movl   $0x8010744a,(%esp)
80102486:	e8 d5 de ff ff       	call   80100360 <panic>
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102490:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102491:	b8 00 00 c0 fe       	mov    $0xfec00000,%eax
{
80102496:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102498:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010249d:	56                   	push   %esi
8010249e:	53                   	push   %ebx
8010249f:	83 ec 10             	sub    $0x10,%esp
  ioapic = (volatile struct ioapic*)IOAPIC;
801024a2:	a3 34 26 11 80       	mov    %eax,0x80112634
  ioapic->reg = reg;
801024a7:	89 15 00 00 c0 fe    	mov    %edx,0xfec00000
  return ioapic->data;
801024ad:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024b3:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
801024b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024bc:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024c2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024c9:	c1 e8 10             	shr    $0x10,%eax
801024cc:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024cf:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801024d2:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024d5:	39 c2                	cmp    %eax,%edx
801024d7:	74 12                	je     801024eb <ioapicinit+0x5b>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024d9:	c7 04 24 94 74 10 80 	movl   $0x80107494,(%esp)
801024e0:	e8 9b e1 ff ff       	call   80100680 <cprintf>
801024e5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801024eb:	83 c6 21             	add    $0x21,%esi
{
801024ee:	ba 10 00 00 00       	mov    $0x10,%edx
801024f3:	b8 20 00 00 00       	mov    $0x20,%eax
801024f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ff:	90                   	nop
  ioapic->reg = reg;
80102500:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102502:	89 c3                	mov    %eax,%ebx
80102504:	40                   	inc    %eax
  ioapic->data = data;
80102505:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010250b:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102511:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102514:	8d 5a 01             	lea    0x1(%edx),%ebx
80102517:	83 c2 02             	add    $0x2,%edx
8010251a:	89 19                	mov    %ebx,(%ecx)
  for(i = 0; i <= maxintr; i++){
8010251c:	39 f0                	cmp    %esi,%eax
  ioapic->data = data;
8010251e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102524:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010252b:	75 d3                	jne    80102500 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	5b                   	pop    %ebx
80102531:	5e                   	pop    %esi
80102532:	5d                   	pop    %ebp
80102533:	c3                   	ret    
80102534:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010253f:	90                   	nop

80102540 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102540:	55                   	push   %ebp
  ioapic->reg = reg;
80102541:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102547:	89 e5                	mov    %esp,%ebp
80102549:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010254c:	8d 50 20             	lea    0x20(%eax),%edx
8010254f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102553:	89 01                	mov    %eax,(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102555:	40                   	inc    %eax
  ioapic->data = data;
80102556:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010255c:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255f:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102562:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102564:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102569:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010256c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010256f:	5d                   	pop    %ebp
80102570:	c3                   	ret    
80102571:	66 90                	xchg   %ax,%ax
80102573:	66 90                	xchg   %ax,%ax
80102575:	66 90                	xchg   %ax,%ax
80102577:	66 90                	xchg   %ax,%ax
80102579:	66 90                	xchg   %ax,%ax
8010257b:	66 90                	xchg   %ax,%ax
8010257d:	66 90                	xchg   %ax,%ax
8010257f:	90                   	nop

80102580 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	83 ec 14             	sub    $0x14,%esp
80102587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010258a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102590:	75 7f                	jne    80102611 <kfree+0x91>
80102592:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80102598:	72 77                	jb     80102611 <kfree+0x91>
8010259a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025a5:	77 6a                	ja     80102611 <kfree+0x91>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025a7:	89 1c 24             	mov    %ebx,(%esp)
801025aa:	ba 00 10 00 00       	mov    $0x1000,%edx
801025af:	b9 01 00 00 00       	mov    $0x1,%ecx
801025b4:	89 54 24 08          	mov    %edx,0x8(%esp)
801025b8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801025bc:	e8 cf 21 00 00       	call   80104790 <memset>

  if(kmem.use_lock)
801025c1:	a1 74 26 11 80       	mov    0x80112674,%eax
801025c6:	85 c0                	test   %eax,%eax
801025c8:	75 26                	jne    801025f0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025ca:	a1 78 26 11 80       	mov    0x80112678,%eax
801025cf:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
801025d1:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801025d7:	a1 74 26 11 80       	mov    0x80112674,%eax
801025dc:	85 c0                	test   %eax,%eax
801025de:	75 20                	jne    80102600 <kfree+0x80>
    release(&kmem.lock);
}
801025e0:	83 c4 14             	add    $0x14,%esp
801025e3:	5b                   	pop    %ebx
801025e4:	5d                   	pop    %ebp
801025e5:	c3                   	ret    
801025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ed:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801025f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801025f7:	e8 94 20 00 00       	call   80104690 <acquire>
801025fc:	eb cc                	jmp    801025ca <kfree+0x4a>
801025fe:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102600:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102607:	83 c4 14             	add    $0x14,%esp
8010260a:	5b                   	pop    %ebx
8010260b:	5d                   	pop    %ebp
    release(&kmem.lock);
8010260c:	e9 2f 21 00 00       	jmp    80104740 <release>
    panic("kfree");
80102611:	c7 04 24 c6 74 10 80 	movl   $0x801074c6,(%esp)
80102618:	e8 43 dd ff ff       	call   80100360 <panic>
8010261d:	8d 76 00             	lea    0x0(%esi),%esi

80102620 <freerange>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102628:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010262b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010262e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102634:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102640:	39 de                	cmp    %ebx,%esi
80102642:	72 24                	jb     80102668 <freerange+0x48>
80102644:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010264f:	90                   	nop
    kfree(p);
80102650:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265c:	89 04 24             	mov    %eax,(%esp)
8010265f:	e8 1c ff ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102664:	39 f3                	cmp    %esi,%ebx
80102666:	76 e8                	jbe    80102650 <freerange+0x30>
}
80102668:	83 c4 10             	add    $0x10,%esp
8010266b:	5b                   	pop    %ebx
8010266c:	5e                   	pop    %esi
8010266d:	5d                   	pop    %ebp
8010266e:	c3                   	ret    
8010266f:	90                   	nop

80102670 <kinit1>:
{
80102670:	55                   	push   %ebp
  initlock(&kmem.lock, "kmem");
80102671:	b8 cc 74 10 80       	mov    $0x801074cc,%eax
{
80102676:	89 e5                	mov    %esp,%ebp
80102678:	56                   	push   %esi
80102679:	53                   	push   %ebx
8010267a:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
8010267d:	89 44 24 04          	mov    %eax,0x4(%esp)
{
80102681:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102684:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010268b:	e8 90 1e 00 00       	call   80104520 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102690:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102693:	31 d2                	xor    %edx,%edx
80102695:	89 15 74 26 11 80    	mov    %edx,0x80112674
  p = (char*)PGROUNDUP((uint)vstart);
8010269b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ad:	39 de                	cmp    %ebx,%esi
801026af:	72 27                	jb     801026d8 <kinit1+0x68>
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop
    kfree(p);
801026c0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026cc:	89 04 24             	mov    %eax,(%esp)
801026cf:	e8 ac fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d4:	39 de                	cmp    %ebx,%esi
801026d6:	73 e8                	jae    801026c0 <kinit1+0x50>
}
801026d8:	83 c4 10             	add    $0x10,%esp
801026db:	5b                   	pop    %ebx
801026dc:	5e                   	pop    %esi
801026dd:	5d                   	pop    %ebp
801026de:	c3                   	ret    
801026df:	90                   	nop

801026e0 <kinit2>:
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
801026e4:	53                   	push   %ebx
801026e5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801026e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026ee:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026f4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102700:	39 de                	cmp    %ebx,%esi
80102702:	72 24                	jb     80102728 <kinit2+0x48>
80102704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010270b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010270f:	90                   	nop
    kfree(p);
80102710:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102716:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010271c:	89 04 24             	mov    %eax,(%esp)
8010271f:	e8 5c fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102724:	39 de                	cmp    %ebx,%esi
80102726:	73 e8                	jae    80102710 <kinit2+0x30>
  kmem.use_lock = 1;
80102728:	b8 01 00 00 00       	mov    $0x1,%eax
8010272d:	a3 74 26 11 80       	mov    %eax,0x80112674
}
80102732:	83 c4 10             	add    $0x10,%esp
80102735:	5b                   	pop    %ebx
80102736:	5e                   	pop    %esi
80102737:	5d                   	pop    %ebp
80102738:	c3                   	ret    
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102740 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102740:	a1 74 26 11 80       	mov    0x80112674,%eax
80102745:	85 c0                	test   %eax,%eax
80102747:	75 27                	jne    80102770 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102749:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010274e:	85 c0                	test   %eax,%eax
80102750:	74 0e                	je     80102760 <kalloc+0x20>
    kmem.freelist = r->next;
80102752:	8b 10                	mov    (%eax),%edx
80102754:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010275a:	c3                   	ret    
8010275b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010275f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102760:	c3                   	ret    
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	83 ec 28             	sub    $0x28,%esp
    acquire(&kmem.lock);
80102776:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010277d:	e8 0e 1f 00 00       	call   80104690 <acquire>
  r = kmem.freelist;
80102782:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102787:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010278d:	85 c0                	test   %eax,%eax
8010278f:	74 08                	je     80102799 <kalloc+0x59>
    kmem.freelist = r->next;
80102791:	8b 08                	mov    (%eax),%ecx
80102793:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102799:	85 d2                	test   %edx,%edx
8010279b:	74 12                	je     801027af <kalloc+0x6f>
    release(&kmem.lock);
8010279d:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801027a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027a7:	e8 94 1f 00 00       	call   80104740 <release>
  return (char*)r;
801027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801027af:	c9                   	leave  
801027b0:	c3                   	ret    
801027b1:	66 90                	xchg   %ax,%ax
801027b3:	66 90                	xchg   %ax,%ax
801027b5:	66 90                	xchg   %ax,%ax
801027b7:	66 90                	xchg   %ax,%ax
801027b9:	66 90                	xchg   %ax,%ax
801027bb:	66 90                	xchg   %ax,%ax
801027bd:	66 90                	xchg   %ax,%ax
801027bf:	90                   	nop

801027c0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027c0:	ba 64 00 00 00       	mov    $0x64,%edx
801027c5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027c6:	24 01                	and    $0x1,%al
801027c8:	0f 84 c2 00 00 00    	je     80102890 <kbdgetc+0xd0>
{
801027ce:	55                   	push   %ebp
801027cf:	ba 60 00 00 00       	mov    $0x60,%edx
801027d4:	89 e5                	mov    %esp,%ebp
801027d6:	53                   	push   %ebx
801027d7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
801027d8:	3c e0                	cmp    $0xe0,%al
801027da:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  data = inb(KBDATAP);
801027e0:	0f b6 d0             	movzbl %al,%edx
  if(data == 0xE0){
801027e3:	74 5b                	je     80102840 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801027e5:	89 d9                	mov    %ebx,%ecx
801027e7:	83 e1 40             	and    $0x40,%ecx
801027ea:	84 c0                	test   %al,%al
801027ec:	78 62                	js     80102850 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027ee:	85 c9                	test   %ecx,%ecx
801027f0:	74 08                	je     801027fa <kbdgetc+0x3a>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027f2:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
801027f4:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027f7:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801027fa:	0f b6 8a 00 76 10 80 	movzbl -0x7fef8a00(%edx),%ecx
  shift ^= togglecode[data];
80102801:	0f b6 82 00 75 10 80 	movzbl -0x7fef8b00(%edx),%eax
  shift |= shiftcode[data];
80102808:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010280a:	31 c1                	xor    %eax,%ecx
8010280c:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102812:	89 c8                	mov    %ecx,%eax
80102814:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102817:	f6 c1 08             	test   $0x8,%cl
  c = charcode[shift & (CTL | SHIFT)][data];
8010281a:	8b 04 85 e0 74 10 80 	mov    -0x7fef8b20(,%eax,4),%eax
80102821:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102825:	74 13                	je     8010283a <kbdgetc+0x7a>
    if('a' <= c && c <= 'z')
80102827:	8d 50 9f             	lea    -0x61(%eax),%edx
8010282a:	83 fa 19             	cmp    $0x19,%edx
8010282d:	76 51                	jbe    80102880 <kbdgetc+0xc0>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
8010282f:	8d 50 bf             	lea    -0x41(%eax),%edx
80102832:	83 fa 19             	cmp    $0x19,%edx
80102835:	77 03                	ja     8010283a <kbdgetc+0x7a>
      c += 'a' - 'A';
80102837:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
8010283a:	5b                   	pop    %ebx
8010283b:	5d                   	pop    %ebp
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102840:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102843:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102845:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010284b:	5b                   	pop    %ebx
8010284c:	5d                   	pop    %ebp
8010284d:	c3                   	ret    
8010284e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102850:	85 c9                	test   %ecx,%ecx
80102852:	75 05                	jne    80102859 <kbdgetc+0x99>
80102854:	24 7f                	and    $0x7f,%al
80102856:	0f b6 d0             	movzbl %al,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102859:	0f b6 82 00 76 10 80 	movzbl -0x7fef8a00(%edx),%eax
80102860:	0c 40                	or     $0x40,%al
80102862:	0f b6 c8             	movzbl %al,%ecx
    return 0;
80102865:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102867:	f7 d1                	not    %ecx
80102869:	21 d9                	and    %ebx,%ecx
}
8010286b:	5b                   	pop    %ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010286c:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102872:	5d                   	pop    %ebp
80102873:	c3                   	ret    
80102874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
80102880:	5b                   	pop    %ebx
      c += 'A' - 'a';
80102881:	83 e8 20             	sub    $0x20,%eax
}
80102884:	5d                   	pop    %ebp
80102885:	c3                   	ret    
80102886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80102890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102895:	c3                   	ret    
80102896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289d:	8d 76 00             	lea    0x0(%esi),%esi

801028a0 <kbdintr>:

void
kbdintr(void)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801028a6:	c7 04 24 c0 27 10 80 	movl   $0x801027c0,(%esp)
801028ad:	e8 7e df ff ff       	call   80100830 <consoleintr>
}
801028b2:	c9                   	leave  
801028b3:	c3                   	ret    
801028b4:	66 90                	xchg   %ax,%ax
801028b6:	66 90                	xchg   %ax,%ax
801028b8:	66 90                	xchg   %ax,%ax
801028ba:	66 90                	xchg   %ax,%ax
801028bc:	66 90                	xchg   %ax,%ax
801028be:	66 90                	xchg   %ax,%ax

801028c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	0f 84 c9 00 00 00    	je     80102996 <lapicinit+0xd6>
  lapic[index] = value;
801028cd:	ba 3f 01 00 00       	mov    $0x13f,%edx
801028d2:	b9 0b 00 00 00       	mov    $0xb,%ecx
801028d7:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e0:	89 88 e0 03 00 00    	mov    %ecx,0x3e0(%eax)
801028e6:	b9 80 96 98 00       	mov    $0x989680,%ecx
  lapic[ID];  // wait for write to finish, by reading
801028eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ee:	ba 20 00 02 00       	mov    $0x20020,%edx
801028f3:	89 90 20 03 00 00    	mov    %edx,0x320(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f9:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fc:	89 88 80 03 00 00    	mov    %ecx,0x380(%eax)
80102902:	b9 00 00 01 00       	mov    $0x10000,%ecx
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010290f:	89 90 50 03 00 00    	mov    %edx,0x350(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102915:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102918:	89 88 60 03 00 00    	mov    %ecx,0x360(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010291e:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102921:	8b 50 30             	mov    0x30(%eax),%edx
80102924:	c1 ea 10             	shr    $0x10,%edx
80102927:	f6 c2 fc             	test   $0xfc,%dl
8010292a:	75 74                	jne    801029a0 <lapicinit+0xe0>
  lapic[index] = value;
8010292c:	b9 33 00 00 00       	mov    $0x33,%ecx
80102931:	89 88 70 03 00 00    	mov    %ecx,0x370(%eax)
80102937:	31 c9                	xor    %ecx,%ecx
  lapic[ID];  // wait for write to finish, by reading
80102939:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293c:	31 d2                	xor    %edx,%edx
8010293e:	89 90 80 02 00 00    	mov    %edx,0x280(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102944:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102947:	89 88 80 02 00 00    	mov    %ecx,0x280(%eax)
8010294d:	31 c9                	xor    %ecx,%ecx
  lapic[ID];  // wait for write to finish, by reading
8010294f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102952:	31 d2                	xor    %edx,%edx
80102954:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010295d:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102963:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102966:	ba 00 85 08 00       	mov    $0x88500,%edx
8010296b:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102971:	8b 50 20             	mov    0x20(%eax),%edx
80102974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010297f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102980:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102986:	f6 c6 10             	test   $0x10,%dh
80102989:	75 f5                	jne    80102980 <lapicinit+0xc0>
  lapic[index] = value;
8010298b:	31 d2                	xor    %edx,%edx
8010298d:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102996:	c3                   	ret    
80102997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299e:	66 90                	xchg   %ax,%ax
  lapic[index] = value;
801029a0:	b9 00 00 01 00       	mov    $0x10000,%ecx
801029a5:	89 88 40 03 00 00    	mov    %ecx,0x340(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ab:	8b 50 20             	mov    0x20(%eax),%edx
}
801029ae:	e9 79 ff ff ff       	jmp    8010292c <lapicinit+0x6c>
801029b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029c0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801029c5:	85 c0                	test   %eax,%eax
801029c7:	74 07                	je     801029d0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029c9:	8b 40 20             	mov    0x20(%eax),%eax
801029cc:	c1 e8 18             	shr    $0x18,%eax
801029cf:	c3                   	ret    
    return 0;
801029d0:	31 c0                	xor    %eax,%eax
}
801029d2:	c3                   	ret    
801029d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801029e5:	85 c0                	test   %eax,%eax
801029e7:	74 0b                	je     801029f4 <lapiceoi+0x14>
  lapic[index] = value;
801029e9:	31 d2                	xor    %edx,%edx
801029eb:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f1:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029f4:	c3                   	ret    
801029f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a00 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a00:	c3                   	ret    
80102a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0f:	90                   	nop

80102a10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a11:	b0 0f                	mov    $0xf,%al
80102a13:	89 e5                	mov    %esp,%ebp
80102a15:	ba 70 00 00 00       	mov    $0x70,%edx
80102a1a:	53                   	push   %ebx
80102a1b:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
80102a1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102a22:	ee                   	out    %al,(%dx)
80102a23:	b0 0a                	mov    $0xa,%al
80102a25:	ba 71 00 00 00       	mov    $0x71,%edx
80102a2a:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a2b:	c1 e1 18             	shl    $0x18,%ecx
  wrv[0] = 0;
80102a2e:	31 c0                	xor    %eax,%eax
80102a30:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a36:	89 d8                	mov    %ebx,%eax
80102a38:	c1 e8 04             	shr    $0x4,%eax
80102a3b:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a41:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
80102a44:	a1 7c 26 11 80       	mov    0x8011267c,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a49:	81 cb 00 06 00 00    	or     $0x600,%ebx
  lapic[index] = value;
80102a4f:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a55:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a58:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102a5d:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a63:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a66:	ba 00 85 00 00       	mov    $0x8500,%edx
80102a6b:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a71:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a74:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a7a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a7d:	89 98 00 03 00 00    	mov    %ebx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a86:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a8c:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a8f:	89 98 00 03 00 00    	mov    %ebx,0x300(%eax)
    microdelay(200);
  }
}
80102a95:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102a96:	8b 40 20             	mov    0x20(%eax),%eax
}
80102a99:	5d                   	pop    %ebp
80102a9a:	c3                   	ret    
80102a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102aa0:	55                   	push   %ebp
80102aa1:	b0 0b                	mov    $0xb,%al
80102aa3:	89 e5                	mov    %esp,%ebp
80102aa5:	ba 70 00 00 00       	mov    $0x70,%edx
80102aaa:	57                   	push   %edi
80102aab:	56                   	push   %esi
80102aac:	53                   	push   %ebx
80102aad:	83 ec 5c             	sub    $0x5c,%esp
80102ab0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab1:	ba 71 00 00 00       	mov    $0x71,%edx
80102ab6:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102ab7:	24 04                	and    $0x4,%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab9:	be 70 00 00 00       	mov    $0x70,%esi
80102abe:	88 45 b2             	mov    %al,-0x4e(%ebp)
80102ac1:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102ac4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102acf:	90                   	nop
80102ad0:	31 c0                	xor    %eax,%eax
80102ad2:	89 f2                	mov    %esi,%edx
80102ad4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad5:	bb 71 00 00 00       	mov    $0x71,%ebx
80102ada:	89 da                	mov    %ebx,%edx
80102adc:	ec                   	in     (%dx),%al
80102add:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae0:	89 f2                	mov    %esi,%edx
80102ae2:	b0 02                	mov    $0x2,%al
80102ae4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae5:	89 da                	mov    %ebx,%edx
80102ae7:	ec                   	in     (%dx),%al
80102ae8:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aeb:	89 f2                	mov    %esi,%edx
80102aed:	b0 04                	mov    $0x4,%al
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 da                	mov    %ebx,%edx
80102af2:	ec                   	in     (%dx),%al
80102af3:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af6:	89 f2                	mov    %esi,%edx
80102af8:	b0 07                	mov    $0x7,%al
80102afa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afb:	89 da                	mov    %ebx,%edx
80102afd:	ec                   	in     (%dx),%al
80102afe:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b01:	89 f2                	mov    %esi,%edx
80102b03:	b0 08                	mov    $0x8,%al
80102b05:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b06:	89 da                	mov    %ebx,%edx
80102b08:	ec                   	in     (%dx),%al
80102b09:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0c:	89 f2                	mov    %esi,%edx
80102b0e:	b0 09                	mov    $0x9,%al
80102b10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b11:	89 da                	mov    %ebx,%edx
80102b13:	ec                   	in     (%dx),%al
80102b14:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b17:	89 f2                	mov    %esi,%edx
80102b19:	b0 0a                	mov    $0xa,%al
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	89 da                	mov    %ebx,%edx
80102b1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b1f:	84 c0                	test   %al,%al
80102b21:	78 ad                	js     80102ad0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102b23:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80102b26:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2a:	89 f2                	mov    %esi,%edx
80102b2c:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b2f:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b33:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b36:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b3a:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b3d:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b41:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b44:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
80102b48:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102b4b:	31 c0                	xor    %eax,%eax
80102b4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4e:	89 da                	mov    %ebx,%edx
80102b50:	ec                   	in     (%dx),%al
80102b51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b54:	89 f2                	mov    %esi,%edx
80102b56:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b59:	b0 02                	mov    $0x2,%al
80102b5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5c:	89 da                	mov    %ebx,%edx
80102b5e:	ec                   	in     (%dx),%al
80102b5f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b62:	89 f2                	mov    %esi,%edx
80102b64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b67:	b0 04                	mov    $0x4,%al
80102b69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6a:	89 da                	mov    %ebx,%edx
80102b6c:	ec                   	in     (%dx),%al
80102b6d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b70:	89 f2                	mov    %esi,%edx
80102b72:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b75:	b0 07                	mov    $0x7,%al
80102b77:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b78:	89 da                	mov    %ebx,%edx
80102b7a:	ec                   	in     (%dx),%al
80102b7b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b7e:	89 f2                	mov    %esi,%edx
80102b80:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b83:	b0 08                	mov    $0x8,%al
80102b85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b86:	89 da                	mov    %ebx,%edx
80102b88:	ec                   	in     (%dx),%al
80102b89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8c:	89 f2                	mov    %esi,%edx
80102b8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b91:	b0 09                	mov    $0x9,%al
80102b93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b94:	89 da                	mov    %ebx,%edx
80102b96:	ec                   	in     (%dx),%al
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  return inb(CMOS_RETURN);
80102b9b:	0f b6 c0             	movzbl %al,%eax
80102b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ba1:	b8 18 00 00 00       	mov    $0x18,%eax
80102ba6:	89 44 24 08          	mov    %eax,0x8(%esp)
80102baa:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bad:	89 04 24             	mov    %eax,(%esp)
80102bb0:	e8 4b 1c 00 00       	call   80104800 <memcmp>
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	0f 85 13 ff ff ff    	jne    80102ad0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102bbd:	80 7d b2 00          	cmpb   $0x0,-0x4e(%ebp)
80102bc1:	75 78                	jne    80102c3b <cmostime+0x19b>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bc6:	89 c2                	mov    %eax,%edx
80102bc8:	83 e0 0f             	and    $0xf,%eax
80102bcb:	c1 ea 04             	shr    $0x4,%edx
80102bce:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd1:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bd7:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bda:	89 c2                	mov    %eax,%edx
80102bdc:	83 e0 0f             	and    $0xf,%eax
80102bdf:	c1 ea 04             	shr    $0x4,%edx
80102be2:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102be5:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102beb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bee:	89 c2                	mov    %eax,%edx
80102bf0:	83 e0 0f             	and    $0xf,%eax
80102bf3:	c1 ea 04             	shr    $0x4,%edx
80102bf6:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf9:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bfc:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c02:	89 c2                	mov    %eax,%edx
80102c04:	83 e0 0f             	and    $0xf,%eax
80102c07:	c1 ea 04             	shr    $0x4,%edx
80102c0a:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c0d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c13:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c16:	89 c2                	mov    %eax,%edx
80102c18:	83 e0 0f             	and    $0xf,%eax
80102c1b:	c1 ea 04             	shr    $0x4,%edx
80102c1e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c21:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c24:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c27:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c2a:	89 c2                	mov    %eax,%edx
80102c2c:	83 e0 0f             	and    $0xf,%eax
80102c2f:	c1 ea 04             	shr    $0x4,%edx
80102c32:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c35:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c38:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102c3e:	31 c0                	xor    %eax,%eax
80102c40:	8b 54 05 b8          	mov    -0x48(%ebp,%eax,1),%edx
80102c44:	89 14 01             	mov    %edx,(%ecx,%eax,1)
80102c47:	83 c0 04             	add    $0x4,%eax
80102c4a:	83 f8 18             	cmp    $0x18,%eax
80102c4d:	72 f1                	jb     80102c40 <cmostime+0x1a0>
  r->year += 2000;
80102c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c52:	81 40 14 d0 07 00 00 	addl   $0x7d0,0x14(%eax)
}
80102c59:	83 c4 5c             	add    $0x5c,%esp
80102c5c:	5b                   	pop    %ebx
80102c5d:	5e                   	pop    %esi
80102c5e:	5f                   	pop    %edi
80102c5f:	5d                   	pop    %ebp
80102c60:	c3                   	ret    
80102c61:	66 90                	xchg   %ax,%ax
80102c63:	66 90                	xchg   %ax,%ax
80102c65:	66 90                	xchg   %ax,%ax
80102c67:	66 90                	xchg   %ax,%ax
80102c69:	66 90                	xchg   %ax,%ax
80102c6b:	66 90                	xchg   %ax,%ax
80102c6d:	66 90                	xchg   %ax,%ax
80102c6f:	90                   	nop

80102c70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c70:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c76:	85 d2                	test   %edx,%edx
80102c78:	0f 8e 92 00 00 00    	jle    80102d10 <install_trans+0xa0>
{
80102c7e:	55                   	push   %ebp
80102c7f:	89 e5                	mov    %esp,%ebp
80102c81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c82:	31 ff                	xor    %edi,%edi
{
80102c84:	56                   	push   %esi
80102c85:	53                   	push   %ebx
80102c86:	83 ec 1c             	sub    $0x1c,%esp
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c90:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c95:	01 f8                	add    %edi,%eax
80102c97:	40                   	inc    %eax
80102c98:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c9c:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102ca1:	89 04 24             	mov    %eax,(%esp)
80102ca4:	e8 27 d4 ff ff       	call   801000d0 <bread>
80102ca9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cab:	8b 04 bd cc 26 11 80 	mov    -0x7feed934(,%edi,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb2:	47                   	inc    %edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cb7:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102cbc:	89 04 24             	mov    %eax,(%esp)
80102cbf:	e8 0c d4 ff ff       	call   801000d0 <bread>
80102cc4:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cc6:	b8 00 02 00 00       	mov    $0x200,%eax
80102ccb:	89 44 24 08          	mov    %eax,0x8(%esp)
80102ccf:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cd6:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cd9:	89 04 24             	mov    %eax,(%esp)
80102cdc:	e8 6f 1b 00 00       	call   80104850 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ce1:	89 1c 24             	mov    %ebx,(%esp)
80102ce4:	e8 c7 d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ce9:	89 34 24             	mov    %esi,(%esp)
80102cec:	e8 ff d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102cf1:	89 1c 24             	mov    %ebx,(%esp)
80102cf4:	e8 f7 d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf9:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102cff:	7f 8f                	jg     80102c90 <install_trans+0x20>
  }
}
80102d01:	83 c4 1c             	add    $0x1c,%esp
80102d04:	5b                   	pop    %ebx
80102d05:	5e                   	pop    %esi
80102d06:	5f                   	pop    %edi
80102d07:	5d                   	pop    %ebp
80102d08:	c3                   	ret    
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d10:	c3                   	ret    
80102d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop

80102d20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 14             	sub    $0x14,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d27:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d30:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102d35:	89 04 24             	mov    %eax,(%esp)
80102d38:	e8 93 d3 ff ff       	call   801000d0 <bread>
80102d3d:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d3f:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102d44:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d47:	85 c0                	test   %eax,%eax
80102d49:	7e 15                	jle    80102d60 <write_head+0x40>
80102d4b:	31 d2                	xor    %edx,%edx
80102d4d:	8d 76 00             	lea    0x0(%esi),%esi
    hb->block[i] = log.lh.block[i];
80102d50:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102d57:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	42                   	inc    %edx
80102d5c:	39 d0                	cmp    %edx,%eax
80102d5e:	75 f0                	jne    80102d50 <write_head+0x30>
  }
  bwrite(buf);
80102d60:	89 1c 24             	mov    %ebx,(%esp)
80102d63:	e8 48 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d68:	89 1c 24             	mov    %ebx,(%esp)
80102d6b:	e8 80 d4 ff ff       	call   801001f0 <brelse>
}
80102d70:	83 c4 14             	add    $0x14,%esp
80102d73:	5b                   	pop    %ebx
80102d74:	5d                   	pop    %ebp
80102d75:	c3                   	ret    
80102d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7d:	8d 76 00             	lea    0x0(%esi),%esi

80102d80 <initlog>:
{
80102d80:	55                   	push   %ebp
  initlock(&log.lock, "log");
80102d81:	ba 00 77 10 80       	mov    $0x80107700,%edx
{
80102d86:	89 e5                	mov    %esp,%ebp
80102d88:	53                   	push   %ebx
80102d89:	83 ec 34             	sub    $0x34,%esp
  initlock(&log.lock, "log");
80102d8c:	89 54 24 04          	mov    %edx,0x4(%esp)
{
80102d90:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d9a:	e8 81 17 00 00       	call   80104520 <initlock>
  readsb(dev, &sb);
80102d9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102da2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102da6:	89 1c 24             	mov    %ebx,(%esp)
80102da9:	e8 c2 e7 ff ff       	call   80101570 <readsb>
  log.start = sb.logstart;
80102dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102db1:	89 1c 24             	mov    %ebx,(%esp)
  log.size = sb.nlog;
80102db4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.dev = dev;
80102db7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102dbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.start = sb.logstart;
80102dc1:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102dc6:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102dcc:	e8 ff d2 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102dd1:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102dd4:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102dda:	85 c9                	test   %ecx,%ecx
80102ddc:	7e 12                	jle    80102df0 <initlog+0x70>
80102dde:	31 d2                	xor    %edx,%edx
    log.lh.block[i] = lh->block[i];
80102de0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102de4:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102deb:	42                   	inc    %edx
80102dec:	39 d1                	cmp    %edx,%ecx
80102dee:	75 f0                	jne    80102de0 <initlog+0x60>
  brelse(buf);
80102df0:	89 04 24             	mov    %eax,(%esp)
80102df3:	e8 f8 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102df8:	e8 73 fe ff ff       	call   80102c70 <install_trans>
  log.lh.n = 0;
80102dfd:	31 c0                	xor    %eax,%eax
80102dff:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  write_head(); // clear the log
80102e04:	e8 17 ff ff ff       	call   80102d20 <write_head>
}
80102e09:	83 c4 34             	add    $0x34,%esp
80102e0c:	5b                   	pop    %ebx
80102e0d:	5d                   	pop    %ebp
80102e0e:	c3                   	ret    
80102e0f:	90                   	nop

80102e10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102e16:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e1d:	e8 6e 18 00 00       	call   80104690 <acquire>
80102e22:	eb 21                	jmp    80102e45 <begin_op+0x35>
80102e24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e2f:	90                   	nop
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e30:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e37:	b8 80 26 11 80       	mov    $0x80112680,%eax
80102e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e40:	e8 4b 11 00 00       	call   80103f90 <sleep>
    if(log.committing){
80102e45:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
80102e4b:	85 d2                	test   %edx,%edx
80102e4d:	75 e1                	jne    80102e30 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e4f:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e54:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
80102e58:	8d 48 01             	lea    0x1(%eax),%ecx
80102e5b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102e60:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e63:	83 f8 1e             	cmp    $0x1e,%eax
80102e66:	7f c8                	jg     80102e30 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e68:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102e6f:	89 0d bc 26 11 80    	mov    %ecx,0x801126bc
      release(&log.lock);
80102e75:	e8 c6 18 00 00       	call   80104740 <release>
      break;
    }
  }
}
80102e7a:	c9                   	leave  
80102e7b:	c3                   	ret    
80102e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	57                   	push   %edi
80102e84:	56                   	push   %esi
80102e85:	53                   	push   %ebx
80102e86:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e89:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e90:	e8 fb 17 00 00       	call   80104690 <acquire>
  log.outstanding -= 1;
80102e95:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e9a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102e9d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
  log.outstanding -= 1;
80102ea2:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102ea8:	85 c0                	test   %eax,%eax
80102eaa:	0f 85 ed 00 00 00    	jne    80102f9d <end_op+0x11d>
    panic("log.committing");
  if(log.outstanding == 0){
80102eb0:	85 db                	test   %ebx,%ebx
80102eb2:	75 34                	jne    80102ee8 <end_op+0x68>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102eb4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 1;
80102ebb:	be 01 00 00 00       	mov    $0x1,%esi
80102ec0:	89 35 c0 26 11 80    	mov    %esi,0x801126c0
  release(&log.lock);
80102ec6:	e8 75 18 00 00       	call   80104740 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ecb:	8b 3d c8 26 11 80    	mov    0x801126c8,%edi
80102ed1:	85 ff                	test   %edi,%edi
80102ed3:	7f 3b                	jg     80102f10 <end_op+0x90>
    acquire(&log.lock);
80102ed5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102edc:	e8 af 17 00 00       	call   80104690 <acquire>
    log.committing = 0;
80102ee1:	31 c0                	xor    %eax,%eax
80102ee3:	a3 c0 26 11 80       	mov    %eax,0x801126c0
    wakeup(&log);
80102ee8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102eef:	e8 6c 12 00 00       	call   80104160 <wakeup>
    release(&log.lock);
80102ef4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102efb:	e8 40 18 00 00       	call   80104740 <release>
}
80102f00:	83 c4 1c             	add    $0x1c,%esp
80102f03:	5b                   	pop    %ebx
80102f04:	5e                   	pop    %esi
80102f05:	5f                   	pop    %edi
80102f06:	5d                   	pop    %ebp
80102f07:	c3                   	ret    
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f10:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102f15:	01 d8                	add    %ebx,%eax
80102f17:	40                   	inc    %eax
80102f18:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f1c:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102f21:	89 04 24             	mov    %eax,(%esp)
80102f24:	e8 a7 d1 ff ff       	call   801000d0 <bread>
80102f29:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f2b:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102f32:	43                   	inc    %ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f33:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f37:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102f3c:	89 04 24             	mov    %eax,(%esp)
80102f3f:	e8 8c d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f44:	b9 00 02 00 00       	mov    $0x200,%ecx
80102f49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f4d:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f4f:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f52:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f56:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f59:	89 04 24             	mov    %eax,(%esp)
80102f5c:	e8 ef 18 00 00       	call   80104850 <memmove>
    bwrite(to);  // write the log
80102f61:	89 34 24             	mov    %esi,(%esp)
80102f64:	e8 47 d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f69:	89 3c 24             	mov    %edi,(%esp)
80102f6c:	e8 7f d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f71:	89 34 24             	mov    %esi,(%esp)
80102f74:	e8 77 d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f79:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102f7f:	7c 8f                	jl     80102f10 <end_op+0x90>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f81:	e8 9a fd ff ff       	call   80102d20 <write_head>
    install_trans(); // Now install writes to home locations
80102f86:	e8 e5 fc ff ff       	call   80102c70 <install_trans>
    log.lh.n = 0;
80102f8b:	31 d2                	xor    %edx,%edx
80102f8d:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
    write_head();    // Erase the transaction from the log
80102f93:	e8 88 fd ff ff       	call   80102d20 <write_head>
80102f98:	e9 38 ff ff ff       	jmp    80102ed5 <end_op+0x55>
    panic("log.committing");
80102f9d:	c7 04 24 04 77 10 80 	movl   $0x80107704,(%esp)
80102fa4:	e8 b7 d3 ff ff       	call   80100360 <panic>
80102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fc0:	83 fa 1d             	cmp    $0x1d,%edx
80102fc3:	0f 8f 83 00 00 00    	jg     8010304c <log_write+0x9c>
80102fc9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102fce:	48                   	dec    %eax
80102fcf:	39 c2                	cmp    %eax,%edx
80102fd1:	7d 79                	jge    8010304c <log_write+0x9c>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fd3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102fd8:	85 c0                	test   %eax,%eax
80102fda:	7e 7c                	jle    80103058 <log_write+0xa8>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fdc:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102fe3:	e8 a8 16 00 00       	call   80104690 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fe8:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102fee:	85 d2                	test   %edx,%edx
80102ff0:	7e 4e                	jle    80103040 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff2:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ff5:	31 c0                	xor    %eax,%eax
80102ff7:	eb 0c                	jmp    80103005 <log_write+0x55>
80102ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103000:	40                   	inc    %eax
80103001:	39 c2                	cmp    %eax,%edx
80103003:	74 2b                	je     80103030 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103005:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
8010300c:	75 f2                	jne    80103000 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
8010300e:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103015:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103018:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
8010301f:	83 c4 14             	add    $0x14,%esp
80103022:	5b                   	pop    %ebx
80103023:	5d                   	pop    %ebp
  release(&log.lock);
80103024:	e9 17 17 00 00       	jmp    80104740 <release>
80103029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80103030:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80103037:	42                   	inc    %edx
80103038:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
8010303e:	eb d5                	jmp    80103015 <log_write+0x65>
  log.lh.block[i] = b->blockno;
80103040:	8b 43 08             	mov    0x8(%ebx),%eax
80103043:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80103048:	75 cb                	jne    80103015 <log_write+0x65>
8010304a:	eb eb                	jmp    80103037 <log_write+0x87>
    panic("too big a transaction");
8010304c:	c7 04 24 13 77 10 80 	movl   $0x80107713,(%esp)
80103053:	e8 08 d3 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80103058:	c7 04 24 29 77 10 80 	movl   $0x80107729,(%esp)
8010305f:	e8 fc d2 ff ff       	call   80100360 <panic>
80103064:	66 90                	xchg   %ax,%ax
80103066:	66 90                	xchg   %ax,%ax
80103068:	66 90                	xchg   %ax,%ax
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103077:	e8 64 09 00 00       	call   801039e0 <cpuid>
8010307c:	89 c3                	mov    %eax,%ebx
8010307e:	e8 5d 09 00 00       	call   801039e0 <cpuid>
80103083:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103087:	c7 04 24 44 77 10 80 	movl   $0x80107744,(%esp)
8010308e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103092:	e8 e9 d5 ff ff       	call   80100680 <cprintf>
  idtinit();       // load idt register
80103097:	e8 64 29 00 00       	call   80105a00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
8010309c:	e8 cf 08 00 00       	call   80103970 <mycpu>
801030a1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030a3:	b8 01 00 00 00       	mov    $0x1,%eax
801030a8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030af:	e8 1c 0c 00 00       	call   80103cd0 <scheduler>
801030b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030bf:	90                   	nop

801030c0 <mpenter>:
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030c6:	e8 65 3a 00 00       	call   80106b30 <switchkvm>
  seginit();
801030cb:	e8 d0 39 00 00       	call   80106aa0 <seginit>
  lapicinit();
801030d0:	e8 eb f7 ff ff       	call   801028c0 <lapicinit>
  mpmain();
801030d5:	e8 96 ff ff ff       	call   80103070 <mpmain>
801030da:	66 90                	xchg   %ax,%ax
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <main>:
{
801030e0:	55                   	push   %ebp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030e1:	b8 00 00 40 80       	mov    $0x80400000,%eax
{
801030e6:	89 e5                	mov    %esp,%ebp
801030e8:	53                   	push   %ebx
801030e9:	83 e4 f0             	and    $0xfffffff0,%esp
801030ec:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801030f3:	c7 04 24 a8 54 11 80 	movl   $0x801154a8,(%esp)
801030fa:	e8 71 f5 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
801030ff:	e8 1c 3f 00 00       	call   80107020 <kvmalloc>
  mpinit();        // detect other processors
80103104:	e8 97 01 00 00       	call   801032a0 <mpinit>
  lapicinit();     // interrupt controller
80103109:	e8 b2 f7 ff ff       	call   801028c0 <lapicinit>
  seginit();       // segment descriptors
8010310e:	66 90                	xchg   %ax,%ax
80103110:	e8 8b 39 00 00       	call   80106aa0 <seginit>
  picinit();       // disable pic
80103115:	e8 56 03 00 00       	call   80103470 <picinit>
  ioapicinit();    // another interrupt controller
8010311a:	e8 71 f3 ff ff       	call   80102490 <ioapicinit>
  consoleinit();   // console hardware
8010311f:	90                   	nop
80103120:	e8 fb d8 ff ff       	call   80100a20 <consoleinit>
  uartinit();      // serial port
80103125:	e8 26 2c 00 00       	call   80105d50 <uartinit>
  pinit();         // process table
8010312a:	e8 21 08 00 00       	call   80103950 <pinit>
  tvinit();        // trap vectors
8010312f:	90                   	nop
80103130:	e8 4b 28 00 00       	call   80105980 <tvinit>
  binit();         // buffer cache
80103135:	e8 06 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010313a:	e8 c1 dc ff ff       	call   80100e00 <fileinit>
  ideinit();       // disk 
8010313f:	90                   	nop
80103140:	e8 3b f1 ff ff       	call   80102280 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103145:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010314a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010314e:	b8 8c a4 10 80       	mov    $0x8010a48c,%eax
80103153:	89 44 24 04          	mov    %eax,0x4(%esp)
80103157:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
8010315e:	e8 ed 16 00 00       	call   80104850 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103163:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80103168:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010316b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010316e:	c1 e0 04             	shl    $0x4,%eax
80103171:	05 80 27 11 80       	add    $0x80112780,%eax
80103176:	3d 80 27 11 80       	cmp    $0x80112780,%eax
8010317b:	0f 86 7f 00 00 00    	jbe    80103200 <main+0x120>
80103181:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103186:	eb 25                	jmp    801031ad <main+0xcd>
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80103195:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010319b:	8d 14 80             	lea    (%eax,%eax,4),%edx
8010319e:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031a1:	c1 e0 04             	shl    $0x4,%eax
801031a4:	05 80 27 11 80       	add    $0x80112780,%eax
801031a9:	39 c3                	cmp    %eax,%ebx
801031ab:	73 53                	jae    80103200 <main+0x120>
    if(c == mycpu())  // We've started already.
801031ad:	e8 be 07 00 00       	call   80103970 <mycpu>
801031b2:	39 c3                	cmp    %eax,%ebx
801031b4:	74 da                	je     80103190 <main+0xb0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031b6:	e8 85 f5 ff ff       	call   80102740 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
801031bb:	ba c0 30 10 80       	mov    $0x801030c0,%edx
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031c0:	b9 00 90 10 00       	mov    $0x109000,%ecx
    *(void(**)(void))(code-8) = mpenter;
801031c5:	89 15 f8 6f 00 80    	mov    %edx,0x80006ff8
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031cb:	89 0d f4 6f 00 80    	mov    %ecx,0x80006ff4
    *(void**)(code-4) = stack + KSTACKSIZE;
801031d1:	05 00 10 00 00       	add    $0x1000,%eax
801031d6:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801031db:	b8 00 70 00 00       	mov    $0x7000,%eax
801031e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801031e4:	0f b6 03             	movzbl (%ebx),%eax
801031e7:	89 04 24             	mov    %eax,(%esp)
801031ea:	e8 21 f8 ff ff       	call   80102a10 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031ef:	90                   	nop
801031f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031f6:	85 c0                	test   %eax,%eax
801031f8:	74 f6                	je     801031f0 <main+0x110>
801031fa:	eb 94                	jmp    80103190 <main+0xb0>
801031fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103200:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103207:	b8 00 00 00 8e       	mov    $0x8e000000,%eax
8010320c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103210:	e8 cb f4 ff ff       	call   801026e0 <kinit2>
  userinit();      // first user process
80103215:	e8 16 08 00 00       	call   80103a30 <userinit>
  mpmain();        // finish this processor's setup
8010321a:	e8 51 fe ff ff       	call   80103070 <mpmain>
8010321f:	90                   	nop

80103220 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80103226:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010322c:	83 ec 1c             	sub    $0x1c,%esp
  e = addr+len;
8010322f:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80103236:	39 de                	cmp    %ebx,%esi
80103238:	72 0c                	jb     80103246 <mpsearch1+0x26>
8010323a:	eb 54                	jmp    80103290 <mpsearch1+0x70>
8010323c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103240:	39 cb                	cmp    %ecx,%ebx
80103242:	89 ce                	mov    %ecx,%esi
80103244:	76 4a                	jbe    80103290 <mpsearch1+0x70>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103246:	89 34 24             	mov    %esi,(%esp)
80103249:	b8 04 00 00 00       	mov    $0x4,%eax
8010324e:	ba 58 77 10 80       	mov    $0x80107758,%edx
80103253:	89 44 24 08          	mov    %eax,0x8(%esp)
80103257:	89 54 24 04          	mov    %edx,0x4(%esp)
8010325b:	e8 a0 15 00 00       	call   80104800 <memcmp>
80103260:	8d 4e 10             	lea    0x10(%esi),%ecx
80103263:	85 c0                	test   %eax,%eax
80103265:	75 d9                	jne    80103240 <mpsearch1+0x20>
80103267:	89 f2                	mov    %esi,%edx
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103270:	0f b6 3a             	movzbl (%edx),%edi
80103273:	42                   	inc    %edx
80103274:	01 f8                	add    %edi,%eax
  for(i=0; i<len; i++)
80103276:	39 ca                	cmp    %ecx,%edx
80103278:	75 f6                	jne    80103270 <mpsearch1+0x50>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010327a:	84 c0                	test   %al,%al
8010327c:	75 c2                	jne    80103240 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
8010327e:	83 c4 1c             	add    $0x1c,%esp
80103281:	89 f0                	mov    %esi,%eax
80103283:	5b                   	pop    %ebx
80103284:	5e                   	pop    %esi
80103285:	5f                   	pop    %edi
80103286:	5d                   	pop    %ebp
80103287:	c3                   	ret    
80103288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop
80103290:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80103293:	31 f6                	xor    %esi,%esi
}
80103295:	5b                   	pop    %ebx
80103296:	89 f0                	mov    %esi,%eax
80103298:	5e                   	pop    %esi
80103299:	5f                   	pop    %edi
8010329a:	5d                   	pop    %ebp
8010329b:	c3                   	ret    
8010329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
801032a5:	53                   	push   %ebx
801032a6:	83 ec 2c             	sub    $0x2c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032b7:	c1 e0 08             	shl    $0x8,%eax
801032ba:	09 d0                	or     %edx,%eax
801032bc:	c1 e0 04             	shl    $0x4,%eax
801032bf:	75 1b                	jne    801032dc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032c1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032c8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032cf:	c1 e0 08             	shl    $0x8,%eax
801032d2:	09 d0                	or     %edx,%eax
801032d4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032d7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032dc:	ba 00 04 00 00       	mov    $0x400,%edx
801032e1:	e8 3a ff ff ff       	call   80103220 <mpsearch1>
801032e6:	85 c0                	test   %eax,%eax
801032e8:	89 c6                	mov    %eax,%esi
801032ea:	0f 84 40 01 00 00    	je     80103430 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032f0:	8b 5e 04             	mov    0x4(%esi),%ebx
801032f3:	85 db                	test   %ebx,%ebx
801032f5:	0f 84 55 01 00 00    	je     80103450 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032fb:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103301:	ba 04 00 00 00       	mov    $0x4,%edx
80103306:	89 54 24 08          	mov    %edx,0x8(%esp)
8010330a:	b9 5d 77 10 80       	mov    $0x8010775d,%ecx
8010330f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80103313:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103319:	e8 e2 14 00 00       	call   80104800 <memcmp>
8010331e:	85 c0                	test   %eax,%eax
80103320:	0f 85 2a 01 00 00    	jne    80103450 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103326:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010332d:	3c 01                	cmp    $0x1,%al
8010332f:	74 08                	je     80103339 <mpinit+0x99>
80103331:	3c 04                	cmp    $0x4,%al
80103333:	0f 85 17 01 00 00    	jne    80103450 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
80103339:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103340:	85 ff                	test   %edi,%edi
80103342:	74 22                	je     80103366 <mpinit+0xc6>
80103344:	89 d8                	mov    %ebx,%eax
80103346:	01 df                	add    %ebx,%edi
  sum = 0;
80103348:	31 d2                	xor    %edx,%edx
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103350:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103357:	40                   	inc    %eax
80103358:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010335a:	39 f8                	cmp    %edi,%eax
8010335c:	75 f2                	jne    80103350 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
8010335e:	84 d2                	test   %dl,%dl
80103360:	0f 85 ea 00 00 00    	jne    80103450 <mpinit+0x1b0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103366:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010336c:	8d 93 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%edx
  lapic = (uint*)conf->lapicaddr;
80103372:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010337a:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  ismp = 1;
80103381:	bb 01 00 00 00       	mov    $0x1,%ebx
80103386:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103389:	01 c1                	add    %eax,%ecx
8010338b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010338f:	90                   	nop
80103390:	39 d1                	cmp    %edx,%ecx
80103392:	76 15                	jbe    801033a9 <mpinit+0x109>
    switch(*p){
80103394:	0f b6 02             	movzbl (%edx),%eax
80103397:	3c 02                	cmp    $0x2,%al
80103399:	74 55                	je     801033f0 <mpinit+0x150>
8010339b:	77 43                	ja     801033e0 <mpinit+0x140>
8010339d:	84 c0                	test   %al,%al
8010339f:	90                   	nop
801033a0:	74 5e                	je     80103400 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033a2:	83 c2 08             	add    $0x8,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033a5:	39 d1                	cmp    %edx,%ecx
801033a7:	77 eb                	ja     80103394 <mpinit+0xf4>
801033a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033ac:	85 db                	test   %ebx,%ebx
801033ae:	0f 84 a8 00 00 00    	je     8010345c <mpinit+0x1bc>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033b4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801033b8:	74 11                	je     801033cb <mpinit+0x12b>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ba:	b0 70                	mov    $0x70,%al
801033bc:	ba 22 00 00 00       	mov    $0x22,%edx
801033c1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033c2:	ba 23 00 00 00       	mov    $0x23,%edx
801033c7:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033c8:	0c 01                	or     $0x1,%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ca:	ee                   	out    %al,(%dx)
  }
}
801033cb:	83 c4 2c             	add    $0x2c,%esp
801033ce:	5b                   	pop    %ebx
801033cf:	5e                   	pop    %esi
801033d0:	5f                   	pop    %edi
801033d1:	5d                   	pop    %ebp
801033d2:	c3                   	ret    
801033d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(*p){
801033e0:	2c 03                	sub    $0x3,%al
801033e2:	3c 01                	cmp    $0x1,%al
801033e4:	76 bc                	jbe    801033a2 <mpinit+0x102>
801033e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801033ed:	eb a1                	jmp    80103390 <mpinit+0xf0>
801033ef:	90                   	nop
      ioapicid = ioapic->apicno;
801033f0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
801033f4:	83 c2 08             	add    $0x8,%edx
      ioapicid = ioapic->apicno;
801033f7:	a2 60 27 11 80       	mov    %al,0x80112760
      continue;
801033fc:	eb 92                	jmp    80103390 <mpinit+0xf0>
801033fe:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103400:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80103405:	83 f8 07             	cmp    $0x7,%eax
80103408:	7f 19                	jg     80103423 <mpinit+0x183>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010340a:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
8010340e:	8d 3c 80             	lea    (%eax,%eax,4),%edi
80103411:	8d 3c 78             	lea    (%eax,%edi,2),%edi
        ncpu++;
80103414:	40                   	inc    %eax
80103415:	a3 00 2d 11 80       	mov    %eax,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010341a:	c1 e7 04             	shl    $0x4,%edi
8010341d:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103423:	83 c2 14             	add    $0x14,%edx
      continue;
80103426:	e9 65 ff ff ff       	jmp    80103390 <mpinit+0xf0>
8010342b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010342f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80103430:	ba 00 00 01 00       	mov    $0x10000,%edx
80103435:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010343a:	e8 e1 fd ff ff       	call   80103220 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010343f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103441:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103443:	0f 85 a7 fe ff ff    	jne    801032f0 <mpinit+0x50>
80103449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103450:	c7 04 24 62 77 10 80 	movl   $0x80107762,(%esp)
80103457:	e8 04 cf ff ff       	call   80100360 <panic>
    panic("Didn't find a suitable machine");
8010345c:	c7 04 24 7c 77 10 80 	movl   $0x8010777c,(%esp)
80103463:	e8 f8 ce ff ff       	call   80100360 <panic>
80103468:	66 90                	xchg   %ax,%ax
8010346a:	66 90                	xchg   %ax,%ax
8010346c:	66 90                	xchg   %ax,%ax
8010346e:	66 90                	xchg   %ax,%ax

80103470 <picinit>:
80103470:	b0 ff                	mov    $0xff,%al
80103472:	ba 21 00 00 00       	mov    $0x21,%edx
80103477:	ee                   	out    %al,(%dx)
80103478:	ba a1 00 00 00       	mov    $0xa1,%edx
8010347d:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
8010347e:	c3                   	ret    
8010347f:	90                   	nop

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	83 ec 28             	sub    $0x28,%esp
80103486:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	89 75 f8             	mov    %esi,-0x8(%ebp)
8010348f:	8b 75 0c             	mov    0xc(%ebp),%esi
80103492:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103495:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010349b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034a1:	e8 7a d9 ff ff       	call   80100e20 <filealloc>
801034a6:	89 03                	mov    %eax,(%ebx)
801034a8:	85 c0                	test   %eax,%eax
801034aa:	0f 84 ae 00 00 00    	je     8010355e <pipealloc+0xde>
801034b0:	e8 6b d9 ff ff       	call   80100e20 <filealloc>
801034b5:	89 06                	mov    %eax,(%esi)
801034b7:	85 c0                	test   %eax,%eax
801034b9:	0f 84 91 00 00 00    	je     80103550 <pipealloc+0xd0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034bf:	e8 7c f2 ff ff       	call   80102740 <kalloc>
801034c4:	85 c0                	test   %eax,%eax
801034c6:	89 c7                	mov    %eax,%edi
801034c8:	0f 84 b2 00 00 00    	je     80103580 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801034ce:	b8 01 00 00 00       	mov    $0x1,%eax
  p->writeopen = 1;
801034d3:	ba 01 00 00 00       	mov    $0x1,%edx
  p->readopen = 1;
801034d8:	89 87 3c 02 00 00    	mov    %eax,0x23c(%edi)
  p->nwrite = 0;
  p->nread = 0;
801034de:	31 c0                	xor    %eax,%eax
  p->nwrite = 0;
801034e0:	31 c9                	xor    %ecx,%ecx
  p->nread = 0;
801034e2:	89 87 34 02 00 00    	mov    %eax,0x234(%edi)
  initlock(&p->lock, "pipe");
801034e8:	b8 9b 77 10 80       	mov    $0x8010779b,%eax
  p->writeopen = 1;
801034ed:	89 97 40 02 00 00    	mov    %edx,0x240(%edi)
  p->nwrite = 0;
801034f3:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
  initlock(&p->lock, "pipe");
801034f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801034fd:	89 3c 24             	mov    %edi,(%esp)
80103500:	e8 1b 10 00 00       	call   80104520 <initlock>
  (*f0)->type = FD_PIPE;
80103505:	8b 03                	mov    (%ebx),%eax
80103507:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010350d:	8b 03                	mov    (%ebx),%eax
8010350f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103513:	8b 03                	mov    (%ebx),%eax
80103515:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103519:	8b 03                	mov    (%ebx),%eax
8010351b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010351e:	8b 06                	mov    (%esi),%eax
80103520:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103526:	8b 06                	mov    (%esi),%eax
80103528:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010352c:	8b 06                	mov    (%esi),%eax
8010352e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103532:	8b 06                	mov    (%esi),%eax
80103534:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80103537:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103539:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010353c:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010353f:	8b 7d fc             	mov    -0x4(%ebp),%edi
80103542:	89 ec                	mov    %ebp,%esp
80103544:	5d                   	pop    %ebp
80103545:	c3                   	ret    
80103546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103550:	8b 03                	mov    (%ebx),%eax
80103552:	85 c0                	test   %eax,%eax
80103554:	74 16                	je     8010356c <pipealloc+0xec>
    fileclose(*f0);
80103556:	89 04 24             	mov    %eax,(%esp)
80103559:	e8 82 d9 ff ff       	call   80100ee0 <fileclose>
  if(*f1)
8010355e:	8b 06                	mov    (%esi),%eax
80103560:	85 c0                	test   %eax,%eax
80103562:	74 08                	je     8010356c <pipealloc+0xec>
    fileclose(*f1);
80103564:	89 04 24             	mov    %eax,(%esp)
80103567:	e8 74 d9 ff ff       	call   80100ee0 <fileclose>
}
8010356c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  return -1;
8010356f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103574:	8b 75 f8             	mov    -0x8(%ebp),%esi
80103577:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010357a:	89 ec                	mov    %ebp,%esp
8010357c:	5d                   	pop    %ebp
8010357d:	c3                   	ret    
8010357e:	66 90                	xchg   %ax,%ax
  if(*f0)
80103580:	8b 03                	mov    (%ebx),%eax
80103582:	85 c0                	test   %eax,%eax
80103584:	75 d0                	jne    80103556 <pipealloc+0xd6>
80103586:	eb d6                	jmp    8010355e <pipealloc+0xde>
80103588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010358f:	90                   	nop

80103590 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	83 ec 18             	sub    $0x18,%esp
80103596:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010359c:	89 75 fc             	mov    %esi,-0x4(%ebp)
8010359f:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035a2:	89 1c 24             	mov    %ebx,(%esp)
801035a5:	e8 e6 10 00 00       	call   80104690 <acquire>
  if(writable){
801035aa:	85 f6                	test   %esi,%esi
801035ac:	74 42                	je     801035f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801035ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035b4:	31 f6                	xor    %esi,%esi
801035b6:	89 b3 40 02 00 00    	mov    %esi,0x240(%ebx)
    wakeup(&p->nread);
801035bc:	89 04 24             	mov    %eax,(%esp)
801035bf:	e8 9c 0b 00 00       	call   80104160 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035c4:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ca:	85 d2                	test   %edx,%edx
801035cc:	75 0a                	jne    801035d8 <pipeclose+0x48>
801035ce:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035d4:	85 c0                	test   %eax,%eax
801035d6:	74 38                	je     80103610 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035db:	8b 75 fc             	mov    -0x4(%ebp),%esi
801035de:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801035e1:	89 ec                	mov    %ebp,%esp
801035e3:	5d                   	pop    %ebp
    release(&p->lock);
801035e4:	e9 57 11 00 00       	jmp    80104740 <release>
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801035f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035f6:	31 c9                	xor    %ecx,%ecx
801035f8:	89 8b 3c 02 00 00    	mov    %ecx,0x23c(%ebx)
    wakeup(&p->nwrite);
801035fe:	89 04 24             	mov    %eax,(%esp)
80103601:	e8 5a 0b 00 00       	call   80104160 <wakeup>
80103606:	eb bc                	jmp    801035c4 <pipeclose+0x34>
80103608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010360f:	90                   	nop
    release(&p->lock);
80103610:	89 1c 24             	mov    %ebx,(%esp)
80103613:	e8 28 11 00 00       	call   80104740 <release>
}
80103618:	8b 75 fc             	mov    -0x4(%ebp),%esi
    kfree((char*)p);
8010361b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010361e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80103621:	89 ec                	mov    %ebp,%esp
80103623:	5d                   	pop    %ebp
    kfree((char*)p);
80103624:	e9 57 ef ff ff       	jmp    80102580 <kfree>
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103630 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 2c             	sub    $0x2c,%esp
80103639:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010363c:	89 3c 24             	mov    %edi,(%esp)
8010363f:	e8 4c 10 00 00       	call   80104690 <acquire>
  for(i = 0; i < n; i++){
80103644:	8b 75 10             	mov    0x10(%ebp),%esi
80103647:	85 f6                	test   %esi,%esi
80103649:	0f 8e c7 00 00 00    	jle    80103716 <pipewrite+0xe6>
8010364f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103652:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103658:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010365b:	8b 87 38 02 00 00    	mov    0x238(%edi),%eax
80103661:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103664:	01 d9                	add    %ebx,%ecx
80103666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103669:	8b 8f 34 02 00 00    	mov    0x234(%edi),%ecx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010366f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103675:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010367b:	39 d0                	cmp    %edx,%eax
8010367d:	74 46                	je     801036c5 <pipewrite+0x95>
8010367f:	eb 63                	jmp    801036e4 <pipewrite+0xb4>
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010368f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103690:	e8 6b 03 00 00       	call   80103a00 <myproc>
80103695:	8b 40 24             	mov    0x24(%eax),%eax
80103698:	85 c0                	test   %eax,%eax
8010369a:	75 33                	jne    801036cf <pipewrite+0x9f>
      wakeup(&p->nread);
8010369c:	89 34 24             	mov    %esi,(%esp)
8010369f:	e8 bc 0a 00 00       	call   80104160 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
801036a8:	89 1c 24             	mov    %ebx,(%esp)
801036ab:	e8 e0 08 00 00       	call   80103f90 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b0:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801036b6:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801036bc:	05 00 02 00 00       	add    $0x200,%eax
801036c1:	39 c2                	cmp    %eax,%edx
801036c3:	75 2b                	jne    801036f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036c5:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801036cb:	85 d2                	test   %edx,%edx
801036cd:	75 c1                	jne    80103690 <pipewrite+0x60>
        release(&p->lock);
801036cf:	89 3c 24             	mov    %edi,(%esp)
801036d2:	e8 69 10 00 00       	call   80104740 <release>
        return -1;
801036d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036dc:	83 c4 2c             	add    $0x2c,%esp
801036df:	5b                   	pop    %ebx
801036e0:	5e                   	pop    %esi
801036e1:	5f                   	pop    %edi
801036e2:	5d                   	pop    %ebp
801036e3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036e4:	89 c2                	mov    %eax,%edx
801036e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036f0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801036f3:	8d 42 01             	lea    0x1(%edx),%eax
801036f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036fc:	89 87 38 02 00 00    	mov    %eax,0x238(%edi)
80103702:	0f b6 0b             	movzbl (%ebx),%ecx
80103705:	43                   	inc    %ebx
  for(i = 0; i < n; i++){
80103706:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80103709:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010370c:	88 4c 17 34          	mov    %cl,0x34(%edi,%edx,1)
  for(i = 0; i < n; i++){
80103710:	0f 85 53 ff ff ff    	jne    80103669 <pipewrite+0x39>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103716:	8d 87 34 02 00 00    	lea    0x234(%edi),%eax
8010371c:	89 04 24             	mov    %eax,(%esp)
8010371f:	e8 3c 0a 00 00       	call   80104160 <wakeup>
  release(&p->lock);
80103724:	89 3c 24             	mov    %edi,(%esp)
80103727:	e8 14 10 00 00       	call   80104740 <release>
  return n;
8010372c:	8b 45 10             	mov    0x10(%ebp),%eax
8010372f:	eb ab                	jmp    801036dc <pipewrite+0xac>
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010373f:	90                   	nop

80103740 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	57                   	push   %edi
80103744:	56                   	push   %esi
80103745:	53                   	push   %ebx
80103746:	83 ec 1c             	sub    $0x1c,%esp
80103749:	8b 75 08             	mov    0x8(%ebp),%esi
8010374c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010374f:	89 34 24             	mov    %esi,(%esp)
80103752:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103758:	e8 33 0f 00 00       	call   80104690 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010375d:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103763:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103769:	74 2f                	je     8010379a <piperead+0x5a>
8010376b:	eb 37                	jmp    801037a4 <piperead+0x64>
8010376d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103770:	e8 8b 02 00 00       	call   80103a00 <myproc>
80103775:	8b 48 24             	mov    0x24(%eax),%ecx
80103778:	85 c9                	test   %ecx,%ecx
8010377a:	0f 85 80 00 00 00    	jne    80103800 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103780:	89 74 24 04          	mov    %esi,0x4(%esp)
80103784:	89 1c 24             	mov    %ebx,(%esp)
80103787:	e8 04 08 00 00       	call   80103f90 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010378c:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103792:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103798:	75 0a                	jne    801037a4 <piperead+0x64>
8010379a:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037a0:	85 c0                	test   %eax,%eax
801037a2:	75 cc                	jne    80103770 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037a4:	8b 55 10             	mov    0x10(%ebp),%edx
801037a7:	31 db                	xor    %ebx,%ebx
801037a9:	85 d2                	test   %edx,%edx
801037ab:	7f 1f                	jg     801037cc <piperead+0x8c>
801037ad:	eb 2b                	jmp    801037da <piperead+0x9a>
801037af:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037b0:	8d 48 01             	lea    0x1(%eax),%ecx
801037b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037b8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037be:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037c3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037c6:	43                   	inc    %ebx
801037c7:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037ca:	74 0e                	je     801037da <piperead+0x9a>
    if(p->nread == p->nwrite)
801037cc:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d2:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037d8:	75 d6                	jne    801037b0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037da:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037e0:	89 04 24             	mov    %eax,(%esp)
801037e3:	e8 78 09 00 00       	call   80104160 <wakeup>
  release(&p->lock);
801037e8:	89 34 24             	mov    %esi,(%esp)
801037eb:	e8 50 0f 00 00       	call   80104740 <release>
  return i;
}
801037f0:	83 c4 1c             	add    $0x1c,%esp
801037f3:	89 d8                	mov    %ebx,%eax
801037f5:	5b                   	pop    %ebx
801037f6:	5e                   	pop    %esi
801037f7:	5f                   	pop    %edi
801037f8:	5d                   	pop    %ebp
801037f9:	c3                   	ret    
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
80103800:	89 34 24             	mov    %esi,(%esp)
      return -1;
80103803:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103808:	e8 33 0f 00 00       	call   80104740 <release>
}
8010380d:	83 c4 1c             	add    $0x1c,%esp
80103810:	89 d8                	mov    %ebx,%eax
80103812:	5b                   	pop    %ebx
80103813:	5e                   	pop    %esi
80103814:	5f                   	pop    %edi
80103815:	5d                   	pop    %ebp
80103816:	c3                   	ret    
80103817:	66 90                	xchg   %ax,%ax
80103819:	66 90                	xchg   %ax,%ax
8010381b:	66 90                	xchg   %ax,%ax
8010381d:	66 90                	xchg   %ax,%ax
8010381f:	90                   	nop

80103820 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103824:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103829:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010382c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103833:	e8 58 0e 00 00       	call   80104690 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103838:	eb 15                	jmp    8010384f <allocproc+0x2f>
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103840:	83 c3 7c             	add    $0x7c,%ebx
80103843:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103849:	0f 84 81 00 00 00    	je     801038d0 <allocproc+0xb0>
    if(p->state == UNUSED)
8010384f:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103852:	85 c9                	test   %ecx,%ecx
80103854:	75 ea                	jne    80103840 <allocproc+0x20>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103856:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010385d:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103862:	89 43 10             	mov    %eax,0x10(%ebx)
80103865:	8d 50 01             	lea    0x1(%eax),%edx

  release(&ptable.lock);
80103868:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->pid = nextpid++;
8010386f:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103875:	e8 c6 0e 00 00       	call   80104740 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010387a:	e8 c1 ee ff ff       	call   80102740 <kalloc>
8010387f:	89 43 08             	mov    %eax,0x8(%ebx)
80103882:	85 c0                	test   %eax,%eax
80103884:	74 60                	je     801038e6 <allocproc+0xc6>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103886:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010388c:	b9 14 00 00 00       	mov    $0x14,%ecx
  sp -= sizeof *p->tf;
80103891:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103894:	ba 6c 59 10 80       	mov    $0x8010596c,%edx
  sp -= sizeof *p->context;
80103899:	05 9c 0f 00 00       	add    $0xf9c,%eax
  *(uint*)sp = (uint)trapret;
8010389e:	89 50 14             	mov    %edx,0x14(%eax)
  memset(p->context, 0, sizeof *p->context);
801038a1:	31 d2                	xor    %edx,%edx
  p->context = (struct context*)sp;
801038a3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801038aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801038ae:	89 04 24             	mov    %eax,(%esp)
801038b1:	e8 da 0e 00 00       	call   80104790 <memset>
  p->context->eip = (uint)forkret;
801038b6:	8b 43 1c             	mov    0x1c(%ebx),%eax
801038b9:	c7 40 10 00 39 10 80 	movl   $0x80103900,0x10(%eax)

  return p;
}
801038c0:	83 c4 14             	add    $0x14,%esp
801038c3:	89 d8                	mov    %ebx,%eax
801038c5:	5b                   	pop    %ebx
801038c6:	5d                   	pop    %ebp
801038c7:	c3                   	ret    
801038c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038cf:	90                   	nop
  release(&ptable.lock);
801038d0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  return 0;
801038d7:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038d9:	e8 62 0e 00 00       	call   80104740 <release>
}
801038de:	83 c4 14             	add    $0x14,%esp
801038e1:	89 d8                	mov    %ebx,%eax
801038e3:	5b                   	pop    %ebx
801038e4:	5d                   	pop    %ebp
801038e5:	c3                   	ret    
    p->state = UNUSED;
801038e6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038ed:	31 db                	xor    %ebx,%ebx
}
801038ef:	83 c4 14             	add    $0x14,%esp
801038f2:	89 d8                	mov    %ebx,%eax
801038f4:	5b                   	pop    %ebx
801038f5:	5d                   	pop    %ebp
801038f6:	c3                   	ret    
801038f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fe:	66 90                	xchg   %ax,%ax

80103900 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103906:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010390d:	e8 2e 0e 00 00       	call   80104740 <release>

  if (first) {
80103912:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
80103918:	85 d2                	test   %edx,%edx
8010391a:	75 04                	jne    80103920 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010391c:	c9                   	leave  
8010391d:	c3                   	ret    
8010391e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103920:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
80103927:	31 c0                	xor    %eax,%eax
80103929:	a3 00 a0 10 80       	mov    %eax,0x8010a000
    iinit(ROOTDEV);
8010392e:	e8 8d dc ff ff       	call   801015c0 <iinit>
    initlog(ROOTDEV);
80103933:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010393a:	e8 41 f4 ff ff       	call   80102d80 <initlog>
}
8010393f:	c9                   	leave  
80103940:	c3                   	ret    
80103941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394f:	90                   	nop

80103950 <pinit>:
{
80103950:	55                   	push   %ebp
  initlock(&ptable.lock, "ptable");
80103951:	b8 a0 77 10 80       	mov    $0x801077a0,%eax
{
80103956:	89 e5                	mov    %esp,%ebp
80103958:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010395b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010395f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103966:	e8 b5 0b 00 00       	call   80104520 <initlock>
}
8010396b:	c9                   	leave  
8010396c:	c3                   	ret    
8010396d:	8d 76 00             	lea    0x0(%esi),%esi

80103970 <mycpu>:
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
80103974:	53                   	push   %ebx
80103975:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103978:	9c                   	pushf  
80103979:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010397a:	f6 c4 02             	test   $0x2,%ah
8010397d:	75 52                	jne    801039d1 <mycpu+0x61>
  apicid = lapicid();
8010397f:	e8 3c f0 ff ff       	call   801029c0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103984:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010398a:	85 f6                	test   %esi,%esi
  apicid = lapicid();
8010398c:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010398e:	7e 35                	jle    801039c5 <mycpu+0x55>
80103990:	31 d2                	xor    %edx,%edx
80103992:	eb 11                	jmp    801039a5 <mycpu+0x35>
80103994:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop
801039a0:	42                   	inc    %edx
801039a1:	39 f2                	cmp    %esi,%edx
801039a3:	74 20                	je     801039c5 <mycpu+0x55>
    if (cpus[i].apicid == apicid)
801039a5:	8d 04 92             	lea    (%edx,%edx,4),%eax
801039a8:	8d 04 42             	lea    (%edx,%eax,2),%eax
801039ab:	c1 e0 04             	shl    $0x4,%eax
801039ae:	0f b6 88 80 27 11 80 	movzbl -0x7feed880(%eax),%ecx
801039b5:	39 d9                	cmp    %ebx,%ecx
801039b7:	75 e7                	jne    801039a0 <mycpu+0x30>
}
801039b9:	83 c4 10             	add    $0x10,%esp
      return &cpus[i];
801039bc:	05 80 27 11 80       	add    $0x80112780,%eax
}
801039c1:	5b                   	pop    %ebx
801039c2:	5e                   	pop    %esi
801039c3:	5d                   	pop    %ebp
801039c4:	c3                   	ret    
  panic("unknown apicid\n");
801039c5:	c7 04 24 a7 77 10 80 	movl   $0x801077a7,(%esp)
801039cc:	e8 8f c9 ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801039d1:	c7 04 24 84 78 10 80 	movl   $0x80107884,(%esp)
801039d8:	e8 83 c9 ff ff       	call   80100360 <panic>
801039dd:	8d 76 00             	lea    0x0(%esi),%esi

801039e0 <cpuid>:
cpuid() {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039e6:	e8 85 ff ff ff       	call   80103970 <mycpu>
}
801039eb:	c9                   	leave  
  return mycpu()-cpus;
801039ec:	2d 80 27 11 80       	sub    $0x80112780,%eax
801039f1:	c1 f8 04             	sar    $0x4,%eax
801039f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039fa:	c3                   	ret    
801039fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039ff:	90                   	nop

80103a00 <myproc>:
myproc(void) {
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
80103a04:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a07:	e8 84 0b 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103a0c:	e8 5f ff ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103a11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a17:	e8 c4 0b 00 00       	call   801045e0 <popcli>
}
80103a1c:	5a                   	pop    %edx
80103a1d:	89 d8                	mov    %ebx,%eax
80103a1f:	5b                   	pop    %ebx
80103a20:	5d                   	pop    %ebp
80103a21:	c3                   	ret    
80103a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a30 <userinit>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103a37:	e8 e4 fd ff ff       	call   80103820 <allocproc>
  initproc = p;
80103a3c:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  p = allocproc();
80103a41:	89 c3                	mov    %eax,%ebx
  if((p->pgdir = setupkvm()) == 0)
80103a43:	e8 48 35 00 00       	call   80106f90 <setupkvm>
80103a48:	89 43 04             	mov    %eax,0x4(%ebx)
80103a4b:	85 c0                	test   %eax,%eax
80103a4d:	0f 84 cf 00 00 00    	je     80103b22 <userinit+0xf2>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a53:	89 04 24             	mov    %eax,(%esp)
80103a56:	b9 60 a4 10 80       	mov    $0x8010a460,%ecx
80103a5b:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103a60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80103a64:	89 54 24 08          	mov    %edx,0x8(%esp)
80103a68:	e8 d3 31 00 00       	call   80106c40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a6d:	b8 4c 00 00 00       	mov    $0x4c,%eax
  p->sz = PGSIZE;
80103a72:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a78:	89 44 24 08          	mov    %eax,0x8(%esp)
80103a7c:	31 c0                	xor    %eax,%eax
80103a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a82:	8b 43 18             	mov    0x18(%ebx),%eax
80103a85:	89 04 24             	mov    %eax,(%esp)
80103a88:	e8 03 0d 00 00       	call   80104790 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a8d:	8b 43 18             	mov    0x18(%ebx),%eax
80103a90:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a96:	8b 43 18             	mov    0x18(%ebx),%eax
80103a99:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a9f:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa2:	8b 50 2c             	mov    0x2c(%eax),%edx
80103aa5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103aa9:	8b 43 18             	mov    0x18(%ebx),%eax
80103aac:	8b 50 2c             	mov    0x2c(%eax),%edx
80103aaf:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ab3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab6:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103abd:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ac7:	8b 43 18             	mov    0x18(%ebx),%eax
80103aca:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ad1:	b8 10 00 00 00       	mov    $0x10,%eax
80103ad6:	89 44 24 08          	mov    %eax,0x8(%esp)
80103ada:	b8 d0 77 10 80       	mov    $0x801077d0,%eax
80103adf:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ae3:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ae6:	89 04 24             	mov    %eax,(%esp)
80103ae9:	e8 82 0e 00 00       	call   80104970 <safestrcpy>
  p->cwd = namei("/");
80103aee:	c7 04 24 d9 77 10 80 	movl   $0x801077d9,(%esp)
80103af5:	e8 76 e6 ff ff       	call   80102170 <namei>
80103afa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103afd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b04:	e8 87 0b 00 00       	call   80104690 <acquire>
  p->state = RUNNABLE;
80103b09:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b10:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b17:	e8 24 0c 00 00       	call   80104740 <release>
}
80103b1c:	83 c4 14             	add    $0x14,%esp
80103b1f:	5b                   	pop    %ebx
80103b20:	5d                   	pop    %ebp
80103b21:	c3                   	ret    
    panic("userinit: out of memory?");
80103b22:	c7 04 24 b7 77 10 80 	movl   $0x801077b7,(%esp)
80103b29:	e8 32 c8 ff ff       	call   80100360 <panic>
80103b2e:	66 90                	xchg   %ax,%ax

80103b30 <growproc>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	56                   	push   %esi
80103b34:	53                   	push   %ebx
80103b35:	83 ec 10             	sub    $0x10,%esp
80103b38:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b3b:	e8 50 0a 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103b40:	e8 2b fe ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103b45:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b4b:	e8 90 0a 00 00       	call   801045e0 <popcli>
  if(n > 0){
80103b50:	85 f6                	test   %esi,%esi
  sz = curproc->sz;
80103b52:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b54:	7f 1a                	jg     80103b70 <growproc+0x40>
  } else if(n < 0){
80103b56:	75 38                	jne    80103b90 <growproc+0x60>
  curproc->sz = sz;
80103b58:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b5a:	89 1c 24             	mov    %ebx,(%esp)
80103b5d:	e8 de 2f 00 00       	call   80106b40 <switchuvm>
  return 0;
80103b62:	31 c0                	xor    %eax,%eax
}
80103b64:	83 c4 10             	add    $0x10,%esp
80103b67:	5b                   	pop    %ebx
80103b68:	5e                   	pop    %esi
80103b69:	5d                   	pop    %ebp
80103b6a:	c3                   	ret    
80103b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b70:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b74:	01 c6                	add    %eax,%esi
80103b76:	89 74 24 08          	mov    %esi,0x8(%esp)
80103b7a:	8b 43 04             	mov    0x4(%ebx),%eax
80103b7d:	89 04 24             	mov    %eax,(%esp)
80103b80:	e8 1b 32 00 00       	call   80106da0 <allocuvm>
80103b85:	85 c0                	test   %eax,%eax
80103b87:	75 cf                	jne    80103b58 <growproc+0x28>
      return -1;
80103b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b8e:	eb d4                	jmp    80103b64 <growproc+0x34>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b90:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b94:	01 c6                	add    %eax,%esi
80103b96:	89 74 24 08          	mov    %esi,0x8(%esp)
80103b9a:	8b 43 04             	mov    0x4(%ebx),%eax
80103b9d:	89 04 24             	mov    %eax,(%esp)
80103ba0:	e8 3b 33 00 00       	call   80106ee0 <deallocuvm>
80103ba5:	85 c0                	test   %eax,%eax
80103ba7:	75 af                	jne    80103b58 <growproc+0x28>
80103ba9:	eb de                	jmp    80103b89 <growproc+0x59>
80103bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103baf:	90                   	nop

80103bb0 <fork>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	57                   	push   %edi
80103bb4:	56                   	push   %esi
80103bb5:	53                   	push   %ebx
80103bb6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bb9:	e8 d2 09 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103bbe:	e8 ad fd ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103bc3:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103bc9:	e8 12 0a 00 00       	call   801045e0 <popcli>
  if((np = allocproc()) == 0){
80103bce:	e8 4d fc ff ff       	call   80103820 <allocproc>
80103bd3:	85 c0                	test   %eax,%eax
80103bd5:	0f 84 c4 00 00 00    	je     80103c9f <fork+0xef>
80103bdb:	89 c6                	mov    %eax,%esi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bdd:	8b 07                	mov    (%edi),%eax
80103bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80103be3:	8b 47 04             	mov    0x4(%edi),%eax
80103be6:	89 04 24             	mov    %eax,(%esp)
80103be9:	e8 82 34 00 00       	call   80107070 <copyuvm>
80103bee:	89 46 04             	mov    %eax,0x4(%esi)
80103bf1:	85 c0                	test   %eax,%eax
80103bf3:	0f 84 ad 00 00 00    	je     80103ca6 <fork+0xf6>
  np->sz = curproc->sz;
80103bf9:	8b 07                	mov    (%edi),%eax
  np->parent = curproc;
80103bfb:	89 7e 14             	mov    %edi,0x14(%esi)
  *np->tf = *curproc->tf;
80103bfe:	8b 4e 18             	mov    0x18(%esi),%ecx
  np->sz = curproc->sz;
80103c01:	89 06                	mov    %eax,(%esi)
  *np->tf = *curproc->tf;
80103c03:	31 c0                	xor    %eax,%eax
80103c05:	8b 5f 18             	mov    0x18(%edi),%ebx
80103c08:	8b 14 03             	mov    (%ebx,%eax,1),%edx
80103c0b:	89 14 01             	mov    %edx,(%ecx,%eax,1)
80103c0e:	83 c0 04             	add    $0x4,%eax
80103c11:	83 f8 4c             	cmp    $0x4c,%eax
80103c14:	72 f2                	jb     80103c08 <fork+0x58>
  np->tf->eax = 0;
80103c16:	8b 46 18             	mov    0x18(%esi),%eax
  for(i = 0; i < NOFILE; i++)
80103c19:	31 db                	xor    %ebx,%ebx
  np->tf->eax = 0;
80103c1b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c30:	8b 44 9f 28          	mov    0x28(%edi,%ebx,4),%eax
80103c34:	85 c0                	test   %eax,%eax
80103c36:	74 0c                	je     80103c44 <fork+0x94>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c38:	89 04 24             	mov    %eax,(%esp)
80103c3b:	e8 50 d2 ff ff       	call   80100e90 <filedup>
80103c40:	89 44 9e 28          	mov    %eax,0x28(%esi,%ebx,4)
  for(i = 0; i < NOFILE; i++)
80103c44:	43                   	inc    %ebx
80103c45:	83 fb 10             	cmp    $0x10,%ebx
80103c48:	75 e6                	jne    80103c30 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103c4a:	8b 47 68             	mov    0x68(%edi),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c4d:	83 c7 6c             	add    $0x6c,%edi
  np->cwd = idup(curproc->cwd);
80103c50:	89 04 24             	mov    %eax,(%esp)
80103c53:	e8 78 db ff ff       	call   801017d0 <idup>
80103c58:	89 46 68             	mov    %eax,0x68(%esi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c5b:	b8 10 00 00 00       	mov    $0x10,%eax
80103c60:	89 44 24 08          	mov    %eax,0x8(%esp)
80103c64:	8d 46 6c             	lea    0x6c(%esi),%eax
80103c67:	89 7c 24 04          	mov    %edi,0x4(%esp)
80103c6b:	89 04 24             	mov    %eax,(%esp)
80103c6e:	e8 fd 0c 00 00       	call   80104970 <safestrcpy>
  pid = np->pid;
80103c73:	8b 5e 10             	mov    0x10(%esi),%ebx
  acquire(&ptable.lock);
80103c76:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c7d:	e8 0e 0a 00 00       	call   80104690 <acquire>
  np->state = RUNNABLE;
80103c82:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  release(&ptable.lock);
80103c89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c90:	e8 ab 0a 00 00       	call   80104740 <release>
}
80103c95:	83 c4 1c             	add    $0x1c,%esp
80103c98:	89 d8                	mov    %ebx,%eax
80103c9a:	5b                   	pop    %ebx
80103c9b:	5e                   	pop    %esi
80103c9c:	5f                   	pop    %edi
80103c9d:	5d                   	pop    %ebp
80103c9e:	c3                   	ret    
    return -1;
80103c9f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ca4:	eb ef                	jmp    80103c95 <fork+0xe5>
    kfree(np->kstack);
80103ca6:	8b 46 08             	mov    0x8(%esi),%eax
    return -1;
80103ca9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103cae:	89 04 24             	mov    %eax,(%esp)
80103cb1:	e8 ca e8 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80103cb6:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
    np->state = UNUSED;
80103cbd:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return -1;
80103cc4:	eb cf                	jmp    80103c95 <fork+0xe5>
80103cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi

80103cd0 <scheduler>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103cd9:	e8 92 fc ff ff       	call   80103970 <mycpu>
  c->proc = 0;
80103cde:	31 d2                	xor    %edx,%edx
80103ce0:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80103ce6:	8d 78 04             	lea    0x4(%eax),%edi
  struct cpu *c = mycpu();
80103ce9:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cef:	90                   	nop
  asm volatile("sti");
80103cf0:	fb                   	sti    
    acquire(&ptable.lock);
80103cf1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103cfd:	e8 8e 09 00 00       	call   80104690 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->state != RUNNABLE)
80103d10:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d14:	75 31                	jne    80103d47 <scheduler+0x77>
      c->proc = p;
80103d16:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d1c:	89 1c 24             	mov    %ebx,(%esp)
80103d1f:	e8 1c 2e 00 00       	call   80106b40 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d24:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d27:	89 3c 24             	mov    %edi,(%esp)
      p->state = RUNNING;
80103d2a:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d31:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d35:	e8 8f 0c 00 00       	call   801049c9 <swtch>
      switchkvm();
80103d3a:	e8 f1 2d 00 00       	call   80106b30 <switchkvm>
      c->proc = 0;
80103d3f:	31 c0                	xor    %eax,%eax
80103d41:	89 86 ac 00 00 00    	mov    %eax,0xac(%esi)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d47:	83 c3 7c             	add    $0x7c,%ebx
80103d4a:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103d50:	75 be                	jne    80103d10 <scheduler+0x40>
    release(&ptable.lock);
80103d52:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d59:	e8 e2 09 00 00       	call   80104740 <release>
    sti();
80103d5e:	eb 90                	jmp    80103cf0 <scheduler+0x20>

80103d60 <sched>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	56                   	push   %esi
80103d64:	53                   	push   %ebx
80103d65:	83 ec 10             	sub    $0x10,%esp
  pushcli();
80103d68:	e8 23 08 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103d6d:	e8 fe fb ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103d72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d78:	e8 63 08 00 00       	call   801045e0 <popcli>
  if(!holding(&ptable.lock))
80103d7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d84:	e8 b7 08 00 00       	call   80104640 <holding>
80103d89:	85 c0                	test   %eax,%eax
80103d8b:	74 4f                	je     80103ddc <sched+0x7c>
  if(mycpu()->ncli != 1)
80103d8d:	e8 de fb ff ff       	call   80103970 <mycpu>
80103d92:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d99:	75 65                	jne    80103e00 <sched+0xa0>
  if(p->state == RUNNING)
80103d9b:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d9f:	74 53                	je     80103df4 <sched+0x94>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103da1:	9c                   	pushf  
80103da2:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103da3:	f6 c4 02             	test   $0x2,%ah
80103da6:	75 40                	jne    80103de8 <sched+0x88>
  intena = mycpu()->intena;
80103da8:	e8 c3 fb ff ff       	call   80103970 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dad:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103db0:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103db6:	e8 b5 fb ff ff       	call   80103970 <mycpu>
80103dbb:	8b 40 04             	mov    0x4(%eax),%eax
80103dbe:	89 1c 24             	mov    %ebx,(%esp)
80103dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dc5:	e8 ff 0b 00 00       	call   801049c9 <swtch>
  mycpu()->intena = intena;
80103dca:	e8 a1 fb ff ff       	call   80103970 <mycpu>
80103dcf:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103dd5:	83 c4 10             	add    $0x10,%esp
80103dd8:	5b                   	pop    %ebx
80103dd9:	5e                   	pop    %esi
80103dda:	5d                   	pop    %ebp
80103ddb:	c3                   	ret    
    panic("sched ptable.lock");
80103ddc:	c7 04 24 db 77 10 80 	movl   $0x801077db,(%esp)
80103de3:	e8 78 c5 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103de8:	c7 04 24 07 78 10 80 	movl   $0x80107807,(%esp)
80103def:	e8 6c c5 ff ff       	call   80100360 <panic>
    panic("sched running");
80103df4:	c7 04 24 f9 77 10 80 	movl   $0x801077f9,(%esp)
80103dfb:	e8 60 c5 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103e00:	c7 04 24 ed 77 10 80 	movl   $0x801077ed,(%esp)
80103e07:	e8 54 c5 ff ff       	call   80100360 <panic>
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e10 <exit>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e19:	e8 72 07 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103e1e:	e8 4d fb ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103e23:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e29:	e8 b2 07 00 00       	call   801045e0 <popcli>
  if(curproc == initproc)
80103e2e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103e34:	0f 84 ec 00 00 00    	je     80103f26 <exit+0x116>
80103e3a:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e3d:	8d 7e 68             	lea    0x68(%esi),%edi
    if(curproc->ofile[fd]){
80103e40:	8b 03                	mov    (%ebx),%eax
80103e42:	85 c0                	test   %eax,%eax
80103e44:	74 0e                	je     80103e54 <exit+0x44>
      fileclose(curproc->ofile[fd]);
80103e46:	89 04 24             	mov    %eax,(%esp)
80103e49:	e8 92 d0 ff ff       	call   80100ee0 <fileclose>
      curproc->ofile[fd] = 0;
80103e4e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  for(fd = 0; fd < NOFILE; fd++){
80103e54:	83 c3 04             	add    $0x4,%ebx
80103e57:	39 df                	cmp    %ebx,%edi
80103e59:	75 e5                	jne    80103e40 <exit+0x30>
  begin_op();
80103e5b:	e8 b0 ef ff ff       	call   80102e10 <begin_op>
  iput(curproc->cwd);
80103e60:	8b 46 68             	mov    0x68(%esi),%eax
80103e63:	89 04 24             	mov    %eax,(%esp)
80103e66:	e8 c5 da ff ff       	call   80101930 <iput>
  end_op();
80103e6b:	e8 10 f0 ff ff       	call   80102e80 <end_op>
  curproc->cwd = 0;
80103e70:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e77:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e7e:	e8 0d 08 00 00       	call   80104690 <acquire>
  wakeup1(curproc->parent);
80103e83:	8b 56 14             	mov    0x14(%esi),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e86:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e8b:	eb 0d                	jmp    80103e9a <exit+0x8a>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
80103e90:	83 c0 7c             	add    $0x7c,%eax
80103e93:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e98:	74 1c                	je     80103eb6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e9a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e9e:	75 f0                	jne    80103e90 <exit+0x80>
80103ea0:	3b 50 20             	cmp    0x20(%eax),%edx
80103ea3:	75 eb                	jne    80103e90 <exit+0x80>
      p->state = RUNNABLE;
80103ea5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eac:	83 c0 7c             	add    $0x7c,%eax
80103eaf:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103eb4:	75 e4                	jne    80103e9a <exit+0x8a>
      p->parent = initproc;
80103eb6:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ebc:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ec1:	eb 18                	jmp    80103edb <exit+0xcb>
80103ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ed0:	83 c2 7c             	add    $0x7c,%edx
80103ed3:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103ed9:	74 33                	je     80103f0e <exit+0xfe>
    if(p->parent == curproc){
80103edb:	39 72 14             	cmp    %esi,0x14(%edx)
80103ede:	75 f0                	jne    80103ed0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103ee0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ee4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ee7:	75 e7                	jne    80103ed0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103eee:	eb 0a                	jmp    80103efa <exit+0xea>
80103ef0:	83 c0 7c             	add    $0x7c,%eax
80103ef3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103ef8:	74 d6                	je     80103ed0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103efa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103efe:	75 f0                	jne    80103ef0 <exit+0xe0>
80103f00:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f03:	75 eb                	jne    80103ef0 <exit+0xe0>
      p->state = RUNNABLE;
80103f05:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f0c:	eb e2                	jmp    80103ef0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103f0e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f15:	e8 46 fe ff ff       	call   80103d60 <sched>
  panic("zombie exit");
80103f1a:	c7 04 24 28 78 10 80 	movl   $0x80107828,(%esp)
80103f21:	e8 3a c4 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103f26:	c7 04 24 1b 78 10 80 	movl   $0x8010781b,(%esp)
80103f2d:	e8 2e c4 ff ff       	call   80100360 <panic>
80103f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f40 <yield>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	53                   	push   %ebx
80103f44:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f47:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f4e:	e8 3d 07 00 00       	call   80104690 <acquire>
  pushcli();
80103f53:	e8 38 06 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103f58:	e8 13 fa ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103f5d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f63:	e8 78 06 00 00       	call   801045e0 <popcli>
  myproc()->state = RUNNABLE;
80103f68:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f6f:	e8 ec fd ff ff       	call   80103d60 <sched>
  release(&ptable.lock);
80103f74:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f7b:	e8 c0 07 00 00       	call   80104740 <release>
}
80103f80:	83 c4 14             	add    $0x14,%esp
80103f83:	5b                   	pop    %ebx
80103f84:	5d                   	pop    %ebp
80103f85:	c3                   	ret    
80103f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi

80103f90 <sleep>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	83 ec 28             	sub    $0x28,%esp
80103f96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80103f99:	89 75 f8             	mov    %esi,-0x8(%ebp)
80103f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80103f9f:	89 7d fc             	mov    %edi,-0x4(%ebp)
80103fa2:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80103fa5:	e8 e6 05 00 00       	call   80104590 <pushcli>
  c = mycpu();
80103faa:	e8 c1 f9 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80103faf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb5:	e8 26 06 00 00       	call   801045e0 <popcli>
  if(p == 0)
80103fba:	85 db                	test   %ebx,%ebx
80103fbc:	0f 84 8d 00 00 00    	je     8010404f <sleep+0xbf>
  if(lk == 0)
80103fc2:	85 f6                	test   %esi,%esi
80103fc4:	74 7d                	je     80104043 <sleep+0xb3>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fc6:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103fcc:	74 52                	je     80104020 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fd5:	e8 b6 06 00 00       	call   80104690 <acquire>
    release(lk);
80103fda:	89 34 24             	mov    %esi,(%esp)
80103fdd:	e8 5e 07 00 00       	call   80104740 <release>
  p->chan = chan;
80103fe2:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fe5:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fec:	e8 6f fd ff ff       	call   80103d60 <sched>
  p->chan = 0;
80103ff1:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ff8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fff:	e8 3c 07 00 00       	call   80104740 <release>
}
80104004:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    acquire(lk);
80104007:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010400a:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010400d:	8b 75 f8             	mov    -0x8(%ebp),%esi
80104010:	89 ec                	mov    %ebp,%esp
80104012:	5d                   	pop    %ebp
    acquire(lk);
80104013:	e9 78 06 00 00       	jmp    80104690 <acquire>
80104018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401f:	90                   	nop
  p->chan = chan;
80104020:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104023:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010402a:	e8 31 fd ff ff       	call   80103d60 <sched>
  p->chan = 0;
8010402f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104036:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104039:	8b 75 f8             	mov    -0x8(%ebp),%esi
8010403c:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010403f:	89 ec                	mov    %ebp,%esp
80104041:	5d                   	pop    %ebp
80104042:	c3                   	ret    
    panic("sleep without lk");
80104043:	c7 04 24 3a 78 10 80 	movl   $0x8010783a,(%esp)
8010404a:	e8 11 c3 ff ff       	call   80100360 <panic>
    panic("sleep");
8010404f:	c7 04 24 34 78 10 80 	movl   $0x80107834,(%esp)
80104056:	e8 05 c3 ff ff       	call   80100360 <panic>
8010405b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010405f:	90                   	nop

80104060 <wait>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	56                   	push   %esi
80104064:	53                   	push   %ebx
80104065:	83 ec 10             	sub    $0x10,%esp
  pushcli();
80104068:	e8 23 05 00 00       	call   80104590 <pushcli>
  c = mycpu();
8010406d:	e8 fe f8 ff ff       	call   80103970 <mycpu>
  p = c->proc;
80104072:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104078:	e8 63 05 00 00       	call   801045e0 <popcli>
  acquire(&ptable.lock);
8010407d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104084:	e8 07 06 00 00       	call   80104690 <acquire>
    havekids = 0;
80104089:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408b:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104090:	eb 19                	jmp    801040ab <wait+0x4b>
80104092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040a0:	83 c3 7c             	add    $0x7c,%ebx
801040a3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801040a9:	74 1b                	je     801040c6 <wait+0x66>
      if(p->parent != curproc)
801040ab:	39 73 14             	cmp    %esi,0x14(%ebx)
801040ae:	75 f0                	jne    801040a0 <wait+0x40>
      if(p->state == ZOMBIE){
801040b0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040b4:	74 3a                	je     801040f0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801040b9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040be:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801040c4:	75 e5                	jne    801040ab <wait+0x4b>
    if(!havekids || curproc->killed){
801040c6:	85 c0                	test   %eax,%eax
801040c8:	74 7b                	je     80104145 <wait+0xe5>
801040ca:	8b 56 24             	mov    0x24(%esi),%edx
801040cd:	85 d2                	test   %edx,%edx
801040cf:	75 74                	jne    80104145 <wait+0xe5>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040d1:	89 34 24             	mov    %esi,(%esp)
801040d4:	b8 20 2d 11 80       	mov    $0x80112d20,%eax
801040d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801040dd:	e8 ae fe ff ff       	call   80103f90 <sleep>
    havekids = 0;
801040e2:	eb a5                	jmp    80104089 <wait+0x29>
801040e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ef:	90                   	nop
        kfree(p->kstack);
801040f0:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
801040f3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040f6:	89 04 24             	mov    %eax,(%esp)
801040f9:	e8 82 e4 ff ff       	call   80102580 <kfree>
        freevm(p->pgdir);
801040fe:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80104101:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104108:	89 04 24             	mov    %eax,(%esp)
8010410b:	e8 00 2e 00 00       	call   80106f10 <freevm>
        release(&ptable.lock);
80104110:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104117:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010411e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104125:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104129:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104130:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104137:	e8 04 06 00 00       	call   80104740 <release>
}
8010413c:	83 c4 10             	add    $0x10,%esp
8010413f:	89 f0                	mov    %esi,%eax
80104141:	5b                   	pop    %ebx
80104142:	5e                   	pop    %esi
80104143:	5d                   	pop    %ebp
80104144:	c3                   	ret    
      release(&ptable.lock);
80104145:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      return -1;
8010414c:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104151:	e8 ea 05 00 00       	call   80104740 <release>
      return -1;
80104156:	eb e4                	jmp    8010413c <wait+0xdc>
80104158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415f:	90                   	nop

80104160 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80104167:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
{
8010416e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104171:	e8 1a 05 00 00       	call   80104690 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104176:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010417b:	eb 0d                	jmp    8010418a <wakeup+0x2a>
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
80104180:	83 c0 7c             	add    $0x7c,%eax
80104183:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104188:	74 1c                	je     801041a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010418a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010418e:	75 f0                	jne    80104180 <wakeup+0x20>
80104190:	3b 58 20             	cmp    0x20(%eax),%ebx
80104193:	75 eb                	jne    80104180 <wakeup+0x20>
      p->state = RUNNABLE;
80104195:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419c:	83 c0 7c             	add    $0x7c,%eax
8010419f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801041a4:	75 e4                	jne    8010418a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801041a6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801041ad:	83 c4 14             	add    $0x14,%esp
801041b0:	5b                   	pop    %ebx
801041b1:	5d                   	pop    %ebp
  release(&ptable.lock);
801041b2:	e9 89 05 00 00       	jmp    80104740 <release>
801041b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041be:	66 90                	xchg   %ax,%ax

801041c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;

  acquire(&ptable.lock);
801041c7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
{
801041ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041d1:	e8 ba 04 00 00       	call   80104690 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041db:	eb 0d                	jmp    801041ea <kill+0x2a>
801041dd:	8d 76 00             	lea    0x0(%esi),%esi
801041e0:	83 c0 7c             	add    $0x7c,%eax
801041e3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801041e8:	74 36                	je     80104220 <kill+0x60>
    if(p->pid == pid){
801041ea:	39 58 10             	cmp    %ebx,0x10(%eax)
801041ed:	75 f1                	jne    801041e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041ef:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041f3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041fa:	75 07                	jne    80104203 <kill+0x43>
        p->state = RUNNABLE;
801041fc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104203:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010420a:	e8 31 05 00 00       	call   80104740 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010420f:	83 c4 14             	add    $0x14,%esp
      return 0;
80104212:	31 c0                	xor    %eax,%eax
}
80104214:	5b                   	pop    %ebx
80104215:	5d                   	pop    %ebp
80104216:	c3                   	ret    
80104217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80104220:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104227:	e8 14 05 00 00       	call   80104740 <release>
}
8010422c:	83 c4 14             	add    $0x14,%esp
  return -1;
8010422f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104234:	5b                   	pop    %ebx
80104235:	5d                   	pop    %ebp
80104236:	c3                   	ret    
80104237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423e:	66 90                	xchg   %ax,%ax

80104240 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010424b:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010424e:	83 ec 4c             	sub    $0x4c,%esp
80104251:	eb 28                	jmp    8010427b <procdump+0x3b>
80104253:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104260:	c7 04 24 bb 7b 10 80 	movl   $0x80107bbb,(%esp)
80104267:	e8 14 c4 ff ff       	call   80100680 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426c:	83 c3 7c             	add    $0x7c,%ebx
8010426f:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104275:	0f 84 95 00 00 00    	je     80104310 <procdump+0xd0>
    if(p->state == UNUSED)
8010427b:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010427e:	85 c0                	test   %eax,%eax
80104280:	74 ea                	je     8010426c <procdump+0x2c>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104282:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104285:	ba 4b 78 10 80       	mov    $0x8010784b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010428a:	77 11                	ja     8010429d <procdump+0x5d>
8010428c:	8b 14 85 ac 78 10 80 	mov    -0x7fef8754(,%eax,4),%edx
      state = "???";
80104293:	b8 4b 78 10 80       	mov    $0x8010784b,%eax
80104298:	85 d2                	test   %edx,%edx
8010429a:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010429d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801042a1:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801042a4:	89 54 24 08          	mov    %edx,0x8(%esp)
801042a8:	c7 04 24 4f 78 10 80 	movl   $0x8010784f,(%esp)
801042af:	89 44 24 04          	mov    %eax,0x4(%esp)
801042b3:	e8 c8 c3 ff ff       	call   80100680 <cprintf>
    if(p->state == SLEEPING){
801042b8:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042bc:	75 a2                	jne    80104260 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042be:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801042c5:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042c8:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042cb:	8b 40 0c             	mov    0xc(%eax),%eax
801042ce:	83 c0 08             	add    $0x8,%eax
801042d1:	89 04 24             	mov    %eax,(%esp)
801042d4:	e8 67 02 00 00       	call   80104540 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e0:	8b 17                	mov    (%edi),%edx
801042e2:	85 d2                	test   %edx,%edx
801042e4:	0f 84 76 ff ff ff    	je     80104260 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042ea:	89 54 24 04          	mov    %edx,0x4(%esp)
801042ee:	83 c7 04             	add    $0x4,%edi
801042f1:	c7 04 24 a1 72 10 80 	movl   $0x801072a1,(%esp)
801042f8:	e8 83 c3 ff ff       	call   80100680 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042fd:	39 fe                	cmp    %edi,%esi
801042ff:	75 df                	jne    801042e0 <procdump+0xa0>
80104301:	e9 5a ff ff ff       	jmp    80104260 <procdump+0x20>
80104306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
  }
}
80104310:	83 c4 4c             	add    $0x4c,%esp
80104313:	5b                   	pop    %ebx
80104314:	5e                   	pop    %esi
80104315:	5f                   	pop    %edi
80104316:	5d                   	pop    %ebp
80104317:	c3                   	ret    
80104318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431f:	90                   	nop

80104320 <proc_dump>:
void
proc_dump(struct proc_info *process, int *size)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	53                   	push   %ebx
80104326:	83 ec 2c             	sub    $0x2c,%esp
80104329:	8b 45 0c             	mov    0xc(%ebp),%eax
8010432c:	8b 7d 08             	mov    0x8(%ebp),%edi
    struct proc *p = ptable.proc;
    struct proc_info *list = process;
    (*size) = 0;
8010432f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    acquire(&ptable.lock);
80104335:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
{
8010433c:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010433f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    acquire(&ptable.lock);
80104342:	e8 49 03 00 00       	call   80104690 <acquire>
    struct proc_info *list = process;
80104347:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    struct proc *p = ptable.proc;
8010434a:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
8010434f:	eb 1a                	jmp    8010436b <proc_dump+0x4b>
80104351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435f:	90                   	nop

    for (int i = 0; i < NPROC; ++i, ++p) 
80104360:	83 c7 7c             	add    $0x7c,%edi
80104363:	81 ff 54 4c 11 80    	cmp    $0x80114c54,%edi
80104369:	74 61                	je     801043cc <proc_dump+0xac>
    {
        if (p->state != RUNNING && p->state != RUNNABLE)
8010436b:	8b 47 0c             	mov    0xc(%edi),%eax
8010436e:	83 e8 03             	sub    $0x3,%eax
80104371:	83 f8 01             	cmp    $0x1,%eax
80104374:	77 ea                	ja     80104360 <proc_dump+0x40>
            continue;

        list->memsize = p->sz;
80104376:	8b 07                	mov    (%edi),%eax
80104378:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        list->pid = p->pid;
        list++;
        (*size)++;
8010437b:	8b 75 e0             	mov    -0x20(%ebp),%esi
        list->memsize = p->sz;
8010437e:	89 42 04             	mov    %eax,0x4(%edx)
        list++;
80104381:	83 c2 08             	add    $0x8,%edx
        list->pid = p->pid;
80104384:	8b 47 10             	mov    0x10(%edi),%eax
80104387:	89 42 f8             	mov    %eax,-0x8(%edx)
        list++;
8010438a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        (*size)++;
8010438d:	8b 16                	mov    (%esi),%edx
8010438f:	8d 42 01             	lea    0x1(%edx),%eax

        for (int j = (*size) - 1; j > 0; --j) 
80104392:	85 d2                	test   %edx,%edx
        (*size)++;
80104394:	89 06                	mov    %eax,(%esi)
        for (int j = (*size) - 1; j > 0; --j) 
80104396:	7e c8                	jle    80104360 <proc_dump+0x40>
80104398:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010439b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
8010439e:	eb 17                	jmp    801043b7 <proc_dump+0x97>
            if (process[j].memsize >= process[j - 1].memsize)
                break;

            int sz = process[j - 1].memsize;
            int pid = process[j - 1].pid;
            process[j - 1].memsize = process[j].memsize;
801043a0:	89 58 fc             	mov    %ebx,-0x4(%eax)
            int pid = process[j - 1].pid;
801043a3:	8b 70 f8             	mov    -0x8(%eax),%esi
            process[j - 1].pid = process[j].pid;
801043a6:	83 e8 08             	sub    $0x8,%eax
            process[j].memsize = sz;
801043a9:	89 48 0c             	mov    %ecx,0xc(%eax)
            process[j - 1].pid = process[j].pid;
801043ac:	8b 58 08             	mov    0x8(%eax),%ebx
            process[j].pid = pid;
801043af:	89 70 08             	mov    %esi,0x8(%eax)
            process[j - 1].pid = process[j].pid;
801043b2:	89 18                	mov    %ebx,(%eax)
        for (int j = (*size) - 1; j > 0; --j) 
801043b4:	4a                   	dec    %edx
801043b5:	74 a9                	je     80104360 <proc_dump+0x40>
            if (process[j].memsize >= process[j - 1].memsize)
801043b7:	8b 58 04             	mov    0x4(%eax),%ebx
801043ba:	8b 48 fc             	mov    -0x4(%eax),%ecx
801043bd:	39 cb                	cmp    %ecx,%ebx
801043bf:	7c df                	jl     801043a0 <proc_dump+0x80>
    for (int i = 0; i < NPROC; ++i, ++p) 
801043c1:	83 c7 7c             	add    $0x7c,%edi
801043c4:	81 ff 54 4c 11 80    	cmp    $0x80114c54,%edi
801043ca:	75 9f                	jne    8010436b <proc_dump+0x4b>
        }
    }
    release(&ptable.lock);
801043cc:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)

    return;
801043d3:	83 c4 2c             	add    $0x2c,%esp
801043d6:	5b                   	pop    %ebx
801043d7:	5e                   	pop    %esi
801043d8:	5f                   	pop    %edi
801043d9:	5d                   	pop    %ebp
    release(&ptable.lock);
801043da:	e9 61 03 00 00       	jmp    80104740 <release>
801043df:	90                   	nop

801043e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043e0:	55                   	push   %ebp
  initlock(&lk->lk, "sleep lock");
801043e1:	b8 c4 78 10 80       	mov    $0x801078c4,%eax
{
801043e6:	89 e5                	mov    %esp,%ebp
801043e8:	53                   	push   %ebx
801043e9:	83 ec 14             	sub    $0x14,%esp
  initlock(&lk->lk, "sleep lock");
801043ec:	89 44 24 04          	mov    %eax,0x4(%esp)
{
801043f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043f3:	8d 43 04             	lea    0x4(%ebx),%eax
801043f6:	89 04 24             	mov    %eax,(%esp)
801043f9:	e8 22 01 00 00       	call   80104520 <initlock>
  lk->name = name;
801043fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104401:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104407:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010440e:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104411:	83 c4 14             	add    $0x14,%esp
80104414:	5b                   	pop    %ebx
80104415:	5d                   	pop    %ebp
80104416:	c3                   	ret    
80104417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441e:	66 90                	xchg   %ax,%ax

80104420 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	83 ec 10             	sub    $0x10,%esp
80104428:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010442b:	8d 73 04             	lea    0x4(%ebx),%esi
8010442e:	89 34 24             	mov    %esi,(%esp)
80104431:	e8 5a 02 00 00       	call   80104690 <acquire>
  while (lk->locked) {
80104436:	8b 13                	mov    (%ebx),%edx
80104438:	85 d2                	test   %edx,%edx
8010443a:	74 16                	je     80104452 <acquiresleep+0x32>
8010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104440:	89 74 24 04          	mov    %esi,0x4(%esp)
80104444:	89 1c 24             	mov    %ebx,(%esp)
80104447:	e8 44 fb ff ff       	call   80103f90 <sleep>
  while (lk->locked) {
8010444c:	8b 03                	mov    (%ebx),%eax
8010444e:	85 c0                	test   %eax,%eax
80104450:	75 ee                	jne    80104440 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104452:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104458:	e8 a3 f5 ff ff       	call   80103a00 <myproc>
8010445d:	8b 40 10             	mov    0x10(%eax),%eax
80104460:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104463:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104466:	83 c4 10             	add    $0x10,%esp
80104469:	5b                   	pop    %ebx
8010446a:	5e                   	pop    %esi
8010446b:	5d                   	pop    %ebp
  release(&lk->lk);
8010446c:	e9 cf 02 00 00       	jmp    80104740 <release>
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447f:	90                   	nop

80104480 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	83 ec 18             	sub    $0x18,%esp
80104486:	89 5d f8             	mov    %ebx,-0x8(%ebp)
80104489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010448c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  acquire(&lk->lk);
8010448f:	8d 73 04             	lea    0x4(%ebx),%esi
80104492:	89 34 24             	mov    %esi,(%esp)
80104495:	e8 f6 01 00 00       	call   80104690 <acquire>
  lk->locked = 0;
8010449a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044a0:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044a7:	89 1c 24             	mov    %ebx,(%esp)
801044aa:	e8 b1 fc ff ff       	call   80104160 <wakeup>
  release(&lk->lk);
}
801044af:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  release(&lk->lk);
801044b2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044b5:	8b 75 fc             	mov    -0x4(%ebp),%esi
801044b8:	89 ec                	mov    %ebp,%esp
801044ba:	5d                   	pop    %ebp
  release(&lk->lk);
801044bb:	e9 80 02 00 00       	jmp    80104740 <release>

801044c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	83 ec 28             	sub    $0x28,%esp
801044c6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
801044c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044cc:	89 75 f8             	mov    %esi,-0x8(%ebp)
801044cf:	89 7d fc             	mov    %edi,-0x4(%ebp)
801044d2:	31 ff                	xor    %edi,%edi
  int r;
  
  acquire(&lk->lk);
801044d4:	8d 73 04             	lea    0x4(%ebx),%esi
801044d7:	89 34 24             	mov    %esi,(%esp)
801044da:	e8 b1 01 00 00       	call   80104690 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044df:	8b 03                	mov    (%ebx),%eax
801044e1:	85 c0                	test   %eax,%eax
801044e3:	75 1b                	jne    80104500 <holdingsleep+0x40>
  release(&lk->lk);
801044e5:	89 34 24             	mov    %esi,(%esp)
801044e8:	e8 53 02 00 00       	call   80104740 <release>
  return r;
}
801044ed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801044f0:	89 f8                	mov    %edi,%eax
801044f2:	8b 75 f8             	mov    -0x8(%ebp),%esi
801044f5:	8b 7d fc             	mov    -0x4(%ebp),%edi
801044f8:	89 ec                	mov    %ebp,%esp
801044fa:	5d                   	pop    %ebp
801044fb:	c3                   	ret    
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104500:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104503:	e8 f8 f4 ff ff       	call   80103a00 <myproc>
80104508:	39 58 10             	cmp    %ebx,0x10(%eax)
8010450b:	0f 94 c0             	sete   %al
8010450e:	0f b6 f8             	movzbl %al,%edi
80104511:	eb d2                	jmp    801044e5 <holdingsleep+0x25>
80104513:	66 90                	xchg   %ax,%ax
80104515:	66 90                	xchg   %ax,%ax
80104517:	66 90                	xchg   %ax,%ax
80104519:	66 90                	xchg   %ax,%ax
8010451b:	66 90                	xchg   %ax,%ax
8010451d:	66 90                	xchg   %ax,%ax
8010451f:	90                   	nop

80104520 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104526:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010452f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104532:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104539:	5d                   	pop    %ebp
8010453a:	c3                   	ret    
8010453b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010453f:	90                   	nop

80104540 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104540:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104541:	31 d2                	xor    %edx,%edx
{
80104543:	89 e5                	mov    %esp,%ebp
80104545:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104546:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104549:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010454c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010454f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104550:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104556:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010455c:	77 12                	ja     80104570 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010455e:	8b 58 04             	mov    0x4(%eax),%ebx
80104561:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104564:	42                   	inc    %edx
80104565:	83 fa 0a             	cmp    $0xa,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104568:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010456a:	75 e4                	jne    80104550 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010456c:	5b                   	pop    %ebx
8010456d:	5d                   	pop    %ebp
8010456e:	c3                   	ret    
8010456f:	90                   	nop
  for(; i < 10; i++)
80104570:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104573:	8d 51 28             	lea    0x28(%ecx),%edx
80104576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104580:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104586:	83 c0 04             	add    $0x4,%eax
80104589:	39 d0                	cmp    %edx,%eax
8010458b:	75 f3                	jne    80104580 <getcallerpcs+0x40>
}
8010458d:	5b                   	pop    %ebx
8010458e:	5d                   	pop    %ebp
8010458f:	c3                   	ret    

80104590 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 04             	sub    $0x4,%esp
80104597:	9c                   	pushf  
80104598:	5b                   	pop    %ebx
  asm volatile("cli");
80104599:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010459a:	e8 d1 f3 ff ff       	call   80103970 <mycpu>
8010459f:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045a5:	85 d2                	test   %edx,%edx
801045a7:	74 17                	je     801045c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045a9:	e8 c2 f3 ff ff       	call   80103970 <mycpu>
801045ae:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
801045b4:	58                   	pop    %eax
801045b5:	5b                   	pop    %ebx
801045b6:	5d                   	pop    %ebp
801045b7:	c3                   	ret    
801045b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801045c0:	e8 ab f3 ff ff       	call   80103970 <mycpu>
801045c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801045d1:	e8 9a f3 ff ff       	call   80103970 <mycpu>
801045d6:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
801045dc:	58                   	pop    %eax
801045dd:	5b                   	pop    %ebx
801045de:	5d                   	pop    %ebp
801045df:	c3                   	ret    

801045e0 <popcli>:

void
popcli(void)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045e6:	9c                   	pushf  
801045e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045e8:	f6 c4 02             	test   $0x2,%ah
801045eb:	75 35                	jne    80104622 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045ed:	e8 7e f3 ff ff       	call   80103970 <mycpu>
801045f2:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
801045f8:	78 34                	js     8010462e <popcli+0x4e>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045fa:	e8 71 f3 ff ff       	call   80103970 <mycpu>
801045ff:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104605:	85 d2                	test   %edx,%edx
80104607:	74 07                	je     80104610 <popcli+0x30>
    sti();
}
80104609:	c9                   	leave  
8010460a:	c3                   	ret    
8010460b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010460f:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104610:	e8 5b f3 ff ff       	call   80103970 <mycpu>
80104615:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010461b:	85 c0                	test   %eax,%eax
8010461d:	74 ea                	je     80104609 <popcli+0x29>
  asm volatile("sti");
8010461f:	fb                   	sti    
}
80104620:	c9                   	leave  
80104621:	c3                   	ret    
    panic("popcli - interruptible");
80104622:	c7 04 24 cf 78 10 80 	movl   $0x801078cf,(%esp)
80104629:	e8 32 bd ff ff       	call   80100360 <panic>
    panic("popcli");
8010462e:	c7 04 24 e6 78 10 80 	movl   $0x801078e6,(%esp)
80104635:	e8 26 bd ff ff       	call   80100360 <panic>
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104640 <holding>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	83 ec 08             	sub    $0x8,%esp
80104646:	89 75 fc             	mov    %esi,-0x4(%ebp)
80104649:	8b 75 08             	mov    0x8(%ebp),%esi
8010464c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010464f:	31 db                	xor    %ebx,%ebx
  pushcli();
80104651:	e8 3a ff ff ff       	call   80104590 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104656:	8b 06                	mov    (%esi),%eax
80104658:	85 c0                	test   %eax,%eax
8010465a:	75 14                	jne    80104670 <holding+0x30>
  popcli();
8010465c:	e8 7f ff ff ff       	call   801045e0 <popcli>
}
80104661:	8b 75 fc             	mov    -0x4(%ebp),%esi
80104664:	89 d8                	mov    %ebx,%eax
80104666:	8b 5d f8             	mov    -0x8(%ebp),%ebx
80104669:	89 ec                	mov    %ebp,%esp
8010466b:	5d                   	pop    %ebp
8010466c:	c3                   	ret    
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104670:	8b 5e 08             	mov    0x8(%esi),%ebx
80104673:	e8 f8 f2 ff ff       	call   80103970 <mycpu>
80104678:	39 c3                	cmp    %eax,%ebx
8010467a:	0f 94 c3             	sete   %bl
8010467d:	0f b6 db             	movzbl %bl,%ebx
80104680:	eb da                	jmp    8010465c <holding+0x1c>
80104682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104690 <acquire>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	83 ec 10             	sub    $0x10,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104698:	e8 f3 fe ff ff       	call   80104590 <pushcli>
  if(holding(lk))
8010469d:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046a0:	89 1c 24             	mov    %ebx,(%esp)
801046a3:	e8 98 ff ff ff       	call   80104640 <holding>
801046a8:	85 c0                	test   %eax,%eax
801046aa:	0f 85 84 00 00 00    	jne    80104734 <acquire+0xa4>
801046b0:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801046b2:	ba 01 00 00 00       	mov    $0x1,%edx
801046b7:	eb 0a                	jmp    801046c3 <acquire+0x33>
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046c3:	89 d0                	mov    %edx,%eax
801046c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801046c8:	85 c0                	test   %eax,%eax
801046ca:	75 f4                	jne    801046c0 <acquire+0x30>
  __sync_synchronize();
801046cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046d4:	e8 97 f2 ff ff       	call   80103970 <mycpu>
801046d9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801046dc:	89 e8                	mov    %ebp,%eax
801046de:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046e0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801046e6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801046ec:	77 22                	ja     80104710 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801046ee:	8b 50 04             	mov    0x4(%eax),%edx
801046f1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801046f5:	46                   	inc    %esi
801046f6:	83 fe 0a             	cmp    $0xa,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801046f9:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046fb:	75 e3                	jne    801046e0 <acquire+0x50>
}
801046fd:	83 c4 10             	add    $0x10,%esp
80104700:	5b                   	pop    %ebx
80104701:	5e                   	pop    %esi
80104702:	5d                   	pop    %ebp
80104703:	c3                   	ret    
80104704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop
  for(; i < 10; i++)
80104710:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104714:	83 c3 34             	add    $0x34,%ebx
80104717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104726:	83 c0 04             	add    $0x4,%eax
80104729:	39 d8                	cmp    %ebx,%eax
8010472b:	75 f3                	jne    80104720 <acquire+0x90>
}
8010472d:	83 c4 10             	add    $0x10,%esp
80104730:	5b                   	pop    %ebx
80104731:	5e                   	pop    %esi
80104732:	5d                   	pop    %ebp
80104733:	c3                   	ret    
    panic("acquire");
80104734:	c7 04 24 ed 78 10 80 	movl   $0x801078ed,(%esp)
8010473b:	e8 20 bc ff ff       	call   80100360 <panic>

80104740 <release>:
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 14             	sub    $0x14,%esp
80104747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010474a:	89 1c 24             	mov    %ebx,(%esp)
8010474d:	e8 ee fe ff ff       	call   80104640 <holding>
80104752:	85 c0                	test   %eax,%eax
80104754:	74 23                	je     80104779 <release+0x39>
  lk->pcs[0] = 0;
80104756:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010475d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104764:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104769:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010476f:	83 c4 14             	add    $0x14,%esp
80104772:	5b                   	pop    %ebx
80104773:	5d                   	pop    %ebp
  popcli();
80104774:	e9 67 fe ff ff       	jmp    801045e0 <popcli>
    panic("release");
80104779:	c7 04 24 f5 78 10 80 	movl   $0x801078f5,(%esp)
80104780:	e8 db bb ff ff       	call   80100360 <panic>
80104785:	66 90                	xchg   %ax,%ax
80104787:	66 90                	xchg   %ax,%ax
80104789:	66 90                	xchg   %ax,%ax
8010478b:	66 90                	xchg   %ax,%ax
8010478d:	66 90                	xchg   %ax,%ax
8010478f:	90                   	nop

80104790 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	83 ec 08             	sub    $0x8,%esp
80104796:	89 7d fc             	mov    %edi,-0x4(%ebp)
80104799:	8b 55 08             	mov    0x8(%ebp),%edx
8010479c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
8010479f:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047a5:	89 d7                	mov    %edx,%edi
801047a7:	09 cf                	or     %ecx,%edi
801047a9:	83 e7 03             	and    $0x3,%edi
801047ac:	75 32                	jne    801047e0 <memset+0x50>
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ae:	c1 e9 02             	shr    $0x2,%ecx
    c &= 0xFF;
801047b1:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047b4:	c1 e0 18             	shl    $0x18,%eax
801047b7:	89 fb                	mov    %edi,%ebx
801047b9:	c1 e3 10             	shl    $0x10,%ebx
801047bc:	09 d8                	or     %ebx,%eax
801047be:	09 f8                	or     %edi,%eax
801047c0:	c1 e7 08             	shl    $0x8,%edi
801047c3:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047c5:	89 d7                	mov    %edx,%edi
801047c7:	fc                   	cld    
801047c8:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047ca:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801047cd:	89 d0                	mov    %edx,%eax
801047cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
801047d2:	89 ec                	mov    %ebp,%esp
801047d4:	5d                   	pop    %ebp
801047d5:	c3                   	ret    
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801047e0:	89 d7                	mov    %edx,%edi
801047e2:	fc                   	cld    
801047e3:	f3 aa                	rep stos %al,%es:(%edi)
801047e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
801047e8:	89 d0                	mov    %edx,%eax
801047ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
801047ed:	89 ec                	mov    %ebp,%esp
801047ef:	5d                   	pop    %ebp
801047f0:	c3                   	ret    
801047f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop

80104800 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	8b 75 10             	mov    0x10(%ebp),%esi
80104807:	53                   	push   %ebx
80104808:	8b 55 08             	mov    0x8(%ebp),%edx
8010480b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010480e:	85 f6                	test   %esi,%esi
80104810:	74 2e                	je     80104840 <memcmp+0x40>
80104812:	01 c6                	add    %eax,%esi
80104814:	eb 10                	jmp    80104826 <memcmp+0x26>
80104816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104820:	40                   	inc    %eax
80104821:	42                   	inc    %edx
  while(n-- > 0){
80104822:	39 f0                	cmp    %esi,%eax
80104824:	74 1a                	je     80104840 <memcmp+0x40>
    if(*s1 != *s2)
80104826:	0f b6 0a             	movzbl (%edx),%ecx
80104829:	0f b6 18             	movzbl (%eax),%ebx
8010482c:	38 d9                	cmp    %bl,%cl
8010482e:	74 f0                	je     80104820 <memcmp+0x20>
      return *s1 - *s2;
80104830:	0f b6 c1             	movzbl %cl,%eax
80104833:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104835:	5b                   	pop    %ebx
80104836:	5e                   	pop    %esi
80104837:	5d                   	pop    %ebp
80104838:	c3                   	ret    
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104840:	5b                   	pop    %ebx
  return 0;
80104841:	31 c0                	xor    %eax,%eax
}
80104843:	5e                   	pop    %esi
80104844:	5d                   	pop    %ebp
80104845:	c3                   	ret    
80104846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

80104850 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	8b 55 08             	mov    0x8(%ebp),%edx
80104857:	56                   	push   %esi
80104858:	8b 75 0c             	mov    0xc(%ebp),%esi
8010485b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010485e:	39 d6                	cmp    %edx,%esi
80104860:	73 2e                	jae    80104890 <memmove+0x40>
80104862:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104865:	39 fa                	cmp    %edi,%edx
80104867:	73 27                	jae    80104890 <memmove+0x40>
80104869:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010486c:	85 c9                	test   %ecx,%ecx
8010486e:	74 0d                	je     8010487d <memmove+0x2d>
      *--d = *--s;
80104870:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104874:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104877:	48                   	dec    %eax
80104878:	83 f8 ff             	cmp    $0xffffffff,%eax
8010487b:	75 f3                	jne    80104870 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010487d:	5e                   	pop    %esi
8010487e:	89 d0                	mov    %edx,%eax
80104880:	5f                   	pop    %edi
80104881:	5d                   	pop    %ebp
80104882:	c3                   	ret    
80104883:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104890:	85 c9                	test   %ecx,%ecx
80104892:	89 d7                	mov    %edx,%edi
80104894:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104897:	74 e4                	je     8010487d <memmove+0x2d>
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048a1:	39 f0                	cmp    %esi,%eax
801048a3:	75 fb                	jne    801048a0 <memmove+0x50>
}
801048a5:	5e                   	pop    %esi
801048a6:	89 d0                	mov    %edx,%eax
801048a8:	5f                   	pop    %edi
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret    
801048ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048af:	90                   	nop

801048b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801048b0:	eb 9e                	jmp    80104850 <memmove>
801048b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	8b 75 10             	mov    0x10(%ebp),%esi
801048c7:	53                   	push   %ebx
801048c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801048cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801048ce:	85 f6                	test   %esi,%esi
801048d0:	74 2e                	je     80104900 <strncmp+0x40>
801048d2:	01 c6                	add    %eax,%esi
801048d4:	eb 14                	jmp    801048ea <strncmp+0x2a>
801048d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	38 ca                	cmp    %cl,%dl
801048e2:	75 10                	jne    801048f4 <strncmp+0x34>
    n--, p++, q++;
801048e4:	40                   	inc    %eax
801048e5:	43                   	inc    %ebx
  while(n > 0 && *p && *p == *q)
801048e6:	39 f0                	cmp    %esi,%eax
801048e8:	74 16                	je     80104900 <strncmp+0x40>
801048ea:	0f b6 13             	movzbl (%ebx),%edx
801048ed:	0f b6 08             	movzbl (%eax),%ecx
801048f0:	84 d2                	test   %dl,%dl
801048f2:	75 ec                	jne    801048e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801048f4:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
801048f5:	0f b6 c2             	movzbl %dl,%eax
801048f8:	29 c8                	sub    %ecx,%eax
}
801048fa:	5e                   	pop    %esi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret    
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
80104900:	5b                   	pop    %ebx
    return 0;
80104901:	31 c0                	xor    %eax,%eax
}
80104903:	5e                   	pop    %esi
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret    
80104906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104917:	56                   	push   %esi
80104918:	8b 75 08             	mov    0x8(%ebp),%esi
8010491b:	53                   	push   %ebx
8010491c:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010491f:	89 f2                	mov    %esi,%edx
80104921:	eb 19                	jmp    8010493c <strncpy+0x2c>
80104923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104930:	0f b6 01             	movzbl (%ecx),%eax
80104933:	41                   	inc    %ecx
80104934:	42                   	inc    %edx
80104935:	88 42 ff             	mov    %al,-0x1(%edx)
80104938:	84 c0                	test   %al,%al
8010493a:	74 07                	je     80104943 <strncpy+0x33>
8010493c:	89 fb                	mov    %edi,%ebx
8010493e:	4f                   	dec    %edi
8010493f:	85 db                	test   %ebx,%ebx
80104941:	7f ed                	jg     80104930 <strncpy+0x20>
    ;
  while(n-- > 0)
80104943:	85 ff                	test   %edi,%edi
80104945:	89 d1                	mov    %edx,%ecx
80104947:	7e 17                	jle    80104960 <strncpy+0x50>
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104950:	c6 01 00             	movb   $0x0,(%ecx)
80104953:	41                   	inc    %ecx
  while(n-- > 0)
80104954:	89 c8                	mov    %ecx,%eax
80104956:	f7 d0                	not    %eax
80104958:	01 d0                	add    %edx,%eax
8010495a:	01 d8                	add    %ebx,%eax
8010495c:	85 c0                	test   %eax,%eax
8010495e:	7f f0                	jg     80104950 <strncpy+0x40>
  return os;
}
80104960:	5b                   	pop    %ebx
80104961:	89 f0                	mov    %esi,%eax
80104963:	5e                   	pop    %esi
80104964:	5f                   	pop    %edi
80104965:	5d                   	pop    %ebp
80104966:	c3                   	ret    
80104967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496e:	66 90                	xchg   %ax,%ax

80104970 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	8b 55 10             	mov    0x10(%ebp),%edx
80104977:	53                   	push   %ebx
80104978:	8b 75 08             	mov    0x8(%ebp),%esi
8010497b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010497e:	85 d2                	test   %edx,%edx
80104980:	7e 21                	jle    801049a3 <safestrcpy+0x33>
80104982:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104986:	89 f2                	mov    %esi,%edx
80104988:	eb 12                	jmp    8010499c <safestrcpy+0x2c>
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104990:	0f b6 08             	movzbl (%eax),%ecx
80104993:	40                   	inc    %eax
80104994:	42                   	inc    %edx
80104995:	88 4a ff             	mov    %cl,-0x1(%edx)
80104998:	84 c9                	test   %cl,%cl
8010499a:	74 04                	je     801049a0 <safestrcpy+0x30>
8010499c:	39 d8                	cmp    %ebx,%eax
8010499e:	75 f0                	jne    80104990 <safestrcpy+0x20>
    ;
  *s = 0;
801049a0:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049a3:	5b                   	pop    %ebx
801049a4:	89 f0                	mov    %esi,%eax
801049a6:	5e                   	pop    %esi
801049a7:	5d                   	pop    %ebp
801049a8:	c3                   	ret    
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049b0 <strlen>:

int
strlen(const char *s)
{
801049b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049b1:	31 c0                	xor    %eax,%eax
{
801049b3:	89 e5                	mov    %esp,%ebp
801049b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049b8:	80 3a 00             	cmpb   $0x0,(%edx)
801049bb:	74 0a                	je     801049c7 <strlen+0x17>
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
801049c0:	40                   	inc    %eax
801049c1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049c5:	75 f9                	jne    801049c0 <strlen+0x10>
    ;
  return n;
}
801049c7:	5d                   	pop    %ebp
801049c8:	c3                   	ret    

801049c9 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049c9:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049cd:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049d1:	55                   	push   %ebp
  pushl %ebx
801049d2:	53                   	push   %ebx
  pushl %esi
801049d3:	56                   	push   %esi
  pushl %edi
801049d4:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049d5:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049d7:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049d9:	5f                   	pop    %edi
  popl %esi
801049da:	5e                   	pop    %esi
  popl %ebx
801049db:	5b                   	pop    %ebx
  popl %ebp
801049dc:	5d                   	pop    %ebp
  ret
801049dd:	c3                   	ret    
801049de:	66 90                	xchg   %ax,%ax

801049e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 04             	sub    $0x4,%esp
801049e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049ea:	e8 11 f0 ff ff       	call   80103a00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ef:	8b 00                	mov    (%eax),%eax
801049f1:	39 d8                	cmp    %ebx,%eax
801049f3:	76 1b                	jbe    80104a10 <fetchint+0x30>
801049f5:	8d 53 04             	lea    0x4(%ebx),%edx
801049f8:	39 d0                	cmp    %edx,%eax
801049fa:	72 14                	jb     80104a10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ff:	8b 13                	mov    (%ebx),%edx
80104a01:	89 10                	mov    %edx,(%eax)
  return 0;
80104a03:	31 c0                	xor    %eax,%eax
}
80104a05:	5a                   	pop    %edx
80104a06:	5b                   	pop    %ebx
80104a07:	5d                   	pop    %ebp
80104a08:	c3                   	ret    
80104a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a15:	eb ee                	jmp    80104a05 <fetchint+0x25>
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 04             	sub    $0x4,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a2a:	e8 d1 ef ff ff       	call   80103a00 <myproc>

  if(addr >= curproc->sz)
80104a2f:	39 18                	cmp    %ebx,(%eax)
80104a31:	76 2d                	jbe    80104a60 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a36:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a38:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a3a:	39 d3                	cmp    %edx,%ebx
80104a3c:	73 22                	jae    80104a60 <fetchstr+0x40>
80104a3e:	89 d8                	mov    %ebx,%eax
80104a40:	eb 13                	jmp    80104a55 <fetchstr+0x35>
80104a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a50:	40                   	inc    %eax
80104a51:	39 c2                	cmp    %eax,%edx
80104a53:	76 0b                	jbe    80104a60 <fetchstr+0x40>
    if(*s == 0)
80104a55:	80 38 00             	cmpb   $0x0,(%eax)
80104a58:	75 f6                	jne    80104a50 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104a5a:	5a                   	pop    %edx
      return s - *pp;
80104a5b:	29 d8                	sub    %ebx,%eax
}
80104a5d:	5b                   	pop    %ebx
80104a5e:	5d                   	pop    %ebp
80104a5f:	c3                   	ret    
80104a60:	5a                   	pop    %edx
    return -1;
80104a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a66:	5b                   	pop    %ebx
80104a67:	5d                   	pop    %ebp
80104a68:	c3                   	ret    
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a75:	e8 86 ef ff ff       	call   80103a00 <myproc>
80104a7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a7d:	8b 40 18             	mov    0x18(%eax),%eax
80104a80:	8b 40 44             	mov    0x44(%eax),%eax
80104a83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a86:	e8 75 ef ff ff       	call   80103a00 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a8e:	8b 00                	mov    (%eax),%eax
80104a90:	39 c6                	cmp    %eax,%esi
80104a92:	73 1c                	jae    80104ab0 <argint+0x40>
80104a94:	8d 53 08             	lea    0x8(%ebx),%edx
80104a97:	39 d0                	cmp    %edx,%eax
80104a99:	72 15                	jb     80104ab0 <argint+0x40>
  *ip = *(int*)(addr);
80104a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104aa1:	89 10                	mov    %edx,(%eax)
  return 0;
80104aa3:	31 c0                	xor    %eax,%eax
}
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5d                   	pop    %ebp
80104aa8:	c3                   	ret    
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab5:	eb ee                	jmp    80104aa5 <argint+0x35>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	83 ec 20             	sub    $0x20,%esp
80104ac8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104acb:	e8 30 ef ff ff       	call   80103a00 <myproc>
80104ad0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ad2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80104adc:	89 04 24             	mov    %eax,(%esp)
80104adf:	e8 8c ff ff ff       	call   80104a70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ae4:	c1 e8 1f             	shr    $0x1f,%eax
80104ae7:	84 c0                	test   %al,%al
80104ae9:	75 35                	jne    80104b20 <argptr+0x60>
80104aeb:	89 d8                	mov    %ebx,%eax
80104aed:	c1 e8 1f             	shr    $0x1f,%eax
80104af0:	84 c0                	test   %al,%al
80104af2:	75 2c                	jne    80104b20 <argptr+0x60>
80104af4:	8b 16                	mov    (%esi),%edx
80104af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af9:	39 c2                	cmp    %eax,%edx
80104afb:	76 23                	jbe    80104b20 <argptr+0x60>
80104afd:	01 c3                	add    %eax,%ebx
80104aff:	39 da                	cmp    %ebx,%edx
80104b01:	72 1d                	jb     80104b20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b03:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b06:	89 02                	mov    %eax,(%edx)
  return 0;
80104b08:	31 c0                	xor    %eax,%eax
}
80104b0a:	83 c4 20             	add    $0x20,%esp
80104b0d:	5b                   	pop    %ebx
80104b0e:	5e                   	pop    %esi
80104b0f:	5d                   	pop    %ebp
80104b10:	c3                   	ret    
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1f:	90                   	nop
    return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b25:	eb e3                	jmp    80104b0a <argptr+0x4a>
80104b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b39:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80104b40:	89 04 24             	mov    %eax,(%esp)
80104b43:	e8 28 ff ff ff       	call   80104a70 <argint>
80104b48:	85 c0                	test   %eax,%eax
80104b4a:	78 14                	js     80104b60 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	89 04 24             	mov    %eax,(%esp)
80104b59:	e8 c2 fe ff ff       	call   80104a20 <fetchstr>
}
80104b5e:	c9                   	leave  
80104b5f:	c3                   	ret    
80104b60:	c9                   	leave  
    return -1;
80104b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b66:	c3                   	ret    
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <syscall>:
[SYS_proc_dump]   sys_proc_dump,
};

void
syscall(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 14             	sub    $0x14,%esp
  int num;
  struct proc *curproc = myproc();
80104b77:	e8 84 ee ff ff       	call   80103a00 <myproc>
80104b7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b7e:	8b 40 18             	mov    0x18(%eax),%eax
80104b81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b87:	83 fa 15             	cmp    $0x15,%edx
80104b8a:	77 24                	ja     80104bb0 <syscall+0x40>
80104b8c:	8b 14 85 20 79 10 80 	mov    -0x7fef86e0(,%eax,4),%edx
80104b93:	85 d2                	test   %edx,%edx
80104b95:	74 19                	je     80104bb0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104b97:	ff d2                	call   *%edx
80104b99:	89 c2                	mov    %eax,%edx
80104b9b:	8b 43 18             	mov    0x18(%ebx),%eax
80104b9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ba1:	83 c4 14             	add    $0x14,%esp
80104ba4:	5b                   	pop    %ebx
80104ba5:	5d                   	pop    %ebp
80104ba6:	c3                   	ret    
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104bb0:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80104bb4:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104bbb:	8b 43 10             	mov    0x10(%ebx),%eax
80104bbe:	c7 04 24 fd 78 10 80 	movl   $0x801078fd,(%esp)
80104bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc9:	e8 b2 ba ff ff       	call   80100680 <cprintf>
    curproc->tf->eax = -1;
80104bce:	8b 43 18             	mov    0x18(%ebx),%eax
80104bd1:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bd8:	83 c4 14             	add    $0x14,%esp
80104bdb:	5b                   	pop    %ebx
80104bdc:	5d                   	pop    %ebp
80104bdd:	c3                   	ret    
80104bde:	66 90                	xchg   %ax,%ax

80104be0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104be0:	55                   	push   %ebp
80104be1:	0f bf d2             	movswl %dx,%edx
80104be4:	89 e5                	mov    %esp,%ebp
80104be6:	0f bf c9             	movswl %cx,%ecx
80104be9:	57                   	push   %edi
80104bea:	56                   	push   %esi
80104beb:	53                   	push   %ebx
80104bec:	83 ec 3c             	sub    $0x3c,%esp
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bef:	89 04 24             	mov    %eax,(%esp)
{
80104bf2:	0f bf 7d 08          	movswl 0x8(%ebp),%edi
80104bf6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104bf9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104bfc:	89 7d cc             	mov    %edi,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bff:	8d 7d da             	lea    -0x26(%ebp),%edi
80104c02:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c06:	e8 85 d5 ff ff       	call   80102190 <nameiparent>
80104c0b:	85 c0                	test   %eax,%eax
80104c0d:	0f 84 2d 01 00 00    	je     80104d40 <create+0x160>
    return 0;
  ilock(dp);
80104c13:	89 04 24             	mov    %eax,(%esp)
80104c16:	89 c3                	mov    %eax,%ebx
80104c18:	e8 e3 cb ff ff       	call   80101800 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c1d:	31 c9                	xor    %ecx,%ecx
80104c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80104c23:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c27:	89 1c 24             	mov    %ebx,(%esp)
80104c2a:	e8 81 d1 ff ff       	call   80101db0 <dirlookup>
80104c2f:	85 c0                	test   %eax,%eax
80104c31:	89 c6                	mov    %eax,%esi
80104c33:	74 4b                	je     80104c80 <create+0xa0>
    iunlockput(dp);
80104c35:	89 1c 24             	mov    %ebx,(%esp)
80104c38:	e8 63 ce ff ff       	call   80101aa0 <iunlockput>
    ilock(ip);
80104c3d:	89 34 24             	mov    %esi,(%esp)
80104c40:	e8 bb cb ff ff       	call   80101800 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c45:	83 7d d4 02          	cmpl   $0x2,-0x2c(%ebp)
80104c49:	75 15                	jne    80104c60 <create+0x80>
80104c4b:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c50:	75 0e                	jne    80104c60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c52:	83 c4 3c             	add    $0x3c,%esp
80104c55:	89 f0                	mov    %esi,%eax
80104c57:	5b                   	pop    %ebx
80104c58:	5e                   	pop    %esi
80104c59:	5f                   	pop    %edi
80104c5a:	5d                   	pop    %ebp
80104c5b:	c3                   	ret    
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104c60:	89 34 24             	mov    %esi,(%esp)
    return 0;
80104c63:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c65:	e8 36 ce ff ff       	call   80101aa0 <iunlockput>
}
80104c6a:	83 c4 3c             	add    $0x3c,%esp
80104c6d:	89 f0                	mov    %esi,%eax
80104c6f:	5b                   	pop    %ebx
80104c70:	5e                   	pop    %esi
80104c71:	5f                   	pop    %edi
80104c72:	5d                   	pop    %ebp
80104c73:	c3                   	ret    
80104c74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104c80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c83:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c87:	8b 03                	mov    (%ebx),%eax
80104c89:	89 04 24             	mov    %eax,(%esp)
80104c8c:	e8 ef c9 ff ff       	call   80101680 <ialloc>
80104c91:	85 c0                	test   %eax,%eax
80104c93:	89 c6                	mov    %eax,%esi
80104c95:	0f 84 bd 00 00 00    	je     80104d58 <create+0x178>
  ilock(ip);
80104c9b:	89 04 24             	mov    %eax,(%esp)
80104c9e:	e8 5d cb ff ff       	call   80101800 <ilock>
  ip->major = major;
80104ca3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  ip->nlink = 1;
80104ca6:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  ip->major = major;
80104cac:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104cb0:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104cb3:	66 89 46 54          	mov    %ax,0x54(%esi)
  iupdate(ip);
80104cb7:	89 34 24             	mov    %esi,(%esp)
80104cba:	e8 81 ca ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cbf:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
80104cc3:	74 2b                	je     80104cf0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104cc5:	8b 46 04             	mov    0x4(%esi),%eax
80104cc8:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104ccc:	89 1c 24             	mov    %ebx,(%esp)
80104ccf:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cd3:	e8 b8 d3 ff ff       	call   80102090 <dirlink>
80104cd8:	85 c0                	test   %eax,%eax
80104cda:	78 70                	js     80104d4c <create+0x16c>
  iunlockput(dp);
80104cdc:	89 1c 24             	mov    %ebx,(%esp)
80104cdf:	e8 bc cd ff ff       	call   80101aa0 <iunlockput>
}
80104ce4:	83 c4 3c             	add    $0x3c,%esp
80104ce7:	89 f0                	mov    %esi,%eax
80104ce9:	5b                   	pop    %ebx
80104cea:	5e                   	pop    %esi
80104ceb:	5f                   	pop    %edi
80104cec:	5d                   	pop    %ebp
80104ced:	c3                   	ret    
80104cee:	66 90                	xchg   %ax,%ax
    dp->nlink++;  // for ".."
80104cf0:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
80104cf4:	89 1c 24             	mov    %ebx,(%esp)
80104cf7:	e8 44 ca ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cfc:	8b 46 04             	mov    0x4(%esi),%eax
80104cff:	ba 98 79 10 80       	mov    $0x80107998,%edx
80104d04:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d08:	89 34 24             	mov    %esi,(%esp)
80104d0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d0f:	e8 7c d3 ff ff       	call   80102090 <dirlink>
80104d14:	85 c0                	test   %eax,%eax
80104d16:	78 1c                	js     80104d34 <create+0x154>
80104d18:	8b 43 04             	mov    0x4(%ebx),%eax
80104d1b:	89 34 24             	mov    %esi,(%esp)
80104d1e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d22:	b8 97 79 10 80       	mov    $0x80107997,%eax
80104d27:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d2b:	e8 60 d3 ff ff       	call   80102090 <dirlink>
80104d30:	85 c0                	test   %eax,%eax
80104d32:	79 91                	jns    80104cc5 <create+0xe5>
      panic("create dots");
80104d34:	c7 04 24 8b 79 10 80 	movl   $0x8010798b,(%esp)
80104d3b:	e8 20 b6 ff ff       	call   80100360 <panic>
}
80104d40:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104d43:	31 f6                	xor    %esi,%esi
}
80104d45:	5b                   	pop    %ebx
80104d46:	89 f0                	mov    %esi,%eax
80104d48:	5e                   	pop    %esi
80104d49:	5f                   	pop    %edi
80104d4a:	5d                   	pop    %ebp
80104d4b:	c3                   	ret    
    panic("create: dirlink");
80104d4c:	c7 04 24 9a 79 10 80 	movl   $0x8010799a,(%esp)
80104d53:	e8 08 b6 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
80104d58:	c7 04 24 7c 79 10 80 	movl   $0x8010797c,(%esp)
80104d5f:	e8 fc b5 ff ff       	call   80100360 <panic>
80104d64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d6f:	90                   	nop

80104d70 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	89 d6                	mov    %edx,%esi
80104d76:	53                   	push   %ebx
80104d77:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d79:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d7c:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80104d7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d8a:	e8 e1 fc ff ff       	call   80104a70 <argint>
80104d8f:	85 c0                	test   %eax,%eax
80104d91:	78 2d                	js     80104dc0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d93:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d97:	77 27                	ja     80104dc0 <argfd.constprop.0+0x50>
80104d99:	e8 62 ec ff ff       	call   80103a00 <myproc>
80104d9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104da1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104da5:	85 c0                	test   %eax,%eax
80104da7:	74 17                	je     80104dc0 <argfd.constprop.0+0x50>
  if(pfd)
80104da9:	85 db                	test   %ebx,%ebx
80104dab:	74 02                	je     80104daf <argfd.constprop.0+0x3f>
    *pfd = fd;
80104dad:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104daf:	89 06                	mov    %eax,(%esi)
  return 0;
80104db1:	31 c0                	xor    %eax,%eax
}
80104db3:	83 c4 20             	add    $0x20,%esp
80104db6:	5b                   	pop    %ebx
80104db7:	5e                   	pop    %esi
80104db8:	5d                   	pop    %ebp
80104db9:	c3                   	ret    
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb ec                	jmp    80104db3 <argfd.constprop.0+0x43>
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <sys_dup>:
{
80104dd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104dd1:	31 c0                	xor    %eax,%eax
{
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	56                   	push   %esi
80104dd6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104dd7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dda:	83 ec 20             	sub    $0x20,%esp
  if(argfd(0, 0, &f) < 0)
80104ddd:	e8 8e ff ff ff       	call   80104d70 <argfd.constprop.0>
80104de2:	85 c0                	test   %eax,%eax
80104de4:	78 18                	js     80104dfe <sys_dup+0x2e>
  if((fd=fdalloc(f)) < 0)
80104de6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104de9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104deb:	e8 10 ec ff ff       	call   80103a00 <myproc>
    if(curproc->ofile[fd] == 0){
80104df0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104df4:	85 d2                	test   %edx,%edx
80104df6:	74 18                	je     80104e10 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104df8:	43                   	inc    %ebx
80104df9:	83 fb 10             	cmp    $0x10,%ebx
80104dfc:	75 f2                	jne    80104df0 <sys_dup+0x20>
}
80104dfe:	83 c4 20             	add    $0x20,%esp
    return -1;
80104e01:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e06:	89 d8                	mov    %ebx,%eax
80104e08:	5b                   	pop    %ebx
80104e09:	5e                   	pop    %esi
80104e0a:	5d                   	pop    %ebp
80104e0b:	c3                   	ret    
80104e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104e10:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e17:	89 04 24             	mov    %eax,(%esp)
80104e1a:	e8 71 c0 ff ff       	call   80100e90 <filedup>
}
80104e1f:	83 c4 20             	add    $0x20,%esp
80104e22:	89 d8                	mov    %ebx,%eax
80104e24:	5b                   	pop    %ebx
80104e25:	5e                   	pop    %esi
80104e26:	5d                   	pop    %ebp
80104e27:	c3                   	ret    
80104e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop

80104e30 <sys_read>:
{
80104e30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e31:	31 c0                	xor    %eax,%eax
{
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e3b:	e8 30 ff ff ff       	call   80104d70 <argfd.constprop.0>
80104e40:	85 c0                	test   %eax,%eax
80104e42:	78 5c                	js     80104ea0 <sys_read+0x70>
80104e44:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104e4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e52:	e8 19 fc ff ff       	call   80104a70 <argint>
80104e57:	85 c0                	test   %eax,%eax
80104e59:	78 45                	js     80104ea0 <sys_read+0x70>
80104e5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e65:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e70:	e8 4b fc ff ff       	call   80104ac0 <argptr>
80104e75:	85 c0                	test   %eax,%eax
80104e77:	78 27                	js     80104ea0 <sys_read+0x70>
  return fileread(f, p, n);
80104e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e7c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e83:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e8a:	89 04 24             	mov    %eax,(%esp)
80104e8d:	e8 8e c1 ff ff       	call   80101020 <fileread>
}
80104e92:	c9                   	leave  
80104e93:	c3                   	ret    
80104e94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e9f:	90                   	nop
80104ea0:	c9                   	leave  
    return -1;
80104ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ea6:	c3                   	ret    
80104ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <sys_write>:
{
80104eb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eb1:	31 c0                	xor    %eax,%eax
{
80104eb3:	89 e5                	mov    %esp,%ebp
80104eb5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ebb:	e8 b0 fe ff ff       	call   80104d70 <argfd.constprop.0>
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	78 5c                	js     80104f20 <sys_write+0x70>
80104ec4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ecb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ece:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ed2:	e8 99 fb ff ff       	call   80104a70 <argint>
80104ed7:	85 c0                	test   %eax,%eax
80104ed9:	78 45                	js     80104f20 <sys_write+0x70>
80104edb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ee5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ee9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ef0:	e8 cb fb ff ff       	call   80104ac0 <argptr>
80104ef5:	85 c0                	test   %eax,%eax
80104ef7:	78 27                	js     80104f20 <sys_write+0x70>
  return filewrite(f, p, n);
80104ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104efc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f03:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f0a:	89 04 24             	mov    %eax,(%esp)
80104f0d:	e8 ce c1 ff ff       	call   801010e0 <filewrite>
}
80104f12:	c9                   	leave  
80104f13:	c3                   	ret    
80104f14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f1f:	90                   	nop
80104f20:	c9                   	leave  
    return -1;
80104f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f26:	c3                   	ret    
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <sys_close>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104f36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f3c:	e8 2f fe ff ff       	call   80104d70 <argfd.constprop.0>
80104f41:	85 c0                	test   %eax,%eax
80104f43:	78 2b                	js     80104f70 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f45:	e8 b6 ea ff ff       	call   80103a00 <myproc>
80104f4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f4d:	31 c9                	xor    %ecx,%ecx
80104f4f:	89 4c 90 28          	mov    %ecx,0x28(%eax,%edx,4)
  fileclose(f);
80104f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f56:	89 04 24             	mov    %eax,(%esp)
80104f59:	e8 82 bf ff ff       	call   80100ee0 <fileclose>
  return 0;
80104f5e:	31 c0                	xor    %eax,%eax
}
80104f60:	c9                   	leave  
80104f61:	c3                   	ret    
80104f62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f70:	c9                   	leave  
    return -1;
80104f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f76:	c3                   	ret    
80104f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <sys_fstat>:
{
80104f80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f81:	31 c0                	xor    %eax,%eax
{
80104f83:	89 e5                	mov    %esp,%ebp
80104f85:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f8b:	e8 e0 fd ff ff       	call   80104d70 <argfd.constprop.0>
80104f90:	85 c0                	test   %eax,%eax
80104f92:	78 3c                	js     80104fd0 <sys_fstat+0x50>
80104f94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f9b:	b8 14 00 00 00       	mov    $0x14,%eax
80104fa0:	89 44 24 08          	mov    %eax,0x8(%esp)
80104fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fab:	e8 10 fb ff ff       	call   80104ac0 <argptr>
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	78 1c                	js     80104fd0 <sys_fstat+0x50>
  return filestat(f, st);
80104fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fbe:	89 04 24             	mov    %eax,(%esp)
80104fc1:	e8 0a c0 ff ff       	call   80100fd0 <filestat>
}
80104fc6:	c9                   	leave  
80104fc7:	c3                   	ret    
80104fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop
80104fd0:	c9                   	leave  
    return -1;
80104fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fd6:	c3                   	ret    
80104fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fde:	66 90                	xchg   %ax,%ax

80104fe0 <sys_link>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	57                   	push   %edi
80104fe4:	56                   	push   %esi
80104fe5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fe6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fe9:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ff0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ff7:	e8 34 fb ff ff       	call   80104b30 <argstr>
80104ffc:	85 c0                	test   %eax,%eax
80104ffe:	0f 88 e5 00 00 00    	js     801050e9 <sys_link+0x109>
80105004:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010500b:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010500e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105012:	e8 19 fb ff ff       	call   80104b30 <argstr>
80105017:	85 c0                	test   %eax,%eax
80105019:	0f 88 ca 00 00 00    	js     801050e9 <sys_link+0x109>
  begin_op();
8010501f:	e8 ec dd ff ff       	call   80102e10 <begin_op>
  if((ip = namei(old)) == 0){
80105024:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105027:	89 04 24             	mov    %eax,(%esp)
8010502a:	e8 41 d1 ff ff       	call   80102170 <namei>
8010502f:	85 c0                	test   %eax,%eax
80105031:	89 c3                	mov    %eax,%ebx
80105033:	0f 84 ab 00 00 00    	je     801050e4 <sys_link+0x104>
  ilock(ip);
80105039:	89 04 24             	mov    %eax,(%esp)
8010503c:	e8 bf c7 ff ff       	call   80101800 <ilock>
  if(ip->type == T_DIR){
80105041:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105046:	0f 84 90 00 00 00    	je     801050dc <sys_link+0xfc>
  ip->nlink++;
8010504c:	66 ff 43 56          	incw   0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105050:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105053:	89 1c 24             	mov    %ebx,(%esp)
80105056:	e8 e5 c6 ff ff       	call   80101740 <iupdate>
  iunlock(ip);
8010505b:	89 1c 24             	mov    %ebx,(%esp)
8010505e:	e8 7d c8 ff ff       	call   801018e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105063:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105066:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010506a:	89 04 24             	mov    %eax,(%esp)
8010506d:	e8 1e d1 ff ff       	call   80102190 <nameiparent>
80105072:	85 c0                	test   %eax,%eax
80105074:	89 c6                	mov    %eax,%esi
80105076:	74 50                	je     801050c8 <sys_link+0xe8>
  ilock(dp);
80105078:	89 04 24             	mov    %eax,(%esp)
8010507b:	e8 80 c7 ff ff       	call   80101800 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105080:	8b 03                	mov    (%ebx),%eax
80105082:	39 06                	cmp    %eax,(%esi)
80105084:	75 3a                	jne    801050c0 <sys_link+0xe0>
80105086:	8b 43 04             	mov    0x4(%ebx),%eax
80105089:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010508d:	89 34 24             	mov    %esi,(%esp)
80105090:	89 44 24 08          	mov    %eax,0x8(%esp)
80105094:	e8 f7 cf ff ff       	call   80102090 <dirlink>
80105099:	85 c0                	test   %eax,%eax
8010509b:	78 23                	js     801050c0 <sys_link+0xe0>
  iunlockput(dp);
8010509d:	89 34 24             	mov    %esi,(%esp)
801050a0:	e8 fb c9 ff ff       	call   80101aa0 <iunlockput>
  iput(ip);
801050a5:	89 1c 24             	mov    %ebx,(%esp)
801050a8:	e8 83 c8 ff ff       	call   80101930 <iput>
  end_op();
801050ad:	e8 ce dd ff ff       	call   80102e80 <end_op>
  return 0;
801050b2:	31 c0                	xor    %eax,%eax
}
801050b4:	83 c4 3c             	add    $0x3c,%esp
801050b7:	5b                   	pop    %ebx
801050b8:	5e                   	pop    %esi
801050b9:	5f                   	pop    %edi
801050ba:	5d                   	pop    %ebp
801050bb:	c3                   	ret    
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(dp);
801050c0:	89 34 24             	mov    %esi,(%esp)
801050c3:	e8 d8 c9 ff ff       	call   80101aa0 <iunlockput>
  ilock(ip);
801050c8:	89 1c 24             	mov    %ebx,(%esp)
801050cb:	e8 30 c7 ff ff       	call   80101800 <ilock>
  ip->nlink--;
801050d0:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801050d4:	89 1c 24             	mov    %ebx,(%esp)
801050d7:	e8 64 c6 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
801050dc:	89 1c 24             	mov    %ebx,(%esp)
801050df:	e8 bc c9 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801050e4:	e8 97 dd ff ff       	call   80102e80 <end_op>
  return -1;
801050e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ee:	eb c4                	jmp    801050b4 <sys_link+0xd4>

801050f0 <sys_unlink>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	56                   	push   %esi
801050f5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801050f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050f9:	83 ec 4c             	sub    $0x4c,%esp
  if(argstr(0, &path) < 0)
801050fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105100:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105107:	e8 24 fa ff ff       	call   80104b30 <argstr>
8010510c:	85 c0                	test   %eax,%eax
8010510e:	0f 88 69 01 00 00    	js     8010527d <sys_unlink+0x18d>
  begin_op();
80105114:	e8 f7 dc ff ff       	call   80102e10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105119:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010511c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010511f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105123:	89 04 24             	mov    %eax,(%esp)
80105126:	e8 65 d0 ff ff       	call   80102190 <nameiparent>
8010512b:	85 c0                	test   %eax,%eax
8010512d:	89 c6                	mov    %eax,%esi
8010512f:	0f 84 43 01 00 00    	je     80105278 <sys_unlink+0x188>
  ilock(dp);
80105135:	89 04 24             	mov    %eax,(%esp)
80105138:	e8 c3 c6 ff ff       	call   80101800 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010513d:	b8 98 79 10 80       	mov    $0x80107998,%eax
80105142:	89 44 24 04          	mov    %eax,0x4(%esp)
80105146:	89 1c 24             	mov    %ebx,(%esp)
80105149:	e8 32 cc ff ff       	call   80101d80 <namecmp>
8010514e:	85 c0                	test   %eax,%eax
80105150:	0f 84 1a 01 00 00    	je     80105270 <sys_unlink+0x180>
80105156:	89 1c 24             	mov    %ebx,(%esp)
80105159:	b8 97 79 10 80       	mov    $0x80107997,%eax
8010515e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105162:	e8 19 cc ff ff       	call   80101d80 <namecmp>
80105167:	85 c0                	test   %eax,%eax
80105169:	0f 84 01 01 00 00    	je     80105270 <sys_unlink+0x180>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010516f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105173:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105176:	89 44 24 08          	mov    %eax,0x8(%esp)
8010517a:	89 34 24             	mov    %esi,(%esp)
8010517d:	e8 2e cc ff ff       	call   80101db0 <dirlookup>
80105182:	85 c0                	test   %eax,%eax
80105184:	89 c3                	mov    %eax,%ebx
80105186:	0f 84 e4 00 00 00    	je     80105270 <sys_unlink+0x180>
  ilock(ip);
8010518c:	89 04 24             	mov    %eax,(%esp)
8010518f:	e8 6c c6 ff ff       	call   80101800 <ilock>
  if(ip->nlink < 1)
80105194:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105199:	0f 8e 1a 01 00 00    	jle    801052b9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010519f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051a4:	8d 55 d8             	lea    -0x28(%ebp),%edx
801051a7:	74 77                	je     80105220 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
801051a9:	89 14 24             	mov    %edx,(%esp)
801051ac:	31 c9                	xor    %ecx,%ecx
801051ae:	b8 10 00 00 00       	mov    $0x10,%eax
801051b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b7:	bf 10 00 00 00       	mov    $0x10,%edi
  memset(&de, 0, sizeof(de));
801051bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801051c0:	e8 cb f5 ff ff       	call   80104790 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801051c8:	8d 55 d8             	lea    -0x28(%ebp),%edx
801051cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801051cf:	89 54 24 04          	mov    %edx,0x4(%esp)
801051d3:	89 34 24             	mov    %esi,(%esp)
801051d6:	89 44 24 08          	mov    %eax,0x8(%esp)
801051da:	e8 41 ca ff ff       	call   80101c20 <writei>
801051df:	83 f8 10             	cmp    $0x10,%eax
801051e2:	0f 85 c5 00 00 00    	jne    801052ad <sys_unlink+0x1bd>
  if(ip->type == T_DIR){
801051e8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051ed:	0f 84 9d 00 00 00    	je     80105290 <sys_unlink+0x1a0>
  iunlockput(dp);
801051f3:	89 34 24             	mov    %esi,(%esp)
801051f6:	e8 a5 c8 ff ff       	call   80101aa0 <iunlockput>
  ip->nlink--;
801051fb:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801051ff:	89 1c 24             	mov    %ebx,(%esp)
80105202:	e8 39 c5 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
80105207:	89 1c 24             	mov    %ebx,(%esp)
8010520a:	e8 91 c8 ff ff       	call   80101aa0 <iunlockput>
  end_op();
8010520f:	e8 6c dc ff ff       	call   80102e80 <end_op>
  return 0;
80105214:	31 c0                	xor    %eax,%eax
}
80105216:	83 c4 4c             	add    $0x4c,%esp
80105219:	5b                   	pop    %ebx
8010521a:	5e                   	pop    %esi
8010521b:	5f                   	pop    %edi
8010521c:	5d                   	pop    %ebp
8010521d:	c3                   	ret    
8010521e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105220:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105224:	76 83                	jbe    801051a9 <sys_unlink+0xb9>
80105226:	bf 20 00 00 00       	mov    $0x20,%edi
8010522b:	eb 0f                	jmp    8010523c <sys_unlink+0x14c>
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
80105230:	83 c7 10             	add    $0x10,%edi
80105233:	39 7b 58             	cmp    %edi,0x58(%ebx)
80105236:	0f 86 6d ff ff ff    	jbe    801051a9 <sys_unlink+0xb9>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010523c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105240:	b8 10 00 00 00       	mov    $0x10,%eax
80105245:	89 44 24 0c          	mov    %eax,0xc(%esp)
80105249:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010524d:	89 1c 24             	mov    %ebx,(%esp)
80105250:	e8 9b c8 ff ff       	call   80101af0 <readi>
80105255:	8d 55 d8             	lea    -0x28(%ebp),%edx
80105258:	83 f8 10             	cmp    $0x10,%eax
8010525b:	75 44                	jne    801052a1 <sys_unlink+0x1b1>
    if(de.inum != 0)
8010525d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105262:	74 cc                	je     80105230 <sys_unlink+0x140>
    iunlockput(ip);
80105264:	89 1c 24             	mov    %ebx,(%esp)
80105267:	e8 34 c8 ff ff       	call   80101aa0 <iunlockput>
    goto bad;
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105270:	89 34 24             	mov    %esi,(%esp)
80105273:	e8 28 c8 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105278:	e8 03 dc ff ff       	call   80102e80 <end_op>
  return -1;
8010527d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105282:	eb 92                	jmp    80105216 <sys_unlink+0x126>
80105284:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010528f:	90                   	nop
    dp->nlink--;
80105290:	66 ff 4e 56          	decw   0x56(%esi)
    iupdate(dp);
80105294:	89 34 24             	mov    %esi,(%esp)
80105297:	e8 a4 c4 ff ff       	call   80101740 <iupdate>
8010529c:	e9 52 ff ff ff       	jmp    801051f3 <sys_unlink+0x103>
      panic("isdirempty: readi");
801052a1:	c7 04 24 bc 79 10 80 	movl   $0x801079bc,(%esp)
801052a8:	e8 b3 b0 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
801052ad:	c7 04 24 ce 79 10 80 	movl   $0x801079ce,(%esp)
801052b4:	e8 a7 b0 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
801052b9:	c7 04 24 aa 79 10 80 	movl   $0x801079aa,(%esp)
801052c0:	e8 9b b0 ff ff       	call   80100360 <panic>
801052c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052d0 <sys_open>:

int
sys_open(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	57                   	push   %edi
801052d4:	56                   	push   %esi
801052d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052d9:	83 ec 2c             	sub    $0x2c,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052e7:	e8 44 f8 ff ff       	call   80104b30 <argstr>
801052ec:	85 c0                	test   %eax,%eax
801052ee:	0f 88 7f 00 00 00    	js     80105373 <sys_open+0xa3>
801052f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801052fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105302:	e8 69 f7 ff ff       	call   80104a70 <argint>
80105307:	85 c0                	test   %eax,%eax
80105309:	78 68                	js     80105373 <sys_open+0xa3>
    return -1;

  begin_op();
8010530b:	e8 00 db ff ff       	call   80102e10 <begin_op>

  if(omode & O_CREATE){
80105310:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105314:	75 6a                	jne    80105380 <sys_open+0xb0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105316:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105319:	89 04 24             	mov    %eax,(%esp)
8010531c:	e8 4f ce ff ff       	call   80102170 <namei>
80105321:	85 c0                	test   %eax,%eax
80105323:	89 c6                	mov    %eax,%esi
80105325:	74 47                	je     8010536e <sys_open+0x9e>
      end_op();
      return -1;
    }
    ilock(ip);
80105327:	89 04 24             	mov    %eax,(%esp)
8010532a:	e8 d1 c4 ff ff       	call   80101800 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010532f:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105334:	0f 84 a6 00 00 00    	je     801053e0 <sys_open+0x110>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010533a:	e8 e1 ba ff ff       	call   80100e20 <filealloc>
8010533f:	85 c0                	test   %eax,%eax
80105341:	89 c7                	mov    %eax,%edi
80105343:	74 21                	je     80105366 <sys_open+0x96>
  struct proc *curproc = myproc();
80105345:	e8 b6 e6 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010534a:	31 db                	xor    %ebx,%ebx
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105350:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105354:	85 d2                	test   %edx,%edx
80105356:	74 48                	je     801053a0 <sys_open+0xd0>
  for(fd = 0; fd < NOFILE; fd++){
80105358:	43                   	inc    %ebx
80105359:	83 fb 10             	cmp    $0x10,%ebx
8010535c:	75 f2                	jne    80105350 <sys_open+0x80>
    if(f)
      fileclose(f);
8010535e:	89 3c 24             	mov    %edi,(%esp)
80105361:	e8 7a bb ff ff       	call   80100ee0 <fileclose>
    iunlockput(ip);
80105366:	89 34 24             	mov    %esi,(%esp)
80105369:	e8 32 c7 ff ff       	call   80101aa0 <iunlockput>
    end_op();
8010536e:	e8 0d db ff ff       	call   80102e80 <end_op>
    return -1;
80105373:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105378:	eb 5b                	jmp    801053d5 <sys_open+0x105>
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ip = create(path, T_FILE, 0, 0);
80105380:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105383:	31 c9                	xor    %ecx,%ecx
80105385:	ba 02 00 00 00       	mov    $0x2,%edx
8010538a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105391:	e8 4a f8 ff ff       	call   80104be0 <create>
    if(ip == 0){
80105396:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105398:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010539a:	75 9e                	jne    8010533a <sys_open+0x6a>
8010539c:	eb d0                	jmp    8010536e <sys_open+0x9e>
8010539e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801053a0:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  }
  iunlock(ip);
801053a4:	89 34 24             	mov    %esi,(%esp)
801053a7:	e8 34 c5 ff ff       	call   801018e0 <iunlock>
  end_op();
801053ac:	e8 cf da ff ff       	call   80102e80 <end_op>

  f->type = FD_INODE;
801053b1:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
801053b7:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->off = 0;
801053bd:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053c4:	89 d0                	mov    %edx,%eax
801053c6:	f7 d0                	not    %eax
801053c8:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053cb:	f6 c2 03             	test   $0x3,%dl
  f->readable = !(omode & O_WRONLY);
801053ce:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053d1:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053d5:	83 c4 2c             	add    $0x2c,%esp
801053d8:	89 d8                	mov    %ebx,%eax
801053da:	5b                   	pop    %ebx
801053db:	5e                   	pop    %esi
801053dc:	5f                   	pop    %edi
801053dd:	5d                   	pop    %ebp
801053de:	c3                   	ret    
801053df:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801053e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053e3:	85 c9                	test   %ecx,%ecx
801053e5:	0f 84 4f ff ff ff    	je     8010533a <sys_open+0x6a>
801053eb:	e9 76 ff ff ff       	jmp    80105366 <sys_open+0x96>

801053f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053f6:	e8 15 da ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105402:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105409:	e8 22 f7 ff ff       	call   80104b30 <argstr>
8010540e:	85 c0                	test   %eax,%eax
80105410:	78 2e                	js     80105440 <sys_mkdir+0x50>
80105412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105415:	31 c9                	xor    %ecx,%ecx
80105417:	ba 01 00 00 00       	mov    $0x1,%edx
8010541c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105423:	e8 b8 f7 ff ff       	call   80104be0 <create>
80105428:	85 c0                	test   %eax,%eax
8010542a:	74 14                	je     80105440 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010542c:	89 04 24             	mov    %eax,(%esp)
8010542f:	e8 6c c6 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105434:	e8 47 da ff ff       	call   80102e80 <end_op>
  return 0;
80105439:	31 c0                	xor    %eax,%eax
}
8010543b:	c9                   	leave  
8010543c:	c3                   	ret    
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105440:	e8 3b da ff ff       	call   80102e80 <end_op>
    return -1;
80105445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010544a:	c9                   	leave  
8010544b:	c3                   	ret    
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_mknod>:

int
sys_mknod(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105456:	e8 b5 d9 ff ff       	call   80102e10 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010545b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010545e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105462:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105469:	e8 c2 f6 ff ff       	call   80104b30 <argstr>
8010546e:	85 c0                	test   %eax,%eax
80105470:	78 5e                	js     801054d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105472:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105479:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010547c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105480:	e8 eb f5 ff ff       	call   80104a70 <argint>
  if((argstr(0, &path)) < 0 ||
80105485:	85 c0                	test   %eax,%eax
80105487:	78 47                	js     801054d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105489:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105490:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105493:	89 44 24 04          	mov    %eax,0x4(%esp)
80105497:	e8 d4 f5 ff ff       	call   80104a70 <argint>
     argint(1, &major) < 0 ||
8010549c:	85 c0                	test   %eax,%eax
8010549e:	78 30                	js     801054d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054a0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801054a4:	ba 03 00 00 00       	mov    $0x3,%edx
801054a9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054ad:	89 04 24             	mov    %eax,(%esp)
801054b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054b3:	e8 28 f7 ff ff       	call   80104be0 <create>
     argint(2, &minor) < 0 ||
801054b8:	85 c0                	test   %eax,%eax
801054ba:	74 14                	je     801054d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054bc:	89 04 24             	mov    %eax,(%esp)
801054bf:	e8 dc c5 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801054c4:	e8 b7 d9 ff ff       	call   80102e80 <end_op>
  return 0;
801054c9:	31 c0                	xor    %eax,%eax
}
801054cb:	c9                   	leave  
801054cc:	c3                   	ret    
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801054d0:	e8 ab d9 ff ff       	call   80102e80 <end_op>
    return -1;
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054da:	c9                   	leave  
801054db:	c3                   	ret    
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_chdir>:

int
sys_chdir(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
801054e5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054e8:	e8 13 e5 ff ff       	call   80103a00 <myproc>
801054ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054ef:	e8 1c d9 ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801054fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105502:	e8 29 f6 ff ff       	call   80104b30 <argstr>
80105507:	85 c0                	test   %eax,%eax
80105509:	78 4a                	js     80105555 <sys_chdir+0x75>
8010550b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550e:	89 04 24             	mov    %eax,(%esp)
80105511:	e8 5a cc ff ff       	call   80102170 <namei>
80105516:	85 c0                	test   %eax,%eax
80105518:	89 c3                	mov    %eax,%ebx
8010551a:	74 39                	je     80105555 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010551c:	89 04 24             	mov    %eax,(%esp)
8010551f:	e8 dc c2 ff ff       	call   80101800 <ilock>
  if(ip->type != T_DIR){
80105524:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105529:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010552c:	75 22                	jne    80105550 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010552e:	e8 ad c3 ff ff       	call   801018e0 <iunlock>
  iput(curproc->cwd);
80105533:	8b 46 68             	mov    0x68(%esi),%eax
80105536:	89 04 24             	mov    %eax,(%esp)
80105539:	e8 f2 c3 ff ff       	call   80101930 <iput>
  end_op();
8010553e:	e8 3d d9 ff ff       	call   80102e80 <end_op>
  curproc->cwd = ip;
  return 0;
80105543:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105545:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105548:	83 c4 20             	add    $0x20,%esp
8010554b:	5b                   	pop    %ebx
8010554c:	5e                   	pop    %esi
8010554d:	5d                   	pop    %ebp
8010554e:	c3                   	ret    
8010554f:	90                   	nop
    iunlockput(ip);
80105550:	e8 4b c5 ff ff       	call   80101aa0 <iunlockput>
    end_op();
80105555:	e8 26 d9 ff ff       	call   80102e80 <end_op>
    return -1;
8010555a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555f:	eb e7                	jmp    80105548 <sys_chdir+0x68>
80105561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop

80105570 <sys_exec>:

int
sys_exec(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	57                   	push   %edi
80105574:	56                   	push   %esi
80105575:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105576:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010557c:	81 ec ac 00 00 00    	sub    $0xac,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105582:	89 44 24 04          	mov    %eax,0x4(%esp)
80105586:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010558d:	e8 9e f5 ff ff       	call   80104b30 <argstr>
80105592:	85 c0                	test   %eax,%eax
80105594:	0f 88 8e 00 00 00    	js     80105628 <sys_exec+0xb8>
8010559a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055a1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ab:	e8 c0 f4 ff ff       	call   80104a70 <argint>
801055b0:	85 c0                	test   %eax,%eax
801055b2:	78 74                	js     80105628 <sys_exec+0xb8>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055b4:	ba 80 00 00 00       	mov    $0x80,%edx
801055b9:	31 c9                	xor    %ecx,%ecx
801055bb:	89 54 24 08          	mov    %edx,0x8(%esp)
801055bf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801055c5:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801055cb:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801055d1:	89 04 24             	mov    %eax,(%esp)
801055d4:	e8 b7 f1 ff ff       	call   80104790 <memset>
    if(i >= NELEM(argv))
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
801055e4:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055ea:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801055f1:	01 f0                	add    %esi,%eax
801055f3:	89 04 24             	mov    %eax,(%esp)
801055f6:	e8 e5 f3 ff ff       	call   801049e0 <fetchint>
801055fb:	85 c0                	test   %eax,%eax
801055fd:	78 29                	js     80105628 <sys_exec+0xb8>
      return -1;
    if(uarg == 0){
801055ff:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105605:	85 c0                	test   %eax,%eax
80105607:	74 37                	je     80105640 <sys_exec+0xd0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105609:	89 04 24             	mov    %eax,(%esp)
8010560c:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105612:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105615:	89 54 24 04          	mov    %edx,0x4(%esp)
80105619:	e8 02 f4 ff ff       	call   80104a20 <fetchstr>
8010561e:	85 c0                	test   %eax,%eax
80105620:	78 06                	js     80105628 <sys_exec+0xb8>
  for(i=0;; i++){
80105622:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80105623:	83 fb 20             	cmp    $0x20,%ebx
80105626:	75 b8                	jne    801055e0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
80105628:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
8010562e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105633:	5b                   	pop    %ebx
80105634:	5e                   	pop    %esi
80105635:	5f                   	pop    %edi
80105636:	5d                   	pop    %ebp
80105637:	c3                   	ret    
80105638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop
      argv[i] = 0;
80105640:	31 c0                	xor    %eax,%eax
80105642:	89 84 9d 68 ff ff ff 	mov    %eax,-0x98(%ebp,%ebx,4)
  return exec(path, argv);
80105649:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010564f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105653:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105659:	89 04 24             	mov    %eax,(%esp)
8010565c:	e8 0f b4 ff ff       	call   80100a70 <exec>
}
80105661:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105667:	5b                   	pop    %ebx
80105668:	5e                   	pop    %esi
80105669:	5f                   	pop    %edi
8010566a:	5d                   	pop    %ebp
8010566b:	c3                   	ret    
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_pipe>:

int
sys_pipe(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105674:	bf 08 00 00 00       	mov    $0x8,%edi
{
80105679:	56                   	push   %esi
8010567a:	53                   	push   %ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010567b:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010567e:	83 ec 2c             	sub    $0x2c,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105681:	89 7c 24 08          	mov    %edi,0x8(%esp)
80105685:	89 44 24 04          	mov    %eax,0x4(%esp)
80105689:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105690:	e8 2b f4 ff ff       	call   80104ac0 <argptr>
80105695:	85 c0                	test   %eax,%eax
80105697:	78 4b                	js     801056e4 <sys_pipe+0x74>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105699:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010569c:	89 44 24 04          	mov    %eax,0x4(%esp)
801056a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056a3:	89 04 24             	mov    %eax,(%esp)
801056a6:	e8 d5 dd ff ff       	call   80103480 <pipealloc>
801056ab:	85 c0                	test   %eax,%eax
801056ad:	78 35                	js     801056e4 <sys_pipe+0x74>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056af:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056b2:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056b4:	e8 47 e3 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056c0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056c4:	85 f6                	test   %esi,%esi
801056c6:	74 28                	je     801056f0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801056c8:	43                   	inc    %ebx
801056c9:	83 fb 10             	cmp    $0x10,%ebx
801056cc:	75 f2                	jne    801056c0 <sys_pipe+0x50>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801056ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056d1:	89 04 24             	mov    %eax,(%esp)
801056d4:	e8 07 b8 ff ff       	call   80100ee0 <fileclose>
    fileclose(wf);
801056d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801056dc:	89 04 24             	mov    %eax,(%esp)
801056df:	e8 fc b7 ff ff       	call   80100ee0 <fileclose>
    return -1;
801056e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e9:	eb 56                	jmp    80105741 <sys_pipe+0xd1>
801056eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop
      curproc->ofile[fd] = f;
801056f0:	8d 73 08             	lea    0x8(%ebx),%esi
801056f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056fa:	e8 01 e3 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ff:	31 d2                	xor    %edx,%edx
80105701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105710:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105714:	85 c9                	test   %ecx,%ecx
80105716:	74 18                	je     80105730 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105718:	42                   	inc    %edx
80105719:	83 fa 10             	cmp    $0x10,%edx
8010571c:	75 f2                	jne    80105710 <sys_pipe+0xa0>
      myproc()->ofile[fd0] = 0;
8010571e:	e8 dd e2 ff ff       	call   80103a00 <myproc>
80105723:	31 d2                	xor    %edx,%edx
80105725:	89 54 b0 08          	mov    %edx,0x8(%eax,%esi,4)
80105729:	eb a3                	jmp    801056ce <sys_pipe+0x5e>
8010572b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010572f:	90                   	nop
      curproc->ofile[fd] = f;
80105730:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105734:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105737:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105739:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010573c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010573f:	31 c0                	xor    %eax,%eax
}
80105741:	83 c4 2c             	add    $0x2c,%esp
80105744:	5b                   	pop    %ebx
80105745:	5e                   	pop    %esi
80105746:	5f                   	pop    %edi
80105747:	5d                   	pop    %ebp
80105748:	c3                   	ret    
80105749:	66 90                	xchg   %ax,%ax
8010574b:	66 90                	xchg   %ax,%ax
8010574d:	66 90                	xchg   %ax,%ax
8010574f:	90                   	nop

80105750 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105750:	e9 5b e4 ff ff       	jmp    80103bb0 <fork>
80105755:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_exit>:
}

int
sys_exit(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	83 ec 08             	sub    $0x8,%esp
  exit();
80105766:	e8 a5 e6 ff ff       	call   80103e10 <exit>
  return 0;  // not reached
}
8010576b:	31 c0                	xor    %eax,%eax
8010576d:	c9                   	leave  
8010576e:	c3                   	ret    
8010576f:	90                   	nop

80105770 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105770:	e9 eb e8 ff ff       	jmp    80104060 <wait>
80105775:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_kill>:
}

int
sys_kill(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105786:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010578d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105790:	89 44 24 04          	mov    %eax,0x4(%esp)
80105794:	e8 d7 f2 ff ff       	call   80104a70 <argint>
80105799:	85 c0                	test   %eax,%eax
8010579b:	78 13                	js     801057b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010579d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a0:	89 04 24             	mov    %eax,(%esp)
801057a3:	e8 18 ea ff ff       	call   801041c0 <kill>
}
801057a8:	c9                   	leave  
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057b0:	c9                   	leave  
    return -1;
801057b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057b6:	c3                   	ret    
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax

801057c0 <sys_getpid>:

int
sys_getpid(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057c6:	e8 35 e2 ff ff       	call   80103a00 <myproc>
801057cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801057ce:	c9                   	leave  
801057cf:	c3                   	ret    

801057d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057d7:	83 ec 24             	sub    $0x24,%esp
  if(argint(0, &n) < 0)
801057da:	89 44 24 04          	mov    %eax,0x4(%esp)
801057de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057e5:	e8 86 f2 ff ff       	call   80104a70 <argint>
801057ea:	85 c0                	test   %eax,%eax
801057ec:	78 22                	js     80105810 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057ee:	e8 0d e2 ff ff       	call   80103a00 <myproc>
801057f3:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f8:	89 04 24             	mov    %eax,(%esp)
801057fb:	e8 30 e3 ff ff       	call   80103b30 <growproc>
80105800:	85 c0                	test   %eax,%eax
80105802:	78 0c                	js     80105810 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105804:	83 c4 24             	add    $0x24,%esp
80105807:	89 d8                	mov    %ebx,%eax
80105809:	5b                   	pop    %ebx
8010580a:	5d                   	pop    %ebp
8010580b:	c3                   	ret    
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105810:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105815:	eb ed                	jmp    80105804 <sys_sbrk+0x34>
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax

80105820 <sys_sleep>:

int
sys_sleep(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105824:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105827:	83 ec 24             	sub    $0x24,%esp
  if(argint(0, &n) < 0)
8010582a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010582e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105835:	e8 36 f2 ff ff       	call   80104a70 <argint>
8010583a:	85 c0                	test   %eax,%eax
8010583c:	0f 88 82 00 00 00    	js     801058c4 <sys_sleep+0xa4>
    return -1;
  acquire(&tickslock);
80105842:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105849:	e8 42 ee ff ff       	call   80104690 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010584e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  ticks0 = ticks;
80105851:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105857:	85 c9                	test   %ecx,%ecx
80105859:	75 26                	jne    80105881 <sys_sleep+0x61>
8010585b:	eb 53                	jmp    801058b0 <sys_sleep+0x90>
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105860:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
80105867:	b8 60 4c 11 80       	mov    $0x80114c60,%eax
8010586c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105870:	e8 1b e7 ff ff       	call   80103f90 <sleep>
  while(ticks - ticks0 < n){
80105875:	a1 a0 54 11 80       	mov    0x801154a0,%eax
8010587a:	29 d8                	sub    %ebx,%eax
8010587c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010587f:	73 2f                	jae    801058b0 <sys_sleep+0x90>
    if(myproc()->killed){
80105881:	e8 7a e1 ff ff       	call   80103a00 <myproc>
80105886:	8b 50 24             	mov    0x24(%eax),%edx
80105889:	85 d2                	test   %edx,%edx
8010588b:	74 d3                	je     80105860 <sys_sleep+0x40>
      release(&tickslock);
8010588d:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105894:	e8 a7 ee ff ff       	call   80104740 <release>
  }
  release(&tickslock);
  return 0;
}
80105899:	83 c4 24             	add    $0x24,%esp
      return -1;
8010589c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058a1:	5b                   	pop    %ebx
801058a2:	5d                   	pop    %ebp
801058a3:	c3                   	ret    
801058a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058af:	90                   	nop
  release(&tickslock);
801058b0:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801058b7:	e8 84 ee ff ff       	call   80104740 <release>
  return 0;
801058bc:	31 c0                	xor    %eax,%eax
}
801058be:	83 c4 24             	add    $0x24,%esp
801058c1:	5b                   	pop    %ebx
801058c2:	5d                   	pop    %ebp
801058c3:	c3                   	ret    
    return -1;
801058c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c9:	eb f3                	jmp    801058be <sys_sleep+0x9e>
801058cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058cf:	90                   	nop

801058d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
801058d4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801058d7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801058de:	e8 ad ed ff ff       	call   80104690 <acquire>
  xticks = ticks;
801058e3:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
801058e9:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801058f0:	e8 4b ee ff ff       	call   80104740 <release>
  return xticks;
}
801058f5:	83 c4 14             	add    $0x14,%esp
801058f8:	89 d8                	mov    %ebx,%eax
801058fa:	5b                   	pop    %ebx
801058fb:	5d                   	pop    %ebp
801058fc:	c3                   	ret    
801058fd:	8d 76 00             	lea    0x0(%esi),%esi

80105900 <sys_proc_dump>:
int
sys_proc_dump(void)
{
80105900:	55                   	push   %ebp
    int *size;
    struct proc_info *process;

    argptr(0, (void *)&process, sizeof(struct proc_info));
80105901:	b8 08 00 00 00       	mov    $0x8,%eax
{
80105906:	89 e5                	mov    %esp,%ebp
80105908:	83 ec 28             	sub    $0x28,%esp
    argptr(0, (void *)&process, sizeof(struct proc_info));
8010590b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010590f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105912:	89 44 24 04          	mov    %eax,0x4(%esp)
80105916:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010591d:	e8 9e f1 ff ff       	call   80104ac0 <argptr>
    argptr(1, (void *)&size, sizeof(int));
80105922:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105925:	ba 04 00 00 00       	mov    $0x4,%edx
8010592a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010592e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105932:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105939:	e8 82 f1 ff ff       	call   80104ac0 <argptr>

    proc_dump(process, size);
8010593e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105941:	89 44 24 04          	mov    %eax,0x4(%esp)
80105945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105948:	89 04 24             	mov    %eax,(%esp)
8010594b:	e8 d0 e9 ff ff       	call   80104320 <proc_dump>

    return 0;
80105950:	31 c0                	xor    %eax,%eax
80105952:	c9                   	leave  
80105953:	c3                   	ret    

80105954 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105954:	1e                   	push   %ds
  pushl %es
80105955:	06                   	push   %es
  pushl %fs
80105956:	0f a0                	push   %fs
  pushl %gs
80105958:	0f a8                	push   %gs
  pushal
8010595a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010595b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010595f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105961:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105963:	54                   	push   %esp
  call trap
80105964:	e8 c7 00 00 00       	call   80105a30 <trap>
  addl $4, %esp
80105969:	83 c4 04             	add    $0x4,%esp

8010596c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010596c:	61                   	popa   
  popl %gs
8010596d:	0f a9                	pop    %gs
  popl %fs
8010596f:	0f a1                	pop    %fs
  popl %es
80105971:	07                   	pop    %es
  popl %ds
80105972:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105973:	83 c4 08             	add    $0x8,%esp
  iret
80105976:	cf                   	iret   
80105977:	66 90                	xchg   %ax,%ax
80105979:	66 90                	xchg   %ax,%ax
8010597b:	66 90                	xchg   %ax,%ax
8010597d:	66 90                	xchg   %ax,%ax
8010597f:	90                   	nop

80105980 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105980:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105981:	31 c0                	xor    %eax,%eax
{
80105983:	89 e5                	mov    %esp,%ebp
80105985:	83 ec 18             	sub    $0x18,%esp
80105988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105990:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105997:	b9 08 00 00 8e       	mov    $0x8e000008,%ecx
8010599c:	89 0c c5 a2 4c 11 80 	mov    %ecx,-0x7feeb35e(,%eax,8)
801059a3:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
801059aa:	80 
801059ab:	c1 ea 10             	shr    $0x10,%edx
801059ae:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801059b5:	80 
  for(i = 0; i < 256; i++)
801059b6:	40                   	inc    %eax
801059b7:	3d 00 01 00 00       	cmp    $0x100,%eax
801059bc:	75 d2                	jne    80105990 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059be:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801059c3:	b9 dd 79 10 80       	mov    $0x801079dd,%ecx
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059c8:	ba 08 00 00 ef       	mov    $0xef000008,%edx
  initlock(&tickslock, "time");
801059cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801059d1:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059d8:	89 15 a2 4e 11 80    	mov    %edx,0x80114ea2
801059de:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801059e4:	c1 e8 10             	shr    $0x10,%eax
801059e7:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801059ed:	e8 2e eb ff ff       	call   80104520 <initlock>
}
801059f2:	c9                   	leave  
801059f3:	c3                   	ret    
801059f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ff:	90                   	nop

80105a00 <idtinit>:

void
idtinit(void)
{
80105a00:	55                   	push   %ebp
  pd[1] = (uint)p;
80105a01:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105a06:	89 e5                	mov    %esp,%ebp
80105a08:	0f b7 d0             	movzwl %ax,%edx
  pd[2] = (uint)p >> 16;
80105a0b:	c1 e8 10             	shr    $0x10,%eax
80105a0e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105a11:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105a17:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    
80105a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2e:	66 90                	xchg   %ax,%ax

80105a30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
80105a35:	53                   	push   %ebx
80105a36:	83 ec 3c             	sub    $0x3c,%esp
80105a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105a3c:	8b 43 30             	mov    0x30(%ebx),%eax
80105a3f:	83 f8 40             	cmp    $0x40,%eax
80105a42:	0f 84 f8 01 00 00    	je     80105c40 <trap+0x210>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a48:	83 e8 20             	sub    $0x20,%eax
80105a4b:	83 f8 1f             	cmp    $0x1f,%eax
80105a4e:	77 07                	ja     80105a57 <trap+0x27>
80105a50:	ff 24 85 84 7a 10 80 	jmp    *-0x7fef857c(,%eax,4)
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a57:	e8 a4 df ff ff       	call   80103a00 <myproc>
80105a5c:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a5f:	85 c0                	test   %eax,%eax
80105a61:	0f 84 30 02 00 00    	je     80105c97 <trap+0x267>
80105a67:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a6b:	0f 84 26 02 00 00    	je     80105c97 <trap+0x267>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a71:	0f 20 d1             	mov    %cr2,%ecx
80105a74:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a77:	e8 64 df ff ff       	call   801039e0 <cpuid>
80105a7c:	8b 73 30             	mov    0x30(%ebx),%esi
80105a7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a82:	8b 43 34             	mov    0x34(%ebx),%eax
80105a85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a88:	e8 73 df ff ff       	call   80103a00 <myproc>
80105a8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a90:	e8 6b df ff ff       	call   80103a00 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a95:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a98:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a9c:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a9f:	89 7c 24 18          	mov    %edi,0x18(%esp)
80105aa3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105aa6:	89 54 24 14          	mov    %edx,0x14(%esp)
80105aaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105aad:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ab0:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ab4:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ab8:	89 54 24 10          	mov    %edx,0x10(%esp)
80105abc:	8b 40 10             	mov    0x10(%eax),%eax
80105abf:	c7 04 24 40 7a 10 80 	movl   $0x80107a40,(%esp)
80105ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aca:	e8 b1 ab ff ff       	call   80100680 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105acf:	e8 2c df ff ff       	call   80103a00 <myproc>
80105ad4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105adb:	e8 20 df ff ff       	call   80103a00 <myproc>
80105ae0:	85 c0                	test   %eax,%eax
80105ae2:	74 1b                	je     80105aff <trap+0xcf>
80105ae4:	e8 17 df ff ff       	call   80103a00 <myproc>
80105ae9:	8b 50 24             	mov    0x24(%eax),%edx
80105aec:	85 d2                	test   %edx,%edx
80105aee:	74 0f                	je     80105aff <trap+0xcf>
80105af0:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105af3:	83 e0 03             	and    $0x3,%eax
80105af6:	83 f8 03             	cmp    $0x3,%eax
80105af9:	0f 84 81 01 00 00    	je     80105c80 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105aff:	e8 fc de ff ff       	call   80103a00 <myproc>
80105b04:	85 c0                	test   %eax,%eax
80105b06:	74 0f                	je     80105b17 <trap+0xe7>
80105b08:	e8 f3 de ff ff       	call   80103a00 <myproc>
80105b0d:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b11:	0f 84 09 01 00 00    	je     80105c20 <trap+0x1f0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b17:	e8 e4 de ff ff       	call   80103a00 <myproc>
80105b1c:	85 c0                	test   %eax,%eax
80105b1e:	66 90                	xchg   %ax,%ax
80105b20:	74 1b                	je     80105b3d <trap+0x10d>
80105b22:	e8 d9 de ff ff       	call   80103a00 <myproc>
80105b27:	8b 40 24             	mov    0x24(%eax),%eax
80105b2a:	85 c0                	test   %eax,%eax
80105b2c:	74 0f                	je     80105b3d <trap+0x10d>
80105b2e:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105b31:	83 e0 03             	and    $0x3,%eax
80105b34:	83 f8 03             	cmp    $0x3,%eax
80105b37:	0f 84 2c 01 00 00    	je     80105c69 <trap+0x239>
    exit();
}
80105b3d:	83 c4 3c             	add    $0x3c,%esp
80105b40:	5b                   	pop    %ebx
80105b41:	5e                   	pop    %esi
80105b42:	5f                   	pop    %edi
80105b43:	5d                   	pop    %ebp
80105b44:	c3                   	ret    
    ideintr();
80105b45:	e8 b6 c7 ff ff       	call   80102300 <ideintr>
    lapiceoi();
80105b4a:	e8 91 ce ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b4f:	90                   	nop
80105b50:	e8 ab de ff ff       	call   80103a00 <myproc>
80105b55:	85 c0                	test   %eax,%eax
80105b57:	75 8b                	jne    80105ae4 <trap+0xb4>
80105b59:	eb a4                	jmp    80105aff <trap+0xcf>
    if(cpuid() == 0){
80105b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
80105b60:	e8 7b de ff ff       	call   801039e0 <cpuid>
80105b65:	85 c0                	test   %eax,%eax
80105b67:	75 e1                	jne    80105b4a <trap+0x11a>
      acquire(&tickslock);
80105b69:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105b70:	e8 1b eb ff ff       	call   80104690 <acquire>
      wakeup(&ticks);
80105b75:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105b7c:	ff 05 a0 54 11 80    	incl   0x801154a0
      wakeup(&ticks);
80105b82:	e8 d9 e5 ff ff       	call   80104160 <wakeup>
      release(&tickslock);
80105b87:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105b8e:	e8 ad eb ff ff       	call   80104740 <release>
    lapiceoi();
80105b93:	eb b5                	jmp    80105b4a <trap+0x11a>
    kbdintr();
80105b95:	e8 06 cd ff ff       	call   801028a0 <kbdintr>
    lapiceoi();
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ba0:	e8 3b ce ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ba5:	e8 56 de ff ff       	call   80103a00 <myproc>
80105baa:	85 c0                	test   %eax,%eax
80105bac:	0f 85 32 ff ff ff    	jne    80105ae4 <trap+0xb4>
80105bb2:	e9 48 ff ff ff       	jmp    80105aff <trap+0xcf>
    uartintr();
80105bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbe:	66 90                	xchg   %ax,%ax
80105bc0:	e8 7b 02 00 00       	call   80105e40 <uartintr>
    lapiceoi();
80105bc5:	e8 16 ce ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bca:	e8 31 de ff ff       	call   80103a00 <myproc>
80105bcf:	85 c0                	test   %eax,%eax
80105bd1:	0f 85 0d ff ff ff    	jne    80105ae4 <trap+0xb4>
80105bd7:	e9 23 ff ff ff       	jmp    80105aff <trap+0xcf>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bdc:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bdf:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105be3:	e8 f8 dd ff ff       	call   801039e0 <cpuid>
80105be8:	c7 04 24 e8 79 10 80 	movl   $0x801079e8,(%esp)
80105bef:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105bf3:	89 74 24 08          	mov    %esi,0x8(%esp)
80105bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bfb:	e8 80 aa ff ff       	call   80100680 <cprintf>
    lapiceoi();
80105c00:	e8 db cd ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c05:	e8 f6 dd ff ff       	call   80103a00 <myproc>
80105c0a:	85 c0                	test   %eax,%eax
80105c0c:	0f 85 d2 fe ff ff    	jne    80105ae4 <trap+0xb4>
80105c12:	e9 e8 fe ff ff       	jmp    80105aff <trap+0xcf>
80105c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1e:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80105c20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c24:	0f 85 ed fe ff ff    	jne    80105b17 <trap+0xe7>
    yield();
80105c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c30:	e8 0b e3 ff ff       	call   80103f40 <yield>
80105c35:	e9 dd fe ff ff       	jmp    80105b17 <trap+0xe7>
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105c40:	e8 bb dd ff ff       	call   80103a00 <myproc>
80105c45:	8b 70 24             	mov    0x24(%eax),%esi
80105c48:	85 f6                	test   %esi,%esi
80105c4a:	75 44                	jne    80105c90 <trap+0x260>
    myproc()->tf = tf;
80105c4c:	e8 af dd ff ff       	call   80103a00 <myproc>
80105c51:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c54:	e8 17 ef ff ff       	call   80104b70 <syscall>
    if(myproc()->killed)
80105c59:	e8 a2 dd ff ff       	call   80103a00 <myproc>
80105c5e:	8b 48 24             	mov    0x24(%eax),%ecx
80105c61:	85 c9                	test   %ecx,%ecx
80105c63:	0f 84 d4 fe ff ff    	je     80105b3d <trap+0x10d>
}
80105c69:	83 c4 3c             	add    $0x3c,%esp
80105c6c:	5b                   	pop    %ebx
80105c6d:	5e                   	pop    %esi
80105c6e:	5f                   	pop    %edi
80105c6f:	5d                   	pop    %ebp
      exit();
80105c70:	e9 9b e1 ff ff       	jmp    80103e10 <exit>
80105c75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105c80:	e8 8b e1 ff ff       	call   80103e10 <exit>
80105c85:	e9 75 fe ff ff       	jmp    80105aff <trap+0xcf>
80105c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105c90:	e8 7b e1 ff ff       	call   80103e10 <exit>
80105c95:	eb b5                	jmp    80105c4c <trap+0x21c>
80105c97:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ca0:	e8 3b dd ff ff       	call   801039e0 <cpuid>
80105ca5:	89 74 24 10          	mov    %esi,0x10(%esp)
80105ca9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105cad:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cb1:	8b 43 30             	mov    0x30(%ebx),%eax
80105cb4:	c7 04 24 0c 7a 10 80 	movl   $0x80107a0c,(%esp)
80105cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cbf:	e8 bc a9 ff ff       	call   80100680 <cprintf>
      panic("trap");
80105cc4:	c7 04 24 e2 79 10 80 	movl   $0x801079e2,(%esp)
80105ccb:	e8 90 a6 ff ff       	call   80100360 <panic>

80105cd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105cd0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105cd5:	85 c0                	test   %eax,%eax
80105cd7:	74 17                	je     80105cf0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cd9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cde:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105cdf:	24 01                	and    $0x1,%al
80105ce1:	74 0d                	je     80105cf0 <uartgetc+0x20>
80105ce3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ce8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ce9:	0f b6 c0             	movzbl %al,%eax
80105cec:	c3                   	ret    
80105ced:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cf5:	c3                   	ret    
80105cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfd:	8d 76 00             	lea    0x0(%esi),%esi

80105d00 <uartputc.part.0>:
uartputc(int c)
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	56                   	push   %esi
80105d04:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d09:	53                   	push   %ebx
80105d0a:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d0f:	83 ec 20             	sub    $0x20,%esp
80105d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d15:	eb 18                	jmp    80105d2f <uartputc.part.0+0x2f>
80105d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105d20:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105d27:	e8 d4 cc ff ff       	call   80102a00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d2c:	4b                   	dec    %ebx
80105d2d:	74 07                	je     80105d36 <uartputc.part.0+0x36>
80105d2f:	89 f2                	mov    %esi,%edx
80105d31:	ec                   	in     (%dx),%al
80105d32:	24 20                	and    $0x20,%al
80105d34:	74 ea                	je     80105d20 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d36:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
80105d3a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d3f:	ee                   	out    %al,(%dx)
}
80105d40:	83 c4 20             	add    $0x20,%esp
80105d43:	5b                   	pop    %ebx
80105d44:	5e                   	pop    %esi
80105d45:	5d                   	pop    %ebp
80105d46:	c3                   	ret    
80105d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4e:	66 90                	xchg   %ax,%ax

80105d50 <uartinit>:
{
80105d50:	55                   	push   %ebp
80105d51:	31 c9                	xor    %ecx,%ecx
80105d53:	89 e5                	mov    %esp,%ebp
80105d55:	88 c8                	mov    %cl,%al
80105d57:	57                   	push   %edi
80105d58:	56                   	push   %esi
80105d59:	53                   	push   %ebx
80105d5a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d5f:	83 ec 2c             	sub    $0x2c,%esp
80105d62:	89 da                	mov    %ebx,%edx
80105d64:	ee                   	out    %al,(%dx)
80105d65:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d6a:	b0 80                	mov    $0x80,%al
80105d6c:	89 fa                	mov    %edi,%edx
80105d6e:	ee                   	out    %al,(%dx)
80105d6f:	b0 0c                	mov    $0xc,%al
80105d71:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d76:	ee                   	out    %al,(%dx)
80105d77:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d7c:	88 c8                	mov    %cl,%al
80105d7e:	89 f2                	mov    %esi,%edx
80105d80:	ee                   	out    %al,(%dx)
80105d81:	b0 03                	mov    $0x3,%al
80105d83:	89 fa                	mov    %edi,%edx
80105d85:	ee                   	out    %al,(%dx)
80105d86:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d8b:	88 c8                	mov    %cl,%al
80105d8d:	ee                   	out    %al,(%dx)
80105d8e:	b0 01                	mov    $0x1,%al
80105d90:	89 f2                	mov    %esi,%edx
80105d92:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d93:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d98:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d99:	fe c0                	inc    %al
80105d9b:	74 65                	je     80105e02 <uartinit+0xb2>
  uart = 1;
80105d9d:	be 01 00 00 00       	mov    $0x1,%esi
80105da2:	89 da                	mov    %ebx,%edx
80105da4:	89 35 bc a5 10 80    	mov    %esi,0x8010a5bc
80105daa:	ec                   	in     (%dx),%al
80105dab:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105db0:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105db1:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105db8:	31 ff                	xor    %edi,%edi
  for(p="xv6...\n"; *p; p++)
80105dba:	bb 04 7b 10 80       	mov    $0x80107b04,%ebx
  ioapicenable(IRQ_COM1, 0);
80105dbf:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105dc3:	e8 78 c7 ff ff       	call   80102540 <ioapicenable>
80105dc8:	b2 76                	mov    $0x76,%dl
  for(p="xv6...\n"; *p; p++)
80105dca:	b8 78 00 00 00       	mov    $0x78,%eax
80105dcf:	eb 16                	jmp    80105de7 <uartinit+0x97>
80105dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ddf:	90                   	nop
80105de0:	0f be c2             	movsbl %dl,%eax
80105de3:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
  if(!uart)
80105de7:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
80105ded:	85 c9                	test   %ecx,%ecx
80105def:	74 0c                	je     80105dfd <uartinit+0xad>
80105df1:	88 55 e7             	mov    %dl,-0x19(%ebp)
80105df4:	e8 07 ff ff ff       	call   80105d00 <uartputc.part.0>
80105df9:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  for(p="xv6...\n"; *p; p++)
80105dfd:	43                   	inc    %ebx
80105dfe:	84 d2                	test   %dl,%dl
80105e00:	75 de                	jne    80105de0 <uartinit+0x90>
}
80105e02:	83 c4 2c             	add    $0x2c,%esp
80105e05:	5b                   	pop    %ebx
80105e06:	5e                   	pop    %esi
80105e07:	5f                   	pop    %edi
80105e08:	5d                   	pop    %ebp
80105e09:	c3                   	ret    
80105e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e10 <uartputc>:
{
80105e10:	55                   	push   %ebp
  if(!uart)
80105e11:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105e17:	89 e5                	mov    %esp,%ebp
80105e19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105e1c:	85 d2                	test   %edx,%edx
80105e1e:	74 10                	je     80105e30 <uartputc+0x20>
}
80105e20:	5d                   	pop    %ebp
80105e21:	e9 da fe ff ff       	jmp    80105d00 <uartputc.part.0>
80105e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
80105e30:	5d                   	pop    %ebp
80105e31:	c3                   	ret    
80105e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e40 <uartintr>:

void
uartintr(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105e46:	c7 04 24 d0 5c 10 80 	movl   $0x80105cd0,(%esp)
80105e4d:	e8 de a9 ff ff       	call   80100830 <consoleintr>
}
80105e52:	c9                   	leave  
80105e53:	c3                   	ret    

80105e54 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $0
80105e56:	6a 00                	push   $0x0
  jmp alltraps
80105e58:	e9 f7 fa ff ff       	jmp    80105954 <alltraps>

80105e5d <vector1>:
.globl vector1
vector1:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $1
80105e5f:	6a 01                	push   $0x1
  jmp alltraps
80105e61:	e9 ee fa ff ff       	jmp    80105954 <alltraps>

80105e66 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $2
80105e68:	6a 02                	push   $0x2
  jmp alltraps
80105e6a:	e9 e5 fa ff ff       	jmp    80105954 <alltraps>

80105e6f <vector3>:
.globl vector3
vector3:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $3
80105e71:	6a 03                	push   $0x3
  jmp alltraps
80105e73:	e9 dc fa ff ff       	jmp    80105954 <alltraps>

80105e78 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $4
80105e7a:	6a 04                	push   $0x4
  jmp alltraps
80105e7c:	e9 d3 fa ff ff       	jmp    80105954 <alltraps>

80105e81 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $5
80105e83:	6a 05                	push   $0x5
  jmp alltraps
80105e85:	e9 ca fa ff ff       	jmp    80105954 <alltraps>

80105e8a <vector6>:
.globl vector6
vector6:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $6
80105e8c:	6a 06                	push   $0x6
  jmp alltraps
80105e8e:	e9 c1 fa ff ff       	jmp    80105954 <alltraps>

80105e93 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $7
80105e95:	6a 07                	push   $0x7
  jmp alltraps
80105e97:	e9 b8 fa ff ff       	jmp    80105954 <alltraps>

80105e9c <vector8>:
.globl vector8
vector8:
  pushl $8
80105e9c:	6a 08                	push   $0x8
  jmp alltraps
80105e9e:	e9 b1 fa ff ff       	jmp    80105954 <alltraps>

80105ea3 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $9
80105ea5:	6a 09                	push   $0x9
  jmp alltraps
80105ea7:	e9 a8 fa ff ff       	jmp    80105954 <alltraps>

80105eac <vector10>:
.globl vector10
vector10:
  pushl $10
80105eac:	6a 0a                	push   $0xa
  jmp alltraps
80105eae:	e9 a1 fa ff ff       	jmp    80105954 <alltraps>

80105eb3 <vector11>:
.globl vector11
vector11:
  pushl $11
80105eb3:	6a 0b                	push   $0xb
  jmp alltraps
80105eb5:	e9 9a fa ff ff       	jmp    80105954 <alltraps>

80105eba <vector12>:
.globl vector12
vector12:
  pushl $12
80105eba:	6a 0c                	push   $0xc
  jmp alltraps
80105ebc:	e9 93 fa ff ff       	jmp    80105954 <alltraps>

80105ec1 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ec1:	6a 0d                	push   $0xd
  jmp alltraps
80105ec3:	e9 8c fa ff ff       	jmp    80105954 <alltraps>

80105ec8 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ec8:	6a 0e                	push   $0xe
  jmp alltraps
80105eca:	e9 85 fa ff ff       	jmp    80105954 <alltraps>

80105ecf <vector15>:
.globl vector15
vector15:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $15
80105ed1:	6a 0f                	push   $0xf
  jmp alltraps
80105ed3:	e9 7c fa ff ff       	jmp    80105954 <alltraps>

80105ed8 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $16
80105eda:	6a 10                	push   $0x10
  jmp alltraps
80105edc:	e9 73 fa ff ff       	jmp    80105954 <alltraps>

80105ee1 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ee1:	6a 11                	push   $0x11
  jmp alltraps
80105ee3:	e9 6c fa ff ff       	jmp    80105954 <alltraps>

80105ee8 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $18
80105eea:	6a 12                	push   $0x12
  jmp alltraps
80105eec:	e9 63 fa ff ff       	jmp    80105954 <alltraps>

80105ef1 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $19
80105ef3:	6a 13                	push   $0x13
  jmp alltraps
80105ef5:	e9 5a fa ff ff       	jmp    80105954 <alltraps>

80105efa <vector20>:
.globl vector20
vector20:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $20
80105efc:	6a 14                	push   $0x14
  jmp alltraps
80105efe:	e9 51 fa ff ff       	jmp    80105954 <alltraps>

80105f03 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $21
80105f05:	6a 15                	push   $0x15
  jmp alltraps
80105f07:	e9 48 fa ff ff       	jmp    80105954 <alltraps>

80105f0c <vector22>:
.globl vector22
vector22:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $22
80105f0e:	6a 16                	push   $0x16
  jmp alltraps
80105f10:	e9 3f fa ff ff       	jmp    80105954 <alltraps>

80105f15 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $23
80105f17:	6a 17                	push   $0x17
  jmp alltraps
80105f19:	e9 36 fa ff ff       	jmp    80105954 <alltraps>

80105f1e <vector24>:
.globl vector24
vector24:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $24
80105f20:	6a 18                	push   $0x18
  jmp alltraps
80105f22:	e9 2d fa ff ff       	jmp    80105954 <alltraps>

80105f27 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $25
80105f29:	6a 19                	push   $0x19
  jmp alltraps
80105f2b:	e9 24 fa ff ff       	jmp    80105954 <alltraps>

80105f30 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $26
80105f32:	6a 1a                	push   $0x1a
  jmp alltraps
80105f34:	e9 1b fa ff ff       	jmp    80105954 <alltraps>

80105f39 <vector27>:
.globl vector27
vector27:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $27
80105f3b:	6a 1b                	push   $0x1b
  jmp alltraps
80105f3d:	e9 12 fa ff ff       	jmp    80105954 <alltraps>

80105f42 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $28
80105f44:	6a 1c                	push   $0x1c
  jmp alltraps
80105f46:	e9 09 fa ff ff       	jmp    80105954 <alltraps>

80105f4b <vector29>:
.globl vector29
vector29:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $29
80105f4d:	6a 1d                	push   $0x1d
  jmp alltraps
80105f4f:	e9 00 fa ff ff       	jmp    80105954 <alltraps>

80105f54 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $30
80105f56:	6a 1e                	push   $0x1e
  jmp alltraps
80105f58:	e9 f7 f9 ff ff       	jmp    80105954 <alltraps>

80105f5d <vector31>:
.globl vector31
vector31:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $31
80105f5f:	6a 1f                	push   $0x1f
  jmp alltraps
80105f61:	e9 ee f9 ff ff       	jmp    80105954 <alltraps>

80105f66 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $32
80105f68:	6a 20                	push   $0x20
  jmp alltraps
80105f6a:	e9 e5 f9 ff ff       	jmp    80105954 <alltraps>

80105f6f <vector33>:
.globl vector33
vector33:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $33
80105f71:	6a 21                	push   $0x21
  jmp alltraps
80105f73:	e9 dc f9 ff ff       	jmp    80105954 <alltraps>

80105f78 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $34
80105f7a:	6a 22                	push   $0x22
  jmp alltraps
80105f7c:	e9 d3 f9 ff ff       	jmp    80105954 <alltraps>

80105f81 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $35
80105f83:	6a 23                	push   $0x23
  jmp alltraps
80105f85:	e9 ca f9 ff ff       	jmp    80105954 <alltraps>

80105f8a <vector36>:
.globl vector36
vector36:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $36
80105f8c:	6a 24                	push   $0x24
  jmp alltraps
80105f8e:	e9 c1 f9 ff ff       	jmp    80105954 <alltraps>

80105f93 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $37
80105f95:	6a 25                	push   $0x25
  jmp alltraps
80105f97:	e9 b8 f9 ff ff       	jmp    80105954 <alltraps>

80105f9c <vector38>:
.globl vector38
vector38:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $38
80105f9e:	6a 26                	push   $0x26
  jmp alltraps
80105fa0:	e9 af f9 ff ff       	jmp    80105954 <alltraps>

80105fa5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $39
80105fa7:	6a 27                	push   $0x27
  jmp alltraps
80105fa9:	e9 a6 f9 ff ff       	jmp    80105954 <alltraps>

80105fae <vector40>:
.globl vector40
vector40:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $40
80105fb0:	6a 28                	push   $0x28
  jmp alltraps
80105fb2:	e9 9d f9 ff ff       	jmp    80105954 <alltraps>

80105fb7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $41
80105fb9:	6a 29                	push   $0x29
  jmp alltraps
80105fbb:	e9 94 f9 ff ff       	jmp    80105954 <alltraps>

80105fc0 <vector42>:
.globl vector42
vector42:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $42
80105fc2:	6a 2a                	push   $0x2a
  jmp alltraps
80105fc4:	e9 8b f9 ff ff       	jmp    80105954 <alltraps>

80105fc9 <vector43>:
.globl vector43
vector43:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $43
80105fcb:	6a 2b                	push   $0x2b
  jmp alltraps
80105fcd:	e9 82 f9 ff ff       	jmp    80105954 <alltraps>

80105fd2 <vector44>:
.globl vector44
vector44:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $44
80105fd4:	6a 2c                	push   $0x2c
  jmp alltraps
80105fd6:	e9 79 f9 ff ff       	jmp    80105954 <alltraps>

80105fdb <vector45>:
.globl vector45
vector45:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $45
80105fdd:	6a 2d                	push   $0x2d
  jmp alltraps
80105fdf:	e9 70 f9 ff ff       	jmp    80105954 <alltraps>

80105fe4 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $46
80105fe6:	6a 2e                	push   $0x2e
  jmp alltraps
80105fe8:	e9 67 f9 ff ff       	jmp    80105954 <alltraps>

80105fed <vector47>:
.globl vector47
vector47:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $47
80105fef:	6a 2f                	push   $0x2f
  jmp alltraps
80105ff1:	e9 5e f9 ff ff       	jmp    80105954 <alltraps>

80105ff6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $48
80105ff8:	6a 30                	push   $0x30
  jmp alltraps
80105ffa:	e9 55 f9 ff ff       	jmp    80105954 <alltraps>

80105fff <vector49>:
.globl vector49
vector49:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $49
80106001:	6a 31                	push   $0x31
  jmp alltraps
80106003:	e9 4c f9 ff ff       	jmp    80105954 <alltraps>

80106008 <vector50>:
.globl vector50
vector50:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $50
8010600a:	6a 32                	push   $0x32
  jmp alltraps
8010600c:	e9 43 f9 ff ff       	jmp    80105954 <alltraps>

80106011 <vector51>:
.globl vector51
vector51:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $51
80106013:	6a 33                	push   $0x33
  jmp alltraps
80106015:	e9 3a f9 ff ff       	jmp    80105954 <alltraps>

8010601a <vector52>:
.globl vector52
vector52:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $52
8010601c:	6a 34                	push   $0x34
  jmp alltraps
8010601e:	e9 31 f9 ff ff       	jmp    80105954 <alltraps>

80106023 <vector53>:
.globl vector53
vector53:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $53
80106025:	6a 35                	push   $0x35
  jmp alltraps
80106027:	e9 28 f9 ff ff       	jmp    80105954 <alltraps>

8010602c <vector54>:
.globl vector54
vector54:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $54
8010602e:	6a 36                	push   $0x36
  jmp alltraps
80106030:	e9 1f f9 ff ff       	jmp    80105954 <alltraps>

80106035 <vector55>:
.globl vector55
vector55:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $55
80106037:	6a 37                	push   $0x37
  jmp alltraps
80106039:	e9 16 f9 ff ff       	jmp    80105954 <alltraps>

8010603e <vector56>:
.globl vector56
vector56:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $56
80106040:	6a 38                	push   $0x38
  jmp alltraps
80106042:	e9 0d f9 ff ff       	jmp    80105954 <alltraps>

80106047 <vector57>:
.globl vector57
vector57:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $57
80106049:	6a 39                	push   $0x39
  jmp alltraps
8010604b:	e9 04 f9 ff ff       	jmp    80105954 <alltraps>

80106050 <vector58>:
.globl vector58
vector58:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $58
80106052:	6a 3a                	push   $0x3a
  jmp alltraps
80106054:	e9 fb f8 ff ff       	jmp    80105954 <alltraps>

80106059 <vector59>:
.globl vector59
vector59:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $59
8010605b:	6a 3b                	push   $0x3b
  jmp alltraps
8010605d:	e9 f2 f8 ff ff       	jmp    80105954 <alltraps>

80106062 <vector60>:
.globl vector60
vector60:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $60
80106064:	6a 3c                	push   $0x3c
  jmp alltraps
80106066:	e9 e9 f8 ff ff       	jmp    80105954 <alltraps>

8010606b <vector61>:
.globl vector61
vector61:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $61
8010606d:	6a 3d                	push   $0x3d
  jmp alltraps
8010606f:	e9 e0 f8 ff ff       	jmp    80105954 <alltraps>

80106074 <vector62>:
.globl vector62
vector62:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $62
80106076:	6a 3e                	push   $0x3e
  jmp alltraps
80106078:	e9 d7 f8 ff ff       	jmp    80105954 <alltraps>

8010607d <vector63>:
.globl vector63
vector63:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $63
8010607f:	6a 3f                	push   $0x3f
  jmp alltraps
80106081:	e9 ce f8 ff ff       	jmp    80105954 <alltraps>

80106086 <vector64>:
.globl vector64
vector64:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $64
80106088:	6a 40                	push   $0x40
  jmp alltraps
8010608a:	e9 c5 f8 ff ff       	jmp    80105954 <alltraps>

8010608f <vector65>:
.globl vector65
vector65:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $65
80106091:	6a 41                	push   $0x41
  jmp alltraps
80106093:	e9 bc f8 ff ff       	jmp    80105954 <alltraps>

80106098 <vector66>:
.globl vector66
vector66:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $66
8010609a:	6a 42                	push   $0x42
  jmp alltraps
8010609c:	e9 b3 f8 ff ff       	jmp    80105954 <alltraps>

801060a1 <vector67>:
.globl vector67
vector67:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $67
801060a3:	6a 43                	push   $0x43
  jmp alltraps
801060a5:	e9 aa f8 ff ff       	jmp    80105954 <alltraps>

801060aa <vector68>:
.globl vector68
vector68:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $68
801060ac:	6a 44                	push   $0x44
  jmp alltraps
801060ae:	e9 a1 f8 ff ff       	jmp    80105954 <alltraps>

801060b3 <vector69>:
.globl vector69
vector69:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $69
801060b5:	6a 45                	push   $0x45
  jmp alltraps
801060b7:	e9 98 f8 ff ff       	jmp    80105954 <alltraps>

801060bc <vector70>:
.globl vector70
vector70:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $70
801060be:	6a 46                	push   $0x46
  jmp alltraps
801060c0:	e9 8f f8 ff ff       	jmp    80105954 <alltraps>

801060c5 <vector71>:
.globl vector71
vector71:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $71
801060c7:	6a 47                	push   $0x47
  jmp alltraps
801060c9:	e9 86 f8 ff ff       	jmp    80105954 <alltraps>

801060ce <vector72>:
.globl vector72
vector72:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $72
801060d0:	6a 48                	push   $0x48
  jmp alltraps
801060d2:	e9 7d f8 ff ff       	jmp    80105954 <alltraps>

801060d7 <vector73>:
.globl vector73
vector73:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $73
801060d9:	6a 49                	push   $0x49
  jmp alltraps
801060db:	e9 74 f8 ff ff       	jmp    80105954 <alltraps>

801060e0 <vector74>:
.globl vector74
vector74:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $74
801060e2:	6a 4a                	push   $0x4a
  jmp alltraps
801060e4:	e9 6b f8 ff ff       	jmp    80105954 <alltraps>

801060e9 <vector75>:
.globl vector75
vector75:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $75
801060eb:	6a 4b                	push   $0x4b
  jmp alltraps
801060ed:	e9 62 f8 ff ff       	jmp    80105954 <alltraps>

801060f2 <vector76>:
.globl vector76
vector76:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $76
801060f4:	6a 4c                	push   $0x4c
  jmp alltraps
801060f6:	e9 59 f8 ff ff       	jmp    80105954 <alltraps>

801060fb <vector77>:
.globl vector77
vector77:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $77
801060fd:	6a 4d                	push   $0x4d
  jmp alltraps
801060ff:	e9 50 f8 ff ff       	jmp    80105954 <alltraps>

80106104 <vector78>:
.globl vector78
vector78:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $78
80106106:	6a 4e                	push   $0x4e
  jmp alltraps
80106108:	e9 47 f8 ff ff       	jmp    80105954 <alltraps>

8010610d <vector79>:
.globl vector79
vector79:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $79
8010610f:	6a 4f                	push   $0x4f
  jmp alltraps
80106111:	e9 3e f8 ff ff       	jmp    80105954 <alltraps>

80106116 <vector80>:
.globl vector80
vector80:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $80
80106118:	6a 50                	push   $0x50
  jmp alltraps
8010611a:	e9 35 f8 ff ff       	jmp    80105954 <alltraps>

8010611f <vector81>:
.globl vector81
vector81:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $81
80106121:	6a 51                	push   $0x51
  jmp alltraps
80106123:	e9 2c f8 ff ff       	jmp    80105954 <alltraps>

80106128 <vector82>:
.globl vector82
vector82:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $82
8010612a:	6a 52                	push   $0x52
  jmp alltraps
8010612c:	e9 23 f8 ff ff       	jmp    80105954 <alltraps>

80106131 <vector83>:
.globl vector83
vector83:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $83
80106133:	6a 53                	push   $0x53
  jmp alltraps
80106135:	e9 1a f8 ff ff       	jmp    80105954 <alltraps>

8010613a <vector84>:
.globl vector84
vector84:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $84
8010613c:	6a 54                	push   $0x54
  jmp alltraps
8010613e:	e9 11 f8 ff ff       	jmp    80105954 <alltraps>

80106143 <vector85>:
.globl vector85
vector85:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $85
80106145:	6a 55                	push   $0x55
  jmp alltraps
80106147:	e9 08 f8 ff ff       	jmp    80105954 <alltraps>

8010614c <vector86>:
.globl vector86
vector86:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $86
8010614e:	6a 56                	push   $0x56
  jmp alltraps
80106150:	e9 ff f7 ff ff       	jmp    80105954 <alltraps>

80106155 <vector87>:
.globl vector87
vector87:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $87
80106157:	6a 57                	push   $0x57
  jmp alltraps
80106159:	e9 f6 f7 ff ff       	jmp    80105954 <alltraps>

8010615e <vector88>:
.globl vector88
vector88:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $88
80106160:	6a 58                	push   $0x58
  jmp alltraps
80106162:	e9 ed f7 ff ff       	jmp    80105954 <alltraps>

80106167 <vector89>:
.globl vector89
vector89:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $89
80106169:	6a 59                	push   $0x59
  jmp alltraps
8010616b:	e9 e4 f7 ff ff       	jmp    80105954 <alltraps>

80106170 <vector90>:
.globl vector90
vector90:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $90
80106172:	6a 5a                	push   $0x5a
  jmp alltraps
80106174:	e9 db f7 ff ff       	jmp    80105954 <alltraps>

80106179 <vector91>:
.globl vector91
vector91:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $91
8010617b:	6a 5b                	push   $0x5b
  jmp alltraps
8010617d:	e9 d2 f7 ff ff       	jmp    80105954 <alltraps>

80106182 <vector92>:
.globl vector92
vector92:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $92
80106184:	6a 5c                	push   $0x5c
  jmp alltraps
80106186:	e9 c9 f7 ff ff       	jmp    80105954 <alltraps>

8010618b <vector93>:
.globl vector93
vector93:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $93
8010618d:	6a 5d                	push   $0x5d
  jmp alltraps
8010618f:	e9 c0 f7 ff ff       	jmp    80105954 <alltraps>

80106194 <vector94>:
.globl vector94
vector94:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $94
80106196:	6a 5e                	push   $0x5e
  jmp alltraps
80106198:	e9 b7 f7 ff ff       	jmp    80105954 <alltraps>

8010619d <vector95>:
.globl vector95
vector95:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $95
8010619f:	6a 5f                	push   $0x5f
  jmp alltraps
801061a1:	e9 ae f7 ff ff       	jmp    80105954 <alltraps>

801061a6 <vector96>:
.globl vector96
vector96:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $96
801061a8:	6a 60                	push   $0x60
  jmp alltraps
801061aa:	e9 a5 f7 ff ff       	jmp    80105954 <alltraps>

801061af <vector97>:
.globl vector97
vector97:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $97
801061b1:	6a 61                	push   $0x61
  jmp alltraps
801061b3:	e9 9c f7 ff ff       	jmp    80105954 <alltraps>

801061b8 <vector98>:
.globl vector98
vector98:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $98
801061ba:	6a 62                	push   $0x62
  jmp alltraps
801061bc:	e9 93 f7 ff ff       	jmp    80105954 <alltraps>

801061c1 <vector99>:
.globl vector99
vector99:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $99
801061c3:	6a 63                	push   $0x63
  jmp alltraps
801061c5:	e9 8a f7 ff ff       	jmp    80105954 <alltraps>

801061ca <vector100>:
.globl vector100
vector100:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $100
801061cc:	6a 64                	push   $0x64
  jmp alltraps
801061ce:	e9 81 f7 ff ff       	jmp    80105954 <alltraps>

801061d3 <vector101>:
.globl vector101
vector101:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $101
801061d5:	6a 65                	push   $0x65
  jmp alltraps
801061d7:	e9 78 f7 ff ff       	jmp    80105954 <alltraps>

801061dc <vector102>:
.globl vector102
vector102:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $102
801061de:	6a 66                	push   $0x66
  jmp alltraps
801061e0:	e9 6f f7 ff ff       	jmp    80105954 <alltraps>

801061e5 <vector103>:
.globl vector103
vector103:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $103
801061e7:	6a 67                	push   $0x67
  jmp alltraps
801061e9:	e9 66 f7 ff ff       	jmp    80105954 <alltraps>

801061ee <vector104>:
.globl vector104
vector104:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $104
801061f0:	6a 68                	push   $0x68
  jmp alltraps
801061f2:	e9 5d f7 ff ff       	jmp    80105954 <alltraps>

801061f7 <vector105>:
.globl vector105
vector105:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $105
801061f9:	6a 69                	push   $0x69
  jmp alltraps
801061fb:	e9 54 f7 ff ff       	jmp    80105954 <alltraps>

80106200 <vector106>:
.globl vector106
vector106:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $106
80106202:	6a 6a                	push   $0x6a
  jmp alltraps
80106204:	e9 4b f7 ff ff       	jmp    80105954 <alltraps>

80106209 <vector107>:
.globl vector107
vector107:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $107
8010620b:	6a 6b                	push   $0x6b
  jmp alltraps
8010620d:	e9 42 f7 ff ff       	jmp    80105954 <alltraps>

80106212 <vector108>:
.globl vector108
vector108:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $108
80106214:	6a 6c                	push   $0x6c
  jmp alltraps
80106216:	e9 39 f7 ff ff       	jmp    80105954 <alltraps>

8010621b <vector109>:
.globl vector109
vector109:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $109
8010621d:	6a 6d                	push   $0x6d
  jmp alltraps
8010621f:	e9 30 f7 ff ff       	jmp    80105954 <alltraps>

80106224 <vector110>:
.globl vector110
vector110:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $110
80106226:	6a 6e                	push   $0x6e
  jmp alltraps
80106228:	e9 27 f7 ff ff       	jmp    80105954 <alltraps>

8010622d <vector111>:
.globl vector111
vector111:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $111
8010622f:	6a 6f                	push   $0x6f
  jmp alltraps
80106231:	e9 1e f7 ff ff       	jmp    80105954 <alltraps>

80106236 <vector112>:
.globl vector112
vector112:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $112
80106238:	6a 70                	push   $0x70
  jmp alltraps
8010623a:	e9 15 f7 ff ff       	jmp    80105954 <alltraps>

8010623f <vector113>:
.globl vector113
vector113:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $113
80106241:	6a 71                	push   $0x71
  jmp alltraps
80106243:	e9 0c f7 ff ff       	jmp    80105954 <alltraps>

80106248 <vector114>:
.globl vector114
vector114:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $114
8010624a:	6a 72                	push   $0x72
  jmp alltraps
8010624c:	e9 03 f7 ff ff       	jmp    80105954 <alltraps>

80106251 <vector115>:
.globl vector115
vector115:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $115
80106253:	6a 73                	push   $0x73
  jmp alltraps
80106255:	e9 fa f6 ff ff       	jmp    80105954 <alltraps>

8010625a <vector116>:
.globl vector116
vector116:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $116
8010625c:	6a 74                	push   $0x74
  jmp alltraps
8010625e:	e9 f1 f6 ff ff       	jmp    80105954 <alltraps>

80106263 <vector117>:
.globl vector117
vector117:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $117
80106265:	6a 75                	push   $0x75
  jmp alltraps
80106267:	e9 e8 f6 ff ff       	jmp    80105954 <alltraps>

8010626c <vector118>:
.globl vector118
vector118:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $118
8010626e:	6a 76                	push   $0x76
  jmp alltraps
80106270:	e9 df f6 ff ff       	jmp    80105954 <alltraps>

80106275 <vector119>:
.globl vector119
vector119:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $119
80106277:	6a 77                	push   $0x77
  jmp alltraps
80106279:	e9 d6 f6 ff ff       	jmp    80105954 <alltraps>

8010627e <vector120>:
.globl vector120
vector120:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $120
80106280:	6a 78                	push   $0x78
  jmp alltraps
80106282:	e9 cd f6 ff ff       	jmp    80105954 <alltraps>

80106287 <vector121>:
.globl vector121
vector121:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $121
80106289:	6a 79                	push   $0x79
  jmp alltraps
8010628b:	e9 c4 f6 ff ff       	jmp    80105954 <alltraps>

80106290 <vector122>:
.globl vector122
vector122:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $122
80106292:	6a 7a                	push   $0x7a
  jmp alltraps
80106294:	e9 bb f6 ff ff       	jmp    80105954 <alltraps>

80106299 <vector123>:
.globl vector123
vector123:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $123
8010629b:	6a 7b                	push   $0x7b
  jmp alltraps
8010629d:	e9 b2 f6 ff ff       	jmp    80105954 <alltraps>

801062a2 <vector124>:
.globl vector124
vector124:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $124
801062a4:	6a 7c                	push   $0x7c
  jmp alltraps
801062a6:	e9 a9 f6 ff ff       	jmp    80105954 <alltraps>

801062ab <vector125>:
.globl vector125
vector125:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $125
801062ad:	6a 7d                	push   $0x7d
  jmp alltraps
801062af:	e9 a0 f6 ff ff       	jmp    80105954 <alltraps>

801062b4 <vector126>:
.globl vector126
vector126:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $126
801062b6:	6a 7e                	push   $0x7e
  jmp alltraps
801062b8:	e9 97 f6 ff ff       	jmp    80105954 <alltraps>

801062bd <vector127>:
.globl vector127
vector127:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $127
801062bf:	6a 7f                	push   $0x7f
  jmp alltraps
801062c1:	e9 8e f6 ff ff       	jmp    80105954 <alltraps>

801062c6 <vector128>:
.globl vector128
vector128:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $128
801062c8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801062cd:	e9 82 f6 ff ff       	jmp    80105954 <alltraps>

801062d2 <vector129>:
.globl vector129
vector129:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $129
801062d4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801062d9:	e9 76 f6 ff ff       	jmp    80105954 <alltraps>

801062de <vector130>:
.globl vector130
vector130:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $130
801062e0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062e5:	e9 6a f6 ff ff       	jmp    80105954 <alltraps>

801062ea <vector131>:
.globl vector131
vector131:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $131
801062ec:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062f1:	e9 5e f6 ff ff       	jmp    80105954 <alltraps>

801062f6 <vector132>:
.globl vector132
vector132:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $132
801062f8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062fd:	e9 52 f6 ff ff       	jmp    80105954 <alltraps>

80106302 <vector133>:
.globl vector133
vector133:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $133
80106304:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106309:	e9 46 f6 ff ff       	jmp    80105954 <alltraps>

8010630e <vector134>:
.globl vector134
vector134:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $134
80106310:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106315:	e9 3a f6 ff ff       	jmp    80105954 <alltraps>

8010631a <vector135>:
.globl vector135
vector135:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $135
8010631c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106321:	e9 2e f6 ff ff       	jmp    80105954 <alltraps>

80106326 <vector136>:
.globl vector136
vector136:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $136
80106328:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010632d:	e9 22 f6 ff ff       	jmp    80105954 <alltraps>

80106332 <vector137>:
.globl vector137
vector137:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $137
80106334:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106339:	e9 16 f6 ff ff       	jmp    80105954 <alltraps>

8010633e <vector138>:
.globl vector138
vector138:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $138
80106340:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106345:	e9 0a f6 ff ff       	jmp    80105954 <alltraps>

8010634a <vector139>:
.globl vector139
vector139:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $139
8010634c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106351:	e9 fe f5 ff ff       	jmp    80105954 <alltraps>

80106356 <vector140>:
.globl vector140
vector140:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $140
80106358:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010635d:	e9 f2 f5 ff ff       	jmp    80105954 <alltraps>

80106362 <vector141>:
.globl vector141
vector141:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $141
80106364:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106369:	e9 e6 f5 ff ff       	jmp    80105954 <alltraps>

8010636e <vector142>:
.globl vector142
vector142:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $142
80106370:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106375:	e9 da f5 ff ff       	jmp    80105954 <alltraps>

8010637a <vector143>:
.globl vector143
vector143:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $143
8010637c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106381:	e9 ce f5 ff ff       	jmp    80105954 <alltraps>

80106386 <vector144>:
.globl vector144
vector144:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $144
80106388:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010638d:	e9 c2 f5 ff ff       	jmp    80105954 <alltraps>

80106392 <vector145>:
.globl vector145
vector145:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $145
80106394:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106399:	e9 b6 f5 ff ff       	jmp    80105954 <alltraps>

8010639e <vector146>:
.globl vector146
vector146:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $146
801063a0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801063a5:	e9 aa f5 ff ff       	jmp    80105954 <alltraps>

801063aa <vector147>:
.globl vector147
vector147:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $147
801063ac:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801063b1:	e9 9e f5 ff ff       	jmp    80105954 <alltraps>

801063b6 <vector148>:
.globl vector148
vector148:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $148
801063b8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801063bd:	e9 92 f5 ff ff       	jmp    80105954 <alltraps>

801063c2 <vector149>:
.globl vector149
vector149:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $149
801063c4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801063c9:	e9 86 f5 ff ff       	jmp    80105954 <alltraps>

801063ce <vector150>:
.globl vector150
vector150:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $150
801063d0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801063d5:	e9 7a f5 ff ff       	jmp    80105954 <alltraps>

801063da <vector151>:
.globl vector151
vector151:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $151
801063dc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063e1:	e9 6e f5 ff ff       	jmp    80105954 <alltraps>

801063e6 <vector152>:
.globl vector152
vector152:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $152
801063e8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063ed:	e9 62 f5 ff ff       	jmp    80105954 <alltraps>

801063f2 <vector153>:
.globl vector153
vector153:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $153
801063f4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063f9:	e9 56 f5 ff ff       	jmp    80105954 <alltraps>

801063fe <vector154>:
.globl vector154
vector154:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $154
80106400:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106405:	e9 4a f5 ff ff       	jmp    80105954 <alltraps>

8010640a <vector155>:
.globl vector155
vector155:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $155
8010640c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106411:	e9 3e f5 ff ff       	jmp    80105954 <alltraps>

80106416 <vector156>:
.globl vector156
vector156:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $156
80106418:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010641d:	e9 32 f5 ff ff       	jmp    80105954 <alltraps>

80106422 <vector157>:
.globl vector157
vector157:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $157
80106424:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106429:	e9 26 f5 ff ff       	jmp    80105954 <alltraps>

8010642e <vector158>:
.globl vector158
vector158:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $158
80106430:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106435:	e9 1a f5 ff ff       	jmp    80105954 <alltraps>

8010643a <vector159>:
.globl vector159
vector159:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $159
8010643c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106441:	e9 0e f5 ff ff       	jmp    80105954 <alltraps>

80106446 <vector160>:
.globl vector160
vector160:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $160
80106448:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010644d:	e9 02 f5 ff ff       	jmp    80105954 <alltraps>

80106452 <vector161>:
.globl vector161
vector161:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $161
80106454:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106459:	e9 f6 f4 ff ff       	jmp    80105954 <alltraps>

8010645e <vector162>:
.globl vector162
vector162:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $162
80106460:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106465:	e9 ea f4 ff ff       	jmp    80105954 <alltraps>

8010646a <vector163>:
.globl vector163
vector163:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $163
8010646c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106471:	e9 de f4 ff ff       	jmp    80105954 <alltraps>

80106476 <vector164>:
.globl vector164
vector164:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $164
80106478:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010647d:	e9 d2 f4 ff ff       	jmp    80105954 <alltraps>

80106482 <vector165>:
.globl vector165
vector165:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $165
80106484:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106489:	e9 c6 f4 ff ff       	jmp    80105954 <alltraps>

8010648e <vector166>:
.globl vector166
vector166:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $166
80106490:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106495:	e9 ba f4 ff ff       	jmp    80105954 <alltraps>

8010649a <vector167>:
.globl vector167
vector167:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $167
8010649c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801064a1:	e9 ae f4 ff ff       	jmp    80105954 <alltraps>

801064a6 <vector168>:
.globl vector168
vector168:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $168
801064a8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801064ad:	e9 a2 f4 ff ff       	jmp    80105954 <alltraps>

801064b2 <vector169>:
.globl vector169
vector169:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $169
801064b4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801064b9:	e9 96 f4 ff ff       	jmp    80105954 <alltraps>

801064be <vector170>:
.globl vector170
vector170:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $170
801064c0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801064c5:	e9 8a f4 ff ff       	jmp    80105954 <alltraps>

801064ca <vector171>:
.globl vector171
vector171:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $171
801064cc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801064d1:	e9 7e f4 ff ff       	jmp    80105954 <alltraps>

801064d6 <vector172>:
.globl vector172
vector172:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $172
801064d8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064dd:	e9 72 f4 ff ff       	jmp    80105954 <alltraps>

801064e2 <vector173>:
.globl vector173
vector173:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $173
801064e4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064e9:	e9 66 f4 ff ff       	jmp    80105954 <alltraps>

801064ee <vector174>:
.globl vector174
vector174:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $174
801064f0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064f5:	e9 5a f4 ff ff       	jmp    80105954 <alltraps>

801064fa <vector175>:
.globl vector175
vector175:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $175
801064fc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106501:	e9 4e f4 ff ff       	jmp    80105954 <alltraps>

80106506 <vector176>:
.globl vector176
vector176:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $176
80106508:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010650d:	e9 42 f4 ff ff       	jmp    80105954 <alltraps>

80106512 <vector177>:
.globl vector177
vector177:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $177
80106514:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106519:	e9 36 f4 ff ff       	jmp    80105954 <alltraps>

8010651e <vector178>:
.globl vector178
vector178:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $178
80106520:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106525:	e9 2a f4 ff ff       	jmp    80105954 <alltraps>

8010652a <vector179>:
.globl vector179
vector179:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $179
8010652c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106531:	e9 1e f4 ff ff       	jmp    80105954 <alltraps>

80106536 <vector180>:
.globl vector180
vector180:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $180
80106538:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010653d:	e9 12 f4 ff ff       	jmp    80105954 <alltraps>

80106542 <vector181>:
.globl vector181
vector181:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $181
80106544:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106549:	e9 06 f4 ff ff       	jmp    80105954 <alltraps>

8010654e <vector182>:
.globl vector182
vector182:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $182
80106550:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106555:	e9 fa f3 ff ff       	jmp    80105954 <alltraps>

8010655a <vector183>:
.globl vector183
vector183:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $183
8010655c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106561:	e9 ee f3 ff ff       	jmp    80105954 <alltraps>

80106566 <vector184>:
.globl vector184
vector184:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $184
80106568:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010656d:	e9 e2 f3 ff ff       	jmp    80105954 <alltraps>

80106572 <vector185>:
.globl vector185
vector185:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $185
80106574:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106579:	e9 d6 f3 ff ff       	jmp    80105954 <alltraps>

8010657e <vector186>:
.globl vector186
vector186:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $186
80106580:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106585:	e9 ca f3 ff ff       	jmp    80105954 <alltraps>

8010658a <vector187>:
.globl vector187
vector187:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $187
8010658c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106591:	e9 be f3 ff ff       	jmp    80105954 <alltraps>

80106596 <vector188>:
.globl vector188
vector188:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $188
80106598:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010659d:	e9 b2 f3 ff ff       	jmp    80105954 <alltraps>

801065a2 <vector189>:
.globl vector189
vector189:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $189
801065a4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801065a9:	e9 a6 f3 ff ff       	jmp    80105954 <alltraps>

801065ae <vector190>:
.globl vector190
vector190:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $190
801065b0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801065b5:	e9 9a f3 ff ff       	jmp    80105954 <alltraps>

801065ba <vector191>:
.globl vector191
vector191:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $191
801065bc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801065c1:	e9 8e f3 ff ff       	jmp    80105954 <alltraps>

801065c6 <vector192>:
.globl vector192
vector192:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $192
801065c8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801065cd:	e9 82 f3 ff ff       	jmp    80105954 <alltraps>

801065d2 <vector193>:
.globl vector193
vector193:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $193
801065d4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801065d9:	e9 76 f3 ff ff       	jmp    80105954 <alltraps>

801065de <vector194>:
.globl vector194
vector194:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $194
801065e0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065e5:	e9 6a f3 ff ff       	jmp    80105954 <alltraps>

801065ea <vector195>:
.globl vector195
vector195:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $195
801065ec:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065f1:	e9 5e f3 ff ff       	jmp    80105954 <alltraps>

801065f6 <vector196>:
.globl vector196
vector196:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $196
801065f8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065fd:	e9 52 f3 ff ff       	jmp    80105954 <alltraps>

80106602 <vector197>:
.globl vector197
vector197:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $197
80106604:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106609:	e9 46 f3 ff ff       	jmp    80105954 <alltraps>

8010660e <vector198>:
.globl vector198
vector198:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $198
80106610:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106615:	e9 3a f3 ff ff       	jmp    80105954 <alltraps>

8010661a <vector199>:
.globl vector199
vector199:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $199
8010661c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106621:	e9 2e f3 ff ff       	jmp    80105954 <alltraps>

80106626 <vector200>:
.globl vector200
vector200:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $200
80106628:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010662d:	e9 22 f3 ff ff       	jmp    80105954 <alltraps>

80106632 <vector201>:
.globl vector201
vector201:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $201
80106634:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106639:	e9 16 f3 ff ff       	jmp    80105954 <alltraps>

8010663e <vector202>:
.globl vector202
vector202:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $202
80106640:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106645:	e9 0a f3 ff ff       	jmp    80105954 <alltraps>

8010664a <vector203>:
.globl vector203
vector203:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $203
8010664c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106651:	e9 fe f2 ff ff       	jmp    80105954 <alltraps>

80106656 <vector204>:
.globl vector204
vector204:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $204
80106658:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010665d:	e9 f2 f2 ff ff       	jmp    80105954 <alltraps>

80106662 <vector205>:
.globl vector205
vector205:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $205
80106664:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106669:	e9 e6 f2 ff ff       	jmp    80105954 <alltraps>

8010666e <vector206>:
.globl vector206
vector206:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $206
80106670:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106675:	e9 da f2 ff ff       	jmp    80105954 <alltraps>

8010667a <vector207>:
.globl vector207
vector207:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $207
8010667c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106681:	e9 ce f2 ff ff       	jmp    80105954 <alltraps>

80106686 <vector208>:
.globl vector208
vector208:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $208
80106688:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010668d:	e9 c2 f2 ff ff       	jmp    80105954 <alltraps>

80106692 <vector209>:
.globl vector209
vector209:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $209
80106694:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106699:	e9 b6 f2 ff ff       	jmp    80105954 <alltraps>

8010669e <vector210>:
.globl vector210
vector210:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $210
801066a0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801066a5:	e9 aa f2 ff ff       	jmp    80105954 <alltraps>

801066aa <vector211>:
.globl vector211
vector211:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $211
801066ac:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801066b1:	e9 9e f2 ff ff       	jmp    80105954 <alltraps>

801066b6 <vector212>:
.globl vector212
vector212:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $212
801066b8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801066bd:	e9 92 f2 ff ff       	jmp    80105954 <alltraps>

801066c2 <vector213>:
.globl vector213
vector213:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $213
801066c4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801066c9:	e9 86 f2 ff ff       	jmp    80105954 <alltraps>

801066ce <vector214>:
.globl vector214
vector214:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $214
801066d0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801066d5:	e9 7a f2 ff ff       	jmp    80105954 <alltraps>

801066da <vector215>:
.globl vector215
vector215:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $215
801066dc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066e1:	e9 6e f2 ff ff       	jmp    80105954 <alltraps>

801066e6 <vector216>:
.globl vector216
vector216:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $216
801066e8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066ed:	e9 62 f2 ff ff       	jmp    80105954 <alltraps>

801066f2 <vector217>:
.globl vector217
vector217:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $217
801066f4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066f9:	e9 56 f2 ff ff       	jmp    80105954 <alltraps>

801066fe <vector218>:
.globl vector218
vector218:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $218
80106700:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106705:	e9 4a f2 ff ff       	jmp    80105954 <alltraps>

8010670a <vector219>:
.globl vector219
vector219:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $219
8010670c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106711:	e9 3e f2 ff ff       	jmp    80105954 <alltraps>

80106716 <vector220>:
.globl vector220
vector220:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $220
80106718:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010671d:	e9 32 f2 ff ff       	jmp    80105954 <alltraps>

80106722 <vector221>:
.globl vector221
vector221:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $221
80106724:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106729:	e9 26 f2 ff ff       	jmp    80105954 <alltraps>

8010672e <vector222>:
.globl vector222
vector222:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $222
80106730:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106735:	e9 1a f2 ff ff       	jmp    80105954 <alltraps>

8010673a <vector223>:
.globl vector223
vector223:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $223
8010673c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106741:	e9 0e f2 ff ff       	jmp    80105954 <alltraps>

80106746 <vector224>:
.globl vector224
vector224:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $224
80106748:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010674d:	e9 02 f2 ff ff       	jmp    80105954 <alltraps>

80106752 <vector225>:
.globl vector225
vector225:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $225
80106754:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106759:	e9 f6 f1 ff ff       	jmp    80105954 <alltraps>

8010675e <vector226>:
.globl vector226
vector226:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $226
80106760:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106765:	e9 ea f1 ff ff       	jmp    80105954 <alltraps>

8010676a <vector227>:
.globl vector227
vector227:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $227
8010676c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106771:	e9 de f1 ff ff       	jmp    80105954 <alltraps>

80106776 <vector228>:
.globl vector228
vector228:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $228
80106778:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010677d:	e9 d2 f1 ff ff       	jmp    80105954 <alltraps>

80106782 <vector229>:
.globl vector229
vector229:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $229
80106784:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106789:	e9 c6 f1 ff ff       	jmp    80105954 <alltraps>

8010678e <vector230>:
.globl vector230
vector230:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $230
80106790:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106795:	e9 ba f1 ff ff       	jmp    80105954 <alltraps>

8010679a <vector231>:
.globl vector231
vector231:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $231
8010679c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801067a1:	e9 ae f1 ff ff       	jmp    80105954 <alltraps>

801067a6 <vector232>:
.globl vector232
vector232:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $232
801067a8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801067ad:	e9 a2 f1 ff ff       	jmp    80105954 <alltraps>

801067b2 <vector233>:
.globl vector233
vector233:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $233
801067b4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801067b9:	e9 96 f1 ff ff       	jmp    80105954 <alltraps>

801067be <vector234>:
.globl vector234
vector234:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $234
801067c0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801067c5:	e9 8a f1 ff ff       	jmp    80105954 <alltraps>

801067ca <vector235>:
.globl vector235
vector235:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $235
801067cc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801067d1:	e9 7e f1 ff ff       	jmp    80105954 <alltraps>

801067d6 <vector236>:
.globl vector236
vector236:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $236
801067d8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067dd:	e9 72 f1 ff ff       	jmp    80105954 <alltraps>

801067e2 <vector237>:
.globl vector237
vector237:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $237
801067e4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067e9:	e9 66 f1 ff ff       	jmp    80105954 <alltraps>

801067ee <vector238>:
.globl vector238
vector238:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $238
801067f0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067f5:	e9 5a f1 ff ff       	jmp    80105954 <alltraps>

801067fa <vector239>:
.globl vector239
vector239:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $239
801067fc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106801:	e9 4e f1 ff ff       	jmp    80105954 <alltraps>

80106806 <vector240>:
.globl vector240
vector240:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $240
80106808:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010680d:	e9 42 f1 ff ff       	jmp    80105954 <alltraps>

80106812 <vector241>:
.globl vector241
vector241:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $241
80106814:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106819:	e9 36 f1 ff ff       	jmp    80105954 <alltraps>

8010681e <vector242>:
.globl vector242
vector242:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $242
80106820:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106825:	e9 2a f1 ff ff       	jmp    80105954 <alltraps>

8010682a <vector243>:
.globl vector243
vector243:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $243
8010682c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106831:	e9 1e f1 ff ff       	jmp    80105954 <alltraps>

80106836 <vector244>:
.globl vector244
vector244:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $244
80106838:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010683d:	e9 12 f1 ff ff       	jmp    80105954 <alltraps>

80106842 <vector245>:
.globl vector245
vector245:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $245
80106844:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106849:	e9 06 f1 ff ff       	jmp    80105954 <alltraps>

8010684e <vector246>:
.globl vector246
vector246:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $246
80106850:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106855:	e9 fa f0 ff ff       	jmp    80105954 <alltraps>

8010685a <vector247>:
.globl vector247
vector247:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $247
8010685c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106861:	e9 ee f0 ff ff       	jmp    80105954 <alltraps>

80106866 <vector248>:
.globl vector248
vector248:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $248
80106868:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010686d:	e9 e2 f0 ff ff       	jmp    80105954 <alltraps>

80106872 <vector249>:
.globl vector249
vector249:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $249
80106874:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106879:	e9 d6 f0 ff ff       	jmp    80105954 <alltraps>

8010687e <vector250>:
.globl vector250
vector250:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $250
80106880:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106885:	e9 ca f0 ff ff       	jmp    80105954 <alltraps>

8010688a <vector251>:
.globl vector251
vector251:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $251
8010688c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106891:	e9 be f0 ff ff       	jmp    80105954 <alltraps>

80106896 <vector252>:
.globl vector252
vector252:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $252
80106898:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010689d:	e9 b2 f0 ff ff       	jmp    80105954 <alltraps>

801068a2 <vector253>:
.globl vector253
vector253:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $253
801068a4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801068a9:	e9 a6 f0 ff ff       	jmp    80105954 <alltraps>

801068ae <vector254>:
.globl vector254
vector254:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $254
801068b0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801068b5:	e9 9a f0 ff ff       	jmp    80105954 <alltraps>

801068ba <vector255>:
.globl vector255
vector255:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $255
801068bc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801068c1:	e9 8e f0 ff ff       	jmp    80105954 <alltraps>
801068c6:	66 90                	xchg   %ax,%ax
801068c8:	66 90                	xchg   %ax,%ax
801068ca:	66 90                	xchg   %ax,%ax
801068cc:	66 90                	xchg   %ax,%ax
801068ce:	66 90                	xchg   %ax,%ax

801068d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	83 ec 28             	sub    $0x28,%esp
801068d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
801068d9:	89 d6                	mov    %edx,%esi
801068db:	89 7d fc             	mov    %edi,-0x4(%ebp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801068de:	c1 ea 16             	shr    $0x16,%edx
{
801068e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  pde = &pgdir[PDX(va)];
801068e4:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
801068e7:	8b 1f                	mov    (%edi),%ebx
801068e9:	f6 c3 01             	test   $0x1,%bl
801068ec:	74 32                	je     80106920 <walkpgdir+0x50>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801068f4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801068fa:	89 f0                	mov    %esi,%eax
}
801068fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  return &pgtab[PTX(va)];
801068ff:	c1 e8 0a             	shr    $0xa,%eax
}
80106902:	8b 75 f8             	mov    -0x8(%ebp),%esi
  return &pgtab[PTX(va)];
80106905:	25 fc 0f 00 00       	and    $0xffc,%eax
8010690a:	01 d8                	add    %ebx,%eax
}
8010690c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010690f:	89 ec                	mov    %ebp,%esp
80106911:	5d                   	pop    %ebp
80106912:	c3                   	ret    
80106913:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010691a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106920:	85 c9                	test   %ecx,%ecx
80106922:	74 3c                	je     80106960 <walkpgdir+0x90>
80106924:	e8 17 be ff ff       	call   80102740 <kalloc>
80106929:	85 c0                	test   %eax,%eax
8010692b:	89 c3                	mov    %eax,%ebx
8010692d:	74 31                	je     80106960 <walkpgdir+0x90>
    memset(pgtab, 0, PGSIZE);
8010692f:	89 1c 24             	mov    %ebx,(%esp)
80106932:	b8 00 10 00 00       	mov    $0x1000,%eax
80106937:	31 d2                	xor    %edx,%edx
80106939:	89 44 24 08          	mov    %eax,0x8(%esp)
8010693d:	89 54 24 04          	mov    %edx,0x4(%esp)
80106941:	e8 4a de ff ff       	call   80104790 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106946:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010694c:	83 c8 07             	or     $0x7,%eax
8010694f:	89 07                	mov    %eax,(%edi)
80106951:	eb a7                	jmp    801068fa <walkpgdir+0x2a>
80106953:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010695a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106960:	8b 5d f4             	mov    -0xc(%ebp),%ebx
      return 0;
80106963:	31 c0                	xor    %eax,%eax
}
80106965:	8b 75 f8             	mov    -0x8(%ebp),%esi
80106968:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010696b:	89 ec                	mov    %ebp,%esp
8010696d:	5d                   	pop    %ebp
8010696e:	c3                   	ret    
8010696f:	90                   	nop

80106970 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	89 c7                	mov    %eax,%edi
80106976:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106977:	89 d6                	mov    %edx,%esi
{
80106979:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
8010697a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106980:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106984:	83 ec 2c             	sub    $0x2c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106987:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010698c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010698f:	8b 45 08             	mov    0x8(%ebp),%eax
80106992:	29 f0                	sub    %esi,%eax
80106994:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106997:	eb 21                	jmp    801069ba <mappages+0x4a>
80106999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801069a0:	f6 00 01             	testb  $0x1,(%eax)
801069a3:	75 45                	jne    801069ea <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801069a5:	8b 55 0c             	mov    0xc(%ebp),%edx
801069a8:	09 d3                	or     %edx,%ebx
801069aa:	83 cb 01             	or     $0x1,%ebx
    if(a == last)
801069ad:	3b 75 e0             	cmp    -0x20(%ebp),%esi
    *pte = pa | perm | PTE_P;
801069b0:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801069b2:	74 2c                	je     801069e0 <mappages+0x70>
      break;
    a += PGSIZE;
801069b4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801069ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801069bd:	b9 01 00 00 00       	mov    $0x1,%ecx
801069c2:	89 f2                	mov    %esi,%edx
801069c4:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801069c7:	89 f8                	mov    %edi,%eax
801069c9:	e8 02 ff ff ff       	call   801068d0 <walkpgdir>
801069ce:	85 c0                	test   %eax,%eax
801069d0:	75 ce                	jne    801069a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801069d2:	83 c4 2c             	add    $0x2c,%esp
      return -1;
801069d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069da:	5b                   	pop    %ebx
801069db:	5e                   	pop    %esi
801069dc:	5f                   	pop    %edi
801069dd:	5d                   	pop    %ebp
801069de:	c3                   	ret    
801069df:	90                   	nop
801069e0:	83 c4 2c             	add    $0x2c,%esp
  return 0;
801069e3:	31 c0                	xor    %eax,%eax
}
801069e5:	5b                   	pop    %ebx
801069e6:	5e                   	pop    %esi
801069e7:	5f                   	pop    %edi
801069e8:	5d                   	pop    %ebp
801069e9:	c3                   	ret    
      panic("remap");
801069ea:	c7 04 24 0c 7b 10 80 	movl   $0x80107b0c,(%esp)
801069f1:	e8 6a 99 ff ff       	call   80100360 <panic>
801069f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069fd:	8d 76 00             	lea    0x0(%esi),%esi

80106a00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	57                   	push   %edi
80106a04:	56                   	push   %esi
80106a05:	89 c6                	mov    %eax,%esi
80106a07:	53                   	push   %ebx
80106a08:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a0a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a10:	83 ec 2c             	sub    $0x2c,%esp
80106a13:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  a = PGROUNDUP(newsz);
80106a16:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; a  < oldsz; a += PGSIZE){
80106a1c:	39 da                	cmp    %ebx,%edx
80106a1e:	73 5f                	jae    80106a7f <deallocuvm.part.0+0x7f>
80106a20:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106a23:	89 d7                	mov    %edx,%edi
80106a25:	eb 34                	jmp    80106a5b <deallocuvm.part.0+0x5b>
80106a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a2e:	66 90                	xchg   %ax,%ax
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106a30:	8b 00                	mov    (%eax),%eax
80106a32:	a8 01                	test   $0x1,%al
80106a34:	74 1a                	je     80106a50 <deallocuvm.part.0+0x50>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106a36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a3b:	74 4d                	je     80106a8a <deallocuvm.part.0+0x8a>
        panic("kfree");
      char *v = P2V(pa);
80106a3d:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106a42:	89 04 24             	mov    %eax,(%esp)
80106a45:	e8 36 bb ff ff       	call   80102580 <kfree>
      *pte = 0;
80106a4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106a50:	81 c7 00 10 00 00    	add    $0x1000,%edi
  for(; a  < oldsz; a += PGSIZE){
80106a56:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106a59:	76 24                	jbe    80106a7f <deallocuvm.part.0+0x7f>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a5b:	31 c9                	xor    %ecx,%ecx
80106a5d:	89 fa                	mov    %edi,%edx
80106a5f:	89 f0                	mov    %esi,%eax
80106a61:	e8 6a fe ff ff       	call   801068d0 <walkpgdir>
    if(!pte)
80106a66:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a68:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106a6a:	75 c4                	jne    80106a30 <deallocuvm.part.0+0x30>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a6c:	89 fa                	mov    %edi,%edx
80106a6e:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106a74:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
  for(; a  < oldsz; a += PGSIZE){
80106a7a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106a7d:	77 dc                	ja     80106a5b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106a7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a82:	83 c4 2c             	add    $0x2c,%esp
80106a85:	5b                   	pop    %ebx
80106a86:	5e                   	pop    %esi
80106a87:	5f                   	pop    %edi
80106a88:	5d                   	pop    %ebp
80106a89:	c3                   	ret    
        panic("kfree");
80106a8a:	c7 04 24 c6 74 10 80 	movl   $0x801074c6,(%esp)
80106a91:	e8 ca 98 ff ff       	call   80100360 <panic>
80106a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9d:	8d 76 00             	lea    0x0(%esi),%esi

80106aa0 <seginit>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106aa6:	e8 35 cf ff ff       	call   801039e0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106aab:	b9 00 9a cf 00       	mov    $0xcf9a00,%ecx
  pd[0] = size-1;
80106ab0:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
80106ab6:	8d 14 80             	lea    (%eax,%eax,4),%edx
80106ab9:	8d 04 50             	lea    (%eax,%edx,2),%eax
80106abc:	ba ff ff 00 00       	mov    $0xffff,%edx
80106ac1:	c1 e0 04             	shl    $0x4,%eax
80106ac4:	89 90 f8 27 11 80    	mov    %edx,-0x7feed808(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106aca:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106acf:	89 88 fc 27 11 80    	mov    %ecx,-0x7feed804(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ad5:	b9 00 92 cf 00       	mov    $0xcf9200,%ecx
80106ada:	89 90 00 28 11 80    	mov    %edx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ae0:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ae5:	89 88 04 28 11 80    	mov    %ecx,-0x7feed7fc(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106aeb:	b9 00 fa cf 00       	mov    $0xcffa00,%ecx
80106af0:	89 90 08 28 11 80    	mov    %edx,-0x7feed7f8(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106af6:	ba ff ff 00 00       	mov    $0xffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106afb:	89 88 0c 28 11 80    	mov    %ecx,-0x7feed7f4(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b01:	b9 00 f2 cf 00       	mov    $0xcff200,%ecx
80106b06:	89 90 10 28 11 80    	mov    %edx,-0x7feed7f0(%eax)
80106b0c:	89 88 14 28 11 80    	mov    %ecx,-0x7feed7ec(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106b12:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106b17:	0f b7 d0             	movzwl %ax,%edx
80106b1a:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b1e:	c1 e8 10             	shr    $0x10,%eax
80106b21:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b25:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b28:	0f 01 10             	lgdtl  (%eax)
}
80106b2b:	c9                   	leave  
80106b2c:	c3                   	ret    
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi

80106b30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b30:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106b35:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b3a:	0f 22 d8             	mov    %eax,%cr3
}
80106b3d:	c3                   	ret    
80106b3e:	66 90                	xchg   %ax,%ax

80106b40 <switchuvm>:
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
80106b46:	83 ec 2c             	sub    $0x2c,%esp
80106b49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b4c:	85 f6                	test   %esi,%esi
80106b4e:	0f 84 c5 00 00 00    	je     80106c19 <switchuvm+0xd9>
  if(p->kstack == 0)
80106b54:	8b 7e 08             	mov    0x8(%esi),%edi
80106b57:	85 ff                	test   %edi,%edi
80106b59:	0f 84 d2 00 00 00    	je     80106c31 <switchuvm+0xf1>
  if(p->pgdir == 0)
80106b5f:	8b 5e 04             	mov    0x4(%esi),%ebx
80106b62:	85 db                	test   %ebx,%ebx
80106b64:	0f 84 bb 00 00 00    	je     80106c25 <switchuvm+0xe5>
  pushcli();
80106b6a:	e8 21 da ff ff       	call   80104590 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b6f:	e8 fc cd ff ff       	call   80103970 <mycpu>
80106b74:	89 c3                	mov    %eax,%ebx
80106b76:	e8 f5 cd ff ff       	call   80103970 <mycpu>
80106b7b:	89 c7                	mov    %eax,%edi
80106b7d:	e8 ee cd ff ff       	call   80103970 <mycpu>
80106b82:	83 c7 08             	add    $0x8,%edi
80106b85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b88:	e8 e3 cd ff ff       	call   80103970 <mycpu>
80106b8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b90:	ba 67 00 00 00       	mov    $0x67,%edx
80106b95:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106b9c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106ba3:	83 c1 08             	add    $0x8,%ecx
80106ba6:	c1 e9 10             	shr    $0x10,%ecx
80106ba9:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106baf:	83 c0 08             	add    $0x8,%eax
80106bb2:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106bb7:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
80106bbe:	c1 e8 18             	shr    $0x18,%eax
80106bc1:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
80106bc7:	e8 a4 cd ff ff       	call   80103970 <mycpu>
80106bcc:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bd3:	e8 98 cd ff ff       	call   80103970 <mycpu>
80106bd8:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106bde:	8b 5e 08             	mov    0x8(%esi),%ebx
80106be1:	e8 8a cd ff ff       	call   80103970 <mycpu>
80106be6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bec:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bef:	e8 7c cd ff ff       	call   80103970 <mycpu>
80106bf4:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106bfa:	b8 28 00 00 00       	mov    $0x28,%eax
80106bff:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c02:	8b 46 04             	mov    0x4(%esi),%eax
80106c05:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c0a:	0f 22 d8             	mov    %eax,%cr3
}
80106c0d:	83 c4 2c             	add    $0x2c,%esp
80106c10:	5b                   	pop    %ebx
80106c11:	5e                   	pop    %esi
80106c12:	5f                   	pop    %edi
80106c13:	5d                   	pop    %ebp
  popcli();
80106c14:	e9 c7 d9 ff ff       	jmp    801045e0 <popcli>
    panic("switchuvm: no process");
80106c19:	c7 04 24 12 7b 10 80 	movl   $0x80107b12,(%esp)
80106c20:	e8 3b 97 ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
80106c25:	c7 04 24 3d 7b 10 80 	movl   $0x80107b3d,(%esp)
80106c2c:	e8 2f 97 ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106c31:	c7 04 24 28 7b 10 80 	movl   $0x80107b28,(%esp)
80106c38:	e8 23 97 ff ff       	call   80100360 <panic>
80106c3d:	8d 76 00             	lea    0x0(%esi),%esi

80106c40 <inituvm>:
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	83 ec 38             	sub    $0x38,%esp
80106c46:	89 75 f8             	mov    %esi,-0x8(%ebp)
80106c49:	8b 75 10             	mov    0x10(%ebp),%esi
80106c4c:	89 7d fc             	mov    %edi,-0x4(%ebp)
80106c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c52:	89 5d f4             	mov    %ebx,-0xc(%ebp)
80106c55:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(sz >= PGSIZE)
80106c58:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106c5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c61:	77 5b                	ja     80106cbe <inituvm+0x7e>
  mem = kalloc();
80106c63:	e8 d8 ba ff ff       	call   80102740 <kalloc>
  memset(mem, 0, PGSIZE);
80106c68:	31 d2                	xor    %edx,%edx
80106c6a:	89 54 24 04          	mov    %edx,0x4(%esp)
  mem = kalloc();
80106c6e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c70:	b8 00 10 00 00       	mov    $0x1000,%eax
80106c75:	89 1c 24             	mov    %ebx,(%esp)
80106c78:	89 44 24 08          	mov    %eax,0x8(%esp)
80106c7c:	e8 0f db ff ff       	call   80104790 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c81:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c87:	b9 06 00 00 00       	mov    $0x6,%ecx
80106c8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106c90:	31 d2                	xor    %edx,%edx
80106c92:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c97:	89 04 24             	mov    %eax,(%esp)
80106c9a:	89 f8                	mov    %edi,%eax
80106c9c:	e8 cf fc ff ff       	call   80106970 <mappages>
  memmove(mem, init, sz);
80106ca1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ca4:	89 75 10             	mov    %esi,0x10(%ebp)
}
80106ca7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  memmove(mem, init, sz);
80106caa:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cad:	8b 75 f8             	mov    -0x8(%ebp),%esi
80106cb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  memmove(mem, init, sz);
80106cb3:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106cb6:	89 ec                	mov    %ebp,%esp
80106cb8:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106cb9:	e9 92 db ff ff       	jmp    80104850 <memmove>
    panic("inituvm: more than a page");
80106cbe:	c7 04 24 51 7b 10 80 	movl   $0x80107b51,(%esp)
80106cc5:	e8 96 96 ff ff       	call   80100360 <panic>
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cd0 <loaduvm>:
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	83 ec 2c             	sub    $0x2c,%esp
80106cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cdc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106cdf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ce4:	0f 85 9c 00 00 00    	jne    80106d86 <loaduvm+0xb6>
  for(i = 0; i < sz; i += PGSIZE){
80106cea:	01 f0                	add    %esi,%eax
80106cec:	89 f3                	mov    %esi,%ebx
80106cee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cf1:	8b 45 14             	mov    0x14(%ebp),%eax
80106cf4:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106cf6:	85 f6                	test   %esi,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106cfb:	75 11                	jne    80106d0e <loaduvm+0x3e>
80106cfd:	eb 71                	jmp    80106d70 <loaduvm+0xa0>
80106cff:	90                   	nop
80106d00:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106d06:	89 f0                	mov    %esi,%eax
80106d08:	29 d8                	sub    %ebx,%eax
80106d0a:	39 c6                	cmp    %eax,%esi
80106d0c:	76 62                	jbe    80106d70 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d11:	31 c9                	xor    %ecx,%ecx
80106d13:	8b 45 08             	mov    0x8(%ebp),%eax
80106d16:	29 da                	sub    %ebx,%edx
80106d18:	e8 b3 fb ff ff       	call   801068d0 <walkpgdir>
80106d1d:	85 c0                	test   %eax,%eax
80106d1f:	74 59                	je     80106d7a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106d21:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
80106d23:	bf 00 10 00 00       	mov    $0x1000,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d28:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106d2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d30:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106d36:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d39:	05 00 00 00 80       	add    $0x80000000,%eax
80106d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d42:	8b 45 10             	mov    0x10(%ebp),%eax
80106d45:	29 d9                	sub    %ebx,%ecx
80106d47:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106d4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106d4f:	89 04 24             	mov    %eax,(%esp)
80106d52:	e8 99 ad ff ff       	call   80101af0 <readi>
80106d57:	39 f8                	cmp    %edi,%eax
80106d59:	74 a5                	je     80106d00 <loaduvm+0x30>
}
80106d5b:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80106d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d63:	5b                   	pop    %ebx
80106d64:	5e                   	pop    %esi
80106d65:	5f                   	pop    %edi
80106d66:	5d                   	pop    %ebp
80106d67:	c3                   	ret    
80106d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d6f:	90                   	nop
80106d70:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80106d73:	31 c0                	xor    %eax,%eax
}
80106d75:	5b                   	pop    %ebx
80106d76:	5e                   	pop    %esi
80106d77:	5f                   	pop    %edi
80106d78:	5d                   	pop    %ebp
80106d79:	c3                   	ret    
      panic("loaduvm: address should exist");
80106d7a:	c7 04 24 6b 7b 10 80 	movl   $0x80107b6b,(%esp)
80106d81:	e8 da 95 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
80106d86:	c7 04 24 0c 7c 10 80 	movl   $0x80107c0c,(%esp)
80106d8d:	e8 ce 95 ff ff       	call   80100360 <panic>
80106d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106da0 <allocuvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 2c             	sub    $0x2c,%esp
  if(newsz >= KERNBASE)
80106da9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106dac:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106daf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106db2:	85 c0                	test   %eax,%eax
80106db4:	0f 88 c6 00 00 00    	js     80106e80 <allocuvm+0xe0>
  if(newsz < oldsz)
80106dba:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106dc0:	0f 82 aa 00 00 00    	jb     80106e70 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
80106dc6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106dcc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106dd2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106dd5:	77 53                	ja     80106e2a <allocuvm+0x8a>
80106dd7:	e9 97 00 00 00       	jmp    80106e73 <allocuvm+0xd3>
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106de0:	89 1c 24             	mov    %ebx,(%esp)
80106de3:	31 d2                	xor    %edx,%edx
80106de5:	b8 00 10 00 00       	mov    $0x1000,%eax
80106dea:	89 54 24 04          	mov    %edx,0x4(%esp)
80106dee:	89 44 24 08          	mov    %eax,0x8(%esp)
80106df2:	e8 99 d9 ff ff       	call   80104790 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106df7:	b9 06 00 00 00       	mov    $0x6,%ecx
80106dfc:	89 f2                	mov    %esi,%edx
80106dfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80106e02:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e08:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e0d:	89 04 24             	mov    %eax,(%esp)
80106e10:	89 f8                	mov    %edi,%eax
80106e12:	e8 59 fb ff ff       	call   80106970 <mappages>
80106e17:	85 c0                	test   %eax,%eax
80106e19:	0f 88 81 00 00 00    	js     80106ea0 <allocuvm+0x100>
  for(; a < newsz; a += PGSIZE){
80106e1f:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e25:	39 75 10             	cmp    %esi,0x10(%ebp)
80106e28:	76 49                	jbe    80106e73 <allocuvm+0xd3>
    mem = kalloc();
80106e2a:	e8 11 b9 ff ff       	call   80102740 <kalloc>
    if(mem == 0){
80106e2f:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106e31:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106e33:	75 ab                	jne    80106de0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106e35:	c7 04 24 89 7b 10 80 	movl   $0x80107b89,(%esp)
80106e3c:	e8 3f 98 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80106e41:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e44:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e47:	74 37                	je     80106e80 <allocuvm+0xe0>
80106e49:	8b 55 10             	mov    0x10(%ebp),%edx
80106e4c:	89 c1                	mov    %eax,%ecx
80106e4e:	89 f8                	mov    %edi,%eax
80106e50:	e8 ab fb ff ff       	call   80106a00 <deallocuvm.part.0>
      return 0;
80106e55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e5f:	83 c4 2c             	add    $0x2c,%esp
80106e62:	5b                   	pop    %ebx
80106e63:	5e                   	pop    %esi
80106e64:	5f                   	pop    %edi
80106e65:	5d                   	pop    %ebp
80106e66:	c3                   	ret    
80106e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e6e:	66 90                	xchg   %ax,%ax
    return oldsz;
80106e70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e76:	83 c4 2c             	add    $0x2c,%esp
80106e79:	5b                   	pop    %ebx
80106e7a:	5e                   	pop    %esi
80106e7b:	5f                   	pop    %edi
80106e7c:	5d                   	pop    %ebp
80106e7d:	c3                   	ret    
80106e7e:	66 90                	xchg   %ax,%ax
    return 0;
80106e80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e8a:	83 c4 2c             	add    $0x2c,%esp
80106e8d:	5b                   	pop    %ebx
80106e8e:	5e                   	pop    %esi
80106e8f:	5f                   	pop    %edi
80106e90:	5d                   	pop    %ebp
80106e91:	c3                   	ret    
80106e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ea0:	c7 04 24 a1 7b 10 80 	movl   $0x80107ba1,(%esp)
80106ea7:	e8 d4 97 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80106eac:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eaf:	39 45 10             	cmp    %eax,0x10(%ebp)
80106eb2:	74 0c                	je     80106ec0 <allocuvm+0x120>
80106eb4:	8b 55 10             	mov    0x10(%ebp),%edx
80106eb7:	89 c1                	mov    %eax,%ecx
80106eb9:	89 f8                	mov    %edi,%eax
80106ebb:	e8 40 fb ff ff       	call   80106a00 <deallocuvm.part.0>
      kfree(mem);
80106ec0:	89 1c 24             	mov    %ebx,(%esp)
80106ec3:	e8 b8 b6 ff ff       	call   80102580 <kfree>
      return 0;
80106ec8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ed2:	83 c4 2c             	add    $0x2c,%esp
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ee0 <deallocuvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ee6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106eec:	39 d1                	cmp    %edx,%ecx
80106eee:	73 10                	jae    80106f00 <deallocuvm+0x20>
}
80106ef0:	5d                   	pop    %ebp
80106ef1:	e9 0a fb ff ff       	jmp    80106a00 <deallocuvm.part.0>
80106ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106efd:	8d 76 00             	lea    0x0(%esi),%esi
80106f00:	5d                   	pop    %ebp
80106f01:	89 d0                	mov    %edx,%eax
80106f03:	c3                   	ret    
80106f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f0f:	90                   	nop

80106f10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
80106f19:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f1c:	85 f6                	test   %esi,%esi
80106f1e:	74 55                	je     80106f75 <freevm+0x65>
  if(newsz >= oldsz)
80106f20:	31 c9                	xor    %ecx,%ecx
80106f22:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f27:	89 f0                	mov    %esi,%eax
80106f29:	89 f3                	mov    %esi,%ebx
80106f2b:	e8 d0 fa ff ff       	call   80106a00 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f30:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f36:	eb 0f                	jmp    80106f47 <freevm+0x37>
80106f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3f:	90                   	nop
80106f40:	83 c3 04             	add    $0x4,%ebx
80106f43:	39 df                	cmp    %ebx,%edi
80106f45:	74 1f                	je     80106f66 <freevm+0x56>
    if(pgdir[i] & PTE_P){
80106f47:	8b 03                	mov    (%ebx),%eax
80106f49:	a8 01                	test   $0x1,%al
80106f4b:	74 f3                	je     80106f40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f52:	83 c3 04             	add    $0x4,%ebx
80106f55:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f5a:	89 04 24             	mov    %eax,(%esp)
80106f5d:	e8 1e b6 ff ff       	call   80102580 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106f62:	39 df                	cmp    %ebx,%edi
80106f64:	75 e1                	jne    80106f47 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f66:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f69:	83 c4 1c             	add    $0x1c,%esp
80106f6c:	5b                   	pop    %ebx
80106f6d:	5e                   	pop    %esi
80106f6e:	5f                   	pop    %edi
80106f6f:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f70:	e9 0b b6 ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
80106f75:	c7 04 24 bd 7b 10 80 	movl   $0x80107bbd,(%esp)
80106f7c:	e8 df 93 ff ff       	call   80100360 <panic>
80106f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8f:	90                   	nop

80106f90 <setupkvm>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	56                   	push   %esi
80106f94:	53                   	push   %ebx
80106f95:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f98:	e8 a3 b7 ff ff       	call   80102740 <kalloc>
80106f9d:	85 c0                	test   %eax,%eax
80106f9f:	89 c6                	mov    %eax,%esi
80106fa1:	74 46                	je     80106fe9 <setupkvm+0x59>
  memset(pgdir, 0, PGSIZE);
80106fa3:	89 34 24             	mov    %esi,(%esp)
80106fa6:	b8 00 10 00 00       	mov    $0x1000,%eax
80106fab:	31 d2                	xor    %edx,%edx
80106fad:	89 44 24 08          	mov    %eax,0x8(%esp)
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fb1:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106fb6:	89 54 24 04          	mov    %edx,0x4(%esp)
80106fba:	e8 d1 d7 ff ff       	call   80104790 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106fbf:	8b 53 0c             	mov    0xc(%ebx),%edx
                (uint)k->phys_start, k->perm) < 0) {
80106fc2:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106fc5:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106fc8:	89 54 24 04          	mov    %edx,0x4(%esp)
80106fcc:	8b 13                	mov    (%ebx),%edx
80106fce:	89 04 24             	mov    %eax,(%esp)
80106fd1:	29 c1                	sub    %eax,%ecx
80106fd3:	89 f0                	mov    %esi,%eax
80106fd5:	e8 96 f9 ff ff       	call   80106970 <mappages>
80106fda:	85 c0                	test   %eax,%eax
80106fdc:	78 22                	js     80107000 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fde:	83 c3 10             	add    $0x10,%ebx
80106fe1:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106fe7:	75 d6                	jne    80106fbf <setupkvm+0x2f>
}
80106fe9:	83 c4 10             	add    $0x10,%esp
80106fec:	89 f0                	mov    %esi,%eax
80106fee:	5b                   	pop    %ebx
80106fef:	5e                   	pop    %esi
80106ff0:	5d                   	pop    %ebp
80106ff1:	c3                   	ret    
80106ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107000:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107003:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107005:	e8 06 ff ff ff       	call   80106f10 <freevm>
}
8010700a:	83 c4 10             	add    $0x10,%esp
8010700d:	89 f0                	mov    %esi,%eax
8010700f:	5b                   	pop    %ebx
80107010:	5e                   	pop    %esi
80107011:	5d                   	pop    %ebp
80107012:	c3                   	ret    
80107013:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107020 <kvmalloc>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107026:	e8 65 ff ff ff       	call   80106f90 <setupkvm>
8010702b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107030:	05 00 00 00 80       	add    $0x80000000,%eax
80107035:	0f 22 d8             	mov    %eax,%cr3
}
80107038:	c9                   	leave  
80107039:	c3                   	ret    
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107040 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107040:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107041:	31 c9                	xor    %ecx,%ecx
{
80107043:	89 e5                	mov    %esp,%ebp
80107045:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107048:	8b 55 0c             	mov    0xc(%ebp),%edx
8010704b:	8b 45 08             	mov    0x8(%ebp),%eax
8010704e:	e8 7d f8 ff ff       	call   801068d0 <walkpgdir>
  if(pte == 0)
80107053:	85 c0                	test   %eax,%eax
80107055:	74 05                	je     8010705c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107057:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010705a:	c9                   	leave  
8010705b:	c3                   	ret    
    panic("clearpteu");
8010705c:	c7 04 24 ce 7b 10 80 	movl   $0x80107bce,(%esp)
80107063:	e8 f8 92 ff ff       	call   80100360 <panic>
80107068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010706f:	90                   	nop

80107070 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107079:	e8 12 ff ff ff       	call   80106f90 <setupkvm>
8010707e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107081:	85 c0                	test   %eax,%eax
80107083:	0f 84 a3 00 00 00    	je     8010712c <copyuvm+0xbc>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107089:	8b 55 0c             	mov    0xc(%ebp),%edx
8010708c:	85 d2                	test   %edx,%edx
8010708e:	0f 84 98 00 00 00    	je     8010712c <copyuvm+0xbc>
80107094:	31 ff                	xor    %edi,%edi
80107096:	eb 50                	jmp    801070e8 <copyuvm+0x78>
80107098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801070a0:	89 34 24             	mov    %esi,(%esp)
801070a3:	b8 00 10 00 00       	mov    $0x1000,%eax
801070a8:	89 44 24 08          	mov    %eax,0x8(%esp)
801070ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070af:	05 00 00 00 80       	add    $0x80000000,%eax
801070b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801070b8:	e8 93 d7 ff ff       	call   80104850 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801070bd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070c3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070c8:	89 04 24             	mov    %eax,(%esp)
801070cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070ce:	89 fa                	mov    %edi,%edx
801070d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801070d4:	e8 97 f8 ff ff       	call   80106970 <mappages>
801070d9:	85 c0                	test   %eax,%eax
801070db:	78 63                	js     80107140 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
801070dd:	81 c7 00 10 00 00    	add    $0x1000,%edi
801070e3:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801070e6:	76 44                	jbe    8010712c <copyuvm+0xbc>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070e8:	8b 45 08             	mov    0x8(%ebp),%eax
801070eb:	31 c9                	xor    %ecx,%ecx
801070ed:	89 fa                	mov    %edi,%edx
801070ef:	e8 dc f7 ff ff       	call   801068d0 <walkpgdir>
801070f4:	85 c0                	test   %eax,%eax
801070f6:	74 5e                	je     80107156 <copyuvm+0xe6>
    if(!(*pte & PTE_P))
801070f8:	8b 18                	mov    (%eax),%ebx
801070fa:	f6 c3 01             	test   $0x1,%bl
801070fd:	74 4b                	je     8010714a <copyuvm+0xda>
    pa = PTE_ADDR(*pte);
801070ff:	89 d8                	mov    %ebx,%eax
    flags = PTE_FLAGS(*pte);
80107101:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107107:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010710c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010710f:	e8 2c b6 ff ff       	call   80102740 <kalloc>
80107114:	85 c0                	test   %eax,%eax
80107116:	89 c6                	mov    %eax,%esi
80107118:	75 86                	jne    801070a0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
8010711a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010711d:	89 04 24             	mov    %eax,(%esp)
80107120:	e8 eb fd ff ff       	call   80106f10 <freevm>
  return 0;
80107125:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010712c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010712f:	83 c4 2c             	add    $0x2c,%esp
80107132:	5b                   	pop    %ebx
80107133:	5e                   	pop    %esi
80107134:	5f                   	pop    %edi
80107135:	5d                   	pop    %ebp
80107136:	c3                   	ret    
80107137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713e:	66 90                	xchg   %ax,%ax
      kfree(mem);
80107140:	89 34 24             	mov    %esi,(%esp)
80107143:	e8 38 b4 ff ff       	call   80102580 <kfree>
      goto bad;
80107148:	eb d0                	jmp    8010711a <copyuvm+0xaa>
      panic("copyuvm: page not present");
8010714a:	c7 04 24 f2 7b 10 80 	movl   $0x80107bf2,(%esp)
80107151:	e8 0a 92 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80107156:	c7 04 24 d8 7b 10 80 	movl   $0x80107bd8,(%esp)
8010715d:	e8 fe 91 ff ff       	call   80100360 <panic>
80107162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107170 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107170:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107171:	31 c9                	xor    %ecx,%ecx
{
80107173:	89 e5                	mov    %esp,%ebp
80107175:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107178:	8b 55 0c             	mov    0xc(%ebp),%edx
8010717b:	8b 45 08             	mov    0x8(%ebp),%eax
8010717e:	e8 4d f7 ff ff       	call   801068d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107183:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107185:	89 c2                	mov    %eax,%edx
80107187:	83 e2 05             	and    $0x5,%edx
8010718a:	83 fa 05             	cmp    $0x5,%edx
8010718d:	75 11                	jne    801071a0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
8010718f:	c9                   	leave  
  return (char*)P2V(PTE_ADDR(*pte));
80107190:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107195:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010719a:	c3                   	ret    
8010719b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010719f:	90                   	nop
801071a0:	c9                   	leave  
    return 0;
801071a1:	31 c0                	xor    %eax,%eax
}
801071a3:	c3                   	ret    
801071a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071af:	90                   	nop

801071b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
801071b9:	8b 75 14             	mov    0x14(%ebp),%esi
801071bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071bf:	85 f6                	test   %esi,%esi
801071c1:	75 43                	jne    80107206 <copyout+0x56>
801071c3:	eb 7b                	jmp    80107240 <copyout+0x90>
801071c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801071d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801071d3:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801071d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
    n = PGSIZE - (va - va0);
801071d8:	29 d3                	sub    %edx,%ebx
    memmove(pa0 + (va - va0), buf, n);
801071da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    n = PGSIZE - (va - va0);
801071de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801071e4:	39 f3                	cmp    %esi,%ebx
801071e6:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801071e9:	29 fa                	sub    %edi,%edx
801071eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801071ef:	01 c2                	add    %eax,%edx
801071f1:	89 14 24             	mov    %edx,(%esp)
801071f4:	e8 57 d6 ff ff       	call   80104850 <memmove>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801071f9:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
    buf += n;
801071ff:	01 5d 10             	add    %ebx,0x10(%ebp)
  while(len > 0){
80107202:	29 de                	sub    %ebx,%esi
80107204:	74 3a                	je     80107240 <copyout+0x90>
    va0 = (uint)PGROUNDDOWN(va);
80107206:	89 55 0c             	mov    %edx,0xc(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107209:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
8010720c:	89 d7                	mov    %edx,%edi
8010720e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107214:	89 7c 24 04          	mov    %edi,0x4(%esp)
80107218:	89 04 24             	mov    %eax,(%esp)
8010721b:	e8 50 ff ff ff       	call   80107170 <uva2ka>
    if(pa0 == 0)
80107220:	85 c0                	test   %eax,%eax
80107222:	75 ac                	jne    801071d0 <copyout+0x20>
  }
  return 0;
}
80107224:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80107227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010722c:	5b                   	pop    %ebx
8010722d:	5e                   	pop    %esi
8010722e:	5f                   	pop    %edi
8010722f:	5d                   	pop    %ebp
80107230:	c3                   	ret    
80107231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723f:	90                   	nop
80107240:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80107243:	31 c0                	xor    %eax,%eax
}
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
