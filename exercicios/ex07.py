#Exercícios
import time
import datetime

"""---------------------------------------------------------------------------------------
1 - decorator para imprimir o tempo de execução
"""
def timer(func):
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        func(*args, **kwargs)
        end = time.perf_counter()
        runningTime = end - start
        print(f"Tempo de execucao: {runningTime:.3f}s")
    return wrapper

@timer
def waiting(t):
    time.sleep(t/1000)

#chamadas da funcao
#waiting(100) #milissegundos
#waiting(200)

"""---------------------------------------------------------------------------------------
2 - decorator para construir um string com linhas para a hora e argumentos e saida de cada chamada da função. 
O string será acessado via atributo
"""
def logExecution(func):
    #atributo inicializado - string vazia
    

    def wrapper(*args, **kwargs):
        now = datetime.datetime.now()
        nowStr = now.strftime("[%d/%m/%Y %H:%M:%S]")
        res = func(*args, **kwargs)
        wrapper.log += f"{nowStr} \t-  {func.__name__}{args} = {res}\n"
        return res
    wrapper.log = ""
    return wrapper

@logExecution
def sum(*args):
    x=0
    for i in args: 
        x += i
    return x

@logExecution
def mult(*args):
    x=1
    for i in args:
        x *= i
    return x

#chamadas da funcao
#mult(1,2,3)
#mult(4,5,6)
#sum(1,2,3,4)
#sum(5,6,7,8)
#
#print(mult.log)
#print(sum.log)

    
"""---------------------------------------------------------------------------------------
3 - decorator para memoizar a função. Memoização é criar um dicionário que se lembra dos valores de entrada 
e de saída da função ja executado. Se um desses valores de entrada for re-executado, a função não será 
re-executada - ela apenas retorna o valor de saída memoizado
"""



"""---------------------------------------------------------------------------------------
4 - decorator para log argumentos e horario num arquivo (append no arquivo) dado como argumento do decorator 
(ver o primer on decorators )
"""


