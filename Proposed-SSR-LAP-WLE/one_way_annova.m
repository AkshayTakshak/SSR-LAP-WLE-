clc; clear; close all;

%% --- Input Data (Each row = Dataset, Each column = Technique) ---
SSIM = [...
    0.5926, 0.6614, 0.4339, 0.6127, 0.6344, 0.5091, 0.4479, 0.5827, 0.6276, 0.3121, 0.2910, 0.6832, 0.5931, 0.4929;  % Dataset 1
    0.5512, 0.6169, 0.3426, 0.5108, 0.5990, 0.4382, 0.3318, 0.5218, 0.5255, 0.2940, 0.2851, 0.6042, 0.5349, 0.4637;  % Dataset 2
    0.4669, 0.5244, 0.2724, 0.3322, 0.5012, 0.3642, 0.2590, 0.4227, 0.3849, 0.2701, 0.2851, 0.4805, 0.4325, 0.3987;  % Dataset 3
    0.4185, 0.4137, 0.2509, 0.3401, 0.3909, 0.2836, 0.3340, 0.3205, 0.3666, 0.2546, 0.1308, 0.3547, 0.3288, 0.3170;  % Dataset 4
    0.3754, 0.3365, 0.2270, 0.2845, 0.3131, 0.2108, 0.2833, 0.2436, 0.3568, 0.2552, 0.1130, 0.2819, 0.2728, 0.2303;  % Dataset 5
];

methods = {'Proposed','BRUEM','CBM','CBF','MLLE','PCDE','PDS','UDHTV','RRO','WCD','UNTV','HFM','ROP','TEBCF'};

%% Step 2: Significance Level
alpha = 0.05;

%% Step 3: Degrees of Freedom
[a,b] = size(SSIM);   % a = datasets, b = methods
N = numel(SSIM);
df_between = b - 1;   % Between = methods
df_within = N - b;
df_total = N - 1;

fprintf('\n3. CALCULATE DEGREES OF FREEDOM\n');
fprintf('   Total observations N = %d\n', N);
fprintf('   df_between = %d\n', df_between);
fprintf('   df_within  = %d\n', df_within);
fprintf('   df_total   = %d\n', df_total);

%% Step 4: ANOVA Components
group_means = mean(SSIM,1);   % mean per method
overall_mean = mean(SSIM(:));

SS_between = sum(a*(group_means - overall_mean).^2);
SS_within = sum(sum((SSIM - group_means).^2));
SS_total = SS_between + SS_within;

MS_between = SS_between / df_between;
MS_within  = SS_within  / df_within;
F_value = MS_between / MS_within;

%% Step 5: Display Table
fprintf('\n5. CALCULATE TEST STATISTICS\n');
fprintf('------------------------------------------------------------\n');
fprintf('%-12s %-12s %-5s %-12s %-8s %-8s\n','Source','SS','df','MS','F','Prob>F');
fprintf('------------------------------------------------------------\n');
p_val = 1 - fcdf(F_value, df_between, df_within);
fprintf('%-12s %-12.4f %-5d %-12.4f %-8.2f %-8.4f\n','Between',SS_between,df_between,MS_between,F_value,p_val);
fprintf('%-12s %-12.4f %-5d %-12.4f\n','Within',SS_within,df_within,MS_within);
fprintf('%-12s %-12.4f %-5d\n','Total',SS_total,df_total);
fprintf('------------------------------------------------------------\n');

%% Step 6: Decision Rule
F_crit = finv(1-alpha, df_between, df_within);
fprintf('\n6. STATE DECISION RULE\n');
fprintf('   Critical value F(%.2f; %d,%d) = %.4f\n', 1-alpha, df_between, df_within, F_crit);
fprintf('   If F_calc > F_crit => Reject H0\n');

%% Step 7: Result & Conclusion
fprintf('\n7. STATE RESULT & CONCLUSION\n');
if F_value > F_crit
    fprintf('   F_calc = %.4f > %.4f ⇒ Reject H0\n', F_value, F_crit);
    fprintf('   => Significant difference among methods (p = %.4f < α)\n', p_val);
else
    fprintf('   F_calc = %.4f < %.4f ⇒ Fail to Reject H0\n', F_value, F_crit);
    fprintf('   => No significant difference among methods (p = %.4f > α)\n', p_val);
end

%% Step 8: Effect Size
eta_sq = SS_between / SS_total;
fprintf('\n8. EFFECT SIZE\n');
fprintf('   Eta-Squared (η²) = %.4f (%.2f%% of total variance explained)\n', eta_sq, eta_sq*100);
fprintf('==============================================================\n\n');
