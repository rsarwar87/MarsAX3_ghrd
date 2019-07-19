/** \file I2cInterfaceVariables.h
 * \brief Header file for global variables required for Xilinx I2C interface functions.
 * \author Garry Jeromson
 * \date 07.07.15
 */

#pragma once

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------

#include <xiic.h>
#include <xparameters.h>


//-------------------------------------------------------------------------------------------------
// Definitions and constants
//-------------------------------------------------------------------------------------------------

/// Device ID
#define IIC_DEVICE_ID XPAR_IIC_0_DEVICE_ID

/// Interrupt ID
#define IIC_INTR_ID XPAR_INTC_0_IIC_0_VEC_ID


//-------------------------------------------------------------------------------------------------
// Global variable declarations
//-------------------------------------------------------------------------------------------------

extern XIic g_XIicInstance;
