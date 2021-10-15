library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity seg_timer is
  port (
    clk : in std_logic;
    an : out std_logic_vector(3 downto 0);
    seg : out std_logic_vector(6 downto 0));

end entity seg_timer;

architecture  of seg_timer is
  -- signals
  signal reset : std_logic;
  signal count : std_logic;

  -- seven seg displays, 0 is right-most display
  -- four bit binary number to display as decimal
  signal TO_7SEG0 : std_logic_vector (3 downto 0);
  signal TO_7SEG1 : std_logic_vector (3 downto 0);
  signal TO_7SEG2 : std_logic_vector (3 downto 0);
  signal TO_7SEG3 : std_logic_vector (3 downto 0);
  
  -- signals for the digits to display on the seven seg
  -- these get loaded in to seg
  signal digit_0 : std_logic_vector(6 downto 0);
  signal digit_1 : std_logic_vector(6 downto 0);
  signal digit_2 : std_logic_vector(6 downto 0);
  signal digit_3 : std_logic_vector(6 downto 0);

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

begin
  -- triggers on rising edge
  BIN_TO_7SEG0: process()
    variable data : std_logic_vector;
  begin
    data <= TO_7SEG0;
    case data is
      when "0000" => 
        digit_0 <= ZERO_7SEG; ---0
      when "0001" => 
        digit_0 <= ONE_7SEG; ---1
      when "0010" => 
        digit_0 <= TWO_7SEG; ---2
      when "0011" => 
        digit_0 <= THREE_7SEG; ---3
      when "0100" => 
        digit_0 <= FOUR_7SEG; ---4
      when "0101" => 
        digit_0 <= FIVE_7SEG; ---5
      when "0110" => 
        digit_0 <= SIX_7SEG; ---6
      when "0111" => 
        digit_0 <= SEVEN_7SEG; ---7
      when "1000" => 
        digit_0 <= EIGHT_7SEG; ---8
      when "1001" => 
        digit_0 <= NINE_7SEG; ---9
      when others =>
        digit_0 <= E_7SEG; ---E for error
    end case;
	end process;

  -- triggers on rising edge
  BIN_TO_7SEG1: process()
    variable data : std_logic_vector;
  begin
    data <= TO_7SEG1;
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

  -- triggers on rising edge
  BIN_TO_7SEG2: process()
    variable data : std_logic_vector;
  begin
    data <= TO_7SEG2;
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

  -- triggers on rising edge
  BIN_TO_7SEG3: process()
    variable data : std_logic_vector;
  begin
    data <= TO_7SEG3;
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
  
end architecture ;