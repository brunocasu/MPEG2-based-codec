% Projeto Interdisciplinar NEC120 e NEC130

clear 
close all
clc

%video = VideoWriter('video_pt2.avi','Uncompressed AVI');
%video.FrameRate = 12;
%open(video)

%imagefiles = dir ('*jpeg');
%numfiles = length(imagefiles);

%for i = 1:numfiles
%   filename = ['scene0' num2str(i,'%04d') '.jpeg'];
%   image = imread(filename);
%   writeVideo(video,image)
%end

%close(video)
%%
%Begin processing the video
numfiles = 1; %Choose how many frames will be processed (this can be reduced to test the program with smaller vectors)
tic;
video_rgb = fonte('video_pt2.avi'); %Load the video and store in the RGB struct

frame_dim = [(size(video_rgb.R,1)),(size(video_rgb.R,2))];
frame_size = (size(video_rgb.R,1))*(size(video_rgb.R,2));
scale_factor = 2;

video_serial = [];
video_Y_serial = [];
video_Pb_serial= [];
video_Pr_serial= [];

for f=1:numfiles %The video is processed frame by frame
    frame_rgb.R = video_rgb.R(:,:,f);
    frame_rgb.G = video_rgb.G(:,:,f);
    frame_rgb.B = video_rgb.B(:,:,f);
    frame_ypbpr = dct(frame_rgb, scale_factor); %Apply DCT, return YPbPr frame Quantized with a define scale factor
    frame_serial = zig(frame_ypbpr); %Serialize the frames using the ZigZag sequence

    video_Y_serial = cat(2, video_Y_serial, frame_serial.Y); 
    video_Pb_serial= cat(2, video_Pb_serial, frame_serial.Pb);
    video_Pr_serial= cat(2, video_Pr_serial, frame_serial.Pr);

    video_serial = cat(2, video_serial, frame_serial.YPbPr); 
end
   
%save serial Y Pb Pr of all video to be accessed by the statistic function
save('video_ypbpr', 'video_Y_serial', 'video_Pb_serial', 'video_Pr_serial');
%%    
%Run the statistic function to create the Huffman dict
statistic();

%Implement the huffman encoding
binary_serial_video = huff (frame_size, numfiles);

%Estimate the compression of the process
compression_rate = (numfiles*frame_size*3*8)/(length(binary_serial_video));
%%
%Implement the convolutional encoder

rate_num = 5;
rate_den = 6;
rate = rate_num/rate_den; % availables: 1/2, 2/3, 3/4, 5/6, 7/8

extra_data = 0;
if rem(length(binary_serial_video), rate_num) ~= 0
    extra_data = rate_num - rem(length(binary_serial_video), rate_num);
    binary_serial_video_fixed = cat(2, binary_serial_video, zeros(1, extra_data));
else
    binary_serial_video_fixed = binary_serial_video;
end 

coded_data = trellis_conv_encoder (binary_serial_video_fixed, rate);
extra_b = 0;
if rem(length(coded_data), 3) ~= 0
    extra_b = 3 - rem(length(coded_data), 3);
    coded_data_fixed = cat(2, coded_data, zeros(1, extra_b));
else
    coded_data_fixed = coded_data;
end
%%
%Serial To Paralel Converter (binary serial video to Q, I and A signals)
Q.time = [];
I.time = [];
A.time = [];

%8QAM modem inputs:
Q.signals.values = (coded_data_fixed(1, 1:3:end))';
I.signals.values = (coded_data_fixed(1, 2:3:end))';
A.signals.values = (coded_data_fixed(1, 3:3:end))';

%the simulation time (tsym) is calculated y multiplying the symbol time (1/3MHz) by the number of symbols in the serial array
tsym = (1/3000000)*(length(coded_data_fixed)/3);
%tsym = tsym + (1/3000000);
%%

%Run Simulink project: modem_8QAM

%%
%Output of the 8QAM modem
num_bits = size(recovered_A.signals.values, 3) + size(recovered_Q.signals.values, 3) + size(recovered_I.signals.values, 3) -6;
rec_Q(1,1:size(recovered_Q.signals.values, 3)-2) = double(recovered_Q.signals.values(:,:,2:end-1));  
rec_I(1,1:size(recovered_I.signals.values, 3)-2) = double(recovered_I.signals.values(:,:,2:end-1));  
rec_A(1,1:size(recovered_A.signals.values, 3)-2) = double(recovered_A.signals.values(:,:,2:end-1));

%Paralel to Serial converter (Q, I and A signals to serial demodulated video)
if extra_b == 1
    auxiliar(1,1:3:num_bits)=rec_Q(1,1:end);
    auxiliar(1,2:3:num_bits)=rec_I(1,1:end);
    auxiliar(1,3:3:num_bits)=rec_A(1,1:end);
    %remove extra bit
    binary_serial_video_demodulated(1, 1:num_bits-1) = auxiliar(1, 1:num_bits-1); 
elseif extra_b == 2
    auxiliar(1,1:3:num_bits)=rec_Q(1,1:end);
    auxiliar(1,2:3:num_bits)=rec_I(1,1:end);
    auxiliar(1,3:3:num_bits)=rec_A(1,1:end);
    %remove extra bits
    binary_serial_video_demodulated(1, 1:num_bits-2) = auxiliar(1, 1:num_bits-2);
else
    binary_serial_video_demodulated(1,1:3:num_bits)=rec_Q(1,1:end);
    binary_serial_video_demodulated(1,2:3:num_bits)=rec_I(1,1:end);
    binary_serial_video_demodulated(1,3:3:num_bits)=rec_A(1,1:end);
end

[Num_of_errors, BER] = biterr(coded_data, binary_serial_video_demodulated);
%%
%FEC
binary_serial_video_recovered_extra = viterbi_decoder (binary_serial_video_demodulated, rate);
%remove extra data inserted
binary_serial_video_recovered(1, 1:length(binary_serial_video_recovered_extra)-extra_data) = binary_serial_video_recovered_extra(1, 1:end-extra_data);
[Total_errors, BER_after_FEC] = biterr(binary_serial_video, binary_serial_video_recovered);
%%
%Recovering the video
serial_compressed_decoded_video = inv_huff (binary_serial_video_recovered, frame_size, numfiles );

k=0;
for f=1:numfiles
    compressed_frame_ypbpr = inv_zig (serial_compressed_decoded_video(1, k*3*frame_size +1:f*(3*frame_size)), frame_dim);
    k=k+1;

    compressed_frame_rgb = inv_dct(compressed_frame_ypbpr, scale_factor);
    
    compressed_video_rgb.R(:,:,f) = compressed_frame_rgb.R;
    compressed_video_rgb.G(:,:,f) = compressed_frame_rgb.G;
    compressed_video_rgb.B(:,:,f) = compressed_frame_rgb.B;
end

destino (compressed_video_rgb, numfiles);
toc;
