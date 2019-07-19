---------------------------------------------------------------------------------------------------
-- Project          : Mars AX3 Reference Design
-- File description : Top Level
-- File name        : system_top_PM3.vhd
-- Author           : Christoph Glattfelder
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2017 by Enclustra GmbH, Switzerland. All rights are reserved. 
-- Unauthorized duplication of this document, in whole or in part, by any means is prohibited
-- without the prior written permission of Enclustra GmbH, Switzerland.
-- 
-- Although Enclustra GmbH believes that the information included in this publication is correct
-- as of the date of publication, Enclustra GmbH reserves the right to make changes at any time
-- without notice.
-- 
-- All information in this document may only be published by Enclustra GmbH, Switzerland.
---------------------------------------------------------------------------------------------------
-- Description:
-- This is a top-level file for Mars AX3 Reference Design
--    
---------------------------------------------------------------------------------------------------
-- File history:
--
-- Version | Date       | Author           | Remarks
-- ------------------------------------------------------------------------------------------------
-- 1.0     | 21.01.2014 | C. Glattfelder   | First released version
-- 2.0     | 20.10.2017 | D. Ungureanu     | Consistency checks
-- 3.0     | 03.01.2018 | D. Duerner       | Add blinking LEDs
--
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- libraries
---------------------------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	
library unisim;
	use unisim.vcomponents.all;

entity system_top is
	port (
		-------------------------------------------------------------------------------------------
		-- clock and reset
		-------------------------------------------------------------------------------------------
		
		Clk_50 			: in std_logic;
		Reset_N 		: in std_logic;
		
		-------------------------------------------------------------------------------------------
		-- DDR3 SDRAM
		-------------------------------------------------------------------------------------------
		
		DDR3_addr 		: out std_logic_vector ( 13 downto 0 );
		DDR3_ba 		: out std_logic_vector ( 2 downto 0 );
		DDR3_cas_n 		: out std_logic;
		DDR3_ck_n 		: out std_logic_vector ( 0 to 0 );
		DDR3_ck_p 		: out std_logic_vector ( 0 to 0 );
		DDR3_cke 		: out std_logic_vector ( 0 to 0 );
		DDR3_dm 		: out std_logic_vector ( 1 downto 0 );
		DDR3_dq 		: inout std_logic_vector ( 15 downto 0 );
		DDR3_dqs_n 		: inout std_logic_vector ( 1 downto 0 );
		DDR3_dqs_p 		: inout std_logic_vector ( 1 downto 0 );
		DDR3_odt 		: out std_logic_vector ( 0 to 0 );
		DDR3_ras_n 		: out std_logic;
		DDR3_reset_n 	: out std_logic;
		DDR3_we_n 		: out std_logic;
		
		-------------------------------------------------------------------------------------------
		-- UART
		-------------------------------------------------------------------------------------------
		
		UART_rxd 		: in STD_LOGIC;
		UART_txd 		: out STD_LOGIC;
		
		-------------------------------------------------------------------------------------------
		-- Ethernet
		-------------------------------------------------------------------------------------------
		
		Eth_Rst_N 		: out std_logic;
		Eth_Rxd 		: in Std_logic_vector ( 3 downto 0 );
		Eth_Rx_Ctl 		: in Std_logic;
		Eth_Rxc 		: in Std_logic;
		Eth_Txd 		: out std_logic_vector ( 3 downto 0 );
		Eth_Tx_Ctl 		: out std_logic;
		Eth_Txc 		: out std_logic;
		Eth_Mdio 		: inout std_logic;
		Eth_Mdc 		: out std_logic;
		
		-------------------------------------------------------------------------------------------
		-- I2C
		-------------------------------------------------------------------------------------------

		I2c_Int_N		: inout	std_logic;
		I2c_Scl			: inout	std_logic;
		I2c_Sda			: inout	std_logic;
	
		-------------------------------------------------------------------------------------------
		-- SPI flash
		-------------------------------------------------------------------------------------------

		Flash_Clk		: inout	std_logic;
		Flash_Cs_N		: inout	std_logic;
		Flash_Do		: inout	std_logic;
		Flash_Di		: inout	std_logic;

		-------------------------------------------------------------------------------------------
		-- Led		
		-------------------------------------------------------------------------------------------

		Led_N			: out std_logic_vector (3 downto 0);
		
		-------------------------------------------------------------------------------------------
		-- System		
		-------------------------------------------------------------------------------------------

		Pwr_Good		: inout	std_logic;
		DDR3_VSEL		: inout	std_logic
	);
end system_top;

