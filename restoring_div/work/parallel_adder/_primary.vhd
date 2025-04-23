library verilog;
use verilog.vl_types.all;
entity parallel_adder is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        cin             : in     vl_logic;
        cout            : out    vl_logic;
        Sum             : out    vl_logic_vector(7 downto 0)
    );
end parallel_adder;
