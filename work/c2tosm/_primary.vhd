library verilog;
use verilog.vl_types.all;
entity c2tosm is
    port(
        x               : in     vl_logic_vector(7 downto 0);
        y               : in     vl_logic_vector(7 downto 0);
        z               : in     vl_logic_vector(7 downto 0);
        sm              : out    vl_logic_vector(7 downto 0)
    );
end c2tosm;
