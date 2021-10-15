
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gameshow is
    port(
        contestant1, contestant2, contestant3 : in character;
        correct_answer : in character;
        number_correct : out integer
    );
end gameshow;

architecture data_flow of gameshow is

begin
    process(contestant1, contestant2, contestant3) is
        variable count : integer := 0;
        constant inputs := (contestant1, contestant2, contestant3);
    begin
        for i in inputs'range loop
            if inputs(i) = correct_answer then
                tally := tally + 1;
            endif;
        end loop;
    end process;
end dataflow;
