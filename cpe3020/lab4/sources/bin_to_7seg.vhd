-- Name: bcd_to_7seg.vhd
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
entity bcd_to_7seg is
  port( 
    -- four input bits
    din : in std_logic_vector (3 downto 0);

    -- seven seg output
    seg : out std_logic_vector (6 downto 0));

  -- constants
  constant ZERO_7SEG : std_logic_vector := "1000000";
  constant ONE_7SEG : std_logic_vector := "1111001";
  constant TWO_7SEG : std_logic_vector := "0100100";
  constant THREE_7SEG : std_logic_vector := "0110000";
  constant FOUR_7SEG : std_logic_vector := "0011001";
  constant FIVE_7SEG : std_logic_vector := "0010010";
  constant SIX_7SEG : std_logic_vector := "0000010";
  constant SEVEN_7SEG : std_logic_vector := "1111000";
  constant EIGHT_7SEG : std_logic_vector := "0000000";
  constant NINE_7SEG : std_logic_vector := "0011000";
  constant E_7SEG : std_logic_vector := "0000110";

end bcd_to_7seg;

-- behavior declaration
architecture behav of bcd_to_7seg is
	-- array of 4 values
	signal data : unsigned(3 downto 0);
	begin
		-- load our array with the values from the input
		data <= unsigned(din);

	process(din)
	begin
		case data is
			when "0000" => 
				seg <= ZERO_7SEG; ---0
			when "0001" => 
				seg <= ONE_7SEG; ---1
			when "0010" => 
				seg <= TWO_7SEG; ---2
			when "0011" => 
				seg <= THREE_7SEG; ---3
			when "0100" => 
				seg <= FOUR_7SEG; ---4
			when "0101" => 
				seg <= FIVE_7SEG; ---5
			when "0110" => 
				seg <= SIX_7SEG; ---6
			when "0111" => 
				seg <= SEVEN_7SEG; ---7
			when "1000" => 
				seg <= EIGHT_7SEG; ---8
			when "1001" => 
				seg <= NINE_7SEG; ---9
			when others =>
				seg <= E_7SEG; ---E for error
		end case;
	end process;
end behav;
