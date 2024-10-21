"""
###############################################################################
#                 MC346 - PARADIGMAS DE PROGRAMACAO - 2S_2024                 #
#                 PROFo:  JACQUES WAINER                                      #
#                 NOME:   RAONITON ADRIANO DA SILVA                           #
#                 RA:     186291                                              #
###############################################################################

Projeto 6 - Python
Ate 2a feria dia 21/10 ate 23:59

Considere a função somaQuadrados que recebe um numero qualquer de argumentos 
e retorna a soma dos quadrados desses numeros.

Na versao futura da sua biblioteca essa funçao recebera apenas até 3 argumentos. 
Escreva um decorator e aplique-o a esta funcao, de forma que se o usuário entrar 
mais de 3 argumentos para a somaQuadrados o programa imprime 
    “A função somaQuadrados será modificada na proxima versão da biblioteca para aceitar apenas até 3 argumentos”

1. valendo 5 pontos: implemente o decorator de forma que ele só imprime a 
mensagem na primeira vez que a função é chamada com mais de 3 argumentos.

2. valendo os 10 pontos: implemente o decorator de forma que ele imprime a 
mensagem a cada 10 vezes que a funçao é chamada com mais de 3 argumentos, 
desde que tenha se passado mais de 5 minutos da ultima vez que a mensagem foi escrita.

Assim

import time
for i in  range(31):
    a = somaQuadrados(1,2,3,4)
    if i<= 12: 
        time.sleep(60)  #  1 minuto
    b = somaQuadrados(1,2,3)
   
deve imprimir a mensagem na primeira passagem (i==0) por a = somaQuadrados(1,2,3,4) 
e na 11 passada (i==10) de a = somaQuadrados(1,2,3,4) e não mais. 
Nunca imprime em b = somaQuadrados(1,2,3) e as outras passadas (i==20 e i==30) 
por a = .. acontecem em menos de 5 minutos da impressão no i==10.
"""
import time

#decorator que verifica a necessidade de imprimir a mensagem ou nao
def myDecorator(f):
    counter = 0
    last = 0
    limitInferior = 5*60 # 5 minutos
    def wrapper(*args, **kwargs):
        nonlocal counter, last
        
        if(len(args) > 3):
            now = time.time()
            
            if (counter % 10 == 0 and (now - last) > limitInferior):
                print("A função somaQuadrados será modificada na proxima versão da biblioteca para aceitar apenas até 3 argumentos")
                last = time.time()
            counter += 1
        
        return f(*args, **kwargs) 
        #else:
        #    print(f"{f.__name__}{args} = {f(*args, **kwargs)}")
        
    return wrapper
        

#funcao que sera passada para o decorator myDecorator
@myDecorator
def somaQuadrados(*args):
    x=0
    #print(len(args))
    for i in args: 
        x += i**2
    return x

#chamada da funcao em loop para testar o decorator
for i in  range(31):
    a = somaQuadrados(1,2,3,4)
    if i<= 12: 
        time.sleep(60)  #  1 minuto
    b = somaQuadrados(1,2,3)

