function new_pop = mutation( ...
    pop, pm, numCustomers, numVehicles, demands, capacity)
% MUTATION - 实现整数编码基因的交换变异操作
% 
%    new_pop = MUTATION( ...
%        pop, pm, numCustomers, numVehicles, demands, capacity)
%
%    输入参数
%        pop - 种群矩阵，每一行表示一个个体
%        pm - 变异概率
%        numCustomers - CVRP 问题中顾客节点的数量
%        numVehicles - CVRP 问题中运载工具的数量
%        demands - CVRP 问题中各个顾客节点的需求量的一维向量
%        capacity - CVRP 问题中运载工具的容量限制
% 
%    返回参数
%        new_pop - 交叉后的新种群矩阵

[num_individuals, num_genes] = size(pop);
new_pop = pop;

for i = 1:num_individuals
    for j = 1:num_genes
        if rand <= pm % 如果生成的均匀分布随机数小于一个
            % 随机选择另一个基因进行交换
            swap_idx = randi(num_genes);
            
            % 创建一个临时的试验个体，用 constrict 检验这个个体是否是可行解。
            % 限制仅当变异之后的个体是可行解的时候，变异才会发生。
            % 
            %     temp - 保存交换的基因点上的数字
            %     temp_individual - 保存用于测验的临时个体
            
            temp_individual = new_pop(i, :);
            temp = temp_individual(j);
            temp_individual(j) = temp_individual(swap_idx);
            temp_individual(swap_idx) = temp;
        
            if constrict(temp_individual, numCustomers, numVehicles, demands, capacity)
                % 执行交换操作
                temp = new_pop(i, j);
                new_pop(i, j) = new_pop(i, swap_idx);
                new_pop(i, swap_idx) = temp;
            end
        end
    end
end

end
