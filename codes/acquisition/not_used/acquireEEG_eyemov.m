 clear a 
% addpath(genpath('/tcc/software/BCILAB-Program'));

relax = imread('Figures/relax.jpg');
left = imread('Figures/left.jpg');
right = imread('Figures/right.jpg');
dots = imread('Figures/pontos.jpg');
% View results

run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','mystream');
tic

pause(5)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

for j=2:2:20
    imshow(relax);
    pause(2.5);
    a{j,2}=('Rest');
    a{j,1}=num2str(toc);
    pause(2.5);
    
	imshow(dots); 
    pause(0.5);
    
    y=randi(2);
    if y==1
        imshow(left,[]);
        a{j+1,2}=('Instruct_left');
        time=toc;
        pause(1)
        a{j+1,1}=num2str(time);
    end
    
    if y==2
        a{j+1,2}=('Instruct_right'); 
        imshow(right,[]);
        time=toc;
        pause(1)
        a{j+1,1}=num2str(time);
    end
    pause(2)
end

onl_clear()

data=dataset({a 'latency','type'});

export(data,'file','/tcc/Results/August25/eventmarkers/eyemov.txt');

EEG=pop_loadset('/tcc/Results/August25/mystream.set');


EEG=pop_importevent(EEG, ...
    'event', '/tcc/Results/August25/eventmarkers/eyemov.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);
