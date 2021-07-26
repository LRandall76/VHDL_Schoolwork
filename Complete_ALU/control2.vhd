library ieee;
use ieee.std_logic_1164.all;
use work.sm16_types.all;

-- control Entity Description
-- Adapted from Dr. Michael Crocker's Spring 2013 CSCE 385 Lab 4 at Pacific Lutheran University
entity control2 is
   port( CLK   : in std_logic;
              RESET : in std_logic;
              START : in std_logic;
              
              WE     : out std_logic;            
              EN_PC  : out std_logic;
              
          OP2 : in std_logic_vector (3 downto 0);
       
          
          -- Enable Signals
          EN_ABCD : out std_logic;
          EN_INSTR : out std_logic;
          EN_IMM : out std_logic;
          EN_OP : out std_logic;
          EN_DATA : out std_logic;
          EN_RV : out std_logic;
          EN_B2R : out std_logic);
end control2;

-- control Architecture Description
architecture behavorial of control2 is
        
    -- op codes
    constant op_add   : sm16_opcode := "0000";
    constant op_sub   : sm16_opcode := "0001";  
    constant op_load  : sm16_opcode := "0010";
    constant op_store : sm16_opcode := "0011";
    constant op_addi  : sm16_opcode := "0100";
    constant op_seti  : sm16_opcode := "0101";
  --  constant op_jump  : sm16_opcode := "000110";
  --   constant op_jz    : sm16_opcode := "000111";
    
    -- definitions of the states the control can be in
    type states is (stopped, running);  -- single cycle now, so only one running state
    signal state, next_state : states := stopped;
    
    -- internal write enable, ungated by the clock
    signal pre_we : std_logic;
    
begin
    
    -- write enable is gated when the clock is low
    WE <= pre_we and (not CLK);
    
    -- process to state register
    state_reg: process( CLK, RESET )
    begin
        if( RESET = '1' ) then
            state <= stopped;
        elsif( rising_edge(CLK) ) then
            state <= next_state;
        end if;
    end process state_reg;
    
    -- ############################################ --
    
    -- process to define next state transitions and output signals
    next_state_and_output: process(state, START, OP2 )
    begin
        case state is
            -- Stopped is the stopped state; wait for start
            when stopped =>
                
                if( START /= '1' ) then
                    -- issue nop
                    -- Enable Signals
                    EN_INSTR <= '0';   EN_IMM <= '0'; EN_OP <= '0'; EN_DATA <= '0';
                    EN_RV <= '0';      EN_B2R <= '0'; EN_PC <='0'; EN_ABCD <= '0';
          
                 
                    
                    next_state <= stopped;
                else
                   -- Enable Signals
                    EN_INSTR <= '0';   EN_IMM <= '0'; EN_OP <= '0'; EN_DATA <= '0';
                    EN_RV <= '0';      EN_B2R <= '0';  EN_PC <='1'; EN_ABCD <= '0';
                    
              
                    
                    next_state <= running; -- go to fetch state
                end if;
                
            -- In running state, each instruciton has its own control signals
            when running =>
                
                if OP2 = op_add then
                    -- A <- A + Mem

                    EN_INSTR <= '1';   EN_IMM <= '1'; EN_OP <= '1'; EN_DATA <= '1';
                    EN_RV <= '1';      EN_B2R <= '1';  EN_PC <='1';  EN_ABCD <= '1';
                  
                    
                    next_state <= running;
                    
                elsif OP2 = op_sub then
                    -- A <- A - Mem
 -- Enable Signals
                    EN_INSTR <= '1';   EN_IMM <= '1'; EN_OP <= '1'; EN_DATA <= '1';
                    EN_RV <= '1';      EN_B2R <= '1';  EN_PC <='1'; EN_ABCD <= '1';
                    
                  
                    
                    next_state <= running;
                    
                elsif OP2 = op_seti then
                    -- A <- 0 + Immediate
 -- Enable Signals
                    EN_INSTR <= '1';   EN_IMM <= '1'; EN_OP <= '1'; EN_DATA <= '1';
                    EN_RV <= '1';      EN_B2R <= '1'; EN_PC <='1'; EN_ABCD <= '1';
                    
                    
                    next_state <= running;
                    
                elsif OP2= op_load then
                    -- PC <- 0 + Immediate
 -- Enable Signals
                    EN_INSTR <= '1';   EN_IMM <= '1'; EN_OP <= '1'; EN_DATA <= '1';
                    EN_RV <= '1';      EN_B2R <= '1';  EN_PC <='1'; EN_ABCD <= '1';
                    
                  
                    
                    next_state <= running;
                    
               elsif OP2 = op_store then
                    -- PC <- 0 + Immediate
 -- Enable Signals
                    EN_INSTR <= '1';   EN_IMM <= '1'; EN_OP <= '1'; EN_DATA <= '1';
                    EN_RV <= '1';      EN_B2R <= '1';  EN_PC <='1'; EN_ABCD <= '1';
                  
                    
                    next_state <= running; 
                      
               elsif OP2 = op_addi then
                    -- PC <- 0 + Immediate
 -- Enable Signals
                    EN_INSTR <= '1';   EN_IMM <= '1'; EN_OP <= '1'; EN_DATA <= '1';
                    EN_RV <= '1';      EN_B2R <= '1'; EN_PC <='1';  EN_ABCD <= '1';
                    
                 
                                                        
                    next_state <= running;
                                             
               end if;
                
            when others => -- unknown state
                    -- should never get here, but if it does, set PC<=0 and stop
                   EN_PC <='1';
                    
                    next_state <= stopped;
        end case;
    end process next_state_and_output;
    
end behavorial;
