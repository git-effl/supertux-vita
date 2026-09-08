# SuperTux 0.40 PS Vita Makefile
# Simple, direct compilation without CMake

# Toolchain
CC = arm-vita-eabi-gcc
CXX = arm-vita-eabi-g++
AR = arm-vita-eabi-ar
RANLIB = arm-vita-eabi-ranlib
STRIP = arm-vita-eabi-strip
PACK = vita-pack-vpk
SFO = vita-mksfoex

# Paths
VITASDK ?= /opt/devkitpro/vitasdk
VITA_PREFIX = $(VITASDK)/arm-vita-eabi

# Directories
SRC_DIR = src
BUILD_DIR = BUILD_VITA
OBJ_DIR = $(BUILD_DIR)/obj
DEP_DIR = $(BUILD_DIR)/deps

# Output Targets
BIN_NAME = supertux.elf
BIN_PATH = $(BUILD_DIR)/$(BIN_NAME)
VELF_PATH = $(BUILD_DIR)/supertux.velf
EBOOT_PATH = $(BUILD_DIR)/eboot.bin
OUTPUT = supertux-vita.elf
VPK_OUTPUT = supertux-vita.vpk

# Compiler flags
CFLAGS = -O2 -g \
  --sysroot=$(VITA_PREFIX) \
  -march=armv7-a -mfpu=neon \
  -mfloat-abi=hard \
  -I. \
  -I./GL \
  -I./SDL2 \
  -isystem$(VITA_PREFIX)/include/SDL2 \
  -I$(VITA_PREFIX)/include/AL \
  -Wall -Wextra -Wpedantic \
  -fno-strict-aliasing \
  -DVITA \
  -D_GNU_SOURCE \
  -DBOOST_HAS_LONG_LONG \
  -Iexternal \
  -Iexternal/boost \
  -I$(SRC_DIR) \
  -I$(SRC_DIR)/supertux \
  -I$(SRC_DIR)/object \
  -I$(SRC_DIR)/badguy \
  -I$(SRC_DIR)/sprite \
  -I$(SRC_DIR)/control \
  -I$(SRC_DIR)/gui \
  -I$(SRC_DIR)/audio \
  -I$(SRC_DIR)/math \
  -I$(SRC_DIR)/trigger \
  -I$(SRC_DIR)/worldmap \
  -I$(SRC_DIR)/video \
  -I$(SRC_DIR)/video/sdl \
  -I$(SRC_DIR)/video/gl \
  -I$(SRC_DIR)/physfs \
  -I$(SRC_DIR)/util \
  -I$(SRC_DIR)/scripting \
  -I$(SRC_DIR)/lisp \
  -I$(SRC_DIR)/addon \
  -Iexternal/tinygettext/include \
  -Iexternal/squirrel/include \
  -Iexternal/obstack \
  -Iexternal/findlocale

CXXFLAGS = $(CFLAGS) \
  -std=c++17 \
  -fexceptions
  
LDFLAGS = -L$(VITA_PREFIX)/lib

LIBS = -Wl,--start-group \
  -lSDL2 -lSDL2_image -lvitaGL -lphysfs \
  -lvitashark -lmathneon -lwebpdemux \
  -lSceGxm_stub -lSceDisplay_stub -lSceCtrl_stub -lSceTouch_stub \
  -lSceMotion_stub -lSceCommonDialog_stub -lSceSysmodule_stub \
  -lScePower_stub -lSceAppUtil_stub -lSceAudio_stub -lSceAudioIn_stub \
  -lSceHid_stub -lSceAppMgr_stub -lSceShaccCg_stub \
  -lopenal -lvorbisfile -lvorbis -logg \
  -lpng -ljpeg -lz -lc -lm -lpthread -lstdc++ \
  -lcurl -lssl -lcrypto -lzstd -lwebp -lwebpmux \
  -Wl,--end-group
  
