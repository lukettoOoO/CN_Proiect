library verilog;
use verilog.vl_types.all;
entity define_sign is
    port(
        inbus1          : in     vl_logic_vector(7 downto 0);
        inbus2          : in     vl_logic_vector(7 downto 0);
        sign1           : out    vl_logic;
        sign2           : out    vl_logic;
        abs1            : out    vl_logic_vector(7 downto 0);
        abs2            : out    vl_logic_vector(7 downto 0)
    );
end define_sign;
