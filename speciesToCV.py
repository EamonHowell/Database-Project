import csv

officialName = []
commonName = []
with open('speclist.txt', 'r') as in_file:
    line_list = in_file.readlines()
    for i in range(len(line_list)):
        if 'N=' in line_list[i] and 'C=' in line_list[i+1]:
            string1 = line_list[i]
            string2 = line_list[i+1]
            index = string1.index('N=')
            string = string1[index + 2:].strip()
            officialName.append(string)

            index = string2.index('C=')
            string = string2[index + 2:].strip()
            commonName.append(string)


with open('specList.csv', 'w') as out_file:
    for i in range(len(officialName)):
        line = [officialName[i], commonName[i]]
        write = csv.writer(out_file)
        write.writerow(line)
