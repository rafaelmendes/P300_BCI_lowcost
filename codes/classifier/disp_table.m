function [] = disp_table(a, selec, sens, spec, a_cv, selec_cv, sens_cv, spec_cv)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

d=[selec, sens, spec, a; selec_cv, sens_cv, spec_cv, a_cv];
f = figure('Position',[300 300 500 70]);
    
 % Create the column and row names in cell arrays 
cnames = {'Selectivity','Sensitivity','Specificity','Accuracy'};
rnames = {'Validation','Cross_Validation'};  
    
% Create the uitable
t = uitable('Data',d,...
            'ColumnName',cnames,... 
            'RowName',rnames, 'Position', [0 0 500 70]);
% Set width and height
t.Position = [400 400 400 100];

end

