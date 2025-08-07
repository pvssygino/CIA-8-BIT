library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopRCA is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        A     : in  std_logic_vector(7 downto 0);
        B     : in  std_logic_vector(7 downto 0);
        Cin   : in  std_logic;
        Sum   : out std_logic_vector(9 downto 0)
    );
end TopRCA;

architecture Behavioral of TopRCA is

    component RCA4 is
        Port (
            A    : in  std_logic_vector(3 downto 0);
            B    : in  std_logic_vector(3 downto 0);
            Cin  : in  std_logic;
            Sum  : out std_logic_vector(4 downto 0);
            Cout : out std_logic
        );
    end component;

    signal Sum0, Sum1, Sum1_inc, Sum1_mux : std_logic_vector(4 downto 0);
    signal Sum0_reg : std_logic_vector(4 downto 0);
    signal Sum_final : std_logic_vector(9 downto 0);
    signal Carry0 : std_logic;
    signal Carry0_reg : std_logic;

begin
    U_RCA0: RCA4
        port map (
            A    => A(3 downto 0),
            B    => B(3 downto 0),
            Cin  => Cin,
            Sum  => Sum0,
            Cout => Carry0
        );
    U_RCA1: RCA4
        port map (
            A    => A(7 downto 4),
            B    => B(7 downto 4),
            Cin  => '0',
            Sum  => Sum1,
            Cout => open
        );
    Sum1_inc <= std_logic_vector(unsigned(Sum1) + 1);

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                Carry0_reg <= '0';
            else
                Carry0_reg <= Carry0;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                Sum0_reg <= (others => '0');
            else
                Sum0_reg <= Sum0;
            end if;
        end if;
    end process;
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                Sum1_mux <= (others => '0');
            else
                if Carry0_reg = '0' then
                    Sum1_mux <= Sum1;
                else
                    Sum1_mux <= Sum1_inc;
                end if;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                Sum_final <= (others => '0');
            else
                Sum_final <= Sum1_mux & Sum0_reg;
            end if;
        end if;
    end process;

    Sum <= Sum_final;

end Behavioral;
