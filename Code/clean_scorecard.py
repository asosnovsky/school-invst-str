import pandas as pd 

df_scorecard = pd.read_csv('Contest-Data/collegescorecard_data.csv',encoding='latin-1')

df_scorecard_norelig = df_scorecard[df_scorecard['RELAFFIL'].isnull()]

#df_medium_2year = df_scorecard_norelig[df_scorecard_norelig['CCSIZSET'] == 3]
#df_large_2year = df_scorecard_norelig[df_scorecard_norelig['CCSIZSET'] == 4]
#df_verylarge_2year = df_scorecard_norelig[df_scorecard_norelig['CCSIZSET'] == 5]

df_2year = df_scorecard_norelig[((df_scorecard_norelig['CCSIZSET'] >= 3) & (df_scorecard_norelig['CCSIZSET'] <= 5))]
#df_medium_4year = df_scorecard_norelig[(df_scorecard_norelig['CCSIZSET'] >= 12) & (df_scorecard_norelig['CCSIZSET'] <= 14)]
#df_large_4year = df_scorecard_norelig[(df_scorecard_norelig['CCSIZSET'] >= 15) & (df_scorecard_norelig['CCSIZSET'] <= 17)]

df_4year = df_scorecard_norelig[((df_scorecard_norelig['CCSIZSET'] >= 12) & (df_scorecard_norelig['CCSIZSET'] <= 17))]

df_spec = df_scorecard_norelig[(df_scorecard_norelig['CCSIZSET'] == 18) | (df_scorecard_norelig['CCSIZSET'].isnull())]

frames = [df_2year, df_4year,df_spec]

result = pd.concat(frames)

df_cert = result[result['PREDDEG'] == 1]
df_ass = result[result['PREDDEG'] == 2]
df_bac = result[result['PREDDEG'] == 3]
df_gra = result[result['PREDDEG'] == 4]

df_cert.to_csv('Analyzed-Data/CS_cert.csv')
df_ass.to_csv('Analyzed-Data/CS_ass.csv')
df_bac.to_csv('Analyzed-Data/CS_bac.csv')
df_gra.to_csv('Analyzed-Data/CS_gra.csv')
