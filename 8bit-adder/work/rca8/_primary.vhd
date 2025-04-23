library verilog;
use verilog.vl_types.all;
entity rca8 is
    port(
        x               : in     vl_logic_vector(7 downto 0);
        y               : in     vl_logic_vector(7 downto 0);
        c_in            : in     vl_logic;
        z               : out    vl_logic_vector(7 downto 0);
        c_out           : out    vl_logic;
        ovr             : out    vl_logic
    );
end rca8;
