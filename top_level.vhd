library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        MAX10_CLK1_50 : in  std_logic;
        VGA_VS        : out std_logic;
        VGA_HS        : out std_logic;
        VGA_R         : out std_logic_vector(3 downto 0);
        VGA_G         : out std_logic_vector(3 downto 0);
        VGA_B         : out std_logic_vector(3 downto 0);
        KEY           : in  std_logic_vector(1 downto 0);
        SW            : in  std_logic_vector(7 downto 0)
    );
end entity top_level;

architecture RTL of top_level is
    signal clk_50 : std_logic;

    signal valid          : std_logic;
    signal stop_bit_error : std_logic;
    signal tx_rx          : std_logic;
    signal tx_busy        : std_logic;

    signal data    : std_logic_vector(7 downto 0);
    signal ascii   : std_logic_vector(7 downto 0);
    signal ram_out : std_logic_vector(7 downto 0);

    signal read_address  : integer range 0 to 59999;
    signal write_address : integer range 0 to 59999;
    signal write_enable  : std_logic;

begin
    system_clock : entity work.clock
        port map(
            areset => '0',
            inclk0 => MAX10_CLK1_50,
            c0     => clk_50,
            locked => open
        );
    uart_tx : entity work.uart_tx
        port map(
            clk   => clk_50,
            rst_n => KEY(0),
            start => KEY(1),
            data  => SW,
            busy  => tx_busy,
            tx    => tx_rx
        );
    uart_rx_module : entity work.uart_rx
        port map(
            clk            => clk_50,
            rst_n          => KEY(0),
            rx             => tx_rx,
            data           => data,
            valid          => valid,
            stop_bit_error => stop_bit_error
        );
    ascii_to_ram : entity work.logic_vector_to_ascii
        port map(
            clk           => clk_50,
            rst_n         => KEY(0),
            we            => write_enable,
            data          => data,
            ascii         => ascii,
            write_address => write_address
        );
    block_ram : entity work.single_clock_rw_ram
        port map(
            clk           => clk_50,
            data          => ascii,
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
