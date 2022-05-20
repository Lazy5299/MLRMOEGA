% ����·������ʱ�亯��
function [path_time,time] = cal_path_time(pop, x, mapspeed)
[n, ~] = size(pop);
time = zeros(1, n);
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
            time(1, i) = time(1, i) + 1*mapspeed(x_now,y_now);
        else
            time(1, i) = time(1, i) + sqrt(2)*mapspeed(x_now,y_now) ;
        end
    end
end
% path_time=mapminmax(time,1,limit);
% path_time=mapminmax(time,1,10);
path_time=log(time);