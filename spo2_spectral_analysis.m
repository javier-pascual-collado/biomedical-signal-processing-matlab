%% SpO2 SIGNAL SPECTRAL ANALYSIS
% Spectral analysis of overnight SpO2 signal using Welch's PSD method.
% Spectral features extracted: median frequency, spectral entropy,
% and respiratory band power (0.014–0.033 Hz).
% Author: Javier Pascual Collado
% Dataset: SpO2.mat

%% 1. LOAD AND VISUALIZE SpO2 SIGNAL
load SpO2.mat
signal = SpO2.SpO2;
fs     = 1; % Sampling frequency (Hz)

% Display full overnight recording
t = (0:length(signal)-1) / 3600; % Convert to hours
figure();
plot(t, signal);
xlabel('Time (hours)'); ylabel('SpO2 (%)');
title('Overnight SpO2 Recording');


%% 2. POWER SPECTRAL DENSITY – WELCH METHOD
[PSD, f] = pwelch(signal - mean(signal), hann(512), [], 1024, fs, 'onesided');

figure();
plot(f, PSD);
xlabel('Frequency (Hz)'); ylabel('PSD (%^2/Hz)');
title('SpO2 Power Spectral Density');


%% 3. SPECTROGRAM
figure();
spectrogram(signal - mean(signal), hann(512), [], 1024, fs, 'yaxis');
ylim([0, 100]);
clim([-30, 30]);
title('SpO2 Spectrogram');


%% 4. SPECTRAL FEATURES

% Median frequency (50% of total spectral power)
PSD_n = PSD / sum(PSD); % Normalized PSD
i  = 0;
Pe = 0;
while Pe <= 0.5
    i  = i + 1;
    Pe = Pe + PSD_n(i);
end
FM = f(i);
fprintf('Median Frequency: %.4f Hz\n', FM);

% Spectral entropy (measure of spectral complexity)
SpecEn = -sum(PSD_n .* log(PSD_n)) / log(length(PSD_n));
fprintf('Spectral Entropy: %.4f\n', SpecEn);

% Respiratory band power (0.014–0.033 Hz)
i1   = find(f <= 0.014, 1, 'last');
i2   = find(f >= 0.033, 1, 'first');
Pbw  = sum(PSD_n(i1:i2));
Pmax = max(PSD_n(i1:i2));
fprintf('Respiratory Band Power: %.4f\n', Pbw);
fprintf('Peak Power in Band:     %.4f\n', Pmax);
