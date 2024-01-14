from sfc_opt import SFC, VNF
import pandas as pd
import os

if __name__ == '__main__':
    
    # single - class
    
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
    
    avs = [0.999999, 0.99999, 0.9999, 0.999, 0.99]
    
    df = pd.DataFrame(columns=['Availability', 'Cost', 'Redundancies'])
    
    for av in avs:
        optimal_cost, optimal_redundancies = sfc.get_optimal_redundancy(costs, av)
        df.loc[len(df)] = [av, optimal_cost, optimal_redundancies]
    
    additional_configurations = [
        [2, 2, 3],
        [3, 3, 2],
        [3, 2, 2]
    ]
    
    for add in additional_configurations:
        av, cost = sfc.get_availability_cost(costs, add)
        df.loc[len(df)] = [av, cost, add]
        
    df.drop_duplicates(subset=['Redundancies'], inplace=True)
    df.sort_values(by=['Cost'], inplace=True)
    
    os.chdir('availability') if os.getcwd().split('/')[-1] != 'availability' else None
    df.to_csv('solutions/sc.csv', index=False)
    
    # multi - class
    # C1
    
    