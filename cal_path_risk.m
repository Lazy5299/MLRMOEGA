% 计算路径摔倒率函数
function [path_risk,risk] = cal_path_risk(pop, x, maprisk)
[n, ~] = size(pop);
risk = ones(1, n);
limit=x*10;
for i = 1 : n
    pathsafety=1;
    single_pop = pop{i, 1};
    [~, m] = size(single_pop);
    for j = 1 : m - 1
        % 点i所在列（从左到右编号1.2.3...）
        x_now = mod(single_pop(1, j), x) + 1; 
        % 点i所在行（从上到下编号行1.2.3...）
        y_now = fix(single_pop(1, j) / x) + 1;
        % 点i+1所在列、行
        x_next = mod(single_pop(1, j + 1), x) + 1;
        y_next = fix(single_pop(1, j + 1) / x) + 1;
        if abs(x_now - x_next) + abs(y_now - y_next) == 1
            pathsafety =pathsafety*(1-maprisk(x_now,y_now));
        else
            pathsafety =pathsafety*(1-sqrt(2)*maprisk(x_now,y_now));
       end
    risk(1, i)=(1-pathsafety);  
    end
end
% path_risk=(risk*100)-(90*ones(1, n));  %摔倒率最后基本都为0.99...导致区分度太小，所以乘100-99，得到百分位以后的小数数据
% path_risk=mapminmax(path_risk,1,limit);
% path_risk=mapminmax(path_risk,1,10);
path_risk=log(((risk*100)-(35*ones(1, n)))*10); %摔倒率最后基本都为0.99...导致区分度太小，所以乘100-99，得到百分位以后的小数数据，再乘10取ln
