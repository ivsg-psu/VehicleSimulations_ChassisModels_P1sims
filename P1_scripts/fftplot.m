function [f,P] = fftplot(x,n,s)
% fftplot(x,s,n)
% x - dataset (required)
% n - number of points in transform (optional, number of points in series if not given)
% s - sample rate

% Calculate the FFT and find the magnitude at each frequency
X = fft(x,n);
P = sqrt(X.* conj(X))/n;
f = s*(0:round(n/2))/n;
P = 2*P(1:length(f));

% Plot the magnitude versus frequency on a semilog plot, trimming off the
% frequencies above the Nyquist frequency
% figure
semilogy(f,P,'k*-','markersize',6)
ylabel('Frequency Content')
xlabel('Frequency (Hz)')
