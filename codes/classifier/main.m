close all
clear all
% Specifications:

low_cutoff=0.5; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=10; % band pass filter upper cutoff frequency (Hz)

epoch_start=0; % latency before the event for epoch extraction
epoch_end=1; % latency after the event for epoch extraction

max_amplitude=50; % Defines the maximum amplitude allowed in an epoch

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

path='/arquivos/tcc/Results/olimex/05february2015';
data_train='p300_audio_val.set';
data_val='p300_audio_train.set';

ALLEEG=[];
% --- Processing ---

% Loads the EEGDATA to train the model:
EEG = pop_loadset('filename', data_train ,'filepath',path);
% EEG = pop_biosig('/arquivos/tcc/Results/01february2015/p300_audio_luiz.gdf', 'blockepoch','off');

[Accuracy, Selectivity, Sensitivity, Specificity, W] = calibration(ALLEEG, EEG, low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, channel_name, resample);

% Loads the EEGDATA to crossvalidate the model:
% epoch_start=0.4; % latency before the event for epoch extraction
% epoch_end=1.4; % latency after the event for epoch extraction

% 
% std= '2';
% odd= '1';

EEG = pop_loadset('filename', data_val ,'filepath',path);
% EEG = pop_biosig('/arquivos/tcc/Results/05january2015/lays/train_p300audio_lays3.gdf', 'blockepoch','off');


[Accuracy_cv, Selectivity_cv, Sensitivity_cv, Specificity_cv] = validate(ALLEEG, EEG, low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, channel_name, resample, W);

% Accuracy_cv = Accuracy;
% Selectivity_cv = Selectivity;
% Sensitivity_cv = Sensitivity;
% Specificity_cv = Specificity;

disp_table(Accuracy, Selectivity, Sensitivity, Specificity, ... 
    Accuracy_cv, Selectivity_cv, Sensitivity_cv, Specificity_cv);