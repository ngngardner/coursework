-- Name: seven_seg_timer.vhd
-- Author: Noah Gardner
-- Date: 10/22/2019
-- 
-- Purpose: The purpose of this program is to implement
-- lab 4b. This program implements a timer where the user
-- can start and stop the timer with the center button,
-- and reset the timer with the up button. The user can 
-- also input a custom number to count down from by using
-- the switches. When the countdown reaches 0, a victory
-- pattern is displayed on the two left segments. The current
-- count is displayed on the two right segments. Finally,
-- the right-most led displays whether the timer is paused
-- or not.

library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity seven_segment_display_VHDL is
	port (
		clk : in std_logic;-- 100Mhz clock on Basys 3 FPGA board
		sw : in std_logic_vector (9 downto 0); --switches 0,1,2,3,4,5
		led : out std_logic_vector (1 downto 0); -- led for start/stop
		an : out std_logic_vector (3 downto 0);-- 4 Anode signals
		seg : out std_logic_vector (6 downto 0);-- Cathode patterns of 7-segment display
		btnC : in std_logic; -- center button - start/stop
		btnU : in std_logic); -- up button - reset
end seven_segment_display_VHDL;

architecture Behavioral of seven_segment_display_VHDL is
	-- the current count of the timer
	signal count : std_logic_vector (7 downto 0);

	-- the base number to reset to
	-- loaded with the switches as an 8 bit binary number
	signal base : std_logic_vector (7 downto 0);
	-- switches to use for base
	signal base_sw : std_logic_vector (7 downto 0);

	-- up button which can reset the count to base
	signal reset : std_logic;

	-- center button 
	signal start_button : std_logic;

	-- if count = 0, this signal goes high
	signal celebrate : std_logic;

	-- the counter counts on every 'clk' cycle, to be used
	-- with their respective clocks
	signal counter_1hz : std_logic_vector (27 downto 0);
	signal counter_10hz : std_logic_vector (27 downto 0);

	-- clock enables for different frequencies
	signal clock_1hz : std_logic;
	signal clock_10hz : std_logic;

	-- number to be displayed on the 4 7 seg displays
	signal displayed_number : std_logic_vector (15 downto 0);

	-- signal used to convert the 4 bit number to a seg display
	signal LED_BCD : std_logic_vector (3 downto 0);

	-- these signals are for displaying different numbers 
	-- simultaneously on the 4 7 seg displays
	signal refresh_counter : std_logic_vector (19 downto 0);
	signal LED_activating_counter : std_logic_vector(1 downto 0);

	-- state machine
	-- start - counting down
	-- stop - paused
	type states is (START, STOP);
	signal start_stop : states;

	-- constants
	constant ACTIVE : std_logic := '1';
	constant ZERO7SEG : std_logic_vector(6 downto 0) := "1000000"; ---0
	constant ONE7SEG : std_logic_vector(6 downto 0) := "1111001"; ---1
	constant TWO7SEG : std_logic_vector(6 downto 0) := "0100100"; ---2
	constant THREE7SEG : std_logic_vector(6 downto 0) := "0110000"; ---3
	constant FOUR7SEG : std_logic_vector(6 downto 0) := "0011001"; ---4
	constant FIVE7SEG : std_logic_vector(6 downto 0) := "0010010"; ---5
	constant SIX7SEG : std_logic_vector(6 downto 0) := "0000010"; ---6
	constant SEVEN7SEG : std_logic_vector(6 downto 0) := "1111000"; ---7
	constant EIGHT7SEG : std_logic_vector(6 downto 0) := "0000000"; ---8
	constant NINE7SEG : std_logic_vector(6 downto 0) := "0011000"; ---9
	constant TEN7SEG : std_logic_vector(6 downto 0) := "1000000"; ---0
	constant ELEVEN7SEG : std_logic_vector(6 downto 0) := "1111001"; ---1
	constant TWELVE7SEG : std_logic_vector(6 downto 0) := "0100100"; ---2
	constant THIRTEEN7SEG : std_logic_vector(6 downto 0) := "0110000"; ---3
	constant FOURTEEN7SEG : std_logic_vector(6 downto 0) := "0011001"; ---4
	constant FIFTEEN7SEG : std_logic_vector(6 downto 0) := "0010010"; ---5
