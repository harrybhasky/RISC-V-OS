#!/bin/bash
set -xue

QEMU=qemu-system-riscv32

# Path to clang and compiler flags
CC=/opt/homebrew/opt/llvm/bin/clang  
CFLAGS="-std=c11 -O2 -g3 -Wall -Wextra --target=riscv32-unknown-elf -fno-stack-protector -ffreestanding -nostdlib"

# Build the kernel
# 1. Compile to object file
$CC $CFLAGS -c kernel.c -o kernel.o

# 2. Link with LLD
/opt/homebrew/opt/llvm/bin/ld.lld -T kernel.ld -static -nostdlib \
       -Map=kernel.map -o kernel.elf kernel.o

# Start QEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot \
    -kernel kernel.elf
