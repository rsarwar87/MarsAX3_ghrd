
################################################################
# This is a generated script based on design: MarsAX3
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.4
set current_vivado_version [version -short]
set_property target_language VHDL [current_project]

global fpga_part
regexp (.*?)(csg).*?-([1-3]) ${fpga_part} whole_match part fpga_package speedgrade

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_msg_id "BD_TCL-1002" "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source MarsAX3_script.tcl

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
variable design_name
set design_name MarsAX3

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_iic:*\
xilinx.com:ip:axi_gpio:*\
xilinx.com:ip:axi_quad_spi:*\
xilinx.com:ip:axi_uartlite:*\
xilinx.com:ip:axi_timer:*\
xilinx.com:ip:xlconcat:*\
xilinx.com:ip:xadc_wiz:*\
xilinx.com:ip:mdm:*\
xilinx.com:ip:microblaze:*\
xilinx.com:ip:axi_intc:*\
xilinx.com:ip:proc_sys_reset:*\
xilinx.com:ip:axi_ethernet:*\
xilinx.com:ip:axi_dma:*\
xilinx.com:ip:clk_wiz:*\
xilinx.com:ip:mig_7series:*\
xilinx.com:ip:lmb_bram_if_cntlr:*\
xilinx.com:ip:lmb_v10:*\
xilinx.com:ip:blk_mem_gen:*\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}


##################################################################
# MIG PRJ FILE TCL PROCs
##################################################################

