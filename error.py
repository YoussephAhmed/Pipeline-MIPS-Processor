
def listMaker(string):
    x = string.replace("("," ")
    y = x.replace(")"," ")
    z = y.replace(","," ")
    result = z.split()
    return result

def FormatIdentefier(string):
    #list = listMaker(string)
    if (string == 'add' or string == 'sub' or string == 'and' or string == 'sll' or string == 'or' or string == 'jr' ):
        format = 'R-format'
    elif (string == 'addi' or string == 'lw' or string == 'andi' or string == 'sw' or string == 'ori' or string == 'beq' or string == 'bne'):
        format = 'I-format'
    elif (string == 'j' or string == 'jal'):
        format = 'J-format'
    return format

def Operation_Checker(string):
    state = 'compiled successfully..you are ready to Go'
    instuctionslist =  listMaker(string)
    op = instuctionslist[0]
    if(op == 'add' or op == 'sub' or op == 'and' or op == 'sll' or op == 'or'):
        pass
    elif(op == 'addi' or op == 'lw' or op == 'andi' or op == 'sw' or op == 'ori' or op == 'beq' or op == 'bne'):
        pass
    elif(op == 'j' or op == 'jal'):
       pass
    else:
        state = 'error:: unidentified operation "{}" in :{}'.format(op,string)
    return(state)






def RegisterName_Checker(string):
    state = 'compiled successfully..you are ready to Go'
    error_exp = ''
    instuctionslist =  listMaker(string)
    op = instuctionslist[0]
    Format =  FormatIdentefier(op)
    if (Format == 'R-format'):
        dis = instuctionslist[1]
        first = instuctionslist[2]
        second = instuctionslist[3]
        if (dis == '$s0'or dis == '$s1' or dis == '$s2' or dis == '$s3' or dis == '$s4' or dis == '$s5' or dis == '$s6' or dis == '$s7'):
            pass
        elif(dis == '$t0'or dis == '$t1' or dis == '$t2' or dis == '$t3' or dis == '$t4' or dis == '$t5' or dis == '$t6' or dis == '$t7'):
            pass
        elif(dis == '$at'or dis == '$v0' or dis == '$v1'):
            pass
        else:
            error_exp = error_exp+'error::unidentified register name "{}" in :{} \n'.format(dis,string)



        if (first == '$s0'or first == '$s1' or first == '$s2' or first == '$s3' or first == '$s4' or first == '$s5' or first == '$s6' or first == '$s7'):
            pass
        elif(first == '$t0'or first == '$t1' or first == '$t2' or first == '$t3' or first == '$t4' or first == '$t5' or first == '$t6' or first == '$t7'):
            pass
        elif(first == '$at'or first == '$v0' or first == '$v1'):
            pass
        else:
            error_exp = error_exp+'error::unidentified register name "{}" in :{} \n'.format(first,string)


        if(second.isdecimal()):
            pass
        else:
            if (second == '$s0'or second == '$s1' or second == '$s2' or second == '$s3' or second == '$s4' or second == '$s5' or second == '$s6' or second == '$s7'):
                pass
            elif(second == '$t0'or second == '$t1' or second == '$t2' or second == '$t3' or second == '$t4' or second == '$t5' or second == '$t6' or second == '$t7'):
                pass
            elif(second == '$at'or second == '$v0' or second == '$v1'):
                pass
            else:
                error_exp = error_exp+'error::unidentified register name "{}" in :{} \n'.format(second,string)

    elif(Format == 'I-format'):
        if(instuctionslist[0] == 'addi' or instuctionslist[0] == 'andi' or instuctionslist[0] == 'ori'):
            dis = instuctionslist[1]
            first = instuctionslist[2]
        elif(instuctionslist[0] == 'lw' or instuctionslist[0] == 'sw'):
            dis = instuctionslist[3]
            first = instuctionslist[1]
        elif(instuctionslist[0] == 'beq' or instuctionslist[0] == 'bne'):
            dis = instuctionslist[1]
            first = instuctionslist[2]

        if (dis == '$s0'or dis == '$s1' or dis == '$s2' or dis == '$s3' or dis == '$s4' or dis == '$s5' or dis == '$s6' or dis == '$s7'):
            pass
        elif(dis == '$t0'or dis == '$t1' or dis == '$t2' or dis == '$t3' or dis == '$t4' or dis == '$t5' or dis == '$t6' or dis == '$t7'):
            pass
        elif(dis == '$at'or dis == '$v0' or dis == '$v1'):
            pass
        else:
            error_exp = error_exp+'error::unidentified register name "{}" in :{} \n'.format(dis,string)




        if (first == '$s0'or first == '$s1' or first == '$s2' or first == '$s3' or first == '$s4' or first == '$s5' or first == '$s6' or first == '$s7'):
            pass
        elif(first == '$t0'or first == '$t1' or first == '$t2' or first == '$t3' or first == '$t4' or first == '$t5' or first == '$t6' or first == '$t7'):
            pass
        elif(first == '$at'or first == '$v0' or first == '$v1'):
            pass
        else:
            error_exp = error_exp+'error::unidentified register name "{}" in :{} \n'.format(first, string)

    if(error_exp != ''):
            state = error_exp
    return state


