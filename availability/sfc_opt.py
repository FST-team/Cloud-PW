class VNF:
    
    def __init__(self, conf: dict):
        self.conf = conf

class SFC:
    
    def __init__(self, vnf_list: list, av_list: list):
        if len(vnf_list) != len(av_list):
            raise Exception("Number of VNFs and availabilities do not match.")
        self.vnf_list = vnf_list
        self.av_list = av_list
        self.redundancies = [1 for _ in range(len(vnf_list))]
        
    def get_cost(self, costs: dict, vnf_conf: dict = None):
        if vnf_conf is None:
            # compute cost of the whole SFC
            cost = 0
            for i in range(len(self.vnf_list)):
                cost += self.get_cost(costs, self.vnf_list[i].conf) * self.redundancies[i]
        else:
            # compute cost of a single VNF
            cost = 0
            for resource in vnf_conf:
                cost += costs[resource] * vnf_conf[resource]
        return cost
    
    def get_availability(self, redundancies_list: list = None):
        if redundancies_list is None:
            redundancies_list = self.redundancies
        availability = 1
        for i in range(len(self.vnf_list)):
            availability *= (1- (1-self.av_list[i]) ** redundancies_list[i])
        return availability
    
    def __calculate_dp(self, i, a, vnf_list, availability_constraint, memo, max_replicas=10):
        # Base cases
        if i == len(vnf_list):
            return (0, []) if a >= availability_constraint else (float('inf'), [])
        
        if a <= 0:
            return (float('inf'), [])
        
        # Check if value is already calculated
        if (i, a) in memo:
            return memo[(i, a)]
        
        min_cost = float('inf')
        min_replicas = []
        
        # Explore different redundancies for VNF i
        for redundancy in range(1, max_replicas):  
            new_a = a * (1 - (1 - vnf_list[i]['availability']) ** redundancy)
            cost = vnf_list[i]['cost'] * redundancy
            
            # Recursively calculate minimum cost and replicas for the next VNF
            next_cost, next_replicas = self.__calculate_dp(i + 1, new_a, vnf_list, availability_constraint, memo)
            
            # Update min_cost and min_replicas if a better solution is found
            if cost + next_cost < min_cost:
                min_cost = cost + next_cost
                min_replicas = [redundancy] + next_replicas
        
        # Memoize the calculated value
        memo[(i, a)] = (min_cost, min_replicas)
        return (min_cost, min_replicas)

    def get_optimal_redundancy(self, costs, availability_constraint, max_replicas=10):
        vnf_list = [{'cost': self.get_cost(costs, self.vnf_list[i].conf), 'availability': self.av_list[i]} for i in range(len(self.vnf_list))]
        memo = {}
        result_cost, result_replicas = self.__calculate_dp(0, 1.0, vnf_list, availability_constraint, memo, max_replicas)
        print(memo)
        if result_cost != float('inf'):
            return result_cost, result_replicas
        else:
            return -1, []

if __name__ == '__main__':
    
    costs = {
        "CNT": 1,
        "DCK": 2,
        "VM": 2.5,
        "HYP": 2,
        "HW": 1.5
    }
    
    vnf_P = vnf_S = VNF({
        "CNT": 1,
        "DCK": 1,
        "VM": 1,
        "HYP": 1,
        "HW": 1
    })
    
    vnf_IH = VNF({
        "CNT": 6,
        "DCK": 2,
        "VM": 2,
        "HYP": 1,
        "HW": 1
    })
    
    avP = avS = 0.998259001
    avIH = 0.997671992
    
    sfc = SFC([vnf_P, vnf_S, vnf_IH], [avP, avS, avIH])
        
    print("Initial Cost: ", sfc.get_cost(costs))
    print("Initial Availability: ", sfc.get_availability())
    optimal_cost, optimal_redundancies = sfc.get_optimal_redundancy(costs, 0.99999)
    print("Optimal redundancies: ", optimal_redundancies)
    print("Optimal cost: ", optimal_cost)
    print("Optimal availability: ", sfc.get_availability(optimal_redundancies))