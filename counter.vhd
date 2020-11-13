library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	port(
		clk    : in  std_logic;
		rst_n  : in  std_logic;
		cnt    : in  std_logic_vector(31 downto 0) := (others => '0');
		clk_o : out std_logic                    := '0'
	);
end entity counter;

architecture RTL of counter is
	signal current_count : natural;
begin
	process(clk) is
	begin
		if rising_edge(clk) then
			if rst_n = '0' then
				current_count <= 0;
			else
				if current_count < to_integer(unsigned(cnt)) then
					current_count <= current_count + 1;
				else
					clk_o <= not clk_o;
				end if;
			end if;
		end if;
	end process;
end architecture RTL;
