clear a 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));

relax = imread('Figures/relax.jpg');
up = imread('Figures/up_arrow.jpg');
left = imread('Figures/left_arrow.jpg');
right = imread('Figures/right_arrow.jpg');
% View results

run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','mystream');
tic

pause(5)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

for j=2:2:10
    imshow(relax);
    figure(1);
    a{j,2}=('rest');
    a{j,1}=num2str(toc);
    
    pause(0.2);
    
    y=randi(3);
    if y==1
        imshow(up,[]);
        a{j+1,2}=('up');
        time=toc;
        pause(1)
        a{j+1,1}=num2str(time);
    end
    
    if y==2
        a{j+1,2}=('left'); 
        imshow(left,[]);
        time=toc;
        pause(1)
        a{j+1,1}=num2str(time);
    end
        
    if y==3
        a{j+1,2}=('right'); 
        imshow(right,[]);
        time=toc;
        pause(1)
        a{j+1,1}=num2str(time);
    end
    pause(0.4)
end

onl_clear()

data=dataset({a 'latency','type'});

export(data,'file','/arquivos/tcc/Results/03september2014/eventmarkers/P300.txt');

EEG=pop_loadset('/arquivos/tcc/Results/03september2014/mystream.set');


EEG=pop_importevent(EEG, ...
    'event', '/arquivos/tcc/Results/03september2014/eventmarkers/P300.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);
