% ����·��ƽ���Ⱥ�����ƽ���Ⱥ����в�û�о���ĽǶ���Ϣ��ֻ�гͷ���Ϣ
function [path_smooth,totalangle] = cal_path_smooth(pop, x)
[n, ~] = size(pop);
pathsmooth = ones(1, n)*5;
totalangle = zeros(1,n);
limit=x*10;
for i = 1 : n
    single_pop = pop{i, 1};
    [~, m] = size(single_pop);
    for j = 1 : m - 2
        % ��i�����У������ұ��1.2.3...��
        x_now = mod(single_pop(1, j), x) + 1; 
        % ��i�����У����ϵ��±����1.2.3...��
        y_now = fix(single_pop(1, j) / x) + 1;
        % ��i+1�����С���
        x_next1 = mod(single_pop(1, j + 1), x) + 1;
        y_next1 = fix(single_pop(1, j + 1) / x) + 1;
        % ��i+2�����С���
        x_next2 = mod(single_pop(1, j + 2), x) + 1;
        y_next2 = fix(single_pop(1, j + 2) / x) + 1;
        % cos A=(b?+c?-a?)/2bc
        b2 = (x_now - x_next1)^2 + (y_now - y_next1)^2;
        c2 = (x_next2 - x_next1)^2 + (y_next2 - y_next1)^2;
        a2 = (x_now - x_next2)^2 + (y_now - y_next2)^2;
        cosa = (c2 + b2 - a2) / (2 * sqrt(b2) *  sqrt(c2));
        angle = acosd(cosa);
        radangle=deg2rad(angle);
        
        %����ÿ��·���ܵ��۽Ǵ�С
        totalangle(1,i) = totalangle(1,i) + (pi-radangle);
        
        %�ԽǶȽϴ��ʩ�ӳͷ�
        if angle < 170 && angle > 91     
            pathsmooth(1, i) = pathsmooth(1, i) + 10; %�۽Ǽӽ�С�ͷ�
        elseif angle <= 91 && angle > 46
            pathsmooth(1, i) = pathsmooth(1, i) + 30;  %�е����
        elseif angle <= 46 && angle>=0
            pathsmooth(1, i) = pathsmooth(1, i) + 90;   %С��ǼӴ�ͷ�
        else
            pathsmooth(1, i) = pathsmooth(1, i) + 5;
        end
    end
end
% path_smooth=mapminmax(pathsmooth,1,limit);
% path_smooth=mapminmax(pathsmooth,1,10);
path_smooth=log(pathsmooth);