def colon_Checker(string):
    state = 'compiled successfully..you are ready to Go'
    counter = 0
    for i in string:
        if(i == ','):
            counter = counter + 1
    instuctionslist =  listMaker(string)
    op = instuctionslist[0]
    Format =  FormatIdentefier(op)
    if(Format == 'R-format' and counter == 2):
        pass
    elif(Format == 'R-format' and counter == 0 and op == 'jr'):
        pass
    elif(Format == 'I-format' and counter == 2 and (op == 'addi'  or op == 'andi'  or op == 'ori' or op == 'beq' or op == 'bne')):
        pass
    elif(Format == 'I-format' and counter == 1 and (op == 'lw'  or op == 'sw')):
        pass
    elif(Format == 'J-format' and counter == 0 and (op == 'j' or op == 'jal')):
       pass
    else:
        state = 'error::unexpected "," in :{}'.format(string)
    return(state)

def dollarSign_Checker(string):
    state = 'compiled successfully..you are ready to Go'
    counter = 0
    for i in string:
        if(i == '$'):
            counter = counter + 1
    instuctionslist =  listMaker(string)
    op = instuctionslist[0]
    Format =  FormatIdentefier(op)
    if(Format == 'R-format' and counter == 3):
        pass
    elif(Format == 'R-format' and counter == 1 and op == 'jr'):
        pass
    elif(Format == 'I-format' and counter == 2 and (op == 'addi'  or op == 'andi'  or op == 'ori' or op == 'beq' or op == 'bne')):
        pass
    elif(Format == 'R-format' and counter == 2 and (op == 'sll')):
        pass
    elif(Format == 'I-format' and counter == 2 and (op == 'lw'  or op == 'sw')):
        pass
    elif(Format == 'J-format' and counter == 0 and (op == 'j' or op == 'jal')):
       pass
    else:
        state = 'error::unexpected "$" in :{}'.format(string)
    return(state)

def Prasec_Checker(string):
    state = 'compiled successfully..you are ready to Go'
    counter = 0
    for i in string:
        if(i == '(' or i == ')'):
            counter = counter + 1
    instuctionslist =  listMaker(string)
    op = instuctionslist[0]
    Format =  FormatIdentefier(op)
    if(Format == 'I-format' and counter == 2 and (op == 'lw'  or op == 'sw')):
        pass

    else:
        state = 'error::wrong {} expression in: {}'.format(op ,string)
    return(state)



def instruction_stucture(string):
    state = 'compiled successfully..you are ready to Go'
    instuctionslist =  listMaker(string)
    op = instuctionslist[0]
    Format =  FormatIdentefier(op)
    n = len(instuctionslist)
    if ((Format=='R-format' or Format=='I-format') and n != 4 ):
        state = 'error::wrong mips instrucion {}'.format(string)
    elif((Format=='J-format') and n != 2 ):
        state = 'error::wrong mips instrucion {}'.format(string)
    return(state)


def error_checker(string):
    instuctionslist =  listMaker(string)
    op = instuctionslist[0]
    state = 'compiled successfully..you are ready to Go'
    error_exp = ''
    m = Operation_Checker(string)
    if (m == state):
        o = RegisterName_Checker(string)
        x = instruction_stucture(string)
        n = colon_Checker(string)
        q = dollarSign_Checker(string)
        if (op == 'lw' or op == 'sw'):
            p = Prasec_Checker(string)
        else:
            p = state


        if (x != state):
            error_exp = error_exp +'\n'+x
        if (o != state):
            error_exp = error_exp +'\n'+o
        if (n != state):
            error_exp = error_exp +'\n'+n
        if (q != state):
            error_exp = error_exp +'\n'+q
        if (p != state):
            error_exp = error_exp +'\n'+p
    else :
        error_exp = error_exp +'\n'+m


    if(error_exp != ''):
        state = error_exp
    return state
#------------------------------------------------------------------------------#
def error_handler():
        input = open('input.txt','r')
        instuctions = input.readlines()
        error = open('error.txt','w')
        state = 'compiled successfully..you are ready to Go'
        flag = 0
        i = 0
        while(i < len(instuctions)):
            result = error_checker(instuctions[i])
            if (result != state ):
                error.write(result+'\n')
                flag = flag + 1
            i= i+1
        if (flag == 0):
            error.write(result+'\n')


if __name__ == "__main__": main()
