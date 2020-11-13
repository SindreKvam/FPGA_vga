library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_driver is
	port(
		clk_25 : in  std_logic;
		rst_n  : in  std_logic;
		h_sync : out std_logic                    := '0';
		v_sync : out std_logic                    := '0';
		r      : out std_logic_vector(3 downto 0) := (others => '0');
		g      : out std_logic_vector(3 downto 0) := (others => '0');
		b      : out std_logic_vector(3 downto 0) := (others => '0');
		r_p    : out std_logic_vector(3 downto 0) := (others => '0');
		g_p    : out std_logic_vector(3 downto 0) := (others => '0');
		b_p    : out std_logic_vector(3 downto 0) := (others => '0')
	);
end entity vga_driver;

architecture RTL of vga_driver is
	-- http://tinyvga.com/vga-timing/640x480@60Hz
	constant HBP : integer := 48;       -- Horizontal back porch (48)
	constant HD  : integer := 640;      -- Horizontal display (640)
	constant HFP : integer := 16;       -- Horizontal front porch (16)
	constant HSP : integer := 96;       -- Horizontal sync pulse (retrace) (96)

	constant VBP : integer := 33;       -- Vertical back porch (33)
	constant VD  : integer := 480;      -- Vertical display (480)
	constant VFP : integer := 10;       -- Vertical front porch (10)
	constant VSP : integer := 2;        -- Vertical sync pulse (retrace) (2)

	signal vPos : integer := 0;
	signal hPos : integer := 0;
begin

	process(clk_25) is
	begin
		if rising_edge(clk_25) then
			if rst_n = '0' then
				hPos <= 0;
				vPos <= 0;
			else
				if hPos < HBP + HD + HFP + HSP then
					hPos <= hPos + 1;
					if hPos < HBP + HD + HFP then
						h_sync <= '1';
					else
						h_sync <= '0';
					end if;
				else
					hPos <= 0;
					if vPos < VBP + VD + VFP + VSP then
						vPos <= vPos + 1;
						if vPos < VBP + VD + VFP then
							v_sync <= '1';
						else
							v_sync <= '0';
						end if;
					else
						vPos <= 0;
					end if;
				end if;

				if hPos > HBP and hPos < HBP + HD and vPos > VBP and vPos < VBP + VD then
					r   <= "1000";
					g   <= "0000";
					b   <= "1000";
					r_p <= r;
					g_p <= g;
					b_p <= b;
				else
					r <= "0000";
					g <= "0000";
					b <= "0000";
				end if;
			end if;
		end if;
	end process;
end architecture RTL;
