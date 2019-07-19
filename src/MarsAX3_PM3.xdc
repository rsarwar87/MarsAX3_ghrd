# -------------------------------------------------------------------------------------------------
# -- Project             : Mars AX3 Reference Design
# -- File description    : Pin assignment and timing constraints file for Mars PM3
# -- File name           : MarsAX3_PM3.xdc
# -- Authors             : Christoph Glattfelder
# -------------------------------------------------------------------------------------------------
# -- Copyright (c) 2017 by Enclustra GmbH, Switzerland. All rights are reserved.
# -- Unauthorized duplication of this document, in whole or in part, by any means is prohibited
# -- without the prior written permission of Enclustra GmbH, Switzerland.
# --
# -- Although Enclustra GmbH believes that the information included in this publication is correct
# -- as of the date of publication, Enclustra GmbH reserves the right to make changes at any time
# -- without notice.
# --
# -- All information in this document may only be published by Enclustra GmbH, Switzerland.
# -------------------------------------------------------------------------------------------------
# -- Notes:
# -- The IO standards might need to be adapted to your design
# -------------------------------------------------------------------------------------------------
# -- File history:
# --
# -- Version | Date       | Author             | Remarks
# -- ----------------------------------------------------------------------------------------------
# -- 1.0     | 11.04.2014 | C. Glattfelder     | Converted from UCF
# -- 2.0     | 20.10.2017 | D. Ungureanu       | Consistency checks
# --
# -------------------------------------------------------------------------------------------------

set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN ENABLE [current_design]

# -------------------------------------------------------------------------------------------------
# Mars PM3
# -------------------------------------------------------------------------------------------------

set_property PACKAGE_PIN B3 [get_ports UART_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_rxd]
set_property PACKAGE_PIN B2 [get_ports UART_txd]
set_property IOSTANDARD LVCMOS33 [get_ports UART_txd]

set_property PACKAGE_PIN N15 [get_ports Reset_N]
set_property IOSTANDARD LVCMOS33 [get_ports Reset_N]

set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]

# -------------------------------------------------------------------------------------------------
# Global clock inputs
# -------------------------------------------------------------------------------------------------

set_property IOSTANDARD LVCMOS33 [get_ports Clk_50]
set_property PACKAGE_PIN P17 [get_ports Clk_50]

# -------------------------------------------------------------------------------------------------
# DDR3 SDRAM
# -------------------------------------------------------------------------------------------------

# The DDR3 SDRAM pinout is defined via the MIG GUI

# -------------------------------------------------------------------------------------------------
# Ethernet
# -------------------------------------------------------------------------------------------------

