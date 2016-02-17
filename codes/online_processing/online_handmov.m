% clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));

clear a;

% environment variables:
n_trials= 100;

t=zeros(n_trials,2);
target=0;

odd_audio=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/1000_100ms.wav');

epoch_start=1; % latency before the event for epoch extraction
epoch_end=2; % latency after the event for epoch extraction

max_amplitude=30; % Defines the maximum amplitude allowed in an epoch

channel=2;

channel_name='C3';

resample=32; % Downsampling the signal to guarantee that the number of training
% samples is greater than the number of samples (avoid singular matrices)

std='Stop';
odd='Move';

%% Filter specifications
low_cutoff=8; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=12; % band pass filter upper cutoff frequency (Hz)


filter_order = 3;                   
filter_cutoff = [2*low_cutoff/resample 2*upper_cutoff/resample]; % 1 to 12 Hz  

[b, a] = butter(filter_order,filter_cutoff); 

%% Calibration - Projection matrix calculation:
W=onl_calibration_handmov(low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, resample);
% W=zeros(1,65);

%% instantiate the library:
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1},1000,256);

% Receive data chunk
disp('Now receiving chunked data...');


FREQUENCY=48000;
CHANNELS=1; % MONO

% try
%     
InitializePsychSound(0);
pahandle = PsychPortAudio('Open', [], 1, [], FREQUENCY, CHANNELS, [], 0.010);

%% Trials:
[chunk,stamps] = inlet.pull_chunk();

try
    for j=1:n_trials
    
    if j==n_trials/2+1 % Plays stimulus in the middle of section
        PsychPortAudio('FillBuffer', pahandle, odd_audio');
        PsychPortAudio('Start', pahandle);
        target=1;
    end
    
    pause(1); % wait for 256 samples to buffer in
    
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    
    % Channel select
    ch=chunk(channel,:);
   
    % Decimation: from 256 Hz to 64 Hz
    ch=ch(1:256/resample:end);
    time=stamps(1:256/resample:end);

    %Data bandpass filtering 
    ch=filtfilt(b, a, ch);
    
    if max(ch)<max_amplitude
        %Data normalization
        ch=normal(ch);
        
        % Calculates the linear scores (projections):
        L = [1 ch] * W';

        % Calculates the bayes probabilities
        P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

        % Classification:     
        if P(1)<P(2)
            t(j,2)=1; 
        else
            t(j,2)=0;
        end
    else
        t(j,2)=0;
    end
    
    t(j,1)= target;
                
    end

catch exception
   PsychPortAudio('Close', pahandle);
display('Error!')
end

save('results_handmov_marina2.txt', 't', '-ascii');

PsychPortAudio('Close', pahandle);

