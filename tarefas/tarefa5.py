"""
Tarefa 5
Escreva uma função Python que recebe 2 strings e retorna um inteiro que é o tamanho do maior substring no final do 1o argumento que também esta no começo do 2o argumento.

Se não há um substring em comum entre o fim do 1o argumento e o começo do 2o argumento, a função retorna 0.

funcao("abcxxxxa", "xxaabcd")   => 3 (o substring "xxa")


funcao("abcxxxxa", "cxxaabcd")   => 0 (nenhum  substring))


funcao("abcxxxxx", "xxxxde")   => 4  (o substring "xxxx")
Voce pode usar qualquer funcao e metodo para listas ou strings definidos na standard library do Python.

Dica: procure todos os lugares no string 1 onde a primeira letra do string 2 aparece.
"""

import sys
def tamMaiorSubs(str1,str2):
    tam = 0 #iniciliza o tamanho final
    #percorre a lista, verificando str1[i:](final de str1) e o inicio de str2, str2[:len(str1)-1]

    for i in range( len(str1) ):
        #print('{0}  {1}\n'.format(str1[i:], str2[: len(str1) - i]))
        if(str1[i:] == str2[ : len(str1) - i  ]):
            tam = len(str1) - i
            break # se encontrar, atualiza tam e da um break
    return tam 

# caso queira testar por linha de comando, basta rodar com as strings apos .py
# ex: python3 tarefa5.py abcxxxxa xxaabcd
if(len(sys.argv) == 3): 
    str1 = sys.argv[1]
    str2 = sys.argv[2]
    print( tamMaiorSubs(str1, str2) )
    
