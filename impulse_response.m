clear; clc; close all;
%%%%%%%%%%%%%%%%%%%%%%%%原数据%%%%%%%%%%%%%%%%%%%%%%%%
N =100000; % 数据长度， 或者采样点数
fs=500000; % 采样频率
t=0:1/fs:(N-1)/fs; % 离散的时间序列
fc=5000; % 信号频率
R=9.8e3; % 电阻， 单位欧姆
C=4000e-12; %电容， 单位法拉
sys1=tf(1,[R*C,1]); %模拟一个线性系统
fb1=1/(2*pi*R*C); % 根据 RC 值， 计算得到的低通滤波器截止频率
h1= 1/(R*C)*exp(-1/(R*C).*t)/fs; % RC 低通滤波器对应的时域冲击响应理论值
ff=0:fs/N:fs/2-fs/N; 
H=1./(1+1i*2*pi*ff*R*C); % RC 低通滤波器传输函数的理论值
mu = 0; sigma = 1;
noise=mu+sqrt(sigma)*randn(1,N);% 产生均值为mu=0,方差sigma=1的高斯白噪声
xt1= lsim(sys1, noise, t); % 将高斯白噪声信号noise送入到系统sys1中， t是时间序列， y是输出信号
yt1=xcorr(xt1,noise)/N; % 过被测系统后的输出信号xt1与高斯白噪声求互相关,除以N是为了归一化
L1=length(yt1);
h1_est=yt1(floor((L1)/2)+1:L1); % 取后半部分数值， 即为估计到的系统冲击响应，
figure();
plot(t(2:200),h1(2:200),"v-",color="blue"); % 画出滤波器冲击响应,从第二个采样值开始
hold("on");
plot(t(2:200),h1_est(2:200),".-",color="red");
title("低通滤波器时域冲激响应");xlabel("时间/s");ylabel("幅度/V");
legend("真实的冲激响应","估计的冲激响应")
M=100; % M 取值不能太大， 太大， 会影响估计结果
fft_h1_est=fft(h1_est(1:M),N); %对h1_est的前M个点进行傅里叶变换， 因为低通滤波器后面的数值接近与0，
f=0:fs/N:fs/2-fs/N;
figure();semilogx(f,abs(H),"-");hold("on"); %系统传输函数的幅频特性（ 理论分析结果）
semilogx(f,(abs(fft_h1_est(1:length(f))))),"-"; % 系统传输传输（ 估计结果）
xlabel("频率/Hz");ylabel("传输系数"); title("滤波器传输函数");
legend("真实传输函数","估计到的传输函数")
%%%%%%%%%%%%%%%%%%%%%%%%增加采样点数%%%%%%%%%%%%%%%%%%%%%%%%
Nnew =1000000; % 数据长度， 或者采样点数
t=0:1/fs:(Nnew-1)/fs; % 离散的时间序列
sys1=tf(1,[R*C,1]); %模拟一个线性系统
fb1=1/(2*pi*R*C); % 根据 RC 值， 计算得到的低通滤波器截止频率
h1= 1/(R*C)*exp(-1/(R*C).*t)/fs; % RC 低通滤波器对应的时域冲击响应理论值
ff=0:fs/Nnew:fs/2-fs/Nnew; 
H=1./(1+1i*2*pi*ff*R*C); % RC 低通滤波器传输函数的理论值
mu = 0; sigma = 1;
noise=mu+sqrt(sigma)*randn(1,Nnew);% 产生均值为mu=0,方差sigma=1的高斯白噪声
xt1= lsim(sys1, noise, t); % 将高斯白噪声信号noise送入到系统sys1中， t是时间序列， y是输出信号
yt1=xcorr(xt1,noise)/Nnew; % 过被测系统后的输出信号xt1与高斯白噪声求互相关,除以N是为了归一化
L1=length(yt1);
h1_est=yt1(floor((L1)/2)+1:L1); % 取后半部分数值， 即为估计到的系统冲击响应，
figure();
plot(t(2:200),h1(2:200),"v-",color="blue"); % 画出滤波器冲击响应,从第二个采样值开始
hold("on");
plot(t(2:200),h1_est(2:200),".-",color="red");
title("低通滤波器时域冲激响应（增加采样点数）");xlabel("时间/s");ylabel("幅度/V");
legend("真实的冲激响应","估计的冲激响应（增加采样点数）")
M=100; %M 取值不能太大， 太大， 会影响估计结果
fft_h1_est=fft(h1_est(1:M),Nnew); %对h1_est的前M个点进行傅里叶变换， 因为低通滤波器后面的数值接近与0，
f=0:fs/Nnew:fs/2-fs/Nnew;
figure();semilogx(f,abs(H),"-");hold("on"); %系统传输函数的幅频特性（ 理论分析结果）
semilogx(f,(abs(fft_h1_est(1:length(f))))),"-"; % 系统传输传输（ 估计结果）
xlabel("频率/Hz");ylabel("传输系数"); title("滤波器传输函数（增加采样点数）");
legend("真实传输函数","估计到的传输函数（增加采样点数）")
%%%%%%%%%%%%%%%%%%%%%%%%增加采样频率%%%%%%%%%%%%%%%%%%%%%%%%
N =1000000; % 数据长度， 或者采样点数
fs=5000000; % 采样频率
t=0:1/fs:(N-1)/fs; % 离散的时间序列
fc=5000; % 信号频率
R=9.8e3; % 电阻， 单位欧姆
C=4000e-12; %电容， 单位法拉
sys1=tf(1,[R*C,1]); %模拟一个线性系统
fb1=1/(2*pi*R*C); % 根据 RC 值， 计算得到的低通滤波器截止频率
h1= 1/(R*C)*exp(-1/(R*C).*t)/fs; % RC 低通滤波器对应的时域冲击响应理论值
ff=0:fs/N:fs/2-fs/N; 
H=1./(1+1i*2*pi*ff*R*C); % RC 低通滤波器传输函数的理论值
mu = 0; sigma = 1;
noise=mu+sqrt(sigma)*randn(1,N);% 产生均值为mu=0,方差sigma=1的高斯白噪声
xt1= lsim(sys1, noise, t); % 将高斯白噪声信号noise送入到系统sys1中， t是时间序列， y是输出信号
yt1=xcorr(xt1,noise)/N; % 过被测系统后的输出信号xt1与高斯白噪声求互相关,除以N是为了归一化
L1=length(yt1);
h1_est=yt1(floor((L1)/2)+1:L1); % 取后半部分数值， 即为估计到的系统冲击响应，
figure();
plot(t(2:200),h1(2:200),"v-",color="blue"); % 画出滤波器冲击响应,从第二个采样值开始
hold("on");
plot(t(2:200),h1_est(2:200),".-",color="red");
title("低通滤波器时域冲激响应（增加采样频率）");xlabel("时间/s");ylabel("幅度/V");
legend("真实的冲激响应","估计的冲激响应")
M=1000; % M 取值不能太大， 太大， 会影响估计结果
fft_h1_est=fft(h1_est(1:M),N); %对h1_est的前M个点进行傅里叶变换， 因为低通滤波器后面的数值接近与0，
f=0:fs/N:fs/2-fs/N;
figure();semilogx(f,abs(H),"-");hold("on"); %系统传输函数的幅频特性（ 理论分析结果）
semilogx(f,(abs(fft_h1_est(1:length(f))))),"-"; % 系统传输传输（ 估计结果）
xlabel("频率/Hz");ylabel("传输系数"); title("滤波器传输函数（增加采样频率）");
legend("真实传输函数","估计到的传输函数")