import os
from glob import glob
PATH="../"
outputFilesResults = [y for x in os.walk(PATH) for y in glob(os.path.join(x[0], 'output.tf'))]
mainFileResults = [y for x in os.walk(PATH) for y in glob(os.path.join(x[0], 'main.tf'))]
outputInUse = False

for outputFileResult in outputFilesResults:
    with open(outputFileResult) as of:
        outputFile = of.readlines()
    for line in outputFile:
        if line.startswith('output'):
            # print(line.split()[1].replace('\'', '').replace('\"', ''))
            output = line.split()[1].replace('\'', '').replace('\"', '')
            for mainFileResult in mainFileResults:
                with open(mainFileResult) as mf:
                    mainFile = mf.readlines()
                for mainFileLine in mainFile:
                    if output in mainFileLine:
                        # print(mainFileResult, " contains ", output)
                        outputInUse = True
                        break
                    else:
                        outputInuse = False
                if not outputInUse:
                    print(mainFileResult, "does not contain ", output)
                

            # print(line)
            # print(outputFileResult)

# print(result)