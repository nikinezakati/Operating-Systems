
bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:	fa                   	cli    

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0d:	75 fa                	jne    7c09 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c17:	75 fa                	jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c1d:	0f 01 16             	lgdtl  (%esi)
    7c20:	78 7c                	js     7c9e <readsect+0x13>
  movl    %cr0, %eax
    7c22:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c25:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c29:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c2c:	ea                   	.byte 0xea
    7c2d:	31 7c 08 00          	xor    %edi,0x0(%eax,%ecx,1)

00007c31 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c31:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c35:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c37:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c39:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c3b:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c3f:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c41:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c43:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c48:	e8 e9 00 00 00       	call   7d36 <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c4d:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7c51:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7c54:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c56:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c5a:	66 ef                	out    %ax,(%dx)

00007c5c <spin>:
spin:
  jmp     spin
    7c5c:	eb fe                	jmp    7c5c <spin>
    7c5e:	66 90                	xchg   %ax,%ax

00007c60 <gdt>:
	...
    7c68:	ff                   	(bad)  
    7c69:	ff 00                	incl   (%eax)
    7c6b:	00 00                	add    %al,(%eax)
    7c6d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c74:	00                   	.byte 0x0
    7c75:	92                   	xchg   %eax,%edx
    7c76:	cf                   	iret   
	...

00007c78 <gdtdesc>:
    7c78:	17                   	pop    %ss
    7c79:	00 60 7c             	add    %ah,0x7c(%eax)
	...

00007c7e <waitdisk>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c7e:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c83:	ec                   	in     (%dx),%al

void
waitdisk(void)
{
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c84:	24 c0                	and    $0xc0,%al
    7c86:	3c 40                	cmp    $0x40,%al
    7c88:	75 f9                	jne    7c83 <waitdisk+0x5>
    ;
}
    7c8a:	c3                   	ret    

00007c8b <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7c8b:	55                   	push   %ebp
    7c8c:	89 e5                	mov    %esp,%ebp
    7c8e:	57                   	push   %edi
    7c8f:	83 ec 04             	sub    $0x4,%esp
  // Issue command.
  waitdisk();
    7c92:	e8 e7 ff ff ff       	call   7c7e <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7c97:	b0 01                	mov    $0x1,%al
    7c99:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c9e:	ee                   	out    %al,(%dx)
    7c9f:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7ca4:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    7ca8:	ee                   	out    %al,(%dx)
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
    7ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
    7cac:	c1 e8 08             	shr    $0x8,%eax
    7caf:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cb4:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
    7cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
    7cb8:	c1 e8 10             	shr    $0x10,%eax
    7cbb:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7cc0:	ee                   	out    %al,(%dx)
  outb(0x1F6, (offset >> 24) | 0xE0);
    7cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
    7cc4:	c1 e8 18             	shr    $0x18,%eax
    7cc7:	0c e0                	or     $0xe0,%al
    7cc9:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cce:	ee                   	out    %al,(%dx)
    7ccf:	b0 20                	mov    $0x20,%al
    7cd1:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cd6:	ee                   	out    %al,(%dx)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7cd7:	e8 a2 ff ff ff       	call   7c7e <waitdisk>
  asm volatile("cld; rep insl" :
    7cdc:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cdf:	b9 80 00 00 00       	mov    $0x80,%ecx
    7ce4:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ce9:	fc                   	cld    
    7cea:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7cec:	83 c4 04             	add    $0x4,%esp
    7cef:	5f                   	pop    %edi
    7cf0:	5d                   	pop    %ebp
    7cf1:	c3                   	ret    

00007cf2 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7cf2:	55                   	push   %ebp
    7cf3:	89 e5                	mov    %esp,%ebp
    7cf5:	57                   	push   %edi
    7cf6:	56                   	push   %esi
    7cf7:	53                   	push   %ebx
    7cf8:	83 ec 1c             	sub    $0x1c,%esp
    7cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7cfe:	8b 75 10             	mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
    7d01:	89 df                	mov    %ebx,%edi
    7d03:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7d06:	89 f0                	mov    %esi,%eax
    7d08:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d0d:	29 c3                	sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d0f:	c1 ee 09             	shr    $0x9,%esi
    7d12:	46                   	inc    %esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d13:	39 df                	cmp    %ebx,%edi
    7d15:	76 17                	jbe    7d2e <readseg+0x3c>
    readsect(pa, offset);
    7d17:	89 74 24 04          	mov    %esi,0x4(%esp)
    7d1b:	89 1c 24             	mov    %ebx,(%esp)
    7d1e:	e8 68 ff ff ff       	call   7c8b <readsect>
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d23:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d29:	46                   	inc    %esi
    7d2a:	39 df                	cmp    %ebx,%edi
    7d2c:	77 e9                	ja     7d17 <readseg+0x25>
}
    7d2e:	83 c4 1c             	add    $0x1c,%esp
    7d31:	5b                   	pop    %ebx
    7d32:	5e                   	pop    %esi
    7d33:	5f                   	pop    %edi
    7d34:	5d                   	pop    %ebp
    7d35:	c3                   	ret    

