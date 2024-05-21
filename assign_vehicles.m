function modified_individual = assign_vehicles(individual, numVehicles)
% ASSIGN_VEHICLES 用于遗传算法解决 CVRP 问题的过程中对给出的节点访问顺序给出指派
%    即在给定的数组 individual 中间插入 (numVehicles - 1) 个 0
%
%    modified_individual = ASSIGN_VEHICLES(individual, numVehicles)
%
%    输入参数
%        individual - 一维数组
%        numVehicles - 一个整数，表示需要插入的 0 的个数 + 1
%
%    返回参数
%        modified_individual - 插入 0 之后的数组

% 计算需要插入的 0 的个数
numZeros = numVehicles - 1;

% 获取原数组的长度
len = length(individual);

% 检查是否可以插入 0
if numZeros > len - 2
    error('插入的 0 的数量过多，无法在数组中间部分插入。');
end

% 随机生成插入位置（不包括数组的最前面和最后面）
insert_positions = randperm(len - 2, numZeros) + 1;

% 初始化新的数组
modified_individual = individual;

% 插入 0
for i = 1:numZeros
    % 通过切片的方式，索引原始数组在插入 0 位置的前半部分和后半部分
    modified_individual = [ ...
        modified_individual(1:insert_positions(i)-1), ...
        0, modified_individual(insert_positions(i):end)];
    % 更新插入位置索引，以适应已插入的 0
    insert_positions = insert_positions + 1;
end

end


