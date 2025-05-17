function [P, condY] = generate_projection_matrix(bpdatah, fs, freq)
condY = cca_reference5(bpdatah, fs, freq);
for cond = 1 : length(freq)
    Y = condY{cond};
    [Q,~] = qr(Y,0);
    P{cond} = Q*Q';
end
end