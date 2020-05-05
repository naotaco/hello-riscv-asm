TARGET = boot
TARGET_ELF=$(TARGET).elf
TARGET_HEX=$(TARGET).hex
FILES = boot.S
#CFLAGS = -O2 -nostdlib -nostartfiles -fno-builtin-printf

builddir := .

RISCV_PATH ?= $(toolchain_prefix)

AS      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-as)
LD      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-ld)
CC      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-gcc)
OC      := $(abspath $(RISCV_PATH)/bin/riscv64-unknown-elf-objcopy)

#ASM_FLAGS     = -f

RISCV_ARCH=rv64imac
RISCV_ABI=ilp64
RISCV_CMODEL=medlow
RISCV_SERIES=sifive-3-series

ARCH=-march=$(RISCV_ARCH)

TARGET_TAGS=board jlink
TARGET_DHRY_ITERS=20000000
TARGET_CORE_ITERS=5000

OBJS = $(FILES:.S=.o)

LINKER=-T linker.lds

ASFLAGS=$(ARCH)
# ASFLAGS=
LDFLAGS=$(LINKER)

all: $(TARGET_ELF) $(TARGET_HEX)
	# nothing

$(TARGET_ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $(TARGET_ELF) $(OBJS)

$(TARGET_HEX) : $(TARGET_ELF)
	$(OC) -O ihex $(TARGET_ELF) $(TARGET_HEX)

%.o : $(FILES)
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf $(OBJS) $(TARGET) $(TARGET_ELF) $(TARGET_HEX)