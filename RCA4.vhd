library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA4 is
  port(
    A, B: in std_logic_vector(3 downto 0);
    Cin: in std_logic;
    Sum: out std_logic_vector(4 downto 0);
    Cout: out std_logic
  );
end RCA4;

architecture rtl of RCA4 is
  signal carry : std_logic_vector(4 downto 0);
begin

  carry(0) <= Cin;

  RCA_PROC: for i in 0 to 3 generate
    begin
      process(A(i), B(i), carry(i))
      begin
        Sum(i) <= A(i) xor B(i) xor carry(i);
        carry(i+1) <= (A(i) and B(i)) or (A(i) and carry(i)) or (B(i) and carry(i));
      end process;
  end generate;

  Cout <= carry(4); 

end rtl;
