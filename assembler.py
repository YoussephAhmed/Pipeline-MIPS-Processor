import os

def listMaker(string):
    x = string.replace("("," ")
    y = x.replace(")"," ")
    z = y.replace(","," ")
    result = z.split()
    return result

def bitdevider(string):
    output='\n'.join(string[i:i+8] for i in range(0,len(string),8))
    return output


def funcChecker(string):
    if(string == 'add'):
        funct = '100000'
    elif(string == 'sub'):
        funct = '100010'
    elif(string == 'sll'):
        funct = '000000'
    elif(string == 'and'):
        funct = '100100'
    elif(string == 'or'):
        funct = '100101'
    return funct

def StringToBin16(number):
    intNum = int(number)
    binaryValue = bin(intNum)
    complement = ""
    binaryVAL = ""
    FinalVAL = ""
    k = len(binaryValue)
    if(intNum < 0):
        for i in range (3 , k):
            binaryVAL = binaryVAL + binaryValue[i]
        complement = toTwosComplement(binaryVAL)
        le = len(complement)
        for i in range (le , 16):
            FinalVAL = FinalVAL + '1'
        FinalVAL = FinalVAL + complement
        return(FinalVAL)
    else:
        for i in range (2 , k):
            binaryVAL = binaryVAL + binaryValue[i]
        le = len(binaryVAL)
        for i in range (le , 16):
            FinalVAL = FinalVAL + '0'
        FinalVAL = FinalVAL + binaryVAL
        return(FinalVAL)


def StringToBin26(number):
    intNum = int(number)
    binaryValue = bin(intNum)
    complement = ""
    binaryVAL = ""
    FinalVAL = ""
    k = len(binaryValue)
    if(intNum < 0):
        for i in range (3 , k):
            binaryVAL = binaryVAL + binaryValue[i]
        complement = toTwosComplement(binaryVAL)
        le = len(complement)
        for i in range (le , 26):
            FinalVAL = FinalVAL + '1'
        FinalVAL = FinalVAL + complement
        return(FinalVAL)
    else:
        for i in range (2 , k):
            binaryVAL = binaryVAL + binaryValue[i]
        le = len(binaryVAL)
        for i in range (le , 26):
            FinalVAL = FinalVAL + '0'
        FinalVAL = FinalVAL + binaryVAL
        return(FinalVAL)

def StringToBin5(number):
    intNum = int(number)
    binaryValue = bin(intNum)
    complement = ""
    binaryVAL = ""
    FinalVAL = ""
    k = len(binaryValue)
    if(intNum < 0):
        for i in range (3 , k):
            binaryVAL = binaryVAL + binaryValue[i]
        complement = toTwosComplement(binaryVAL)
        le = len(complement)
        for i in range (le , 5):
            FinalVAL = FinalVAL + '1'
        FinalVAL = FinalVAL + complement
        return(FinalVAL)
    else:
        for i in range (2 , k):
            binaryVAL = binaryVAL + binaryValue[i]
        le = len(binaryVAL)
        for i in range (le , 5):
            FinalVAL = FinalVAL + '0'
        FinalVAL = FinalVAL + binaryVAL
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



def FormatIdentefier(string):
    #list = listMaker(string)
    if (string == 'add' or string == 'sub' or string == 'and' or string == 'sll' or string == 'or' or string == 'jr' ):
        format = 'R-format'
    elif (string == 'addi' or string == 'lw' or string == 'andi' or string == 'sw' or string == 'ori' or string == 'beq' or string == 'bne'):
        format = 'I-format'
    elif (string == 'j' or string == 'jal'):
        format = 'J-format'

    return format


def RegisterIdentifier(string):

    if(string == '$s0'):
        code = '10000'
    elif(string == '$s1'):
        code = '10001'
    elif(string == '$s2'):
        code = '10010'
    elif(string == '$s3'):
        code = '10011'
    elif(string == '$s4'):
        code = '10100'
    elif(string == '$s5'):
        code = '10101'
    elif(string == '$s6'):
        code = '10110'
    elif(string == '$s7'):
        code = '10111'
    elif(string == '$t0'):
        code = '01000'
    elif(string == '$t1'):
        code = '01001'
    elif(string == '$t2'):
        code = '01010'
    elif(string == '$t3'):
        code = '01011'
    elif(string == '$t4'):
        code = '01100'
    elif(string == '$t5'):
        code = '01101'
    elif(string == '$t6'):
        code = '01110'
    elif(string == '$t7'):
        code = '01111'
    elif(string == '$at'):
        code = '00001'
    elif(string == '$v0'):
        code = '00010'
    elif(string == '$v1'):
        code = '00011'
    return code

