library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity and_gate is
    port(
        A : in std_logic;
        B : in std_logic;
        O : out std_logic);

end and_gate;

architecture data_flow of and_gate is
    begin
        O <= A and B;
    
end architecture data_flow;