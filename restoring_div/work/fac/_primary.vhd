library verilog;
use verilog.vl_types.all;
entity fac is
    port(
        x               : in     vl_logic;
        y               : in     vl_logic;
        ci              : in     vl_logic;
        z               : out    vl_logic;
        co              : out    vl_logic
    );
end fac;
