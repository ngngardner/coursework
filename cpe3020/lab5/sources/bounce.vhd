-- Name: bounce.vhd
-- Author: Noah Gardner
-- Date: 11/5/2019
-- 
-- Purpose: The purpose of this code is to implement Lab 5,
-- where a bouncing ball is simulated on the leds of the Basys 3.
-- The ball is served with the center button, and is reset with
-- the down button. Switches can be activated and the 'ball' will
-- 'bounce' off of their positions

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
entity bounce is
  port (
    clk : in std_logic;-- 100Mhz clock on Basys 3 FPGA board
    sw : in std_logic_vector (15 downto 0); -- switches
    led : out std_logic_vector (15 downto 0); -- led for ball_pos
    an : out std_logic_vector (3 downto 0);-- 4 anode signals
    seg : out std_logic_vector (6 downto 0);-- cathode patterns of 7-segment display
    btnC : in std_logic; -- center button - serve
    btnD : in std_logic -- down button - reset
  );
end bounce;
-------------------------------------------------------------
-------------------------------------------------------------
architecture arch of bounce is
  type states is (init, move_right, move_left);
  signal bounce_state : states;
  signal reset : std_logic;
  signal serve : std_logic;
  signal cur_pos : integer range 0 to 15;
  signal bounce_count : std_logic_vector(7 downto 0);
  -- the counter counts on every 'clk' cycle, to be used
  -- with their respective clocks
  signal counter_10hz : std_logic_vector (27 downto 0);
  -- clock enables for different frequencies
  signal clock_10hz : std_logic;
  -- number to be displayed on the 4 7 seg displays
  signal displayed_number : std_logic_vector (15 downto 0);
  -- signal used to convert the 4 bit number to a seg display
  signal binary_dec_display : std_logic_vector (3 downto 0);
  -- these signals are for displaying different numbers
  -- simultaneously on the 4 7 seg displays
  signal refresh_counter : std_logic_vector (19 downto 0);
  signal LED_activating_counter : std_logic_vector(1 downto 0);
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
  reset <= btnD;
  serve <= btnC;

  -------------------------------------------------------------
  -------------------------------------------------------------
  TRANSITION : process (reset, clock_10hz)
    -- the purpose of this process is to move between the states and to update the
    -- position of the ball
    variable temp : integer; -- variable to hold the current position of the ball
  begin
    temp := cur_pos;
    if reset = '1' then
      bounce_state <= init;
      bounce_count <= (others => '0');
      temp := 0;
      led(15 downto 0) <= (others => '0');
    elsif rising_edge(clock_10hz) then
      if bounce_state = init then
        -- wait for serve signal
        if serve = '1' then
          led(15 downto 0) <= (others => '0');
          led(temp) <= '1';
          bounce_state <= move_left;
        else
          bounce_state <= bounce_state;
        end if;
      elsif bounce_state = move_left then
        -- increment and update to simulate moving left
        if temp < 15 then
          temp := temp + 1;
          led(15 downto 0) <= (others => '0');
          led(temp) <= '1';
        end if;
        -- if we are at an active switch or the left edge,
        -- bounce to move_right
        if (sw(temp) = '1') or (temp = 15) then
          bounce_state <= move_right;
          -- update count
          if bounce_count < "01100011" then
            bounce_count <= bounce_count + '1';
          end if;
        else
          bounce_state <= bounce_state;
        end if;
      elsif bounce_state = move_right then
        -- deccrement and update to simulate moving right
        if temp > 0 then
          temp := temp - 1;
          led(15 downto 0) <= (others => '0');
          led(temp) <= '1';
        end if;
        -- if we are at an active switch or the right edge,
        -- bounce to move_left
        if (sw(temp) = '1') or (temp = 0) then
          bounce_state <= move_left;
          if bounce_count < "01100011" then
            bounce_count <= bounce_count + '1';
          end if;
        else
          bounce_state <= bounce_state;
        end if;
      end if;
    end if;
    cur_pos <= temp;
  end process;

  -------------------------------------------------------------
  -------------------------------------------------------------
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

  -------------------------------------------------------------
  -------------------------------------------------------------
  BIN_DEC_DISP : process (binary_dec_display)
    -- VHDL code for BCD to 7-segment decoder
    -- Cathode patterns of the 7-segment LED display
    -- change binary number to a decimal number for display
  begin
    case binary_dec_display is
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
      when others =>
        seg <= ZERO7SEG; ---0
    end case;
  end process;

  -------------------------------------------------------------
  -------------------------------------------------------------
  REFRESH : process (clk)
    -- 7-segment display controller
    -- generate refresh period of 10.5ms
  begin
    if (rising_edge(clk)) then
      refresh_counter <= refresh_counter + 1;
    end if;
  end process;

  -------------------------------------------------------------
  -------------------------------------------------------------
  LED_activating_counter <= refresh_counter(19 downto 18);
  ANODE_SELECT : process (LED_activating_counter)
    -- 4-to-1 MUX to generate anode activating signals for 4 LEDs
  begin
    case LED_activating_counter is
      when "11" =>
        an <= "0111";
        -- activate LED1 and Deactivate LED2, LED3, LED4
        binary_dec_display <= "0000";
        -- the first hex digit of the 16-bit number
      when "10" =>
        an <= "1011";
        -- activate LED2 and Deactivate LED1, LED3, LED4
        binary_dec_display <= "0000";
        -- the second hex digit of the 16-bit number
      when "01" =>
        an <= "1101";
        -- activate LED3 and Deactivate LED2, LED1, LED4
        binary_dec_display <= "0000";
        binary_dec_display <= displayed_number(15 downto 12);
        -- the third hex digit of the 16-bit number
      when "00" =>
        an <= "1110";
        -- activate LED4 and Deactivate LED2, LED3, LED1
        binary_dec_display <= "0000";
        binary_dec_display <= displayed_number(11 downto 8);
        -- the fourth hex digit of the 16-bit number
    end case;
  end process;

  -------------------------------------------------------------
  -------------------------------------------------------------
  LOAD_COUNT : process (clk)
    variable temp : std_logic_vector(7 downto 0);
    variable d_0 : std_logic_vector(3 downto 0);
    variable d_1 : std_logic_vector(3 downto 0);
    variable tempCounter : std_logic_vector(15 downto 0) := (others => '0');
    variable divident_int : integer;
    variable modulo_0_int : integer;
    variable modulo_1_int : integer;
  begin
    temp := bounce_count;
    divident_int := to_integer(unsigned(temp));
    modulo_0_int := divident_int mod 10;
    divident_int := divident_int - modulo_0_int;
    modulo_1_int := divident_int/10;
    d_0 := std_logic_vector(to_unsigned(modulo_0_int, d_0'length));
    d_1 := std_logic_vector(to_unsigned(modulo_1_int, d_1'length));
    displayed_number(15 downto 12) <= d_1;
    displayed_number(11 downto 8) <= d_0;
  end process;
end architecture arch;