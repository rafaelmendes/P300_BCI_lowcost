% environment variables:
% Specifications:
% 

standard_audio=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/2000_100ms.wav');
odd_audio=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/1000_100ms.wav');

max_amplitude=15; % Defines the maximum amplitude allowed in an epoch

last=0;
n_trials=100;

t=zeros(n_trials,4);

target=0;

channel_name='Pz';

resample=64; % Downsampling the signal to guarantee that the number of training
% samples is greater than the number of samples (avoid singular matrices)

std='33025';
odd='33024';

vermelho = imread('../acquisition/Figures/vermelho.jpg');
verde = imread('../acquisition/Figures/verde.jpg');

[w, screenRect]=Screen('OpenWindow', 0, 0,[],32,2);

Index_verde=Screen('MakeTexture', w, verde);
Index_vermelho=Screen('MakeTexture', w, vermelho); 

%% Filter specifications and calibration for p300:
low_cutoff=0.5; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=10; % band pass filter upper cutoff frequency (Hz)

filter_order = 3;                   
filter_cutoff = [2*low_cutoff/resample 2*upper_cutoff/resample]; % 1 to 12 Hz  

[b_p300, a_p300] = butter(filter_order,filter_cutoff); 

channel=1;
epoch_start=0; % latency before the event for epoch extraction
epoch_end=1; % latency after the event for epoch extraction

W_p300=onl_calibration_p300(low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, resample);
% W_p300=1:65;

%% Filter specifications and calibration for handmov:
low_cutoff=8; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=12; % band pass filter upper cutoff frequency (Hz)

filter_order = 3;                   
filter_cutoff = [2*low_cutoff/resample 2*upper_cutoff/resample]; % 1 to 12 Hz  

[b_handmov, a_handmov] = butter(filter_order,filter_cutoff);

channel=2;
epoch_start=1.5; % latency before the event for epoch extraction
epoch_end=2.5; % latency after the event for epoch extraction

W_handmov=onl_calibration_p300(low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, resample);

% W_handmov=1:65;
pause(2)
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
i=1;
disp('Now receiving chunked data...');

FREQUENCY=48000;
CHANNELS=1; % MONO

% try
%     
InitializePsychSound(0);
pahandle = PsychPortAudio('Open', [], 1, [], FREQUENCY, CHANNELS, [], 0.010);


[chunk,stamps] = inlet.pull_chunk();
while i<n_trials


    y=rand(1);

    if or(y<0.75, and(y>=0.75, last==1))

        PsychPortAudio('FillBuffer', pahandle,standard_audio');
        PsychPortAudio('Start', pahandle);
        t(i,1)=0;
        last=0;

    else

        PsychPortAudio('FillBuffer', pahandle,odd_audio');
        PsychPortAudio('Start', pahandle);        
        t(i,1)=1;                  
        last=1;

    end
    
    if i==n_trials/2+1 % Plays stimulus in the middle of section
        Screen('DrawTexture',w, Index_vermelho); % now visible on screen
        Screen(w, 'Flip');
        target=1;
    end
    
    pause(1); % wait for 256 samples buffer in
    
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    
    % Decimation: from 256 Hz to 64 Hz
    chunk=chunk(:,1:256/resample:end);
    time=stamps(1:256/resample:end);
       
    %% P300 detection:
    
    % Channel select for p300
    ch_p300=chunk(1,:);
   
    %Data bandpass filtering 
    ch_p300=filtfilt(b_p300, a_p300, ch_p300);
 
    if max(ch_p300)<max_amplitude
        %Data normalization
        ch_p300=normal(ch_p300);

        % Calculates the linear scores (projections):
        L = [1 ch_p300] * W_p300';

        % Calculates the bayes probabilities
        P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

        % Classification:     
        if P(1)<P(2)
            t(i,2)=1; 
        else
            t(i,2)=0;
        end
    else
        t(i,2)=0; % If epoch contains abnormal value, it is not an event
    end  
    
    %% Handmov ERD detection:
    
    % Channel select for ERD:
    ch_handmov=chunk(2,:);
   
    %Data bandpass filtering 
    ch_handmov=filtfilt(b_handmov, a_handmov, ch_handmov);
 
    if max(ch_handmov)<max_amplitude
        %Data normalization
        ch_handmov=normal(ch_handmov);

        % Calculates the linear scores (projections):
        L = [1 ch_handmov] * W_handmov';

        % Calculates the bayes probabilities
        P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

        % Classification:     
        if P(1)<P(2)
            t(i,4)=1; 
        else
            t(i,4)=0;
        end
    else
        t(i,4)=0; % If epoch contains abnormal value, it is not an event
        
    end  
    
    t(i,3)=target;
    
    i=i+1;
end

sca;

% catch
    PsychPortAudio('Close', pahandle);
%     Screen('Closeall') 
%     Screen(w,'Close')
%     Screen('MATLABToFront')

% end

save('results_handmovp300_rafael2.txt', 't', '-ascii');
