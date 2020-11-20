library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	port(
		MAX10_CLK1_50 : in  std_logic;
		VGA_VS        : out std_logic;
		VGA_HS        : out std_logic;
		KEY           : in  std_logic_vector(1 downto 0);
		VGA_R         : out std_logic_vector(3 downto 0);
		VGA_G         : out std_logic_vector(3 downto 0);
		VGA_B         : out std_logic_vector(3 downto 0);
		HEX0          : out std_logic_vector(7 downto 0);
		HEX1          : out std_logic_vector(7 downto 0);
		HEX2          : out std_logic_vector(7 downto 0);
		HEX3          : out std_logic_vector(7 downto 0);
		HEX4          : out std_logic_vector(7 downto 0);
		HEX5          : out std_logic_vector(7 downto 0)
	);
end entity top_level;

architecture RTL of top_level is
	signal clk_50 : std_logic;
	signal clk_25 : std_logic;

	-- Internal colour values to send in to the binary to bcd.
	signal r : std_logic_vector(3 downto 0);
	signal g : std_logic_vector(3 downto 0);
	signal b : std_logic_vector(3 downto 0);

	-- For drawing the colour values on the 7-seg displays
	signal bcd_0_r : std_logic_vector(3 downto 0);
	signal bcd_1_r : std_logic_vector(3 downto 0);
	signal bcd_0_g : std_logic_vector(3 downto 0);
	signal bcd_1_g : std_logic_vector(3 downto 0);
	signal bcd_0_b : std_logic_vector(3 downto 0);
	signal bcd_1_b : std_logic_vector(3 downto 0);

begin
	system_clock : entity work.clock
		port map(
			areset => '0',
			inclk0 => MAX10_CLK1_50,
			c0     => clk_50,
			locked => open
		);
	clock_divider : entity work.counter
		port map(
			clk   => clk_50,
			rst_n => KEY(0),
			cnt   => X"00000002",
			clk_o => clk_25
		);
	internal_vga_driver : entity work.vga_driver
		port map(
			clk_25 => clk_25,
			rst_n  => KEY(1),
			h_sync => VGA_HS,
			v_sync => VGA_VS,
			r      => VGA_R,
			g      => VGA_G,
			b      => VGA_B,
			r_p    => r,
			g_p    => g,
			b_p    => b
		);
	bin_to_bcd_r : entity work.binary_to_bcd
		port map(
			binary => r,
			bcd_0  => bcd_0_r,
			bcd_1  => bcd_1_r
		);
	bin_to_bcd_g : entity work.binary_to_bcd
		port map(
			binary => g,
			bcd_0  => bcd_0_g,
			bcd_1  => bcd_1_g
		);
	bin_to_bcd_b : entity work.binary_to_bcd
		port map(
			binary => b,
			bcd_0  => bcd_0_b,
			bcd_1  => bcd_1_b
		);
	bcd_to_7_r_0 : entity work.bcd_to_7_segment
		port map(
			bcd       => bcd_0_r,
			dot       => '0',
			seven_seg => HEX4
		);
	bcd_to_7_r_1 : entity work.bcd_to_7_segment
		port map(
			bcd       => bcd_1_r,
			dot       => '0',
			seven_seg => HEX5
		);
	bcd_to_7_g_0 : entity work.bcd_to_7_segment
		port map(
			bcd       => bcd_0_g,
			dot       => '0',
			seven_seg => HEX2
		);
	bcd_to_7_g_1 : entity work.bcd_to_7_segment
		port map(
			bcd       => bcd_1_g,
			dot       => '0',
			seven_seg => HEX3
		);
	bcd_to_7_b_0 : entity work.bcd_to_7_segment
		port map(
			bcd       => bcd_0_b,
			dot       => '0',
			seven_seg => HEX0
		);
	bcd_to_7_b_1 : entity work.bcd_to_7_segment
		port map(
			bcd       => bcd_1_b,
			dot       => '0',
			seven_seg => HEX1
		);
end architecture RTL;
