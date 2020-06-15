function decimal = bin2signed (bin)
    
    if bin(1, 1) == 1;
        s = num2str(bin);
        s(isspace(s)) = '';
        decimal = bin2dec(s);
    else
        inv_bin = bin;
        inv_bin(inv_bin==1) = 2;
        inv_bin(inv_bin==0) = 1;
        inv_bin(inv_bin==2) = 0;
        s = num2str(inv_bin);
        s(isspace(s)) = '';
        decimal = (-1)* (bin2dec(s));
    end

end
