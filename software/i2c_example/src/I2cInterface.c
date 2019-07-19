/** \file I2cInterface.c
 * \brief Implementation file for I2C interface functions.
 * \author Garry Jeromson
 * \date 18.06.15
 */

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------

#include "I2cInterface.h"
#include "I2cInterfaceVariables.h"
#include "SystemDefinitions.h"
#include "UtilityFunctions.h"


//-------------------------------------------------------------------------------------------------
// Global variable definitions
//-------------------------------------------------------------------------------------------------

XIic g_XIicInstance;


volatile bool g_i2cTransmissionInProgress;
volatile bool g_i2cReceiveInProgress;
volatile bool g_i2cSlaveNack;

//-------------------------------------------------------------------------------------------------
// Function definitions
//-------------------------------------------------------------------------------------------------


/*****************************************************************************/
/**
 * This Send handler is called asynchronously from an interrupt context and
 * indicates that data in the specified buffer has been sent.
 *
 * @param	InstancePtr is a pointer to the IIC driver instance for which
 * 			the handler is being called for.
 *
 * @return	None.
 *
 * @note	None.
 *
 ******************************************************************************/
void SendHandler(XIic* InstancePtr)
{
    g_i2cTransmissionInProgress = false;
}


/*****************************************************************************/
/**
 * This Receive handler is called asynchronously from an interrupt context and
 * indicates that data in the specified buffer has been Received.
 *
 * @param	InstancePtr is a pointer to the IIC driver instance for which
 * 			the handler is being called for.
 *
 * @return	None.
 *
 * @note		None.
 *
 ******************************************************************************/
void ReceiveHandler(XIic* InstancePtr)
{
    g_i2cReceiveInProgress = false;
}


/**
 * This Status handler is called asynchronously from an interrupt
 * context and indicates the events that have occurred.
 *
 * @param	InstancePtr is a pointer to the IIC driver instance for which
 *		the handler is being called for.
 * @param	Event indicates the condition that has occurred.
 *
 * @return	None.
 *
 * @note		None.
 *
 */
void StatusHandler(XIic* InstancePtr, int event)
{
    switch (event)
    {
    case XII_SLAVE_NO_ACK_EVENT:
    {
        g_i2cSlaveNack = true;
        break;
    }
    case XII_GENERAL_CALL_EVENT:
    {
        break;
    }
    default:
        break;
    }
}


EN_RESULT InitialiseI2cInterface()
{
    int status = XIic_Initialize(&g_XIicInstance, IIC_DEVICE_ID);
    if (status != XST_SUCCESS)
    {
        return EN_ERROR_FAILED_TO_INITIALISE_I2C_CONTROLLER;
    }

    // Set the Transmit and Receive handlers
    XIic_SetSendHandler(&g_XIicInstance, &g_XIicInstance, (XIic_Handler)SendHandler);
    XIic_SetRecvHandler(&g_XIicInstance, &g_XIicInstance, (XIic_Handler)ReceiveHandler);
    XIic_SetStatusHandler(&g_XIicInstance, &g_XIicInstance, (XIic_StatusHandler)StatusHandler);

    // To wake the Atmel ATSHA204A EEPROM device, we have to set the I2C SDA line low for 8 cycles;
    // this is achieved in practice by a general write to device address 0. The Xilinx I2C driver
    // reacts as if it is addressed as a slave in this case, so we have to include this functionality -
    // not doing so results in an infinite loop in the XIic_AddrAsSlaveFuncPtr stub function.
    XIic_SlaveInclude();

    return EN_SUCCESS;
}


