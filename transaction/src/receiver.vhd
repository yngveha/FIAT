-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : 
-- Author     : 
-- Company    : 
-- Created    : 
-- Last update: 2025-09-04
-- Platform   : 
-- Standard   : VHDL'93/02
-- 
-- Description: 
--
-- Copyright (c) 2019
-- 
-- Revisions  :
-- Date        Version  Author  Description

-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity receiver is
  port(
    clk  : in std_ulogic;
    rstn : in std_ulogic;

    --device_id : in std_ulogic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    --device_status : in std_ulogic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    message_valid : out std_ulogic;

    rx : in std_ulogic
    );
end receiver;

architecture structural of receiver is
  signal rx_data : std_ulogic_vector(7 downto 0);
  signal rx_dv   : std_ulogic;

  component uart_rx is
    generic (
      g_CLKS_PER_BIT : integer := 115   
      );
    port (
      i_Clk       : in  std_ulogic;
      i_RX_Serial : in  std_ulogic;
      o_RX_DV     : out std_ulogic;
      o_RX_Byte   : out std_ulogic_vector(7 downto 0)
      );
  end component;

  component transaction_decoder is
    port (
      clk           : in  std_ulogic;
      rstn          : in  std_ulogic;
      din           : in  std_ulogic_vector(7 downto 0);
      dv            : in  std_ulogic;
      message_valid : out std_ulogic
      );
  end component;


begin

  uart_rx_inst : uart_rx
    generic map(
      --g_CLKS_PER_BIT => 800
      -- 100 000 000 Mhz / 115200
      -- 865 gives 17.27
      g_CLKS_PER_BIT => 866  --68 868 gives 17.36 want 17.31 800 gives 16
      )
    port map (
      i_Clk       => clk,
      i_RX_Serial => rx,
      o_RX_DV     => rx_dv,
      o_RX_Byte   => rx_data
      );

  transaction_decoder_inst : transaction_decoder
    port map (
      clk           => clk,
      rstn          => rstn,
      din           => rx_data,
      dv            => rx_dv,
      message_valid => message_valid
      );

end structural;
