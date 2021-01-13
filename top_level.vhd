library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	port(
		MAX10_CLK1_50 : in  std_logic;
		VGA_VS        : out std_logic;
		VGA_HS        : out std_logic;
		VGA_R         : out std_logic_vector(3 downto 0);
		VGA_G         : out std_logic_vector(3 downto 0);
		VGA_B         : out std_logic_vector(3 downto 0)
	);
end entity top_level;

architecture RTL of top_level is
	signal clk_50 : std_logic;

begin
	system_clock : entity work.clock
		port map(
			areset => '0',
			inclk0 => MAX10_CLK1_50,
			c0     => clk_50,
			locked => open
		);
	internal_vga_driver : entity work.vga_driver
		port map(
			clk => clk_50,
			h_sync => VGA_HS,
			v_sync => VGA_VS,
			r => VGA_R,
			g => VGA_G,
			b => VGA_B
		);
end architecture RTL;
