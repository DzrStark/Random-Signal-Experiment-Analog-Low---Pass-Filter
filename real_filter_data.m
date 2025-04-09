% 数据
frequency_khz = [0.1, 0.5, 1, 1.3, 1.5, 1.7, 2, 2.3, 2.5, 2.7, 3, 3.2, 3.4, ...
                 3.6, 3.8, 4, 4.2, 5, 7, 10, 20, 30, 50, 100]; % 频率 (kHz)
voltage = [5, 4.92, 4.8, 4.72, 4.64, 4.6, 4.44, 4.32, 4.2, 4.12, 4, 3.92, ...
           3.78, 3.68, 3.6, 3.53, 3.44, 3.14, 2.5, 1.92, 1.02, 0.684, 0.424, 0.214]; % 电压 (V)

% 绘制幅频特性曲线
figure;
semilogx(frequency_khz, voltage, 'o-', 'LineWidth', 1.5);
grid on;
xlabel('频率(kHz)');
ylabel('电压 (V)');
title('幅频特性曲线');
legend('测量值');

% 转换单位为 Hz 和幅频特性
f_hz = frequency_khz * 1e3; % 转换为 Hz
V_max = max(voltage); % 最大电压，归一化
H = voltage / V_max; % 传输系数归一化

% 指定频率
query_frequencies = [100, 500, 1000, 2000, 4000, 8000, 10000]; % 查询频率 (Hz)

% 插值计算传输系数
H_query = interp1(f_hz, H, query_frequencies, 'pchip'); % 插值计算

% 打印结果
fprintf('指定频率下的传输系数：\n');
fprintf('频率 (Hz)\t传输系数\n');
for i = 1:length(query_frequencies)
    fprintf('%d\t\t%.4f\n', query_frequencies(i), H_query(i));
end