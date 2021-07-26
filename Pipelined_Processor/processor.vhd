library IEEE;
use IEEE.std_logic_1164.all;
use work.sm16_types.all;

-- processor Entity Description
-- Adapted from Dr. Michael Crocker's Spring 2013 CSCE 385 Lab 4 at Pacific Lutheran University
entity processor is
    port( CLK : in std_logic;
          RESET : in std_logic;
          START : in std_logic  -- signals to run the processor
          );
end processor;

-- processor Architecture Description
architecture structural of processor is
    
    -- declare all components and their ports 
    component datapath is
        port( CLK   : in std_logic;
              RESET : in std_logic;
              
              -- I/O with Data Memory
              DATA_IN   : out sm16_data;
              DATA_OUT  : in  sm16_data;
              DATA_ADDR : out sm16_address;
              
              -- I/O with Instruction Memory
              INSTR_OUT  : in  sm16_data;
              INSTR_ADDR : out sm16_address;
              
              
              
              -- Control Signals to the ALU
              ALU_OP : in std_logic_vector(1 downto 0);
              B_INV  : in std_logic;
              CIN    : in std_logic;
              
              EN_PC  : in std_logic;
              
              -- ALU Multiplexer Select Signals
              A_SEL  : in std_logic;
              B_SEL  : in std_logic;
              
                --I added these
                --OP Signals
          OP2 : out std_logic_vector (3 downto 0);
          OP3 : out std_logic_vector (3 downto 0);
          
          -- Enable Signals
          EN_INSTR : in std_logic;
          EN_IMM : in std_logic;
          EN_OP : in std_logic;
          EN_DATA : in std_logic;
          EN_RV : in std_logic;
          EN_B2R : in std_logic;
          EN_ABCD : in std_logic);
    end component;
    
    component instr_memory is
        port( DIN : in sm16_data;
              ADDR: in sm16_address;
              DOUT: out sm16_data;
              WE: in std_logic);
    end component;
    
    component data_memory is
        port( DIN : in sm16_data;
              ADDR : in sm16_address;
              DOUT : out sm16_data;
              WE : in std_logic);
    end component;
    
    component control2 is
        port( CLK   : in std_logic;
              RESET : in std_logic;
              START : in std_logic;
             
              WE     : out std_logic;            
              EN_PC  : out std_logic;
              
          OP2 : in std_logic_vector (3 downto 0);
       
          
          -- Enable Signals
      
          EN_INSTR : out std_logic;
          EN_IMM : out std_logic;
          EN_OP : out std_logic;
          EN_DATA : out std_logic;
          EN_RV : out std_logic;
          EN_B2R : out std_logic);
        
    end component;
    
    
      component control3 is
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
                    
    end component;
    
    signal DataAddress_Connect, PCAddress_Connect : sm16_address;
    signal Data_IntoMem_Connect : sm16_data;
    signal DataOut_OutofMem_Connect, Instruction_Connect : sm16_data;
    signal ReadWrite_Connect : std_logic;
    
  
    signal ALUOp_Connect : std_logic_vector(1 downto 0);
    signal Binv_Connect  : std_logic;
    signal Cin_Connect   : std_logic;
    
    
    signal ASel_Connect  : std_logic;
    signal BSel_Connect  : std_logic;

    signal EnPC_Connect : std_logic;
    
    signal EnInstr_Connect : std_logic;
    signal EnImm_Connect  : std_logic;
    signal EnOP_Connect  : std_logic;
    signal EnData_Connect  : std_logic;
    signal EnRV_Connect  : std_logic;
    signal EnB2R_Connect  : std_logic;
    signal EnABCD_connect : std_logic;
    
    signal OP2_Connect : std_logic_vector(3 downto 0);
    signal Op3_Connect : std_logic_vector (3 downto 0);
    
begin
    
    the_instr_memory: instr_memory port map (
        DIN => "0000000000000000",
        ADDR => PCAddress_Connect,
        DOUT => Instruction_Connect,
        WE => '0'  -- always read
        );
        
    the_data_memory: data_memory port map (
        DIN => Data_IntoMem_Connect,
        ADDR => DataAddress_Connect,
        DOUT => DataOut_OutofMem_Connect,
        WE => ReadWrite_Connect
        );
        
    the_datapath: datapath port map (
        CLK   => CLK,
        RESET => RESET,
        DATA_IN   => Data_IntoMem_Connect,
        DATA_OUT  => DataOut_OutofMem_Connect,
        DATA_ADDR => DataAddress_Connect,
        INSTR_OUT  => Instruction_Connect,
        INSTR_ADDR => PCAddress_Connect,
        
        
        ALU_OP => ALUOp_Connect,
        B_INV  => Binv_Connect,
        CIN    => Cin_Connect,
        A_SEL  => ASel_Connect,
        B_SEL  => BSel_Connect,
        EN_PC => EnPC_Connect,
        
   
    
              --I added these
                --OP Signals
          OP2 => OP2_Connect,
          OP3 => Op3_Connect,
          
          -- Enable Signals
          EN_INSTR => EnInstr_Connect,
          EN_IMM => EnImm_Connect,
          EN_OP => EnOP_Connect,
          EN_DATA => EnData_Connect,
          EN_RV =>  EnRV_Connect,
          EN_B2R => EnB2R_Connect,
          EN_ABCD => EnABCD_connect
        
        );
        
    the_control2: control2 port map (
        CLK   => CLK,
        RESET => RESET,
        START => START,
        
        WE     => ReadWrite_Connect,   
        
        EN_PC  => EnPC_Connect,      
        OP2 => OP2_Connect,                
        EN_INSTR => EnInstr_Connect,
        EN_IMM => EnImm_Connect,
        EN_OP => EnOP_Connect,
        EN_DATA => EnData_Connect,
        EN_RV =>  EnRV_Connect,
        EN_B2R => EnB2R_Connect
               
         
        );
        
        
         the_control3: control3 port map (
        CLK   => CLK,
        RESET => RESET,
        START => START,
        ALU_OP => ALUOp_Connect,
        B_INV  => Binv_Connect,
        CIN    => Cin_Connect,
        A_SEL  => ASel_Connect,
        B_SEL  => BSel_Connect,
        OP3 => Op3_Connect,
        EN_ABCD => EnABCD_connect 
       
        );
        
end structural;
