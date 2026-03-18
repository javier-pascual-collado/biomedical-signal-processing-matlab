%% ECG SIGNAL ANALYSIS – POWER SPECTRAL DENSITY
% Analysis of ECG signal using autocorrelation-based PSD estimation
% with Blackman window, and comparison with Welch's method.
% Author: Javier Pascual Collado
% Dataset: ECGcorto.mat

%% 1. LOAD AND VISUALIZE ECG SIGNAL
load ECGcorto.mat

fs   = 512; % Sampling frequency (Hz)
time = linspace(0, 11, length(ECGcorto));

figure();
plot(time, ECGcorto);
xlabel('Time (s)');
ylabel('ECG (V)');
title('ECG Signal');


%% 2. PSD ESTIMATION VIA AUTOCORRELATION + BLACKMAN WINDOW
M          = floor(length(ECGcorto) / 5);
ECG_corr   = xcorr(ECGcorto, M, 'unbiased');
w          = blackman((2*M) + 1);
ECG_w      = w .* ECG_corr;
PSD_1      = fft(ECG_w);
freq_1     = (0:length(PSD_1)-1) * (fs / length(PSD_1));

% Centered (two-sided) spectrum
PSD_2  = fftshift(PSD_1);
freq_2 = ((-length(PSD_2)/2):(length(PSD_2)/2)-1) * (fs / length(PSD_2));

figure();
subplot(3,1,1);
plot(freq_1, abs(PSD_1));
xlabel('Frequency (Hz)'); ylabel('PSD (V^2/Hz)');
title('One-sided PSD (Autocorrelation + Blackman)');

subplot(3,1,2);
plot(freq_2, abs(PSD_2));
xlabel('Frequency (Hz)'); ylabel('PSD (V^2/Hz)');
title('Two-sided PSD');

subplot(3,1,3);
plot(freq_1, abs(PSD_2));
xlim([0, 10]);
xlabel('Frequency (Hz)'); ylabel('PSD (V^2/Hz)');
title('PSD – Low Frequency Range (0–10 Hz)');


%% 3. PSD ESTIMATION VIA WELCH'S METHOD
[PSD_welch, freq_welch] = pwelch(ECGcorto, hann(1024), [], 2^11, fs, 'onesided');

figure();
subplot(2,1,1);
plot(freq_welch, PSD_welch);
xlabel('Frequency (Hz)'); ylabel('PSD (V^2/Hz)');
title('PSD – Welch Method');

subplot(2,1,2);
plot(freq_1, abs(PSD_2));
xlim([0, 10]);
xlabel('Frequency (Hz)'); ylabel('PSD (V^2/Hz)');
title('PSD – Autocorrelation Method (0–10 Hz)');
