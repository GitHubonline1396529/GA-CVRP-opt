function initial_pop = initialize_pop(numCustomers, numVehicles, popSize)
% INITIALIZE_POP - 为遗传算法解决 CVRP 问题初始化种群
%    输入问题的基本参数，返回一个经过初始化的种群。需要注意的是，由于在创建初始化
%    种群的过程中，没有对产生个体的条件进行约束，可能会产生不符合模型约束的不合法
%    个体。这个问题将会在第一轮循环时通过将非法个体的适应度函数值设置为 0 被修正
%    且实践证明这种方法是可行的。
% 
%    initial_pop = initialize_pop(numCustoms, numVehicles, popSize)
% 
%    输入参数
%        numCustomers - CVRP 问题中顾客节点的数量
%        numVehicles - CVRP 问题中运载工具的数量
%        popSize - 种群的大小
%
%    返回参数
%        initial_pop - 一个经过初始化的始祖种群

initial_pop = zeros(popSize, (numCustomers + (numVehicles - 1)));

    for i = 1:popSize % 遍历种群长度
      individual = randperm(numCustomers);
      individual = assign_vehicles(individual, numVehicles);
      initial_pop(i, :) = individual;
    end
end

