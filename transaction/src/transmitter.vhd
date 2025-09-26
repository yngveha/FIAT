-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : transmitter.vhd
-- Author     : 
-- Company    : 
-- Created    : 
-- Last update: 2025-09-16
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
use ieee.numeric_std.all;

entity transmitter is
  generic (
    -- Width of S_AXI data bus
    C_S_AXI_DATA_WIDTH : integer := 32
    );
  port(
    clk  : in std_ulogic;
    rstn : in std_ulogic;

--    status  : out std_ulogic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--    control : in  std_ulogic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

    tx : out std_ulogic
    );
end transmitter;

architecture structural of transmitter is

  type state is (IDLESTATE, READSTATE);
  signal mst_exec_state : state;

  signal tx_data   : std_ulogic_vector(7 downto 0);
  signal tx_dv     : std_ulogic;
  signal tx_active : std_ulogic;
  signal tx_done   : std_ulogic;

  signal tx_o   : std_ulogic;


  signal device_id : std_ulogic_vector(7 downto 0);
  signal device_status : std_ulogic_vector(7 downto 0);

  component uart_tx is
    generic (
      g_CLKS_PER_BIT : integer := 115   -- Needs to be set correctly
      );
    port (
      i_Clk       : in  std_ulogic;
      i_TX_DV     : in  std_ulogic;
      i_TX_Byte   : in  std_ulogic_vector(7 downto 0);
      o_TX_Active : out std_ulogic;
      o_TX_Serial : out std_ulogic;
      o_TX_Done   : out std_ulogic
      );
  end component;

  component transaction_encoder is
    generic (
      TX_FREQUENCY : integer := 1000    -- packets per second
      );
    port(
      clk  : in std_ulogic;
      rstn : in std_ulogic;

      dout      : out std_ulogic_vector(7 downto 0);
      dv        : out std_ulogic;
      uart_done : in  std_ulogic;

      device_id : in std_ulogic_vector(7 downto 0);
      device_status   : in std_ulogic_vector(7 downto 0)
      );
  end component;


begin

  uart_tx_inst : uart_tx
    generic map(
      g_CLKS_PER_BIT => 866
      )
    port map (
      i_Clk       => clk,
      i_TX_DV     => tx_dv,
      i_TX_Byte   => tx_data,
      o_TX_Active => tx_active,
      o_TX_Serial => tx_o,
      o_TX_Done   => tx_done
      );

  transaction_encoder_inst : transaction_encoder
    generic map (
      TX_FREQUENCY => 80000           --h shall be 100 hz (100 0000)
      )
    port map (
      clk  => clk,
      rstn => rstn,--control(0),

      dout      => tx_data,
      dv        => tx_dv,
      uart_done => tx_done,

      device_id=> device_id,
      device_status   => device_status
      );


  device_id <= x"04";
  device_status <= x"ff";

  tx <= '1' when rstn = '0' else tx_o;
--  status(31)          <= watchdog_oe;
--  status(30 downto 1) <= (others => '0');  --x"0000";


end structural;
