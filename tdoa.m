function[lag, theta] = tdoa(data_mic1, data_mic3)

lag0 = 18.24; %the maximum lag between mic1 and mic3

[r1,lags1] = xcorr(data_mic1,data_mic3);


% find the maximum and lags
k1 = find(lags1==-50); % find the index of lags=-50
k2 = find(lags1==50);  % find the index of lags=50
lagsx = lags1(k1:k2);  
rx = r1(k1:k2);
% stem(lagsx,rx);
% xlabel('lags');
% ylabel('Cross Correlation');
[M,I] = max(rx);  % find the maximum of correlation m and its index i 
lag = lagsx(:,I);   % find the lag corresponding to the maximm of correlation
if -18 <= lag <= 18
    theta = real(acosd(lag/lag0));
else
    theta = 0;
end
% fprintf('The lag between mic1 and mic3 is %d.\n',lag);
% fprintf('The estimate angle is %.2f.\n',theta);
