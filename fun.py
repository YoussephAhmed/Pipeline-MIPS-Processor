import decimal 
def listMaker(string):
    x = string.replace("("," ")
    y = x.replace(")"," ")
    z = y.replace(","," ")
    result = z.split()
    return result
def desReg(x):
    allInone = []
    Destination_Reg = []
    for i in x:
        allInone = allInone + listMaker(i)
    num = len(allInone)
    nim = 0
    while(nim < num):
        if (allInone[nim] == 'add' or allInone[nim] == 'sub' or allInone[nim] == 'and' or allInone[nim] == 'sll' or allInone[nim] == 'or' or allInone[nim] == 'jr' ):
            Destination_Reg.append(allInone[nim+1])
        elif (allInone[nim] == 'addi' or allInone[nim] == 'lw' or allInone[nim] == 'andi' or allInone[nim] == 'sw' or allInone[nim] == 'ori' or allInone[nim] == 'beq' or allInone[nim] == 'bne'):
            Destination_Reg.append(allInone[nim+1])
        elif (allInone[nim] == 'j' or allInone[nim] == 'jal'):
            Destination_Reg.append(allInone[nim+1])
        nim = nim + 1
    return(Destination_Reg)
## This Function return all data readed from file ##
def ReadFile(fileName):
    readFile = open(fileName , 'r').readlines()
    return(readFile)

def StringToBin(number):
    intNum = int(number)
    binaryValue = bin(intNum)
    complement = ""
    binaryVAL = ""
    FinalVAL = ""
    k = len(binaryValue)
    if(intNum > 0):
        for i in range (2 , k):
            binaryVAL = binaryVAL + binaryValue[i]
        le = len(binaryVAL)    
        for i in range (le , 16):
            FinalVAL = FinalVAL + '0'
        FinalVAL = FinalVAL + binaryVAL   
        return(FinalVAL)
    else:
        for i in range (3 , k):
            binaryVAL = binaryVAL + binaryValue[i]
        complement = toTwosComplement(binaryVAL)
        le = len(complement)    
        for i in range (le , 16):
            FinalVAL = FinalVAL + '1'
        FinalVAL = FinalVAL + complement   
        return(FinalVAL)
    
def toTwosComplement(binarySequence):
    convertedSequence = [0] * len(binarySequence)
    carryBit = 1
    # INVERT THE BITS
    for i in range(0, len(binarySequence)):
        if binarySequence[i] == '0':
            convertedSequence[i] = 1
        else:
            convertedSequence[i] = 0

    # ADD BINARY DIGIT 1

    if convertedSequence[-1] == 0: #if last digit is 0, just add the 1 then there's no carry bit so return
            convertedSequence[-1] = 1
            return ''.join(str(x) for x in convertedSequence)

    for bit in range(0, len(binarySequence)):
        if carryBit == 0:
            break
        index = len(binarySequence) - bit - 1
        if convertedSequence[index] == 1:
            convertedSequence[index] = 0
            carryBit = 1
        else:
            convertedSequence[index] = 1
            carryBit = 0

    return ''.join(str(x) for x in convertedSequence)  
x = []
x = ReadFile('input.txt')
s = []
s = desReg(x)
for i in s:
    print(" " , i)
x = "-3"
print(bin(-3))
print(StringToBin('-3'))



