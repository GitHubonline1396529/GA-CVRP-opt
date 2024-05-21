function plot_route(loc, route)
% PLOT_ROUTE - 可视化节点访问顺序，并在经过节点 0 时更换颜色
%    访问顺序将从 0 开始并在 0 结束，无论传入的访问顺序向量 route 的起始数字和结
%    束数字是几，该方法都会自动在前后添加从 0 开始和回到 0 的绘制过程。 
%
%    PLOT_ROUTE(loc, route)
%
%    输入参数
%        loc - 坐标点的坐标矩阵，每行表示一个节点的坐标 [x, y]
%        route - 节点访问顺序向量（从 0 开始的索引）

% 将节点索引从 0 开始转换为 1 开始
route = route + 1;

% 获取节点的数量
numNodes = size(loc, 1);

% 获取颜色列表（从 colormap 中获取）
colormap_name = 'lines'; % 可以选择其他 colormap，如 'parula', 'jet', 等
colorlist = colormap(colormap_name);
num_colors = size(colorlist, 1);
colorIndex = 1;

% 创建一个新图形窗口
figure;
hold on;

% 绘制节点
scatter(loc(:,1), loc(:,2), 'filled');
text( ...
    loc(:,1), loc(:,2), num2str((0:numNodes-1)'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','right');

% 绘制从起点 0 到第一个节点
firstNode = route(1);
plot( ...
    [loc(1, 1), loc(firstNode, 1)], ...
    [loc(1, 2), loc(firstNode, 2)], ...
    '-o', 'Color', colorlist(colorIndex, :));

% 连接节点，显示路径，并在经过节点 0 时更换颜色
for i = 1:length(route) - 1
    startNode = route(i);
    endNode = route(i + 1);
        
    % 如果经过节点 0，则更换颜色
    if startNode == 1 || endNode == 1
        colorIndex = mod(colorIndex, num_colors) + 1;
    end

    % 绘制路径
    plot( ...
        [loc(startNode, 1), loc(endNode, 1)], ...
        [loc(startNode, 2), loc(endNode, 2)], ...
        '-o', 'Color', colorlist(colorIndex, :));
end
    
% 从最后一个节点返回到起点 0
lastNode = route(end);
plot( ...
    [loc(lastNode, 1), loc(1, 1)], ...
    [loc(lastNode, 2), loc(1, 2)], ...
    '-o', 'Color', colorlist(colorIndex, :));

% 设置图形标题和标签
title('最优节点访问路径');
xlabel('X');
ylabel('Y');

% 设置图形的网格
grid on;
hold off;
end
