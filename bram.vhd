library ieee;
use ieee.std_logic_1164.all;

entity single_clock_rw_ram is
    port(
        clk           : in  std_logic;
        data          : in  std_logic_vector(7 downto 0);
        write_address : in  integer range 0 to 59999;
        read_address  : in  integer range 0 to 59999;
        we            : in  std_logic;
        q             : out std_logic_vector(7 downto 0)
    );
end single_clock_rw_ram;
architecture rtl of single_clock_rw_ram is
    type mem is array (0 to 59999) of std_logic_vector(7 downto 0);
    signal ram_block        : mem;
    signal read_address_reg : integer range 0 to 59999;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram_block(write_address - 1) <= data;
            end if;
            read_address_reg <= read_address;
        end if;
    end process;
    q <= ram_block(read_address_reg);
end rtl;
