library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_driver_tb is
end entity vga_driver_tb;

architecture tb of vga_driver_tb is
	signal clk_25_tb : std_logic := '0';
	signal rst_n_tb  : std_logic := '1'; -- @suppress "signal rst_n_tb is never written"
	signal h_sync_tb : std_logic;       -- @suppress "signal h_sync_tb is never read"
	signal v_sync_tb : std_logic;       -- @suppress "signal v_sync_tb is never read"
	signal r_tb      : std_logic_vector(3 downto 0); -- @suppress "signal r_tb is never read"
	signal g_tb      : std_logic_vector(3 downto 0); -- @suppress "signal g_tb is never read"
	signal b_tb      : std_logic_vector(3 downto 0); -- @suppress "signal b_tb is never read"
begin
	dut : entity work.vga_driver
		port map(
			clk_25 => clk_25_tb,
			rst_n  => rst_n_tb,
			h_sync => h_sync_tb,
			v_sync => v_sync_tb,
			r      => r_tb,
			g      => g_tb,
			b      => b_tb,
			r_p    => open,
			g_p    => open,
			b_p    => open
		);
	process is
	begin
		wait for 1 ps;
		clk_25_tb <= not clk_25_tb;

	end process;
end architecture tb;
