function result = tdca_test(data,freq,targetNum,model,time,latency,filters,lag,r_use)
% lag: latency w.r.t. each dataset, in accordance with tdca_train.m
% r_use: number of space subspace used for classification
data = data(1:time+latency,:);
for band = 1:5
    bpdata(:,:,band) = bp40_FBm(data,filters,band)';
end
testdatah = [];
for l = 1 : lag
    bpdatah1 = bpdata(:,latency+l:time+latency,:,:,:);
    if size(bpdatah1,2) < time
        pad = zeros(size(bpdatah1,1),time-size(bpdatah1,2),size(bpdatah1,3));
        bpdatah1 = cat(2,bpdatah1,pad);
    end    
    testdatah = cat(1,testdatah,bpdatah1);
end
weights=[1:10].^(-1.25)+0.25;
w = 2;
SFsIndex=[1:targetNum];

P = model.P;

for cond = 1:targetNum
    P_cond = P{cond};
    for band = 1 : 5
        Xh = testdatah(:,:,band)';
        Xhp = [Xh;(P_cond*Xh)];
        Y2h = (squeeze(model.traindatah(:,:,cond,band)))';
        U1 = Xhp * [model.SFsAllh(:,1:r_use,band)];
        V1 = Y2h * [model.SFsAllh(:,1:r_use,band)];
        rr(band,cond)= corr2_new(U1,V1); 
    end
end

rrr = weights(1:5)*(sign(rr(1:5,:)).*abs(rr(1:5,:)).^w);

result = find(rrr==max(rrr));

end