function [data_sheet1, data_sheet2, data_sheet3] = get_data(file)
    data_sheet1 = readtable(file, 'Sheet', 'Plan_8Mt');
    data_sheet2 = readtable(file, 'Sheet', 'Plan_6Mt'); 
    data_sheet3 = readtable(file, 'Sheet', 'Plan_4Mt');
end

