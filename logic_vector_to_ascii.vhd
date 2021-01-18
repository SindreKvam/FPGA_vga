library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logic_vector_to_ascii is
    port(
        clk           : in  std_logic;
        rst_n         : in  std_logic;
        we            : in  std_logic;
        on_screen     : in  std_logic;
        data          : in  std_logic_vector(7 downto 0);
        ascii         : out std_logic_vector(7 downto 0);
        write_address : out integer range 0 to 59999
    );
end entity logic_vector_to_ascii;

architecture RTL of logic_vector_to_ascii is

begin

    vector_to_ascii_converter : process(clk) is
        variable data_as_integer : integer;
    begin
        if rising_edge(clk) and we = '1' and on_screen = '1' then
            if rst_n = '0' then
                ascii         <= "00000000";
                write_address <= 0;
            else
                data_as_integer := to_integer(unsigned(data));

                write_address <= write_address + 1;

                case data_as_integer is
                    when 65 =>
                        ascii <= "00011000";
                    when others =>
                        ascii <= "00000000";
                end case;

            end if;
        end if;
    end process vector_to_ascii_converter;

end architecture RTL;
