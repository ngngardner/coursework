library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- A testbench has no ports
entity and_tb is
    end and_tb;

    architecture behav of and_tb is
        --  Declaration of the component that will be instantiated.
        component and_gate
            port (A, B : in std_logic; O : out std_logic);
        end component;

        --  Specifies which entity is bound with the component
        for and_0: and_gate use entity work.and_gate;
        signal A, B, O : std_logic;
    
    begin
        --  Component instantiation.
        and_0 : and_gate port map (A => A, B => B, O => O);

        --  'do work'
        process
          type pattern_type is record
          -- the inputs of the and gate
          A, B : std_logic;

          --  the expected output of the and gate
          O : std_logic;
          end record;
        -- the patterns to apply
        type pattern_array is array (natural range<>) of pattern_type;
        constant patterns : pattern_array :=
          (('0', '0', '0'), 
          ('0', '1', '0'), 
          ('1', '0', '0'), 
          ('1', '1', '1'));
          
    begin
      -- check each pattern
      for i in patterns'range loop
        -- set the inputs
        A <= patterns(i).A;
        B <= patterns(i).B;
        --  wait for the results
        wait for 1 ns;
        assert O = patterns(i).O
          report "bad output value" severity error;
      end loop;
      assert false report "end of test" severity note;
      -- wait forever, this will finish the simulation.
      wait;
    end process;
  end behav;
  