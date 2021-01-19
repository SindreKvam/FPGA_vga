library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logic_vector_to_ascii is
    port(
        rst_n         : in  std_logic;
        we            : in  std_logic;
        valid_uart    : in  std_logic;
        data          : in  std_logic_vector(7 downto 0);
        ascii         : out std_logic_vector(7 downto 0);
        write_address : out integer range 0 to 59999
    );
end entity logic_vector_to_ascii;

architecture RTL of logic_vector_to_ascii is
    signal valid_uart_p1 : std_logic;
begin

    vector_to_ascii_converter : process(we) is
        variable data_as_integer : integer;
        variable counter         : integer              := 0;
        variable line            : integer range 0 to 7 := 0;
    begin
        if rising_edge(we) then
            if rst_n = '0' then
                ascii         <= (others => '0');
                write_address <= 0;
                counter       := 0;
                line          := 0;
            else

                valid_uart_p1 <= valid_uart;
                -- for every time the uart recieves a new letter, add 1 to the write address
                if valid_uart = '1' and valid_uart_p1 = '0' then
                    line    := 0;
                    -- when you have drawn to the edge of the screen, add 700 to skip to a new line (8 lines assigned for each letter)
                    if counter mod 100 = 0 and counter /= 0 then
                        counter := counter + 700;
                    end if;
                    counter := counter + 1;
                end if;

                if line > 7 then
                    line := 0;
                else
                    write_address <= counter + (line * 100);
                end if;

                data_as_integer := to_integer(unsigned(data));
                case line is
                    when 0 =>
                        case data_as_integer is
                            when 65 =>
                                ascii <= "00011000";
                            when others =>
                                ascii <= "00000000";
                        end case;
                    when 1 =>
                        case data_as_integer is
                            when 65 =>
                                ascii <= "00100100";
                            when others =>
                                ascii <= "00000000";
                        end case;
                    when 2 =>
                        case data_as_integer is
                            when 65 =>
                                ascii <= "01000010";
                            when others =>
                                ascii <= "00000000";
                        end case;
                    when 3 =>
                        case data_as_integer is
                            when 65 =>
                                ascii <= "01000010";
                            when others =>
                                ascii <= "00000000";
                        end case;
                    when 4 =>
                        case data_as_integer is
                            when 65 =>
                                ascii <= "01000010";
                            when others =>
                                ascii <= "00000000";
                        end case;
                    when 5 =>
                        case data_as_integer is
                            when 65 =>
                                ascii <= "01111110";
                            when others =>
                                ascii <= "00000000";
                        end case;
                    when 6 =>
                        case data_as_integer is
                            when 65 =>
                                ascii <= "01000010";
                            when others =>
                                ascii <= "00000000";
                        end case;
                    when 7 =>
                        case data_as_integer is
                            when 65 =>
                                ascii <= "01000010";
                            when others =>
                                ascii <= "00000000";
                        end case;
                end case;

                line := line + 1;

            end if;
        end if;
    end process vector_to_ascii_converter;

end architecture RTL;