begin
	-- load base_sw with the switches
	base_sw <= sw(7 downto 0);

	-- load button values
	reset <= btnU;
	start_button <= btnC;

	
	process (LED_BCD)
		-- VHDL code for BCD to 7-segment decoder
		-- Cathode patterns of the 7-segment LED display 
	begin
		case LED_BCD is
			when "0000" => --------BCD--------
				seg <= ZERO7SEG; ---0
			when "0001" =>
				seg <= ONE7SEG; ---1
			when "0010" =>
				seg <= TWO7SEG; ---2
			when "0011" =>
				seg <= THREE7SEG; ---3
			when "0100" =>
				seg <= FOUR7SEG; ---4
			when "0101" =>
				seg <= FIVE7SEG; ---5
			when "0110" =>
				seg <= SIX7SEG; ---6
			when "0111" =>
				seg <= SEVEN7SEG; ---7
			when "1000" =>
				seg <= EIGHT7SEG; ---8
			when "1001" =>
				seg <= NINE7SEG; ---9
			when "1010" =>
				seg <= "0000010"; -- a
			when "1011" =>
				seg <= "1100000"; -- b
			when "1100" =>
				seg <= "0110001"; -- C
			when "1101" =>
				seg <= "1000010"; -- d
			when "1110" =>
				seg <= "0110000"; -- E
			when others =>
				seg <= "0111000"; -- F
		end case;
	end process;
	
	
	REFRESH : process (clk)
		-- 7-segment display controller
		-- generate refresh period of 10.5ms
	begin

		if (rising_edge(clk)) then
			refresh_counter <= refresh_counter + 1;
		end if;
	end process;

	LED_activating_counter <= refresh_counter(19 downto 18);
	
	ANODE_SELECT : process (LED_activating_counter)
		-- 4-to-1 MUX to generate anode activating signals for 4 LEDs 
	begin
		case LED_activating_counter is
			when "11" =>
				an <= "0111";
				-- activate LED1 and Deactivate LED2, LED3, LED4
				LED_BCD <= displayed_number(15 downto 12);
				-- the first hex digit of the 16-bit number
			when "10" =>
				an <= "1011";
				-- activate LED2 and Deactivate LED1, LED3, LED4
				LED_BCD <= displayed_number(11 downto 8);
				-- the second hex digit of the 16-bit number
			when "01" =>
				an <= "1101";
				-- activate LED3 and Deactivate LED2, LED1, LED4
				LED_BCD <= displayed_number(7 downto 4);
				-- the third hex digit of the 16-bit number
			when "00" =>
				an <= "1110";
				-- activate LED4 and Deactivate LED2, LED3, LED1
				LED_BCD <= displayed_number(3 downto 0);
				-- the fourth hex digit of the 16-bit number    
		end case;
	end process;

	ONE_HZ_CLOCK : process (clk)
		-- create a one hz clock with counter_1hz
	begin
		if (rising_edge(clk)) then
			if (counter_1hz >= x"2FAF07f") then
				counter_1hz <= (others => '0');
				if clock_1hz = '0' then
					clock_1hz <= '1';
				else
					clock_1hz <= '0';
				end if;
			else
				counter_1hz <= counter_1hz + "0000001";
			end if;
		end if;
	end process;

	TEN_HZ_CLOCK : process (clk)
		-- create a 10 hz clock with counter_10hz
	begin
		if rising_edge(clk) then
			if counter_10hz >= x"989680" then
				counter_10hz <= (others => '0');
				if clock_10hz = '0' then
					clock_10hz <= '1';
				else
					clock_10hz <= '0';
				end if;
			else
				counter_10hz <= counter_10hz + "0000001";
			end if;
		end if;
	end process;

	base <= base_sw;
	STARTSTOP : process (reset, clock_10hz)
		-- use the 10hz clock and the reset button to
		-- switch between states
		variable temp : std_logic_vector(7 downto 0);
	begin
		if reset = '1' then
			start_stop <= STOP;
			led(0) <= '0';
		elsif rising_edge(clock_10hz) then
			if start_button = ACTIVE then
				if start_stop = STOP then
					start_stop <= START;
					led(0) <= '1';
				elsif start_stop = START then
					start_stop <= STOP;
					led(0) <= '0';
				end if;
			end if;
		end if;
	end process;

	COUNTDOWN : process (reset, clock_1hz)
		-- main countdown process
		variable temp : std_logic_vector(7 downto 0);
	begin
		if reset = '1' then
			-- set to base
			temp := base;

			-- if base is > 99, set to 99
			if temp > "01100011" then
				temp := "01100011";
			-- if base is 0, set to 20
			elsif temp = "00000000" then
				temp := "00010100";
			end if;
			-- load count with base
			count <= temp;

		elsif rising_edge(clock_1hz) and reset = '0' then
			-- countdown
			if start_stop = START then
				if count > 0 then
					count <= count - '1';
				end if;
			end if;
		end if;
	end process;
    
	VICTORY : process (clock_1hz)
		-- generate a pattern on the two left 7 seg displays 
		-- when count = 0
		variable counter : Integer range 6 downto 0;
		variable display_output : std_logic_vector (3 downto 0);
	begin
		if rising_edge(clock_1hz) then
			if start_stop = START then
				if count < "00000001" then
					if counter < 6 then
						counter := counter + 1;
					else
						counter := 0;
					end if;
					case counter is
						when 0 => display_output := "0001";
						when 1 => display_output := "0010";
						when 2 => display_output := "0011";
						when 3 => display_output := "0100";
						when 4 => display_output := "0101";
						when 5 => display_output := "0110";
						when 6 => display_output := "0111";
						when others => display_output := "1111";
					end case;
				else
				    display_output := "0000";
				end if;
			end if;
		end if;
		displayed_number(11 downto 8) <= display_output;
		displayed_number(15 downto 12) <= display_output;
	end process;

	LOAD_COUNT : process (clk)
		-- the purpose of this process is to take the 8 bit number for the count
		-- and separate it into two four bit numbers, which represent the ones
		-- and the tens digit of the count number. Then, this digits are loaded
		-- into the lower 8 bits of displayed_number, the main entry point to the 
		-- seven seg displays.
		variable temp : std_logic_vector(7 downto 0);
		variable d_0 : std_logic_vector(3 downto 0);
		variable d_1 : std_logic_vector(3 downto 0);
		variable tempCounter : std_logic_vector(15 downto 0) := (others => '0');

		variable divident_int : Integer;
		variable modulo_0_int : Integer;
		variable modulo_1_int : Integer;

	begin
		temp := count;
		divident_int := to_integer(unsigned(temp));
		modulo_0_int := divident_int mod 10;
		divident_int := divident_int - modulo_0_int;
		modulo_1_int := divident_int/10;
		d_0 := std_logic_vector(to_unsigned(modulo_0_int, d_0'length));
		d_1 := std_logic_vector(to_unsigned(modulo_1_int, d_1'length));

		displayed_number(3 downto 0) <= d_0;
		displayed_number(7 downto 4) <= d_1;
	end process;

end Behavioral;