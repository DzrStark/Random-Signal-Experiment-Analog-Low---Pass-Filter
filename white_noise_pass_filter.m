clear; clc; close all;
% 参数设置  
Fs = 100e4;           % 采样频率 (Hz)  
T = 1/Fs;             % 采样周期 (s)  
t_sim = 0:T:1;        % 仿真时间向量，从0到1秒  
N = length(t_sim);    % 仿真点数  

% 高斯白噪声参数  
mu = 0;               % 均值  
sigma = 1;            % 标准差  

% 滤波器参数  
Fc = 4e3;             % 截止频率 4kHz  
omega0 = 2*pi*Fc;     % 滤波器自然频率，对应截止频率为4kHz  
% 对于RC低通滤波器，omega0 = 1/(RC)，这里采用已知的omega0计算公式

% 生成高斯白噪声信号  
u = mu + sigma*randn(1, N);  

% 设计滤波器  
num = [omega0^2];  
den = [1 3*omega0 omega0^2];  
H = tf(num, den);  

% 计算滤波器输出响应  
[y, t_out] = lsim(H, u, t_sim);  

% 计算输入输出信号的统计特性  
mean_u = mean(u);  
mean_y = mean(y);  
var_u = var(u);  
var_y = var(y);  
rms_u = rms(u); % 均方根值，也等于标准差（对于零均值信号）  
rms_y = rms(y);  

% 显示统计特性  
fprintf('输入信号均值: %f\n', mean_u);  
fprintf('输出信号均值: %f\n', mean_y);  
fprintf('输入信号方差: %f\n', var_u);  
fprintf('输出信号方差: %f\n', var_y);  
fprintf('输入信号均方根值: %f\n', rms_u);  
fprintf('输出信号均方根值: %f\n', rms_y);  

% 计算并绘制自相关函数  
[r_u, lags_u] = xcorr(u, 'coeff', N); % 输入信号的自相关函数  
[r_y, lags_y] = xcorr(y, 'coeff', N); % 输出信号的自相关函数  

% 绘制时域波形
figure;  % 创建新图形窗口
subplot(2,1,1);  % 2行1列的第一个子图
plot(t_sim, u);  % 绘制输入信号的时域波形
axis([0 0.01 -2 2]);
title('输入信号：高斯白噪声');  % 设置标题
xlabel('时间 (s)');  % 设置x轴标签
ylabel('幅度');  % 设置y轴标签
grid on;  % 打开网格

subplot(2,1,2);  % 2行1列的第二个子图
plot(t_out, y);  % 绘制输出信号的时域波形
axis([0 0.01 -2 2]);
title('输出信号');  % 设置标题
xlabel('时间 (s)');  % 设置x轴标签
ylabel('幅度');  % 设置y轴标签
grid on;  % 打开网格

% 绘制频谱图
figure;  % 创建新图形窗口
NFFT = length(u); % 用于FFT的点数，等于输入信号的长度
f = Fs*(0:(NFFT/2))/NFFT; % 频率向量，用于绘制频谱图

U = fft(u, NFFT); % 输入信号的FFT
Y = fft(y, NFFT); % 输出信号的FFT

subplot(2,1,1);  % 2行1列的第一个子图
plot(f, abs(U(1:NFFT/2+1))/NFFT); % 绘制输入信号的频谱
title('输入信号的频谱');  % 设置标题
xlabel('频率 (Hz)');  % 设置x轴标签
ylabel('幅度');  % 设置y轴标签
grid on;  % 打开网格

subplot(2,1,2);  % 2行1列的第二个子图
plot(f, abs(Y(1:NFFT/2+1))/NFFT); % 绘制输出信号的频谱
title('输出信号的频谱');  % 设置标题
xlabel('频率 (Hz)');  % 设置x轴标签
ylabel('幅度');  % 设置y轴标签
grid on;  % 打开网格

% 绘制自相关函数图  
figure;  
subplot(2,1,1);  
plot(lags_u, r_u);  
title('输入信号（高斯白噪声）的自相关函数');  
xlabel('滞后 (样本点)');  
ylabel('自相关系数');  
grid on;  
  
subplot(2,1,2);  
plot(lags_y, r_y);  
title('输出信号的自相关函数');  
xlabel('滞后 (样本点)');  
ylabel('自相关系数');  
grid on;  
  
% 计算并绘制功率谱密度  
figure;  
Pxx_u = pwelch(u, [], [], [], Fs); % 输入信号的功率谱密度  
Pxx_y = pwelch(y, [], [], [], Fs); % 输出信号的功率谱密度  
  
% 绘制功率谱密度图  
subplot(2,1,1);  
plot(10*log10(Pxx_u));  
title('输入信号（高斯白噪声）的功率谱密度');  
xlabel('频率 (Hz)');  
ylabel('功率谱密度 (dB/Hz)');  
grid on;  
  
subplot(2,1,2);  
plot(10*log10(Pxx_y));  
xlim([0 1e4]); % 限制 x 轴范围在 0 到 10万 Hz
title('输出信号的功率谱密度');  
xlabel('频率 (Hz)');  
ylabel('功率谱密度 (dB/Hz)');  
grid on;