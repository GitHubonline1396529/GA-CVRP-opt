function total_distance = calculate_total_distance(dis_matrix, individual)
% CALCULATE_TOTAL_DISTANCE 计算从节点 0 开始，按顺序经过所有节点并回到节点 0 的
%    总距离。该函数用于计算遗传算法解决 CVRP 问题的适应度函数。
%    
%    total_distance = CALCULATE_TOTAL_DISTANCE(od_matrix, individual)
%
%    输入参数
%        dis_matrix - n x n 的距离矩阵，表示各个节点间的距离
%        individual - 一维数组，表示访问节点的顺序
%
%    返回参数
%        total_distance - 总距离

% 初始化总距离
total_distance = 0;

% 当前节点从 0 开始
current_node = 0;

% 遍历 individual 数组中的每个节点
for i = 1:length(individual)
    next_node = individual(i);
    % 累加从 current_node 到 next_node 的距离 
    % 由于在距离矩阵中第一行第一列代表的是 CVRP 问题的仓库 Depot 的坐标，因此需
    % 对行列索引各自加上 1 跳过第一行第一列
    total_distance = total_distance + dis_matrix( ...
        current_node + 1, next_node + 1);
    % 更新当前节点为下一个节点
    current_node = next_node;
end

% 最后从最后一个节点回到节点 0
total_distance = total_distance + dis_matrix(current_node + 1, 1);

end
