function y=lowp(x,f1,f3,rp,rs,fs)
% lowpass filter
% 
% Attention: 
% The cut-off frequency of passband or stopband should not exceed half of the sampling rate
% 
%
% x:input
% f1��Passband cutoff frequency
% f3��Stopband cutoff frequency
% rp��Sideband attenuation dB
% rs��Cut-off attenuation DB
% fS��sample rate of the input

wp = f1/(0.5*fs);
ws = f3/(0.5*fs);

% Chebyshev filter
[n,wn]=cheb1ord(wp,ws,rp,rs);
[bz1,az1]=cheby1(n,rp,wp);


% plot curve
% figure(2);
% [h,w]=freqz(bz1,az1,256,fs);
% h=20*log10(abs(h));
% figure;plot(w,h);
% title('Pass band curve of the designed filter');
% grid on;

y=filter(bz1,az1,x);    % output
end