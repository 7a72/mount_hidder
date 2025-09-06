# Makefile for Kernel Patch Module (KPM) build system

NDK_PATH := $(shell echo $(NDK_PATH))
export TARGET_COMPILE=$(NDK_PATH)/toolchains/llvm/prebuilt/linux-x86_64/bin/

KP_DIR = ../..

CC = $(TARGET_COMPILE)aarch64-linux-android31-clang
LD = $(TARGET_COMPILE)ld.lld
AS = $(TARGET_COMPILE)llvm-as
OBJCOPY = $(TARGET_COMPILE)llvm-objcopy
STRIP := $(TARGET_COMPILE)llvm-strip

INCLUDE_DIRS := . include patch/include linux/include linux/arch/arm64/include linux/tools/arch/arm64/include

INCLUDE_FLAGS := $(foreach dir,$(INCLUDE_DIRS),-I$(KP_DIR)/kernel/$(dir))

CFLAGS = -Wall -O2 -fno-PIC -fno-asynchronous-unwind-tables -fno-stack-protector -fno-common 

LDFLAGS += -s

objs := hide_mount.o

all: hide_mount.kpm

hide_mount.kpm: ${objs}
	${CC} $(LDFLAGS) -r -o $@ $^

%.o: %.c
	${CC} $(CFLAGS) $(INCLUDE_FLAGS) -c -o $@ $<

.PHONY: clean
clean:
	rm -rf *.o *.kpm
