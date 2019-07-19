################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/dispatch.c \
../src/echo.c \
../src/http_response.c \
../src/main.c \
../src/platform.c \
../src/platform_fs.c \
../src/platform_gpio.c \
../src/platform_ppc.c \
../src/platform_zynq.c \
../src/prot_malloc.c \
../src/rxperf.c \
../src/tftpserver.c \
../src/tftputils.c \
../src/txperf.c \
../src/urxperf.c \
../src/utxperf.c \
../src/web_utils.c \
../src/webserver.c \
../src/xaxiemacif_physpeed.c 

OBJS += \
./src/dispatch.o \
./src/echo.o \
./src/http_response.o \
./src/main.o \
./src/platform.o \
./src/platform_fs.o \
./src/platform_gpio.o \
./src/platform_ppc.o \
./src/platform_zynq.o \
./src/prot_malloc.o \
./src/rxperf.o \
./src/tftpserver.o \
./src/tftputils.o \
./src/txperf.o \
./src/urxperf.o \
./src/utxperf.o \
./src/web_utils.o \
./src/webserver.o \
./src/xaxiemacif_physpeed.o 

C_DEPS += \
./src/dispatch.d \
./src/echo.d \
./src/http_response.d \
./src/main.d \
./src/platform.d \
./src/platform_fs.d \
./src/platform_gpio.d \
./src/platform_ppc.d \
./src/platform_zynq.d \
./src/prot_malloc.d \
./src/rxperf.d \
./src/tftpserver.d \
./src/tftputils.d \
./src/txperf.d \
./src/urxperf.d \
./src/utxperf.d \
./src/web_utils.d \
./src/webserver.d \
./src/xaxiemacif_physpeed.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze gcc compiler'
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I/media/wkspace/wkspace1/fpga/AX3_MARS/Vivado_PM3/MarsAX3_PM3.sdk/standalone_bsp_0/CPU_microblaze_0/include -mlittle-endian -mcpu=v11.0 -mxl-soft-mul -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


