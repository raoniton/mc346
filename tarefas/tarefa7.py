"""
Escreva trecho de código que normaliza (L1) as colunas de um array de
2 dimensões.  Altere o valor das colunas do array. 

Voce nao prode escrever um loop para fazer isso - com loop
explicito a tarefa nao valerá nenhum ponto. Mas voce pode criar 
variavies novas para armazenar valores intermediarios da computaçao. 

Normalização L1 é garantir que a soma dos **valores absoluto** dos dados
 é igual a 1. Normalmente, normalização é garantir que a soma dos quadrados dos valores é igual a 1 (isso é oficialmente conhecido como norma-2 ou normalização L2).
"""
import numpy as np

def normaliza(matrix):
    #converte o array para numpy array   
    matrix = np.array(matrix)

    #calcula a soma das colunas
    l1 = np.sum(np.abs(matrix), axis=0)
    normalizado = matrix/l1
    #print(l1)
    #print(norm)
    
    return normalizado
    
#print(normaliza([[1,2,3],[4,5,6]]))

