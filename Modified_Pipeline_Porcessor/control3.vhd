library ieee;
use ieee.std_logic_1164.all;
use work.sm16_types.all;

-- control Entity Description
-- Adapted from Dr. Michael Crocker's Spring 2013 CSCE 385 Lab 4 at Pacific Lutheran University
entity control3 is
 port( CLK   : in std_logic;
              RESET : in std_logic;
              START : in std_logic;
              OP3 : in std_logic_vector (3 downto 0);
              
             EN_ABCD : out std_logic; 
              ALU_OP : out std_logic_vector(1 downto 0);
              B_INV  : out std_logic;
              CIN    : out std_logic;
              A_SEL  : out std_logic;
              B_SEL  : out std_logic);  
end control3;

-- control Architecture Description
architecture behavorial of control3 is

    -- control signal values
        -- alu operations
        constant alu_nop : std_logic_vector(1 downto 0) := "00";
        constant alu_and : std_logic_vector(1 downto 0) := "00";
        constant alu_or  : std_logic_vector(1 downto 0) := "01";
        constant alu_add : std_logic_vector(1 downto 0) := "10";
        
        -- a select control
        constant a_0 : std_logic := '0';
        constant a_a : std_logic := '1';
        
        -- b select control
        constant b_mem : std_logic := '0';
        constant b_imm : std_logic := '1';
        
        
        -- register load control
        constant hold : std_logic := '0';
        constant load : std_logic := '1';
        
     
        
        -- b invert control
        constant pos : std_logic := '0';
        constant inv : std_logic := '1';
        
    -- op codes
    constant op_add   : sm16_opcode := "0000";
    constant op_sub   : sm16_opcode := "0001";  
    constant op_load  : sm16_opcode := "0010";
    constant op_store : sm16_opcode := "0011";
    constant op_addi  : sm16_opcode := "0100";
    constant op_seti  : sm16_opcode := "0101";
    constant op_jump  : sm16_opcode := "0110";
  --  constant op_jz    : sm16_opcode := "000111";
    
    -- definitions of the states the control can be in
    type states is (stopped, running);  -- single cycle now, so only one running state
    signal state, next_state : states := stopped;
    

    
begin
    
    
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
    next_state_and_output: process(state, START, OP3 )
    begin
        case state is
            -- Stopped is the stopped state; wait for start
            when stopped =>
                
                if( START /= '1' ) then
                    -- issue nop
                  
               
          
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_nop;
                    A_SEL <= a_0;     B_SEL  <= b_mem;  EN_ABCD <= '0';
                    
                    next_state <= stopped;
                else
                   
          
                    
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_and;
                    A_SEL <= a_0;     B_SEL  <= b_mem;  EN_ABCD <= '0';
                    
                    next_state <= running; -- go to fetch state
                end if;
                
            -- In running state, each instruciton has its own control signals
            when running =>
                
                if OP3 = op_add then
                    -- A <- A + Mem

                
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_add;
                    A_SEL <= a_a;     B_SEL  <= b_mem; EN_ABCD <= '1';
                    
                    next_state <= running;
                    
                elsif OP3 = op_sub then
                    -- A <- A - Mem
                   
                    
                    B_INV <= inv;     CIN    <= '1';     ALU_OP <= alu_add; --ADD TOGETHER
                    
                    A_SEL <= a_a;     B_SEL  <= b_mem; EN_ABCD <= '1';
                    
                    next_state <= running;
                    
                elsif  OP3 = op_seti then
                    -- A <- 0 + Immediate
                     
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_add;
                    A_SEL <= a_0;     B_SEL  <= b_imm;  EN_ABCD <= '1'; 
                    
                    next_state <= running;
                    
                elsif OP3 = op_load then
                    -- PC <- 0 + Immediate
                    
                    
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_add; --DONE
                 EN_ABCD <= '1';
                    A_SEL <= a_0;     B_SEL  <= b_mem; --DONE
                    
                    next_state <= running;
                    
               elsif OP3 = op_store then
                    -- PC <- 0 + Immediate
                       
                    
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_nop;
                    
                    A_SEL <= a_a;     B_SEL  <= b_imm;   EN_ABCD <= '0';
                    
                    next_state <= running; 
                      
               elsif OP3 = op_addi then
                    -- PC <- 0 + Immediate
                      
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_add;
                    
                    A_SEL <= a_a;     B_SEL  <= b_imm; EN_ABCD <= '1';
                                                        
                    next_state <= running;
                    
                   elsif OP3 = op_jump then
                    -- PC <- 0 + Immediate
 -- Enable Signals
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_nop;
                    
                    A_SEL <= a_0;     B_SEL  <= b_mem; EN_ABCD <= '0';
                    next_state <= running;   
                                             
               end if;
                
            when others => -- unknown state
                    -- should never get here, but if it does, set PC<=0 and stop
                    B_INV <= pos;     CIN    <= '0';     ALU_OP <= alu_and;
                    A_SEL <= a_0;     B_SEL  <= b_mem; EN_ABCD <= '0';
                    
                    next_state <= stopped;
        end case;
    end process next_state_and_output;
    
end behavorial;
