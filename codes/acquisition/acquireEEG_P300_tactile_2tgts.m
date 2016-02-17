% clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));

clear a; % Clears event info

% environment variables:
n_trials= 150;
n_repetitions= 1;
n=0;
m=0;
x=1;
b=0;
terminator='CR';
timeout=20;


pause(2)
% Start acquiring EEG:
run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);
run_writedataset('out_filename','/arquivos/tcc/Results/16dezember2014/mystream.set');
tic

% Open serial port monitor:
ser=serial('/dev/ttyS101');
set(ser,'terminator', terminator, 'timeout', timeout, 'inputbuffersize', 50, 'BaudRate', 9600,'DataBits',8, 'StopBits',1);
fopen(ser);

pause(3)
a{1,2}=('Stim_begin');
a{1,1}=num2str(toc);

line=2; % First line to be marked in txt file

try
    for j=1:n_trials

        y=fscanf(ser, '%d',4);
        time_stim=toc;
        if (y<=75)
            a{line,2}=('right'); % Black motor
            
        else 
            a{line,2}=('left'); % Yellow motor 
        end
        
        a{line,1}=num2str(time_stim);
        line=line+1;  
        
        pause(1);
    end

catch exception % Closing serial port in case of error or interruption
    display('Error (aborted), closing serial port.')
    fclose(ser);
    delete(ser);
    clear ser;
    %freeserial;
end

% Closing serial port anyway
display('End of experiment.')
fclose(ser);
delete(ser);
clear ser;

% Exporting txt file with events info
onl_clear();
% 
data=dataset({a 'latency','type'});

export(data,'file','/arquivos/tcc/Results/05january2015/rafael/p300_tactile/tactile3.txt');
% 
pause(3);

% Importing events to EEG dataset
EEG=pop_loadset('/arquivos/tcc/Results/16dezember2014/mystream.set');


EEG=pop_importevent(EEG, ...
    'event', '/arquivos/tcc/Results/05january2015/rafael/p300_tactile/tactile3.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);

