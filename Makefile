# ----------------------------------------
# Project Config

TARGET_EXEC := $(shell basename $(shell pwd))
BUILD_DIR := ./build

C_DIR := ./c
CXX_DIR := ./c++
ASM_DIR := ./asm
RUST_DIR := ./rust

SRC_DIRS := ./src ./lib $(C_DIR) $(CXX_DIR) $(ASM_DIR) $(RUST_DIR)/src

LDFLAGS := -L$(BUILD_DIR) -no-pie -lc

# ----------------------------------------
# C/C++/ASM Config

# All the files we want to compile
SRCS := $(shell find $(SRC_DIRS) -regex ".*\.\(c\|s\|cpp\|asm\|S\)" 2>/dev/null)

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d 2>/dev/null)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS := $(INC_FLAGS) -MMD -MP -fPIE

ASMFLAGS := -f elf64

# ----------------------------------------
# Rust Config

# for multiple rust libs
# RUST_CRATES := $(shell find $(RUST_DIR)/src -maxdepth 1 -type d 2>/dev/null)

# for a single rust lib
RUST_CRATES := $(shell basename $(RUST_DIR))

RUST_SRCS := $(shell find $(RUST_CRATES) -regex ".*\.\(rs\|toml\)" 2>/dev/null)

RUST_OBJS := $(RUST_CRATES:%=$(BUILD_DIR)/%.rs.so)
RUST_DS := $(RUST_CRATES:%=$(BUILD_DIR)/%.rs.d)

CARGO_FLAGS := --release


# ----------------------------------------
# Project Build

# Build the final binary
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS) $(RUST_OBJS) $(RUST_DS)
	$(CC) $(OBJS) $(RUST_OBJS) -o $@ $(LDFLAGS)

# ----------------------------------------
# C/C++/ASM Build

# Build .c files
$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Build .cpp files
$(BUILD_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

# Build .asm files
$(BUILD_DIR)/%.asm.o: %.asm
	mkdir -p $(dir $@)
	nasm $(ASMFLAGS) $< -o $@

# ----------------------------------------
# Rust Build

$(BUILD_DIR)/%.rs.d: $(RUST_SRCS)
	mkdir -p $(dir $@)
	cd $(RUST_DIR) && cargo build $(CARGO_FLAGS)
	cp $(RUST_DIR)/target/release/*.d $@

# Build .rs files
$(BUILD_DIR)/%.rs.so: $(BUILD_DIR)/%.rs.d
	cp $(RUST_DIR)/target/release/*.so $@

# ----------------------------------------
# Build Commands

.PHONY: run
run: $(BUILD_DIR)/$(TARGET_EXEC)
	@echo ---
	@LD_LIBRARY_DIR=$(BUILD_DIR) $(BUILD_DIR)/$(TARGET_EXEC)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	$(addprefix rm -rf ,$(addsuffix /target,$(RUST_CRATES)))

# ----------------------------------------
# Other

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want
# those errors to show up.
-include $(DEPS)
