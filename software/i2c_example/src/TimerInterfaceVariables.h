/** \file TimerFunctions.h
* Header file for timer functions.
* \author Garry Jeromson
* \date 22.06.2015
*
* Copyright (c) 2015 Enclustra GmbH, Switzerland.
* All rights reserved.
*/

#pragma once

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------

#include "StandardIncludes.h"

#include <xtmrctr.h>
#include <xparameters.h>

//-------------------------------------------------------------------------------------------------
// Definitions and constants
//-------------------------------------------------------------------------------------------------

#define TMRCTR_DEVICE_ID XPAR_TMRCTR_0_DEVICE_ID
#define TMRCTR_INTERRUPT_ID XPAR_INTC_0_TMRCTR_0_VEC_ID
#define TIMER_COUNTER_0 0

//-------------------------------------------------------------------------------------------------
// Global variable declarations
//-------------------------------------------------------------------------------------------------

extern XTmrCtr g_timerInstance;



