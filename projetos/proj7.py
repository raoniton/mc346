""""
###############################################################################
#                 MC346 - PARADIGMAS DE PROGRAMACAO - 2S_2024                 #
#                 PROFo:  JACQUES WAINER                                      #
#                 NOME:   RAONITON ADRIANO DA SILVA                           #
#                 RA:     186291                                              #
###############################################################################

Projeto 7
Data: 6/11 (ate meia noite)

Implemente o projeto de Dykstra (em haskell) em Python.

1) Uma versão simplificada do Dykstra
Para um gráfico não direcionado, e dado um vértice de origem e um de destino, usar o algoritmo de Dykstra para calcular 
a menor distancia entre a origem e o destino.

O gráfico será dado como uma lista de triplas [("ab1","b67",10.4),("ab1","cc",11.2)...] onde os 2 primeiros componentes 
da tupla são os nomes (um string) dos vértices, e o terceiro componente a distancia entre os 2 vértices. 
Note que se a distancia entre os vértices “ab1” e “b67” é 10.4 então a distancia entre “b67” e “ab1” também é de 10.4 
mas a lista não vai conter uma entrada ( "b67",  "ab1", 10,4).

O problema é uma versão simplificada do Dykstra. Na versão “normal” do Dykstra queremos não só a menor distancia 
entre 2 vértices mas também o caminho com essa menor distancia. Mas para esse problema não precisa computar o caminho, 
apenas a menor distancia.

Você pode assumir que o grafo é conectado, ou seja existe um caminho entre quaisquer 2 nós do grafo.

Você não precisa usar estruturas de dados complexas como um “priority queue” que sao O(1) para achar o minimo. 
Pode fazer uma busca linear para achar o mínimo e usar as funções já disponíveis no HasPythonkell.

A função principal deve se chamar proj7 e ela recebe 3 argumentos, o grafo no formato especificado, o nó origem e o nó destino.

Vc pode usar as bibliotecas padrão do Python.

A pagina do Dykstra na wikipedia https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm tem uma animaçao do algoritmo 
para um grafo simples. Aquele grafo corresponde ao dado abaixo.

[ ("1", "2", 7),
  ("1", "3", 9),
  ("1", "6", 14),
  ("2", "3", 10),
  ("2", "4", 15),
  ("3", "4", 11),
  ("3", "6", 2),
  ("4", "5", 6),
  ("5", "6", 9)
  ]

2) grafo não necessariamente conectado
Esta parte do projeto vale apenas 1/4 da nota total do projeto.

Na parte anterior assuminos que o grafo era conectado. No miolo do Dykstra, ha o passo onde precisamos achar a aresta 
de menor tamanho que liga um vertice já visitado com um não visitado. Se o grafo é conectado havera sempre pelo menos 1 
aresta entre os 2 conjuntos de nós. Se o grafo não é conectado, pode não haver nenhuma aresta ligando esses 2 conjuntos.

Agora o grafo não será necessariamente conectado e sua funcão deve retornar alguma indicacão que não existe um caminho 
que liga o vertice origem do vertice destino. Seu programa deve retornar um numero se houver um caminho minimo ou None 
se nao houver esse caminho minimo.

Se vc implementar essa segunda parte, implemente apenas um funcão proj7. quando ela recebe um grafo conectado retorna 
um numero e se nao, retorna None.
"""


import math

# NAO FOI IMPLEMENTADA A CONSTRUCAO DO CAMINHO 

