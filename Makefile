TARGET = boot
TARGET_ELF=$(TARGET).elf
TARGET_HEX=$(TARGET).hex
FILES = boot.S
#CFLAGS = -O2 -nostdlib -nostartfiles -fno-builtin-printf

builddir := .

TOOLCHAIN=$(RISCV_PATH)/bin/riscv32-unknown-elf

AS      := $(abspath $(TOOLCHAIN)-as)
LD      := $(abspath $(TOOLCHAIN)-ld)
GDB     := $(abspath $(TOOLCHAIN)-gdb)
OC      := $(abspath $(TOOLCHAIN)-objcopy)

#ASM_FLAGS     = -f

RISCV_ARCH=rv32imac
RISCV_ABI=ilp32
RISCV_CMODEL=medlow
RISCV_SERIES=sifive-3-series

ARCH=-march=$(RISCV_ARCH) -mabi=$(RISCV_ABI)
# -march=rv32imac -mabi=ilp32:

TARGET_TAGS=board jlink
TARGET_DHRY_ITERS=20000000
TARGET_CORE_ITERS=5000

OBJS = $(FILES:.S=.o)

LINKER=-T linker.lds

ASFLAGS=$(ARCH) -g
# ASFLAGS=
LDFLAGS=$(LINKER)

all: $(TARGET_ELF) $(TARGET_HEX)
	@echo "Done."	

$(TARGET_ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $(TARGET_ELF) $(OBJS)

$(TARGET_HEX) : $(TARGET_ELF)
	$(OC) -O ihex $(TARGET_ELF) $(TARGET_HEX)

$(OBJS) : $(FILES)
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf $(OBJS) $(TARGET) $(TARGET_ELF) $(TARGET_HEX)

debug:
	scripts/debug --elf $(TARGET_ELF) --jlink JLinkGDBServer --gdb $(GDB)

flash : $(TARGET_HEX)
	JLinkExe -device FE310 -speed 1000 -if JTAG -jtagconf -1,-1 -autoconnect 1 -CommanderScript "./scripts/flash.jlink"
