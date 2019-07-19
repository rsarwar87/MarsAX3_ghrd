/** \file InterruptController.c
 * \brief Implementation file for interrupt controller functions.
 * \author Garry Jeromson
 * \date 24.06.2015
 */

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------

#include "InterruptController.h"
#include "I2cInterfaceVariables.h"
#include "TimerInterfaceVariables.h"

#include <xil_exception.h>
#include <xil_types.h>

//-------------------------------------------------------------------------------------------------
// Definitions and constants
//-------------------------------------------------------------------------------------------------

#define INTC_DEVICE_ID XPAR_INTC_0_DEVICE_ID


//-------------------------------------------------------------------------------------------------
// Global variable definitions
//-------------------------------------------------------------------------------------------------

/// Interrupt controller, declared in InterruptController.h
XIntc g_interruptController;


//-------------------------------------------------------------------------------------------------
// Function definitions
//-------------------------------------------------------------------------------------------------

EN_RESULT SetupInterruptSystem()
{

    if (g_interruptController.IsStarted == XIL_COMPONENT_IS_STARTED)
    {
        return EN_SUCCESS;
    }

    // Initialize the interrupt controller driver so that it's ready to use.
    RETURN_IF_XILINX_CALL_FAILED(XIntc_Initialize(&g_interruptController, INTC_DEVICE_ID),
                                 EN_ERROR_FAILED_TO_INITIALISE_INTERRUPT_CONTROLLER);


    // Connect the device driver handler that will be called when an I2C interrupt  occurs
    RETURN_IF_XILINX_CALL_FAILED(
        XIntc_Connect(&g_interruptController, IIC_INTR_ID, (XInterruptHandler)XIic_InterruptHandler, &g_XIicInstance),
        EN_ERROR_FAILED_TO_INITIALISE_INTERRUPT_CONTROLLER);


    // Connect the device driver handler that will be called when a timer interrupt  occurs
    RETURN_IF_XILINX_CALL_FAILED(
        XIntc_Connect(
            &g_interruptController, TMRCTR_INTERRUPT_ID, (XInterruptHandler)XTmrCtr_InterruptHandler, &g_timerInstance),
        EN_ERROR_FAILED_TO_INITIALISE_INTERRUPT_CONTROLLER);


    // Start the interrupt controller
    RETURN_IF_XILINX_CALL_FAILED(XIntc_Start(&g_interruptController, XIN_REAL_MODE),
                                 EN_ERROR_FAILED_TO_START_INTERRUPT_CONTROLLER);


    // Enable the interrupts for the IIC device.
    XIntc_Enable(&g_interruptController, IIC_INTR_ID);

    // Enable the interrupt for the timer counter
    XIntc_Enable(&g_interruptController, TMRCTR_INTERRUPT_ID);

// INSERT ANY FURTHER INTERRUPT ENABLES HERE //

#ifdef __MICROBLAZE__
    // Enable the Microblaze Interrupts.
    microblaze_enable_interrupts();
#endif

    // Initialize the exception table.
    Xil_ExceptionInit();

    // Register the interrupt controller handler with the exception table.
    Xil_ExceptionRegisterHandler(
        XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XIntc_InterruptHandler, &g_interruptController);

    // Enable non-critical exceptions.
    Xil_ExceptionEnable();

    return EN_SUCCESS;
}
