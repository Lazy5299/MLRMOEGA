%创建具有障碍物的栅格地图
%矩阵中1代表黑色栅格

function M = DrawMap(M)
b = M;
b(end+1,end+1) = 0;
    map=[1 1 1;  %白
        0 0 1;   %蓝
        1 0 1;   %品红
        0 1 1;   %黑
        1 0 0;   %红
        1 1 0;   %黄
        0.46667 0.53333 0.6      %LightSlateGray 
        0.41176 0.41176 0.41176  %DimGrey
        0 0.74902 1              %DeepSkyBlue
        0 1 0];  %绿
    colormap(map);
pcolor(0.5:size(M,2) + 0.5, 0.5:size(M,1) + 0.5, b); % 赋予栅格颜色
set(gca, 'XTick', 1:size(M,1), 'YTick', 1:size(M,2));  % 设置坐标
axis image xy;  % 沿每个坐标轴使用相同的数据单位，保持一致