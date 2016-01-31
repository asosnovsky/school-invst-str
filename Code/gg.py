from scipy.spatial import distance
import numpy as np
import pandas as pd
from scipy.stats import chisquare

''' 
compute euclidean distance from anchor points 
target : 1-D array of target school variables 
anchor : N-D array of anchor points, where N = # of anchors 

'''
def euclid(targets,index_1):
    targ_np = targets.tolist()
    # temp
    anchor_test = pd.DataFrame(np.random.rand(4,2)+4, index = ['one','two','three','four'])
    
    #targ_np = [targ_np]
    #targ_np = [[1,1]]
    anch_list = []

    for index, row in anchor_test.iterrows():
        val = row.values.tolist()
        anch_list.append(val)
    
    #dist = distance.cdist(targ_np,anch_list,'euclidean')
        
    # score is found in min value of array, then find index, then take second
    # value of resulted array since it reutrns row, col
    
    #mini_euc = dist.min()
    #score_euc = np.where(dist == mini_euc)[1][0]

    #list_scores = [score_euc,mini_euc,index_1]
    
    # chi squared
    chi = []
    p = []
    for row in anch_list:
        chi_sum,p = chisquare(targ_np,f_exp = row,ddof = len(targ_np) - 1)
        chi.append(chi_sum)
        p.append(p)
        
    
    mini_chi = min(chi)
    score_chi = chi.index(mini_chi)
    
    
    list_scores_chi = [score_chi,chi,index_1]
    
    return list_scores_chi

'''

df = dataframe of all need to be classified schools and all variables

'''
    
def compute_scores(df):
    scores = []
    
    for index,row in df.iterrows():
        # remove school name column
        score = euclid(row.values,index)
        scores.append(score)
    
    #sorted(scores)
    
    return scores

def main():
    school_test = pd.DataFrame(np.random.rand(1,2)+10, index = ['a'])
    
    scores = compute_scores(school_test)
    print(scores)

if __name__ == "__main__":
    main()
    
    