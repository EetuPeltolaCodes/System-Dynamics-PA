function [cf_model] = load_model(periods, tonnes, mill1, mill_Au_GRAde, waste, ...
    stockpile_in, stockpile_out, recovery_rate, unit_processing_cost, ...
    capital_expenditure, tax_and_royalty, mining_cost_inflation, ...
    discount_rate, initial_mining_cost, goldPrice, model_name)

    cf_model = Simulink.SimulationInput(model_name);
    time = (1:length(periods))';  % Calculate the time
    
    % Set up the variables
    cf_model = cf_model.setVariable('tonnes', timeseries(tonnes, time));
    cf_model = cf_model.setVariable('mill1', timeseries(mill1, time));
    cf_model = cf_model.setVariable('mill_au_grade', timeseries(mill_Au_GRAde, time));
    cf_model = cf_model.setVariable('waste', timeseries(waste, time));
    cf_model = cf_model.setVariable('stockpile_in', timeseries(stockpile_in, time));
    cf_model = cf_model.setVariable('stockpile_out', timeseries(stockpile_out, time));
    cf_model = cf_model.setVariable('recovery_rate', timeseries(recovery_rate, time));
    cf_model = cf_model.setVariable('unit_processing_cost', timeseries(unit_processing_cost, time));
    cf_model = cf_model.setVariable('capital_expenditure', timeseries(capital_expenditure, time));
    cf_model = cf_model.setVariable('tax_and_royalty', timeseries(tax_and_royalty, time));
    cf_model = cf_model.setVariable('mining_cost_inflation', timeseries(mining_cost_inflation, time));
    cf_model = cf_model.setVariable('periods', timeseries(periods, time));
    cf_model = cf_model.setVariable('discount_rate', timeseries(discount_rate, time));
    cf_model = cf_model.setVariable('initial_mining_cost', timeseries(initial_mining_cost, time));
    cf_model = cf_model.setVariable('gold_price', timeseries(goldPrice, time));

end

