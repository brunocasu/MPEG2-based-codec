function binary_serial_video_encoded = huff (frame_size, numfiles)

load('video_ypbpr.mat', 'video_Y_serial', 'video_Pb_serial', 'video_Pr_serial');
load('serial_class.mat', 'class_Y_DC', 'class_Y_AC', 'class_PbPr_DC', 'class_PbPr_AC');
load('huffman_dict.mat', 'dict_Y_DC', 'dict_Y_AC', 'dict_PbPr_DC', 'dict_PbPr_AC');

%serial length
slen = numfiles*frame_size;

fun = @(block_struct) inv_ac_serial(block_struct.data);
Y_class = blockproc(class_Y_AC, [1 63], fun);
Y_class(1, 1:64:length(Y_class)) = class_Y_DC; 

fun2 = @(block_struct) inv_ac2_serial(block_struct.data);
PbPr_class = blockproc(class_PbPr_AC, [1 126], fun2);
Pb_class = PbPr_class(1, 1:size(PbPr_class, 2));
Pb_class(1:64:length(Pb_class)) = class_PbPr_DC (1:2:end);  
Pr_class = PbPr_class(2, 1:size(PbPr_class, 2));
Pr_class(1:64:length(Pr_class)) = class_PbPr_DC (2:2:end);

%sequence class before amplitude in a single array
%Y_amplitude_and_class(1, 1:2:2*slen) = Y_class;
%Y_amplitude_and_class(1, 2:2:2*slen) = video_Y_serial;
%
%Pb_amplitude_and_class(1, 1:2:2*slen) = Pb_class;
%Pb_amplitude_and_class(1, 2:2:2*slen) = video_Pb_serial;
%
%Pr_amplitude_and_class(1, 1:2:2*slen) = Pr_class;
%Pr_amplitude_and_class(1, 2:2:2*slen) = video_Pr_serial;


video_serial_class_and_amplitude = zeros(1, 2*3*frame_size*numfiles);
%encoded length has double the video serial size
len = length(video_serial_class_and_amplitude);

k=1;
for n = 1:2:128
    
    video_serial_class_and_amplitude (1, n:384:len ) = Y_class(1, k:64:slen);  
    video_serial_class_and_amplitude (1, n+1:384:len) = video_Y_serial(1, k:64:slen); 

    video_serial_class_and_amplitude (1, n+128:384:len) = Pb_class(1, k:64:slen);  
    video_serial_class_and_amplitude (1, n+129:384:len) = video_Pb_serial(1, k:64:slen); 

    video_serial_class_and_amplitude (1, n+256:384:len) = Pr_class(1, k:64:slen);  
    video_serial_class_and_amplitude (1, n+257:384:len) = video_Pr_serial(1, k:64:slen); 
    k=k+1;
end

binary_array_to_find_seq_of_zeros = video_serial_class_and_amplitude;
binary_array_to_find_seq_of_zeros(binary_array_to_find_seq_of_zeros~=0) = 1;
number_of_non_zeros = nnz(binary_array_to_find_seq_of_zeros);

string = sprintf('%d', binary_array_to_find_seq_of_zeros);

group_of_zeros = textscan(string,'%s','delimiter','1','multipleDelimsAsOne',1);
cell_group_of_zeros = group_of_zeros{:};
size_of_groups = cellfun(@length, cell_group_of_zeros);

encoded_video_serial_class_and_amplitude = zeros(1, number_of_non_zeros + (size(size_of_groups,1))*2);
pos_in_video = 1; 
pos_in_0group = 1;
pos_in_encoded = 1;
while pos_in_video <= len % size of video with class values and amplitude

    if video_serial_class_and_amplitude(1, pos_in_video) > 0 % this position in video_serial_class_and_amplitude should always point to a class value
        encoded_video_serial_class_and_amplitude(1, pos_in_encoded) = video_serial_class_and_amplitude(1, pos_in_video);
        encoded_video_serial_class_and_amplitude(1, pos_in_encoded+1) = video_serial_class_and_amplitude(1, pos_in_video+1);
        pos_in_video = pos_in_video +2;
        pos_in_encoded = pos_in_encoded +2;
    else % if finds a class with value of zero;
        encoded_video_serial_class_and_amplitude(1, pos_in_encoded) = video_serial_class_and_amplitude(1, pos_in_video);
        encoded_video_serial_class_and_amplitude(1, pos_in_encoded+1) = (size_of_groups(pos_in_0group, 1))/2;
        pos_in_video = pos_in_video + size_of_groups(pos_in_0group, 1);
        pos_in_0group = pos_in_0group +1;
        pos_in_encoded = pos_in_encoded +2;
    end
    
end
enco_len = length(encoded_video_serial_class_and_amplitude);
cell_encoded_video = mat2cell(encoded_video_serial_class_and_amplitude, 1, 2*ones(1, enco_len/2));

%cell_binary_encoded_video = num2cell(zeros(1, length(cell_encoded_video)));
binary_serial_video_encoded = [];

relative_block_pos = 1;
for pos_in_cell = 1:length(cell_encoded_video)
    
    aux = cell_encoded_video{1, pos_in_cell};

    aux_class = aux(1, 1);
    aux_amp = aux(1, 2);
    if aux_class > 0 %for positive classes
        
        if relative_block_pos == 1 
            bin_class = huffmanenco(aux_class, dict_Y_DC); 
        elseif (relative_block_pos > 1) && (relative_block_pos <= 64) 
            bin_class = huffmanenco(aux_class, dict_Y_AC);
        elseif (relative_block_pos == 65) || (relative_block_pos == 129)
            bin_class = huffmanenco(aux_class, dict_PbPr_DC);
        else
            bin_class = huffmanenco(aux_class, dict_PbPr_AC);
        end
        
        if relative_block_pos >= 192
            relative_block_pos = 1;
        else
            relative_block_pos = relative_block_pos +1;
        end
        bin_class=bin_class';
        bin_amp = signed2bin(aux_amp) - '0';

    else %for class zero
        
        if relative_block_pos == 1 
            bin_class = huffmanenco(aux_class, dict_Y_DC); 
        elseif (relative_block_pos > 1) && (relative_block_pos <= 64) 
            bin_class = huffmanenco(aux_class, dict_Y_AC);
        elseif (relative_block_pos == 65) || (relative_block_pos == 129)
            bin_class = huffmanenco(aux_class, dict_PbPr_DC);
        else
            bin_class = huffmanenco(aux_class, dict_PbPr_AC);
        end
        
        bin_amp = dec2bin(aux_amp, 8) - '0'; %fixed 8 bits length
        
        relative_block_pos = relative_block_pos + aux_amp;
        if relative_block_pos >= 192
            relative_block_pos = 1;
        end
    end
        
    %cell_binary_encoded_video{1, pos_in_cell} = cat(2, bin_class, bin_amp);
    next_block = cat(2, bin_class, bin_amp);
    binary_serial_video_encoded = cat(2, binary_serial_video_encoded, next_block);
end


end

