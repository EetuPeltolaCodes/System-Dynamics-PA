function [periods, tonnes, mill1, mill_Au_GRAde, waste, ...
    stockpile_in, stockpile_out, recovery_rate, unit_processing_cost, ...
    capital_expenditure, tax_and_royalty, mining_cost_inflation, ...
    discount_rate, initial_mining_cost] = parse_data(data)

    periods = data.Period;
    periods = periods(~isnan(periods));

    tonnes = data.Tonnes;
    tonnes = tonnes(~isnan(tonnes));
    tonnes = tonnes(1:end-1); % Remove the total

    mill1 = data.Mill1;
    mill1 = mill1(~isnan(mill1));
    discount_rate = mill1(end); 
    mining_cost_inflation = mill1(end-1);
    initial_mining_cost = mill1(end-2);
    mill1 = mill1(1:end-4); % Remove the total and other variables

    mill_Au_GRAde = data.Mill_Au_GRADE_g_t_;
    mill_Au_GRAde = mill_Au_GRAde(~isnan(mill_Au_GRAde));
    mill_Au_GRAde = mill_Au_GRAde(1:end-1);

    waste = data.Waste;
    waste = waste(~isnan(waste));
    waste = waste(1:end-1);

    stockpile_in = data.Stockpile_t__in;
    stockpile_in = stockpile_in(~isnan(stockpile_in));
    stockpile_in = stockpile_in(1:end-1);

    stockpile_out = data.Stockpile_t__out;
    stockpile_out = stockpile_out(~isnan(stockpile_out));
    stockpile_out = stockpile_out(1:end-1);

    recovery_rate = data.RecoveryRate;
    recovery_rate = recovery_rate(~isnan(recovery_rate));

    unit_processing_cost = data.UnitProcessingCost_USD_tn_;
    unit_processing_cost = unit_processing_cost(~isnan(unit_processing_cost));

    capital_expenditure = data.CapitalExpenditure_USD_;
    capital_expenditure = capital_expenditure(~isnan(capital_expenditure));
    capital_expenditure = capital_expenditure(1:end-1);

    tax_and_royalty = data.TaxAndRoyalty___;
    tax_and_royalty = tax_and_royalty(~isnan(tax_and_royalty));
    tax_and_royalty = tax_and_royalty(1:end-1);

end