architecture STRUCTURE of system_top is

  component MarsAX3 is
  port (
    Led_N_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    UART_0_rxd : in STD_LOGIC;
    UART_0_txd : out STD_LOGIC;
    iic_0_scl_i : in STD_LOGIC;
    iic_0_scl_o : out STD_LOGIC;
    iic_0_scl_t : out STD_LOGIC;
    iic_0_sda_i : in STD_LOGIC;
    iic_0_sda_o : out STD_LOGIC;
    iic_0_sda_t : out STD_LOGIC;
    spi_0_io0_i : in STD_LOGIC;
    spi_0_io0_o : out STD_LOGIC;
    spi_0_io0_t : out STD_LOGIC;
    spi_0_io1_i : in STD_LOGIC;
    spi_0_io1_o : out STD_LOGIC;
    spi_0_io1_t : out STD_LOGIC;
    spi_0_ss_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    spi_0_ss_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    spi_0_ss_t : out STD_LOGIC;
    phy_rst_n : out STD_LOGIC;
    CLK_50 : out STD_LOGIC;
    sys_clk_i : in STD_LOGIC;
    sys_rst : in STD_LOGIC;
    DDR3_dq : inout STD_LOGIC_VECTOR ( 15 downto 0 );
    DDR3_dqs_p : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_dqs_n : inout STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    DDR3_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR3_ras_n : out STD_LOGIC;
    DDR3_cas_n : out STD_LOGIC;
    DDR3_we_n : out STD_LOGIC;
    DDR3_reset_n : out STD_LOGIC;
    DDR3_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    DDR3_dm : out STD_LOGIC_VECTOR ( 1 downto 0 );
    DDR3_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    mdio_mdc : out STD_LOGIC;
    rgmii_rd : in STD_LOGIC_VECTOR ( 3 downto 0 );
    rgmii_rx_ctl : in STD_LOGIC;
    rgmii_rxc : in STD_LOGIC;
    rgmii_td : out STD_LOGIC_VECTOR ( 3 downto 0 );
    rgmii_tx_ctl : out STD_LOGIC;
    rgmii_txc : out STD_LOGIC;
    mdio_mdio_i : in STD_LOGIC;
    mdio_mdio_o : out STD_LOGIC;
    mdio_mdio_t : out STD_LOGIC
  );
  end component MarsAX3;
  
  component IOBUF is
    port (
      I : in STD_LOGIC;
      O : out STD_LOGIC;
      T : in STD_LOGIC;
      IO : inout STD_LOGIC
    );
  end component IOBUF;
  
  signal iic_0_scl_i : STD_LOGIC;
  signal iic_0_scl_o : STD_LOGIC;
  signal iic_0_scl_t : STD_LOGIC;
  signal iic_0_sda_i : STD_LOGIC;
  signal iic_0_sda_o : STD_LOGIC;
  signal iic_0_sda_t : STD_LOGIC;
  signal mdio_mdio_i : STD_LOGIC;
  signal mdio_mdio_o : STD_LOGIC;
  signal mdio_mdio_t : STD_LOGIC;
  signal spi_0_io0_i : STD_LOGIC;
  signal spi_0_io0_o : STD_LOGIC;
  signal spi_0_io0_t : STD_LOGIC;
  signal spi_0_io1_i : STD_LOGIC;
  signal spi_0_io1_o : STD_LOGIC;
  signal spi_0_io1_t : STD_LOGIC;
  signal spi_0_ss_i_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal spi_0_ss_io_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal spi_0_ss_o_0 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal spi_0_ss_t : STD_LOGIC;
  
  signal Clk_50_logic : STD_LOGIC;
  
  signal led_n_intern : STD_LOGIC_VECTOR( 3 downto 0 );
  signal LedCount     : UNSIGNED (23 downto 0);
  signal Rst          : std_logic := '0';
  signal RstCnt       : unsigned (15 downto 0) := (others => '0');


