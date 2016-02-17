close all
clear all
% Specifications:

low_cutoff=0.5; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=10; % band pass filter upper cutoff frequency (Hz)

epoch_start=0; % latency before the event for epoch extraction
epoch_end=1; % latency after the event for epoch extraction

max_amplitude=40; % Defines the maximum amplitude allowed in an epoch

channel=1;

channel_name='Pz';

resample=32; % Downsampling the signal to guarantee that the number of training
% samples is greater than the number of samples (avoid singular matrices)
% 
% std= '4';
% odd= '3';
% 
std= '33025';
odd= '33024';

% std= 'Stop';
% odd= 'Move';

ALLEEG=[];
% --- Processing ---

% Loads the EEGDATA to train the model:
% EEG = pop_loadset('filename', data_train ,'filepath',path);
EEG = pop_biosig('/arquivos/tcc/Results/olimex/05february2015/p300_audio_lays.gdf', 'blockepoch','off');

[Accuracy, Selectivity, Sensitivity, Specificity, W] = calibration(ALLEEG, EEG, low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, channel_name, resample);

data=load('/arquivos/tcc/Results/olimex/05february2015/online/data_rafael_p300_lays.txt');

targets=load('/arquivos/tcc/Results/olimex/05february2015/online/results_p300_audio_lays.txt');
targets=logical(targets(:,1));
targets(100,:)=[];
% 


time=[1:32]*(1/resample);



trials1=data(~targets,:);
trials1(any(isnan(trials1),2),:)=[];

trials2=data(targets,:);
trials2(any(isnan(trials2),2),:)=[];

odd_mean=mean(trials2);

std_mean=mean(trials1);

figure;
plot(time,std_mean);
hold on
plot(time,odd_mean,'r')

trials=[trials1;trials2];

targets=[zeros(length(trials1),1); ones(length(trials2),1)];

% Applies data to the classifier:
L = [ones(size(trials,1),1) trials] * W';

% Calculates the probability of each class:
P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

% Model accuracy estimation:
Predict=zeros(size(P,1),1);
TP=0;
TN=0;
FN=0;
FP=0;

%Calculate accuracy and sets the probability to -1 or 1
for i=1:size(P,1)
    if P(i,1)<P(i,2)
        Predict(i)=1; 
    else
        Predict(i)=0;
    end
    
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
end

Accuracy=100*(TP+TN)/(TP+TN+FP+FN)

Selectivity = 100*TP/(TP+FP)

Sensitivity = 100*TP/(TP+FN)

Specificity = 100*TN/(TN+FP)