EN_RESULT I2cWrite_NoSubAddress(uint8_t deviceAddress, const uint8_t* pWriteBuffer, uint32_t numberOfBytesToWrite)
{
    if (pWriteBuffer == NULL)
    {
        return EN_ERROR_NULL_POINTER;
    }

    if (numberOfBytesToWrite == 0)
    {
        return EN_ERROR_INVALID_ARGUMENT;
    }

#ifdef _DEBUG
    xil_printf("I2C: Writing %d bytes to device address 0x%x\r\n", numberOfBytesToWrite, deviceAddress);
#endif

    RETURN_IF_XILINX_CALL_FAILED(XIic_SetAddress(&g_XIicInstance, XII_ADDR_TO_SEND_TYPE, deviceAddress),
                                 EN_ERROR_FAILED_TO_SET_I2C_DEVICE_ADDRESS);

    // Set the transmission flags.
    g_i2cTransmissionInProgress = true;
    g_i2cSlaveNack = false;

    // Start the IIC device.
    RETURN_IF_XILINX_CALL_FAILED(XIic_Start(&g_XIicInstance), EN_ERROR_FAILED_TO_START_XIIC_DEVICE);

    // Set the transfer options.
    g_XIicInstance.Options = 0;

    RETURN_IF_XILINX_CALL_FAILED(XIic_MasterSend(&g_XIicInstance, (uint8_t*)pWriteBuffer, numberOfBytesToWrite),
                                 EN_ERROR_XIIC_SEND_FAILED);


    // Wait till data is transmitted.
    unsigned int timeout = 0;
    while ((g_i2cTransmissionInProgress /*&& !g_i2cSlaveNack*/) || (XIic_IsIicBusy(&g_XIicInstance) == TRUE))
    {
        timeout++;
        if (timeout > 100000 * numberOfBytesToWrite)
        {
#ifdef _DEBUG
            xil_printf(
                "Error: I2C timeout when writing %d bytes to device 0x%x\r\n", numberOfBytesToWrite, deviceAddress);
#endif

            return EN_ERROR_I2C_WRITE_TIMEOUT;
        }
    }

    // Stop the IIC device.
    RETURN_IF_XILINX_CALL_FAILED(XIic_Stop(&g_XIicInstance), EN_ERROR_FAILED_TO_STOP_XIIC_DEVICE);

    if (g_i2cSlaveNack)
    {
#ifdef _DEBUG
        xil_printf("NACK received from I2C slave at address 0x%x\n\r", deviceAddress);
#endif

        return EN_ERROR_I2C_SLAVE_NACK;
    }

    return EN_SUCCESS;
}

EN_RESULT I2cWrite_ByteSubAddress(uint8_t deviceAddress,
                                  uint8_t subAddress,
                                  const uint8_t* pWriteBuffer,
                                  uint32_t numberOfBytesToWrite)
{
    // Create a new array, to contain both the subaddress and the write data.
    uint8_t transferSizeBytes = numberOfBytesToWrite + 1;
    uint8_t transferData[transferSizeBytes];
    transferData[0] = subAddress;

    unsigned int dataByteIndex = 0;
    for (dataByteIndex = 0; dataByteIndex < numberOfBytesToWrite; dataByteIndex++)
    {
        transferData[dataByteIndex + 1] = pWriteBuffer[dataByteIndex];
    }

    EN_RETURN_IF_FAILED(I2cWrite_NoSubAddress(deviceAddress, (uint8_t*)&transferData, transferSizeBytes));

    return EN_SUCCESS;
}

EN_RESULT I2cWrite_TwoByteSubAddress(uint8_t deviceAddress,
                                     uint16_t subAddress,
                                     const uint8_t* pWriteBuffer,
                                     uint32_t numberOfBytesToWrite)
{
    // Create a new array, to contain both the subaddress and the write data.
    uint8_t transferSizeBytes = numberOfBytesToWrite + 2;
    uint8_t transferData[transferSizeBytes];
    transferData[0] = GetUpperByte(subAddress);
    transferData[1] = GetLowerByte(subAddress);

    unsigned int dataByteIndex = 0;
    for (dataByteIndex = 0; dataByteIndex < numberOfBytesToWrite; dataByteIndex++)
    {
        transferData[dataByteIndex + 2] = pWriteBuffer[dataByteIndex];
    }

    EN_RETURN_IF_FAILED(I2cWrite_NoSubAddress(deviceAddress, (uint8_t*)&transferData, transferSizeBytes));

    return EN_SUCCESS;
}

EN_RESULT I2cRead_NoSubAddress(uint8_t deviceAddress, uint8_t* pReadBuffer, uint32_t numberOfBytesToRead)
{

    if (pReadBuffer == NULL)
    {
        return EN_ERROR_NULL_POINTER;
    }

    if (numberOfBytesToRead == 0)
    {
        return EN_ERROR_INVALID_ARGUMENT;
    }

#ifdef _DEBUG
    xil_printf("I2C: Reading %d bytes from device address 0x%x\r\n", numberOfBytesToRead, deviceAddress);
#endif

    RETURN_IF_XILINX_CALL_FAILED(XIic_SetAddress(&g_XIicInstance, XII_ADDR_TO_SEND_TYPE, deviceAddress),
                                 EN_ERROR_FAILED_TO_SET_I2C_DEVICE_ADDRESS);

    // Set the transfer flags.
    g_i2cReceiveInProgress = true;
    g_i2cSlaveNack = false;

    // Start the IIC device.
    RETURN_IF_XILINX_CALL_FAILED(XIic_Start(&g_XIicInstance), EN_ERROR_FAILED_TO_START_XIIC_DEVICE);

    // Set the transfer options.
    g_XIicInstance.Options = 0; // XII_REPEATED_START_OPTION;

    // Receive the data.
    RETURN_IF_XILINX_CALL_FAILED(XIic_MasterRecv(&g_XIicInstance, pReadBuffer, numberOfBytesToRead),
                                 EN_ERROR_XIIC_RECEIVE_FAILED);

    // Wait till all the data is received.
    unsigned int timeout = 0;
    while (g_i2cReceiveInProgress /*&& !g_i2cSlaveNack*/)
    {
        timeout++;
        if (timeout > 1000000 * numberOfBytesToRead)
        {
#ifdef _DEBUG
            xil_printf(
                "Error: I2C timeout when receiving %d bytes from device 0x%x\r\n", numberOfBytesToRead, deviceAddress);
#endif
            return EN_ERROR_I2C_READ_TIMEOUT;
        }
    }

    // Stop the IIC device.
    RETURN_IF_XILINX_CALL_FAILED(XIic_Stop(&g_XIicInstance), EN_ERROR_FAILED_TO_STOP_XIIC_DEVICE);

    if (g_i2cSlaveNack)
    {
#ifdef _DEBUG
        xil_printf("NACK received from I2C slave at address 0x%x\n\r", deviceAddress);
#endif

        return EN_ERROR_I2C_SLAVE_NACK;
    }

    return EN_SUCCESS;
}


