from sfc_opt import SFC, VNF
import pandas as pd

def build_csv(df, csv_path):
    
    with open(csv_path, 'w') as f:
        vnf_names = ["P-CSCF", "S-CSCF", "I-CSCF/HSS"]
        col_names = ["Configuration"] + vnf_names + ["Availability", "Cost"]

        f.write(" , ".join(col_names) + "\n")
        
        conf_str = "$RN_{}$"
        for i in range(len(df)):
            row = df.iloc[i]
            conf = conf_str.format(i+1)
            row_str = [conf] 
            vnf_redundancies = [str(x) for x in row['Redundancies']]
            row_str += vnf_redundancies
            row_str += [str(round(row['Availability'], 6)), str(row['Cost'])]
            f.write(" , ".join(row_str) + "\n")
            
def get_suboptimal_solutions_and_build_csv(sfc, costs, avs, csv_path, additional_configurations=[]):
    
    df = pd.DataFrame(columns=['Availability', 'Cost', 'Redundancies'])
    
    for av in avs:
        optimal_cost, optimal_redundancies = sfc.get_optimal_redundancy(costs, av)
        df.loc[len(df)] = [av, optimal_cost, optimal_redundancies]
    
    for add in additional_configurations:
        av, cost = sfc.get_availability_cost(costs, add)
        df.loc[len(df)] = [av, cost, add]
        
    df.drop_duplicates(subset=['Redundancies'], inplace=True)
    df.sort_values(by=['Cost'], inplace=True)
    
    build_csv(df, csv_path)

if __name__ == '__main__':
    
    # single - class
    
    costs = {
        "CNT": 1,
        "DCK": 2,
        "VM": 2.5,
        "HYP": 2,
        "HW": 1.5
    }
    
    vnf_P = VNF({
        "CNT": 1,
        "DCK": 1,
        "VM": 1,
        "HYP": 1,
        "HW": 1
    })
    
    vnf_S = VNF({
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
    
    additional_configurations = [
        [2, 2, 3],
        [3, 3, 2],
        [3, 2, 2]
    ]
    
    get_suboptimal_solutions_and_build_csv(sfc, costs, avs, 'availability/solutions/sc.csv', additional_configurations)
    
    # multi - class
    # C1
    
    vnf_S.set_container(4)
    vnf_IH.set_container(24)
    
    avP = 0.998259001
    avS = 0.998244349
    avIH = 0.997594466
    
    sfc = SFC([vnf_P, vnf_S, vnf_IH], [avP, avS, avIH])
    
    additional_configurations = [
        [2, 2, 3],
        [3, 3, 2],
        [2, 3, 2]
    ]
    
    get_suboptimal_solutions_and_build_csv(sfc, costs, avs, 'availability/solutions/mc_1.csv', additional_configurations)
    
    # multi - class
    # C2
    
    vnf_IH.set_container(21)
    
    avP = 0.998259001
    avS = 0.998244349
    avIH = 0.997607230
    
    sfc = SFC([vnf_P, vnf_S, vnf_IH], [avP, avS, avIH])
    
    additional_configurations = [
        [2, 2, 3],
        [3, 3, 2],
        [2, 3, 2]
    ]
    
    get_suboptimal_solutions_and_build_csv(sfc, costs, avs, 'availability/solutions/mc_2.csv', additional_configurations)
