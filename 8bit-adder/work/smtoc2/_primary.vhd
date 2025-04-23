library verilog;
use verilog.vl_types.all;
entity smtoc2 is
    port(
        x               : in     vl_logic_vector(7 downto 0);
        y               : in     vl_logic_vector(7 downto 0);
        x_c2            : out    vl_logic_vector(7 downto 0);
        y_c2            : out    vl_logic_vector(7 downto 0)
    );
end smtoc2;
