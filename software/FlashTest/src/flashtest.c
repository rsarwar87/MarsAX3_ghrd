/******************************************************************************
 * This test is based on Xilinx xspi_intel_flash_example.c
 *
*******************************************************************************/

/* $Id: xspi_intel_flash_example.c,v 1.1.2.1 2010/04/28 11:10:03 svemula Exp $ */
/******************************************************************************
*
* (c) Copyright 2008-2009 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/
/******************************************************************************
*
* @file xspi_intel_flash_example.c
*
* This file contains a design example using the SPI driver (XSpi) and hardware
* device with an Intel Serial Flash Memory (S33) in the interrupt mode.
* This example erases a sector, writes to a Page within the sector, reads back
* from that Page and compares the data.
*
* The example works with an Intel Serial Flash Memory (S33). The number of bytes
* per page in this device is 256. For further details about the device refer to
* the Intel Serial Flash Memory (S33) Data sheet
*
* This example assumes that the underlying processor is MicroBlaze.
*
* @note
*
* None.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a sd   02/26/08 First release
* 3.00a ktn  10/22/09 Converted all register accesses to 32 bit access.
*		      Updated to use the HAL APIs/macros. Replaced call to
*		      XSpi_Initialize API with XSpi_LookupConfig and
*		      XSpi_CfgInitialize.
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xparameters.h"	/* EDK generated parameters */
#include "xintc.h"		/* Interrupt controller device driver */
#include "xspi.h"		/* SPI device driver */
#include "xil_exception.h"
#include "stdio.h"
#include "mb_interface.h"


/************************** Constant Definitions *****************************/


/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define SPI_DEVICE_ID		XPAR_SPI_0_DEVICE_ID
#define INTC_DEVICE_ID		XPAR_INTC_0_DEVICE_ID
#define SPI_INTR_ID			XPAR_INTC_0_SPI_0_VEC_ID

/*
 * The following constant defines the slave select signal that is used to
 * to select the Flash device on the SPI bus, this signal is typically
 * connected to the chip select of the device.
 */
#define INTEL_SPI_SELECT 0x01


/*
 * Definitions of the commands shown in this example.
 */
#define INTEL_COMMAND_RANDOM_READ	0x03 /* Random read command */
#define INTEL_COMMAND_PAGEPROGRAM_WRITE	0x02 /* Page Program command */
#define	INTEL_COMMAND_WRITE_ENABLE	0x06 /* Write Enable command */
#define INTEL_COMMAND_SECTOR_ERASE	0xD8 /* Sector Erase command */
#define INTEL_COMMAND_BULK_ERASE	0xC7 /* Bulk Erase command */
#define INTEL_COMMAND_STATUSREG_READ	0x05 /* Status read command */
#define INTEL_COMMAND_STATUSREG_WRITE	0x01 /* Status write command */
#define INTEL_COMMAND_READ_ID			0x9F /* Read ID command */

/*
 * This definitions specify the EXTRA bytes for each of the command
 * transactions. This count includes command byte, address bytes and any
 * don't care bytes needed.
 */
#define INTEL_READ_WRITE_EXTRA_BYTES	4 /* Read/Write extra bytes */
#define	INTEL_WRITE_ENABLE_BYTES	1 /* Write Enable bytes */
#define INTEL_SECTOR_ERASE_BYTES	4 /* Sector erase extra bytes */
#define INTEL_BULK_ERASE_BYTES		1 /* Bulk erase extra bytes */
#define INTEL_STATUS_READ_BYTES		2 /* Status read bytes count */
#define INTEL_STATUS_WRITE_BYTES	2 /* Status write bytes count */

/*
 * Flash not busy mask in the status register of the flash device.
 */
#define INTEL_FLASH_SR_IS_READY_MASK	0x01 /* Ready mask */

/*
 * Sector protection disable mask in the status register for all the sectors of
 * the flash device.
 */
#define INTEL_DISABLE_PROTECTION_ALL	0x00

/*
 * Number of bytes per page in the flash device.
 */
#define INTEL_FLASH_PAGE_SIZE		256


/*
 * Address of the page to perform Erase, Write and Read operations.
 */
