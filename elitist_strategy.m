%精英策略
function [elite_pop,new_pop1,elite_fit_value,maxquantity] = elitist_strategy(new_pop1,fit_value)
max_fit_value = max(fit_value);
max_index_list = find(fit_value==max_fit_value);
maxquantity=size(max_index_list);
% elite_pop = new_pop1(max_index);
elite_pop = new_pop1(max_index_list);
elite_fit_value = max_fit_value;

