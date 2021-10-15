library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity or_gate is
    port(
        A : in std_logic;
        B : in std_logic;
        O : out std_logic);

end or_gate;

architecture data_flow of or_gate is
    begin
        O <= A or B;
    
end architecture data_flow;