# Source files
MAIN_SRC = $(wildcard $(SRC_DIR)/*.cpp)
SUPERTUX_SRC = $(wildcard $(SRC_DIR)/supertux/*.cpp)
OBJECT_SRC = $(wildcard $(SRC_DIR)/object/*.cpp)
BADGUY_SRC = $(wildcard $(SRC_DIR)/badguy/*.cpp)
SPRITE_SRC = $(wildcard $(SRC_DIR)/sprite/*.cpp)
CONTROL_SRC = $(wildcard $(SRC_DIR)/control/*.cpp)
MENU_SRC = $(wildcard $(SRC_DIR)/supertux/menu/*.cpp)
GUI_SRC = $(wildcard $(SRC_DIR)/gui/*.cpp) \
          $(wildcard $(SRC_DIR)/gui/menu_storage.cpp)
AUDIO_SRC = $(wildcard $(SRC_DIR)/audio/*.cpp)
MATH_SRC = $(wildcard $(SRC_DIR)/math/*.cpp)
TRIGGER_SRC = $(wildcard $(SRC_DIR)/trigger/*.cpp)
WORLDMAP_SRC = $(wildcard $(SRC_DIR)/worldmap/*.cpp)
VIDEO_SRC = $(wildcard $(SRC_DIR)/video/*.cpp) $(wildcard $(SRC_DIR)/video/sdl/*.cpp) $(wildcard $(SRC_DIR)/video/gl/*.cpp)
PHYSFS_SRC = $(wildcard $(SRC_DIR)/physfs/*.cpp)
UTIL_SRC = $(wildcard $(SRC_DIR)/util/*.cpp)
SCRIPTING_SRC = $(wildcard $(SRC_DIR)/scripting/*.cpp)
LISP_SRC = $(wildcard $(SRC_DIR)/lisp/*.cpp)
ADDON_SRC = $(wildcard $(SRC_DIR)/addon/*.cpp)
SHIMS_SRC = vita_shims.c

# External libraries
TINYGETTEXT_SRC = $(wildcard external/tinygettext/src/*.cpp)
SQUIRREL_SRC = $(wildcard external/squirrel/squirrel/*.cpp) \
  $(wildcard external/squirrel/sqstdlib/*.cpp)
FINDLOCALE_SRC = external/findlocale/findlocale.c
OBSTACK_SRC = external/obstack/obstack.c

# Combine all sources
ALL_SRC = $(MAIN_SRC) $(SUPERTUX_SRC) $(OBJECT_SRC) $(BADGUY_SRC) \
  $(SPRITE_SRC) $(CONTROL_SRC) $(GUI_SRC) $(AUDIO_SRC) $(MATH_SRC) \
  $(TRIGGER_SRC) $(WORLDMAP_SRC) $(VIDEO_SRC) $(PHYSFS_SRC) $(UTIL_SRC) \
  $(SCRIPTING_SRC) $(LISP_SRC) $(ADDON_SRC) $(TINYGETTEXT_SRC) \
  $(SQUIRREL_SRC) $(FINDLOCALE_SRC) $(OBSTACK_SRC) $(MENU_SRC) $(SHIMS_SRC)

# Convert to object files
OBJS = $(patsubst %.c,$(OBJ_DIR)/%.o,$(patsubst %.cpp,$(OBJ_DIR)/%.o,$(ALL_SRC)))

# Default target
all: $(VPK_OUTPUT)

# Create directories
$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(OBJ_DIR)/supertux
	@mkdir -p $(OBJ_DIR)/supertux/menu
	@mkdir -p $(OBJ_DIR)/object
	@mkdir -p $(OBJ_DIR)/badguy
	@mkdir -p $(OBJ_DIR)/sprite
	@mkdir -p $(OBJ_DIR)/control
	@mkdir -p $(OBJ_DIR)/gui
	@mkdir -p $(OBJ_DIR)/audio
	@mkdir -p $(OBJ_DIR)/math
	@mkdir -p $(OBJ_DIR)/trigger
	@mkdir -p $(OBJ_DIR)/worldmap
	@mkdir -p $(OBJ_DIR)/video
	@mkdir -p $(OBJ_DIR)/video/sdl
	@mkdir -p $(OBJ_DIR)/video/gl
	@mkdir -p $(OBJ_DIR)/physfs
	@mkdir -p $(OBJ_DIR)/util
	@mkdir -p $(OBJ_DIR)/scripting
	@mkdir -p $(OBJ_DIR)/lisp
	@mkdir -p $(OBJ_DIR)/addon
	@mkdir -p $(OBJ_DIR)/external/tinygettext/src
	@mkdir -p $(OBJ_DIR)/external/squirrel/squirrel
	@mkdir -p $(OBJ_DIR)/external/squirrel/sqstdlib
	@mkdir -p $(OBJ_DIR)/external/findlocale
	@mkdir -p $(OBJ_DIR)/external/obstack

# Compile C++ files
$(OBJ_DIR)/%.o: %.cpp | $(OBJ_DIR)
	@echo "Compiling $<"
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) -c $< -o $@

# Compile C files
$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	@echo "Compiling $<"
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c $< -o $@

# 1. Link ELF
$(BIN_PATH): $(OBJS)
	@echo "Linking ELF $@"
	@$(CXX) $(OBJS) $(LDFLAGS) $(LIBS) -o $@
	@echo "✓ Built ELF: $@"

# 2. Convert ELF to VELF
$(VELF_PATH): $(BIN_PATH)
	@echo "Converting ELF to VELF: $< -> $@"
	@vita-elf-create $< $@

# 3. Convert VELF to FSELF (eboot.bin)
$(EBOOT_PATH): $(VELF_PATH)
	@echo "Converting VELF to FSELF: $< -> $@"
	@vita-make-fself -c $< $@

# # 4. Pack final VPK (auto-generating param.sfo if missing)
$(VPK_OUTPUT): $(EBOOT_PATH)
	@if [ ! -d "sce_sys" ]; then \
		mkdir -p sce_sys; \
	fi
	@if [ ! -f "sce_sys/param.sfo" ]; then \
		echo "Generating default sce_sys/param.sfo..."; \
		$(SFO) -s TITLE_ID="STUX00040" "SuperTux" sce_sys/param.sfo; \
	fi
	@CMD="$(PACK) $@ --sfo sce_sys/param.sfo --eboot $(EBOOT_PATH)"; \
	if [ -f "sce_sys/icon0.png" ]; then CMD="$$CMD --add sce_sys/icon0.png=sce_sys/icon0.png"; fi; \
	if [ -f "sce_sys/pic0.png" ]; then CMD="$$CMD --add sce_sys/pic0.png=sce_sys/pic0.png"; fi; \
	if [ -d "sce_sys/livearea" ]; then \
		for f in $$(find sce_sys/livearea -type f); do \
			CMD="$$CMD --add $$f=$$f"; \
		done; \
	fi; \
	if [ -d "data" ]; then CMD="$$CMD --add data=data"; fi; \
	eval $$CMD; \
	echo "✓ VPK Package Complete: $@"

# Clean
clean:
	@rm -rf $(BUILD_DIR) $(OUTPUT) $(VPK_OUTPUT)
	@echo "Cleaned"

# Help
help:
	@echo "SuperTux 0.40 PS Vita Makefile"
	@echo "Targets:"
	@echo "  make              - Build, convert, and pack into supertux-vita.vpk"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make help         - Show this help"

.PHONY: all clean help
