
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ascii_to_framebuffer is
  port (
    clk             : in  std_logic;
    ascii_character : in  std_logic_vector(39 downto 0);
    write_enable    : in  std_logic;
    write_address   : out std_logic_vector(7 downto 0);
    q               : out std_logic_vector(4 downto 0)
  );
end ascii_to_framebuffer;

architecture rtl of ascii_to_framebuffer is
  signal ascii_character_reg : std_logic_vector(39 downto 0);
begin

  ASCII_PLACEHOLDER_PROC : process(ascii_character)
  begin
    ascii_character_reg <= ascii_character;
  end process;

  ASCII_TO_FRAMEBUFFER_PROC : process(clk)
  begin
    if rising_edge(clk) then
      
    end if;
  end process;

end architecture;