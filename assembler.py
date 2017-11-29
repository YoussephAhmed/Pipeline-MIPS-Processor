
#بتاخد سترينج و ترجع ليست
#'add  $s0, $s1, $s2 ==> [add , $s0 , $s1 , $s2]
def listMaker(string):
    x = string.replace("("," ")
    y = x.replace(")"," ")
    z = y.replace(","," ")
    result = z.split()
    return result
#identify the R-type funct
def funcChecker(string):
    if(string == 'add'):
        funct = '100000'
    elif(string == 'sub'):
        funct = '000000'
    elif(string == 'sll'):
        funct = '100010'
    elif(string == 'and'):
        funct = '100100'
    elif(string == 'or'):
        funct = '100101'
    return funct

#واضح فشخ انها بترجع كود الريجيستر
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
#بتاخد سطر انستركشن و ترجع المشين كود بتاعه
def Rformat(string):
    list = listMaker(string)
    op = '000000'
    if (list[3].isdecimal()):
        x = int(list[3])
        y = "{0:5b}".format(x)
        shamt = y.replace(" ","0")
        rt = 'xxxxx'
    else:
        rt = RegisterIdentifier(list[3])
        shamt = '00000'
    funct =funcChecker(list[0])
    rd = RegisterIdentifier(list[1])
    rs = RegisterIdentifier(list[2])
    machineCode = op+rs+rt+rd+shamt+funct
    return machineCode

#بتاخد سطر انستركشن و ترجع المشين كود بتاعه
def Iformat(string):
    list = listMaker(string)
    op = operationIdentifier(list[0])
    if(list[0] == 'addi' or list[0] == 'andi' or list[0] == 'ori'):
        rt = RegisterIdentifier(list[1])
        rs = RegisterIdentifier(list[2])
        x = int(list[3])
        y = "{0:16b}".format(x)
        imm = y.replace(" ","0")
    elif(list[0] == 'lw' or list[0] == 'sw'):
        rt = RegisterIdentifier(list[1])
        rs = RegisterIdentifier(list[3])
        x = int(list[2])
        y = "{0:16b}".format(x)
        imm = y.replace(" ","0")
    elif(list[0] == 'beq' or list[0] == 'bne'):
        rt = RegisterIdentifier(list[2])
        rs = RegisterIdentifier(list[1])
        x = int(list[3])
        y = "{0:16b}".format(x)
        imm = y.replace(" ","0")
    else:
        rt='xxxxx'
        rs='xxxxx'
        imm = 'xxxxxxxxxxxxxxxx'
    machineCode =op+rs+rt+imm
    return machineCode


#بتاخد سطر انستركشن و ترجع المشين كود بتاعه
def Jformat(string):
    list = listMaker(string)
    op = operationIdentifier(list[0])
    x = int(list[1])
    y = "{0:26b}".format(x)
    imm = y.replace(" ","0")
    machineCode = op+imm
    return machineCode
#بتعرف النوع واضح من الاسم بردو
def FormatIdentefier(string):
    #list = listMaker(string)
    if (string == 'add' or string == 'sub' or string == 'and' or string == 'sll' or string == 'or'):
        format = 'R-format'
    elif (string == 'addi' or string == 'lw' or string == 'andi' or string == 'sw' or string == 'ori' or string == 'beq' or string == 'bne'):
        format = 'I-format'
    elif (string == 'j' or string == 'jal'):
        format = 'J-format'
    return format


#الماين الجميله
def main():

    input = open('input.txt','r')
    instuctions = input.readlines()
    output = open('output.txt','w')

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
        output.write(machineCode+'\n')
        i= i+1

    print("Done..")


    # d = Rformat('add  $s1,$s2,$s3')
    # h = Rformat('sll  $t1,$s2,(4)')
    # a = Iformat('addi  $t1,$s2,4')
    # b = Iformat('lw  $t1,18($t5)')
    # c = Iformat('beq  $t1,$s2,32')
    # m = Jformat('j 30')
    # n = Jformat('jal 30')
    # print(d)
    # print(h)
    # print(a)
    # print(b)
    # print(c)
    # print(m)
    # print(n)
if __name__ == "__main__": main()
