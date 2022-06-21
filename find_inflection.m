function [inflection] = find_inflection(min_path,x)
%FIND_INFLECTION 此处显示有关此函数的摘要
%   此处显示详细说明
inflection=[];
inflection_num=1;
[~, m] = size(min_path);
for j = 1 : m - 2
     % 点i所在列（从左到右编号1.2.3...）
     x_now = mod(min_path(1, j), x) + 1; 
     % 点i所在行（从上到下编号行1.2.3...）
     y_now = fix(min_path(1, j) / x) + 1;
     % 点i+1所在列、行
     x_next1 = mod(min_path(1, j + 1), x) + 1;
     y_next1 = fix(min_path(1, j + 1) / x) + 1;
     % 点i+2所在列、行
     x_next2 = mod(min_path(1, j + 2), x) + 1;
     y_next2 = fix(min_path(1, j + 2) / x) + 1;
     % cos A=(b?+c?-a?)/2bc
     b2 = (x_now - x_next1)^2 + (y_now - y_next1)^2;
     c2 = (x_next2 - x_next1)^2 + (y_next2 - y_next1)^2;
     a2 = (x_now - x_next2)^2 + (y_now - y_next2)^2;
     cosa = (c2 + b2 - a2) / (2 * sqrt(b2) *  sqrt(c2));
     angle = acosd(cosa);
     if angle == 45 || angle == 135 || angle == 225 || angle == 315
         inflection(inflection_num,1)=x_next1;
         inflection(inflection_num,2)=y_next1;
         inflection_num=inflection_num+1;
     end
end
end

