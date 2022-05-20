% ����·�����ĺ���
function [path_cost,cost] = cal_path_cost(pop, x, mapdata)
[n, ~] = size(pop);
cost = zeros(1, n);
limit=x*10;
for i = 1 : n
    single_pop = pop{i, 1};
    [~, m] = size(single_pop);
    for j = 1 : m - 1
        % ��i�����У������ұ��1.2.3...��
        x_now = mod(single_pop(1, j), x) + 1; 
        % ��i�����У����ϵ��±����1.2.3...��
        y_now = fix(single_pop(1, j) / x) + 1;
        % ��i+1�����С���
        x_next = mod(single_pop(1, j + 1), x) + 1;
        y_next = fix(single_pop(1, j + 1) / x) + 1;
        if abs(x_now - x_next) + abs(y_now - y_next) == 1
            cost(1, i) = cost(1, i) + 1*mapdata(x_now,y_now);
        else
            cost(1, i) = cost(1, i) + sqrt(2)*mapdata(x_now,y_now) ;
        end
    end
end
% path_cost=mapminmax(cost,1,limit);
% path_cost=mapminmax(cost,1,10);
path_cost=log(cost);