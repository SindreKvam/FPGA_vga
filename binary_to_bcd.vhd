
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity binary_to_bcd is
  port(
  binary : in std_logic_vector(3 downto 0);

  bcd_0 : out std_logic_vector(3 downto 0) := (others => '0'); -- One
  bcd_1 : out std_logic_vector(3 downto 0) := (others => '0') -- Ten
  );
end entity;


architecture rtl of binary_to_bcd is
begin

process(binary) is
  variable a : std_logic_vector(3 downto 0);
  variable b : std_logic_vector(3 downto 0);
  begin
    a := (others => '0');
    b := (others => '0');

    for i in 3 downto 0 loop

      if unsigned(a) > 4 then
        a := std_logic_vector(unsigned(a) + 3);

      end if;
      if unsigned(b) > 4 then
        b := std_logic_vector(unsigned(b) + 3);

      end if;

      b := b(2 downto 0) & '0'; --sll - shift logic left
      b(0) := a(3);

      a := a(2 downto 0) & '0';
      a(0) := binary(i);
    end loop;

    bcd_0 <= a;
    bcd_1 <= b;

  end process;
end architecture;