begin

	
	-----------------------------------------------------------------------------------------------
	-- Microblaze System
	-----------------------------------------------------------------------------------------------	
	MarsAX3_i: component MarsAX3
     port map (
      DDR3_addr(13 downto 0) => DDR3_addr(13 downto 0),
      DDR3_ba(2 downto 0) => DDR3_ba(2 downto 0),
      DDR3_cas_n => DDR3_cas_n,
      DDR3_ck_n(0) => DDR3_ck_n(0),
      DDR3_ck_p(0) => DDR3_ck_p(0),
      DDR3_cke(0) => DDR3_cke(0),
      DDR3_dm(1 downto 0) => DDR3_dm(1 downto 0),
      DDR3_dq(15 downto 0) => DDR3_dq(15 downto 0),
      DDR3_dqs_n(1 downto 0) => DDR3_dqs_n(1 downto 0),
      DDR3_dqs_p(1 downto 0) => DDR3_dqs_p(1 downto 0),
      DDR3_odt(0) => DDR3_odt(0),
      DDR3_ras_n => DDR3_ras_n,
      DDR3_reset_n => DDR3_reset_n,
      DDR3_we_n => DDR3_we_n,
      Led_N_tri_o(3 downto 0) => led_n_intern(3 downto 0),
      UART_0_rxd => UART_rxd,
      UART_0_txd => UART_txd,
      iic_0_scl_i => iic_0_scl_i,
      iic_0_scl_o => iic_0_scl_o,
      iic_0_scl_t => iic_0_scl_t,
      iic_0_sda_i => iic_0_sda_i,
      iic_0_sda_o => iic_0_sda_o,
      iic_0_sda_t => iic_0_sda_t,
      mdio_mdc => Eth_Mdc,
      mdio_mdio_i => mdio_mdio_i,
      mdio_mdio_o => mdio_mdio_o,
      mdio_mdio_t => mdio_mdio_t,
      phy_rst_n => Eth_Rst_N,
	  rgmii_rd(3 downto 0)	=> Eth_Rxd(3 downto 0),
	  rgmii_rx_ctl			=> Eth_Rx_Ctl,
	  rgmii_rxc				=> Eth_Rxc,
	  rgmii_td(3 downto 0)	=> Eth_Txd(3 downto 0),
	  rgmii_tx_ctl			=> Eth_Tx_Ctl,
	  rgmii_txc				=> Eth_Txc,
      spi_0_io0_i => spi_0_io0_i,
      spi_0_io0_o => spi_0_io0_o,
      spi_0_io0_t => spi_0_io0_t,
      spi_0_io1_i => spi_0_io1_i,
      spi_0_io1_o => spi_0_io1_o,
      spi_0_io1_t => spi_0_io1_t,
      spi_0_ss_i(0) => spi_0_ss_i_0(0),
      spi_0_ss_o(0) => spi_0_ss_o_0(0),
      spi_0_ss_t => spi_0_ss_t,
      CLK_50 => Clk_50_logic,
      sys_clk_i => Clk_50,
      sys_rst => Reset_N
    );
		

	iic_0_scl_iobuf: component IOBUF
		port map (
		I => iic_0_scl_o,
		IO => I2c_Scl,
		O => iic_0_scl_i,
		T => iic_0_scl_t
		);
	iic_0_sda_iobuf: component IOBUF
		port map (
		I => iic_0_sda_o,
		IO => I2c_Sda,
		O => iic_0_sda_i,
		T => iic_0_sda_t
		);
	mdio_mdio_iobuf: component IOBUF
		port map (
		I => mdio_mdio_o,
		IO => Eth_Mdio,
		O => mdio_mdio_i,
		T => mdio_mdio_t
		);
	spi_0_io0_iobuf: component IOBUF
		port map (
		I => spi_0_io0_o,
		IO => Flash_Di,
		O => spi_0_io0_i,
		T => spi_0_io0_t
		);
	spi_0_io1_iobuf: component IOBUF
		port map (
		I => spi_0_io1_o,
		IO => Flash_Do,
		O => spi_0_io1_i,
		T => spi_0_io1_t
		);
	spi_0_ss_iobuf_0: component IOBUF
		port map (
		I => spi_0_ss_o_0(0),
		IO => Flash_Cs_N,
		O => spi_0_ss_i_0(0),
		T => spi_0_ss_t
		);

	------------------------------------------------------------------------------------------------
	--	Clock and Reset
	------------------------------------------------------------------------------------------------ 
	   
   	process (Clk_50_logic)
   	begin
		if rising_edge (Clk_50_logic) then
   			if (not RstCnt) = 0 then
   				Rst			<= '0';
   			else
   				Rst			<= '1';
   				RstCnt		<= RstCnt + 1;
	   		end if;
   		end if;
   	end process;
    
	------------------------------------------------------------------------------------------------
	-- Blinking LED counter & LED assignment
	------------------------------------------------------------------------------------------------
   
    process (Clk_50_logic)
    begin
    	if rising_edge (Clk_50_logic) then
    		if Rst = '1' then
    			LedCount	<= (others => '0');
    		else
    			LedCount <= LedCount + 1;
    		end if;
    	end if;
    end process;

    Led_N(0) <= LedCount(LedCount'high);
    Led_N(3 downto 1) <= led_n_intern (3 downto 1);
		
	-----------------------------------------------------------------------------------------------
	-- unused pins
	-----------------------------------------------------------------------------------------------

	I2c_Int_N			<= 'Z';
	Flash_Clk			<= 'Z'; -- startupe2 block is used
	Pwr_Good			<= 'Z';
	DDR3_VSEL			<= '0'; -- assign to '0' for DDR3L (1.35V) operation

end STRUCTURE;
