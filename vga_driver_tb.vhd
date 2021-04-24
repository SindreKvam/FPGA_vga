library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_driver_tb is
end entity vga_driver_tb;

architecture tb of vga_driver_tb is
    signal clk_tb       : std_logic                    := '0';
    signal screen       : std_logic_vector(7 downto 0) := "00000000"; 
    signal we           : std_logic                    := '0';
    signal read_address : integer range 0 to 95999; 
    signal h_sync_tb    : std_logic;    
    signal v_sync_tb    : std_logic;    
    signal r_tb         : std_logic_vector(3 downto 0); 
    signal g_tb         : std_logic_vector(3 downto 0);
    signal b_tb         : std_logic_vector(3 downto 0);
begin
    dut : entity work.vga_driver
        port map(
            clk          => clk_tb,
            screen       => screen,
            we           => we,
            read_address => read_address,
            h_sync       => h_sync_tb,
            v_sync       => v_sync_tb,
            r            => r_tb,
            g            => g_tb,
            b            => b_tb
        );
    process is
    begin
        wait for 1 ps;
        clk_tb <= not clk_tb;

    end process;
end architecture tb;
