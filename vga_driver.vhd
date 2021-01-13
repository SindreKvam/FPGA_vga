library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_driver is
    port(
        clk    : in  std_logic;
        h_sync : out std_logic                    := '0';
        v_sync : out std_logic                    := '0';
        r      : out std_logic_vector(3 downto 0) := (others => '0');
        g      : out std_logic_vector(3 downto 0) := (others => '0');
        b      : out std_logic_vector(3 downto 0) := (others => '0')
    );
end entity vga_driver;

architecture RTL of vga_driver is
    -- http://tinyvga.com/vga-timing
    constant HD  : integer := 800;      -- Horizontal display (800)
    constant HFP : integer := 56;       -- Horizontal front porch (56)
    constant HSP : integer := 120;      -- Horizontal sync pulse (retrace) (120)
    constant HBP : integer := 64;       -- Horizontal back porch (64)

    constant VD  : integer := 600;      -- Vertical display (600)
    constant VFP : integer := 37;       -- Vertical front porch (37)
    constant VSP : integer := 6;        -- Vertical sync pulse (retrace) (6)
    constant VBP : integer := 23;       -- Vertical back porch (23)

    signal vPos : integer := 0;
    signal hPos : integer := 0;

    type sprite is array (0 to 7) of std_logic_vector(0 to 7); -- 8x8 sprite
    type screen is array (0 to 74, 0 to 99) of sprite; -- screen: 75 rows, 100 cols.
    signal output_scr : screen := (others => (others => (others => "10000001")));
    signal write      : std_logic;

begin
    process(clk) is
        variable h_array_pos : integer := 0;
        variable v_array_pos : integer := 0;
    begin
        if rising_edge(clk) then
            if hPos < HD + HFP + HSP + HBP then
                hPos <= hPos + 1;
                if hPos > HD + HFP and hPos < HD + HFP + HSP then
                    h_sync <= '0';
                else
                    h_sync <= '1';
                end if;
            else
                hPos        <= 0;
                h_array_pos := 0;
                if vPos < VD + VFP + VSP + VBP then
                    vPos <= vPos + 1;
                    if vPos > VD + VFP and vPos < VD + VFP + VSP then
                        v_sync <= '0';
                    else
                        v_sync <= '1';
                    end if;
                else
                    vPos        <= 0;
                    v_array_pos := 0;
                end if;
            end if;

            if hPos < HD and vPos < VD then -- if the counter is in the visible screen
                -- Display here:
                r <= "0000";
                g <= "0000";
                b <= "0000";

                if hPos mod 8 = 0 and hPos /= 0 then
                    h_array_pos := h_array_pos + 1;
                end if;
                if vPos mod 8 = 0 and vPos /= 0 then
                    v_array_pos := v_array_pos + 1;
                end if;

                write <= output_scr(v_array_pos, h_array_pos)(vPos mod 8)(hPos mod 8);
                if vPos mod 8 = 0 then
                    write <= '1';
                end if;

                -- UART sends data to RAM (position in RAM and write enable)
                -- output_scr reads from RAM (position to read in RAM)
                
                if write = '1' then
                    r <= "1111";
                    g <= "1111";
                    b <= "1111";
                end if;

            else                        -- if the counter is out of the visible screen
                r <= "0000";
                g <= "0000";
                b <= "0000";
            end if;
        end if;
    end process;

end architecture RTL;
