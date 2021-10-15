library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity seven_segment_display_VHDL is
	port (
		clk : in STD_LOGIC;-- 100Mhz clock on Basys 3 FPGA board
		sw : in STD_LOGIC_VECTOR (9 downto 0); --switches 0,1,2,3,4,5
		led : out std_logic_vector (1 downto 0);
		an : out STD_LOGIC_VECTOR (3 downto 0);-- 4 Anode signals
		seg : out STD_LOGIC_VECTOR (6 downto 0);-- Cathode patterns of 7-segment display
		btnC : in std_logic;
		btnU : in std_logic);
end seven_segment_display_VHDL;

architecture Behavioral of seven_segment_display_VHDL is
	signal SEVEN_SEG0 : STD_LOGIC_VECTOR (6 downto 0);
	signal SEVEN_SEG1 : STD_LOGIC_VECTOR (6 downto 0);
	signal count : STD_LOGIC_VECTOR (7 downto 0);
	signal base : std_logic_vector (7 downto 0);
	signal reset : std_logic;
	signal start_button : std_logic;

	signal enable_sw : std_logic_vector (1 downto 0);
	signal base_sw : std_logic_vector (7 downto 0);

	signal one_second_counter : STD_LOGIC_VECTOR (27 downto 0);
	signal counter_10hz : STD_LOGIC_VECTOR (27 downto 0);
	-- counter for generating 1-second clock enable
	signal one_second_clock : std_logic;
	signal clock_10hz : std_logic;
	-- one second enable for counting numbers
	signal displayed_number : STD_LOGIC_VECTOR (15 downto 0);
	-- counting decimal number to be displayed on 4-digit 7-segment display
	signal LED_BCD : STD_LOGIC_VECTOR (3 downto 0);
	signal refresh_counter : STD_LOGIC_VECTOR (19 downto 0);
	-- creating 10.5ms refresh period
	signal LED_activating_counter : std_logic_vector(1 downto 0);
	-- the other 2-bit for creating 4 LED-activating signals
	-- count         0    ->  1  ->  2  ->  3
	-- activates    LED1    LED2   LED3   LED4
	-- and repeat
	type states is (START, STOP);
	signal start_stop : states;

	constant ACTIVE : std_logic := '1';

	constant ZERO7SEG : STD_LOGIC_VECTOR(6 downto 0) := "1000000"; ---0
	constant ONE7SEG : STD_LOGIC_VECTOR(6 downto 0) := "1111001"; ---1
	constant TWO7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0100100"; ---2
	constant THREE7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0110000"; ---3
	constant FOUR7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0011001"; ---4
	constant FIVE7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0010010"; ---5
	constant SIX7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0000010"; ---6
	constant SEVEN7SEG : STD_LOGIC_VECTOR(6 downto 0) := "1111000"; ---7
	constant EIGHT7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0000000"; ---8
	constant NINE7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0011000"; ---9
	constant TEN7SEG : STD_LOGIC_VECTOR(6 downto 0) := "1000000"; ---0
	constant ELEVEN7SEG : STD_LOGIC_VECTOR(6 downto 0) := "1111001"; ---1
	constant TWELVE7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0100100"; ---2
	constant THIRTEEN7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0110000"; ---3
	constant FOURTEEN7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0011001"; ---4
	constant FIFTEEN7SEG : STD_LOGIC_VECTOR(6 downto 0) := "0010010"; ---5
begin
	base_sw <= sw(7 downto 0);
	enable_sw <= sw(9 downto 8);
	-- reset <= enable_sw(1);
	reset <= btnU;
	start_button <= btnC;
	-- VHDL code for BCD to 7-segment decoder
	-- Cathode patterns of the 7-segment LED display 
	process (LED_BCD)
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
	-- 7-segment display controller
	-- generate refresh period of 10.5ms
	process (clk)
	begin

		if (rising_edge(clk)) then
			refresh_counter <= refresh_counter + 1;
		end if;
	end process;

	LED_activating_counter <= refresh_counter(19 downto 18);
	-- 4-to-1 MUX to generate anode activating signals for 4 LEDs 
	process (LED_activating_counter)
	begin
		case LED_activating_counter is
			when "11" =>
				an <= "0111";
				-- activate LED1 and Deactivate LED2, LED3, LED4
				LED_BCD <= displayed_number(7 downto 4);
				-- the first hex digit of the 16-bit number
			when "10" =>
				an <= "1011";
				-- activate LED2 and Deactivate LED1, LED3, LED4
				LED_BCD <= displayed_number(7 downto 4);
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
	-- Counting the number to be displayed on 4-digit 7-segment Display 
	-- on Basys 3 FPGA board

	ONE_HZ_CLOCK : process (clk)
	begin
		if (rising_edge(clk)) then
			if (one_second_counter >= x"2FAF07f") then
				one_second_counter <= (others => '0');
				if one_second_clock = '0' then
					one_second_clock <= '1';
				else
					one_second_clock <= '0';
				end if;
			else
				one_second_counter <= one_second_counter + "0000001";
			end if;
		end if;
	end process;

	TEN_HZ_CLOCK : process (clk)
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

	COUNTDOWN : process (reset, one_second_clock)
		variable temp : std_logic_vector(7 downto 0);
	begin
		if reset = '1' then
			temp := base;
			if temp > "01100011" then
				temp := "01100011";
			elsif temp = "00000000" then
				temp := "00010100";
			end if;
			count <= temp;
		elsif rising_edge(one_second_clock) and reset = '0' then
			if start_stop = START then
				if count > 0 then
					count <= count - '1';
				end if;
			end if;
		end if;
	end process;

	VICTORY : process (one_second_clock)
		variable counter : Integer range 6 downto 0;
		variable display_output : std_logic_vector (3 downto 0);
	begin
		if rising_edge(one_second_clock) then
			if start_stop = START then
				if count <= 6 then
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
				end case;
			end if;
		else
			display_output := "0000";
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