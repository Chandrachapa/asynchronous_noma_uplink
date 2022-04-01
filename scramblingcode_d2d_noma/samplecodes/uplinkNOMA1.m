clc; clear variables; 
close all;

df = 800; dn = 200; 	%Distances

eta = 4;	%Path loss exponent
N = 10^5;

%Rayleigh fading coefficients
hf = sqrt(df^-eta)*(randn(1,N)+1i*randn(1,N))/sqrt(2);
hn = sqrt(dn^-eta)*(randn(1,N)+1i*randn(1,N))/sqrt(2);

%Channel gains
gf = (abs(hf)).^2;
gn = (abs(hn)).^2;

%Transmit power
Pt = -60:5:60;	%in dBm
pt = (10^-3)*db2pow(Pt); %in watts

BW = 10^6;	%bandwidth

%Noise powers
No = -174 + 10*log10(BW);	%in dBm
no = (10^-3)*db2pow(No);	%in watts

%Generate noise samples for both users
w0 = sqrt(no)*(randn(1,N)+1i*randn(1,N))/sqrt(2);

%Generate random binary data for two users
data1 = randi([0 1],1,N);  %Data bits of user 1
data2 = randi([0 1],1,N);  %Data bits of user 2

%Do BPSK modulation of data
x1 = 2*data1 - 1;
x2 = 2*data2 - 1;
Pt = 0:2:20;                %Transmit power in dBm
p = length(Pt);

for u = 1:p
    %received data 
    y = sqrt(Pt(u))*hn.*x1 + sqrt(Pt(u))*hf.*x2 + w0;
    
    %Equalize 
    eq1 = y./hn;
    eq2 = y./hf;
    
    %AT USER 1--------------------
    %Direct decoding of x1 from y1
    x1_hat = zeros(1,N);
    x1_hat(eq1>0) = 1;
    
    %Compare decoded x1_hat with data1 to estimate BER
    ber1(u) = biterr(data1,x1_hat)/N;
    
    %AT USER 2-------------------------
    x12_hat = ones(1,N);
    x12_hat(eq2<0) = -1;
    
    y2_dash = eq2 - sqrt(10)*x12_hat;
    x2_hat = zeros(1,N);
    x2_hat(real(y2_dash)>0) = 1;
    
    ber2(u) = biterr(x2_hat, data2)/N;
end

%figure;
semilogy(Pt, ber1,'r', 'linewidth',1.5); hold on; grid on;
semilogy(Pt, ber2,'b', 'linewidth',1.5);
xlabel('Transmit power (P in dBm)');
ylabel('BER');
legend('Sim. User 1/Far user','Sim. User 2/Near user','Theo. User 1/Far user','Theo. User 2/Near user');

title('BER of uplink NOMA');


