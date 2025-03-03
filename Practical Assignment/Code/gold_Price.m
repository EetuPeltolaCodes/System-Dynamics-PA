function S = gold_Price(S0, mu, sigma, dt, T, N, prices)
    % Simulate paths
    model = gbm(mu, sigma, 'StartState', S0);
    [Paths, ~, ~] = simulate(model, T, 'DeltaTime', dt, 'nTrials', N);

    % Calculate the mean and quantiles
    S = squeeze(Paths);
    S_mean = mean(S, 2);
    S_10 = quantile(S, 0.1, 2);
    S_90 = quantile(S, 0.9, 2);

    prices_t = linspace(-length(prices)/12, 0, length(prices));
    t = linspace(0, T, length(S_mean))';
    
    % Plot
    figure;
    plot(t, S); 
    hold on;
    h0 = plot(prices_t, prices, 'b', 'LineWidth', 2);
    h1 = plot(t, S_mean, 'k', 'LineWidth', 2); 
    h2 = plot(t, S_10, 'k--', 'LineWidth', 2); 
    h3 = plot(t, S_90, 'k--', 'LineWidth', 2); 
    axis tight
    xlabel('Time (Periods)');
    ylabel('Gold Price ($)');
    title(['Monte Carlo Gold Price Simulation (N = ', num2str(N), ')']);
    legend([h0, h1, h2, h3],'Price Data', 'Mean Price', '10th Percentile', '90th Percentile', ...
           'Location', 'best');
    grid on;

    plots_dir = '../Plots';
    
    saveas(gcf, fullfile(plots_dir, 'Gold_Price_Simulation.svg'));
end

