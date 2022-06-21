function [inflection] = find_inflection(min_path,x)
%FIND_INFLECTION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
inflection=[];
inflection_num=1;
[~, m] = size(min_path);
for j = 1 : m - 2
     % ��i�����У������ұ��1.2.3...��
     x_now = mod(min_path(1, j), x) + 1; 
     % ��i�����У����ϵ��±����1.2.3...��
     y_now = fix(min_path(1, j) / x) + 1;
     % ��i+1�����С���
     x_next1 = mod(min_path(1, j + 1), x) + 1;
     y_next1 = fix(min_path(1, j + 1) / x) + 1;
     % ��i+2�����С���
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

