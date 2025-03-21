library IEEE;
  use IEEE.std_logic_1164.all; 
  use IEEE.numeric_std.all;

entity tb_fiat is
end entity tb_fiat;

architecture behavioral of tb_fiat is  
  component Qcount is port( 
    clk, reset       : in  std_logic; 
    count            : out std_logic_vector(2 downto 0));
  end component Qcount;
  
  constant N: integer := 3;
  signal clk, reset : std_logic := '1';
  signal tQcount      : integer := 0;
  signal count       : std_logic_vector(N-1 downto 0);
  
begin 

  DUT: Qcount 
    port map(
      reset => reset,
      clk => clk,
      count => count      
    );

  BEHAVIORAL_MODEL:
    process is 
    begin
      wait until rising_edge(clk);    
      tQcount <= 
        0 when reset else 
        0 when tQcount = 4 else
        tQcount+1;
    end process;
  
  CLOCK: 
    clk <= not clk after 5 ns;
    
  CHECKS:
    process is 
      variable DUTcount: integer; 
    begin 
      wait until clk'event;
      DUTcount := to_integer(unsigned(count));      
      --model equivalence
      assert DUTcount = tQcount report("count (" & integer'image(DUTcount) & 
        ") != behavioral model: ("& integer'image(tQcount) & ")");
      --maximum value 
      assert DUTcount < 5 report ("count (" & integer'image(DUTcount) & ") > 4, ** Maximum value exceeded");
    end process;  
    
  
  FAULT_INJECTION:
    process is
      procedure reset_and_wait(count_value: integer) is 
      begin 
        wait until unsigned(count) = 0;
        reset <= '1';
        wait until rising_edge(clk);
        reset <= '0';
        wait until unsigned(count) = count_value;
        wait until falling_edge(clk);
      end procedure;
      
      procedure BLACKBOX_INJECT_TOO_HIGH_VALUE is 
        constant force_value : integer := 5;
      begin        
        count <= force std_logic_vector(to_unsigned(force_value, N));  
        wait until rising_edge(clk);
        count <= release;
      end procedure;
 
      procedure WHITEBOX_INJECT_TOO_HIGH_VALUE is
        constant force_value : integer := 6;
        alias wb_count is <<signal DUT.r_count : unsigned(N-1 downto 0)>>;
      begin        
        wb_count <= force to_unsigned(force_value, N);
        wait until rising_edge(clk);
        wb_count <= release;
      end procedure;
  
    begin
      reset_and_wait(2);
      BLACKBOX_INJECT_TOO_HIGH_VALUE;
      reset_and_wait(3);
      WHITEBOX_INJECT_TOO_HIGH_VALUE;
      reset_and_wait(4);
      std.env.stop;
    end process;
  
end architecture behavioral;