00007d36 <bootmain>:
{
    7d36:	55                   	push   %ebp
    7d37:	89 e5                	mov    %esp,%ebp
    7d39:	57                   	push   %edi
    7d3a:	56                   	push   %esi
    7d3b:	53                   	push   %ebx
    7d3c:	83 ec 1c             	sub    $0x1c,%esp
  readseg((uchar*)elf, 4096, 0);
    7d3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    7d46:	00 
    7d47:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    7d4e:	00 
    7d4f:	c7 04 24 00 00 01 00 	movl   $0x10000,(%esp)
    7d56:	e8 97 ff ff ff       	call   7cf2 <readseg>
  if(elf->magic != ELF_MAGIC)
    7d5b:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d62:	45 4c 46 
    7d65:	75 27                	jne    7d8e <bootmain+0x58>
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d67:	8b 15 1c 00 01 00    	mov    0x1001c,%edx
    7d6d:	8d 9a 00 00 01 00    	lea    0x10000(%edx),%ebx
  eph = ph + elf->phnum;
    7d73:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
    7d7a:	c1 e0 05             	shl    $0x5,%eax
    7d7d:	8d b4 02 00 00 01 00 	lea    0x10000(%edx,%eax,1),%esi
  for(; ph < eph; ph++){
    7d84:	39 f3                	cmp    %esi,%ebx
    7d86:	72 15                	jb     7d9d <bootmain+0x67>
  entry();
    7d88:	ff 15 18 00 01 00    	call   *0x10018
}
    7d8e:	83 c4 1c             	add    $0x1c,%esp
    7d91:	5b                   	pop    %ebx
    7d92:	5e                   	pop    %esi
    7d93:	5f                   	pop    %edi
    7d94:	5d                   	pop    %ebp
    7d95:	c3                   	ret    
  for(; ph < eph; ph++){
    7d96:	83 c3 20             	add    $0x20,%ebx
    7d99:	39 de                	cmp    %ebx,%esi
    7d9b:	76 eb                	jbe    7d88 <bootmain+0x52>
    pa = (uchar*)ph->paddr;
    7d9d:	8b 7b 0c             	mov    0xc(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
    7da0:	8b 43 04             	mov    0x4(%ebx),%eax
    7da3:	89 44 24 08          	mov    %eax,0x8(%esp)
    7da7:	8b 43 10             	mov    0x10(%ebx),%eax
    7daa:	89 44 24 04          	mov    %eax,0x4(%esp)
    7dae:	89 3c 24             	mov    %edi,(%esp)
    7db1:	e8 3c ff ff ff       	call   7cf2 <readseg>
    if(ph->memsz > ph->filesz)
    7db6:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7db9:	8b 43 10             	mov    0x10(%ebx),%eax
    7dbc:	39 c1                	cmp    %eax,%ecx
    7dbe:	76 d6                	jbe    7d96 <bootmain+0x60>
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
    7dc0:	01 c7                	add    %eax,%edi
    7dc2:	29 c1                	sub    %eax,%ecx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7dc4:	b8 00 00 00 00       	mov    $0x0,%eax
    7dc9:	fc                   	cld    
    7dca:	f3 aa                	rep stos %al,%es:(%edi)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    7dcc:	eb c8                	jmp    7d96 <bootmain+0x60>
