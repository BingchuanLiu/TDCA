function [condY] = cca_reference5(data, fs, freq)
%% CCA reference signal
N = size(data,2);
n = [1: N]/fs;
for j = 1:length(freq)
    s1 = sin(2*pi*freq(j)*n);
    s2 = cos(2*pi*freq(j)*n);
    s3 = sin(2*pi*2*freq(j)*n);
    s4 = cos(2*pi*2*freq(j)*n);
    s5 = sin(2*pi*3*freq(j)*n);
    s6 = cos(2*pi*3*freq(j)*n);
    s7 = sin(2*pi*4*freq(j)*n);
    s8 = cos(2*pi*4*freq(j)*n);
    s9 = sin(2*pi*5*freq(j)*n);
    s10 = cos(2*pi*5*freq(j)*n);
    condY{j} = cat(2,s1',s2',s3',s4',s5',s6',s7',s8',s9',s10');
    condY{j}= condY{j} - repmat(mean(condY{j},1), N, 1);%??????§Ö???
end
end