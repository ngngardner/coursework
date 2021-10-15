
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ws2812b_controller is
  port (
    JA : out std_logic_vector(0 downto 0);
    clk : in std_logic;
    led : out std_logic_vector(1 downto 0);
    sw : in std_logic_vector(1 downto 0);
    btnC : in std_logic;
    btnU : in std_logic;
    btnL : in std_logic;
    btnR : in std_logic;
    btnD : in std_logic
  );
end ws2812b_controller;
architecture arch_imp of ws2812b_controller is
  constant NUM_LEDS : integer := 8;
  constant T0L : integer := 85;
  constant T0H : integer := 40;
  constant T1L : integer := 45;
  constant T1H : integer := 80;
  constant TRES : integer := 5000;
  constant DEBOUNCE : integer := 10000;
  constant CLOCK_FREQ : integer := 100;

  -- the counter counts on every 'clk' cycle, to be used
  -- with their respective clocks
  signal counter_10hz : unsigned (27 downto 0);
  -- clock enables for different frequencies
  signal clock_10hz : std_logic;

  signal ws2812_data_out : std_logic;
  signal reset : std_logic;
  signal cycle_up : std_logic;
  signal cycle_down : std_logic;
  signal move_left : std_logic;
  signal move_right : std_logic;
  signal edit : std_logic;
  type led_array_type is array(0 to (NUM_LEDS - 1)) of std_logic_vector(23 downto 0);
  signal led_array : led_array_type;
  type led_write_states is (init, write_zero, write_one, next_led, last_led);
  signal write_state : led_write_states;
  type led_control_states is (init, editing);
  signal control_state : led_control_states;
  signal bit_count : integer range 0 to 23;
  signal led_count : integer range 0 to NUM_LEDS - 1;
  signal reset_delay_count : unsigned(9 downto 0) := (others => '0');
  signal write_delay_count : unsigned(9 downto 0) := (others => '0');
  signal control_delay_count : unsigned(9 downto 0) := (others => '0');
  signal current_led : integer range 0 to NUM_LEDS - 1 := 0;
  -- data format is x"GGRRBB"
  constant NUM_COLORS : integer := 8;
  constant COLOR_RED : std_logic_vector(23 downto 0) := x"001500";
  constant COLOR_BLUE : std_logic_vector(23 downto 0) := x"000015";
  constant COLOR_GREEN : std_logic_vector(23 downto 0) := x"150000";
  constant COLOR_MAGENTA : std_logic_vector(23 downto 0) := x"001515";
  constant COLOR_YELLOW : std_logic_vector(23 downto 0) := x"151500";
  constant COLOR_ORANGE : std_logic_vector(23 downto 0) := x"071500";
  constant COLOR_CYAN : std_logic_vector(23 downto 0) := x"150015";
  constant COLOR_PINK : std_logic_vector(23 downto 0) := x"071507";
  type colors is array(0 to NUM_LEDS-1) of std_logic_vector(23 downto 0);
  signal colors_array : colors := (
    COLOR_RED, COLOR_BLUE, COLOR_GREEN, COLOR_MAGENTA, COLOR_YELLOW, COLOR_ORANGE, COLOR_CYAN, COLOR_PINK
  );
  signal current_color : integer range 0 to NUM_COLORS-1;
  type led_colors is array(0 to NUM_LEDS) of integer;
  signal current_colors : led_colors := (others => 0);
