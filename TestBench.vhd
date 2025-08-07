library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TestBench is
end TestBench;

architecture Behavioral of TestBench is

  component Top_CIA8 is
    port (
      clk, rst : in std_logic;
      A, B     : in std_logic_vector(7 downto 0);
      Cin      : in std_logic;
      Sum      : out std_logic_vector(8 downto 0)
    );
  end component;

  signal TB_A    : std_logic_vector(7 downto 0) := (others => '0');
  signal TB_B    : std_logic_vector(7 downto 0) := (others => '0');
  signal TB_C    : std_logic := '0';
  signal TB_Sum  : std_logic_vector(8 downto 0);
  signal clk     : std_logic := '0';
  signal rst     : std_logic := '0';

  constant clk_period : time := 10 ns;

begin

  uut: Top_CIA8
    port map (
      clk => clk,
      rst => rst,
      A   => TB_A,
      B   => TB_B,
      Cin => TB_C,
      Sum => TB_Sum
    );


  clk_proc: process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  
  stim_proc: process
    variable CorrectSUM : unsigned(8 downto 0);
  begin
    
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    wait for clk_period;

    
    for i in 0 to 255 loop
      for j in 0 to 255 loop
        TB_A <= std_logic_vector(to_unsigned(i, 8));
        TB_B <= std_logic_vector(to_unsigned(j, 8));
        TB_C <= '0';

       
        wait for clk_period;
        wait for clk_period;
        
        
        CorrectSUM := unsigned('0' & std_logic_vector(to_unsigned(i, 8))) +
                      unsigned('0' & std_logic_vector(to_unsigned(j, 8)));

       
      end loop;
    end loop;

    
    wait;
  end process;

end Behavioral;
