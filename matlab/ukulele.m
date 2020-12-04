% Yinan Final Project
% main function
clear;clc;

% choose the function of the process
fprintf('Please choose function:\n');
fprintf('	1. Generate sample note\n');
fprintf('	2. Play MIDI file\n');
opt = input('Enter option number: ');
if isempty(opt)
    opt = 1;
end

% recorded body-to-air reponse
x = audioread('BR.wav');
% x = [1;0];

fs = 44100;         % sampling rate

% choose model
fprintf('\nPlease choose model type:\n');
fprintf('	1. Digital Waveguide\n');
fprintf('	2. Karplus-Strong\n');
model = input('Choose model type:');
if isempty(model)
    model = 2;
end

if opt == 1
%     velo_index = 1;
    Dur = 5;
    Dur = round(Dur*fs);
    fre = input('\nPlease enter the desired frequency: ');
    if isempty(fre)
        fre = 392;
    end
    if model == 1
        y = playDW(fs, fre, Dur, x, 1);
    elseif model ==2
        y = playDW(fs, fre, Dur, x, 1);
    end
    
elseif opt == 2
    midi = input('\nPlease enter midi filename;\nFormat''xxx.mid'':');
    y = playmidi(fs, midi, x, model);
end

fname = input('\nPlease enter the name of the file to be saved;\nFormat''xxx.wav'':');

% STFT spectrogram
% y = audioread('4th_real.wav');
% figure(2);
% spec(y, 0.09, fs);

% Scale Soundfile if necessary
if max(abs(y)) > 0.95
    y = y./max(abs(y)+0.1);
    disp('Scaled waveform');
end
audiowrite(fname, y, fs)
sound(y, fs);

