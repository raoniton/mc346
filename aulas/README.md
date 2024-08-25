# Notas de aulas do [Professor Jacques Wainer](https://www.ic.unicamp.br/~wainer/)
<details>
  <summary>Aula 1</summary>
  
# Aula 1 
## Dicotomias em linguagens de programação
- compilado x interpretado 
- tipagem estática x dinâmica
- tipagem forte x tipagem fraca
- batch x iterativo
a maioria destas “dicotomias” são um continuo

## Compilado x Interpretado
### 2 extremos
- compila para um arquivo auto-contido que roda na plataforma de destino: – C com compilação estática
- cada linha do programa é interpretada (+tabela de símbolos) – BASIC, Bash (sh, csh)
~~~
    for i in {0..9}
    do
       ssh -N  -L 900${i}:${nos[${i}]}:22 wainer@ssh.recod.ic.unicamp.br &
       pid[${i}]=$!
       sleep 1
    done
    echo -n ${pid[@]} > ~/.pidssh
~~~
 
- interpretado precisa processar a linha pid[${i}]=$! 9 vezes onde processar significa
  - fazer a analise sintática e descobrir se há erros
  - entender o comando
  - fazer o que o comando manda: computa o pid do processo (\$!) e atribui à entrada i do array pid

### Tarefas de um compilador
- analise sintática: os comandos estão corretos?
- analise semântica: arvore de operações/comandos
- otimização não especifica da arquitetura. ex: invariantes fora do loop

~~~
    i = 0
    for x in range(10):
        i = 1
~~~

~~~
    i = 0
    for x in range(10):
        pass
    i=1
~~~

~~~
    i = 0
    i = 1
~~~

~~~
    i = 1
~~~

- otimização especifica de arquitetura: registradores, cache
- geração de código de maquina

### Há um continuo de alternativas entre auto contido e processar cada linha todas as vezes.
1. compila para um arquivo mas ele não é auto-contido, por exempli depende de bibliotecas – C com compilação dinâmica

2. “compila” para uma “linguagem de maquina” que não roda no hardware mas precisa de um “interpretador” – Java com o JRE (interpretador) WebAssembly(Wasm)/browser
  - byte-code
  - todas as tarefas de um compilador sem a otimização específica

3. analisa a sintaxe do programa inteiro, faz a análise semântica, otimizações, e converte para uma “linguagem de maquina” falsa, que precisa de um interpretador, mas o interpretador e o compilador são o mesmo programa – Python, Perl, Lisp, etc

1.5. (entre 1 e 2) Compila para linguagem de maquina apenas alguns trechos que código que são auto-contidos e que são usados muito: - Java com compilação JIT (de métodos) (Julia?) - Lisp com compilação de algumas funções e não outras - Numba em Python (acho)

### Transcompilação
Ha ainda _transcompilação_ - traduz da linguagem original para uma linguagem de programacao destino, e esta é compilada com o seu compilador.

typescript -> javascript

coffescript -> javascript

dart-> javascript

Javascript é o destino pois todo mundo já tem um interpretador de javascript nos seus browsers.

## Tipagem estática ou dinâmica
### Estática
- variáveis tem tipo e ele é fixo

- e normalmente declarado mas não NECESSARIAMENTE

- C, Java

- se a variável tem tipo, é possível em tempo de compilação definir exatamente o que fazer com uma operação na variável

a+b

isso é uma soma (inteiros? reais? complexos?) ou uma concatenação (Python)

