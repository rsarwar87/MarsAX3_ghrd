################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/AtmelAtsha204a.c \
../src/CurrentMonitor.c \
../src/I2cExample.c \
../src/I2cInterface.c \
../src/InterruptController.c \
../src/ModuleConfigConstants.c \
../src/ModuleConfigValueKeys.c \
../src/ModuleEeprom.c \
../src/ReadSystemMonitor.c \
../src/RealtimeClock.c \
../src/SystemController.c \
../src/SystemMonitor.c \
../src/TimerInterface.c 

OBJS += \
./src/AtmelAtsha204a.o \
./src/CurrentMonitor.o \
./src/I2cExample.o \
./src/I2cInterface.o \
./src/InterruptController.o \
./src/ModuleConfigConstants.o \
./src/ModuleConfigValueKeys.o \
./src/ModuleEeprom.o \
./src/ReadSystemMonitor.o \
./src/RealtimeClock.o \
./src/SystemController.o \
./src/SystemMonitor.o \
./src/TimerInterface.o 

C_DEPS += \
./src/AtmelAtsha204a.d \
./src/CurrentMonitor.d \
./src/I2cExample.d \
./src/I2cInterface.d \
./src/InterruptController.d \
./src/ModuleConfigConstants.d \
./src/ModuleConfigValueKeys.d \
./src/ModuleEeprom.d \
./src/ReadSystemMonitor.d \
./src/RealtimeClock.d \
./src/SystemController.d \
./src/SystemMonitor.d \
./src/TimerInterface.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I/media/wkspace/wkspace1/fpga/AX3_MARS/Vivado_PM3/MarsAX3_PM3.sdk/standalone_bsp_0/CPU_microblaze_0/include -mlittle-endian -mcpu=v11.0 -mxl-soft-mul -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


