library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.sm16_types.all;

-- instr_memory Entity Description
-- Adapted from Dr. Michael Crocker's Spring 2013 CSCE 385 Lab 6 at Pacific Lutheran University
entity instr_memory is
    port( DIN : in sm16_data;
          ADDR : in sm16_address;
          DOUT : out sm16_data;
          WE : in std_logic);
end instr_memory;

-- instr_memory Architecture Description
architecture behavioral of instr_memory is    subtype ramword is bit_vector(15 downto 0);
    type rammemory is array (0 to 1023) of ramword;
    ----------------------------------------------
    ----------------------------------------------
    ----  This is where you put your program -----
    ----------------------------------------------
    ----------------------------------------------
    -- add   0000           addi 0100
    -- sub   0001           seti 0101
    -- load  0010           Jump 0110
    -- store 0011          
    signal ram : rammemory := ("0101000000001000",  -- 0:  seti A 8
                               "0101010000000010",  -- 1:  seti B 2 
                               "0110000000000101",  -- 2:  Jump to Instruction 5
                               "0101010000000011",  -- 3:  seti B 3
                               "0101000000000000",  -- 4:  seti A 0 
                               "0011000000000000",  -- 5:  store A in 0
                               "0100010000000111",  -- 6:  addi B 7  
                               "0110000000001001",  -- 7:  Jump to Instruction 9
                               "0101010000000001",  -- 8:  seti B 1
                               "0011010000000001",  -- 9:  store B in 1
                              -- "0100000000000000",  -- 10:  addi A 0 should do nothing
                               others => "0100000000000000");

begin

    DOUT <= to_stdlogicvector(ram(to_integer(unsigned(ADDR))));
    
    ram(to_integer(unsigned(ADDR))) <= to_bitvector(DIN) when WE = '1';

end behavioral;
