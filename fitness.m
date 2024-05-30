function fitnessValues = fitness( ...
    pop, Dis_mat, numCustomers, numVehicles, demands, capacity)
% FITNESS 遗传算法解决 VRP 问题的适应度函数计算
%    以列向量的形式返回每一个个体的适应度函数值。在本方法中，使用距离的倒数作为适
%    应度值，从而实现在 VRP 问题中最小化函数目标。
% 
%    fitnessValues = fitness( ...
%         pop, OD_mat, numCustomers, numVehicles, demands, capacity)
%    
%    输入参数
%        pop - 当前的种群矩阵
%        Dis_mat - VRP 问题中所有节点的距离矩阵
%        numCustomers - VRP 问题中顾客节点的数量
%        numVehicles - VRP 问题中运载工具的数量
%
%    输出参数
%        fitnessValues - 一个列向量，包含每个个体的适应度函数值

[popSize, ~] = size(pop); % 只需要获得行数，用 ~ 代替后一个输出变量

fitnessValues = zeros(popSize, 1);

for i = 1 : popSize
    total_dist = calculate_total_distance(Dis_mat, pop(i, :));
    fitnessValues(i, 1) = 1 / total_dist;

    % 模型的约束检验
    if ~constrict(pop(i, :), numCustomers, numVehicles, demands, capacity)
        fitnessValues(i, 1) = 0;
    end
end

end