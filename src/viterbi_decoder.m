function binary_serial_video_recovered = viterbi_decoder (data, rate)

trellis = poly2trellis(7,{'1 + x^3 + x^4 + x^5 + x^6','1 + x + x^3 + x^4 + x^6'});
tbdepth = 96;

if rate == 2/3
    binary_serial_video_recovered = vitdec(data,trellis,tbdepth,'trunc','hard',[1;1;0;1]);
elseif rate == 3/4
    binary_serial_video_recovered = vitdec(data,trellis,tbdepth,'trunc','hard',[1;1;0;1;1;0]);
elseif rate == 5/6
    binary_serial_video_recovered = vitdec(data,trellis,tbdepth,'trunc','hard',[1;1;0;1;1;0;0;1;1;0]);
elseif rate == 7/8
    binary_serial_video_recovered = vitdec(data,trellis,tbdepth,'trunc','hard',[1;1;0;1;1;0;0;1;1;0;0;1;1;0]);
else
    binary_serial_video_recovered = vitdec(data,trellis,tbdepth,'trunc','hard');
end


end