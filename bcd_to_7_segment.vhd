
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_to_7_segment is
	port(
		bcd       : in  std_logic_vector(3 downto 0);
		dot       : in  std_logic := '0';
		seven_seg : out std_logic_vector(7 downto 0) := (others => '0')
	);
end entity;

architecture rtl of bcd_to_7_segment is
begin

	process(bcd, dot) is
	begin
		-- The not on every output is because the 7-segment display is using common anode

		seven_seg(0) <= not (bcd(3) or bcd(1) or (bcd(2) and bcd(0)) or (not bcd(2) and not bcd(0)));
		seven_seg(1) <= not (not bcd(2) or (not bcd(1) and not bcd(0)) or (bcd(1) and bcd(0)));
		seven_seg(2) <= not (bcd(2) or not bcd(1) or bcd(0));
		seven_seg(3) <= not ((bcd(1) and not bcd(2)) or (not bcd(2) and not bcd(0)) or (bcd(1) and not bcd(0)) or bcd(3) or (bcd(2) and not bcd(1) and bcd(0)));
		seven_seg(4) <= not ((not bcd(2) and not bcd(0)) or (bcd(1) and not bcd(0)));
		seven_seg(5) <= not (bcd(3) or (not bcd(1) and not bcd(0)) or (bcd(2) and not bcd(1)) or (bcd(2) and not bcd(0)));
		seven_seg(6) <= not (bcd(3) or (bcd(2) and not bcd(1)) or (not bcd(2) and bcd(1)) or (bcd(1) and not bcd(0)));
		seven_seg(7) <= not dot;

	end process;

end architecture;
