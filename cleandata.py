import pandas as pd
import re

file_path = "C:\\Temp\\dbms_final\\KpopMerchDB_Product.csv"

data = pd.read_csv(file_path, encoding='latin1')
def keepOnlyEnglishAndNumbers(s):
    return re.sub(r'[^a-zA-Z0-9\s]', '', s)
data['product_name'] = data['product_name'].astype(str).apply(keepOnlyEnglishAndNumbers)

cleaned_file_path = "C:\\Temp\\dbms_final\\Cleaned_KpopMerchDB_Product.csv"

data.to_csv(cleaned_file_path, index=False, encoding='utf-8')
print("Succeed")
