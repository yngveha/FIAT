-------------------------------------------------------------------------------
-- Title      : 
-- Project    : 
-------------------------------------------------------------------------------
-- File       : transaction_decoder.vhd
-- Author     : Alexander Wold
-- Company    : 
-- Created    : 
-- Last update: 2025-09-04
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transaction_decoder is
  port(
    clk  : in std_ulogic;
    rstn : in std_ulogic;

    din : in std_ulogic_vector(7 downto 0);
    dv  : in std_ulogic;

    message_valid : out std_ulogic
    );
end transaction_decoder;

architecture rtl of transaction_decoder is

  type state_type is (idle,
                      rx_preamble,
                      rx_data);

  signal state : state_type;

  signal crc_reg : unsigned(7 downto 0);

  signal r_crc : std_ulogic_vector(7 downto 0);

  signal r_strobe : std_ulogic;


  signal byte_counter : integer range 0 to 255 := 0;

  signal message_size : integer range 0 to 255;
  signal msg_valid    : std_ulogic;

begin

  message_valid <= msg_valid;

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '1' then
        state     <= idle;
        msg_valid <= '0';

        case state is
          when idle =>
            state   <= idle;
            crc_reg <= (others => '0');
            if dv = '1' and din = x"55" then
              state        <= rx_preamble;
              crc_reg      <= unsigned(din);
              byte_counter <= 1;
            end if;

          when rx_preamble =>
            state <= rx_preamble;

            if dv = '1' then
              if din = x"55" then
                state <= rx_data;
              else
                state <= idle;
              end if;
              crc_reg      <= crc_reg + unsigned(din);
              byte_counter <= 2;
            end if;


          when rx_data =>
            state <= rx_data;

            if dv = '1' then
              byte_counter <= byte_counter + 1;

              crc_reg <= crc_reg + unsigned(din);

              case byte_counter is
                -- set message size counter
                when 2 =>
                  message_size <= to_integer(unsigned(din));

                -- last byte
                when 7 =>
                  state    <= idle;
                  r_strobe <= '1';
                  -- add data here
                  if crc_reg = unsigned(din) then
                    msg_valid <= '1';
                  end if;

                when others =>

              end case;
            end if;

          when others =>
            state <= idle;
        end case;
      end if;
    end if;
  end process;

end architecture rtl;
