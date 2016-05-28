% using FFT 
%any parameter using two side spectrum to calculate
function enob(data,time)
s = size(data);
figure;
plot(time,data),title('siganl','FontWeight','bold','FontSize',16),xlabel('Time (s)','FontWeight','bold','FontSize',16),ylabel('voltage(v)','FontWeight','bold','FontSize',22);
set(gca,'FontSize',20);
grid on;
fs=1/(time(2)-time(1));
N=size(data,1);
if N==1
   N=size(data,2);
end
y=(abs(fft(data))/N);    %power spectrum
y=y(1:((N)/2+1));
y(2:end)=y(2:end)*2 ; %two side power spectrum to one side power spectrum;?????????
y(1)=0;                       %cancel DC value
x=(0:((N)/2)).*(fs/N);
%plot(x,mag2db(y(1:N/2+1)));
ydb=(mag2db(y(1:N/2+1)));
ydb=ydb-max(ydb);

figure;
plot(ydb);
grid on

%figure;
%plot(x,ydb,'linewidth',2);
%set(gca,'xlim',[0,10000],'FontSize',20);% you can change the limit 
figure;
plot(x,ydb,'linewidth',2);
set(gca,'FontSize',20);
set(gca,'xlim',[0,200],'FontSize',20);% you can change the limit 
[Signal index]=max(y);
SignalPower=Signal^2; 
fin=x(index);
% =====================%TNoisePower=Noise power + Distortion power;
TNoise=y(1:N/2+1);
TNoise(index)=0;
TNoisePower=sum(TNoise.^2);
% ===================
%SFDR=mag2db(Signal/x(index*2-1));

SNDR=10*log10(SignalPower/TNoisePower);
ENOB=(SNDR-1.76)/6.02;
%text(max(x)-max(x),-20,sprintf('%d point FFT\nFin=%d Hz\nFs=%d kHz\nSNDR=%d dB \nENOB=%d',N,fin,fs/1000,SNDR,ENOB),'FontSize',22);

ylabel('Power Density (dBFS/bin)');
xlabel('Frequency (Hz)');
end