- a linguagem pode ser estática mas não ter declaração de variáveis. O compilador infere o tipo da primeira atribuição e não permite que valores de outros tipos sejam atribuídos a essa variável. (veremos em Haskell e RUST(?)

- OO estraga esse conhecimento em tempo de compilação do que deve ser feito. A decisão fica para o tempo de execução.

~~~Java
    public class A {
      public void m() {
        System.out.println("Hello World!");
      }
    }
~~~

~~~Java
    public class B extends A {
      public void m() {
        System.out.println("Bye World!");
      }
    }

    A x;

    ... x = new A()  ou x = new B()

    x.m();
~~~

## Dinâmica
- dados tem tipos, e variáveis apontam para dados
Python:

~~~Python
    x=4
    x="qwerty"
    x=[3,4,5]
~~~

## Diferenças
- tipagem dinâmica é mais lenta – indireção – decisão em tempo de execução o que fazer – gasta mais memória (apontador + tags)

- tipagem dinâmica é útil em modo iterativo

- tipagem estática garante uma programação mais segura

~~~
     def soma(a,b)
        return 4*(a+b)
        ou  return (a+b)/4
~~~

~~~
     soma(3,4)
     soma("casa","azul")
~~~

- linguagens dinâmicas estão cada vez mais permitindo declaração/hints de tipo para argumentos de funções! Python Mas ainda não esta claro o que o interpretador faz com essas declarações.
### Tipagem forte vs fraca 
- tipagem forte não faz conversão de tipos a não ser que explicitamente indicado pelo programador.

~~~
a = "casa" 
b = 3
c = a + b
c == "casa3" -> tipagem fraca
~~~
~~~
erro -> tipagem forte
~~~

- normalmente, quase todas linguagens aceitam que a conversão de inteiro para float pode ser automática (menos RUST)

- PHP é a mais citada linguagem de tipagem fraca.

- aritimetica em ponteiros do C é outro exemplo de tipagem fraca

- conversão explicita vs conversão implicita (coercion)

## Outros conceitos de tipagem
### Tipagem paramétrica ou polimorfismo paramétrico
Em C, lista ligada de inteiros e de float são códigos diferentes, apenas por causa das declarações dos argumentos das funções, o resto do código é igual

~~~C
    struct IntLinkedList{
        int data;
        struct IntLinkedList *next;
     };

    typedef struct LinkedList *inode;

    struct FloatLinkedList{
        float data;
        struct FloatLinkedList *next;
     };

    typedef struct LinkedList *fnode;

    inode addiNode(inode head, int value){
    ...}

    fnode addfNode(fnode head, float value){
    ...}
~~~

- parametric typing (tipos com componentes que serão fixados depois - mas em tempo de compilação, não de execução)

~~~C
     struct LinkedList(X){
        X data;
        struct IntLinkedList *next;
     };

    typedef struct LinkedList(X) *node(X);

    node(X) addNode(node head, X value){
    ...}
~~~

um exemplo real e mais simples em C++
~~~C++
    template <class T>
    T max(T a, T b) {
     return a > b ? a : b;
    }
~~~
- mas o tipo T precisa ser um que aceira a comparação >. Restrições nos tipos

- veremos isso em Haskell

## Batch vs interativo
- Batch: compila e roda, ou chama o run environment e roda <br>
`
$ jre a.java
`<br>

- interativo: existe um modo onde o usuário entra num ambiente que permite o usuário entrar uma linha de comando por vez
~~~
    $ python
    Python 3.6.8 |Anaconda, Inc.| (default, Dec 29 2018, 19:04:46) 
    [GCC 4.2.1 Compatible Clang 4.0.1 (tags/RELEASE_401/final)] on darwin
    Type "help", "copyright", "credits" or "license" for more information.
    >>> c=4
    >>> c+6
    10
~~~
- implementações interativas ****também**** implementam um modo batch <br>
`
$ python a.py
`<br>

- modo interativo é útil para aprender uma linguagem, para aprender sobre uma biblioteca,
- modo interativo é útil para trabalho exploratório - data science
- modo interativo é util para debug
- Jupiter: modo interativo com memória, intercala texto, código, figuras, plots, expressões, etc

## Que linguagens vc deve saber
- C
- C++
- Java
- Python
- Javascript
- 
## Linguagens que talvez valha a pena aprender (um dia)
- Go (golang) - da google
- Scala (prog funcional + oo)
- Julia (Python-like, R-like mas compilado)
- F# ou OCaml (prog funcional menos complexa/pura que Haskell)
- Ruby (ruby-on-rails)
- R (data science, estatística)
- Erlang (paralelo)
- Rust
- Swift (MacOS)
- Perl (bioinformatica)
- Kotlin (Android)
- FORTRAN (computação científica)
- Closure (Nubank)
</details>

<details>
  <summary>Aula 2</summary>
  
# Aula 2
## Familias de sintaxe em linguagens de programação
### expressões vs comandos vs declarações
expressões retornam valores.

comandos principalmente causam efeitos colaterias/mudanca de estado

expressões
~~~
3 + x + 4.5*sqrt(y)
~~~
comandos
~~~
x=4
if x==4 :

else:

print(x)
~~~
(normalmente) comandos são “executados/executed/run” e expressões são “avaliadas/evaluated”

Em linguagens funcionais o programa é uma expressão func1(func2(func3(x))) mas mesmo assim existem comandos para I/O e para atribuir valor a variaveis locais.

Declarações são comandos/informações/statements/pragma para o compilador/interpretador. Declaração de variavies, imports, macros em C, etc

### Chamada de funções

quase todas as linguagens

~~~
func(arg1, arg2)
~~~

familia haskell (embora acho que comecou com APL), separado por brancos
~~~
func arg1 arg2
~~~

familia lisp
~~~
(func arg1 arg2)
~~~

A vantagem da familia tradicional é que é obvio como colocar expressões para os argumentos
~~~
func(x+45, g(y))
~~~

em haskell é bem mais chato

errado:
~~~
func x + 45 g y
~~~

são preciso parenteses
~~~
func (x + 45) (g y)
~~~

Em lisp, os parenteses sao usados necessariamente
~~~
(func (+ x 45) (g y))
~~~ 

### Expressões matemáticas

tradicional - operadores infixos (no meio)
~~~
x + y * 4 / z**2
~~~
- variações quanto a exponenciação (“^”)
- precisa das prioridades na ordem de operações
 - parenteses
 - exponenciacao
 - * e /
 - + e -
lisp - operadores prefixo (no começo) e parenteses, como para a chamada da função
~~~
(+ x (* y * (/ 4 (pow z 2))))
~~~
vantagens na notação prefixa é que os operadores nao são mais binários
~~~
(+ 3 a b c d e f)
~~~
### Blocos e Ifs
Algumas versões do comandos if so aceita um comando como a parte `then um só comando para o else (por exemplo C). Nesse caso, se vc quer mais de um comando, vc precisa de um bloco. Sintaticamente, um bloco faz o papel de um so comando.

- blocos são delimitados por “{” e “}” (C)
- blocos delimitados por begin e end (pascal)

Algumas linguagens entendem que há mais de um comando na parte then, e esses comandos terminam no else. Mas isso cria um problema que é quando os comandos do else terminam? Bash por exemplo usa um terminador do if, o fi.

Algumas ling usam indentação para indicar o bloco. O fim da indentação indica o fim do bloco. E a quantidade de indentação indica um bloco dentro do outro.

O problema do else (dangling else)
~~~
if x ==2 then
c1 
c2
if y == 4 then 
c3 
c4
else
c5 
c6
~~~
Esse else é do 1o ou do 2o if? Ou o 2o if é um if-then ou um if-then-else

indentaçao pode resolver o problema
se a ling tem um terminador do if, entao se o 2o if terminou teria um terminador.
em C isso é ainda um problema em um caso, onde nao há bloco
~~~
if (x==2) if (y==4) c4; else c5
~~~
nesse caso, o else é atribuido ao segundo if.

### Sintaxe do IF
tradicional (C, python, etc)
~~~
if condicao   ou if (condicao)
   ....
els  e
  ...
pascal, haskell

if condicao then
  ...
else
  ...
~~~
em haskell o if tem sempre um else (veremos isso no futuro)

### Separaçao entre comandos
familia C (rust,java, etc) “;”

mais moderno (python haskell, R, go, etc) mudança de linha

acho que todas ling mais modernas permitem mais de um comando por linha separados por “;”

listas e arrays
familia C: primeiro valor tem indice 0 (python, java, go, rust)

familia fortran : primeiro valor tem indice 1 (R, julia)

### Atribuiçao
~~~C
x = 2 (C python etc)
~~~

~~~Pascal
x := 2 (pascal)
~~~

~~~R
x <- 2 (R)
~~~


### Recursao revisao
em python

o tamanho de uma lista
~~~Python
def tam(l):
    if l==[]: 
        return 0
    return 1 + tam(l[1:])
~~~

o maior de uma lista
~~~Python
def maior1(l):
    if len(l) == 1:
        return l[0]
        
    aux = maior1(l[1:])
    if l[0] >= aux :
        return l[0]
    else:
        return aux
~~~
Essa solucao precisa da variavel local. sem ela o problema passa de tempo linear para exponencial
~~~Python
def maior2(l):
   if len(l) == 1:
       return l[0]
       
   if l[0] >= maior2(l[1:]):
       return l[0]
   else:
       return maior2(l[1:])
~~~
no pior caso vc faz a mesma recursao 2 vezes.

### Recursao com um parametro extra
recursao no resto e depois vc faz o seu trabalho
~~~Python
def tam1(l):
    if l==[]:
        return 0
    return 1+tam1(l[1:])

def tam1(l):
    if l==[]:
        return 0
    aux = +tam1(l[1:])
    return aux+1
~~~
o parametro extra é o trabalho da recursão feito antes desta chamada

~~~Python
def tamanho(l):
    return tam2(l,0)

def tam2(l, x):
    if l==[]:
        return x
    return tam(l[1:], x+1)
def maior(l):
    return maior2(l[1:], l[0])

def maior2(l, m):
    if l==[]:
        return m
    if l[0] > m:
        return maior2(l[1:], l[0])
    else:
        return maior2(l[1:], m)
~~~

A recursao sem o parametro do trabalho anterior será chamada de fold right (porque o resultado vem da direita - fim da lista)

a recursao com o trabalho anterior será chamado de fold left (porque o resultado vem da esquerda - do começo da lista).

Fold left tem vantagens

- last call optimization: nao precisa ser implementado (pelo compilador) como uma chamada recursiva e sim como um loop
A ultima coisa que vc faz é a chamada recursiva e portanto nada mais sera executado nessa chamada da recursao - as variaveis locais nao precisam ser lembradas. O compilador simplismente reusa o espaco na pilha para a proxima chamada recursiva.
</details>
