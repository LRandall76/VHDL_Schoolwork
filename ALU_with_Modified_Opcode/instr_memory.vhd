library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.sm16_types.all;

-- instr_memory Entity Description
-- Adapted from Dr. Michael Crocker's Spring 2013 CSCE 385 Lab 4 at Pacific Lutheran University
entity instr_memory is
    port( DIN : in sm16_data;
          ADDR : in sm16_address;
          DOUT : out sm16_data;
          WE : in std_logic);
end instr_memory;

-- instr_memory Architecture Description
architecture behavioral of instr_memory is
    subtype ramword is bit_vector(15 downto 0);
    type rammemory is array (0 to 1023) of ramword;
    ----------------------------------------------
    ----------------------------------------------
    ----  This is where you put your program -----
    ----------------------------------------------
    ----------------------------------------------
    -- add   000000           addi 000100
    -- sub   000001           seti 000101
    -- load  000010           jump 000110
    -- store 000011           jz   000111
    -- lsl   111111
    
    
    
    
    
    
    signal ram : rammemory := ("0000000000000000",  -- 0: 
                               "1111110000000000",  -- 1:  
                               "1111110000000011",  -- 2:  
                               "0000110000000111",  -- 3:  
                               "0000000000000000",  -- 4:  
                               "0000000000000000",  -- 5:  
                               "0000000000000000",  -- 6:  
                               "0000000000000000",  -- 7:  
                               "0000000000000000",  -- 8:  
                               "0000000000000000",  -- 9: 
                               "0000000000000000",  -- 10: 
                               "0000000000000000",  -- 11:
                               "0000000000000000",  -- 12: 
                               "0000000000000000",  -- 13: 
                               "0000000000000000",  -- 14: 
                               "0000000000000000",  -- 15: 
                               "0000000000000000",  -- 16: 
                               "0000000000000000",  -- 17: 
                               "0000000000000000",  -- 18: 
                               "0000000000000000",  -- 19: 
                               "0000000000000000",  -- 20: 
                               others => "0000000000000000");

begin

    DOUT <= to_stdlogicvector(ram(to_integer(unsigned(ADDR))));
    
    ram(to_integer(unsigned(ADDR))) <= to_bitvector(DIN) when WE = '1';

end behavioral;
