function [index] = getIndCell(c,x)
for i = 1:length(c)
    if isequal(x,c{i})
        index = i;
        return;
    end
end
index = -1;
return;