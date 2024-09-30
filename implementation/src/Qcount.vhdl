library IEEE;
  use IEEE.std_logic_1164.all; 
  use IEEE.numeric_std.all;
  
entity Qcount is port( 
  clk, reset : in  std_logic; 
  count      : out std_logic_vector(2 downto 0));
end entity Qcount;

architecture RTL of Qcount is
  signal r_count, next_count : unsigned(count'range);  
begin
  process(clk) is begin 
    if rising_edge(clk) then 
      r_count <= (others => '0') when reset else next_count;
    end if;
  end process;
  count <= std_logic_vector(r_count); 
  next_count <= (others => '0') when r_count = 4 else r_count + 1;
end architecture RTL;

