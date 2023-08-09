CC = arm-none-eabi-gcc
CPU = cortex-m4
CFLAGS = -c -mcpu=$(CPU) -mthumb -mfloat-abi=soft -std=gnu11 -Wall -O0
BUILD_DIR = ./build
SRC_DIR = ./src
PROJECT_NAME = blink
LD_FLAGS = -mcpu=$(CPU) -mthumb -mfloat-abi=soft --specs=nano.specs -Tstm32_ls.ld -Wl,-Map=$(BUILD_DIR)/$(PROJECT_NAME).map

all:$(BUILD_DIR)/main.o \
	$(BUILD_DIR)/stm32_startup.o \
	$(BUILD_DIR)/syscalls.o \
	$(BUILD_DIR)/$(PROJECT_NAME).elf \
	size \

#compile main file
$(BUILD_DIR)/main.o : $(SRC_DIR)/main.c
	$(CC) $(CFLAGS)  $^ -o $@
#compile startup file
$(BUILD_DIR)/stm32_startup.o : stm32_startup.c
	$(CC) $(CFLAGS)  $^ -o $@
#compile syscalls file
$(BUILD_DIR)/syscalls.o : syscalls.c
	$(CC) $(CFLAGS)  $^ -o $@
#creating .elf file
$(BUILD_DIR)/$(PROJECT_NAME).elf : $(BUILD_DIR)/main.o $(BUILD_DIR)/stm32_startup.o $(BUILD_DIR)/syscalls.o 
	$(CC) $(LD_FLAGS) $^ -o $@
#creating .bin file
$(BUILD_DIR)/$(PROJECT_NAME).bin : $(BUILD_DIR)/$(PROJECT_NAME).elf
	arm-none-eabi-objcopy -O binary $^ $@
#flash .bin file to mcu using st flash
flash:$(BUILD_DIR)/$(PROJECT_NAME).elf $(BUILD_DIR)/$(PROJECT_NAME).bin
	st-flash --reset write $(BUILD_DIR)/$(PROJECT_NAME).bin 0x80000000
	
clean:
	rm -f $(BUILD_DIR)/*.o	
	rm -f $(BUILD_DIR)/*.elf
	rm -f $(BUILD_DIR)/*.map

size:
	arm-none-eabi-size $(BUILD_DIR)/$(PROJECT_NAME).elf

.PHONY = all clean size flash