proc write_mig_file_MarsAX3_SDRAM_0 { str_mig_prj_filepath } {

   global fpga_package
   global speedgrade
   global part

   set mig_prj_file [open $str_mig_prj_filepath  w+]

   puts $mig_prj_file {<?xml version='1.0' encoding='UTF-8'?>}
   puts $mig_prj_file {<!-- IMPORTANT: This is an internal file that has been generated by the MIG software. Any direct editing or changes made to this file may result in unpredictable behavior or data corruption. It is strongly advised that users do not edit the contents of this file. Re-run the MIG GUI with the required settings if any of the options provided below need to be altered. -->}
   puts $mig_prj_file {<Project NoOfControllers="1" >}
   puts $mig_prj_file {    <ModuleName>MarsAX3_SDRAM_0</ModuleName>}
   puts $mig_prj_file {    <dci_inouts_inputs>1</dci_inouts_inputs>}
   puts $mig_prj_file {    <dci_inputs>1</dci_inputs>}
   puts $mig_prj_file {    <Debug_En>OFF</Debug_En>}
   puts $mig_prj_file {    <DataDepth_En>1024</DataDepth_En>}
   puts $mig_prj_file {    <LowPower_En>ON</LowPower_En>}
   puts $mig_prj_file {    <XADC_En>Disabled</XADC_En>}
   puts $mig_prj_file "    <TargetFPGA>${part}-${fpga_package}324/-${speedgrade}</TargetFPGA>"
   puts $mig_prj_file {    <Version>2.3</Version>}
   puts $mig_prj_file {    <SystemClock>Single-Ended</SystemClock>}
   puts $mig_prj_file {    <ReferenceClock>No Buffer</ReferenceClock>}
   puts $mig_prj_file {    <SysResetPolarity>ACTIVE LOW</SysResetPolarity>}
   puts $mig_prj_file {    <BankSelectionFlag>FALSE</BankSelectionFlag>}
   puts $mig_prj_file {    <InternalVref>0</InternalVref>}
   puts $mig_prj_file {    <dci_hr_inouts_inputs>50 Ohms</dci_hr_inouts_inputs>}
   puts $mig_prj_file {    <dci_cascade>0</dci_cascade>}
   puts $mig_prj_file {    <FPGADevice>}
   puts $mig_prj_file {        <selected>7a/xc7a35t-csg324</selected>}
   puts $mig_prj_file {        <selected>7a/xc7a50t-csg324</selected>}
   puts $mig_prj_file {        <selected>7a/xc7a75t-csg324</selected>}
   puts $mig_prj_file {    </FPGADevice>}
   puts $mig_prj_file {    <Controller number="0" >}
   puts $mig_prj_file {        <MemoryDevice>DDR3_SDRAM/Components/MT41K128M16XX-15E</MemoryDevice>}
   puts $mig_prj_file {        <TimePeriod>2500</TimePeriod>}
   puts $mig_prj_file {        <VccAuxIO>1.8V</VccAuxIO>}
   puts $mig_prj_file {        <PHYRatio>4:1</PHYRatio>}
   puts $mig_prj_file {        <InputClkFreq>50</InputClkFreq>}
   puts $mig_prj_file {        <UIExtraClocks>1</UIExtraClocks>}
   puts $mig_prj_file {        <MMCM_VCO>800</MMCM_VCO>}
   puts $mig_prj_file {        <MMCMClkOut0>16.00</MMCMClkOut0>}
   puts $mig_prj_file {        <MMCMClkOut1>4</MMCMClkOut1>}
   puts $mig_prj_file {        <MMCMClkOut2>1</MMCMClkOut2>}
   puts $mig_prj_file {        <MMCMClkOut3>1</MMCMClkOut3>}
   puts $mig_prj_file {        <MMCMClkOut4>1</MMCMClkOut4>}
   puts $mig_prj_file {        <DataWidth>16</DataWidth>}
   puts $mig_prj_file {        <DeepMemory>1</DeepMemory>}
   puts $mig_prj_file {        <DataMask>1</DataMask>}
   puts $mig_prj_file {        <ECC>Disabled</ECC>}
   puts $mig_prj_file {        <Ordering>Normal</Ordering>}
   puts $mig_prj_file {        <CustomPart>TRUE</CustomPart>}
   puts $mig_prj_file {        <NewPartName>Mars_AX3</NewPartName>}
   puts $mig_prj_file {        <RowAddress>14</RowAddress>}
   puts $mig_prj_file {        <ColAddress>10</ColAddress>}
   puts $mig_prj_file {        <BankAddress>3</BankAddress>}
   puts $mig_prj_file {        <MemoryVoltage>1.35V</MemoryVoltage>}
   puts $mig_prj_file {        <C0_MEM_SIZE>268435456</C0_MEM_SIZE>}
   puts $mig_prj_file {        <UserMemoryAddressMap>ROW_BANK_COLUMN</UserMemoryAddressMap>}
   puts $mig_prj_file {        <PinSelection>}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="J17" SLEW="" name="ddr3_addr[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="G16" SLEW="" name="ddr3_addr[10]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="G18" SLEW="" name="ddr3_addr[11]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="H16" SLEW="" name="ddr3_addr[12]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="G17" SLEW="" name="ddr3_addr[13]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="J14" SLEW="" name="ddr3_addr[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="J18" SLEW="" name="ddr3_addr[2]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="D18" SLEW="" name="ddr3_addr[3]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="J13" SLEW="" name="ddr3_addr[4]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="E17" SLEW="" name="ddr3_addr[5]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="K13" SLEW="" name="ddr3_addr[6]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="E18" SLEW="" name="ddr3_addr[7]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="H17" SLEW="" name="ddr3_addr[8]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="F18" SLEW="" name="ddr3_addr[9]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="D17" SLEW="" name="ddr3_ba[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="H14" SLEW="" name="ddr3_ba[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="K15" SLEW="" name="ddr3_ba[2]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="F16" SLEW="" name="ddr3_cas_n" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="C17" SLEW="" name="ddr3_ck_n[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="C16" SLEW="" name="ddr3_ck_p[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="G14" SLEW="" name="ddr3_cke[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="D15" SLEW="" name="ddr3_dm[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="D12" SLEW="" name="ddr3_dm[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="A18" SLEW="" name="ddr3_dq[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="B13" SLEW="" name="ddr3_dq[10]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="D14" SLEW="" name="ddr3_dq[11]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="F13" SLEW="" name="ddr3_dq[12]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="A11" SLEW="" name="ddr3_dq[13]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="F14" SLEW="" name="ddr3_dq[14]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="B11" SLEW="" name="ddr3_dq[15]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="E16" SLEW="" name="ddr3_dq[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="A15" SLEW="" name="ddr3_dq[2]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="E15" SLEW="" name="ddr3_dq[3]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="B18" SLEW="" name="ddr3_dq[4]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="B17" SLEW="" name="ddr3_dq[5]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="A16" SLEW="" name="ddr3_dq[6]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="B16" SLEW="" name="ddr3_dq[7]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="B14" SLEW="" name="ddr3_dq[8]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="C14" SLEW="" name="ddr3_dq[9]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="A14" SLEW="" name="ddr3_dqs_n[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="B12" SLEW="" name="ddr3_dqs_n[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="A13" SLEW="" name="ddr3_dqs_p[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="DIFF_SSTL135" PADName="C12" SLEW="" name="ddr3_dqs_p[1]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="K16" SLEW="" name="ddr3_odt[0]" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="F15" SLEW="" name="ddr3_ras_n" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="LVCMOS135" PADName="G13" SLEW="" name="ddr3_reset_n" IN_TERM="" />}
   puts $mig_prj_file {            <Pin VCCAUX_IO="" IOSTANDARD="SSTL135" PADName="J15" SLEW="" name="ddr3_we_n" IN_TERM="" />}
   puts $mig_prj_file {        </PinSelection>}
   puts $mig_prj_file {        <System_Clock>}
   puts $mig_prj_file {            <Pin PADName="P17(MRCC_P)" Bank="14" name="sys_clk_i" />}
   puts $mig_prj_file {        </System_Clock>}
   puts $mig_prj_file {        <System_Control>}
   puts $mig_prj_file {            <Pin PADName="N15(SRCC_P)" Bank="14" name="sys_rst" />}
   puts $mig_prj_file {            <Pin PADName="No connect" Bank="Select Bank" name="init_calib_complete" />}
   puts $mig_prj_file {            <Pin PADName="No connect" Bank="Select Bank" name="tg_compare_error" />}
   puts $mig_prj_file {        </System_Control>}
   puts $mig_prj_file {        <TimingParameters>}
   puts $mig_prj_file {            <Parameters twtr="7.5" trrd="7.5" trefi="7.8" tfaw="40" trtp="7.5" tcke="5.625" trfc="160" trp="15" tras="37.5" trcd="15" />}
   puts $mig_prj_file {        </TimingParameters>}
   puts $mig_prj_file {        <mrBurstLength name="Burst Length" >8 - Fixed</mrBurstLength>}
   puts $mig_prj_file {        <mrBurstType name="Read Burst Type and Length" >Sequential</mrBurstType>}
   puts $mig_prj_file {        <mrCasLatency name="CAS Latency" >6</mrCasLatency>}
   puts $mig_prj_file {        <mrMode name="Mode" >Normal</mrMode>}
   puts $mig_prj_file {        <mrDllReset name="DLL Reset" >No</mrDllReset>}
   puts $mig_prj_file {        <mrPdMode name="DLL control for precharge PD" >Slow Exit</mrPdMode>}
   puts $mig_prj_file {        <emrDllEnable name="DLL Enable" >Enable</emrDllEnable>}
   puts $mig_prj_file {        <emrOutputDriveStrength name="Output Driver Impedance Control" >RZQ/7</emrOutputDriveStrength>}
   puts $mig_prj_file {        <emrMirrorSelection name="Address Mirroring" >Disable</emrMirrorSelection>}
   puts $mig_prj_file {        <emrCSSelection name="Controller Chip Select Pin" >Disable</emrCSSelection>}
   puts $mig_prj_file {        <emrRTT name="RTT (nominal) - On Die Termination (ODT)" >RZQ/4</emrRTT>}
   puts $mig_prj_file {        <emrPosted name="Additive Latency (AL)" >0</emrPosted>}
   puts $mig_prj_file {        <emrOCD name="Write Leveling Enable" >Disabled</emrOCD>}
   puts $mig_prj_file {        <emrDQS name="TDQS enable" >Enabled</emrDQS>}
   puts $mig_prj_file {        <emrRDQS name="Qoff" >Output Buffer Enabled</emrRDQS>}
   puts $mig_prj_file {        <mr2PartialArraySelfRefresh name="Partial-Array Self Refresh" >Full Array</mr2PartialArraySelfRefresh>}
   puts $mig_prj_file {        <mr2CasWriteLatency name="CAS write latency" >5</mr2CasWriteLatency>}
   puts $mig_prj_file {        <mr2AutoSelfRefresh name="Auto Self Refresh" >Enabled</mr2AutoSelfRefresh>}
   puts $mig_prj_file {        <mr2SelfRefreshTempRange name="High Temparature Self Refresh Rate" >Normal</mr2SelfRefreshTempRange>}
   puts $mig_prj_file {        <mr2RTTWR name="RTT_WR - Dynamic On Die Termination (ODT)" >Dynamic ODT off</mr2RTTWR>}
   puts $mig_prj_file {        <PortInterface>AXI</PortInterface>}
   puts $mig_prj_file {        <AXIParameters>}
   puts $mig_prj_file {            <C0_C_RD_WR_ARB_ALGORITHM>RD_PRI_REG</C0_C_RD_WR_ARB_ALGORITHM>}
   puts $mig_prj_file {            <C0_S_AXI_ADDR_WIDTH>28</C0_S_AXI_ADDR_WIDTH>}
   puts $mig_prj_file {            <C0_S_AXI_DATA_WIDTH>32</C0_S_AXI_DATA_WIDTH>}
   puts $mig_prj_file {            <C0_S_AXI_ID_WIDTH>3</C0_S_AXI_ID_WIDTH>}
   puts $mig_prj_file {            <C0_S_AXI_SUPPORTS_NARROW_BURST>0</C0_S_AXI_SUPPORTS_NARROW_BURST>}
   puts $mig_prj_file {        </AXIParameters>}
   puts $mig_prj_file {    </Controller>}
   puts $mig_prj_file {</Project>}

   close $mig_prj_file
}
# End of write_mig_file_MarsAX3_SDRAM_0()



##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -from 0 -to 0 -type rst LMB_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr dlmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $dlmb_bram_if_cntlr

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr ilmb_bram_if_cntlr ]
  set_property -dict [ list \
   CONFIG.C_ECC {0} \
 ] $ilmb_bram_if_cntlr

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen lmb_bram ]
  set_property -dict [ list \
   CONFIG.Enable_B {Use_ENB_Pin} \
   CONFIG.Memory_Type {True_Dual_Port_RAM} \
   CONFIG.Port_B_Clock {100} \
   CONFIG.Port_B_Enable_Rate {100} \
   CONFIG.Port_B_Write_Rate {50} \
   CONFIG.Use_RSTB_Pin {true} \
   CONFIG.use_bram_block {BRAM_Controller} \
 ] $lmb_bram

  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]
  connect_bd_net -net microblaze_0_LMB_Rst [get_bd_pins LMB_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Memory
proc create_hier_cell_Memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_Memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR3
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S02_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S03_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S04_AXI

  # Create pins
  create_bd_pin -dir O -type clk Clk_50
  create_bd_pin -dir O -type clk Clk_100
  create_bd_pin -dir O -type clk Clk_200
  create_bd_pin -dir I -from 11 -to 0 device_temp_i
  create_bd_pin -dir I -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O mmcm_locked
  create_bd_pin -dir I -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -type clk sys_clk_i
  create_bd_pin -dir I -type rst sys_rst
  create_bd_pin -dir O -type rst ui_clk_sync_rst

  # Create instance: AXI_Mem, and set properties
  set AXI_Mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect AXI_Mem ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {5} \
 ] $AXI_Mem

  # Create instance: SDRAM, and set properties
  set SDRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series SDRAM ]

  # Generate the PRJ File for MIG
  set str_mig_folder [get_property IP_DIR [ get_ips [ get_property CONFIG.Component_Name $SDRAM ] ] ]
  set str_mig_file_name mig_a.prj
  set str_mig_file_path ${str_mig_folder}/${str_mig_file_name}

  write_mig_file_MarsAX3_SDRAM_0 $str_mig_file_path

  set_property -dict [ list \
   CONFIG.BOARD_MIG_PARAM {Custom} \
   CONFIG.MIG_DONT_TOUCH_PARAM {Custom} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.XML_INPUT_FILE {mig_a.prj} \
 ] $SDRAM

  # Create interface connections
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_MM2S [get_bd_intf_pins S02_AXI] [get_bd_intf_pins AXI_Mem/S02_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_S2MM [get_bd_intf_pins S03_AXI] [get_bd_intf_pins AXI_Mem/S03_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_SG [get_bd_intf_pins S04_AXI] [get_bd_intf_pins AXI_Mem/S04_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins AXI_Mem/M00_AXI] [get_bd_intf_pins SDRAM/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins S00_AXI] [get_bd_intf_pins AXI_Mem/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins S01_AXI] [get_bd_intf_pins AXI_Mem/S01_AXI]
  connect_bd_intf_net -intf_net mig_7series_0_DDR3 [get_bd_intf_pins DDR3] [get_bd_intf_pins SDRAM/DDR3]

  # Create port connections
  connect_bd_net -net SDRAM_ui_addn_clk_0 [get_bd_pins Clk_50] [get_bd_pins SDRAM/ui_addn_clk_0]
  connect_bd_net -net SDRAM_ui_addn_clk_1 [get_bd_pins Clk_200] [get_bd_pins SDRAM/clk_ref_i] [get_bd_pins SDRAM/ui_addn_clk_1]
  connect_bd_net -net device_temp_i_1 [get_bd_pins device_temp_i] [get_bd_pins SDRAM/device_temp_i]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins Clk_100] [get_bd_pins AXI_Mem/ACLK] [get_bd_pins AXI_Mem/M00_ACLK] [get_bd_pins AXI_Mem/S00_ACLK] [get_bd_pins AXI_Mem/S01_ACLK] [get_bd_pins AXI_Mem/S02_ACLK] [get_bd_pins AXI_Mem/S03_ACLK] [get_bd_pins AXI_Mem/S04_ACLK] [get_bd_pins SDRAM/ui_clk]
  connect_bd_net -net mig_7series_0_mmcm_locked [get_bd_pins mmcm_locked] [get_bd_pins SDRAM/mmcm_locked]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_pins ui_clk_sync_rst] [get_bd_pins SDRAM/ui_clk_sync_rst]
  connect_bd_net -net rst_mig_7series_0_100M_interconnect_aresetn [get_bd_pins interconnect_aresetn] [get_bd_pins AXI_Mem/ARESETN] [get_bd_pins AXI_Mem/M00_ARESETN] [get_bd_pins AXI_Mem/S00_ARESETN] [get_bd_pins AXI_Mem/S01_ARESETN] [get_bd_pins AXI_Mem/S02_ARESETN] [get_bd_pins AXI_Mem/S03_ARESETN] [get_bd_pins AXI_Mem/S04_ARESETN]
  connect_bd_net -net rst_mig_7series_0_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins SDRAM/aresetn]
  connect_bd_net -net sys_clk_i_1 [get_bd_pins sys_clk_i] [get_bd_pins SDRAM/sys_clk_i]
  connect_bd_net -net sys_rst_1 [get_bd_pins sys_rst] [get_bd_pins SDRAM/sys_rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Ethernet_0
proc create_hier_cell_Ethernet_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_Ethernet_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi

  # Create pins
  create_bd_pin -dir O -type intr interrupt
  create_bd_pin -dir O -type intr mac_irq
  create_bd_pin -dir O -type intr mm2s_introut
  create_bd_pin -dir O -from 0 -to 0 -type rst phy_rst_n
  create_bd_pin -dir I -type clk ref_clk
  create_bd_pin -dir I -type rst reset
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -type clk s_axi_lite_clk
  create_bd_pin -dir I -from 0 -to 0 -type rst s_axi_lite_resetn

  # Create instance: axi_ethernet_0, and set properties
  set axi_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet axi_ethernet_0 ]
  set_property -dict [ list \
   CONFIG.PHY_TYPE {RGMII} \
   CONFIG.RXCSUM {Full} \
   CONFIG.TXCSUM {Full} \
 ] $axi_ethernet_0

  # Create instance: axi_ethernet_0_dma, and set properties
  set axi_ethernet_0_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma axi_ethernet_0_dma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
   CONFIG.c_sg_length_width {16} \
   CONFIG.c_sg_use_stsapp_length {1} \
 ] $axi_ethernet_0_dma

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {125.247} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
   CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
   CONFIG.USE_LOCKED {false} \
 ] $clk_wiz_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_Peripherals_M03_AXI [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_ethernet_0_dma/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXIS_CNTRL [get_bd_intf_pins axi_ethernet_0/s_axis_txc] [get_bd_intf_pins axi_ethernet_0_dma/M_AXIS_CNTRL]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXIS_MM2S [get_bd_intf_pins axi_ethernet_0/s_axis_txd] [get_bd_intf_pins axi_ethernet_0_dma/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_MM2S [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_SG [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_SG]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd [get_bd_intf_pins axi_ethernet_0/m_axis_rxd] [get_bd_intf_pins axi_ethernet_0_dma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxs [get_bd_intf_pins axi_ethernet_0/m_axis_rxs] [get_bd_intf_pins axi_ethernet_0_dma/S_AXIS_STS]
  connect_bd_intf_net -intf_net axi_ethernet_0_mdio [get_bd_intf_pins mdio] [get_bd_intf_pins axi_ethernet_0/mdio]
  connect_bd_intf_net -intf_net axi_ethernet_0_rgmii [get_bd_intf_pins rgmii] [get_bd_intf_pins axi_ethernet_0/rgmii]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins s_axi] [get_bd_intf_pins axi_ethernet_0/s_axi]

  # Create port connections
  connect_bd_net -net axi_ethernet_0_dma_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_0/axi_txc_arstn] [get_bd_pins axi_ethernet_0_dma/mm2s_cntrl_reset_out_n]
  connect_bd_net -net axi_ethernet_0_dma_mm2s_introut [get_bd_pins mm2s_introut] [get_bd_pins axi_ethernet_0_dma/mm2s_introut]
  connect_bd_net -net axi_ethernet_0_dma_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_0/axi_txd_arstn] [get_bd_pins axi_ethernet_0_dma/mm2s_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_0_dma_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins axi_ethernet_0_dma/s2mm_introut]
  connect_bd_net -net axi_ethernet_0_dma_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_0/axi_rxd_arstn] [get_bd_pins axi_ethernet_0_dma/s2mm_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_0_dma_s2mm_sts_reset_out_n [get_bd_pins axi_ethernet_0/axi_rxs_arstn] [get_bd_pins axi_ethernet_0_dma/s2mm_sts_reset_out_n]
  connect_bd_net -net axi_ethernet_0_interrupt [get_bd_pins interrupt] [get_bd_pins axi_ethernet_0/interrupt]
  connect_bd_net -net axi_ethernet_0_mac_irq [get_bd_pins mac_irq] [get_bd_pins axi_ethernet_0/mac_irq]
  connect_bd_net -net axi_ethernet_0_phy_rst_n [get_bd_pins phy_rst_n] [get_bd_pins axi_ethernet_0/phy_rst_n]
  connect_bd_net -net gtx_clk_1 [get_bd_pins axi_ethernet_0/gtx_clk] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins s_axi_lite_clk] [get_bd_pins axi_ethernet_0/axis_clk] [get_bd_pins axi_ethernet_0/s_axi_lite_clk] [get_bd_pins axi_ethernet_0_dma/m_axi_mm2s_aclk] [get_bd_pins axi_ethernet_0_dma/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet_0_dma/m_axi_sg_aclk] [get_bd_pins axi_ethernet_0_dma/s_axi_lite_aclk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net mig_7series_0_ui_addn_clk_1 [get_bd_pins ref_clk] [get_bd_pins axi_ethernet_0/ref_clk]
  connect_bd_net -net reset_1 [get_bd_pins reset] [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net rst_mig_7series_0_100M_peripheral_aresetn [get_bd_pins s_axi_lite_resetn] [get_bd_pins axi_ethernet_0/s_axi_lite_resetn] [get_bd_pins axi_ethernet_0_dma/axi_resetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: CPU
proc create_hier_cell_CPU { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_CPU() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M03_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M04_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M06_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M07_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M08_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_DC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_IC

  # Create pins
  create_bd_pin -dir I -type clk Clk
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir I -from 7 -to 0 -type intr intr
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: AXI_Peripherals, and set properties
  set AXI_Peripherals [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect AXI_Peripherals ]
  set_property -dict [ list \
   CONFIG.NUM_MI {9} \
   CONFIG.NUM_SI {1} \
 ] $AXI_Peripherals

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm mdm_1 ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze microblaze_0 ]
  set_property -dict [ list \
   CONFIG.C_CACHE_BYTE_SIZE {8192} \
   CONFIG.C_DCACHE_BASEADDR {0x0000000080000000} \
   CONFIG.C_DCACHE_BYTE_SIZE {8192} \
   CONFIG.C_DCACHE_HIGHADDR {0x000000008FFFFFFF} \
   CONFIG.C_DEBUG_ENABLED {1} \
   CONFIG.C_D_AXI {1} \
   CONFIG.C_D_LMB {1} \
   CONFIG.C_ICACHE_BASEADDR {0x0000000080000000} \
   CONFIG.C_ICACHE_HIGHADDR {0x000000008FFFFFFF} \
   CONFIG.C_I_LMB {1} \
   CONFIG.C_USE_DCACHE {1} \
   CONFIG.C_USE_ICACHE {1} \
 ] $microblaze_0

  # Create instance: microblaze_0_axi_intc, and set properties
  set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc microblaze_0_axi_intc ]
  set_property -dict [ list \
   CONFIG.C_HAS_FAST {1} \
 ] $microblaze_0_axi_intc

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory

  # Create instance: rst_system, and set properties
  set rst_system [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_system ]

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_Peripherals_M03_AXI [get_bd_intf_pins M03_AXI] [get_bd_intf_pins AXI_Peripherals/M03_AXI]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M04_AXI] [get_bd_intf_pins AXI_Peripherals/M04_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M05_AXI] [get_bd_intf_pins AXI_Peripherals/M05_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M06_AXI] [get_bd_intf_pins AXI_Peripherals/M06_AXI]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M07_AXI] [get_bd_intf_pins AXI_Peripherals/M07_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M08_AXI] [get_bd_intf_pins AXI_Peripherals/M08_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins M_AXI_DC] [get_bd_intf_pins microblaze_0/M_AXI_DC]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins M_AXI_IC] [get_bd_intf_pins microblaze_0/M_AXI_IC]
  connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins AXI_Peripherals/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins M01_AXI] [get_bd_intf_pins AXI_Peripherals/M01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins M02_AXI] [get_bd_intf_pins AXI_Peripherals/M02_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net microblaze_0_intc_axi [get_bd_intf_pins AXI_Peripherals/M00_AXI] [get_bd_intf_pins microblaze_0_axi_intc/s_axi]
  connect_bd_intf_net -intf_net microblaze_0_interrupt [get_bd_intf_pins microblaze_0/INTERRUPT] [get_bd_intf_pins microblaze_0_axi_intc/interrupt]

  # Create port connections
  connect_bd_net -net intr_1 [get_bd_pins intr] [get_bd_pins microblaze_0_axi_intc/intr]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_system/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins Clk] [get_bd_pins AXI_Peripherals/ACLK] [get_bd_pins AXI_Peripherals/M00_ACLK] [get_bd_pins AXI_Peripherals/M01_ACLK] [get_bd_pins AXI_Peripherals/M02_ACLK] [get_bd_pins AXI_Peripherals/M03_ACLK] [get_bd_pins AXI_Peripherals/M04_ACLK] [get_bd_pins AXI_Peripherals/M05_ACLK] [get_bd_pins AXI_Peripherals/M06_ACLK] [get_bd_pins AXI_Peripherals/M07_ACLK] [get_bd_pins AXI_Peripherals/M08_ACLK] [get_bd_pins AXI_Peripherals/S00_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_intc/processor_clk] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_system/slowest_sync_clk]
  connect_bd_net -net mig_7series_0_mmcm_locked [get_bd_pins dcm_locked] [get_bd_pins rst_system/dcm_locked]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_pins ext_reset_in] [get_bd_pins rst_system/ext_reset_in]
  connect_bd_net -net rst_mig_7series_0_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/LMB_Rst] [get_bd_pins rst_system/bus_struct_reset]
  connect_bd_net -net rst_mig_7series_0_100M_interconnect_aresetn [get_bd_pins interconnect_aresetn] [get_bd_pins AXI_Peripherals/ARESETN] [get_bd_pins rst_system/interconnect_aresetn]
  connect_bd_net -net rst_mig_7series_0_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins microblaze_0_axi_intc/processor_rst] [get_bd_pins rst_system/mb_reset]
  connect_bd_net -net rst_mig_7series_0_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins AXI_Peripherals/M00_ARESETN] [get_bd_pins AXI_Peripherals/M01_ARESETN] [get_bd_pins AXI_Peripherals/M02_ARESETN] [get_bd_pins AXI_Peripherals/M03_ARESETN] [get_bd_pins AXI_Peripherals/M04_ARESETN] [get_bd_pins AXI_Peripherals/M05_ARESETN] [get_bd_pins AXI_Peripherals/M06_ARESETN] [get_bd_pins AXI_Peripherals/M07_ARESETN] [get_bd_pins AXI_Peripherals/M08_ARESETN] [get_bd_pins AXI_Peripherals/S00_ARESETN] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins rst_system/peripheral_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR3 ]
  set Led_N [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 Led_N ]
  set UART_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART_0 ]
  set iic_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_0 ]
  set mdio [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio ]
  set rgmii [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii ]
  set spi_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi_0 ]

  # Create ports
  set CLK_50 [ create_bd_port -dir O -type clk CLK_50 ]
  set phy_rst_n [ create_bd_port -dir O -from 0 -to 0 -type rst phy_rst_n ]
  set sys_clk_i [ create_bd_port -dir I -type clk sys_clk_i ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {50000000} \
 ] $sys_clk_i
  set sys_rst [ create_bd_port -dir I -type rst sys_rst ]

  # Create instance: CPU
  create_hier_cell_CPU [current_bd_instance .] CPU

  # Create instance: Ethernet_0
  create_hier_cell_Ethernet_0 [current_bd_instance .] Ethernet_0

  # Create instance: IIC_0, and set properties
  set IIC_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic IIC_0 ]

  # Create instance: LEDs, and set properties
  set LEDs [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio LEDs ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_DOUT_DEFAULT {0x000000FF} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $LEDs

  # Create instance: Memory
  create_hier_cell_Memory [current_bd_instance .] Memory

  # Create instance: SPI_FLASH, and set properties
  set SPI_FLASH [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi SPI_FLASH ]
  set_property -dict [ list \
   CONFIG.C_SCK_RATIO {2} \
   CONFIG.C_TYPE_OF_AXI4_INTERFACE {1} \
   CONFIG.C_USE_STARTUP {1} \
 ] $SPI_FLASH

  # Create instance: UART_0, and set properties
  set UART_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite UART_0 ]
  set_property -dict [ list \
   CONFIG.C_BAUDRATE {115200} \
 ] $UART_0

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer axi_timer_0 ]

  # Create instance: interrupt_concat, and set properties
  set interrupt_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat interrupt_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $interrupt_concat

  # Create instance: xadc_wiz_0, and set properties
  set xadc_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz xadc_wiz_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_RESET {false} \
   CONFIG.ENABLE_TEMP_BUS {true} \
   CONFIG.INTERFACE_SELECTION {Enable_AXI} \
   CONFIG.TEMPERATURE_ALARM_OT_TRIGGER {85} \
 ] $xadc_wiz_0

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /xadc_wiz_0/s_axi_lite]

  # Create interface connections
  connect_bd_intf_net -intf_net AXI_Peripherals_M03_AXI [get_bd_intf_pins CPU/M03_AXI] [get_bd_intf_pins Ethernet_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net CPU_M04_AXI [get_bd_intf_pins CPU/M04_AXI] [get_bd_intf_pins axi_timer_0/S_AXI]
  connect_bd_intf_net -intf_net CPU_M05_AXI [get_bd_intf_pins CPU/M05_AXI] [get_bd_intf_pins IIC_0/S_AXI]
  connect_bd_intf_net -intf_net CPU_M06_AXI [get_bd_intf_pins CPU/M06_AXI] [get_bd_intf_pins LEDs/S_AXI]
  connect_bd_intf_net -intf_net CPU_M07_AXI [get_bd_intf_pins CPU/M07_AXI] [get_bd_intf_pins SPI_FLASH/AXI_FULL]
  connect_bd_intf_net -intf_net CPU_M08_AXI [get_bd_intf_pins CPU/M08_AXI] [get_bd_intf_pins xadc_wiz_0/s_axi_lite]
  connect_bd_intf_net -intf_net IIC_0_IIC [get_bd_intf_ports iic_0] [get_bd_intf_pins IIC_0/IIC]
  connect_bd_intf_net -intf_net LEDs_GPIO [get_bd_intf_ports Led_N] [get_bd_intf_pins LEDs/GPIO]
  connect_bd_intf_net -intf_net SPI_FLASH_SPI_0 [get_bd_intf_ports spi_0] [get_bd_intf_pins SPI_FLASH/SPI_0]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_MM2S [get_bd_intf_pins Ethernet_0/M_AXI_MM2S] [get_bd_intf_pins Memory/S02_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_S2MM [get_bd_intf_pins Ethernet_0/M_AXI_S2MM] [get_bd_intf_pins Memory/S03_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_SG [get_bd_intf_pins Ethernet_0/M_AXI_SG] [get_bd_intf_pins Memory/S04_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_mdio [get_bd_intf_ports mdio] [get_bd_intf_pins Ethernet_0/mdio]
  connect_bd_intf_net -intf_net axi_ethernet_0_rgmii [get_bd_intf_ports rgmii] [get_bd_intf_pins Ethernet_0/rgmii]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports UART_0] [get_bd_intf_pins UART_0/UART]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DC [get_bd_intf_pins CPU/M_AXI_DC] [get_bd_intf_pins Memory/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_IC [get_bd_intf_pins CPU/M_AXI_IC] [get_bd_intf_pins Memory/S01_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins CPU/M01_AXI] [get_bd_intf_pins UART_0/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins CPU/M02_AXI] [get_bd_intf_pins Ethernet_0/s_axi]
  connect_bd_intf_net -intf_net mig_7series_0_DDR3 [get_bd_intf_ports DDR3] [get_bd_intf_pins Memory/DDR3]

  # Create port connections
  connect_bd_net -net Clk_50 [get_bd_ports CLK_50] [get_bd_pins Memory/Clk_50] [get_bd_pins SPI_FLASH/ext_spi_clk]
  connect_bd_net -net Clk_100 [get_bd_pins CPU/Clk] [get_bd_pins Ethernet_0/s_axi_lite_clk] [get_bd_pins IIC_0/s_axi_aclk] [get_bd_pins LEDs/s_axi_aclk] [get_bd_pins Memory/Clk_100] [get_bd_pins SPI_FLASH/s_axi4_aclk] [get_bd_pins UART_0/s_axi_aclk] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins xadc_wiz_0/s_axi_aclk]
  connect_bd_net -net Clk_200 [get_bd_pins Ethernet_0/ref_clk] [get_bd_pins Memory/Clk_200]
  connect_bd_net -net Ethernet_0_interrupt [get_bd_pins Ethernet_0/interrupt] [get_bd_pins interrupt_concat/In1]
  connect_bd_net -net Ethernet_0_mac_irq [get_bd_pins Ethernet_0/mac_irq] [get_bd_pins interrupt_concat/In2]
  connect_bd_net -net Ethernet_0_mm2s_introut [get_bd_pins Ethernet_0/mm2s_introut] [get_bd_pins interrupt_concat/In3]
  connect_bd_net -net Ethernet_0_s2mm_introut [get_bd_pins Ethernet_0/s2mm_introut] [get_bd_pins interrupt_concat/In4]
  connect_bd_net -net IIC_0_iic2intc_irpt [get_bd_pins IIC_0/iic2intc_irpt] [get_bd_pins interrupt_concat/In6]
  connect_bd_net -net SPI_FLASH_ip2intc_irpt [get_bd_pins SPI_FLASH/ip2intc_irpt] [get_bd_pins interrupt_concat/In7]
  connect_bd_net -net UART_0_interrupt [get_bd_pins UART_0/interrupt] [get_bd_pins interrupt_concat/In0]
  connect_bd_net -net axi_ethernet_0_phy_rst_n [get_bd_ports phy_rst_n] [get_bd_pins Ethernet_0/phy_rst_n]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins interrupt_concat/In5]
  connect_bd_net -net interconnect_aresetn [get_bd_pins CPU/interconnect_aresetn] [get_bd_pins Memory/interconnect_aresetn]
  connect_bd_net -net interrupt_concat_dout [get_bd_pins CPU/intr] [get_bd_pins interrupt_concat/dout]
  connect_bd_net -net mig_7series_0_mmcm_locked [get_bd_pins CPU/dcm_locked] [get_bd_pins Memory/mmcm_locked]
  connect_bd_net -net mig_7series_0_ui_clk_sync_rst [get_bd_pins CPU/ext_reset_in] [get_bd_pins Ethernet_0/reset] [get_bd_pins Memory/ui_clk_sync_rst]
  connect_bd_net -net peripheral_aresetn [get_bd_pins CPU/peripheral_aresetn] [get_bd_pins Ethernet_0/s_axi_lite_resetn] [get_bd_pins IIC_0/s_axi_aresetn] [get_bd_pins LEDs/s_axi_aresetn] [get_bd_pins Memory/peripheral_aresetn] [get_bd_pins SPI_FLASH/s_axi4_aresetn] [get_bd_pins UART_0/s_axi_aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins xadc_wiz_0/s_axi_aresetn]
  connect_bd_net -net sys_clk_i_1 [get_bd_ports sys_clk_i] [get_bd_pins Memory/sys_clk_i]
  connect_bd_net -net sys_rst_1 [get_bd_ports sys_rst] [get_bd_pins Memory/sys_rst]
  connect_bd_net -net xadc_wiz_0_temp_out [get_bd_pins Memory/device_temp_i] [get_bd_pins xadc_wiz_0/temp_out]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x40800000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs IIC_0/S_AXI/Reg] SEG_IIC_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40000000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs LEDs/S_AXI/Reg] SEG_LEDs_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x40A00000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs SPI_FLASH/aximm/MEM0] SEG_SPI_FLASH_MEM0
  create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs UART_0/S_AXI/Reg] SEG_UART_0_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0x40C00000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs Ethernet_0/axi_ethernet_0/s_axi/Reg0] SEG_axi_ethernet_0_Reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x41E00000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs Ethernet_0/axi_ethernet_0_dma/S_AXI_LITE/Reg] SEG_axi_ethernet_0_dma_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41C00000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] SEG_axi_timer_0_Reg
  create_bd_addr_seg -range 0x00004000 -offset 0x00000000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs CPU/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00004000 -offset 0x00000000 [get_bd_addr_spaces CPU/microblaze_0/Instruction] [get_bd_addr_segs CPU/microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs CPU/microblaze_0_axi_intc/S_AXI/Reg] SEG_microblaze_0_axi_intc_Reg
  create_bd_addr_seg -range 0x10000000 -offset 0x80000000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs Memory/SDRAM/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x10000000 -offset 0x80000000 [get_bd_addr_spaces CPU/microblaze_0/Instruction] [get_bd_addr_segs Memory/SDRAM/memmap/memaddr] SEG_mig_7series_0_memaddr
  create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces CPU/microblaze_0/Data] [get_bd_addr_segs xadc_wiz_0/s_axi_lite/Reg] SEG_xadc_wiz_0_Reg
  create_bd_addr_seg -range 0x10000000 -offset 0x80000000 [get_bd_addr_spaces Ethernet_0/axi_ethernet_0_dma/Data_SG] [get_bd_addr_segs Memory/SDRAM/memmap/memaddr] SEG_SDRAM_memaddr
  create_bd_addr_seg -range 0x10000000 -offset 0x80000000 [get_bd_addr_spaces Ethernet_0/axi_ethernet_0_dma/Data_MM2S] [get_bd_addr_segs Memory/SDRAM/memmap/memaddr] SEG_SDRAM_memaddr
  create_bd_addr_seg -range 0x10000000 -offset 0x80000000 [get_bd_addr_spaces Ethernet_0/axi_ethernet_0_dma/Data_S2MM] [get_bd_addr_segs Memory/SDRAM/memmap/memaddr] SEG_SDRAM_memaddr


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


