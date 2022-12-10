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

	u0 : component unsaved
		port map (
			avalon_f1_0_conduit_end_in_girouette  => CONNECTED_TO_avalon_f1_0_conduit_end_in_girouette,  -- avalon_f1_0_conduit_end.in_girouette
			avalon_f1_0_conduit_end_in_anemometre => CONNECTED_TO_avalon_f1_0_conduit_end_in_anemometre, --                        .in_anemometre
			avalon_f6_0_conduit_data_adc          => CONNECTED_TO_avalon_f6_0_conduit_data_adc,          --     avalon_f6_0_conduit.data_adc
			avalon_f6_0_conduit_cs_adc            => CONNECTED_TO_avalon_f6_0_conduit_cs_adc,            --                        .cs_adc
			avalon_f6_0_conduit_clk_adc           => CONNECTED_TO_avalon_f6_0_conduit_clk_adc,           --                        .clk_adc
			avalon_f6_0_conduit_pwm_motor         => CONNECTED_TO_avalon_f6_0_conduit_pwm_motor,         --                        .pwm_motor
			avalon_f6_0_conduit_sens_motor        => CONNECTED_TO_avalon_f6_0_conduit_sens_motor,        --                        .sens_motor
			avalonf7_0_conduit_end_bp_babord      => CONNECTED_TO_avalonf7_0_conduit_end_bp_babord,      --  avalonf7_0_conduit_end.bp_babord
			avalonf7_0_conduit_end_bp_stby        => CONNECTED_TO_avalonf7_0_conduit_end_bp_stby,        --                        .bp_stby
			avalonf7_0_conduit_end_bp_tribord     => CONNECTED_TO_avalonf7_0_conduit_end_bp_tribord,     --                        .bp_tribord
			avalonf7_0_conduit_end_ledbabord      => CONNECTED_TO_avalonf7_0_conduit_end_ledbabord,      --                        .ledbabord
			avalonf7_0_conduit_end_ledstby        => CONNECTED_TO_avalonf7_0_conduit_end_ledstby,        --                        .ledstby
			avalonf7_0_conduit_end_ledtribord     => CONNECTED_TO_avalonf7_0_conduit_end_ledtribord,     --                        .ledtribord
			avalonf7_0_conduit_end_out_bip        => CONNECTED_TO_avalonf7_0_conduit_end_out_bip,        --                        .out_bip
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                     clk.clk
			reset_reset_n                         => CONNECTED_TO_reset_reset_n                          --                   reset.reset_n
		);

