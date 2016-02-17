clear all

data=load('/arquivos/tcc/Results/14january2015/online/data.txt');

target=load('/arquivos/tcc/Results/14january2015/online/results_p300_audio_rafael.txt');

if(size(data,1)<100)
    target(100,:)=[];
end
    

index_odd=find(target(:,1));

index_std=find(target(:,1)==0);

data_odd=zeros(1,64);
data_std=zeros(1,64);



for i=1:length(index_odd)
    data_odd=[data_odd; data(index_odd(i),:)];
end

for i=1:length(index_std)
    data_std=[data_std; data(index_std(i),:)];
end

data_odd_mean=mean(data_odd,1);

data_std_mean=mean(data_std,1);

t=[1:64]*1/64;

plot(t, data_std_mean, t, data_odd_mean, 'r')