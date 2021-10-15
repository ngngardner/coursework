-- Name: switch_count.vhd
-- Author: Noah Gardner
-- Date: 9/24/2019
-- 
-- Purpose: The purpose of this program is to implement
-- the assignment for Lab 2b. This component contains
-- three inputs to map to each switch. Switches are either
-- on or off, indicated by a '1' or a '0'. There are three 
-- outputs to map to each LED. LED's are active high, and 
-- indicate the number of switches that are high.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity declaration
entity switch_count is
    port(
        -- three input ports
        sw : in std_logic_vector(2 downto 0);

        -- three output ports
        led : out std_logic_vector(2 downto 0));
end switch_count;

-- data flow declaration
architecture data_flow of switch_count is
    -- led(2) is most significant bit
    -- leds are active low
    begin
        -- led(0) is low when at least one switch is high
        led(0) <= not(sw(0) or sw(1) or sw(2));

        -- led(1) is low when at least two switches are high
        led(1) <= not((sw(0) and sw(1)) 
                or (sw(1) and sw(2))
                or (sw(0) and sw(2)));
        
        -- led(2) is low when at least three switches are high
        led(2) <= not(sw(0) and sw(1) and sw(2));
    
end architecture data_flow;
