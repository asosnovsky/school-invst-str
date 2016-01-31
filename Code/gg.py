from scipy.spatial import distance
import numpy as np
import pandas as pd
from scipy.stats import chisquare,chisqprob

''' 
compute euclidean distance from anchor points 
target : 1-D array of target school variables 
anchor : N-D array of anchor points, where N = # of anchors 

'''
def euclid(targets,index_1):
    targ_np = targets.tolist()
    # targ_np = school_test.iloc[3,2:]
    # temp
    anchor = pd.read_csv('3-cleaned-data-top10.csv').iloc[:,2:]
    
    targ_np = [targ_np]
    #targ_np = [[1,1]]
    anch_list = []

    for index, row in anchor.iterrows():
        val = row.values.tolist()
        anch_list.append(val)
    
    dist = distance.cdist(targ_np,anch_list,'euclidean')
        
    # score is found in min value of array, then find index, then take second
    # value of resulted array since it reutrns row, col
    
    mini_euc = dist.min()
    score_euc = np.where(dist == mini_euc)[1][0]

    list_scores = [score_euc,mini_euc,index_1]
    
    # chi squared
    chi = []
    pval = []
    for row in anch_list:
        chi_sum, p = chisquare(targ_np,f_exp = row,ddof = len(targ_np) - 1)
        pvalc = chisqprob(chi_sum, len(targ_np) - 1)
        chi.append(chi_sum)
        pval.append(pvalc)
        
    
    #mini_chi = min(chi)
    #score_chi = chi.index(mini_chi)

    
    #list_scores_chi = [score_chi,mini_chi,index_1,pval]
    
    return list_scores

'''

df = dataframe of all need to be classified schools and all variables

'''
    
def compute_scores(df):
    scores = []
    
    for index,row in df.iterrows():
        name = row[1]
        score = euclid(row[2:].values,name)
        scores.append(score)
    
    #sorted(scores)
    
    return scores
    
def remove_donations(donations,file_to_clean):
    
    for index,row in donations.iterrows():
        file_to_clean = file_to_clean[~file_to_clean['INSTNM'].str.contains(row[0])]
    
    return file_to_clean    

def main():
    #school_test = pd.read_csv('3-cleaned-data.csv')
    donations = pd.read_csv('donations_names.csv')

    #scores = sorted(compute_scores(school_test))
    #df = pd.DataFrame(scores,columns=['Class','Distance','Name'])
    #df = pd.DataFrame(scores,columns=['Class','Distance','P-Value','Name'])
    #df.to_csv('3-cleaned-data-chosen_chi.csv')
    
    df_1 = pd.read_csv('3-cleaned-data.csv')
    
    df = remove_donations(donations,df_1)
    
    print(df)

if __name__ == "__main__":
    main()
    
    