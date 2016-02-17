Input = [randn(10,2); randn(15,2) + 1.5];  Target = [zeros(10,1); ones(15,1)];

[Z, W_fda]=FDA(Input',Target);


W_lda=LDA(Input,Target);
% L = W_fda' * [ones(25,1) Input];

[W_ftrain,t,fp]=fisher_training(Input,Target);

[l,precision,recall,accuracy,F1]=fisher_testing(Input, W_ftrain,t, Target);