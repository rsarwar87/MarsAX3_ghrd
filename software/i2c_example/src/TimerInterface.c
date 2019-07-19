/** \file TimerFunctions.c
 * Implementation file for timer functions.
 * \author Garry Jeromson
 * \date 22.06.2015
 *
 * Copyright (c) 2015 Enclustra GmbH, Switzerland.
 * All rights reserved.
 */


//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------

#include "TimerInterface.h"
#include "TimerInterfaceVariables.h"


//-------------------------------------------------------------------------------------------------
// Global variable definitions
//-------------------------------------------------------------------------------------------------

XTmrCtr g_timerInstance;

volatile bool g_timerRunning;

//-------------------------------------------------------------------------------------------------
// Function definitions
//-------------------------------------------------------------------------------------------------


/*****************************************************************************/
/**
* This function is the handler which performs processing for the timer counter.
* It is called from an interrupt context such that the amount of processing
* performed should be minimized.  It is called when the timer counter expires
* if interrupts are enabled.
*
* This handler provides an example of how to handle timer counter interrupts
* but is application specific.
*
* @param	CallBackRef is a pointer to the callback function
* @param	TmrCtrNumber is the number of the timer to which this
*		handler is associated with.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void TimerCounterHandler(void* CallBackRef, u8 TmrCtrNumber)
{
    g_timerRunning = false;
}


EN_RESULT InitialiseTimer()
{
    RETURN_IF_XILINX_CALL_FAILED(XTmrCtr_Initialize(&g_timerInstance, TMRCTR_DEVICE_ID),
                                 EN_ERROR_TIMER_INITIALISATION_FAILED);

    // Perform a self-test
    RETURN_IF_XILINX_CALL_FAILED(XTmrCtr_SelfTest(&g_timerInstance, TIMER_COUNTER_0), EN_ERROR_TIMER_SELF_TEST_FAILED);

    // Setup the handler for the timer counter that will be called from the interrupt context when the timer
    // expires.
    XTmrCtr_SetHandler(&g_timerInstance, (XTmrCtr_Handler)TimerCounterHandler, &g_timerInstance);


    XTmrCtr_SetOptions(&g_timerInstance, TIMER_COUNTER_0, XTC_INT_MODE_OPTION | XTC_DOWN_COUNT_OPTION);

    return EN_SUCCESS;
}


void SleepMilliseconds(uint32_t milliseconds)
{
    XTmrCtr_SetResetValue(&g_timerInstance, TIMER_COUNTER_0, milliseconds * (SYSTEM_CLOCK_FREQUENCY_HZ / 1000));

    g_timerRunning = true;

    // Start the timer counter.
    XTmrCtr_Start(&g_timerInstance, TIMER_COUNTER_0);

#ifdef _DEBUG
    xil_printf("Sleeping for %d milliseconds..\r\n", milliseconds);
#endif

    // Wait for the timer to expire.
    while (g_timerRunning)
    {
    }

#ifdef _DEBUG
    xil_printf("Sleeping complete.\r\n");
#endif

    XTmrCtr_Stop(&g_timerInstance, TIMER_COUNTER_0);
}
