library IEEE;
use IEEE.std_logic_1164.all;
use work.sm16_types.all;

-- mux2_addr Entity Description
-- Adapted from Dr. Michael Crocker's Spring 2013 CSCE 385 Lab 4 at Pacific Lutheran University
entity mux2_addr is
   port( IN0 : in sm16_address;
         IN1 : in sm16_address;
         SEL : in std_logic;
         DOUT : out sm16_address);
end mux2_addr;

-- mux2_addr Architecture Description
architecture behavioral of mux2_addr is
begin

    with SEL select
    DOUT <= IN0 when '0',
            IN1 when '1',
            (others => 'X') when others;

end behavioral;
