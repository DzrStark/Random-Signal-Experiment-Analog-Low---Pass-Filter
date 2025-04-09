clear; clc; close all;
% 参数设置
fs = 1e6; % 采样频率，单位：赫兹 (1MHz)
f0 = 10e3; % 方波频率，单位：赫兹 (10kHz)
t = (0:1/fs:1-1/fs)'; % 时间向量
fc =4e3;; % 截止频率 (Hz)
% 生成频率为10kHz的方波信号
input_signal = square(2 * pi * f0 * t);
% RC低通滤波器传递函数
[b, a] = butter(1,fc/(fs/2),'low');
% 通过RC低通滤波器
output_signal = filter(b, a, input_signal);
% 计算并绘制输入和输出信号的时域波形
figure;
subplot(2, 1, 1);
plot(t(1:1000), input_signal(1:1000)); % 显示前1000个样本
title('输入信号的时域波形 (10kHz 方波)');
xlabel('时间 (秒)');
ylabel('幅度');
grid on;
subplot(2, 1, 2);
plot(t(1:1000), output_signal(1:1000)); % 显示前1000个样本
title('输出信号的时域波形');
xlabel('时间 (秒)');
ylabel('幅度');
grid on;
% 计算输入和输出信号的频谱
input_spectrum = fft(input_signal);
output_spectrum = fft(output_signal);
f = (0:length(input_signal)-1)*(fs/length(input_signal)); % 频率向量
% 绘制输入和输出信号的频谱
figure;
subplot(2, 1, 1);
plot(f, abs(input_spectrum));
title('输入信号的频谱');
xlabel('频率 (Hz)');
ylabel('幅度');
xlim([0 100e3]);
grid on;
subplot(2, 1, 2);
plot(f, abs(output_spectrum));
title('输出信号的频谱');
xlabel('频率 (Hz)');
ylabel('幅度');
xlim([0 100e3]);
grid on;
% 计算输入和输出信号的自相关函数
[input_autocorr, lags] = xcorr(input_signal, 'biased');
[output_autocorr, ~] = xcorr(output_signal, 'biased');
% 绘制输入和输出信号的自相关函数
figure;
subplot(2, 1, 1);
plot(lags/fs, input_autocorr);
title('输入信号的自相关函数');
xlabel('延迟 (秒)');
ylabel('自相关');
grid on;
subplot(2, 1, 2);
plot(lags/fs, output_autocorr);
title('输出信号的自相关函数');
xlabel('延迟 (秒)');
ylabel('自相关');
grid on;
% 计算输入和输出信号的功率谱密度
[pxx_input, f_input] = pwelch(input_signal, [], [], [], fs);
[pxx_output, f_output] = pwelch(output_signal, [], [], [], fs);
% 绘制输入和输出信号的功率谱密度
figure;
subplot(2, 1, 1);
plot(f_input, 10*log10(pxx_input));
title('输入信号的功率谱密度');
xlabel('频率 (Hz)');
ylabel('功率谱密度 (dB/Hz)');
grid on;
subplot(2, 1, 2);
plot(f_output, 10*log10(pxx_output));
title('输出信号的功率谱密度');
xlabel('频率 (Hz)');
ylabel('功率谱密度 (dB/Hz)');
grid on;