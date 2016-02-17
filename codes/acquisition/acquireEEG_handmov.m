clear a 
addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));
% environment variables:
n_trials= 50;
Screen('Preference', 'SkipSyncTests', 1)

try
% SZ=get(0,'ScreenSize'); % Gets the size of the current display
SZ=[1 1 1366 768];

circle = imread('Figures/bola.jpeg');
task = imread('Figures/quadrado.jpeg');
stop = imread('Figures/stop.jpeg');
hand = imread('Figures/hand.jpeg');
white = imread('Figures/branco.jpeg');

[w, screenRect]=Screen('OpenWindow', 0, 0,[],32,2);

Index_circle=Screen('MakeTexture', w, circle);
Index_task=Screen('MakeTexture', w, task);   
Index_stop=Screen('MakeTexture', w, stop);   
Index_hand=Screen('MakeTexture', w, hand); 
Index_white=Screen('MakeTexture', w, white); 

run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','mystream');
tic

pause(3)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

line=2;


for j=1:n_trials

    Screen('DrawTexture',w, Index_circle); % now visible on screen
    Screen(w, 'Flip');
    a{line,1}=num2str(toc);
    a{line,2}=('Rest');    
    line=line+1;
    pause(2);
    
    y=rand(1);
    if y<0.5

        Screen('DrawTexture',w, Index_stop); % now visible on screen
        Screen(w, 'Flip');
        a{line,1}=num2str(toc);
        a{line,2}=('Stop');

    else
        
        Screen('DrawTexture',w, Index_hand); % now visible on screen
        Screen(w, 'Flip');
        a{line,2}=('Move');
        a{line,1}=num2str(toc);        
    end
    
    line=line+1;
    pause(1);
    

    Screen('DrawTexture',w, Index_task); % now visible on screen
    Screen(w, 'Flip');
    pause(3);
end

catch
    closescreen();
    sca;
end
onl_clear()

closescreen();
sca;

data=dataset({a 'latency','type'});

export(data,'file','/arquivos/tcc/Results/olimex/17february2015/handmov_marina.txt');

EEG=pop_loadset('mystream.set');

EEG=pop_importevent(EEG, ...
    'event', '/arquivos/tcc/Results/olimex/17february2015/handmov_marina.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);


