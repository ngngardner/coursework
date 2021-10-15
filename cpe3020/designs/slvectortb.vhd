library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- tb has no ports
entity slvectortb is
end slvectortb;

architecture behav of slvectortb is

    signal slv1 : std_logic_vector(7 downto 0) := "00101010";
    signal slv2 : std_logic_vector(0 to 7) := "10101010";

begin

    process is
        variable myint : integer;
    begin
        slv1 <= slv1(7 downto 2) & "11";
        for i in slv1'range loop
            report std_logic'image(slv1(i));
            wait for 10 ns;
        end loop;

        assert false report "end of test" severity note;
        wait;
    end process;
end architecture;