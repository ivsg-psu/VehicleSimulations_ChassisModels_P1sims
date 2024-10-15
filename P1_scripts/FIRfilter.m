function x_average = FIRfilter(xbuffer, window_length)

x_portion = 0;
for jj = 1:window_length
    x_portion = x_portion + xbuffer(jj)/window_length;
end
x_average = x_portion;