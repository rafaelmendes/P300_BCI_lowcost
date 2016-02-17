% clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));
clear a;
% Saving names: to be implemented
%folder='20october2014';
%event_names='P300_1.txt';

SZ=get(0,'ScreenSize');


circle = imread('Figures/bola.jpeg');
square = imread('Figures/quadrado.jpeg');


circle = imresize(circle, [SZ(4) SZ(3)]);
square = imresize(square, [SZ(4) SZ(3)]);


% environment variables:
n_trials= 20;
n_repetitions= 1;

response_delay=0.7;
% View results

% run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);
% 
% run_writedataset('out_filename','/arquivos/tcc/Results/27october2014/mystream.set');
tic

pause(3)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

line=2;
last=0;
for j=1:n_trials
    
    for i=1:n_repetitions;

        y=rand(1);
        
        if or(y<0.7, and(y>=0.7, last==1))
            time_stim=toc; 
            fullscreen(square,1)
            stim_delay=toc;
           
            
            a{line,2}=('std');
            
            last=0;
            pause(0.8);

        %if and(y>=0.7, last==0) 
        else
            time_stim=toc; 
            fullscreen(circle,1)
            stim_delay=toc;
           
            
            a{line,2}=('odd');
            
            last=1;
            pause(0.3);
        end
        

        
        a{line,1}=num2str(stim_delay);
        line=line+1;  
        
        
    end
end

closescreen();

% onl_clear();
% % 
data=dataset({a 'latency','type'});

% export(data,'file','/arquivos/tcc/Results/27october2014/eventmarkers/P300_1.txt');
export(data,'file','/arquivos/tcc/teste.txt');


% % 
% pause(3);
% 
% EEG=pop_loadset('/arquivos/tcc/Results/27october2014/mystream.set');
% 
% 
% EEG=pop_importevent(EEG, ...
%     'event', '/arquivos/tcc/Results/27october2014/eventmarkers/P300_1.txt',...
%     'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);
% 
% pop_saveset(EEG);
% 
% pop_eegplot(EEG);
