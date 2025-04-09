clear; clc; close all;

% 设计RC低通滤波器的参数
Fc = 4e3; % 截止频率 4 kHz
R = 1e3; % 电阻 R = 1kΩ
C = 1 / (2 * pi * Fc * R); % 电容 C，使得截止频率为 Fc

% RC 低通滤波器传递函数
omega_c = 2 * pi * Fc; % 截止角频率 (rad/s)
num = [1]; % 分子系数
den = [R*C, 1]; % 分母系数 (RCs + 1)
H = tf(num, den); % 创建传递函数

% 扫频频率范围
f_sweep = logspace(1, 5, 500); % 10Hz 到 100kHz，500个点
w_sweep = 2 * pi * f_sweep; % 转换为角频率

% 计算传输函数的幅频特性
[mag, ~] = bode(H, w_sweep); % 计算幅频响应
mag = squeeze(mag); % 获取幅度值

% 绘制幅频响应曲线（figure1）
figure;
semilogx(f_sweep, 20*log10(mag)); % 使用对数坐标绘制幅度响应（dB）
title('RC 低通滤波器的幅频响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
grid on;

% 仿真不同频率的单音正弦信号通过滤波器
t = 0:1/100e3:1; % 仿真时间，采样频率为100kHz，仿真时间1秒
input_amplitude = 1; % 输入信号的幅度
frequencies = [100, 500, 1000, 2000, 4000, 8000, 10000]; % 单音正弦信号频率

% 仿真并绘制 2 kHz、4 kHz 和 6 kHz 下的输入输出波形
target_frequencies = [2000, 4000, 6000];  % 频率设定为 2 kHz, 4 kHz 和 6 kHz
num_cycles = 4;  % 显示的周期数

for i = 1:length(target_frequencies)
    % 当前频率
    f = target_frequencies(i);
    
    % 计算每个周期的时间
    T = 1 / f;
    
    % 生成输入信号
    u = input_amplitude * sin(2 * pi * f * t);
    
    % 计算滤波器输出响应
    [y, ~] = lsim(H, u, t);

    % 转换时间向量为毫秒，并限制显示时间为2到4个周期
    t_ms = t * 1e3;
    max_time_ms = num_cycles * T * 1e3;  % 显示时间上限，单位为毫秒
    
    % 创建新的 figure 并绘制输入输出波形
    figure;
    
    % 绘制输入信号
    subplot(2,1,1);
    plot(t_ms, u, 'r');  % 用红色绘制输入信号
    title(sprintf('输入信号（频率 = %d Hz）', f));
    xlabel('时间 (毫秒)');
    ylabel('幅度');
    xlim([0, max_time_ms]);  % 限制 x 轴范围显示 2-4 个周期
    ylim([-1.1 * input_amplitude, 1.1 * input_amplitude]);  % 限制 y 轴范围
    grid on;

    % 绘制输出信号
    subplot(2,1,2);
    plot(t_ms, y, 'r');  % 用红色绘制输出信号
    title(sprintf('输出信号（频率 = %d Hz）', f));
    xlabel('时间 (毫秒)');
    ylabel('幅度');
    xlim([0, max_time_ms]);  % 限制 x 轴范围显示 2-4 个周期
    ylim([-1.1 * max(abs(y)), 1.1 * max(abs(y))]);  % 根据输出信号最大值调整 y 轴范围
    grid on;
end




% 计算并绘制每个频率下的输入输出信号幅度和传输系数（figure3）
input_amplitude_spectrum = [];
output_amplitude_spectrum = [];
for i = 1:length(frequencies)
    % 生成输入信号
    u = input_amplitude * sin(2 * pi * frequencies(i) * t);
    % 计算滤波器输出响应
    [y, ~] = lsim(H, u, t);

    % 计算输入输出信号的幅度（均方根）
    input_amplitude_spectrum(i) = rms(u);
    output_amplitude_spectrum(i) = rms(y);
end

% 计算传输系数
transfer_function = output_amplitude_spectrum ./ input_amplitude_spectrum;

% 打印传输系数
disp('频率 (Hz) - 输入信号幅度 - 输出信号幅度 - 传输系数');
for i = 1:length(frequencies)
    fprintf('%d Hz - %.4f - %.4f - %.4f\n', frequencies(i), input_amplitude_spectrum(i), output_amplitude_spectrum(i), transfer_function(i));
end

% 绘制传输系数 vs 频率（figure3）
figure;
semilogx(frequencies, transfer_function, 'o-', 'LineWidth', 2);
title('RC 低通滤波器传输系数');
xlabel('频率 (Hz)');
ylabel('传输系数');
grid on;
