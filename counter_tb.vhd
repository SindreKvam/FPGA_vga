library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end entity counter_tb;

architecture tb of counter_tb is
	signal clk_tb   : std_logic                     := '0';
	signal rst_n_tb : std_logic                     := '1'; -- @suppress "signal rst_n_tb is never written"
	signal cnt_tb   : std_logic_vector(31 downto 0) := (others => '0');
	signal clk_o_tb : std_logic;        -- @suppress "signal clk_o_tb is never read"
begin
	dut : entity work.counter
		port map(
			clk   => clk_tb,
			rst_n => rst_n_tb,
			cnt   => cnt_tb,
			clk_o => clk_o_tb
		);
	process is
	begin
		wait for 100 ps;
		clk_tb <= not clk_tb;
		cnt_tb <= X"00000002";

	end process;
end architecture tb;
