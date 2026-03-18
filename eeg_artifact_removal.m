%% EEG ARTIFACT DETECTION AND REMOVAL
% Analysis of EEG signals with 5 different artifact types.
% Artifacts are identified in the time and frequency domains.
% Removal strategies: Notch filter (power line noise) and bandpass filter.
% Author: Javier Pascual Collado
% Dataset: Apartado3-2_EEG.mat, PBFHW_1-40_fs200.mat

%% LOAD DATA
load Apartado3-2_EEG.mat
load PBFHW_1-40_fs200.mat

fs = 200; % Sampling frequency (Hz)


%% ARTIFACT 1 – Power line noise at 50 Hz (Channel O1, index 3)
time      = linspace(0, length(artefacto1)/fs, length(artefacto1));
frequency = linspace(-fs/2, fs/2, length(artefacto1));
S_signal  = (1/length(artefacto1)) * fftshift(fft(artefacto1(:,3)));

figure();
subplot(2,1,1); plot(time, artefacto1(:,3));
xlabel('Time (s)'); ylabel('Amplitude (uV)'); title('Artifact 1 – Time Domain');
subplot(2,1,2); plot(frequency, abs(S_signal)); xlim([0 fs/2]);
xlabel('Frequency (Hz)'); ylabel('Amplitude'); title('Artifact 1 – Frequency Domain');

% Removal: IIR Notch filter at 50 Hz (European power line frequency)
wo = 50/(fs/2);
bw = wo/100;
[b, a] = iirnotch(wo, bw);
artefacto1_filtered = filtfilt(b, a, artefacto1(:,3));

figure();
plot(time, artefacto1(:,3), 'b-', time, artefacto1_filtered(:), 'r-');
legend('Original', 'Filtered'); title('Artifact 1 – Notch Filter Applied');

S_filtered = (1/length(artefacto1)) * fftshift(fft(artefacto1_filtered(:)));
figure();
plot(frequency, abs(S_signal), 'b-', frequency, abs(S_filtered(:)), 'r-');
legend('Original', 'Filtered'); title('Artifact 1 – Frequency Comparison');


%% ARTIFACT 2 – Eye blink (Channel Fp1, index 11)
% Eye blinks are non-periodic — cannot be removed with a frequency filter
time      = linspace(0, length(artefacto2)/fs, length(artefacto2));
frequency = linspace(-fs/2, fs/2, length(artefacto2));
S_signal  = (1/length(artefacto2)) * fftshift(fft(artefacto2(:,11)));

figure();
subplot(2,1,1); plot(time, artefacto2(:,11));
xlabel('Time (s)'); title('Artifact 2 – Eye Blink (no fixed frequency)');
subplot(2,1,2); plot(frequency, abs(S_signal)); xlim([0 fs/2]);
xlabel('Frequency (Hz)'); title('Artifact 2 – Frequency Domain');


%% ARTIFACT 3 – Cardiac activity overlapping EEG (Channel P4, index 14)
% Overlaps with EEG band — frequency filtering not applicable
time      = linspace(0, length(artefacto3)/fs, length(artefacto3));
frequency = linspace(-fs/2, fs/2, length(artefacto3));
S_signal  = (1/length(artefacto3)) * fftshift(fft(artefacto3(:,14)));

figure();
subplot(2,1,1); plot(time, artefacto3(:,14));
xlabel('Time (s)'); title('Artifact 3 – Cardiac Overlap');
subplot(2,1,2); plot(frequency, abs(S_signal)); xlim([0 fs/2]);
xlabel('Frequency (Hz)'); title('Artifact 3 – Frequency Domain');


%% ARTIFACT 4 – Loose electrode (Channel T5, index 18)
% Disconnected electrode — no meaningful signal present
time      = linspace(0, length(artefacto4)/fs, length(artefacto4));
frequency = linspace(-fs/2, fs/2, length(artefacto4));
S_signal  = (1/length(artefacto4)) * fftshift(fft(artefacto4(:,18)));

figure();
subplot(2,1,1); plot(time, artefacto4(:,18));
xlabel('Time (s)'); title('Artifact 4 – Loose Electrode');
subplot(2,1,2); plot(frequency, abs(S_signal)); xlim([0 fs/2]);
xlabel('Frequency (Hz)'); title('Artifact 4 – Frequency Domain');


%% ARTIFACT 5 – High-frequency noise (Channel Fp1, index 11)
% Removal: Bandpass filter 1–40 Hz
time      = linspace(0, length(artefacto5)/fs, length(artefacto5));
frequency = linspace(-fs/2, fs/2, length(artefacto5));
S_signal  = (1/length(artefacto5)) * fftshift(fft(artefacto5(:,11)));

figure();
subplot(2,1,1); plot(time, artefacto5(:,11));
xlabel('Time (s)'); title('Artifact 5 – High-frequency Noise');
subplot(2,1,2); plot(frequency, abs(S_signal)); xlim([0 fs/2]);
xlabel('Frequency (Hz)'); title('Artifact 5 – Frequency Domain');

% Apply bandpass filter (1–40 Hz)
artefacto5_filtered = filtfilt(Num, Den, artefacto5(:,11));

figure();
plot(time, artefacto5(:,11), 'b-', time, artefacto5_filtered(:), 'r-');
legend('Original', 'Filtered'); title('Artifact 5 – Bandpass Filter Applied (1–40 Hz)');

S_filtered = (1/length(artefacto5)) * fftshift(fft(artefacto5_filtered(:)));
figure();
plot(frequency, abs(S_signal), 'b-', frequency, abs(S_filtered(:)), 'r-');
legend('Original', 'Filtered'); title('Artifact 5 – Frequency Comparison');
