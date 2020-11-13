library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end entity counter_tb;

architecture tb of counter_tb is
	signal clk_tb    : std_logic                    := '0';
	signal rst_n_tb  : std_logic                    := '1';
	signal cnt_tb    : std_logic_vector(3 downto 0) := (others => '0');
	signal clk_25_tb : std_logic;
begin
	dut : entity work.counter
		port map(
			clk    => clk_tb,
			rst_n  => rst_n_tb,
			cnt    => cnt_tb,
			clk_25 => clk_25_tb
		);
	process is
	begin
		wait for 100 ps;
		clk_tb <= not clk_tb;
		cnt_tb <= X"2";

	end process;
end architecture tb;
