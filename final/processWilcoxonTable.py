import pandas as pd
import collections
import numpy as np

if __name__ == '__main__':
	pData = pd.read_csv('wilcoxonTable.csv')
	pData = pData.truncate(after=96) # Only process n=4 to n=100
	columnName = []
	rowName = []
	originalRowNumber = pData.shape[0]
	originalColumnNumber = pData.shape[1]

	# Make hash table for the row names
	HashMap = dict()
	for r in pData.iterrows():
		for idx in range(1,originalColumnNumber):
			if r[1][idx] in HashMap:
				continue
			else:
				HashMap[r[1][idx]] = 0

	# Sort the hash map using key value
	# The outcome is dict{(rowName, index)}. For example: (3114.0, 3074) -> Wilcoxon rValue is 3114, and is at row #3074
	sortedHashMap = collections.OrderedDict(sorted(HashMap.items()))
	count = 0
	for k, v in sortedHashMap.items():
		sortedHashMap[k] = count
		count += 1
	rowName = list(sortedHashMap.keys())
	# sortedHashMap = {value:key for key, value in sortedHashMap.items()}

	# Create the numpy array for the result csv. Enter the first column value.
	outputData = np.full((len(rowName),originalRowNumber+1), -1, dtype=float) # outputData.shape is (3168, 98)
	for r in range(0,outputData.shape[0]):
		outputData[r,0] = rowName[r]


	count = 1
	for r in pData.iterrows():
		columnName.append(r[1][0])
		prev, current, rowNum = 0, 0, 0
		for i in range(1,originalColumnNumber):
			current = r[1][i]
			# special process the last column
			if i == originalColumnNumber-1:
				rowNum = sortedHashMap[current]
				outputData[int(rowNum), count] = (i-1)/1000
				continue
			# use the roof r value to get p value
			if current != prev:
				rowNum = sortedHashMap[prev]
				outputData[int(rowNum), count] = (i-2)/1000
			prev = current
		count = count+1

	# Fill in the -1 sluts with the upper bound value
	for c in range(1, outputData.shape[1]):
		prev = 1.0
		for r in range(outputData.shape[0]-1, 0, -1):
			if outputData[r,c] == -1.0:
				outputData[r,c] = prev
			else:
				prev = outputData[r,c]

	# output the csv file
	NewWilcoxonTable = pd.DataFrame(outputData, columns = ([-1]+columnName))
	NewWilcoxonTable.to_csv('NewWilcoxonTable.csv', index=False)