-- Name: referees_tb.vhd
-- Author: Noah Gardner
-- Date: 9/3/2019
-- 
-- Purpose: The purpose of this program is to
-- create a testbench for the implementation
-- of the 'referees' component.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity referees_tb is
  end referees_tb;

  architecture behav of referees_tb is
    -- component declaration
    component referees
      port (ref_h, ref_a, ref_b, ref_c : in std_logic; o : out std_logic);
    end component;

    -- specifies which entity is bound with the component
    for referees_0: referees use entity work.referees;
    signal ref_h, ref_a, ref_b, ref_c, o : std_logic;

  begin
    -- componenent instantiation
    referees_0 : referees port map (
      ref_h => ref_h,
      ref_a => ref_a,
      ref_b => ref_b,
      ref_c => ref_c,
      o => o);

    -- 'do work'
    process
      type pattern_type is record
      -- inputs
      ref_h, ref_a, ref_b, ref_c : std_logic;

      -- outputs
      o : std_logic;
      end record;
    -- the patterns to apply

    type pattern_array is array (natural range<>) of pattern_type;

    -- array that holds the expected inputs and outputs
    -- in this array the format is:
    -- ('ref_h', 'ref_a', 'ref_b', 'ref_c', 'o')
    constant PATTERNS : pattern_array :=
      (('0', '0', '0', '0', '0'),
      ('0', '0', '0', '1', '0'),
      ('0', '0', '1', '0', '0'),
      ('0', '0', '1', '1', '0'),
      ('0', '1', '0', '0', '0'),
      ('0', '1', '0', '1', '0'),
      ('0', '1', '1', '0', '0'),
      ('0', '1', '1', '1', '1'),
      ('1', '0', '0', '0', '0'),
      ('1', '0', '0', '1', '1'),
      ('1', '0', '1', '0', '1'),
      ('1', '0', '1', '1', '1'),
      ('1', '1', '0', '0', '1'),
      ('1', '1', '0', '1', '1'),
      ('1', '1', '1', '0', '1'),
      ('1', '1', '1', '1', '1'));
      
  begin
    -- check each pattern
    for i in PATTERNS'range loop
      -- set the inputs
      ref_h <= PATTERNS(i).ref_h;
      ref_a <= PATTERNS(i).ref_a;
      ref_b <= PATTERNS(i).ref_b;
      ref_c <= PATTERNS(i).ref_c;
      
      -- wait for the results
      wait for 1 ns;

      -- check and see that the result matches
      -- the expected output in the array
      assert o = PATTERNS(i).o
        report "bad output value" severity error;
    end loop;
    assert false report "end of test" severity note;
    -- wait forever, this will finish the simulation
    wait;
  end process;
end behav;