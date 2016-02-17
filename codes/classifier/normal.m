function [M_normal]=normal(M)
%normal normalizes the matrix M by its maximum absolute value. The result
%       a scaled M matrix ranging from -1 to 1
%
%input: M - Matrix to be normalized
%output: M_normal - Normalized M matrix


% M_max=max(max(abs(M)));
% 
% M_normal=M/M_max;

M_max=max(M,[],2); % max value of each row of M

% normalization by trial:
    for i=1:size(M,1)
        M_normal(i,:)=M(i,:)/M_max(i);
    end
end