-- Name: dec_hex_counter.vhd
-- Author: Noah Gardner
-- Date: 10/1/2019
-- 
-- Purpose: The purpose of this program is to implement
-- the assignment for Lab 3. This component contains the
-- entire implementation of the project. There are 5 switch
-- inputs, where the 5th switch is used as a mode select.
-- Switches 1-4 control the number displayed as a binary
-- number input. When the 5th switch is used, the number
-- displayed on the 7 seg output is hex, and the first led
-- is turned on to indicate that the device is in hex mode.
-- When that switch is off, the number displayed is in decimal.
-- When the msb of the decimal number is over 9, the second led
-- turn on to indicate that the number should be the number on the
-- seven seg + 10.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entity declaration
entity dec_hex_counter is
	port( 
		-- five input switches
		sw : in std_logic_vector (4 downto 0);

		-- seven seg output
		seg : out std_logic_vector (6 downto 0);

		-- two leds output
		-- led(0) is select
		-- led(1) is carry
		led : out std_logic_vector(1 downto 0);

		-- four anodes outputs for seven segs
		an : out std_logic_vector(3 downto 0));
end dec_hex_counter;

-- behavior declaration
architecture behav of dec_hex_counter is
	-- array of 5 values
	signal switches : unsigned(4 downto 0);
	begin
		-- load our array with the values from the switches
		switches <= unsigned(sw);
		-- set the first anode on and the rest off
		an(0) <= '0';
		an(1) <= '1';
		an(2) <= '1';
		an(3) <= '1';

	process(sw)
		begin
			case switches is
				-- select low, we are in decimal mode
				-- carry high when the number is >10
				when "00000" => 
				seg <= "1000000"; ---0
				led(0) <= '0';
				led(1) <= '0';
				when "00001" => 
				seg <= "1111001"; ---1
				led(0) <= '0';
				led(1) <= '0';
				when "00010" => 
				seg <= "0100100"; ---2
				led(0) <= '0';
				led(1) <= '0';
				when "00011" => 
				seg <= "0110000"; ---3
				led(0) <= '0';
				led(1) <= '0';
				when "00100" => 
				seg <= "0011001"; ---4
				led(0) <= '0';
				led(1) <= '0';
				when "00101" => 
				seg <= "0010010"; ---5
				led(0) <= '0';
				led(1) <= '0';
				when "00110" => 
				seg <= "0000010"; ---6
				led(0) <= '0';
				led(1) <= '0';
				when "00111" => 
				seg <= "1111000"; ---7
				led(0) <= '0';
				led(1) <= '0';
				when "01000" => 
				seg <= "0000000"; ---8
				led(0) <= '0';
				led(1) <= '0';
				when "01001" => 
				seg <= "0011000"; ---9
				led(0) <= '0';
				led(1) <= '0';
				when "01010" => 
				seg <= "1000000"; ---0+led
				led(0) <= '0';
				led(1) <= '1';
				when "01011" => 
				seg <= "1111001"; ---1+led
				led(0) <= '0';
				led(1) <= '1';
				when "01100" => 
				seg <= "0100100"; ---2+led
				led(0) <= '0';
				led(1) <= '1';
				when "01101" => 
				seg <= "0110000"; ---3+led
				led(0) <= '0';
				led(1) <= '1';
				when "01110" => 
				seg <= "0011001"; ---4+led
				led(0) <= '0';
				led(1) <= '1';
				when "01111" => 
				seg <= "0010010"; ---5+led
				led(0) <= '0';
				led(1) <= '1';

				-- HEX MODE
				-- select high, we are in hex mode
				-- carry low, theres no carry for hex mode
				when "10000" => 
				seg <= "1000000"; ---0
				led(0) <= '1';
				led(1) <= '0';
				when "10001" => 
				seg <= "1111001"; ---1
				led(0) <= '1';
				led(1) <= '0';
				when "10010" => 
				seg <= "0100100"; ---2
				led(0) <= '1';
				led(1) <= '0';
				when "10011" => 
				seg <= "0110000"; ---3
				led(0) <= '1';
				led(1) <= '0';
				when "10100" => 
				seg <= "0011001"; ---4
				led(1) <= '0';
				when "10101" => 
				seg <= "0010010"; ---5
				led(0) <= '1';
				led(1) <= '0';
				when "10110" => 
				seg <= "0000010"; ---6
				led(0) <= '1';
				led(1) <= '0';
				when "10111" => 
				seg <= "1111000"; ---7
				led(0) <= '1';
				led(1) <= '0';
				when "11000" => 
				seg <= "0000000"; ---8
				led(0) <= '1';
				led(1) <= '0';
				when "11001" => 
				seg <= "0011000"; ---9
				led(0) <= '1';
				led(1) <= '0';
				when "11010" => 
				seg <= "0001000"; ---A
				led(0) <= '1';
				led(1) <= '0';
				when "11011" => 
				seg <= "0000011"; ---b
				led(0) <= '1';
				led(1) <= '0';
				when "11100" => 
				seg <= "1000110"; ---C
				led(0) <= '1';
				led(1) <= '0';
				when "11101" => 
				seg <= "0100001"; ---d
				led(0) <= '1';
				led(1) <= '0';
				when "11110" => 
				seg <= "0000110"; ---E
				led(0) <= '1';
				led(1) <= '0';
				when "11111" => 
				seg <= "0001110"; ---F
				led(0) <= '1';
				led(1) <= '0';
				when others => 
				seg <= "1111111"; ---null
				led(0) <= '1';
				led(1) <= '0';
			end case;
	end process;
end behav;
