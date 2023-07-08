from docplex.cp.expression import CpoIntVar, CpoFunctionCall
import re

def extract_solution(df_, mdl, msol, drop:bool=True ):
    df = df_.copy()

    Solution_Dict = {}
    for i in mdl.get_all_variables():
        Solution_Dict[i.name]= str(msol.get_value(i))


    def multiple_replace(adict, text):
        # Create a regular expression from all of the dictionary keys
        regex = re.compile("|".join(map(re.escape, adict.keys(  ))))
        # For each match, look up the corresponding value in the dictionary
        return regex.sub(lambda match: adict[match.group(0)], text)



    types = [type(i) for i in df.iloc[0].values]
    #print(types)

    evaluated_columns = []
    for column in  df.columns:
        column_type = type(df[column].iloc[0])  
        #print(column, column_type)
         
        if column_type == CpoIntVar:
            df[column+"_Solution"]= df[column].apply(lambda x:  int(Solution_Dict[x.name] )  )          #.apply(lambda x:msol.get_value(x) )
            evaluated_columns.append(column)

        if column_type == CpoFunctionCall:
            df[column+"_Solution"] =  df[column].apply(lambda x: int ( eval (   multiple_replace(Solution_Dict, str(x))  )) )
            evaluated_columns.append(column)

    if drop == True:
        df.drop(evaluated_columns, axis=1, inplace=True)


        
    return df




# def extract_solution(msol, df, extract_dvar_names=None, drop_column_names=None, drop:bool=True):
#     df = df.copy()
#     """Generalized routine to extract a solution value. 
#     Can remove the dvar column from the df to be able to have a clean df for export into scenario."""
#     if extract_dvar_names is not None:
#         for xDVarName in extract_dvar_names:
#             if xDVarName in df.columns:
#                 df[f'{xDVarName}_Solution'] = [msol.get_value(dvar)   for dvar in df[xDVarName]]  #dvar.solution_value
#                 if drop:
#                     df = df.drop([xDVarName], axis = 1)
#     if drop and drop_column_names is not None:
#         for column in drop_column_names:
#             if column in df.columns:
#                 df = df.drop([column], axis = 1)
#     return df   