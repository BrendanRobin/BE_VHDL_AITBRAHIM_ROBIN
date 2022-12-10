library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all; 

entity top is 
port (
	clk, arst_i, in_anemometre, in_girouette, BP_Babord, BP_Tribord, BP_Stby : in std_logic;
	data_in : in std_logic; 
	pwm_o, sens_o, cs_o, clk_adc_o, Led_Babord, Led_Tribord, Led_Stby, Out_bip : out std_logic
); 
end entity top; 




architecture rtl of top is 
		component unsaved is
		port (
			avalon_f1_0_conduit_end_in_girouette  : in  std_logic := 'X'; -- in_girouette
			avalon_f1_0_conduit_end_in_anemometre : in  std_logic := 'X'; -- in_anemometre
			avalon_f6_0_conduit_data_adc          : in  std_logic := 'X'; -- data_adc
			avalon_f6_0_conduit_cs_adc            : out std_logic;        -- cs_adc
			avalon_f6_0_conduit_clk_adc           : out std_logic;        -- clk_adc
			avalon_f6_0_conduit_pwm_motor         : out std_logic;        -- pwm_motor
			avalon_f6_0_conduit_sens_motor        : out std_logic;        -- sens_motor
			avalonf7_0_conduit_end_bp_babord      : in  std_logic := 'X'; -- bp_babord
			avalonf7_0_conduit_end_bp_stby        : in  std_logic := 'X'; -- bp_stby
			avalonf7_0_conduit_end_bp_tribord     : in  std_logic := 'X'; -- bp_tribord
			avalonf7_0_conduit_end_ledbabord      : out std_logic;        -- ledbabord
			avalonf7_0_conduit_end_ledstby        : out std_logic;        -- ledstby
			avalonf7_0_conduit_end_ledtribord     : out std_logic;        -- ledtribord
			avalonf7_0_conduit_end_out_bip        : out std_logic;        -- out_bip
			clk_clk                               : in  std_logic := 'X'; -- clk
			reset_reset_n                         : in  std_logic := 'X'  -- reset_n
		);
	end component unsaved;
begin


	u0 : component unsaved
		port map (
			avalon_f1_0_conduit_end_in_girouette  => in_girouette,  -- avalon_f1_0_conduit_end.in_girouette
			avalon_f1_0_conduit_end_in_anemometre => in_anemometre, --                        .in_anemometre
			avalon_f6_0_conduit_data_adc          => data_in,          --     avalon_f6_0_conduit.data_adc
			avalon_f6_0_conduit_cs_adc            => cs_o,            --                        .cs_adc
			avalon_f6_0_conduit_clk_adc           => clk_adc_o,           --                        .clk_adc
			avalon_f6_0_conduit_pwm_motor         => pwm_o,         --                        .pwm_motor
			avalon_f6_0_conduit_sens_motor        => sens_o,        --                        .sens_motor
			avalonf7_0_conduit_end_bp_babord      => BP_Babord,      --  avalonf7_0_conduit_end.bp_babord
			avalonf7_0_conduit_end_bp_stby        => BP_Stby,        --                        .bp_stby
			avalonf7_0_conduit_end_bp_tribord     => BP_Tribord,     --                        .bp_tribord
			avalonf7_0_conduit_end_ledbabord      => Led_Babord,      --                        .ledbabord
			avalonf7_0_conduit_end_ledstby        => Led_Stby,        --                        .ledstby
			avalonf7_0_conduit_end_ledtribord     => Led_Tribord,     --                        .ledtribord
			avalonf7_0_conduit_end_out_bip        => Out_bip,        --                        .out_bip
			clk_clk                               => clk,                               --                     clk.clk
			reset_reset_n                         => arst_i                          --                   reset.reset_n
		);



end architecture; 