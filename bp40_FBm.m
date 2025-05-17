function  y=bp40_FBm(x,filters,nFB)
B = filters.B{nFB};
A = filters.A{nFB};
y = filtfilt(B,A,x);
end