int FLASH_TEST_ADDRESS = 0;

/*
 * Byte offset value written to Flash. This needs to redefined for writing
 * different patterns of data to the Flash device.
 */
#define INTEL_FLASH_TEST_BYTE	 0x20

/*
 * Byte Positions.
 */
#define BYTE1			0 /* Byte 1 position */
#define BYTE2			1 /* Byte 2 position */
#define BYTE3			2 /* Byte 3 position */
#define BYTE4			3 /* Byte 4 position */
#define BYTE5			4 /* Byte 5 position */

#define INTEL_DUMMYBYTE		0xFF /* Dummy byte */

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

int SpiIntelFlashWriteEnable(XSpi *SpiPtr);
int SpiIntelFlashWrite(XSpi *SpiPtr, u32 Addr, u32 ByteCount);
int SpiIntelFlashRead(XSpi *SpiPtr, u32 Addr, u32 ByteCount);
int SpiIntelFlashBulkErase(XSpi *SpiPtr);
int SpiIntelFlashSectorErase(XSpi *SpiPtr, u32 Addr);
int SpiIntelFlashGetStatus(XSpi *SpiPtr);
int SpiIntelFlashWriteStatus(XSpi *SpiPtr, u8 StatusRegister);
int SpiFlashReadID(XSpi *SpiPtr);
static int SpiIntelFlashWaitForFlashNotBusy(void);
void SpiHandler(void *CallBackRef, u32 StatusEvent, unsigned int ByteCount);
static int SetupInterruptSystem(XSpi *SpiPtr);

/************************** Variable Definitions *****************************/

/*
 * The instances to support the device drivers are global such that they
 * are initialized to zero each time the program runs. They could be local
 * but should at least be static so they are zeroed.
 */
static XIntc InterruptController;
static XSpi Spi;

/*
 * The following variables are shared between non-interrupt processing and
 * interrupt processing such that they must be global.
 */
volatile static int TransferInProgress;

/*
 * The following variable tracks any errors that occur during interrupt
 * processing.
 */
int ErrorCount;

/*
 * Buffers used during read and write transactions.
 */
u8 ReadBuffer[INTEL_FLASH_PAGE_SIZE + INTEL_READ_WRITE_EXTRA_BYTES];
u8 WriteBuffer[INTEL_FLASH_PAGE_SIZE + INTEL_READ_WRITE_EXTRA_BYTES];

/************************** Function Definitions ******************************/

int SpiFlashTest();
int ModuleFlashTest(int Addr, int Wait);

/*****************************************************************************/
/**
*
* Main function to execute the Flash example.
*
* @param	None
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		None
*
******************************************************************************/
int main(){
	int status;
	int FlashSize = 16;
	status = ModuleFlashTest((FlashSize-1)*0x100000, 1);

	while (1);
	return status;
}

/*****************************************************************************/
/**
*
* Generate some text output for the flash test
*
* @param	Addr is the offeset in bytes
* @param	Wait controls if the users is asked to press a key or not
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		None
*
******************************************************************************/

int ModuleFlashTest(int Addr, int Wait){
	int Status;
	int c, i;

	microblaze_enable_icache();
	microblaze_enable_dcache();

	// clear screen
	for (i=0; i<40; i++)
		xil_printf("\r\n");

	xil_printf("\r\n\r\n-- SPI Flash Test --\r\n\r\n");
	if (Wait){
		xil_printf("WARNING: This test will erase 1 Sector at address 0x%x\r\n", Addr);
		xil_printf("\n\rPress Enter to continue or 'n' to abort\n\r");
		c = getchar();
		if (c == 'n'){
			xil_printf("\n\r-- Flash Test aborted! --\n\r");
			return 1;
		}
	} else
		xil_printf("Testing SPI Flash at offset %dMB\r\n", Addr/1024/1024);

	FLASH_TEST_ADDRESS = Addr;
	Status = SpiFlashTest();
	if (Status == XST_SUCCESS)
		xil_printf("\r\nSPI Flash successfully tested!\r\n");
	else
		xil_printf("\r\nSPI Flash error!\r\n");

	xil_printf("\n\r-- SPI Flash Test Complete --\n\r");

	return Status;
}


