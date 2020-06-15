function coded_data = trellis_conv_encoder (data, rate)

%implement the convolutinal encoding

%                         |    impulse (171)oct      |    impulse (133)oct    |
trellis = poly2trellis(7,{'1 + x^3 + x^4 + x^5 + x^6','1 + x + x^3 + x^4 + x^6'});

%puncturing (standard rate is 1/2, using 100% of redundance)
if rate == 2/3
    coded_data = convenc(data,trellis,[1;1;0;1]);
    %len = (length(conv_data)) - (length(conv_data))/4; % 25% reduction in 1/2 redundance
    %coded_data(1:3:len) = conv_data(1:4:end);
    %coded_data(2:3:len) = conv_data(2:4:end);
    %coded_data(3:3:len) = conv_data(4:4:end);
elseif rate == 3/4
    coded_data = convenc(data,trellis,[1;1;0;1;1;0]);
    %len = (length(conv_data)) - (length(conv_data))/3; % 33% reduction in 1/2 redundance
    %coded_data(1:4:len) = conv_data(1:6:end);
    %coded_data(2:4:len) = conv_data(2:6:end);
    %coded_data(3:4:len) = conv_data(4:6:end);
    %coded_data(4:4:len) = conv_data(5:6:end);
elseif rate == 5/6
    coded_data = convenc(data,trellis,[1;1;0;1;1;0;0;1;1;0]);
    %len = (length(conv_data)) - (2*length(conv_data))/5; % 40% reduction in 1/2 redundance
    %coded_data(1:6:len) = conv_data(1:10:end);
    %coded_data(2:6:len) = conv_data(2:10:end);
    %coded_data(3:6:len) = conv_data(4:10:end);
    %coded_data(4:6:len) = conv_data(5:10:end);
    %coded_data(5:6:len) = conv_data(8:10:end);
    %coded_data(6:6:len) = conv_data(9:10:end);
elseif rate == 7/8
    coded_data = convenc(data,trellis,[1;1;0;1;1;0;0;1;1;0;0;1;1;0]);
    %len = (length(conv_data)) - (4*length(conv_data))/7; % 57% reduction in 1/2 redundance
    %coded_data(1:8:len) = conv_data(1:14:end);
    %coded_data(2:8:len) = conv_data(2:14:end);
    %coded_data(3:8:len) = conv_data(4:14:end);
    %coded_data(4:8:len) = conv_data(5:14:end);
    %coded_data(5:8:len) = conv_data(8:14:end);
    %coded_data(6:8:len) = conv_data(9:14:end);
    %coded_data(7:8:len) = conv_data(12:14:end);
    %coded_data(8:8:len) = conv_data(13:14:end);
else
    coded_data = convenc(data,trellis);
end

end