# proj7 - dijkstra - funcao que encontra o menor caminho entre vertices de um grafo.
# parametros: o grafo, a origem(src), destinho
# retorno: 
#       - retorna o valor do menor caminho, caso haja caminho entre (origem, destino)
#       - retorna None, caso nao haja caminho entre (origem, destino) 
def proj7(grafo, origem, destino):

    dist = [math.inf]*(grafo.keys().__len__())  #crio o vetor dist[] com n posicoes que eh quantidade de vertices e preencho com 'infinito'
    prev = [""]*(grafo.keys().__len__())        #crio o vetor prev[] com n posicoes que eh quantidade de vertices e preencho com ''
    visited = set()                             #crio um set que armazenara os vetices que ja foram visitados
    
    v_Atual = origem                            #v_Atual(vertice atual)
    v_AtualIndex = list(grafo).index(v_Atual)   #v_AtualIndex(indice do vertice atual)
    
    #inicializa a distancia da origem como 0
    dist[ v_AtualIndex ] = 0
    #neighbor <- recebe a vizinhanca do vertice, contendo apenas os vertices nao visitados(na primeira chamada nenhum vertice esta visitado) 
    
    neighbor = neighborhood(grafo, visited, v_Atual)
    #print("NEIGHBOR: ", neighbor)
    
    while True:
        #percorre todos os vizinhos do v_Atual e atualiza o vetor dist[] se necessario 
        for k,v in neighbor.items():
            distAux = dist[v_AtualIndex] + v
            if (v_Atual not in visited) and (distAux < dist[ list(grafo).index(k) ]):
                dist[ list(grafo).index(k) ] = distAux  
                prev[ list(grafo).index(k) ] = v_Atual  #antes de atualizar o v_Atual, salvo no indece dos vizinhos o caminho de onde esta vindo

        # marca o v_Atual como visitado
        visited.add(v_Atual)    
        #print('{0} \n{1}\n{2}'.format(visited,dist, prev))
        
        # crio um novo dicionario que contera os possiveis nos que serao os proximos
        # apos salvar na variavel, realizo a busca pelo minimo
        next = {}
        for k,v in neighbor.items():
            if(k not in visited):
                next[k] = v
        
        # se o next estiver vazio, nao ha mais vizinhos nao visitados
        if next == {}:
            break

        chaveMenor = min(next, key=lambda item: next[item])         # encontra a chave do menor utilizando o next.values para comparar
        
        # atualizo v_Atual e seu indice 
        v_Atual = chaveMenor
        v_AtualIndex = list(grafo).index(v_Atual)
        
        # atualizo a vizinhanca, sendo agora a vizinhanca dos v_Atual sem o visitados anteriormente
        neighbor = neighborhood(grafo, visited, v_Atual)
        
    
    print('\nvisitados:\t{0} \ndistancias:\t{1}\nprevious:\t{2}\n'.format(visited,dist, prev))
    
    if dist[ list(grafo).index(destino) ] < math.inf:
        return dist[ list(grafo).index(destino) ], prev
    return None, None


# neighborhood - retorna um dicionario contendo a vizinhanca nao incluindo os vertices que foram visitados
# parametros: grafo, o set() de visitados e a chave a qual se deseja encontrar a vizinhanca
def neighborhood(grafo, visitados, chave):
    v_AtualIndex = list(grafo).index(chave)
    neighbor = list(grafo.values())[ v_AtualIndex ]
    newNeighbor = {}

    for k,v in neighbor.items():
        if k not in visitados:
            newNeighbor[k] = v

    return newNeighbor

# showGrafo - printa o grafo
def showGrafo(grafo):
    print("GRAFO:")
    for k,v in grafo.items():
        print('{0} : {1}'.format(k, v)) 


# caminho - constroi o caminho, no caso, o melhor caminho atraves do vetor de previous
# path = prev[]
# retorna uma string que representa o caminho, no modelo: A -> B -> C -> D
def caminho(path, vertices, origem, destino):
    p = list()
    while destino != origem:
        p.append(destino)
        destino = path[ vertices.index(destino) ]
    p.append(destino)
    p.reverse()
    
    result_aux = []
    for i in range(p.__len__()):
        if i < p.__len__()-1:
            result_aux.append(f'{p[i]} -> ')
        else:
            result_aux.append(f'{p[i]}')
    
    return "".join(result_aux)

############################################################################################################
# os exemplos estao no codigo -> HARD CODED 

# Exemplo de grafo conexo    
input = [("1", "2", 7),("1", "3", 9),("1", "6", 14),("2", "3", 10),("2", "4", 15),("3", "4", 11),("3", "6", 2),("4", "5", 6),("5", "6", 9)]
orig = "1"
dest = "5"

# Exemplo de grafo desconexo
#input = [("A", "B", 2),("A", "D", 8),("B", "D", 5),("B", "E", 6),("D", "E", 3),("D", "F", 2),("E", "F", 1),("E", "C", 9),("F", "C", 3),("G", "H", 10),("G", "I", 5)]
#orig = "A"
#dest = "C"

# seleciono os vertices retirando as duplicatas
v1, v2, number = zip(*input)
vertices = sorted(set(v1+v2))

# crio o dicionario e adiciono as chaves possiveis
grafo = {}
for i in vertices:
    grafo[i] = { }   # crio o dicionarios

# crio o dicionario de dicionarios - nesse caso, cada vertice "x" : {"y":10, ...}, "y" : {"x":10, ...}
# grafo direcionado, por isso adiciono a aresta nos dois sentidos
for i in input:
    grafo[ i[0] ][ i[1] ] = i[2]
    grafo[ i[1] ][ i[0] ] = i[2]

showGrafo(grafo)

# Se origem ou destino nao estiverem no grafo passado, o retorno sera None
if (orig or dest) not in grafo.keys():
    menorCaminho, path = None, None    
else:    
    # Se o programa nao identificar o caminho para o vertice(Grafo nao conectado), o retorno sera None
    menorCaminho, path = proj7(grafo, orig, dest)
    if menorCaminho != None:
        path = caminho(path, vertices, orig, dest)

print("Menor caminho entre os vertices ({0}, {1}) = {2}\n{3}".format(orig, dest, menorCaminho, path))