EN_RESULT I2cRead_ByteSubAddress(uint8_t deviceAddress,
                                 uint8_t subAddress,
                                 uint8_t* pReadBuffer,
                                 uint32_t numberOfBytesToRead)
{
    // Write the subaddress, with start condition asserted but stop condition not.
    EN_RETURN_IF_FAILED(I2cWrite_NoSubAddress(deviceAddress, (uint8_t*)&subAddress, 1));

    // Perform the read.
    EN_RETURN_IF_FAILED(I2cRead_NoSubAddress(deviceAddress, pReadBuffer, numberOfBytesToRead));

    return EN_SUCCESS;
}


EN_RESULT I2cRead_WordSubAddress(uint8_t deviceAddress,
                                 uint16_t subAddress,
                                 uint8_t* pReadBuffer,
                                 uint32_t numberOfBytesToRead)
{
    // Write the subaddress, with start condition asserted but stop condition not.
    EN_RETURN_IF_FAILED(I2cWrite_NoSubAddress(deviceAddress, (uint8_t*)&subAddress, 2));

    // Perform the read.
    EN_RETURN_IF_FAILED(I2cRead_NoSubAddress(deviceAddress, pReadBuffer, numberOfBytesToRead));

    return EN_SUCCESS;
}


EN_RESULT I2cRead(uint8_t deviceAddress,
                  uint16_t subAddress,
                  EI2cSubAddressMode_t subAddressMode,
                  uint32_t numberOfBytesToRead,
                  uint8_t* pReadBuffer)
{

    switch (subAddressMode)
    {
    case EI2cSubAddressMode_None:
    {
        EN_RETURN_IF_FAILED(I2cRead_NoSubAddress(deviceAddress, pReadBuffer, numberOfBytesToRead));
        break;
    }
    case EI2cSubAddressMode_OneByte:
    {
        EN_RETURN_IF_FAILED(
            I2cRead_ByteSubAddress(deviceAddress, (uint8_t)subAddress, pReadBuffer, numberOfBytesToRead));
        break;
    }
    case EI2cSubAddressMode_TwoBytes:
    {
        EN_RETURN_IF_FAILED(
            I2cRead_WordSubAddress(deviceAddress, (uint16_t)subAddress, pReadBuffer, numberOfBytesToRead));
    }
    default:
        break;
    }

    return EN_SUCCESS;
}

EN_RESULT I2cWrite(uint8_t deviceAddress,
                   uint16_t subAddress,
                   EI2cSubAddressMode_t subAddressMode,
                   const uint8_t* pWriteBuffer,
                   uint32_t numberOfBytesToWrite)
{

    switch (subAddressMode)
    {
    case EI2cSubAddressMode_None:
    {
        EN_RETURN_IF_FAILED(I2cWrite_NoSubAddress(deviceAddress, pWriteBuffer, numberOfBytesToWrite));
        break;
    }
    case EI2cSubAddressMode_OneByte:
    {
        EN_RETURN_IF_FAILED(
            I2cWrite_ByteSubAddress(deviceAddress, (uint8_t)subAddress, pWriteBuffer, numberOfBytesToWrite));
        break;
    }
    case EI2cSubAddressMode_TwoBytes:
    {
        EN_RETURN_IF_FAILED(I2cWrite_TwoByteSubAddress(deviceAddress, subAddress, pWriteBuffer, numberOfBytesToWrite));
        break;
    }
    default:
        break;
    }


    return EN_SUCCESS;
}
