%% Estimate mu and sigma with MCMC
clc
close all
clearvars

% Create Plots Directory if Not Exists
plots_dir = '../Plots';
if ~exist(plots_dir, 'dir')
    mkdir(plots_dir);
end

[mu, sigma, prices] = calculateParametersGBM('../DataSheet.xlsx');

%% Load data
clc
close all
[data_sheet1, data_sheet2, data_sheet3] = get_data('../Planning_Data_with_NPV_values.xlsx');
datas = {data_sheet1 ,data_sheet2, data_sheet3};

%%
close all
clc

model = 'SD_Model';

dt = 1;
N = 10^4;
initial_price = prices(end);

oldPrice_general = gold_Price(initial_price, mu, sigma, dt, 20, N, prices);

for i = 1:3
    % Parse data
    data = datas{1, i};
    [periods, tonnes, mill1, mill_Au_GRAde, waste, ...
    stockpile_in, stockpile_out, recovery_rate, unit_processing_cost, ...
    capital_expenditure, tax_and_royalty, mining_cost_inflation, ...
    discount_rate, initial_mining_cost] = parse_data(data);
    
    T = length(periods);
   
    goldPrice = goldPrice_general(1:T,:);
    
    set_param(model, 'StopTime', num2str(T))
    
    cf_model = load_model(periods, tonnes, mill1, mill_Au_GRAde, waste, ...
        stockpile_in, stockpile_out, recovery_rate, unit_processing_cost, ...
        capital_expenditure, tax_and_royalty, mining_cost_inflation, ...
        discount_rate, initial_mining_cost, goldPrice, model);
    
    sim_result = sim(cf_model);
    mean_NPVs = mean(sim_result.simout1.Data,2);
    mean_cum_NPVs = mean(sim_result.simout.Data, 2);

    % Percent of negative NPV results
    NPVs = sim_result.simout1.Data;
    s_NPVs = sign(NPVs);
    switch(i)
        case 1
            negative_NPVs_1 = sum(s_NPVs==-1,2) ./ length(NPVs);
            cum_NPVs_1 = mean_cum_NPVs;
            NPVs_1 = mean_NPVs;
        case 2
            negative_NPVs_2 = sum(s_NPVs==-1,2) ./ length(NPVs);
            cum_NPVs_2 = mean_cum_NPVs;
            NPVs_2 = mean_NPVs;
        case 3
            negative_NPVs_3 = sum(s_NPVs==-1,2) ./ length(NPVs);
            cum_NPVs_3 = mean_cum_NPVs;
            NPVs_3 = mean_NPVs;
    end

    % Mean NPV
    figure
    hold on
    subplot(1,2,1);
    plot(1:T, mean_NPVs, 'b', 'LineWidth', 2); 
    yline(0, '--k', 'LineWidth', 1.5); 
    xlabel('Time (Periods)');
    ylabel('Mean NPV');
    title(['Mean NPV - Case ', num2str(i)]);
    axis tight
    legend('Mean NPV', 'Reference Line (y=0)', 'Location', 'best');
    grid on;

    % Cumulative Mean NPV
    subplot(1,2,2);
    plot(1:T, mean_cum_NPVs, 'r', 'LineWidth', 2);
    yline(0, '--k', 'LineWidth', 1.5);
    xlabel('Time (Periods)');
    ylabel('Cumulative Mean NPV');
    title(['Cumulative Mean NPV - Case ', num2str(i)]);
    legend('Cumulative Mean NPV', 'Reference Line (y=0)', 'Location', 'best');
    axis tight
    grid on;
    hold off

    saveas(gcf, fullfile(plots_dir, ['NPV_Results_Case', num2str(i), '.svg']));
end

disp('Case 1 probability of negative NPV')
round(negative_NPVs_1 * 100,2)
disp('Case 2 probability of negative NPV')
round(negative_NPVs_2 * 100,2)
disp('Case 3 probability of negative NPV')
round(negative_NPVs_3 * 100,2)
disp(['Cumulative NPVs after 11 years case 1: ', num2str(round(cum_NPVs_1(end))), ', case 2: ', num2str(round(cum_NPVs_2(11))), ', case 3: ', num2str(round(cum_NPVs_3(11)))])
disp(['Cumulative NPVs after 14 years case 2: ', num2str(round(cum_NPVs_2(end))), ', case 3: ', num2str(round(cum_NPVs_3(14)))])
disp(['Cumulative NPV of case 3 after 20 years: ', num2str(round(cum_NPVs_3(end)))])

%% Worst case: case 3
clc
close all

data = datas{1, 3};
[periods, tonnes, mill1, mill_Au_GRAde, waste, ...
stockpile_in, stockpile_out, recovery_rate, unit_processing_cost, ...
capital_expenditure, tax_and_royalty, mining_cost_inflation, ...
discount_rate, initial_mining_cost] = parse_data(data);

% Max recovery rate = 1
max_increase = 1-recovery_rate(end);
% Increase to 0.9
increase = ones(size(recovery_rate))* 0.05;
recovery_rate = recovery_rate+increase;
%recovery_rate = ones(size(recovery_rate))

T = length(periods);

goldPrice = goldPrice_general(1:T,:);

set_param(model, 'StopTime', num2str(T))

cf_model = load_model(periods, tonnes, mill1, mill_Au_GRAde, waste, ...
    stockpile_in, stockpile_out, recovery_rate, unit_processing_cost, ...
    capital_expenditure, tax_and_royalty, mining_cost_inflation, ...
    discount_rate, initial_mining_cost, goldPrice, model);

sim_result = sim(cf_model);
mean_NPVs = mean(sim_result.simout1.Data,2);
mean_cum_NPVs = mean(sim_result.simout.Data, 2);

NPVs = sim_result.simout1.Data;
s_NPVs = sign(NPVs);
disp('Case 3 probability of negative NPV')
round(sum(s_NPVs==-1,2) ./ length(NPVs) * 100, 2)


% Mean NPV
figure
hold on
subplot(1,2,1);
plot(1:T, mean_NPVs, 'b', 'LineWidth', 2); 
yline(0, '--k', 'LineWidth', 1.5); 
xlabel('Time (Periods)');
ylabel('Mean NPV');
title(['Mean NPV - Case ', num2str(i)]);
axis tight
legend('Mean NPV', 'Reference Line (y=0)', 'Location', 'best');
grid on;

% Cumulative Mean NPV
subplot(1,2,2);
plot(1:T, mean_cum_NPVs, 'r', 'LineWidth', 2);
yline(0, '--k', 'LineWidth', 1.5);
xlabel('Time (Periods)');
ylabel('Cumulative Mean NPV');
title(['Cumulative Mean NPV - Case ', num2str(i)]);
legend('Cumulative Mean NPV', 'Reference Line (y=0)', 'Location', 'best');
axis tight
grid on;
hold off

saveas(gcf, fullfile(plots_dir, 'NPV_Results_Case_3_better.svg'));