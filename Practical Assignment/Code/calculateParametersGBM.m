function [mu, sigma, price] = calculateParametersGBM(file)
    data = readtable(file);
    price = data.Price;
    price = str2double(price);
    change = data.Change;
    change = change(~isnan(price));
    % Use only the last 5 year data
    %change = change(end-12*5:end);
    
    model.ssfun = @(params, data) nll_GBM(params, price);

    % Initial parameter guess: [mu, sigma]
    params = {
        {'mu', 0, -1, 1, 0,1}
        {'sigma', 0, 0, 10, 0, 1}
    };

    options.nsimu = 10000;  % Number of MCMC iterations
    options.method = 'dram'; % Use DRAM

    % Run MCMC
    [results, chain, s2chain] = mcmcrun(model, change, params, options);

    % Extract estimated parameters
    mu_est = chain(:,1);  % Mean of posterior for mu
    sigma_est = chain(:,2); % Mean of posterior for sigma

    % Take away the burnin time 10%
    mu_burnin = mean(mu_est(length(chain(:,1))*0.1:end));
    sigma_burnin = mean(sigma_est(length(chain(:,2))*0.1:end));

    % Compute drift (mean change) yearly
    mu = mu_burnin*12;

    % Compute volatility (std deviation change) yearly
    sigma = sqrt(12)*sigma_burnin;

    % Compute cumulative average (running mean)
    cum_avg_mu = cumsum(chain(:,1)) ./ (1:length(chain(:,1)))';
    cum_avg_sigma = cumsum(chain(:,2)) ./ (1:length(chain(:,2)))';

    figure;
    subplot(2,2,1);
    plot(chain(:,1), 'b');
    hold on;
    plot(cum_avg_mu, 'r', 'LineWidth', 1.5);
    hold off;
    xlabel('Iteration');
    ylabel('mu');
    title('MCMC Chain for \mu');
    legend('Chain', 'Cumulative Average');

    subplot(2,2,2);
    plot(chain(:,2), 'b');
    hold on;
    plot(cum_avg_sigma, 'r', 'LineWidth', 1.5); 
    hold off;
    xlabel('Iteration');
    ylabel('sigma');
    title('MCMC Chain for \sigma');
    legend('Chain', 'Cumulative Average');

    subplot(2, 2, 3);
    histogram(mu_est, 50);
    title('Histogram of \mu values');
    xlabel('\mu');
    ylabel('Frequency');
    
    subplot(2, 2, 4);
    histogram(sigma_est, 50);
    title('Histogram of \sigma values');
    xlabel('\sigma');
    ylabel('Frequency');

    saveas(gcf, fullfile('../Plots', 'Parameter_Estimation_with_MCMC.svg'));

end

% Function to the negative log-likelihood
function nll = nll_GBM(params, data)
    % Extract parameters: mu and sigma
    mu = params(1);
    sigma = params(2);
    
    % Calculate the log-returns
    log_returns = log(data(2:end) ./ data(1:end-1));
    
    % Calculate the mean and variance of the log-returns
    mu_adjusted = mu - 0.5 * sigma^2;
    
    % Calculate the sum of squared errors
    sq_errors = (log_returns - mu_adjusted).^2;
    
    % Compute the negative log-likelihood
    nll = (length(log_returns) / 2) * log(2 * pi * sigma^2) + (1 / (2 * sigma^2)) * sum(sq_errors);
end