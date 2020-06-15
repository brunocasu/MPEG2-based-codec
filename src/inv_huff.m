function serial_compressed_decoded_video = inv_huff (binary_serial_video_encoded, frame_size, numfiles )

load('huffman_dict.mat', 'dict_Y_DC', 'dict_Y_AC', 'dict_PbPr_DC', 'dict_PbPr_AC');

serial_compressed_decoded_video = zeros(1, 3*frame_size*numfiles);

pos_bin = 1;
pos_serial = 1;

while pos_bin <= length(binary_serial_video_encoded)
    
    % Y DC
    class = [];
    class_len = 0;
    pos_block = 1;
    while isempty(class) == true
        class = huffmandeco(binary_serial_video_encoded(1, pos_bin:pos_bin+class_len), dict_Y_DC);
        class_len = class_len +1;
    end
    bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+class-1);
    serial_compressed_decoded_video(1, pos_serial) = bin2signed(bin_amp);
    pos_serial = pos_serial +1;
    pos_bin = pos_bin + class_len + class;
    pos_block = pos_block +1;

    % Y AC    
    while pos_block < 65
        class = [];
        class_len = 0;
        while isempty(class) == true
            class = huffmandeco(binary_serial_video_encoded(1, pos_bin:pos_bin+class_len), dict_Y_AC);
            class_len = class_len +1;
        end
        if class == 0
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+7);
            s = num2str(bin_amp);
            s(isspace(s)) = '';
            n_of_zeros = bin2dec(s);
            pos_serial = pos_serial + n_of_zeros; %block of zeros
            pos_bin = pos_bin + class_len + 8;
            pos_block = pos_block + n_of_zeros;
        else
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+class-1);
            serial_compressed_decoded_video(1, pos_serial) = bin2signed(bin_amp);
            pos_serial = pos_serial +1;
            pos_bin = pos_bin + class_len + class;
            pos_block = pos_block +1;
        end
        
    end
    
    % Pb DC
    class = [];
    class_len = 0;
    if pos_block == 65
        while isempty(class) == true
            class = huffmandeco(binary_serial_video_encoded(1, pos_bin:pos_bin+class_len), dict_PbPr_DC);
            class_len = class_len +1;
        end
        if class == 0
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+7);
            s = num2str(bin_amp);
            s(isspace(s)) = '';
            n_of_zeros = bin2dec(s);
            pos_serial = pos_serial + n_of_zeros; %block of zeros
            pos_bin = pos_bin + class_len + 8;
            pos_block = pos_block + n_of_zeros;
        else
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+class-1);
            serial_compressed_decoded_video(1, pos_serial) = bin2signed(bin_amp);
            pos_serial = pos_serial +1;
            pos_bin = pos_bin + class_len + class;
            pos_block = pos_block +1;
        end
    
    end
    
    % Pb AC    
    while (pos_block > 65) && (pos_block < 129)
        class = [];
        class_len = 0;
        while isempty(class) == true
            class = huffmandeco(binary_serial_video_encoded(1, pos_bin:pos_bin+class_len), dict_PbPr_AC);
            class_len = class_len +1;
        end
        if class == 0
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+7);
            s = num2str(bin_amp);
            s(isspace(s)) = '';
            n_of_zeros = bin2dec(s);
            pos_serial = pos_serial + n_of_zeros; %block of zeros
            pos_bin = pos_bin + class_len + 8;
            pos_block = pos_block + n_of_zeros;
        else
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+class-1);
            serial_compressed_decoded_video(1, pos_serial) = bin2signed(bin_amp);
            pos_serial = pos_serial +1;
            pos_bin = pos_bin + class_len + class;
            pos_block = pos_block +1;
        end
        
    end
    
    % Pr DC
    class = [];
    class_len = 0;
    if pos_block == 129
        while isempty(class) == true
            class = huffmandeco(binary_serial_video_encoded(1, pos_bin:pos_bin+class_len), dict_PbPr_DC);
            class_len = class_len +1;
        end
        if class == 0
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+7);
            s = num2str(bin_amp);
            s(isspace(s)) = '';
            n_of_zeros = bin2dec(s);
            pos_serial = pos_serial + n_of_zeros; %block of zeros
            pos_bin = pos_bin + class_len + 8;
            pos_block = pos_block + n_of_zeros;
        else
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+class-1);
            serial_compressed_decoded_video(1, pos_serial) = bin2signed(bin_amp);
            pos_serial = pos_serial +1;
            pos_bin = pos_bin + class_len + class;
            pos_block = pos_block +1;
        end
    
    end
    
    % Pr AC    
    while (pos_block > 129) && (pos_block < 193)
        class = [];
        class_len = 0;
        while isempty(class) == true
            class = huffmandeco(binary_serial_video_encoded(1, pos_bin:pos_bin+class_len), dict_PbPr_AC);
            class_len = class_len +1;
        end
        if class == 0
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+7);
            s = num2str(bin_amp);
            s(isspace(s)) = '';
            n_of_zeros = bin2dec(s);
            pos_serial = pos_serial + n_of_zeros; %block of zeros
            pos_bin = pos_bin + class_len + 8;
            pos_block = pos_block + n_of_zeros;
        else
            bin_amp = binary_serial_video_encoded(1, pos_bin+class_len:pos_bin+class_len+class-1);
            serial_compressed_decoded_video(1, pos_serial) = bin2signed(bin_amp);
            pos_serial = pos_serial +1;
            pos_bin = pos_bin + class_len + class;
            pos_block = pos_block +1;
        end
        
    end

end


end
