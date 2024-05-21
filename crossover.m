function new_pop = crossover( ...
    pop, pc, numCustomers, numVehicles, demands, capacity)
% CROSSOVER - 遗传算法中包含约束检验的单点交叉操作
%
%    输入参数
%        pop - 种群矩阵，每一行表示一个个体
%        pc - 交叉概率
%        numCustomers - CVRP 问题中顾客节点的数量
%        numVehicles - CVRP 问题中运载工具的数量
%        demands - CVRP 问题中各个顾客节点的需求量的一维向量
%        capacity - CVRP 问题中运载工具的容量限制
% 
%    返回参数
%        new_pop - 交叉后的新种群矩阵

[num_individuals, num_genes] = size(pop);
new_pop = pop;

% 以步长为 2 遍历整个种群，以便实现各个个体的两两交叉操作
for i = 1:2:num_individuals-1
    if rand <= pc
        % 随机选择交叉点
        cpoint = randi([1, num_genes-1]);

        % 设置两个中间变量，用于约束检验
        temp_pop = pop(i:i+1, :);
        temp_pop(1, cpoint+1:end) = pop(i+1, cpoint+1:end);
        temp_pop(2, cpoint+1:end) = pop(i, cpoint+1:end);

        if constrict( ...
                temp_pop(1, :), numCustomers, numVehicles, ...
                demands, capacity)
            if constrict( ...
                    temp_pop(2, :), numCustomers, numVehicles, ...
                    demands, capacity)
                % 进行交叉
                new_pop(i, cpoint+1:end) = pop(i+1, cpoint+1:end);
                new_pop(i+1, cpoint+1:end) = pop(i, cpoint+1:end);
            end
        end
    end
end

end
