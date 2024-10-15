function xbuffer = CreateFIRBuffer(count, window_length, x, xbufferprev)

% create a buffer of the latest N samples, where N = window_length
xbuffer = xbufferprev;
if count <= window_length
    % fill the buffer
    xbuffer(count,:) = x;
else
    % move everything back one step
    for jj = 1:window_length-1
        xbuffer(jj,:) = xbufferprev(jj+1,:);
    end
    % last item is updated with new signal
    xbuffer(window_length,:) = x;
end