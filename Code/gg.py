from scipy.spatial import distance
import numpy as np
import pandas as pd
from scipy.stats import chisquare, chisqprob

'''
compute euclidean distance from anchor points
target : 1-D array of target school variables
anchor : N-D array of anchor points, where N = # of anchors
'''


def euclid(targets, index_1, anch_list):

    #targ_np = targets.tolist()
    #targ_np = school_test.iloc[3,2:]
    # temp
    #targ_np_norm = [(num - min(targ_np))/(max(targ_np)-min(targ_np)) for num in targ_np]

    targ_np = [targets]

    dist = distance.cdist(targ_np, anch_list, 'euclidean')

    # score is found in min value of array, then find index, then take second
    # value of resulted array since it reutrns row, col

    mini_euc = dist.min()
    score_euc = np.where(dist == mini_euc)[1][0]

    list_scores = [score_euc, mini_euc, index_1]
    
    return list_scores

'''
compute chi-square test from anchor points
target : 1-D array of target school variables
anchor : N-D array of anchor points, where N = # of anchors
'''


def chi_square(targets, index_1, anchor):

    chi = []
    pval = []

    for row in anch_list:
        chi_sum, p = chisquare(
            targ_np_norm, f_exp=row, ddof=len(targ_np_norm) - 1)
        pvalc = chisqprob(chi_sum, len(targ_np_norm) - 1)
        chi.append(chi_sum)
        pval.append(pvalc)

    mini_chi = min(chi)
    score_chi = chi.index(mini_chi)

    list_scores = [score_chi, mini_chi, index_1, pval]

    return list_scores


'''

df_compute = dataframe of all need to be classified schools and all variables

'''


def compute_scores(df_tocompute):

    scores = []
    norm = []
    rad = []

    anchor = pd.read_csv('Analyzed-Data/benchmarks/1-cleaned-data-top10.csv').iloc[:, 2:]
    anch_list = []

    for index, row in anchor.iterrows():
        val = row.values.tolist()
        val_norm = [(num - min(val))/(max(val)-min(val)) for num in val]
        anch_list.append(val_norm)

    for index, row in df_tocompute.iterrows():
        ide = [row[0]]
        name = [row[1]]
        targ_np_norm = [(num - min(row[2:]))/(max(row[2:])-min(row[2:])) for num in row[2:]]
        score = euclid(targ_np_norm, name, anch_list)
        scores.append(score + ide)
        norm.append(ide+name+targ_np_norm)

    df_norm = pd.DataFrame(norm,columns = df_tocompute.columns.values.tolist())
    df_norm.to_csv('Analyzed-Data/normed_filtered_data/normed-1-cleaned-data.csv')
    
    

    # sorted(scores)

    return scores


def remove_donations(donations, file_to_clean):

    for index, row in donations.iterrows():
        file_to_clean = file_to_clean[
            ~file_to_clean['INSTNM'].str.contains(row[0])]

    return file_to_clean
    
def radius(df_k):
    
    scale = 3
    knn_rad = []
    
    df_knn = df_k.drop('Unnamed: 0',1)
    
    for i in range(0,10):
        df_knn_part = df_knn[df_knn['Class'] == i]
        mu = df_knn_part['Distance'].mean()
        std = df_knn_part['Distance'].std()
        df_knn_part = df_knn_part[(df_knn_part['Distance'] - mu) / (std) < scale]
        knn_rad.append(df_knn_part)
    
    df_knn_rad = pd.concat(knn_rad)
    #df_knn_rad = pd.DataFrame(knn_rad,columns = df_knn.columns.values.tolist())
    
    return df_knn_rad


def main():
    school_test = pd.read_csv('Analyzed-Data/filtered/1-cleaned-data.csv')
    #donations = pd.read_csv('External-data/microsoft_donations.csv')
    #normed_school_test = pd.read_csv('Analyzed-Data/normed_filtered_data/normed-1-cleaned-data.csv')
    scores = sorted(compute_scores(school_test))

    #df = pd.DataFrame(scores, columns=['Class', 'Distance', 'Name', 'ID'])
    #df = pd.DataFrame(scores,columns=['Class','Distance','P-Value','Name'])
    #df.to_csv('Analyzed-Data/knn_chosen/tot-cleaned-data-chosen.csv')

    
    rad = radius(pd.read_csv('Analyzed-Data/knn_chosen/tot-cleaned-data-chosen.csv'))
    rad.to_csv('Analyzed-Data/sensitivity_analysis/three_std/tot-cleaned-data-chosen.csv')
    
    print(rad)

    #df_1 = pd.read_csv('tot-cleaned-data.csv')

    #df = remove_donations(donations,df_1)

if __name__ == "__main__":
    main()
