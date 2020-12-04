function spec(y, Dur, fs)
% STFT/Draw Spectrogram

N = round(Dur*fs);
y = y(1:N);
win_sz = 256;
win = hamming(win_sz);      % hamming window
nfft = win_sz;
noverlap = win_sz - 1;
[S, F, T, P] = spectrogram(y, win, noverlap, nfft, fs);
mesh(T,F,10*log10(P)); 
grid on; 
axis tight;
ylim([0 22000]);
zlim([-160 -30]);
colormap gray
colorbar
view(120, 20);              % observation angle
set(gca,'CLim',[-160 -40])
xlabel('Time (secs)')
ylabel('Frequency (Hz)')
% title('Short Time Fourier Transform')
end