begin
  reset <= sw(1);
  edit <= sw(0);
  led(1) <= reset;
  led(0) <= edit;
  cycle_up <= btnU;
  cycle_down <= btnD;
  move_right <= btnL;
  move_left <= btnR;
  JA(0) <= ws2812_data_out;
  
        
  WRITE : process (clk)
    -- the purpose of this process is to write the ws2812_data_out signal
    -- based on the values in led_array
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_delay_count <= (others => '0');
        bit_count <= 23;
        led_count <= 0;
        write_state <= init;
      end if;
      
      case write_state is
        when init =>
          -- we are about to begin writing a 24 bit signal to a WS2812B led
          -- begin with the first bit of the signal, so if the first bit is '1'
          -- start by moving to write_one. otherwise, the first bit is '0',
          -- so move to 
          if (led_array(led_count)(bit_count) = '1') then
            write_state <= write_one;
          else
            write_state <= write_zero;
          end if;
        when write_zero =>
          -- we are writing a zero signal to the data bus
          if (write_delay_count < T0H) then
            -- for the duration of T0H, keep the signal high
            write_delay_count <= write_delay_count + 1;
            ws2812_data_out <= '1';
            write_state <= write_state;
          elsif (write_delay_count < (T0L + T0H)) then
            -- for the duration of T0L (after T0H), keep the signal low
            write_delay_count <= write_delay_count + 1;
            ws2812_data_out <= '0';
            write_state <= write_state;
          else
            -- we have finished writing a 0 bit
            write_delay_count <= (others => '0');
            ws2812_data_out <= '0';
            if bit_count > 0 then
              -- bit count is not zero, so move to the next bit
              bit_count <= bit_count - 1;
              write_state <= init;
            else
              -- we have written the last bit, so move to next led
              bit_count <= 23;
              write_state <= next_led;
            end if;
          end if;
      when write_one =>
        -- we are writing a one signal to the data bus
        if (write_delay_count < T1H) then
          -- for the duration of T1H, keep the signal high
          write_delay_count <= write_delay_count + 1;
          ws2812_data_out <= '1';
          write_state <= write_state;
        elsif (write_delay_count < (T1L + T1H)) then
          -- for the duration of T1L (after T1H), keep the signal low
          write_delay_count <= write_delay_count + 1;
          ws2812_data_out <= '0';
          write_state <= write_state;
        else
          -- we have finished writing a 1 bit
          write_delay_count <= (others => '0');
          ws2812_data_out <= '0';
          if bit_count > 0 then
            -- bit count is not 0, so move to the next bit
            bit_count <= bit_count - 1;
            write_state <= init;
          else
            -- we have written the last bit, so move to next led
            bit_count <= 23;
            write_state <= next_led;
          end if;
        end if;
      when next_led =>
        if (write_delay_count < 128) then
            write_delay_count <= write_delay_count + 1;
        else
          write_delay_count <= (others => '0');
          if (led_count < (NUM_LEDS - 1)) then
            -- led count is less than the total number of leds, so move to next led
            led_count <= led_count + 1;
            write_state <= init; 
          else
            -- led count is equal to the number of leds, so we have written a signal 
            -- for each led. move back to led 0

            -- ensure reset signal is sent before moving back to led 0
            if reset_delay_count < 40 then
              reset_delay_count <= reset_delay_count + 1;
              write_state <= write_state;
            else
              reset_delay_count <= (others => '0'); 
              led_count <= 0;
              write_state <= init;
            end if;
          end if;
        end if;
      when others =>
        write_state <= init;
      end case;
    end if;
  end process;

  CONTROL : process (clock_10hz, reset)
    variable temp_led_data : std_logic_vector(23 downto 0);
  begin
    if reset = '1' then
      control_state <= init;
      current_led <= 0;
      control_delay_count <= (others => '0');
      --current_color <= 0;
      current_colors <= (others => 0);
      for i in 0 to NUM_LEDS-1 loop
        led_array(i) <= colors_array(current_colors(i));
     end loop;
    elsif(rising_edge(clock_10hz)) then
      case control_state is
        -- not in editing mode. wait for user to press edit button
        when init =>
          -- no update
          current_color <= current_color;
          
          -- state transition
          if edit = '1' then
            control_state <= editing;
          else
            control_state <= control_state;
          end if;

        -- user is in edit mode
        when editing =>
          -- button debounce
          if move_left = '1' and current_led < NUM_LEDS-1 then
            current_led <= current_led + 1;
          elsif move_right = '1' and current_led > 0 then
            current_led <= current_led - 1;
          elsif cycle_up = '1' and current_colors(current_led) < NUM_COLORS-1 then
            current_colors(current_led) <= current_colors(current_led) + 1;
          elsif cycle_down = '1' and current_colors(current_led) > 0 then
            current_colors(current_led) <= current_colors(current_led) - 1;
          else
            current_colors(current_led) <= current_colors(current_led);
          end if;

          -- state transition
          if edit = '0' then
            control_state <= init;
          else
            control_state <= control_state;
          end if;
      end case;
    end if;
    for i in 0 to NUM_LEDS-1 loop
      led_array(i) <= colors_array(current_colors(i));
    end loop;
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
        counter_10hz <= counter_10hz + 1;
      end if;
    end if;
  end process;
end architecture arch_imp;