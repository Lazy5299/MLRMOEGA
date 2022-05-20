% ����·��ˤ���ʺ���
function [path_risk,risk] = cal_path_risk(pop, x, maprisk)
[n, ~] = size(pop);
risk = ones(1, n);
limit=x*10;
for i = 1 : n
    pathsafety=1;
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
            pathsafety =pathsafety*(1-maprisk(x_now,y_now));
        else
            pathsafety =pathsafety*(1-sqrt(2)*maprisk(x_now,y_now));
       end
    risk(1, i)=(1-pathsafety);  
    end
end
% path_risk=(risk*100)-(90*ones(1, n));  %ˤ������������Ϊ0.99...�������ֶ�̫С�����Գ�100-99���õ��ٷ�λ�Ժ��С������
% path_risk=mapminmax(path_risk,1,limit);
% path_risk=mapminmax(path_risk,1,10);
path_risk=log(((risk*100)-(35*ones(1, n)))*10); %ˤ������������Ϊ0.99...�������ֶ�̫С�����Գ�100-99���õ��ٷ�λ�Ժ��С�����ݣ��ٳ�10ȡln
