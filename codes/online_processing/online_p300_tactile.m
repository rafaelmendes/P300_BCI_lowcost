% clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));

clear a;

% environment variables:
n_trials= 100;
n_repetitions= 1;
terminator='CR';
timeout=20;
t=zeros(100,2);

epoch_start=0; % latency before the event for epoch extraction
epoch_end=1; % latency after the event for epoch extraction

max_amplitude=100; % Defines the maximum amplitude allowed in an epoch

channel=1;

last=0;
trials=100;

% W=zeros(1,65);
channel_name='Pz';

resample=32; % Downsampling the signal to guarantee that the number of training
% samples is greater than the number of samples (avoid singular matrices)

std='std';
odd='left';

%% Filter specifications
low_cutoff=0.5; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=10; % band pass filter upper cutoff frequency (Hz)


filter_order = 3;                   
filter_cutoff = [2*low_cutoff/resample 2*upper_cutoff/resample]; % 1 to 12 Hz  

[b, a] = butter(filter_order,filter_cutoff); 

%% Calibration - Projection matrix calculation:
W=onl_calibration_p300(low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, resample);

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

data=[];
%% Open serial port monitor:
ser=serial('/dev/ttyS101');
set(ser,'terminator', terminator, 'timeout', timeout, 'inputbuffersize', 50, 'BaudRate', 9600,'DataBits',8, 'StopBits',1);
fopen(ser);


%% Trials:
[chunk,stamps] = inlet.pull_chunk();

% try
    for j=1:n_trials
    
    pause(1); % wait for 256 samples to buffer in    
        
    y=fscanf(ser, '%d',4);
    
    if y>75
        t(i,1)=1;
    else
        t(i,1)=0;
    end
    
    
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    
    % Channel select
    ch=chunk(channel,:);
   
    % Decimation: from 256 Hz to 64 Hz
    ch=ch(1:256/resample:end);
    time=stamps(1:256/resample:end);

    %Data bandpass filtering 
    ch=filtfilt(b, a, ch);
    
%     if max(ch)<max_amplitude
        %Data normalization
        ch=normal(ch);

        % Calculates the linear scores (projections):
        L = [1 ch] * W';

        % Calculates the bayes probabilities
        P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

        % Classification:     
        if P(1)<P(2)
            t(i,2)=1; 
        else
            t(i,2)=0;
        end
        
%     else
%         t(i,2)=0;
%     end  

    
%     if(t(i,2)&&(turn))
%         t(i,1)=1;
%     else
%         t(i,1)=0;
%     end
%     data=[data; ch];
    i=i+1;
    
                
    end
    
    

% catch exception
    fclose(ser);
    delete(ser);
    clear ser;
%   freeserial;
% end

save('results_p300_tactile_3tgts_marina2.txt', 't', '-ascii');
save('data_p300_tactile_marina2.txt', 'data', '-ascii');
% fclose(ser);
% delete(ser);
% clear ser;
% freeserial;
