library verilog;
use verilog.vl_types.all;
entity fac is
    port(
        x               : in     vl_logic;
        y               : in     vl_logic;
        c_in            : in     vl_logic;
        z               : out    vl_logic;
        c_out           : out    vl_logic
    );
end fac;
