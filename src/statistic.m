function  statistic

load('video_ypbpr.mat', 'video_Y_serial', 'video_Pb_serial', 'video_Pr_serial');

Y_DC = video_Y_serial(1:64:end);
Pb_DC = video_Pb_serial(1:64:end);
Pr_DC = video_Pr_serial(1:64:end);

fun = @(block_struct) ac_serial(block_struct.data);
Y_AC = blockproc(video_Y_serial, [1 64], fun);

len = size(Pb_DC, 2) + size(Pr_DC, 2);
PbPr_DC(1:2:len) = Pb_DC;  
PbPr_DC(2:2:len) = Pr_DC;
Pb_AC = blockproc(video_Pb_serial, [1 64], fun);
Pr_AC = blockproc(video_Pr_serial, [1 64], fun);
Z(1, 1:size(Pb_AC,2)) = Pb_AC; 
Z(2, 1:size(Pr_AC,2)) = Pr_AC; 
fun2 = @(block_struct) ac2_serial(block_struct.data);
PbPr_AC = blockproc(Z, [2 63], fun2);

%work with the arrays as cells
cell_Y_DC = num2cell(Y_DC);
cell_bin_Y_DC = cellfun(@signed2bin, cell_Y_DC, 'UniformOutput', false);
class_Y_DC = cellfun(@length, cell_bin_Y_DC);

cell_Y_AC = num2cell(Y_AC); 
cell_bin_Y_AC = cellfun(@signed2bin, cell_Y_AC, 'UniformOutput', false);
class_Y_AC = cellfun(@length, cell_bin_Y_AC);

cell_PbPr_DC = num2cell(PbPr_DC);
cell_bin_PbPr_DC = cellfun(@signed2bin, cell_PbPr_DC, 'UniformOutput', false);
class_PbPr_DC = cellfun(@length, cell_bin_PbPr_DC);

cell_PbPr_AC = num2cell(PbPr_AC);
cell_bin_PbPr_AC = cellfun(@signed2bin, cell_PbPr_AC, 'UniformOutput', false);
class_PbPr_AC = cellfun(@length, cell_bin_PbPr_AC);

%histograms and statistical analisys
H_Y_DC = histogram(class_Y_DC);
p_Y_DC = ones(1, length(H_Y_DC.Values));
p_Y_DC = H_Y_DC.Values./((length(class_Y_DC))*p_Y_DC);
simbols_Y_DC = unique(class_Y_DC);
dict_Y_DC = huffmandict(simbols_Y_DC, p_Y_DC);

H_Y_AC = histogram(class_Y_AC);
p_Y_AC = ones(1, length(H_Y_AC.Values));
p_Y_AC = H_Y_AC.Values./((length(class_Y_AC))*p_Y_AC);
simbols_Y_AC = unique(class_Y_AC);
dict_Y_AC = huffmandict(simbols_Y_AC, p_Y_AC);

H_PbPr_DC = histogram(class_PbPr_DC);
p_PbPr_DC = ones(1, length(H_PbPr_DC.Values));
p_PbPr_DC = H_PbPr_DC.Values./((length(class_PbPr_DC))*p_PbPr_DC);
simbols_PbPr_DC = unique(class_PbPr_DC);
dict_PbPr_DC = huffmandict(simbols_PbPr_DC, p_PbPr_DC);

H_PbPr_AC = histogram(class_PbPr_AC);
p_PbPr_AC = ones(1, length(H_PbPr_AC.Values));
p_PbPr_AC = H_PbPr_AC.Values./((length(class_PbPr_AC))*p_PbPr_AC);
simbols_PbPr_AC = unique(class_PbPr_AC);
dict_PbPr_AC = huffmandict(simbols_PbPr_AC, p_PbPr_AC);

%dict_Y_DC(:,2) = cellfun(@num2str,dict_Y_DC(:,2),'UniformOutput',false);
%dict_Y_AC(:,2) = cellfun(@num2str,dict_Y_AC(:,2),'UniformOutput',false);
%dict_PbPr_DC(:,2) = cellfun(@num2str,dict_PbPr_DC(:,2),'UniformOutput',false);
%dict_PbPr_AC(:,2) = cellfun(@num2str,dict_PbPr_AC(:,2),'UniformOutput',false);

save('huffman_dict', 'dict_Y_DC', 'dict_Y_AC', 'dict_PbPr_DC', 'dict_PbPr_AC');
save('serial_class', 'class_Y_DC', 'class_Y_AC', 'class_PbPr_DC', 'class_PbPr_AC');

end