#بترجع كود الاوبريشن
def operationIdentifier(string):
    if(string == 'addi'):
        op = '001000'
    elif(string == 'andi'):
        op = '001100'
    elif(string == 'ori'):
        op = '001101'
    elif(string == 'lw'):
        op = '100011'
    elif(string == 'sw'):
        op = '101011'
    elif(string == 'beq'):
        op = '000100'
    elif(string == 'bne'):
        op = '000101'
    elif(string == 'j'):
        op = '000010'
    elif(string == 'jal'):
        op = '000011'
    return op




def Rformat(string):
    list = listMaker(string)
    op = '000000'
    if (list[3].isdecimal()):

        shamt = StringToBin5(list[3])
        rt = '00000'
    else:
        rt = RegisterIdentifier(list[3])
        shamt = '00000'
    funct =funcChecker(list[0])
    rd = RegisterIdentifier(list[1])
    rs = RegisterIdentifier(list[2])
    machineCode = op+rs+rt+rd+shamt+funct
    bits = bitdevider(machineCode)
    return bits


def Iformat(string):
    list = listMaker(string)
    op = operationIdentifier(list[0])
    if(list[0] == 'addi' or list[0] == 'andi' or list[0] == 'ori'):
        rt = RegisterIdentifier(list[1])
        rs = RegisterIdentifier(list[2])
        imm = StringToBin16(list[3])
    elif(list[0] == 'lw' or list[0] == 'sw'):
        rt = RegisterIdentifier(list[1])
        rs = RegisterIdentifier(list[3])
        imm = StringToBin16(list[2])
    elif(list[0] == 'beq' or list[0] == 'bne'):
        rt = RegisterIdentifier(list[2])
        rs = RegisterIdentifier(list[1])
        imm = StringToBin16(list[3])
    else:
        rt='xxxxx'
        rs='xxxxx'
        imm = 'xxxxxxxxxxxxxxxx'
    machineCode =op+rs+rt+imm
    bits = bitdevider(machineCode)
    return bits


def Jformat(string):
    list = listMaker(string)
    op = operationIdentifier(list[0])
    x = int(list[1])
    imm = StringToBin26(list[1])
    machineCode = op+imm
    bits = bitdevider(machineCode)
    return bits

def write_line(string,machineCode):
    noop = """00000000
00000000
00000000
00000000"""
    list = listMaker(string)
    op = list[0]
    if(op == 'beq' or op == 'bne' or op == 'j' ):
        v = machineCode +'\n'+ noop +'\n'+ noop +'\n'+ noop +'\n'+ noop+'\n' +noop
        return v
    elif(op == 'lw'):
        v = machineCode +'\n'+ noop
        return v
    else:
        return machineCode
#--------------------------------------------------------------------------------------#

def assembler():
    input = open('input.txt','r')
    instuctions = input.readlines()
    output = open('output.txt','w')
    line_nums = len(instuctions)
    lines = open('lines.txt','w')
    lines.write('{}'.format(line_nums))
    i = 0
    while(i < len(instuctions)):
        elementlist =  listMaker(instuctions[i])
        format = FormatIdentefier(elementlist[0])
        if (format == 'R-format'):
            machineCode = Rformat(instuctions[i])
        elif (format == 'I-format'):
            machineCode = Iformat(instuctions[i])
        elif (format == 'J-format'):
            machineCode = Jformat(instuctions[i])
        ff= write_line(instuctions[i],machineCode)
        output.write(ff+'\n')
        i= i+1

def run():
        os.popen('cd C:\\coproject & vlib work & vmap work work & vlog alufinal.v & vsim TestB -c -do "run 10000;quit"')
        out_reg= ['$s0','$s1','$s2','$s3','$s4','$s5','$s6','$s7']
        resultvalue = self.textBrowser_2
        result_file = open('show.txt','r')
        result = result_file.readlines()
        i = 0
        while(i < len(result)):
            resultvalue.append(out_reg[i]+result[i])
            i = i+1


def assembler_checker(string):

    if ( string == 'compiled successfully..you are ready to Go\n'):
        assembler()
    else:
        check.write('please make sure your input is valid')


if __name__ == "__main__": main()
