TARGET = boot
FILES = boot.S
#CFLAGS = -O2 -nostdlib -nostartfiles -fno-builtin-printf

builddir := .

RISCV_PATH ?= $(toolchain_prefix)

AS      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-as)
LD      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-ld)
CC      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-ld)

#ASM_FLAGS     = -f

OBJS = $(FILES:.S=.o)

all : $(OBJS)
	$(LD) -o $(TARGET) $(OBJS)

%.o : $(FILES)
	$(AS)  $< -o $@

clean:
	rm -rf $(OBJS) $(TARGET)