from pandas import DataFrame

def from_list_to_string(column : DataFrame)-> DataFrame:
        return (lambda x: x[0])(column)
    
def columns_from_list_to_string(df : DataFrame, list_columns : list)-> DataFrame:
        for column in list_columns:
            df[column] = from_list_to_string(df[column])
        return df
    
def remove_duplicated_lines(df : DataFrame)-> DataFrame:
        df = df.drop_duplicates().reset_index()
        return df.drop(columns =['index'])