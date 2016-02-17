close all;

t=load('/arquivos/tcc/Results/olimex/01february2015/online/results_p300_audio_luiz.txt');

l=length(t);
i=1;

targets=t(:,1);
Predict=t(:,2);

TP=0;
TN=0;
FN=0;
FP=0;
while i<l+1;
    if Predict(i) == targets(i)
        if targets(i)==1
            TP=TP+1;
        else
            TN=TN+1;
        end
    else
        if targets(i)==1
            FN=FN+1;
        else
            FP=FP+1;
        end
    end
    i=i+1;
end


Accuracy=100*(TP+TN)/(TP+TN+FP+FN);

Selectivity = 100*TP/(TP+FP);

Sensitivity = 100*TP/(TP+FN);

Specificity = 100*TN/(TN+FP);

%% Draw table
d=[Selectivity, Sensitivity, Specificity, Accuracy];
f = figure('Position',[300 300 500 70]);
    
 % Create the column and row names in cell arrays 
cnames = {'Selectivity','Sensitivity','Specificity', 'Accuracy'};
rnames = {'Validation'};  
    
% Create the uitable
table = uitable('Data',d,...
            'ColumnName',cnames,... 
            'RowName',rnames, 'Position', [0 0 500 70]);
% Set width and height
table.Position = [400 400 400 100];