/*****************************************************************************/
/**
*
* SpiFlashTest contains the actual test
*
* @param	None
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		None
*
******************************************************************************/
int SpiFlashTest()
{
	int Status;
	u32 Index;
	u32 Address;
	XSpi_Config *ConfigPtr;	/* Pointer to Configuration data */

	/*
	 * Initialize the SPI driver so that it is  ready to use.
	 */
	ConfigPtr = XSpi_LookupConfig(SPI_DEVICE_ID);
	if (ConfigPtr == NULL) {
		return XST_DEVICE_NOT_FOUND;
	}

	Status = XSpi_CfgInitialize(&Spi, ConfigPtr,
				  ConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Connect the SPI driver to the interrupt subsystem such that
	 * interrupts can occur. This function is application specific.
	 */
	Status = SetupInterruptSystem(&Spi);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Setup the handler for the SPI that will be called from the interrupt
	 * context when an SPI status occurs, specify a pointer to the SPI
	 * driver instance as the callback reference so the handler is able to
	 * access the instance data.
	 */
	XSpi_SetStatusHandler(&Spi, &Spi, (XSpi_StatusHandler)SpiHandler);

	/*
	 * Set the SPI device as a master and in manual slave select mode such
	 * that the slave select signal does not toggle for every byte of a
	 * transfer, this must be done before the slave select is set.
	 */
	Status = XSpi_SetOptions(&Spi, XSP_MASTER_OPTION |
						XSP_MANUAL_SSELECT_OPTION);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Select the Intel Serial Flash device,  so that it can be
	 * read and written using the SPI bus.
	 */
	Status = XSpi_SetSlaveSelect(&Spi, INTEL_SPI_SELECT);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Start the SPI driver so that interrupts and the device are enabled.
	 */
	XSpi_Start(&Spi);

	/*
	 * Read Flash ID
	 */
//	Status = SpiFlashReadID(&Spi);
//	if(Status != XST_SUCCESS) {
//		return XST_FAILURE;
//	}

	/*
	 * Perform the Write Enable operation.
	 */
	Status = SpiIntelFlashWriteEnable(&Spi);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Disable the sector protection
	 */
	Status = SpiIntelFlashWriteStatus(&Spi, INTEL_DISABLE_PROTECTION_ALL);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Specify the address in the flash device for the Erase/Write/Read
	 * operations.
	 */
	Address = FLASH_TEST_ADDRESS;

	/*
	 * Perform the Write Enable operation.
	 */
	Status = SpiIntelFlashWriteEnable(&Spi);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Perform the Sector Erase operation.
	 */
	Status = SpiIntelFlashSectorErase(&Spi, Address);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Perform the Write Enable operation.
	 */
	xil_printf("   writing to SPI Flash\r\n");
	Status = SpiIntelFlashWriteEnable(&Spi);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Write the data to the Page.
	 * Perform the Write operation.
	 */
	Status = SpiIntelFlashWrite(&Spi, Address, INTEL_FLASH_PAGE_SIZE);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	/*
	 * Clear the read Buffer.
	 */
	for(Index = 0; Index < INTEL_FLASH_PAGE_SIZE +
			INTEL_READ_WRITE_EXTRA_BYTES; Index++) {
		ReadBuffer[Index] = 0x0;
	}

	/*
	 * Read the data from the Page.
	 */
	xil_printf("   reading from SPI Flash\r\n");
	Status = SpiIntelFlashRead(&Spi, Address, INTEL_FLASH_PAGE_SIZE);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	/*
	 * Compare the data read against the data that was Written.
	 */
	for(Index = 0; Index < INTEL_FLASH_PAGE_SIZE; Index++) {
		if(ReadBuffer[Index + INTEL_READ_WRITE_EXTRA_BYTES] !=
					(u8)(Index + INTEL_FLASH_TEST_BYTE)) {
			xil_printf("   Error on readback data!\r\n");
			return XST_FAILURE;
		}
	}

	/*
	 * Perform the Write Enable operation.
	 */
	Status = SpiIntelFlashWriteEnable(&Spi);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Specify the address in the flash device for the Erase/Write/Read
	 * operations.
	 */
	Address = FLASH_TEST_ADDRESS;

	/*
	 * Perform the Write Enable operation.
	 */
	Status = SpiIntelFlashWriteEnable(&Spi);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Perform the Sector Erase operation.
	 */
	Status = SpiIntelFlashSectorErase(&Spi, Address);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Flash is not Busy.
	 */
	Status = SpiIntelFlashWaitForFlashNotBusy();
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function enables writes to the Intel Serial Flash memory.
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		None.
*
******************************************************************************/
int SpiIntelFlashWriteEnable(XSpi *SpiPtr)
{
	int Status;

	/*
	 * Prepare the WriteBuffer.
	 */
	WriteBuffer[BYTE1] = INTEL_COMMAND_WRITE_ENABLE;

	/*
	 * Initiate the Transfer.
	 */
	TransferInProgress = TRUE;
	Status = XSpi_Transfer(SpiPtr, WriteBuffer, NULL,
				INTEL_WRITE_ENABLE_BYTES);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Transfer is complete and check if there are any errors
	 * in the transaction..
	 */
	while(TransferInProgress);
	if(ErrorCount != 0) {
		ErrorCount = 0;
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function writes the data to the specified locations in the Intel Serial
* Flash memory.
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
* @param	Addr is the address in the Buffer, where to write the data.
* @param	ByteCount is the number of bytes to be written.
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		A minimum of one byte and a maximum of one Page can be written
*		using this API.
*
******************************************************************************/
int SpiIntelFlashWrite(XSpi *SpiPtr, u32 Addr, u32 ByteCount)
{
	u32 Index;
	int Status;

	/*
	 * Prepare the WriteBuffer.
	 */
	WriteBuffer[BYTE1] = INTEL_COMMAND_PAGEPROGRAM_WRITE;
	WriteBuffer[BYTE2] = (u8) (Addr >> 16);
	WriteBuffer[BYTE3] = (u8) (Addr >> 8);
	WriteBuffer[BYTE4] = (u8) Addr;


	/*
	 * Fill in the TEST data that is to be written into the STM Serial Flash
	 * device.
	 */
	for(Index = 4; Index < ByteCount + INTEL_READ_WRITE_EXTRA_BYTES;
						Index++) {
		WriteBuffer[Index] = (u8)((Index - 4) + INTEL_FLASH_TEST_BYTE);
	}

	/*
	 * Initiate the Transfer.
	 */
	TransferInProgress = TRUE;
	Status = XSpi_Transfer(SpiPtr, WriteBuffer, NULL,
				(ByteCount + INTEL_READ_WRITE_EXTRA_BYTES));
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Transfer is complete and check if there are any errors
	 * in the transaction..
	 */
	while(TransferInProgress);
	if(ErrorCount != 0) {
		ErrorCount = 0;
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function reads the data from the Intel Serial Flash Memory
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
* @param	Addr is the starting address in the Flash Memory from which the
*		data is to be read.
* @param	ByteCount is the number of bytes to be read.
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		None.
*
******************************************************************************/
int SpiIntelFlashRead(XSpi *SpiPtr, u32 Addr, u32 ByteCount)
{
	int Status;

	/*
	 * Prepare the WriteBuffer.
	 */
	WriteBuffer[BYTE1] = INTEL_COMMAND_RANDOM_READ;
	WriteBuffer[BYTE2] = (u8) (Addr >> 16);
	WriteBuffer[BYTE3] = (u8) (Addr >> 8);
	WriteBuffer[BYTE4] = (u8) Addr;

	/*
	 * Initiate the Transfer.
	 */
	TransferInProgress = TRUE;
	Status = XSpi_Transfer( SpiPtr, WriteBuffer, ReadBuffer,
				(ByteCount + INTEL_READ_WRITE_EXTRA_BYTES));
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Transfer is complete and check if there are any errors
	 * in the transaction..
	 */
	while(TransferInProgress);
	if(ErrorCount != 0) {
		ErrorCount = 0;
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function erases the entire contents of the Intel Serial Flash.
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		The erased bytes will read as 0xFF.
*
******************************************************************************/
int SpiIntelFlashBulkErase(XSpi *SpiPtr)
{
	int Status;

	/*
	 * Prepare the WriteBuffer.
	 */
	WriteBuffer[BYTE1] = INTEL_COMMAND_BULK_ERASE;

	/*
	 * Initiate the Transfer.
	 */
	TransferInProgress = TRUE;
	Status = XSpi_Transfer(SpiPtr, WriteBuffer, NULL,
					INTEL_BULK_ERASE_BYTES);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Transfer is complete and check if there are any errors
	 * in the transaction..
	 */
	while(TransferInProgress);
	if(ErrorCount != 0) {
		ErrorCount = 0;
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function erases the contents of the specified Sector in the Intel Serial
* Flash.
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
* @param	Addr is the address within a sector of the Buffer, which is to
*		be erased.
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		The erased bytes will read as 0xFF.
*
******************************************************************************/
int SpiIntelFlashSectorErase(XSpi *SpiPtr, u32 Addr)
{
	int Status;

	/*
	 * Prepare the WriteBuffer.
	 */
	WriteBuffer[BYTE1] = INTEL_COMMAND_SECTOR_ERASE;
	WriteBuffer[BYTE2] = (u8) (Addr >> 16);
	WriteBuffer[BYTE3] = (u8) (Addr >> 8);
	WriteBuffer[BYTE4] = (u8) (Addr);

	/*
	 * Initiate the Transfer.
	 */
	TransferInProgress = TRUE;
	Status = XSpi_Transfer(SpiPtr, WriteBuffer, NULL,
				INTEL_SECTOR_ERASE_BYTES);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Transfer is complete and check if there are any errors
	 * in the transaction.
	 */
	while(TransferInProgress);
	if(ErrorCount != 0) {
		ErrorCount = 0;
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function reads the Status register of the Intel Serial Flash.
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		The status register content is stored at the second byte pointed
*		by the ReadBuffer.
*
******************************************************************************/
int SpiIntelFlashGetStatus(XSpi *SpiPtr)
{
	int Status;

	/*
	 * Prepare the Write Buffer.
	 */
	WriteBuffer[BYTE1] = INTEL_COMMAND_STATUSREG_READ;

	/*
	 * Initiate the Transfer.
	 */
	TransferInProgress = TRUE;
	Status = XSpi_Transfer(SpiPtr, WriteBuffer, ReadBuffer,
						INTEL_STATUS_READ_BYTES);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Transfer is complete and check if there are any errors
	 * in the transaction.
	 */
	while(TransferInProgress);
	if(ErrorCount != 0) {
		ErrorCount = 0;
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function writes to the Status register of the Intel Flash.
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
* @param	StatusRegister is the value to be written to the status register
* 		of the flash device.
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		The status register content is stored at the second byte pointed
*		by the ReadPtr.
*
******************************************************************************/
int SpiIntelFlashWriteStatus(XSpi *SpiPtr, u8 StatusRegister)
{
	int Status;

	/*
	 * Prepare the Write Buffer.
	 */
	WriteBuffer[BYTE1] = INTEL_COMMAND_STATUSREG_WRITE;
	WriteBuffer[BYTE2] = StatusRegister;

	/*
	 * Initiate the Transfer.
	 */
	TransferInProgress = TRUE;
	Status = XSpi_Transfer(SpiPtr, WriteBuffer, NULL,
				INTEL_STATUS_WRITE_BYTES);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Transfer is complete and check if there are any errors
	 * in the transaction..
	 */
	while(TransferInProgress);
	if(ErrorCount != 0) {
		ErrorCount = 0;
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}


/*****************************************************************************/
/**
*
* This function reads and prints the flash IO.
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note
*
******************************************************************************/
int SpiFlashReadID(XSpi *SpiPtr)
{
	int Status;

	/*
	 * Prepare the Write Buffer.
	 */
	WriteBuffer[BYTE1] = INTEL_COMMAND_READ_ID;
	WriteBuffer[BYTE2] = 0x23;		/* 3 dummy bytes */
	WriteBuffer[BYTE3] = 0x08;
	WriteBuffer[BYTE4] = 0x09;

	/*
	 * Initiate the Transfer.
	 */
	TransferInProgress = TRUE;
	Status = XSpi_Transfer(SpiPtr, WriteBuffer, ReadBuffer, 4);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Wait till the Transfer is complete and check if there are any errors
	 * in the transaction..
	 */
	while(TransferInProgress);
	if(ErrorCount != 0) {
		ErrorCount = 0;
		return XST_FAILURE;
	}

	xil_printf("FlashID=0x%x 0x%x 0x%x\n\r", ReadBuffer[1], ReadBuffer[2], ReadBuffer[3]);

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function waits till the Intel Serial Flash is ready to accept next
* command.
*
* @param	None
*
* @return	XST_SUCCESS if successful else XST_FAILURE.
*
* @note		This function reads the status register of the Buffer and waits
*.		till the WIP bit of the status register becomes 0.
*
******************************************************************************/
int SpiIntelFlashWaitForFlashNotBusy(void)
{
	int Status;
	u8 StatusReg;

	while(1) {

		/*
		 * Get the Status Register.
		 */
		Status = SpiIntelFlashGetStatus(&Spi);
		if(Status != XST_SUCCESS) {
			return XST_FAILURE;
		}

		/*
		 * Check if the flash is ready to accept the next command.
		 * If so break.
		 */
		StatusReg = ReadBuffer[1];
		if((StatusReg & INTEL_FLASH_SR_IS_READY_MASK) == 0) {
			break;
		}
	}

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function is the handler which performs processing for the SPI driver.
* It is called from an interrupt context such that the amount of processing
* performed should be minimized. It is called when a transfer of SPI data
* completes or an error occurs.
*
* This handler provides an example of how to handle SPI interrupts and
* is application specific.
*
* @param	CallBackRef is the upper layer callback reference passed back
*		when the callback function is invoked.
* @param	StatusEvent is the event that just occurred.
* @param	ByteCount is the number of bytes transferred up until the event
*		occurred.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void SpiHandler(void *CallBackRef, u32 StatusEvent, unsigned int ByteCount)
{
	/*
	 * Indicate the transfer on the SPI bus is no longer in progress
	 * regardless of the status event.
	 */
	TransferInProgress = FALSE;

	/*
	 * If the event was not transfer done, then track it as an error.
	 */
	if (StatusEvent != XST_SPI_TRANSFER_DONE) {
		ErrorCount++;
	}
}

/*****************************************************************************/
/**
*
* This function setups the interrupt system such that interrupts can occur
* for the Spi device. This function is application specific since the actual
* system may or may not have an interrupt controller. The Spi device could be
* directly connected to a processor without an interrupt controller.  The
* user should modify this function to fit the application.
*
* @param	SpiPtr is a pointer to the instance of the Spi device.
*
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note		None
*
******************************************************************************/
static int SetupInterruptSystem(XSpi *SpiPtr)
{

	int Status;

	/*
	 * Initialize the interrupt controller driver so that
	 * it's ready to use, specify the device ID that is generated in
	 * xparameters.h
	 */
	Status = XIntc_Initialize(&InterruptController, INTC_DEVICE_ID);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Connect a device driver handler that will be called when an interrupt
	 * for the device occurs, the device driver handler performs the
	 * specific interrupt processing for the device
	 */
	Status = XIntc_Connect(&InterruptController,
				SPI_INTR_ID,
				(XInterruptHandler)XSpi_InterruptHandler,
				(void *)SpiPtr);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Start the interrupt controller such that interrupts are enabled for
	 * all devices that cause interrupts, specific real mode so that
	 * the SPI can cause interrupts thru the interrupt controller.
	 */
	Status = XIntc_Start(&InterruptController, XIN_REAL_MODE);
	if(Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Enable the interrupt for the SPI.
	 */
	XIntc_Enable(&InterruptController, SPI_INTR_ID);


	/*
	 * Initialize the exception table
	 */
	Xil_ExceptionInit();

	/*
	 * Register the interrupt controller handler with the exception table
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)XIntc_InterruptHandler,
			 &InterruptController);

	/*
	 * Enable non-critical exceptions
	 */
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

