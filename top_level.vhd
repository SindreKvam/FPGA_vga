library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        MAX10_CLK1_50 : in  std_logic;
        ARDUINO_IO0   : in  std_logic;
        VGA_VS        : out std_logic;
        VGA_HS        : out std_logic;
        VGA_R         : out std_logic_vector(3 downto 0);
        VGA_G         : out std_logic_vector(3 downto 0);
        VGA_B         : out std_logic_vector(3 downto 0);
        KEY           : in  std_logic_vector(1 downto 0)
    );
end entity top_level;

architecture RTL of top_level is
    signal clk_50 : std_logic;

    signal valid          : std_logic;
    signal stop_bit_error : std_logic;

    signal recieved_data_uart   : std_logic_vector(7 downto 0);
    signal ascii_character      : std_logic_vector(39 downto 0);
    signal ram_out              : std_logic_vector(7 downto 0);

    signal read_address  : normal range 0 to 95999;
    signal write_address : normal range 0 to 95999;
    signal write_enable  : std_logic;

begin
    system_clock : entity work.clock
        port map(
            areset => '0',
            inclk0 => MAX10_CLK1_50,
            c0     => clk_50,
            locked => open
        );
    uart_rx_module : entity work.uart_rx
        port map(
            clk            => clk_50,
            rst_n          => KEY(0),
            rx             => ARDUINO_IO0,
            data           => recieved_data_uart,
            valid          => valid,
            stop_bit_error => stop_bit_error
        );

    ascii_table : entity work.ROM_ascii_table
        port map(
            address	=> recieved_data_uart,  -- Data recieved via UART (ascii character value)
		    clock   => clk_50,              -- clock pulse (50MHz)
		    q		=> ascii_character      -- 40 bit ascii character
        );

    -- Insert ascii to BRAM here

    block_ram : entity work.single_clock_rw_ram
        port map(
            clk           => clk_50,
            data          => --ascii,
            write_address => write_address,
            read_address  => read_address,
            we            => write_enable,
            q             => ram_out
        );
    internal_vga_driver : entity work.vga_driver
        port map(
            clk          => clk_50,
            screen       => ram_out,
            we           => write_enable,
            read_address => read_address,
            h_sync       => VGA_HS,
            v_sync       => VGA_VS,
            r            => VGA_R,
            g            => VGA_G,
            b            => VGA_B
        );
end architecture RTL;
