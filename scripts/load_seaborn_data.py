import seaborn as sns

# Load a dataset from seaborn's built-in datasets
df = sns.load_dataset("tips")

print("Dataset: tips")
print(f"Shape: {df.shape}")
print("\nFirst 5 rows:")
print(df.head())
print("\nBasic statistics:")
print(df.describe())
