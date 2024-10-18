#Exercícios
# lista criada para testar
lista = [-5,-4,-3,-2,-1,0,1,2,3,4,5]
"""---------------------------------------------------------------------------------------
1) - criar uma lista com apenas os valores pares de outra lista
"""
#essa versao segue a maneira usual
def selectPar(list):
    new = []
    for i in list: 
        if(i % 2 == 0):
            new.append(i)
    
    return new

# essa versao com list compreesion
def selectPar2(list): return [i for i in list if i % 2 == 0]

#print('selectPar: {0}'.format(selectPar(lista)))
#print('selectPar2: {0}\n'.format(selectPar2(lista)))


"""---------------------------------------------------------------------------------------
2) - criar uma lista com os valores nas posicoes pares
"""
#essa versao segue a maneira usual
def selectPosPar(list):
    new = []
    for i in range(len(lista)):
        if (i % 2 == 0):
            new.append(lista[i])
    return new

# essa versao com list compreesion
def selectPosPar2(list): return[list[i] for i in range(len(list)) if i % 2 == 0]


#print('selectPosPar: {0}'.format(selectPosPar(lista)))
#print('selectPosPar2: {0}\n'.format(selectPosPar2(lista)))

"""---------------------------------------------------------------------------------------
3 - criar um dicionário com a contagem de cada elemento numa lista
"""
def countElem(list):
    new = {}
    for i in list: 
        if str(i) in new:
            new[str(i)] += 1
        else:
            new[str(i)] = 1
    return new

lista = [1,1,1,2,3,1,5,5,6,4,10,5,9,7,6,6,7,10,10]
#print(countElem(lista))


"""---------------------------------------------------------------------------------------
4 - qual é a chave associada ao maior valor num dicionario
"""
def chaveMaiorValor(dict):
    if len(dict) == 0:
        return None
    elif len(dict) == 1:
        return dict.keys()
    else:
        maior = list(dict.values())[0] # inicializo a variavel maior
        chave = list(dict.keys())[0] # inicializo a variavel chave
        for k,v in dict.items():
            if v > maior:  
                maior = v
                chave = k
        return chave

#di = {"a":1, "b":20, "c":3, "d":4}
#print(chaveMaiorValor(di))

"""---------------------------------------------------------------------------------------
5 - qual o elemento mais comum numa lista
"""
def maisComum(list):
    return chaveMaiorValor( countElem(list) )

#print(maisComum( [1,1,1,10,5,5,10,5,10,10,10] ))


"""---------------------------------------------------------------------------------------
6 - uma lista é sublista de outra?
"""
#verifica se l2 eh sublista de l1
def subList(l1, l2):
    for i in range( len(l1) ):
        if l1[i: len(l2)+i] == l2:
            return True
    return False    

#print( subList([0,1,2,3,0], [1,2,3]) )

#s1 = "abcdefghi"
#print( s1[0:2] ) #ab
#print( s1[1:3] ) #bc
#print( s1[2:4] ) #cd

"""---------------------------------------------------------------------------------------
7 - dado 2 strings o fim de um é igual ao comeco do outro?  a  abc
"""
def fimComeco(s1, s2):
    for i in range(1,len(s1)+1):
        #print('{0} - {1}'.format(s1[len(s1)-i : ], s2[ : i-len(s2)]))
        if s1[-i : ] == s2[ : i]:
            return True
    return False

def fimComeco2(s1, s2):
    new = ""
    flag = True
    for i in range(1, min(len(s1), len(s2)) +1):
        print('{0} - {1}'.format(s1[len(s1)-i : ], s2[ : i-len(s2)]))
        if s1[-i :] == s2[: i]:
            new = s2[ : i]
        elif new != "" and s1[-i :] != s2[: i]:
            break
            
    return new

#print(fimComeco("abcdefghi","fghijklmn"))
#print(fimComeco2("abcdefghi","fghijklmn"))


