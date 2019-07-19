/**************************************************************
 *  Project          : Enclustra Vivado reference design
 *  File description : Memory Test
 *  File name        : main.c
 *  Author           : Christoph Glattfelder
 **************************************************************
 *  Copyright (c) 2015 by Enclustra GmbH, Switzerland
 *  All rights reserved.
 **************************************************************
 *  Notes:
 *
 **************************************************************
 *  File history:
 *
 *  Version | Date     | Author             | Remarks
 *  -----------------------------------------------------------
 *  1.0	    | 29.06.15 | Ch. Glattfelder    | Created
 *  1.1     | 16.07.15 | D. Ungureanu       | Cleaned-up code
 *          |          |                    |
 *  ------------------------------------------------------------
 *
 **************************************************************/

#include <xparameters.h>
#include <stdio.h>
#include "ENC_memtester.h"
#include "xil_cache.h"
#include "StandardIncludes.h"


//1Mb value
#define ONE_MB 0x100000

//Memory test offset - start testing the DDR memory starting from that point on
//used in case the code is executed on the DDR memory; the program will not be
//overwritten by the test
//approximated necessary value 1MB
#define TEST_OFFSET ONE_MB


int main(){
	int i, errors = 0;

	int SdramSizeMem = 256;
	
	Xil_DCacheEnable();
	Xil_ICacheEnable();

	for (i=0; i<20; i++)
		EN_PRINTF("\r\n");
	EN_PRINTF("== Enclustra Memory Test ==\r\n\r\n");

	errors += run_ddr_test((XPAR_MEMORY_SDRAM_BASEADDR + TEST_OFFSET), 2*ONE_MB, 1, TRUE, TRUE);
	errors += run_ddr_test((XPAR_MEMORY_SDRAM_BASEADDR + TEST_OFFSET), SdramSizeMem*ONE_MB - TEST_OFFSET, 2, FALSE, TRUE);

	if (errors)
		EN_PRINTF("== Test finished, %d run contained errors ==\r\n\r\n", errors);
	else
		EN_PRINTF("== Test finished, no errors occurred ==\r\n\r\n");

	return 0;
}