set_property IOSTANDARD LVCMOS33 [get_ports {Eth_Txd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports Eth_Rxc]
set_property IOSTANDARD LVCMOS33 [get_ports Eth_Rst_N]
set_property IOSTANDARD LVCMOS33 [get_ports {Eth_Rxd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Eth_Txd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Eth_Rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports Eth_Mdio]
set_property IOSTANDARD LVCMOS33 [get_ports {Eth_Rxd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports Eth_Mdc]
set_property IOSTANDARD LVCMOS33 [get_ports {Eth_Rxd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports Eth_Txc]
set_property IOSTANDARD LVCMOS33 [get_ports {Eth_Txd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports Eth_Tx_Ctl]
set_property IOSTANDARD LVCMOS33 [get_ports Eth_Rx_Ctl]
set_property IOSTANDARD LVCMOS33 [get_ports {Eth_Txd[3]}]
set_property PACKAGE_PIN T16 [get_ports Eth_Tx_Ctl]
set_property PACKAGE_PIN R18 [get_ports {Eth_Txd[0]}]
set_property PACKAGE_PIN V16 [get_ports {Eth_Rxd[3]}]
set_property PACKAGE_PIN V15 [get_ports {Eth_Rxd[2]}]
set_property PACKAGE_PIN V17 [get_ports {Eth_Rxd[1]}]
set_property PACKAGE_PIN T18 [get_ports {Eth_Txd[1]}]
set_property PACKAGE_PIN U16 [get_ports {Eth_Rxd[0]}]
set_property PACKAGE_PIN T14 [get_ports Eth_Rxc]
set_property PACKAGE_PIN R16 [get_ports Eth_Rx_Ctl]
set_property PACKAGE_PIN U17 [get_ports {Eth_Txd[2]}]
set_property PACKAGE_PIN M13 [get_ports Eth_Rst_N]
set_property PACKAGE_PIN N14 [get_ports Eth_Mdio]
set_property PACKAGE_PIN P14 [get_ports Eth_Mdc]
set_property PACKAGE_PIN U18 [get_ports {Eth_Txd[3]}]
set_property PACKAGE_PIN N16 [get_ports Eth_Txc]

# -------------------------------------------------------------------------------------------------
# I2C
# -------------------------------------------------------------------------------------------------

set_property PACKAGE_PIN R17 [get_ports I2c_Int_N]
set_property IOSTANDARD LVCMOS33 [get_ports I2c_Int_N]
set_property PACKAGE_PIN N17 [get_ports I2c_Scl]
set_property IOSTANDARD LVCMOS33 [get_ports I2c_Scl]
set_property PACKAGE_PIN P18 [get_ports I2c_Sda]
set_property IOSTANDARD LVCMOS33 [get_ports I2c_Sda]

# -------------------------------------------------------------------------------------------------
# SPI flash
# -------------------------------------------------------------------------------------------------

set_property PACKAGE_PIN L13 [get_ports Flash_Cs_N]
set_property IOSTANDARD LVCMOS33 [get_ports Flash_Cs_N]
set_property PACKAGE_PIN K17 [get_ports Flash_Di]
set_property IOSTANDARD LVCMOS33 [get_ports Flash_Di]
set_property PACKAGE_PIN R10 [get_ports Flash_Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Flash_Clk]
set_property PACKAGE_PIN K18 [get_ports Flash_Do]
set_property IOSTANDARD LVCMOS33 [get_ports Flash_Do]

# -------------------------------------------------------------------------------------------------
# Led
# -------------------------------------------------------------------------------------------------

set_property IOSTANDARD LVCMOS33 [get_ports {Led_N[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Led_N[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Led_N[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Led_N[3]}]
set_property PACKAGE_PIN M17 [get_ports {Led_N[1]}]
set_property PACKAGE_PIN M18 [get_ports {Led_N[3]}]
set_property PACKAGE_PIN L18 [get_ports {Led_N[2]}]
set_property PACKAGE_PIN M16 [get_ports {Led_N[0]}]

# -------------------------------------------------------------------------------------------------
# System
# -------------------------------------------------------------------------------------------------

set_property PACKAGE_PIN R11 [get_ports Pwr_Good]
set_property IOSTANDARD LVCMOS33 [get_ports Pwr_Good]
set_property PACKAGE_PIN D9 [get_ports DDR3_VSEL]
set_property IOSTANDARD LVCMOS33 [get_ports DDR3_VSEL]


# -------------------------------------------------------------------------------------------------
# mars pm3: ez-usb fx3 interface
# -------------------------------------------------------------------------------------------------

set_property PACKAGE_PIN V2 [get_ports FX3_A1]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_A1]
set_property PACKAGE_PIN V7 [get_ports FX3_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_CLK]
set_property PACKAGE_PIN U12 [get_ports FX3_DQ0]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ0]
set_property PACKAGE_PIN R15 [get_ports FX3_DQ1]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ1]
set_property PACKAGE_PIN U9 [get_ports FX3_DQ10]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ10]
set_property PACKAGE_PIN V5 [get_ports FX3_DQ11]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ11]
set_property PACKAGE_PIN T3 [get_ports FX3_DQ12]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ12]
set_property PACKAGE_PIN R3 [get_ports FX3_DQ13]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ13]
set_property PACKAGE_PIN V4 [get_ports FX3_DQ14]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ14]
set_property PACKAGE_PIN U7 [get_ports FX3_DQ15]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ15]
set_property PACKAGE_PIN V12 [get_ports FX3_DQ2]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ2]
set_property PACKAGE_PIN P15 [get_ports FX3_DQ3]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ3]
set_property PACKAGE_PIN U11 [get_ports FX3_DQ4]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ4]
set_property PACKAGE_PIN U13 [get_ports FX3_DQ5]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ5]
set_property PACKAGE_PIN T13 [get_ports FX3_DQ6]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ6]
set_property PACKAGE_PIN T11 [get_ports FX3_DQ7]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ7]
set_property PACKAGE_PIN V9 [get_ports FX3_DQ8]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ8]
set_property PACKAGE_PIN U6 [get_ports FX3_DQ9]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_DQ9]
set_property PACKAGE_PIN V6 [get_ports FX3_FLAGA]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_FLAGA]
set_property PACKAGE_PIN U2 [get_ports FX3_FLAGB]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_FLAGB]
set_property PACKAGE_PIN T10 [get_ports FX3_PKTEND_N]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_PKTEND_N]
set_property PACKAGE_PIN T9 [get_ports FX3_SLOE_N]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_SLOE_N]
set_property PACKAGE_PIN R12 [get_ports FX3_SLRD_N]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_SLRD_N]
set_property PACKAGE_PIN R13 [get_ports FX3_SLWR_N]
set_property IOSTANDARD LVCMOS33 [get_ports FX3_SLWR_N]


