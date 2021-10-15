-- Name: testbench.vhd
-- Author: Noah Gardner
-- Date: 9/10/2019
-- 
-- Purpose: The purpose of this program
-- create a testbench for the implementation 
-- of the 'switch_count' component. The program
-- uses a process to trigger the inputs to count
-- to '111', or 7 in base 10.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- A testbench has no ports.
entity testbench is
end testbench;

architecture behav of testbench is
  -- component declaration
  component switch_count
    port (
      switch_0, switch_1, switch_2 : in std_logic;
      led_0, led_1, led_2 : out std_logic);
  end component;

  -- specifies which entity is bound with the component
  for switch_count_0: switch_count use entity work.switch_count;
  signal switch_0, switch_1, switch_2,
     led_0, led_1, led_2 : std_logic;

  begin
    -- component instantiation
    switch_count_0 : switch_count port map (
      switch_0 => switch_0,
      switch_1 => switch_1,
      switch_2 => switch_2,
      led_0 => led_0,
      led_1 => led_1,
      led_2 => led_2);

    -- main testbench process
    tb1 : process
      -- define clock period
      constant PERIOD : time := 20 ns;
      begin
        -- instantiate variables
        switch_0 <= '0';
        switch_1 <= '0';
        switch_2 <= '0';
        wait for PERIOD;

        -- for loop to trigger each input port
        -- switch_0 is the lsb and will flip every period
        -- switch_1 will flip every other period
        -- switch_2 will flip every four periods
        for i in 0 to 1 loop
          switch_0 <= not switch_0;
          wait for PERIOD;

          switch_0 <= not switch_0;
          switch_1 <= not switch_1;
          wait for PERIOD;

          switch_0 <= not switch_0;
          wait for PERIOD;

          switch_0 <= not switch_0;
          switch_1 <= not switch_1;
          switch_2 <= not switch_2;
          wait for PERIOD;
        end loop;

        assert false report "end of test" severity note;
        -- wait forever, this will finish the simulation
        wait;
  end process;
end behav;
