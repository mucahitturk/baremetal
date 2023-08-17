# Toolchain
CC = arm-none-eabi-gcc

# Directories
BUILD_DIR 	= ./build
SOURCE_DIR 	= ./src
INCLUDE_DIR = ./inc
OBJ_DIR		= $(BUILD_DIR)/obj
BIN_DIR		= $(BUILD_DIR)/bin
# Files
TARGET = blink

SOURCES = 	$(SOURCE_DIR)/main.c \
			$(SOURCE_DIR)/stm32_startup.c \
			$(SOURCE_DIR)/syscalls.c \

#OBJECT_NAMES = $(SOURCES:.c=.o)
#OBJECTS =  $(patsubst %,$(OBJ_DIR)/%,$(OBJECT_NAMES))

OBJECTS	=	$(OBJ_DIR)/main.o \
			$(OBJ_DIR)/stm32_startup.o \
			$(OBJ_DIR)/syscalls.o \

# Flags
CPU = cortex-m4
WFLAGS 	= -Wall -Werror -Wshadow
CFLAGS 	= -mcpu=$(CPU) $(WFLAGS) $(addprefix -I,$(INCLUDE_DIR)) --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -std=gnu11 -O0 -g3
LDFLAGS = -mcpu=$(CPU) --specs=nano.specs -mfpu=fpv4-sp-d16 -mthumb -mfloat-abi=hard -T$(SOURCE_DIR)/stm32_ls.ld -Wl,-Map=$(BIN_DIR)/$(TARGET).map

# Compiling
$(OBJ_DIR)/%.o : $(SOURCE_DIR)/%.c
	$(CC) -c $(CFLAGS)  $^ -o $@

# Linking
$(BIN_DIR)/$(TARGET).elf:$(OBJECTS)
	$(CC) $(LDFLAGS) $^ -o $@	

# Creating .bin file
$(BIN_DIR)/$(TARGET).bin : $(BIN_DIR)/$(TARGET).elf
	arm-none-eabi-objcopy -O binary $^ $@

# flash .bin file to mcu using st flash
flash:$(BIN_DIR)/$(TARGET).elf $(BIN_DIR)/$(TARGET).bin size
	st-flash --reset write $(BIN_DIR)/$(TARGET).bin 0x80000000
	
clean:
	rm -f $(OBJ_DIR)/*.o	
	rm -f $(BIN_DIR)/*.elf
	rm -f $(BIN_DIR)/*.map
	rm -f $(BIN_DIR)/*.bin

size:
	arm-none-eabi-size $(BIN_DIR)/$(TARGET).elf

.PHONY = all clean size flash