clear all
close all


resample=64;

%% Filter specifications
low_cutoff=1; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=12; % band pass filter upper cutoff frequency (Hz)


filter_order = 3;                   
filter_cutoff = [2*low_cutoff/resample 2*upper_cutoff/resample]; % 1 to 12 Hz  

[b, a] = butter(filter_order,filter_cutoff); 

[H,w]=freqz(b,a,1000);

plot(resample*w/(2*pi),abs(H));
