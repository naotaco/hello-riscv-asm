TARGET = boot
TARGET_ELF=$(TARGET).elf
FILES = boot.S
#CFLAGS = -O2 -nostdlib -nostartfiles -fno-builtin-printf

builddir := .

RISCV_PATH ?= $(toolchain_prefix)

AS      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-as)
LD      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-ld)
CC      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-gcc)

#ASM_FLAGS     = -f

RISCV_ARCH=rv32imac
RISCV_ABI=ilp32
RISCV_CMODEL=medlow
RISCV_SERIES=sifive-3-series

TARGET_TAGS=board jlink
TARGET_DHRY_ITERS=20000000
TARGET_CORE_ITERS=5000

OBJS = $(FILES:.S=.o)

LINKER=-T linker.lds
LDFLAGS=$(LINKER)

all: $(TARGET_ELF)
	# nothing

$(TARGET_ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $(TARGET_ELF) $(OBJS)

%.o : $(FILES)
	$(AS)  $< -o $@

clean:
	rm -rf $(OBJS) $(TARGET) $(TARGET_ELF)