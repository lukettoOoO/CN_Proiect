library verilog;
use verilog.vl_types.all;
entity restoring_div is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        inbus1          : in     vl_logic_vector(7 downto 0);
        inbus2          : in     vl_logic_vector(7 downto 0);
        cat             : out    vl_logic_vector(7 downto 0);
        rest            : out    vl_logic_vector(7 downto 0);
        done            : out    vl_logic
    );
end restoring_div;
