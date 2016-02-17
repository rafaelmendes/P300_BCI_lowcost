clear all
close all

t=load('/arquivos/tcc/Results/04february2015/online/results_p300_audio_rafael2.txt');
data=load('/arquivos/tcc/Results/04february2015/online/data_rafael_p300_audio2.txt');

t=logical(t);

i=t(:,1);
iinv=~i;

iinv(end,:)=[];

odd=data(i,:);
std=data(iinv,:);

tempo=[1:32]*(1/32);

plot(tempo, mean(odd), tempo, mean(std), 'r')
