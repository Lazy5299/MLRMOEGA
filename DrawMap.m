%���������ϰ����դ���ͼ
%������1�����ɫդ��

function M = DrawMap(M)
b = M;
b(end+1,end+1) = 0;
    map=[1 1 1;  %��
        0 0 1;   %��
        1 0 1;   %Ʒ��
        0 1 1;   %��
        1 0 0;   %��
        1 1 0;   %��
        0.46667 0.53333 0.6      %LightSlateGray 
        0.41176 0.41176 0.41176  %DimGrey
        0 0.74902 1              %DeepSkyBlue
        0 1 0];  %��
    colormap(map);
pcolor(0.5:size(M,2) + 0.5, 0.5:size(M,1) + 0.5, b); % ����դ����ɫ
set(gca, 'XTick', 1:size(M,1), 'YTick', 1:size(M,2));  % ��������
axis image xy;  % ��ÿ��������ʹ����ͬ�����ݵ�λ������һ��