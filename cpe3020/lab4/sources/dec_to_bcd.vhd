library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dec_to_bcd is
  port (
    -- input 7 bit vector
    din : in std_logic_vector (6 downto 0);

    -- output 4 bit bcd
    -- digit0 is lsb as a 4 bit binary number
    -- digit1 is msb as a 4 bit binary number
    digit0_out : out std_logic_vector (3 downto 0)
    digit1_out : out std_logic_vector (3 downto 0));
end entity dec_to_bcd;


architecture behav of dec_to_bcd is
  signal data : std_logic_vector(3 downto 0);
  signal d_0 : std_logic_vector(3 downto 0);
  signal d_1 : std_logic_vector(3 downto 0);
begin
  data <= std_logic_vector(din);
  
  process(din)
  begin
    
    
end architecture behav;