# -------------------------------------------------------------------------------------------------
# mars pm3: fmc lpc connector
# -------------------------------------------------------------------------------------------------

set_property PACKAGE_PIN T4 [get_ports FMC_CLK0_M2C_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_CLK0_M2C_N]
set_property PACKAGE_PIN T5 [get_ports FMC_CLK0_M2C_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_CLK0_M2C_P]
set_property PACKAGE_PIN D3 [get_ports FMC_CLK1_M2C_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_CLK1_M2C_N]
set_property PACKAGE_PIN E3 [get_ports FMC_CLK1_M2C_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_CLK1_M2C_P]
set_property PACKAGE_PIN P5 [get_ports FMC_LA00_CC_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA00_CC_N]
set_property PACKAGE_PIN N5 [get_ports FMC_LA00_CC_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA00_CC_P]
set_property PACKAGE_PIN P3 [get_ports FMC_LA01_CC_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA01_CC_N]
set_property PACKAGE_PIN P4 [get_ports FMC_LA01_CC_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA01_CC_P]
set_property PACKAGE_PIN N6 [get_ports FMC_LA02_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA02_N]
set_property PACKAGE_PIN M6 [get_ports FMC_LA02_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA02_P]
set_property PACKAGE_PIN L5 [get_ports FMC_LA03_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA03_N]
set_property PACKAGE_PIN L6 [get_ports FMC_LA03_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA03_P]
set_property PACKAGE_PIN M1 [get_ports FMC_LA04_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA04_N]
set_property PACKAGE_PIN L1 [get_ports FMC_LA04_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA04_P]
set_property PACKAGE_PIN N4 [get_ports FMC_LA05_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA05_N]
set_property PACKAGE_PIN M4 [get_ports FMC_LA05_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA05_P]
set_property PACKAGE_PIN N1 [get_ports FMC_LA06_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA06_N]
set_property PACKAGE_PIN N2 [get_ports FMC_LA06_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA06_P]
set_property PACKAGE_PIN M2 [get_ports FMC_LA07_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA07_N]
set_property PACKAGE_PIN M3 [get_ports FMC_LA07_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA07_P]
set_property PACKAGE_PIN R5 [get_ports FMC_LA08_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA08_N]
set_property PACKAGE_PIN R6 [get_ports FMC_LA08_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA08_P]
set_property PACKAGE_PIN R2 [get_ports FMC_LA09_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA09_N]
set_property PACKAGE_PIN P2 [get_ports FMC_LA09_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA09_P]
set_property PACKAGE_PIN T1 [get_ports FMC_LA10_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA10_N]
set_property PACKAGE_PIN R1 [get_ports FMC_LA10_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA10_P]
set_property PACKAGE_PIN V1 [get_ports FMC_LA11_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA11_N]
set_property PACKAGE_PIN U1 [get_ports FMC_LA11_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA11_P]
set_property PACKAGE_PIN T6 [get_ports FMC_LA12_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA12_N]
set_property PACKAGE_PIN R7 [get_ports FMC_LA12_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA12_P]
set_property PACKAGE_PIN U3 [get_ports FMC_LA13_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA13_N]
set_property PACKAGE_PIN U4 [get_ports FMC_LA13_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA13_P]
set_property PACKAGE_PIN T8 [get_ports FMC_LA14_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA14_N]
set_property PACKAGE_PIN R8 [get_ports FMC_LA14_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA14_P]
set_property PACKAGE_PIN L4 [get_ports FMC_LA15_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA15_N]
set_property PACKAGE_PIN K5 [get_ports FMC_LA15_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA15_P]
set_property PACKAGE_PIN L3 [get_ports FMC_LA16_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA16_N]
set_property PACKAGE_PIN K3 [get_ports FMC_LA16_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA16_P]
set_property PACKAGE_PIN F3 [get_ports FMC_LA17_CC_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA17_CC_N]
set_property PACKAGE_PIN F4 [get_ports FMC_LA17_CC_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA17_CC_P]
set_property PACKAGE_PIN D2 [get_ports FMC_LA18_CC_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA18_CC_N]
set_property PACKAGE_PIN E2 [get_ports FMC_LA18_CC_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA18_CC_P]
set_property PACKAGE_PIN G3 [get_ports FMC_LA19_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA19_N]
set_property PACKAGE_PIN G4 [get_ports FMC_LA19_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA19_P]
set_property PACKAGE_PIN C7 [get_ports FMC_LA20_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA20_N]
set_property PACKAGE_PIN D8 [get_ports FMC_LA20_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA20_P]
set_property PACKAGE_PIN C1 [get_ports FMC_LA21_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA21_N]
set_property PACKAGE_PIN C2 [get_ports FMC_LA21_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA21_P]
set_property PACKAGE_PIN D7 [get_ports FMC_LA22_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA22_N]
set_property PACKAGE_PIN E7 [get_ports FMC_LA22_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA22_P]
set_property PACKAGE_PIN E1 [get_ports FMC_LA23_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA23_N]
set_property PACKAGE_PIN F1 [get_ports FMC_LA23_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA23_P]
set_property PACKAGE_PIN F6 [get_ports FMC_LA24_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA24_N]
set_property PACKAGE_PIN G6 [get_ports FMC_LA24_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA24_P]
set_property PACKAGE_PIN H5 [get_ports FMC_LA25_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA25_N]
set_property PACKAGE_PIN H6 [get_ports FMC_LA25_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA25_P]
set_property PACKAGE_PIN G2 [get_ports FMC_LA26_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA26_N]
set_property PACKAGE_PIN H2 [get_ports FMC_LA26_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA26_P]
set_property PACKAGE_PIN J2 [get_ports FMC_LA27_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA27_N]
set_property PACKAGE_PIN J3 [get_ports FMC_LA27_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA27_P]
set_property PACKAGE_PIN H4 [get_ports FMC_LA28_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA28_N]
set_property PACKAGE_PIN J4 [get_ports FMC_LA28_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA28_P]
set_property PACKAGE_PIN G1 [get_ports FMC_LA29_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA29_N]
set_property PACKAGE_PIN H1 [get_ports FMC_LA29_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA29_P]
set_property PACKAGE_PIN K1 [get_ports FMC_LA30_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA30_N]
set_property PACKAGE_PIN K2 [get_ports FMC_LA30_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA30_P]
set_property PACKAGE_PIN C5 [get_ports FMC_LA31_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA31_N]
set_property PACKAGE_PIN C6 [get_ports FMC_LA31_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA31_P]
set_property PACKAGE_PIN A1 [get_ports FMC_LA32_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA32_N]
set_property PACKAGE_PIN B1 [get_ports FMC_LA32_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA32_P]
set_property PACKAGE_PIN B4 [get_ports FMC_LA33_N]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA33_N]
set_property PACKAGE_PIN C4 [get_ports FMC_LA33_P]
set_property IOSTANDARD LVCMOS33 [get_ports FMC_LA33_P]

# -------------------------------------------------------------------------------------------------
# timing constraints
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# eof
# -------------------------------------------------------------------------------------------------







set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
