-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : 
-- Author     : 
-- Company    : 
-- Created    : 
-- Last update: 2025-09-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Copyright (c) 2025
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transaction_encoder is
  generic (
    TX_FREQUENCY : integer := 1000
    );
  port(
    clk  : in std_ulogic;
    rstn : in std_ulogic;

    dout      : out std_ulogic_vector(7 downto 0);
    dv        : out std_ulogic;
    uart_done : in  std_ulogic;

    device_id     : in std_ulogic_vector(7 downto 0);
    device_status : in std_ulogic_vector(7 downto 0)
    );
end transaction_encoder;

architecture rtl of transaction_encoder is

  type state_type is (idle_s,
                      tx_preamble_s,
                      tx_data_s);

  signal state : state_type;

  signal crc_reg : u_unsigned(7 downto 0);

  signal msg_type : std_ulogic_vector(7 downto 0);

  signal r_control : std_ulogic_vector(31 downto 0);
  signal r_crc     : std_ulogic_vector(7 downto 0);

  signal r_irig_ms : std_ulogic_vector(9 downto 0);

  signal tx_data : std_ulogic_vector(7 downto 0);
  signal tx_dv   : std_ulogic;

  signal cnt : integer range 0 to 1048575 := 0;

  signal byte_counter : integer range 0 to 20 := 0;

begin  -- architecture rtl

  dout <= tx_data;
  dv   <= tx_dv;

  process(clk)
  begin
    if rising_edge(clk) then
      tx_dv   <= '0';
      tx_data <= (others => '0');
      cnt     <= cnt + 1;

      if rstn = '0' then
        state        <= idle_s;
        byte_counter <= 0;
        cnt          <= 0;
      else

        case state is
          when idle_s =>
            state <= idle_s;

            if cnt > TX_FREQUENCY then
              cnt          <= 0;
              state        <= tx_preamble_s;
              tx_dv        <= '1';
              tx_data      <= x"55";
              crc_reg      <= x"55";
              byte_counter <= 1;
            end if;

          when tx_preamble_s =>
            state <= tx_preamble_s;

            if uart_done = '1' then
              state        <= tx_data_s;
              tx_dv        <= '1';
              tx_data      <= x"55";
              crc_reg      <= crc_reg+x"55";
              byte_counter <= 2;
            end if;

          when tx_data_s =>
            state <= tx_data_s;

            if uart_done = '1' then
              tx_dv        <= '1';
              byte_counter <= byte_counter + 1;

              case byte_counter is      -- msg type
                when 2 =>
                  tx_data <= x"02";
                  crc_reg <= crc_reg+x"02";

                when 3 =>               -- msg size
                  tx_data <= x"0f";
                  crc_reg <= crc_reg+x"0f";

                when 4 =>               -- device_id
                  tx_data <= device_id(7 downto 0);
                  crc_reg <= crc_reg+u_unsigned(device_id(7 downto 0));

                when 5 =>               -- device_status
                  tx_data <= device_status(7 downto 0);
                  crc_reg <= crc_reg+u_unsigned(device_status(7 downto 0));

                when 6 =>
                  tx_data <= std_ulogic_vector(crc_reg);
                  state   <= idle_s;

                when others =>

              end case;

            end if;

          when others =>
            state <= idle_s;
        end case;
      end if;
    end if;
  end process;

end architecture rtl;
