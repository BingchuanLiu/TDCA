function model = tdca_train(data0,time,freq,latency, filters,lag)
% lag: latency w.r.t. each dataset
% r_use: number of space subspace used for classification
n_band = 5;
rfs = 250;
[N,n_chan,n_cond,n_block] = size(data0);
data = data0(1:time+latency+lag,:,:,:);
for band = 1 : n_band
    for ii = 1:n_block
        for cond = 1:n_cond
            downsdata = data(:,:,cond,ii);
            bpdatah0(:,:,cond,ii,band) = bp40_FBm(downsdata,filters,band)';
        end
    end
end
bpdatah = [];% 45 x 50 x 40 x 5 x 5
for l = 1 : lag
    bpdatah1 = bpdatah0(:,latency+l:time+latency+l-1,:,:,:);
    bpdatah = cat(1,bpdatah,bpdatah1);
end

P = generate_projection_matrix(bpdatah, 250, freq);
for band = 1 : n_band
    for ii = 1:n_block
        for cond = 1:n_cond
            trial = bpdatah(:,:,cond,ii,band);
            P_cond = P{cond};
            bpdatahp(:,:,cond,ii,band) = [trial,(trial*P_cond')];
        end
    end
end

model.traindatah = squeeze(mean(bpdatahp,4));
for band = 1 : 5
    traindatah(:,:,:,band) = squeeze(mean(bpdatahp(:,:,:,:,band),4));
    trca_Xm = traindatah(:,:,:,band);% 9x50x40
    trca_Xm = trca_Xm - mean(trca_Xm,2);
    trca_Xma = mean(trca_Xm,3);% 9x50
    trca_Xmb = trca_Xm - trca_Xma;
    Xmc = squeeze(bpdatahp(:,:,:,:,band));% chan x time x cond x block x band
    Xmc = Xmc - mean(Xmc,2);
    Xmca = Xmc - mean(Xmc,4);
    Hb = trca_Xmb(:,:)/sqrt(n_cond);
    Hw = Xmca(:,:)/sqrt(n_block*n_cond);  
    Sw = Hw*Hw'+0.001*eye(size(Hw,1));
    Sb = Hb*Hb';
    [V,D] = eig(Sw\Sb);
    [~,index] = sort(diag(D),'descend');
    V = V(:,index);
    SFshf(:,:,band) = V;
end

model.SFsAllh = SFshf;
model.P = P;
end