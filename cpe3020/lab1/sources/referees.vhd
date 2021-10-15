-- Name: referees.vhd
-- Author: Noah Gardner
-- Date: 9/3/2019
-- 
-- Purpose: The purpose of this program is to implement
-- the assignment for Lab 1. This component contains
-- four inputs to map to each referee. Referees will
-- either support or reject each call. There is a head 
-- referee who settles all ties. A HIGH input means the
-- referee supports the call, and a LOW input means the 
-- referee rejects the call. A HIGH value on the output
-- represents the referees supporting the original call,
-- while a LOW value on the output represents the 
-- referees rejecting the original call.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity referees is
    port(
        ref_h : in std_logic;
        ref_a : in std_logic;
        ref_b : in std_logic;
        ref_c : in std_logic;
        o : out std_logic);

end referees;

architecture data_flow of referees is
    begin
        o <= (ref_h and ref_a) 
            or (ref_h and ref_b) 
            or (ref_h and ref_c)
            or (ref_a and ref_b and ref_c);
    
end architecture data_flow;
