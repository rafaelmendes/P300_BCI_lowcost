clear a 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));
% environment variables:
n_trials= 10;
monitor=1;
probabilidade_verde=0.2;
ps_inter_est=2;
% set(0,'DefaultFigurePosition', [-1000 378 560 420]);

SZ=get(0,'ScreenSize'); % Gets the size of the current display
SZ=[1 1 1366 768];

vermelho = imread('Figures/vermelho.jpg');
verde = imread('Figures/verde.jpg');
fundo = imread('Figures/fundo.jpg');
% cruz = imread('Figures/cruz.jpg');


vermelho = imresize(vermelho, [SZ(4) SZ(3)]); % Rescaling pictures to fit fullscreen
verde = imresize(verde, [SZ(4) SZ(3)]);
fundo = imresize(fundo, [SZ(4) SZ(3)]);
cruz = imresize(cruz, [SZ(4) SZ(3)]);

% fullscreen(cruz, monitor);
fullscreen(vermelho, monitor);
fullscreen(verde, monitor);
fullscreen(fundo, monitor);

run_readlsl('property', 'name', 'value', 'Mitsar EEG 202 - A', 'update_freq', 20);

run_writedataset('out_filename','mystream.set');
tic

pause(3)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

line=2;


for j=1:n_trials
%     fullscreen(cruz, monitor);
%     a{line,1}=num2str(toc);
%     a{line,2}=('cruz');    
%     line=line+1;
%     pause(0.5);
    

    
    fullscreen(fundo,monitor);
    pause(ps_inter_est);
    
    y=rand(1);
    
    if y<probabilidade_verde
        fullscreen(verde,monitor);
        a{line,1}=num2str(toc);
        a{line,2}=('verde');

    else
        a{line,2}=('vermelho');
        a{line,1}=num2str(toc);        
        fullscreen(vermelho,monitor);
    end
    
    line=line+1;
    
    % Detecta se o usuario apertou o espaco no teclado
    key=getkeywait(0.5);
    time_but=toc;
    
    if key == 32
                
        a{line,2}=('botao');
        a{line,1}=num2str(time_but);
        line=line+1;
               
    end   

end
% 
onl_clear()

fim=toc;

closescreen();

data=dataset({a 'latency','type'});

export(data,'file','C:\Users\LEC\Documents\experimento_hiago\gonogo.txt');

pause(3)

EEG=pop_loadset('mystream.set');

EEG=pop_importevent(EEG, ...
    'event', 'C:\Users\LEC\Documents\experimento_hiago\gonogo.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);
