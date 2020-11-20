library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdram is
	port(
		DRAM_DQ    : inout std_logic_vector(15 downto 0); -- Data
		DRAM_ADDR  : out   std_logic_vector(12 downto 0); -- Address
		DRAM_BA    : out   std_logic_vector(1 downto 0); -- Bank address
		DRAM_CLK   : out   std_logic; -- clock 
		DRAM_CKE   : out   std_logic; -- clock enable
		DRAM_LDQM  : out   std_logic; -- byte data mask [0]
		DRAM_UDQM  : out   std_logic; -- byte data mask [1]
		DRAM_WE_N  : out   std_logic; -- Write enable
		DRAM_CAS_N : out   std_logic; -- Column address strobe
		DRAM_RAS_N : out   std_logic; -- Row address strobe
		DRAM_CS_N  : out   std_logic -- chip select
	);
end entity sdram;

architecture RTL of sdram is

begin

end architecture RTL;
