


# Notas de aulas do [Professor Jacques Wainer](https://www.ic.unicamp.br/~wainer/)
![Haskell](https://img.shields.io/badge/Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)
<details>
  <summary>Aula 1 - Introdução</summary>
  
# Aula 1 
<br>

## Dicotomias em linguagens de programação
- compilado x interpretado 
- tipagem estática x dinâmica
- tipagem forte x tipagem fraca
- batch x iterativo
a maioria destas “dicotomias” são um continuo

## Compilado x Interpretado 

<br>

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

<br>

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

<br>

### Há um continuo de alternativas entre auto contido e processar cada linha todas as vezes.
1. compila para um arquivo mas ele não é auto-contido, por exempli depende de bibliotecas – C com compilação dinâmica

2. “compila” para uma “linguagem de maquina” que não roda no hardware mas precisa de um “interpretador” – Java com o JRE (interpretador) WebAssembly(Wasm)/browser
  - byte-code
  - todas as tarefas de um compilador sem a otimização específica

3. analisa a sintaxe do programa inteiro, faz a análise semântica, otimizações, e converte para uma “linguagem de maquina” falsa, que precisa de um interpretador, mas o interpretador e o compilador são o mesmo programa – Python, Perl, Lisp, etc

1.5. (entre 1 e 2) Compila para linguagem de maquina apenas alguns trechos que código que são auto-contidos e que são usados muito: - Java com compilação JIT (de métodos) (Julia?) - Lisp com compilação de algumas funções e não outras - Numba em Python (acho)

<br>

### Transcompilação
Ha ainda _transcompilação_ - traduz da linguagem original para uma linguagem de programacao destino, e esta é compilada com o seu compilador.

typescript -> javascript

coffescript -> javascript

dart-> javascript

Javascript é o destino pois todo mundo já tem um interpretador de javascript nos seus browsers.
<br>

## Tipagem estática ou dinâmica

<br>

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
<br>

## Dinâmica
- dados tem tipos, e variáveis apontam para dados
Python:

~~~Python
    x=4
    x="qwerty"
    x=[3,4,5]
~~~
<br>

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

<br>

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

<br>

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

<br>

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
<br>

## Que linguagens vc deve saber
- C
- C++
- Java
- Python
- Javascript
<br>

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


<!--
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->


<details>
  <summary>Aula 1.5 - Continuação</summary>
  
# Aula 1.5
## Familias de sintaxe em linguagens de programação

<br>

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

<br>

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

<br>

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

<br>

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

<br>

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

<br>

### Separaçao entre comandos
familia C (rust,java, etc) “;”

mais moderno (python haskell, R, go, etc) mudança de linha

acho que todas ling mais modernas permitem mais de um comando por linha separados por “;”

listas e arrays
familia C: primeiro valor tem indice 0 (python, java, go, rust)

familia fortran : primeiro valor tem indice 1 (R, julia)

<br>

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

<br>

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

<br>

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

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->


<details>
  <summary>Aula 2 - Funções, If Then Else, Listas, Recursão, Pattern Matching, Let in </summary>

# Aula 2 - haskell super básico
##### [livro texto](http://learnyouahaskell.com/chapters) capitulos: 2 (tipos, if, funções e listas) , 4 (pattern matching e guards) e 5 (recursão)

##### [haskell online](https://repl.it/languages/haskell)
<br>

# Funções
Define a função usando nomes, parametros e o corpo da função depois do =
<br>

### Sintaxe:

- Sem parenteses para separar o nome da função e seus argumentos na definição e na chamada.

- Sem virgula separando os argumentos
~~~
duplica x = 2*x

duplica 56

soma a b = a + b

soma 2 (duplica 5)
~~~
<br>

## if then else
O **if** define que expressão retornar, e tem sempre um **else**

~~~Haskell
maior a b = if a>b 
              then a 
              else b 

maior 5 8
~~~

if é uma expressão que retorna algo
~~~Haskell
(if x>100 then x else 2*x) + 78
~~~
<br>

## Listas
Sintaxe como em python mas só de dados do mesmo tipo
~~~Haskell
[4,5,3,2,3,7]
~~~
`[]` <-- lista vazia
<br>
Função head e tail para obter o 1o elemento e o resto da lista
~~~Haskell
head [14,5,16]
14

tail [14,5,16]
[5,16]

tail [1]
[]
~~~
~~~Haskell
tail []
Exception: Prelude.tail: empty list
~~~
<br>
  
## Recursão - e apenas recursão

tamanho de uma lista
~~~Haskell
conta lista = if lista == [] 
           then 0
           else (1 + tamanho (tail lista))
~~~

quantas vezes x aparece na lista
~~~Haskell
vezes x lista = if lista == [] 
               then 0 
               else if head lista == x then 1 + vezes x (tail lista) 
                                   else vezes x (tail lista)
~~~

ou usando if como expressão
~~~Haskell
vezes x li  = if li == [] 
               then 0 
               else (if head li == x then 1 else 0) + vezes x (tail li)
~~~
<br>

##Pattern matching

Funções podem ser escritas como um conjunto de regras que especificam os formatos dos argumentos.

`(x:xs)` quebra a lista no head que é colocado em x e no tail que é colocado no xs A lista vazia não pode ser quebrada dessa forma

`[]` é equivalente a testar se o valor recebido é a lista vazia.

~~~Haskell
tamanho [] = 0
tamanho (x:xs) = 1 + tamanho xs

vezes _ []  = 0
vezes x (a:as) = (if x==a then 1 else 0) + vezes x as
~~~

`_` é uma variavel anonima que não pode ser usada (como em python)

Cuidado, não da para testar igualdade **entre valores** no pattern matching. O codigo abaixo nao dá certo:
~~~Haskell
---- ERRADO ERRADO -----
vezes _ [] = 0
vezes a (a:as) = 1 + vezes a as   <=== NAO FUNCIONA
vezes x (a:as) = vezes x as
~~~

remove o item x da lista (todas as instancias de x)
`++` concatena 2 listas
~~~Haskell
remove _ [] = []
remove x (a:as) = if x == a
                     then remove x as 
                     else [a] ++ (remove x as)
~~~

o `:` pode ser usado para construir listas

~~~Haskell
remove _  [] = []
remove x (a:as) = if x == a
                     then remove x as 
                     else a:(remove x as)
~~~
o “`:`” tem baixa prioridade - é feito “depois”. O parenteses em torno de `remove x (a:as)=` é preciso pois sem ele o haskell entenderia `(remove x a) : as =` que é um erro de sintaxe.

Mas na ultima linha acima, a chamada da função tem maior prioridade. assim isso poderia ser escrito como
~~~Haskell
remove _  [] = []
remove x (a:as) = if x == a
                     then remove x as 
                     else a : remove x as
~~~
Mas use parenteses se vc estiver inseguro/insegura.
<br>

## let in
**let … in** - define as variáveis e funções locais antes da chamada/expressão principal
~~~Haskell
maior [x] = x
maior (x:xs) = let
         mm = maior xs
     in if x>mm then x else mm
~~~
<br>

## Proxima aula
- guards
- list comprehension
- where

# Exercicios
Fazer os exercícios usando `head` `tail` `:` `++` `mod` (modulo), `let` e pattern matching

Alguns são bem dificies de fazer usando apenas os conceitos da aula 1!

1. tamanho de uma lista
2. conta quantas vezes o item aparece na lista (0 se nenhuma)
3. soma dos elementos de uma lista
4. soma dos números pares de uma lista ( modulo = mod)
5. retorna o ultimo elemento de uma lista
6. existe item x na lista (True ou False)
7. dado n gera a lista de n a 1
~~~Haskell
range_rev n = if n==1
        then [1]
        else n:range_rev (n-1)
~~~
ou
~~~Haskell 
range_rev' 1 = []
range_rev' n = n: range_rev (n-1)
posição do item na lista (0 se não esta lá, 1 se é o primeiro) **
~~~

8. reverte uma lista
~~~Haskell
-- tradicional fold right
rev1 [] = []
rev1 (x:xs) = rev1 xs ++ [x]
~~~

9. com acumulador do trabalho anterior fold left
~~~Haskell
rev lista = rev2 lista []
rev2 [] acc = acc
rev2 (x:xs) acc = rev2 xs (x:acc)
~~~

10. dado n gera a lista de 1 a n **
11. retorna a lista sem o ultimo elemento **
12. soma dos elementos nas posições pares da lista ( o primeiro elemento esta na posição 1)
13. intercala 2 listas (intercala1 e intercala2)
~~~
intercala1 [1,2,3] [4,5,6,7,8]
 ==> [1,4,2,5,3,6]
intercala2 [1,2,3] [4,5,6,7,8]
 ==>  [1,4,2,5,3,6,7,8]
~~~

14. a lista já esta ordenada? Retorna True ou False
15. shift para a direita
~~~
shiftr [1,2,3,4]
 ==> [4,1,2,3]
~~~

16. shiftr n lista (shift direita n vezes)
17. shift left
18. shift left n vezes
19. remove o item da lista (1 vez só)
~~~
remove1 4 [2,3,4,5,4,3,2,1]
==> [2,3,5,4,3,2,1]
~~~

20. remove item da lista (todas as vezes)
~~~
removeall 4 [2,3,4,5,4,3,2,1,4,4,3]
==> [2,3,5,3,2,1,3]
~~~

21. remove item da lista n (as primeiras n vezes)
~~~
removen 4 2 [2,3,4,5,4,3,2,1,4,4,3]
==> [2,3,5,3,2,1,4,4,3]
~~~

22. remove item da lista (a ultima vez que ele aparece) **
23. troca velho por novo na lista (1 so vez)
~~~
troca1 8 10 [2,4,6,8,11,12]
==> [2,4,6,10,11, 12]
~~~

24. troca velho por novo na lista (todas vezes)
25. troca velho por novo na lista (as primeiras n vezes)
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->


<details>
  <summary>Aula 3 - Guards, Variáveis e Funções Locais, Recursão com acumulador, List Comprehension, Tupla</summary>

# Aula 3
TROCOU O LINK PARA O LIVRO TEXTO

##### [livro texto](https://learnyouahaskell.github.io/chapters) capitulos: 2 (tuplas, range, list comprehension) , 4 (where, let, case) e 5 (recursão)

#### [haskell online](https://repl.it/languages/haskell)

## Sintaxe 
<br>

### Precedencia
a b c d + g h i
- funçoes tem maior prioridade (gruda antes) que operadores (prioridade 10)
- operadores tem prioridades de 9 a 1 (https://www.haskell.org/onlinereport/decls.html#fixity)
- isso é a soma de a b c d com g h i que em sintaxe tradicional de linguagens de programação é a(b,c,d) e g(h,i)
<br>

## Blocos
- indenta com brancos
- (acho) que dentro do bloco precisa esta alinhado
- os diferentes blocos nao precisam estar alinhados entre si (como no Python)

~~~Haskell
maior a b = if a>b 
              then a 
              else b
~~~
<br>

## Guards
~~~Haskell
maior a b = if a > b 
       then a
       else b

maior' a b 
 | a > b = a
 | otherwise = b
~~~
Da notação matemática, mas com a condição antes do valor

$$f(a,b) =
  \begin{cases}
    a       & \quad \text{if } a \text{ > b} \\
    b  & \quad \text{otherwhise } 
  \end{cases}
\$$
 
<br>

## Variáveis e funções locais
posição do item na lista (0 se nao esta la, 1 se é o primeiro)
~~~Haskell
posicao it [] = 0
posicao it (x:xs) 
  | it == x = 1
  | otherwise = if (posicao it xs) == 0 then 0 else (posicao it xs) + 1  
  --- dupla recursao a nao ser que (posicao it xs) == 0
~~~

`where` - define as variáveis (e funções) locais depois da chamada “principal”
~~~Haskell
maior [x] = x
maior (x:xs) = if x>mm then x else mm
    where mm = maior xs
~~~

`let … in` - define as variáveis e funções locais antes da chamada principal
~~~Haskell
maior [x] = x
maior (x:xs) = let
         mm = maior xs
     in if x>mm then x else mm
~~~

`where` permite continuar usando guards

~~~Haskell
maior [x] = x
maior (x:xs) 
   | x>mm = x
   | otherwise = mm
   where mm = maior xs
~~~
<br>

## Recursão com acumulador
As funções recursivas até agora são do tipo - recursao no resto da lista e depois computa a solução com a cabeça da lista
~~~Haskell
soma [] = 0
soma (x:xs) = x + (soma xs)
~~~

A ideia do acumulador é fazer o calculo usando o head e o acumulador recebido e passar o acumulador alterado para a recursão.
O acumulador acumula o trabalho das instancias que vieram antes da recursão

~~~Haskell
--  soma' l acc
soma' [] acc = acc   -- caso base sempre retorna o acumulador
soma' (x:xs) acc = soma' xs (acc+x) 
-- caso recursivo faz primeiro a conta (acc+x) e so no final chama a recursao
~~~

Mas a primeira chamada funçao **soma'*** precisa setar o acumulador da forma certa. A funçao **soma'** é uma função local de soma

~~~Haskell
soma l = soma' l 0
  where soma' [] acc = acc
        soma' (x:xs) acc = soma' xs (x+acc)
~~~
<br>

## Caso do reverte
reverte uma lista
~~~Haskell
reverte [] = []
reverte (x:xs) = (reverte xs) ++ [x]
~~~

Esse codigo é quadratico pois o `++` passeia pela primeira lista “até achar o final” para grudar a segunda lista (se a lista é implementada como uma lista ligada)

- segundo a resposta em https://stackoverflow.com/questions/2688986/how-are-lists-implemented-in-haskell-ghc no Haskell listas são implementadas como lista ligadas)

- em python listas são implementadas como dynamic array veja: https://medium.com/analytics-vidhya/how-lists-are-implemented-in-python-9b055fbc8d36

~~~
T(n) = T(n-1)+n+c
==> T(n) = O(n^2)
~~~

neste caso, recursão com acumulador torna a função linear

~~~Haskell
reverte l = reverte' l []
   where 
     reverte' [] acc = acc
     reverte' (x:xs) acc = reverte' xs (x:acc)
~~~
<br>

## List Comprehension
~~~
[ f x | x <- fonte, condicao1, condicao2]
[ x+10 | x <- [1..10], x `mod` 2 == 0]
~~~

`[1..10]` é um `..`(range) - gera uma lista de 1 a 10
`[2,5..30]` gera a lista [2,5,8,11,14,17,20,23,26,29]

~~~Haskell
somapares xs = soma [x | x <- xs, x `mod` 2 == 0]
~~~
<br>

## Tupla
Como a tupla do Python, mas funcoes de listas nao funcionam em tuplas
~~~
head ("Jose" , 47)
~~~
Pattern matching funciona em tuplas
~~~Haskell
somaAno (n,id) = (n, id+1)
~~~

Para tuplas de 2 elementos:
~~~Haskell
fst ("jose",3)
==> "jose"

fst (a,b) = a

snd ("jose",3)
==> 3

snd (a,b) = b
~~~
Retornar uma tupla é o jeito para uma função retornar mais de uma coisa
<br>

## Trocaultimo
troca a ultima vez na lista que aparece o valor velho pelo valor novo - apenas na ultima vez que velho aparece
~~~Haskell
trocaultimo velho novo lista = fst (trocaultimo' velho novo lista)

trocaultimo' velho novo []  = ([],False)
trocaultimo' velho novo (x:xs) = let
             (xxs,trocou) = trocaultimo' velho novo xs
          in if trocou || (x /= velho)  then (x:xxs, trocou)
                                        else (novo:xxs, True)
~~~
**trocaultimo** retorna uma tupla com a lista trocada e um booleano se ele trocou ou nao o velho pelo novo.

Mais simples:
~~~Haskell
trocaultimo n v l = reverte (troca1 n v (reverte l))
~~~
<br>

# Exercícios
refaça os exercicios da aula passada usando variaveis locais, recursão com acumulador, list comprehension, funções retornando tuplas, combinando funções ja implementadas, etc se for o caso. Em particular tente usar acumuladores para aprender a pensar dessa forma.

Alem disso faça:
1. posicoes - dado um item e uma lista, retorna uma lista com todas as posicoes (primeiro elemento esta na posição 1) do item na lista
2. split - dado um item e uma lista retorna uma lista de listas, todos os elementos da lista antes do item (a primeira vez que ele aparece) e todos depois
~~~Haskell
split "qwertyuiopoiuyt" 't'
--==> ["qwer", "yuiopoiuyt"]
~~~
3. splitall - mesma coisa que o split mas retorna todas as sublistas
~~~Haskell
splitall "qwertyuiopoiuytxxt" 't'
==> ["qwer", "yuiopoiuy", "xx", ""]  ou  ["qwer", "yuiopoiuy", "xx"]
~~~

4. drop n lista - a lista sem os n primeiros elementos - essa função já esta implementada no Prelude
5. take n lista - os primeiros n elementos da lista - essa função já esta implementada no Prelude
</details>


<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->


<details>
  <summary>Aula 4 - Tipos em Haskell, Definindo o tipo na declaração da função</summary>

# Aula 4
##### [livro texto](https://learnyouahaskell.github.io/chapters) capitulos: 3

#### [haskell online](https://repl.it/languages/haskell)


## Por que aprender Haskell!!
~~~Haskell
qs [] = []
qs (x:xs) = qs menores ++ [x] ++ qs maiores
    where  menores = [y | y <- xs, y<=x]
           maiores = [y | y <- xs, y>x]
~~~
<br>

## Tipos
~~~Haskell
:t head
head :: [a] -> a
~~~

indica uma função que recebe uma lista de valores do tipo a e retorna um valor do tipo `a`

**a** é uma variável de tipo (type variable)

~~~Haskell
removeAll c lista = [y | y <- lista, y /= c]

:t removeAll
removeAll :: Eq t => t -> [t] -> [t]
~~~

a parte “`t -> [t] -> [t]`” indica que é uma função de 2 argumentos, um dado e uma lista de dados, que retorna uma lista de dados (porque os 2 argumentos são separados por uma flecha fica para outra aula - **currying**)

“`Eq t =>`” indica que o tipo `t` tem restrições, e tem que pertencer ao typeclass Eq que sao tipos para os quais a comparação de igualdade esta definida (quase todos mas não funções!!)

- Eq tem igualdade (==)
- Ord tem ordem (>)
- Num tem as operações aritméticas (+, -, * e abs) definidas . Num é parte do Eq mas não do Ord (números complexos não tem ordem!!) Divisão nao esta incluida nos Num por causa dos inteiros
- Show pode ser impresso (convertido para string) - função show
- Read pode ser lido (de um string) - função read

Quando voce definir seus tipos, voce poderá definir o que == (Eq) significa para o seu tipo, da mesma forma o show, read, < etc
<br>

## Tipos básicos
- Int inteiros de maquina
- Integer inteiros sem limite de tamanho (como no Python)
- Float do C
- Double do C
- Bool booleano
- Char caracter
<br>

## Outros tipos genéricos
- Integral genérico de inteiros e operação de divisão inteira e resto
- Fractional genérico para floats e operação de divisão real
- Floating generico para floats e operações exponenciais, trigonométricas, etc
<br>

## Booleanos
- True
- False
- || or nas comparações
- && and nas comparações
- not
- and é o and de uma lista de booleanos

~~~Haskell
Prelude> :t and
and :: Foldable t => t Bool -> Bool
~~~
`t` é qualquer modificador de tipo que é Foldable - lista [] é um modificator foldable

~~~Haskell
membro x [] = False
membro x (a:as) 
    | x == a = True
    | otherwise = membro x as

-- ou

membro x [] = False
membro x (a:as) = x==a || membro x as
~~~

4 \`membro` [ 3,2,4,5,6,4,3,2,1]

para toda toda função binaria f voce pode criar um operador), uma função infixa

~~~
f arg1 arg2 

arg1 `f` arg2
~~~

<br>

## Definindo o tipo na declaração da função
~~~Haskell
ordenada :: Ord a => [a] -> Bool
ordenada [] = True
ordenada [x] = True
ordenada (a:b:xs)
   | a <= b = ordenada (b:xs)
   | otherwise = False

-- ou 

ordenada [] = True
ordenada [x] = True
ordenada (a:b:xs) = a<=b && ordenada (b:xs)
remove1 :: Eq a => a -> [a] -> [a]
remove1 _ _ [] = []
remove1 it (x:xs) 
  | x == it = xs
  | otherwise =  x : (remove1 it xs)
~~~
remove1 8  [2,4,5,8,7,6,8,7]

remove1 'a' "qwertiaiuyta"
não é preciso declarar o tipo da função, o haskell infere, mas de vez em quando isso ajuda no debug.
<br>

## Exemplos de exercicios
### Posicoes
~~~Haskell
posicoes :: Eq a => a -> [a] -> [Int]
posicoes _ [] = []
posicoes it (a:as)
    | it == a = 1:resto
    | otherwise = resto
    where
      resto = soma1 (posicoes it as)
      soma1 [] = []
      soma1 (n:ns) = (n+1): (soma1 ns)
~~~
outra solucao - um parametro a mais

~~~Haskell
posicoes it lst = posicoes' it lst 1

posicoes' _ [] _ = []
posicoes' it (a:as) n =
    let aux = posicoes' it as (n+1)
    in if it == a 
        then n:aux
        else aux
~~~
<br>

## Split
uma ideia baseada em acumulador, vai acumulando os itens “errados” ate achar o item separador

~~~Haskell 
split:: Eq a => a -> [a] -> [[a]]
split sep lista = split' sep lista []

split' _ [] acc = [acc] -- diferente da recursao com acumulador tradicional
split' sep (x:xs) acc 
    | sep==x = [acc, xs]
    | otherwise = split' sep xs acc_novo
        where acc_novo = acc ++ [x]
~~~
o split' deve no futuro ser uma funcao local do split, mas para testar crie ele como uma função global.


### melhorias

- sempre fique suspeito de coisas como acc ++ [a]
- grudar no final é custoso, grudar na frente é rápido, mas a ordem fica inversa
- grude na frente e no final chame o reverte

~~~Haskell
split' _ [] acc = [reverse acc] 
split' sep (x:xs) acc 
    | sep==x = [reverse acc, xs]
    | otherwise = split' sep xs (x:acc)
~~~

split 4 [1,2,3,4,5,6,4,3]

split 4 [4,1,2,3]

split 14 [1,2,3,4,5,6,4,3]
a resposta para o ultimo caso poderia ser melhor.
<br>

## Splitall
Usando funçoes já definidas:

~~~Haskell
splitAll :: Eq a => a -> [a] -> [[a]]
splitAll sep lista = let
    res = split sep lista

    segundo [_,a] = a
    
    tamanho [] = 0
    tamanho (a:as) = 1 + tamanho as
    
    in if (tamanho res) == 1 
        then res 
        else (head res) : (splitAll sep (segundo res))
~~~
No let eu misturo variaveis locais e funcoes locais - ficou um pouco confuso. Seria melhor definir as funcoes fora.

splitAll 5 [1,2,3,4,5,6,5,4]

splitAll 5 [1,2,3,4,5,6,5,4,5]

splitAll 5 [1,2,3,4,5,6,5,4,5,5]

splitAll 15 [1,2,3,4,5,6,5,4,5,5]
ultimos 2 casos poderiam ser melhores….
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->

<details>
  <summary>Aula 5 - Currying, Funções de funções, o $, Map e Filter, Folds</summary>

  # Aula 5
##### [livro texto](http://learnyouahaskell.com/chapters) (cap 6)
##### [haskell online](https://repl.it/languages/haskell)
##### [outro - so compilado](https://www.jdoodle.com/execute-haskell-online)

<br>

## Para o compilado
~~~Haskell
main = do
       print $ sua funcao com argumentos
~~~

<br>

# Currying
toda funçao em Haskell é “na verdade” uma funçao de 1 argumento (que pode retornar funções)

~~~Haskell
max 4 5

(max 4) 5

let w = max 4

w 3
w 5
:t w
w :: (Ord a, Num a) => a -> a
~~~
`w` precisa receber um `Ord` por causa do `max` mas também um Num por causa do 4

~~~Haskell
Prelude> :t max
max :: Ord a => a -> a -> a
~~~
<br>

Na interpretação da aula passada, `max` é uma função de 2 argumentos `a -> a` que retorna um `a` (e o `a` tem que satisfazer o `Ord`)

Na interpretação de currying o tipo de max é na verdade
~~~Haskell
      max :: Ord a => a -> (a -> a)
~~~
ou seja `max` recebe um `a` e retorna uma função que esta esperando um `a` para retornar um `a` (que é a função armazenada em `w`)

Veja que nos podemos escrver a função `w` como

~~~Haskell
w x = max 4 x

w = max 4
~~~
essa segunda versão/notação é chamada de **point-free style**

Funções infixas (+, etc) para funções unárias:

~~~Haskell
(8+)
:t (+8)
f1 = (<5)
:t f1

f2 = (5>)
:t f2

maiuscula = (`elem` ['A'..'Z'])
~~~

(<5) (expressoes infixas incompletas) são chamados **sessions**
<br><br>

# Funções que recebem funções como argumento
~~~Haskell
aplica2 f x = f (f x)
:t aplica2
aplica2 :: (t -> t) -> t -> t
zipWith' f [] _ = []
zipWith' f _ [] = []
zipWith' f (a:as) (b:bs) = f a b : (zipWith' f as bs)

zipWith' (+) [1..5] [1000..1004]
flip' f = g 
    where g x y = f y x 

zipWith' (flip' div) [2,2,2,1] [10,8,4,0]
~~~
`flip` e `zipWith` já estão definidas

<br>

# o $
~~~Haskell
aplica2 f x = f (f x)

aplica2 f x = f $ f x
:t aplica2
~~~
o `$` é um abre parênteses com o fecha parênteses implicito no fim do comando.

o `$` é um `pipe` f (g (h x)) = f $ g $ h x

<br>

# Map e filter
~~~Haskell
map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (a:as) = f a : (map f as)

map (5-) [10,8..0]
~~~
~~~Haskell
filter :: (a -> Bool) -> [a] -> [a]  
filter _ [] = []  
filter p (x:xs)   
    | p x       = x : (filter p xs)  
    | otherwise = filter p xs  

impar x = x `mod` 2 == 1

filter impar [1,5,4,3,6,7,8]
~~~

map e filter ja estao definidas

Num certo sentido, o list comprehension combina o `map` e o `filter`

~~~Haskell
map f $ filter p lista 
[ f x | x <- lista, p x]
~~~
<br>

# Funções anônimas
Cria funções sem nomes


\ argumentos -> corpo

~~~Haskell
filter (\ x -> x `mod` 2 == 1) [1,5,4,3,6,7,8]

zipWith (\a b -> if a>b then a+3 else b-1) [1,2,3,4] [5,4,3,2]
~~~
<br>

# Fold
<br>

## foldr
`foldr` é a recursao tradicional (o resultado vem da direita - fim da lista)

~~~Haskell
soma [] = 0
soma (x:xs) = x + (soma xs)

-- foldr combina valor-inicial lista
foldr _ init [] = init
foldr f init (x:xs) = f x (foldr f init xs)

soma l = foldr (+) 0 l

soma = foldr (+) 0
~~~

~~~
:t foldr
veja o tipo da funçao de combinação
~~~
<br>

## foldl
`foldl` é a recursao com acumulador, que o resultado vem da esquerda - do começo da lista

~~~Haskell
-- foldl combina valor-inicial lista

somaacc acc [] = acc
somaacc acc (x:cs) = somaacc (acc+x) xs


foldl _ acc [] = acc
foldl f acc (x:xs) = foldl f  (f acc x) xs


somaacc l = foldl (+) 0 l

somaacc = foldl (+) 0
~~~

~~~
:t foldl
veja o tipo da funçao de combinação
~~~
<br>

## foldr1 e foldl1

`foldr1` é o `foldr` onde o valor inicial é o ultimo elemento

`foldl1` é o `foldl` onde o valor inicial do acumulador é o primeiro elemento

~~~Haskell
minimo = foldl1 (\a b -> if a<b then a else b) 
minimo = foldl1 min

produto = foldr1 (*)

produtoescalar l1 l2 = foldr1 (+) $ zipWith (*) l1 l2

produtoescalar  = foldr1 (+) $ zipWith (*)
~~~
<br>

# Exercícios
- reimplemente os exercicios da aula 1 e 2 usando as funcoes de alto nivel
(map, filter, fold)

- uma matrix é implementada como uma lista de linhas (que são listas)
  <center>
&emsp;&emsp; 1 &emsp;  2 &emsp;  3<br>
&emsp;&emsp; 4 &emsp;  5 &emsp;  6<br>
&emsp;&emsp; 7 &emsp;  8 &emsp;  9<br>
&emsp;&emsp; 0 &emsp;  0 &ensp;  -1<br>

&emsp;&emsp; [[1,2,3],[4,5,6],[7,8,9],[0,0,-1]]
</center>

- implemente transposta que transpoe uma matrix

- implemente matmul que dado duas matrizes de formatos apropriados multiplica-as.
</details>


<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->



<details>
  <summary>Aula 6 - Exemplos das funções vistas na Aula 5</summary>

  # Aula 6
##### [livro texto](http://learnyouahaskell.com/chapters) (cap 6)
##### [haskell online](https://repl.it/languages/haskell)
##### [outro - so compilado](https://www.jdoodle.com/execute-haskell-online)

<br>


# Mergesort

~~~Haskell
mergesort :: Ord a => [a] -> [a]

mergesort [] = []
mergesort [x] = [x]
mergesort xs =
  merge (mergesort x1) (mergesort x2)
  where
    n = (length xs) `div` 2
    x1 = take n xs
    x2 = drop n xs

merge [] b = b
merge a [] = a
merge (a:as) (b:bs)
  | a< b = a: (merge as (b:bs))
  | otherwise = b : (merge (a:as) bs)
drop e take ja estao implementados no prelude

drop 0 x = x
drop n (x:xs) = drop (n-1) xs

take 0 _ = []
take n (x:xs) = x:(take (n-1) xs)
~~~
<br>

# Exemplos
## Conta quantas vezes um item aparece numa lista

~~~Haskell 
conta item lista = sum $ map (\ x -> if x==item then 1 else 0) lista

conta item lista = sum [if x==item then 1 else 0 | x<- lista]

conta item lista = foldl (\ acc x -> if x==item then acc+1 else acc) 0 lista

conta item lista = foldr (\ x res -> if (x==item then res+1 else res) 0 lista

conta item = foldr (\ x res -> if (x==item then res+1 else res) 0       -- point-free
~~~
veja que a função anonima faz acesso ao parametro item isso significa que ele nao pode ser uma funçao externa (precisa ser local ou anonima)
<br>

# Membro e Remove
~~~Haskell
membro item lista = foldl (\ acc x -> x==item || acc) False lista


remove it lista = foldr (\ x res -> if x==it then res else x:res) [] lista
~~~
ja existe a função elem e essa implementação de membro é meio feia - nao há necessidade de ir ate o fim da lista

~~~Haskell
membro item [] = False
membro item (x:xs) 
    | x == item = True
    | otherwise = membro item xs
~~~
<br>

# Reverte
~~~Haskell
reverte lista = rev' lista []
    where 
        rev' [] acc = acc
        rev' (x:xs) acc = rev' xs (x:acc)
    

reverte lista = foldl (\ acc x -> x:acc) [] lista

reverte = foldl (\ acc x -> x:acc) []    --- point free
 
reverte = foldl (flip (:)) []            -- !!!!!!!
~~~
<br>

# Soma cumulativa
~~~Haskell
-- recussao tradicional com um parametro a mais (soma ate agora)

somacum (x:xs) = sc xs x
    where
        sc [] soma = [soma]
        sc (a:as) soma = (soma+a) : (sc as (soma+a))



-- com accumulador mas monta a lista ao contrario

somacumx (x:xs) = scx xs [x]
    where 
        scx [] acc = acc
        scx (x:xs) (a:as) = sc xs ((x+a):(a:as))


somacum (x:xs) = reverse $ foldl comb [x] xs
    where 
        comb all@(x:xs) a = x+a:all
~~~
<br>

# Todas as posicoes de um item numa lista

~~~Haskell
let lista1 = [2,3,1,4,5,4,3,4,6,1,1,0]


-- tradicional 

posicoes it [] = []
posicoes it (x:xs) 
    | x == it = 1:res
    | otherwise = res
    where 
        res = map (1+) $ posicoes it xs

-- foldl passando uma tupla (posicao autual e resultado) 

posicoesx it lista = foldl comb (1,[]) lista
    where 
        comb (n,l) x 
            | x == it = (n+1,n:l)
            | otherwise = (n+1,l)

posicoes it lista = reverse $ snd $ posicoesx it lista
~~~
<br>
        
# Transposta de uma matriz
~~~Haskell
let mat1 = [[1,2,3],[4,5,6],[7,8,9],[0,0,-1]]
let mat1tr = [[1,4,7,0],[2,5,8,0],[3,6,9,-1]]


-- caso recursivo tansp m = (map head m) : (transp (map tail m))
-- caso base? quando a matriz para ser transposta é da forma [[],[],[],...,[]]

transposta ([]:_) = []
transposta mat = (map head mat) : (transposta (map tail mat))
~~~
<br>

# Outra versão do transposta proposto por um aluno
~~~Haskell
-- caso base trnasposta de uma linha da uma coluna
transposta [x] = map (\z -> [z]) x

-- caso recursivo: insere os elementos da linha (l) no comeco das
-- linhas da transposta
transposta (l:ls) = zipWith (:) l (transposta ls)
~~~
<br>

# Multiplicacao de duas matrizes

~~~Haskell
let m1 = [[1,2,3],[4,5,6]]
let m2 = [[7,8],[9,10],[11,12]]
let mresp = [[58,64],[139,154]] -- https://www.mathsisfun.com/algebra/matrix-multiplying.html
    
let m2transp = [[7,9,11],[8,10,12]]    
    
    
prodesc l1 l2 = sum $ zipWith (*) l1 l2

matmul' [] _ = []
matmul' (x:xs) m2t = (map (prodesc x) m2t) : (matmul' xs m2t)


matmul m1 m2 = matmul' m1 $ transposta m2
~~~
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->

<details>
  <summary>Aula 7 - Multiplicação de Matrizes, Lazy Evaluation, Criando os Próprios Tipos</summary>

  # Aula 7
livro texto (cap 8 Algebraic data types intro e Recursive data structures apenas)

##### [livro texto](http://learnyouahaskell.com/chapters) (cap 8)
##### [haskell online](https://replit.com/@mc346b)

# Multiplicacao de matrizes
##### original (ultima aula)

~~~Haskell
prodesc l1 l2 = sum $ zipWith (*) l1 l2

matmul m1 m2 = matmul' m1 $ transposta m2

matmul' [] _ = []
matmul' (x:xs) m2t = (map (prodesc x) m2t) : (matmul' xs m2t)
~~~

com o duplo map:
~~~Haskell
matmul' m1 m2t = map ('x -> (map (prodesc x) m2t) m1
~~~
<br>

# lazy evaluation
`[1..1000]` não cria uma lista de 1000 elementos, cria um objeto que dá um elemento por vez quando recebe o pedido, chamados `thunk`. A vantagem é que isso nao aloca memoria para 1000 números

`[7..]` é um thunk que gera 7, depois 8, depois 9, etc mas não aloca memoria para uma lista infinita

`map (1+) [7..]` nao roda, cria apenas uma promessa de rodar. Se alguem predir pelo primeiro valor, o thunk retorna 8, e o resto continua um thunk

`aux (x:xs) =  ...` é uma operação que pede o 1o elemento de um thunk (que foi passado para a função aux. o xs continua um thunk!!!

### tudo em haskell sao thunks, promessas de computação.

só na hora de print (no repl) é que a promessa é executada. Ha outros contextos que executam os thunks - `strict` (em oposicao a lazy)

~~~Haskell
a = [1..]
take  3 a
b = map (5+)  a  -- nao roda!!
let {double [] = [] ; double (x:xs) = (2*x):(double xs)}
c = double b
d = take 3 c
d
~~~

de vez em quando, thunks são jogados fora antes de computar o seu valor. O `take` é implementado como

~~~Haskell
take 0 resto = []
take n (x:xs) = x: take (n-1) xs
~~~
- o thunk resto na primeira regra é jogado fora! (garbage collected)
- na hora de execução a segunda regra pede o 1o elemento do thunk `(x:xs)` e monta o `take (n-1) xs`

~~~Haskell
posicoes it lista = filter (>0) $ 
    zipWith (\ x p -> if (x==it) then p else 0) lista [1..]
~~~
<br> 

# Criando seus proprios tipos

~~~Haskell
data

data Ponto = Ponto Float Float -- x e y de um ponto
data Figura = Circulo Ponto Float | Retangulo Ponto Ponto

area (Circulo _ r) = 2 * 3.14 * r
area (Retangulo (Ponto xa ya) (Ponto xb yb)) = abs ((ya-yb)*(xa-xb))
data Ponto = Ponto Float Float deriving (Eq,Read,Show)
~~~
o `deriving (Eq,Show,Read)` extende trivialmente o `==` e as funções `show` e `read` para que o novo tipo `Ponto` seja subtipos de `Eq, Show e Read`


Definição de tipos pode conter variaveis de tipo

~~~Haskell
data Tree a = Vazia | No a (Tree a) (Tree a) deriving (Eq,Show,Read)
~~~

Isso define uma arvore binária de a seja o que for a
<br>


# Pattern matching
O pattern matching funciona nos tipos construidos pelo programador

~~~Haskell
soma Vazia = 0
soma (No x ae ad) = soma ae + soma ad + x
~~~

~~~Haskell
distancia (Ponto x y) (Ponto a b) = sqrt (dx**2 + dy**2)
        where  dx = x - a
               dy = y - b
~~~

# Exercicios
arvore de busca binaria (abb): o no da raiz é maior que todos nós a esquerda e menor que todos nós a direita, e isso vale recursivamente.

data Tree a = Vazia | No a (Tree a) (Tree a) deriving (Eq,Show,Read)
- acha um item numa arvore de busca binaria (abb)

- verifica se uma arvore é um abb

~~~Haskell
isAbb :: Ord a => Tree a -> Bool 


isAbb Vazia  = True
isAbb (No _ Vazia Vazia) = True
isAbb (No x Vazia ad) = isAbb ad && x < menor ad
isAbb (No x ae Vazia) = isAbb ae && x > maior ae
isAbb (No x ae ad) = isAbb ae && isAbb ad && x < menor ad && x > maior ae

maior (No x _ Vazia) = x
maior (No x _ ad) = maior ad

menor (No x Vazia _) = x
menor (No x ae _) = menor ae
~~~

- insere um item numa abb

- remove um item de uma abb

- calcula a profundidade maxima de uma abb

- coverte uma abb numa lista em ordem infixa (arvore-esquerda, no, arvore-direita)

- converte uma abb numa lista em ordem prefixa (no, ae, ad)

- converte uma lista em uma abb

- converteparaabb :: Ord a => [a] -> Tree a

~~~Haskell
converteparaabb lista = foldl insereabb' Vazia lista
    where 
        insereabb' Vazia x = No x Vazia Vazia
        insereabb' (No y ae ad) x
            | x == y =  No y ae ad
            | x < y  =  No y (insereabb' ae x) ad
            | otherwise = No y ae (insereabb' ad x)
~~~
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->


<details>
  <summary>Aula 8 - Composição de Funções, Módulos, Base Packages: Data.List, Data.Char, etc, I/O </summary>

# Aula 8
#### [livro texto](http://learnyouahaskell.com/chapters) (cap 7)
#### [Haskell online](https://repl.it/languages/haskell)
#### [compilado](https://www.jdoodle.com/execute-haskell-online)

# Faltou em funções de alto nivel
~~~
f (g (h x)))

f $ g $ h x

(f . g . h) x
~~~
`.` é a composição de 2 funcoes, normalmente usado em map

~~~Haskell
map (f . g) lista

map (\x -> f (g x)) lista
~~~
<br> 

# da aula passada
~~~Haskell
data Tree a = Vazia | No a (Tree a) (Tree a) deriving (Eq,Show,Read)

insereabb :: Ord a => a -> Tree a -> Tree a

insereabb x Vazia = No x Vazia Vazia
insereabb x (No y ae ad)
    | x==y = No y ae ad
    | x<y  = No y (insereabb x ae) ad
    | x>y  = No y ae (insereabb x ad)
    
listatoabb :: Ord a => [a] -> Tree a

listatoabb lst = foldl (flip insereabb) Vazia lst
~~~
<br>

# Modulos
~~~Haskell
import Data.List  -- tudo !!!

import Data.List (nub,sort)  -- apenas

import qualified Data.List as DL -- qualificado

DL.sort
~~~
<br>

# base packages
https://hackage.haskell.org/package/base
<br>
<br>

# Data.List
De uma olhada em [Data.List](https://hackage.haskell.org/package/base-4.20.0.1/docs/Data-List.html)

- `fold, map, filter, elem,` etc

- `sum, maximum`

- `!!` - acesso a um elemento (indexado apartir do 0)

- `zip, zipWith`

- `lines` - divide um stringão em linhas

- `words` - divide um string em palavras (igual ao split() do python)

- `unlines e unwords` - inverso das funcoes acima

- `sort`

- `nub` - remove duplicadas, `partition`

- `sortBy deleteBy groupBy nubBy`

- operações em conjuntos: `union, //` (set difference) etc
<br>

# Data.Map.Strict
containers: https://hackage.haskell.org/package/containers

intro https://haskell-containers.readthedocs.io/en/latest/

https://haskell-containers.readthedocs.io/en/latest/map.html

dicionários (implementados como arvores binarias balanceadas, e tempo de acesso = **O(logn)**

[Data.Map.Strict](https://hackage.haskell.org/package/containers-0.7/docs/Data-Map-Strict.html)

- `empty` - dicionario vazio

- `fromList ::  Ord k => [(k, a)] -> Map k a` - lista de duplas para um dicionário

- `fromListWith :: Ord k => (a -> a -> a) -> [(k, a)] -> Map k a` - o primeiro argumento é uma função que combina 2 valores que tiverem a mesma chave

- `insert Ord k => k -> a -> Map k a -> Map k a` - insere num dicionário

- `insertWith` - função de combinação entre valor velho e novo.
  - Insert with a function, combining new value and old value. insertWith f key value mp will insert the pair (key, value) into mp if key does not exist in the map. If the key does exist, the function will insert the pair (key, f new_value old_value).

- `delete Ord k => k -> Map k a -> Map k a`

- `lookup :: Ord k => k -> Map k a -> Maybe a` - **(a ser discutido na aula que vem)**

- `member Ord k => k -> Map k a -> Bool` - Retorna um booleano

`map :: (a -> b) -> Map k a -> Map k b` - map nos valores

- mapWithKey :: (k -> a -> b) -> Map k a -> Map k b` - map que recebe a chave e transforma os valores

- `elems :: Map k a -> [a]`

- `keys :: Map k a -> [k]`

- `foldr` e `foldl` - funciona (com valores)

- import qualified `Data.Map.Strict as Map`

- `insertWith :: Ord k => (a -> a -> a) -> k -> a -> Map k a -> Map k a`
<br>

# Data.char
https://hackage.haskell.org/package/base-4.20.0.1/docs/Data-Char.html
<br>
<br>
# Exercicos (resposta)
~~~Haskell
data Tree a = Vazia | No a (Tree a) (Tree a) deriving (Eq,Show,Read)

removeabb :: Ord a => a -> Tree a -> Tree a

removeabb _ Vazia = Vazia
removeabb x (No y ae ad) 
    | x < y  = No y (removeabb x ae) ad
    | x > y  = No y ae (removeabb x ad)
    | x == y = aux1 x ae ad
    

aux1 x ae ad 
    | ae == Vazia = ad
    | otherwise = No novaraiz (removeabb novaraiz ae) ad
    | 
    where
        novaraiz = omaior ae
    
omaior (No x _ Vazia) = x
omaior (No _ _ ad) = omaior ad
~~~
essa é uma solução (deselegante).

- o removeabb cuida dos casos simples
- aux1 cuida do caso complicado (remover uma raiz de uma arvore com os 2 lados
a solucao é deselegante por razoes sintaticas (poderia tudo esta como funções auxiliares) mas principalmente porque vc tem que andar pela arvore a esquerda 2 vezes, para achar o maior e para remove-lo

podemos fazer isso de uma so vez

~~~Haskell
acha_remove_maior :: Ord a => Tree a -> (a,Tree a)

acha_remove_maior (No x ae Vazia) = (x,ae)
acha_remove_maior (No x ae ad) = (maior, No x ae nova_ad)
    where
        (maior,nova_ad) = acha_removemaior ad
~~~

agora aux1 fica

~~~Haskell
aux1 x ae ad 
    | ae == Vazia = ad
    | otherwise = No nova_raiz ae nova_ad
    where
        (nova_raiz,nova_ad) = acha_removemaior ad
~~~
melhor ainda é nao definir `aux1` e simplesmente colocar a expressão no linha do x==y

solução final:

~~~Haskell
removeabb :: Ord a => a -> Tree a -> Tree a

removeabb _ Vazia = Vazia
removeabb x (No y ae ad) 
    | x < y  = No y (removeabb x ae) ad
    | x > y  = No y ae (removeabb x ad)
    | x == y && ae == Vazia = ad
    | otherwise =  No nova_raiz ae nova_ad
    where
        (nova_raiz,nova_ad) = acha_removemaior ad
~~~
<br>

# I/O primeira parte
ainda sem ler ou imprimir

- `show x` apenas converte x p/ string

- `read x :: Int` para converter um string x para inteiro

- `read x :: Float` para converter p/ float

- funções `lines` para quebrar um string em linhas e `words` para quebrar uma linha nos brancos

- funçoes `unlines` e `unwords` para montar o string final

~~~Haskell
read "  8  " :: Int

read "  8  " :: Float 

show 9.876
~~~
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->


<details>
  <summary>Aula 9 - Monads, Maybe, Containers, Functor(monoid), applicative, monad, >>=, return, <-, do, I/O</summary>
    
  # Aula 9 Monads
#### [livro texto](http://learnyouahaskell.com/chapters) (cap 11 e 9)
#### [Haskell online](https://repl.it/@mc346b)
#### [Haskell - compilado](https://www.jdoodle.com/execute-haskell-online)

# Maybe

`data Maybe a = Nothing | Just a`
Resultado de algumas funções que podem não ter resultado
~~~Haskell
:m + Data.List

find (>4) [1,2,3,4,5,6,7]

find (>14) [1,2,3,4,5,6,7]
import Data.Map.Strict as M

let dd =  M.fromList [("a",3),("b",5),("g",8)]

M.lookup "b" dd

M.lookup "f" dd
~~~
<br>

# Funções do Maybe
[Maybe no hackage](http://hackage.haskell.org/package/base-4.11.1.0/docs/Data-Maybe.html)

<br><br>

# Containers
Um super tipo que contem um ou mais dados de um tipo interno (ou mais do que um tipo interno) ou nenhum dado.

- lista é um container que pode conter **mais de um** dado de **um** só tipo interno

- Map é um container que pode conter **mais do que um** dado de 2 tipos internos (chave - valor)

- Maybe é um container que so contem **um dado** de **um** tipo
<br>

#Maybe como container
O `Just` a é o “valor correto” e `Nothing` é o valor errado. Eu gostaria de poder continuar processando um Maybe enquanto o valor esta “correto”

~~~Haskell
fmap (*5) (Just 6)

fmap (*5) Nothing
~~~
<br>

# Functor (Monoid)
Um container é um `functor` se ele implementa a função `fmap`

~~~Haskell
:t fmap

:t map
~~~

fmap aplica uma função unária que funciona no dado de dentro, no container como um todo.

fmap é muito parecido com o **map**, ou na verdade, o container **lista** é um functor!!

O fmap aplica uma função que funciona no tipo de interno para dentro do container

Se voce esta definindo o container (tipo), vc precisa definir como o fmap funciona nele. O fmap do maybe é

~~~Haskell
instance Functor Maybe where
   fmap _ Nothing = Nothing
   fmap f (Just something) = Just (f something)
~~~

Dicionario implementado como um abb
~~~Haskell
data Dic ch v = Vazio | No ch v (Dic ch v) (Dic ch v)
-- dicionario implmentado como uma ABB

instance Functor Dic where
   fmap _ Vazio = Vazio
   fmap f (No ch v ae ad) = No ch  (f v) (fmap f ae) (fmap f ad)
~~~
<br>


# applicative
Eu gostaria que:

~~~
(Just 7) + (Just 3) ==> Just 10

(Just 7) + Nothing ==> Nothing
~~~

Um container é um `applicative` se ele permite aplicar uma função binaria que funciona no tipo interno e aplica-la em dois containers

Infelizmente a notação de um aplicative é esquisita. Eu acho que isso deriva do fato que nao há funções binarias em haskell, só funções unárias.

~~~Haskell
(+) <$> (Just 7) <*> (Just 3)

(+) <$> (Just 7) <*> Nothing
~~~

o `<$>` é um operador que combina uma funcao (do tipo interno) e um container e retorna “algo.” O `<*>` é outro operador que combina o “algo” com o container e retorna um container com os elementos internos sendo o resultado da aplicação da função binaria.

A lista é também é um applicative:

~~~
(+) <$> [1,2,3,4] <*> [10,100]

[11,101,12,102,13,103,14,104]
~~~

veja que o aplicative aplica a função binaria em todos os pares dos dois containers (o fmap aplica a função em todos so elementos do container)

# monad
Um container é uma monad se ele implementa (entre outras coisas) a função infixa >>= (operador de bind infixo ) que remove o dado de um container para aplica-lo em uma função que esta esperando o tipo interno e retorna um container com o resultado

~~~Haskell
:t (>>=)

~~~

`(Just 8) >>= (\x -> if odd x then Nothing else (Just (2*x+1)) )`

Note que a função anonima recebe um inteiro e retorna um inteiro dentro do container (Maybe)

Listas são também monadas, que são combinadas com uma operacao de concatenação

~~~
[1,2,3] >>= (\x -> if odd x then [x] else [])
[4]
~~~

Note que a funcao anonima recebe um inteiro e retorna um inteiro dentro do container

# bind (>>=) como composicao
pense em duas funçoes `f :: a -> b` e `g :: b -> c`

uma coisa importante/central em programação funcional é compor essas funçoes
~~~Haskell
g (f x)

g $ f x
~~~

agora assuma uma função **f'** que faz o que **f** faz mas coloca o resultado num container (por exemplo o resultado e um log das operações)

**g'** também gera um log.

mas como compor f' e g'?

é isso que o >>= faz

f' x >>= g'
o `>>=` é um tipo de composição de função. `f' :: a -> t b` e `g' :: b -> t` c onde t é um container. Entao

f' x >>= g'

combina essas funcoes. f' x retorna algo no container, o bind >>= remove do container (da forma correta) e da esse valor para o g' que retrona um conrainer. O bind depois **combina esses 2 containers** da forma apropriada.
<br>

# return
Monad define também a função `return` que coloca um valor dentro do container

~~~Haskell
mae :: Pessoa -> Maybe Pessoa
pai :: Pessoa -> Maybe Pessoa

avomaternal p = return p >>= mae >>= pai
~~~
-- ou
~~~Haskell
avomaternal p = mae p >>= pai
~~~

Maybe é uma monada. Veja a definição dos dois operadores `>>=` e `return`

~~~Haskell
instance Monad Maybe where
    Nothing  >>= f = Nothing
    (Just x) >>= f = f x
    return x       = Just x
~~~
<br>

# Notação `do`
Monadas vão ser importantes. Todo o I/O vai ser relacionado com monadas mas ela é mais importante que isso.

`do` é uma notação mais conveniente para monadas

~~~Haskell
avomaternal p = do 
                 m <- mae p
                 pai m
~~~

A `<-` retira o valor da monada.

A notação `do` parece um programa “tradicional” com o `<-` como operador de atribuição

~~~Haskell
filtra f l = do 
               x <- l
               if f x then [x] else []

filtra2 f l = [ x | x <- l, f x]

filtra  odd [1,2,3,4]
filtra2 odd [1,2,3,4]
~~~

neste caso o **do** faz um loop pela lista! O resultado de cada passo é uma lista ([x] ou []) e o bind da lista faz um `concat` (concatena uma lista de listas)

~~~Haskell
concat [ [2], [], [1,2,3,4], [7,7], [], [] ]
~~~
<br>

# I/O
Toda operação de I/O esta dentro da monada `IO`

~~~Haskell
:t getLine

:t putStrLn
~~~

- `getLine` lê uma linha e retorna o string dentro da monada IO

- `getContents` lê tudo

- `putStrLn` recebe um string, imprime ele, e retorna uma tupla vazia dentro de IO
  

Uma forma genérica para programas haskell (sem interação)

~~~Haskell
main = do 
       dados <- getContent
       let saida = proc dados
       putStrLn saida
~~~

- `print` converte argumentos para string e imprime

- `show` apenas converte p/ string

- `read x :: Int` para converter um sting para inteiros

- `read x :: Float` para converter p/ float

- funções `lines` para quebrar um string em linhas e `words` para quebrar uma linha nos brancos

- funçoes `unlines` e `unwords` para montar o string final

..
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
<details>
  <summary>Aula 10 - Exemplo de uso de monads</summary>

# Aula 10
#### [livro texto](https://learnyouahaskell.github.io/) (cap 11 e 9)
#### [Haskell - compilado](https://www.jdoodle.com/execute-haskell-online)

# Exemplo de uso de monads
~~~Haskell
solquadratica a b c = let
    delta = sqrt (b**2 - 4 *a * c)
    in ((-b + delta) / 2,   (-b - delta) / 2)
~~~
<br>

agora vamos assumir que a, b e c vem de computacoes que geram maybe, e tambem que para deltas negativos devemos retornar um Nothing

~~~Haskell
import Data.Maybe 

solquadratica a b c = if isNothing a || isNothing b || isNothing c then Nothing
                      else let
                          aa = fromJust a
                          bb = fromJust b
                          cc = fromJust c
                          delta = (bb**2 - 4 * aa * cc)
                          in if delta < 0 then Nothing
                             else Just ((-bb + sqrt delta)/2, (-bb - sqrt delta)/2)
~~~
<br>

usando monadas
~~~Haskell
solquadratica2 a b c = do
                aa <- a
                bb <- b
                cc <- c
                let mysqrt x = if x<0 then Nothing else Just (sqrt x)
                sdelta <- mysqrt (bb**2 - 4 * aa * cc)
                return ( (-bb+sdelta)/2,  (-bb-sdelta)/2 )
~~~
<br>

# Outras monadas
- Maybe são computacoes que pode dar errado

- Listas são computacoes que geram 0 , 1 ou mais resultados!!

- OI monad são computacoes que fazem I/O
<br>

# state monad
~~~Haskell
uma aproximacao

simulador g = let (n,g1) = random g
                  (b,g2) = random g1
                  (c,g3) = random g2
                  (m,g4) = random g3
                    in simul' n b c m
~~~

voce quer uma monada que contem (valor, estado) e o do cuida para autializar o estado a cada chamada

~~~Haskell
simuladorx g = do n <- random 
                 b <-  random
                 c <- random 
                 m <- random 
                 return (simul' n b c m)
~~~
<br>

# reader monad
todas computacoes tem acesso a dados comuns imutaveis
<br><br>

# writer monad
cada computacao gera um stream de dados (por exemplo log)
<br><br>

# call with continuation (??)
https://en.wikipedia.org/wiki/Call-with-current-continuation
<br><br>

# referencias futuras
https://wiki.haskell.org/All_About_Monads

proximos passos em haskell https://book.realworldhaskell.org
</details>


<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
<br>

[![Prolog](https://github.com/raoniton/mc346/blob/main/img/logo_prolog.png)](https://www.swi-prolog.org/)
<details>
  <summary>Aula 11 - Prolog - Introdução</summary>
  
  # Aula 11 Prolog

##### [Livro texto pagina](https://en.wikibooks.org/wiki/Prolog) 1 (Introduction) e 2 (rules)

##### [Apostila do Prof Joao Meidanis](https://www.ic.unicamp.br/~meidanis/courses/mc336/2011s2/prolog/apostila-prolog.pdf).

##### [Para baixar para a sua maquina](https://www.swi-prolog.org/download/stable) 

##### [Prolog interativo](https://swish.swi-prolog.org/)
<br>

# Prolog
## história
- criado em 1972 na França
- programação em logica
- declara o que uma solução deva satisfazer e o programa procura por essa solução
- ganhou proeminência com o livro Programming in Prolog by Clocksin e Mellish nos anos 80
- importante para Inteligencia Artificial com a ideia de representação do conhecimento
- desenvolvido principalmente na Europa para se contrapor a preferencia americana em usar Lisp para IA (nos anos 70 e 80)
- virou a linguagem central da [fifth generation computers](https://en.wikipedia.org/wiki/Fifth_Generation_Computer_Systems) do Japão em 1982
- varias implementações (diferente de Haskell, ou Python, ou Perl, ou Lua, R, Rust, Go, etc ). Uma linguagem nao é uma implementação, mas uma especificação, com várias implementações (como C, Java, Lisp, e outras).
- há uma especificação, ISO Prolog, mas as implementações normalmente fazem modificações e extensões e acabam se tornando incompatível.
<br>

## Conceitos básicos
- banco de dados (fatos e regras)
- query
<br>

## banco de dados/fatos/conhecimento
knowledge base
~~~Prolog
human(david).
human(john).
human(suzie).
human(eliza).
man(david).
man(john).
woman(suzie).
woman(eliza).
parent(david, john).
parent(john, eliza).
parent(suzie, eliza).
~~~
`david` e `john` são um novo tipo de dado: `símbolo` ou `átomos`. Não são strings, são nomes, como nomes de variavies e funções em outras linguagens

Símbolos sao sequencias de letras e números começando com uma letra minúscula. Por incluir o underscore _ no meio. Ou são escritos como qualquer sequencia de caracteres entre aspas simples **'4ever'** ou **'abd cde?'**

`human` e `man` são também símbolos. Mas nesse contexto são chamados de `predicados`.

`david` e `john` são `termos`

`human(david)`. é um `fato`

Fatos sao um predicado com 0, 1 ou mais termos, terminado por um .
<br>

## query
`?- human(eliza).` - isto é uma pergunta.
a resposta é 
`Yes` ou `true`

`?- human(tereza)`
a resposta é 
`No` ou `false`

Outra pergunta:
`?- human(X)`. - `X` é uma `variável` pois começa com uma `maiúscula`.

**Variáveis começam com uma letra maiúscula ou com o underscore _**

a resposta é:
`X = david`

## outra resposta - backtracking
no modo interativo do prolog, apertando o `;` ou no site de prolog interativo apertando o `next`

`X = john`
de novo:

`X = suzie`
e de novo

`X = eliza`

No site do prolog, neste caso o `next` deixa de aparecer com disponível. Num prolog interativo, apertando o `;` de novo da a resposta 
`No`
<br>

## Como funciona o Prolog
- dado uma query `?- human(eliza)` o prolog procura no banco de conhecimento um fato que contenha o predicado `human` com 1 argumento.
- a procura é de cima para baixo
- o primeiro que ele encontra é `human(david)`.
- então o prolog tenta `unificar` os termos da query com os respectivos termos do fato encontrado.
neste caso ele tentaria unificar `david` com `eliza`.

  **1a regra de unificacao: 2 simbolos unificam se eles sao o
  mesmo simbolo.**
  
- portanto não há unificação, ou a query nao `casa` (match) com o fato, e o prolog continua a busca.
- o casamento falha com john e finalmente a query casa com `human(eliza)`. Neste caso dizemos que a query foi `satisfeita` e o prolog imprime Yes ou true
- dada a query `human(tereza)` o Prolog nao consegue casar a query com nenhum fato, e quando ele chega aos final dos fatos, o prolog imprime

`No` ou `false`

## com variavel e com backtracking
- a query `human(X)`.
- o prolog encontra o fato `human(david)`.

  **2a regra de unificação: uma variavel sem valor (unbinded)
  unifica com um simbolo e passa a ter como valor (bind) esse
  simbolo**

- o query casa com `human(david)` e a variavel `X`(da query) passa a ter o valor `david`.
- a query foi satisfeita, e o Prolog imprimiria `Yes` ou `true` mas como há uma variável do query com valor atribuido, o Prolog imprime

`X = david`

Se a gente força o backtracking (`;` ou `next`) o prolog

- vai no ultimo fato que foi casado (`human(david)`)
- desfaz as atribuições a variáveis feitos nesse casamento (`X=david`). `X` passa a nao ter valor.
- continua procurando _abaixo_ do fato onde houve o casamento
- casa com `human(john)` onde `X `passa assumir o valor `john`
- imprime `X = john`
- novo backtracking, casa com `human(suzie)` e imprime `X = suzie`
- novo backtracking, casa com `human(eliza)` e imprime `X = eliza`
- novo backtracking e o prolog chega ao final do banco de dados, e imprime `No`

  
## Regras [Prolog Rules](https://en.wikibooks.org/wiki/Prolog/Rules)

~~~Prolog
father(X,Y) :- parent(X,Y), man(X).
mother(X,Y) :- parent(X,Y), woman(X).
~~~
- father(X,Y) é a father(X,Y) é a `cabeça` da regra da regra
- parent(X,Y), man(X) é o corpo da regra
- a virgula , indica `and`
- o operador `:-` deve ser lido como `se`
- O query `?- father(X,eliza).` imprime

`X = john     ;`

`No`

onde o `;` indica que forçamos o backtrack

O query `?- father(A, C).` imprime

~~~Prolog
 A = david
 B = john    ;
 
 A = david
 B = eliza   ; 
 
 No
~~~
<br>

## Como regras funcionam
- buscando satisfazer um query o prolog pode casar com a cabeça de uma regra.
- se o casamento da certo, o corpo da regra passa a ser o novo query.
- ?- parent(X,eliza). tenta casar com a cabeça da regra, Neste caso X do query casa com o X da regra, e Y da regra casa com eliza

  **3a regra de unificação: 2 variaveis sem valor podem unificar e
  se uma delas assumir um valor (no futuro), a outra assume esse valor**
  
- o nome de uma variável é local a query ou a regra. Ou seja o X da query nao tem nada a ver com o X da regra, mas no casamento elas ficam unificadas.

- `father(X,eliza)` casa com `father(X,Y)` onde X_q = X_r

- `parent(X,eliza),man(X)` é o novo query

- `parent(david, john)` nao casa por causa do eliza

- `parent(john, eliza)` casa e causa `X = john.`

- `man(john)` é o novo query, que casa com o fato `man(john)`

- as query foram todas satisfeitas, e portanto o prolog imprime
~~~Prolog
X = john
~~~

- esse `X` é o `X` da query, que foi unificado com o X da regra que durante o processo foi unificado com john.

<br>

# and
- uma query
`a(..) , b(..) , c(..) ,d(..) .`
tentara satisfazer `a(..)`, depois `b(..)`, depois `c(..)`, e finalmente d`(..)`.

- se `d(..)` for satisfeito, a query como um todo é satisfeita, e se for a ultima query o prolog imprime a solução.

- `se a(..)` não puder ser satisfeito, a query como um todo **falha** e se essa for a query do usuário, o prolog imprime `No` (ou `false`)

- se `a(..)` for satisfeito, o prolog tenta satisfazer (provar) `b(..)`. Se `b(..)` falhar, o prolog automaticamente causa um backtracking no a, se no backtracking `a(..)` der certo, tenta de novo satisfazer `b(..)`

- o backtracking no `a(..)` causa, provavelmente, uma outra solução para as variavies do `a(..)`, e com esses novos valores, `b(..)` pode ser solucionado, etc.

<br>

Vamos incluir a regra:

~~~Prolog
mother(X,Y) :- parent(X,Y), woman(X).
~~~

e o query `?- mother(Z,eliza)`.

- o query casa com a cabeça da regra e Z = X e Y = eliza.

- proximo query `parent(X,eliza),woman(X)`.

- `parent(X,eliza)` casa com `parent(john, eliza)` e `X = john`

- parent(john,eliza) foi satisfeito, deu certo, e a próxima query é woman(john)

- o query `woman(john)` falha, causando o backtrack no `parent(X,eliza)`

- desfaz as atribuições feitas no casamento de `parent(X,eliza)` ou seja X passa a nao ter valor, e procura outra solução.

- tenta casar com `parent(suzie,eliza`) que da certo com `X = suzie`.

- o novo query é `woman(suzie)` que casa com o último fato relativo a `woman`.

- a query final do corpo da regra deu certo e portanto o casamento da query original com a cabeça da regra deu certo.

- a (ultima) query final deu certo e o prolog imprime
~~~Prolog
  X = suzie`
~~~
<br>

# Exercício
- escreva a regra para irmao(X,Y) ou na verdade meio-irmão (um parente em comum) Sua solução nao vai estar 100% certa. Discutiremos esse problema na próxima aula

- escreva a regra para irmao_cheio(X,Y) - 2 pessoas com os mesmos 2 parentes

Suponha um banco de dados com fatos pai e mae.

~~~Prolog

pai(antonio, beatriz).
pai(cassio, durval).
...
mae(tereza, beatriz).
mae(valeria, durval).
~~~

- para esse banco de fatos escreva a regra para `avo(A,N)` onde A é um dos avôs de N (neto/neta) . Note que há duas formas de ser avô, pai do pai ou pai da mae. Serão 2 regras para avo.

- escreva a regra recursiva `descendente(D,A)` onde D é um descendente de A (antecessor). Assuma o banco de dados original, com um predicado `parent`
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->

<details>
  <summary>Aula 12 - Continuação, =, not  \+, ou ; , números, listas, pattern matching,  </summary>

  # Aula 12 
##### [Livro texto](https://en.wikibooks.org/wiki/Prolog)

##### [Prolog interativo](https://swish.swi-prolog.org/)

# Continuando prolog basico
vamos assumir o banco de dados
~~~Prolog
parent(alberto,beatriz).
parent(alberto,carlos).
parent(alberto,zeca).
parent(denise,beatriz).
parent(denise,zeca).
parent(elisa,carlos).
parent(beatriz,flavio).
parent(gustavo,flavio).
~~~
a primeira definição de (meio) irmao - pelo menos um parent em comum (neste caso o Z).

~~~Prolog
     irmao(X,Y) :- parent(Z,X),parent(Z,Y).
~~~
<br>
testando

~~~Prolog
      ?- irmao(beatriz,K).
~~~
<br>

respostas

~~~Prolog
K = beatriz
K = carlos
K = zeca
~~~

beatriz é meio irmã de beatriz? Sim segundo a definição, mas claramente queremos pessoas diferentes.

- so por que as variaveis X e Y tem nomes diferentes não significa que elas vao ter valores diferentes,
- por outro lado as variaveis X que aparecem na regra “são todas a mesma variável”
- precisamos uma definição/operação para diferente
<br>

# o =
a operação `=` em prolog é a operação de unificação que dicutimos ate agora

~~~Prolog
pedro = antonio      % -> falha
X = antonio          % -> da certo e X passa a valer  antonio
antonio = X          % ->  da certo e X passa a valer antonio
antonio = X, X = Y   % -> da certo e X e Y valem anotonio
X = Y                % -> da certo e X e Y terao o mesmo valor (quando um assumir um )
X = Y, Y = antonio, X = pedro   % -> falha
~~~
unificação é uma mistura de teste de igualdade e atribuição (bidirecional)
<br>

# o not +
Negaçao em prolog é complicada pois não há boleanos. Um predicado nao retorna True, e um `not` não transforma esse valor para False.

Negação em prolog indica se o predicado de dentro deu ou não certo. _negation by failure_

~~~Prolog
not p(..)     ou    \+ p(..)  
vai dar certo, se p(...) falhar

\+ ( p(..), q(..) )
vai dar certo se (p(..),q(..) ) falhar
~~~
<br>

# meio irmao
~~~Prolog
irmao(X,Y) :- parent(Z,X), parent(Z,Y), \+ X=Y.
~~~
<br>

# irmao cheio
~~~Prolog
irmao_cheio(X,Y) :- parent(Pai,X), parent(Pai,Y),
                    parent(Mae,X), parent(Mae,Y),
                    \+ Mae = Pai,
                    \+ X=Y.
~~~
<bt>
  
# Avô
dado o predicados `pai(a,b)` se `a` é pai de `b`, e `mae(a,b)`

~~~Prolog
avo(A,N) :- pai(A,M), mae(M,N).
avo(A,N) :- pai(A,P), pai(P,N).
~~~
<br>

# o ; ou
o `;` é o operador `ou`.

~~~Prolog
   a(..), b(..), ( c(..) ; d(..) ).
~~~

vai tentar provar `a` depois `b` e depois `c` .


Se `c` falhar, ele vai tentar `d` antes de dar o backtraking.

Avo pode ser escrito com o ;
~~~Prolog
 avo(Avo,Neto) :- pai(Avo,X), ( mae(X,Neto) ; pai(X,Neto) ).
~~~
<br>

# Descendente 
##### [Recursive Rules](https://en.wikibooks.org/wiki/Prolog/Recursive_Rules)
~~~Prolog
descende(X,Ansestral) :- parent(Ansestral,X).
descende(X,Ansestral) :- parent(Ansestral, Filho), 
                               descende(X,Filho).
~~~

Coloque o caso **base antes**.

o caso recursivo tambem poderia ser escrito como

~~~Prolog
descende(X,Ansestral) :- parent(PAI, X), descende(PAI,Ansestral).
~~~
<br>

# Numeros em Prolog
A coisa mais importante é que expressões matematicas só são calculadas em 2 contextos

- Os 2 lados de uma comparação:
~~~Prolog
X*4/Y > Z**2
~~~
<br>

- Do lado direito de um `is`
~~~Prolog
X is Y+2
~~~
<br>

`is` calcula o valor do lado direito e `unifica` com o lado esquerdo.

Expressões podem não dar certo em tempo de execução pois algumas variáveis podem não ter valor no momento da execução

- Isso vai dar um erro
~~~Prolog
Y is X+2, X = 2
~~~
<br>

- Isso vai dar algo estranho:
~~~Prolog
X = 4, Y = X+2
~~~
`NAO` use o `=` numa expressão matemática.
<br>

- Isso é equivalente:
~~~Prolog
X = 2
X is 2
~~~
<br>

# comparações
~~~Prolog
A > B
A >= B

A =< B

A =:= B  /* igualdade aritimetica */
A =\= B  /* desigualdade aritimetica */
~~~
<br>

# Listas
Heterogeneas, entre `[ ]`

~~~Prolog
[1, 2, [5,6], abobora, [] ]
~~~
<br>

# Pattern matching:
~~~Prolog
[Cabeca|Resto] -- equivale ao (cabeca:resto) do haskell
[]
[X|R] nao casa com a lista vazia

[1,2,3] = [X|R]
X = 1, R = [2,3]
~~~
<br>

# Exemplos
- tamanho de uma lista
~~~Prolog
tam([],0).
tam([_|R],N) :- tam(R,NN), N is NN+1.
~~~
<br>

- com acumulador
~~~Prolog
tam(L,N) = tamx(L,N,0).
tamx([],N,Acc) :- Acc=N.
tamx([X|R],N,Acc) :- AA is Acc+1, tamx(R,N,AA).
~~~

nesta ultima regra o prolog indica `singleton variable X` . Isso é um warning que a variavel `X` aparece só uma vez, e isso pode ser um erro com consequencias graves na hora de rocar ou nao ser nada serio como no caso acima.

Voce pode usar a variavel anonima `_`
<br>

# Modo
quando vc programa `tam` vc assume que vc recebe a lista `(+)` e vai devolver o tamanho dela `(-)`

tam modo (+-)

# Erros
- Nao da para somar 1 numa variavels (N)
~~~Prolog
tam([],0).
tam([_|R],N) :- tam(R,N), N is N+1.  <- erro

tam([_|R],N) :- tam(R,NN), N = NN+1.  <- correto
~~~
<br>

`N is N+1` nunca da certo! Ou `N` nao tem valor, e a expressão da um erro, ou `N` tem valor e o lado esquerdo não unifica com o lado esquerdo
<br>

- Não da para passar expressões como parametros do predicado.
~~~Prolog
tamx([X|R],N,Acc) :- tamx(R,N,Acc+1).   <- erro

tamx([X|R],N,Acc) :-  AA is Acc+1, tamx(R,N,AA).  <- correto
~~~
Lembre-se expressões matematicas `NAO` sao avaliadas em passagem de parametros.
<br>

# Exemplo 2
Soma dos elementos de uma lista soma(+LISTA,-SOMA)
~~~Prolog
soma([],S) :- S=0.
soma([X|R],S) :- soma(R,SS), S is SS+X.

ou

soma([], 0). 
soma([X|R],S) :- soma(R,SS), S is SS+X.
~~~
<br>

# exemplo 3
soma dos números pares de uma lista somapares(+LISTA,-SOMA)
~~~Prolog
somapares([], 0).
somapares([X|R], SP) :- X mod 2 =:= 0, somapares(R,SS),
                        SP is SS+X.
somapares([X|R], SP) :- somapares(R,SS), SP=SS.
~~~

se `X` é par , ele executa a 2a regra. Se `X` é impar, o primeiro predicado da 2a regra falha, e o prolog executa a 3a regra.

Nao precisamos de `IF/ELSE`. A 2a regra testa para a condição `X mod 2 =:= 0` e contém o `THEN`. A 3a regra contem o `ELSE`.

Outra versão

~~~Prolog
somapares([],0).
somapares([X|R], SP) :- X mod 2 =:= 0, somapares(R,SS),
                        SP is SS+X.
somapares([_|R], SP) :- somapares(R,SP).
~~~
<br>

Outra versão
~~~Prolog
somapares([], 0).
somapares([X|R], SP) :- somapares(R,SS),
            (X mod 2 =:= 0 , SP is SS+X 
         ;   SP=SS).
~~~
<br>

# Exercícios
Da aula 1 e 2 e haskell - use acumuladores quando necessario.
~~~Prolog
o append(+,+, -)

append([],A,A).
append([X|R],A,AA) :- append(R,A,RR), AA = [X|RR].

ou 

append([],A,A).
append([X|R], A, [X|RR]) :- append(R,A,RR).
~~~ 

- tamanho de uma lista

-soma dos elementos nas posições pares da lista ( o primeiro elemento esta na posicao 1. somapospar(+LISTA,-SOMA)

- existe item na lista `elem(+IT,+LISTA)

- posição do item na lista: 1 se é o primeiro, falha se nao esta na lista pos(+IT,+LISTA,-POS)

- conta quantas vezes o item aparece na lista (0 se nenhuma) conta(+IT,+LISTA,-CONTA)

- reverte uma lista. reverte(+LISTA,-LISTAR)

- intercala 2 listas (intercala1 e intercala2)
~~~Prolog
intercala1([1,2,3], [4,5,6,7,8], X).
 X =  [1,4,2,5,3,6]
intercala2([1,2,3], [4,5,6,7,8], Y),
 Y =   [1,4,2,5,3,6,7,8]
~~~

- a lista ja esta ordenada? ordenada(+LISTA)

- dado n gera a lista de n a 1 range(+N,-LISTA)

- retorna o ultimo elemento de uma lista ultimo(+LISTA, -ULT)

- retorna a lista sem o ultimo elemento: semultimo(+L,-LSEMULT)

- shift right

~~~Prolog
shiftr([1,2,3,4],X)
 X = [4,1,2,3]
~~~

- shiftr n lista (shift right n vezes)

- shift left

- shift left n vezes

- remove item da lista (1 vez só): remove(+IT,+LISTA,-LISTASEM).

- remove item da lista (todas as vezes)

- remove item da lista n (as primeiras n vezes)

- remove item da lista (a ultima vez que ele aparece) **

- troca velho por novo na lista (1 só vez): troca(+L,+VELHO,+NOVO, -LISTAtrocada)

- troca velho por novo na lista (todas vezes)

- troca velho por novo na lista n (as primeiras n vezes)
  
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->

<details>
  <summary>Aula 13 - Correção dos exercícios, IF-THEN-ELSE, Cut, Predicados, fail e true</summary>

  # Aula 13
  <br>
  
  <details>
    <summary>Correção - Exercícios Aula 12</summary>

  # Exercicios
Da aula 1 e 2 - use acumuladores quando necessario.

- tamanho de uma lista

- soma dos elementos de uma lista soma(+LISTA,-SOMA)

- soma dos números pares de uma lista somap(+LISTA,-SOMA)

- soma dos elementos nas posições pares da lista ( o primeiro elemento esta na posicao 1) somapares(+LISTA,-SOMA)

~~~Prolog
somapares([],0).
somapares([_],0).
somapares([A,B|R],S) :- somapares(R,SS), S is SS+B.
~~~
<br>

existe item na lista elem(+IT,+LISTA)
~~~Prolog
elem(IT,[IT|_]).
elem(IT,[_|R]) :- elem(IT,R).
~~~
<br>

- posição do item na lista: 1 se é o primeiro, falha se nao esta na lista
~~~Prolog
pos(+IT,+LISTA,-POS)
pos(IT,L,P) :- pos(IT,L,P,1).
pos(IT,[X|_],P,N) :- X=IT,P=N.
pos(IT, [_|R],P,N) :- NN is N+1, pos(IT,R,P,NN)


pos(IT,L,P) :- pos(IT,L,P,1).
pos(IT,[IT|_],P,P).
pos(IT, [_|R],P,N) :- NN is N+1, pos(IT,R,P,NN)

~~~
<br>

- conta quantas vezes o item aparece na lista (0 se nenhuma) conta(+IT,+LISTA,-CONTA)
~~~Prolog
conta(_,[],0).
conta(X,[X|R],N) :- conta(X,R,NN), N is NN+1.
conta(X,[_|R],N) :- conta(X,R,N).
~~~
<br>

- reverte uma lista
~~~Prolog
rev(L,B) :- rev(L,B,[]).
rev([],A,A).
rev([X|R],B,A) :- rev(R,B,[X|A]).
~~~
Voce pode usar o mesmo nome. O predicado é a combinação do nome e do numero de argumentos. No prolog o predicado é chamado de rev\2 e rev\3.
<br>

- intercala 2 listas (intercala1 e intercala2)
~~~Prolog
intercala1([1,2,3], [4,5,6,7,8], X).
 X =  [1,4,2,5,3,6]
intercala1([],_,[]).
intercala1(_,[],[]).
intercala1([A|RA],[B|RB],[A,B|RR] ) :- intercala1(RA,RB,RR).
intercala2([1,2,3], [4,5,6,7,8], Y),
 Y =   [1,4,2,5,3,6,7,8]
~~~
<br>

- a lista ja esta ordenada?
~~~Prolog
ordenada([]).
ordenada([_]).
ordenada([A,B|R]):- A =< B, ordenda([B|R]).
~~~
<br>

- dado n gera a lista de n a 1
~~~Prolog
gera(1,[1]).
gera(N,L) :- NN is N-1, gera(NN,LL), L = [N|LL].
~~~
<br>

- retorna o ultimo elemento de uma lista
~~~Prolog
ultimo([X],X).
ultimo([_|R],X) :- ultimo(R,X).
~~~
<br>

- retorna a lista sem o ultimo elemento
~~~Prolog
semult(L,LS) :- rev(L,[_|LL]),rev(LL,LS).
~~~
<br>

- shift right
~~~Prolog
shiftr([],[]).
shiftr([X],[X]).
shiftr(L,LS) :- ultimo(L,U),
                semult(L,LL),
                LS = [U|LL].
~~~
<br>

- shiftr n lista (shift right n vezes)

- shift left

- shift left n vezes

- remove item da lista (1 vez so)
~~~Prolog
remove(_,[],[]).
remove(IT,[IT|R],R).
remove(IT,[X|R],SAIDA) :- remove(IT,R,RR),
                          SAIDA = [X|RR]
~~~
<br>
- remove item da lista (todas as vezes)

- remove item da lista n (as primeiras n vezes)

- remove item da lista (a ultima vez que ele aparece) **

- troca velho por novo na lista (1 so vez) troca(+LISTA,+VELHO,+NOVO,-ListaNova)
~~~Prolog
troca1([],_,_,[]).
troca1([V|R],V,N,[N|R]).
troca1([X|R],V,N,LN) :- troca1(R,V,N,LR),LN = [X|LR].
troca velho por novo na lista (todas vezes)
~~~
<br>

- troca velho por novo na lista n (as primeiras n vezes)
  </details>
<br>

# Estruturas
tipo de dado com o mesmo formato que um predicado
~~~Prolog
pai(antonio,ana)

arv(NO,AE,AD)
~~~

Estruturas unificam entre si da mesma forma que predicados

- nome (functor) igual,
- mesmo numero de argumentos
- cada argumento correspondente nas 2 estruturas unifica recursivamente
~~~Prolog
a(X, B, f(4)) = a(3, C, f(Z))
X = 3, B = C, Z = 4.
~~~
<br>

# arvores
~~~Prolog
arv(NO, AE, AD) ou vazia
~~~
<br>

# dicionários
~~~Prolog
[ dic(CHAVE, VALOR), ...]
~~~
<br>

# Predicados de alta ordem
Predicados que recebem outros predicados/estruturas como argumentos

## call
transforma uma estrutura em um query
~~~Prolog
?- P = pai(X,ana), call(P).

P = pai(antonio, ana),
X = antonio.
~~~
<br>

## univ =..
constroi uma estrutura de uma lista (ou quebra uma estrutura em seus componentes)
~~~Prolog
?- X =.. [a,4,5].

X = a(4, 5)

?- Y = pai(a,b), Y =.. Z.

Z = [pai, a, b].
~~~

## map
mapeia um predicado em 1 lista (map1) ou em duas listas (map2), etc
~~~Prolog
map1(_, []).
map1(P, [X|R]) :- G=..[P,X], call(G),
                 map1(P,R)

map2(_, [], []).
map2(P, [X|RX], [Y|RY]) :- G =.. [P,X,Y], call(G),
                         map2(P,RX,RY).
~~~
<br>

Na verdade é possível usar o mesmo nome map pois o predicado so unifica com um outro predicado de mesmo nome e mesmo numero de argumentos.

~~~Prolog
map(_, []).
map(P, [X|R]) :- G=..[P,X], call(G),
                map(P,R)

map(_, [], []).
map(P,[X|RX],[Y|RY]) :- G =.. [P,X,Y], call(G),
                         map(P,RX,RY).
~~~
se distingue as duas versões de map por map/2 e map/3

O map ja esta implementado em SWIProlog [apply em listas](http://www.swi-prolog.org/pldoc/doc/_SWI_/library/apply.pl) como maplist
<br>

## filter
~~~Prolog
%  filter(+Teste, +Lin, -Lout)
filter(_, [], []).
filter(T, [X|R], Lout) :- G =.. [P,X],
                        call(G), filter(T,R,RR), 
                        Lout = [X| RR].
                        
filter(T, [_|R], Lout):-filter(T, R, Lout).
~~~
ja implementado como include no SWIProlog

<br>


## foldl
~~~Prolog
foldl(+P, +Lista, +Val_inicial, -Val_final)
~~~
P tem que ser um predicado de 3 argumentos
~~~Prolog
P( +Dado, +Acumulador, -NovoAcum)
foldl(_,[],ACC,FINAL).
foldl(P,[X|R],ACC,FINAL) :-
    G =.. [P,X,ACC,NACC],
    call(G),
    foldl(P,R,NACC,FINAL).
~~~

foldl ja esta implementado no SWIProlog.
<br>

## Todas as soluções
~~~Prolog
pai(a,b).
pai(a,c).
pai(b,e).
pai(c,f).

ant(A,B) :- pai(A,B).
ant(A,B) :- pai(A,C),ant(C,B).
~~~
<br>

## findall

findall( padrao, query, lista-com-os-resultados)
lista-com-os-resultados acumula todos os valores que padrao assume nas solucoes de query

todos filhos de a:
~~~Prolog
findall(X, pai(a,X), L).
L = [b, c].
~~~
<br>

todos os pais de e:
~~~Prolog
?- findall(X,pai(X,e),L).       
L = [].
~~~

<br>

todos filhos de alguém:
~~~Prolog
findall(X, pai(Z,X), L).
L = [b, c, e, f].
~~~

Veja que o Z aparece no query mas nao no padrão. Assim eles podem assumir qualquer valor nas varias soluçoes do query.

pares (lista de 2) de pais/filhos:
~~~Prolog
findall( [X,Y], pai(X,Y), L).

L = [[a, b], [a, c], [b, e], [c, f]].
~~~

Todos os pares (uma estrutura zz(filho, ai)) de pais e filhos que sao decendentes de a.
~~~Prolog
findall(zz(X,Y), (ant(a,X),pai(Y,X)), L).
~~~

Há 2 outros predicados parecidos mas com comportamento diferente em casos particulares `bagof` e `setof`
<br>

# Alterando o banco de dados
<br>

## assertz
assertz insere um fato no final do BD.
~~~Prolog
:- dynamic pai/2.

?- assertz(pai(f,h)).
?- listing(pai/2).
~~~
asserta insere no inicio do BD.

<br>

## retract
remove o 1o fato que unifica como o argumento do retract
~~~Prolog
?- retract(pai(a,Z)).
~~~
<br>

## retractall
remove todos os fatos que unificam com o argumento.
~~~Prolog
?- retractall(pai(_,_)).
~~~


# Operadores IF-THEN-ELSE (1a versão)
~~~Prolog
Not

\+ (predicado)
OR

A ; B 
IF then else como OR

(teste, then) ; else
~~~

# IF THEN ELSE (2a versão)
~~~Prolog
p :- teste, then.
p :- else.
~~~
<br>

# IF THEN ELSE (3a versão)
Novo operador ->

A ser explicado logo abaixo
~~~Prolog
teste -> then ; else
~~~
<br>

# Cut !
~~~Prolog
nota(N,L) :- N>9,L=a.
nota(N,L) :- N>7,L=b.
nota(N,L) :- N>5,L=c.
nota(_,d).
~~~

~~~Prolog
?- nota(8.5,X).
~~~

O predicado funciona na primeira chamada mas erra os resultados no backtracking/next.

O que precisamos é um jeito de dizer ao prolog que se ele decidiu por uma das regras, mesmo no backtrack ele nao pode escolher outra regra.
~~~Prolog
nota(N,L) :- N>9,!, L=a.
nota(N,L) :- N>7,!, L=b.
nota(N,L) :- N>5,!, L=c.
nota(_,d).

?- nota(8.5,X).
a :- b, c, !, d, e.
a :- f, g.
~~~
Se a execuçao passa pelo cut ela esta comprometida com essa regra. No backtraking o pedicado a vai falhar (e nao tentar provar na regra abaixo).
<br>

# predicados deterministicos
- nao geram outra solução no backtracking

- falham no backtraking
~~~Prolog
..., A+1 > 2*B, proximo(A,B). 
a :- b, c, !.
a :- d, e, f, !.
a: - g.
~~~

Cut no final torna o predicato deterministico.
<br>

# fail e true.
`fail` é um predicado que sempre falha.

`true` é um predicado que sempre da certo.

Como indicar que um predicado deve falhar numa certa condição

~~~Prolog
elem(_,[]) :- !, fail.
~~~

O `fail` sozinho nao funciona pois ele vai forçar o bracktracking. o cut + fail funcional
<br>

# IF THEN ELSE
~~~Prolog
a :- teste, !, then.
a :- else.

a :- teste -> then ; else
a :- antes, (teste 
            -> then 
            ;  else).
~~~

# IF THEN
~~~Prolog
a :- antes, (teste 
            -> then
            ;  true).
~~~
Infelizmente precisa do true na posição do else.
<br>

# multiplos IFs
~~~Prolog
a :- teste1, !, then1.
a :- teste2, !, then2.
a :- teste3, !, then3. 
a :- else.
~~~
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
<br> 

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=white)

<details>
  <summary>Aula 14 - Python - Introdução</summary>

 # Aula 14 - Python
##### [Python online](https://replit.com/languages/python3)

##### [Python Tutorial](https://docs.python.org/3/tutorial/index.html)

##### [Standard library](https://docs.python.org/3/library/index.html)
<br>

# Historia
criando em 1989 por Guido van Rossum

python 3.0 (2008) não é backward compatible com o 2.0

- inteiros sem overflow
- print era um comando (sem parenteses) e virou uma função com um numero qualquer de argumentos
- strings são so em unicode (antes havia 2 tipos de string)
`/` era divisão inteira se os 2 argumentos fossem inteiros, e agora `//` é a divisão inteira, `/` é sempre real
- 2.7 é a ultima versão da familia 2.0

Guido deixou de ser o _ditador benevolente_ vitalicio do python em 2018 por causa -[deste PEP 572](https://www.python.org/dev/peps/pep-0572/) - atribuição em expressões `(:=)`

~~~Python
if (match := pattern.search(data)) is not None:
    # Do something with match

while chunk := file.read(8192):
   process(chunk)

[y := f(x), y**2, y**3]

filtered_data = [y for x in data if (y := f(x)) == 0]
~~~
<br>

# PEP
##### [Python Enhancement Proposals](https://www.python.org/dev/peps/)
<br>

# implementações
- CPython é a “padrão” (versão 3.10 lançada em Outubro 2021) - nao confundir com Cython que é uma linguagem para programação em baixo nivel em Python que compila para C.

- micropython - para sistemas embarcados https://micropython.org/

- IronPython - para o .NET https://ironpython.net/ (versão 3.4)

- Jython - converte para bytecode do Java https://www.jython.org/ (versão 2.7)

- pypy - JIT compiler https://www.pypy.org/index.html
  pypy normalmente esta de 1 a 2 números abaixo a subversão do CPython

- nao confunda pypy with PyPi (instalador mais tradicional de pacotes python)

- stackless python https://github.com/stackless-dev/stackless/wiki
<br>

# paralelismo/concurrency
concurrency - nao necessariamente em paralelo, mas operaçoes que demoram muito (I/O) sao executadas “ao mesmo” tempo que outras operaçoes

paralelismo - operacoes sao realmente executadas em paralelo em diferentes cores/CPU ou mesmo computadores

O ambiente de execução do CPython nao permite concorrencia (interno - automático) por causa do [GIL- global interpreter lock](https://realpython.com/python-gil/)

- não há paralelização automática - se esse comando esta demorando muito então já começe o outro

- o programador pode criar código que explicitamente roda em threads (start/synchronize/etc) mas provavelmente ele não roda realmente em threads https://realpython.com/intro-to-python-threading/

- pacote asyncio https://www.youtube.com/watch?v=GpqAQxH1Afc a partir de 3.10

- há um paralelismo em batch - outro Python sera inicializado e eles se comunicam usando pipes mas não ha memoria compartilhada [multiprocessing](https://docs.python.org/3/library/multiprocessing.html) e [concurrent.futures](https://docs.python.org/3/library/concurrent.futures.html#module-concurrent.futures)

esses podem criar um “modelo de memoria compartilhada” para o programador mas nao é realmente compartilhada no baixo nivel

para obter paralelismo de threads (dentro do mesmo processo) é preciso que o codigo tenha sido escrito em C. Isso é o caso para o numpy, pandas, etc. Uma funçao do numpy pode rodar varios threads em paralelo.
<br>

# Tipagem Dinamica
Variáveis não precisam ser declaradas e não tem tipos
~~~Python
x = 90
x = "qwerty"
x = [3,4,56]
~~~
Basicamente, toda variável é um apontador para um valor.

id(x) retorna o valor do apontador armazenado na variável x

<br>
<table>
  <tr>
    <th colspan= "5" center>Tipos Básicos</th>
    <tr>
      <td>int</td>
      <td>float</td>
      <td>complex</td>
      <td>bool</td>
      <td>None</td>
    </tr>
  </tr>
</table>
<br>


no python >= 3.0, inteiros são unbounded (bignums) - pode não corresponder aos inteiros de hardware

float é o double do hardware - 53 bits de precisão e 11 de expoente
<br>

# compostos
- lista [2, 3, "abc", [], 6.7]
- string "querty" ou 'querty'
- tupla (1, "abc",  2)
- dicionário { "abc":4, "de":9, "aav": -3}
- set
- frozenset
- etc
<br>

# mutáveis e imutáveis
- tipos basicos são imutáveis
Trocar o valor de uma variavel que contem um tipo básico significa criar um novo valor e apontar a variável para esse novo valor.

~~~Python
x=5
id(x)
x=x+1
id(x)
~~~
<br>

- listas são mutaveis - **modificar** um valor mutável mantem o mesmo apontador. **Atribuir** um novo valor, como sempre, muda o apontador
~~~Python
x = [10, 20, 30, 40]
id(x)
x[1]
x[1] = 99
id(x)
x = [10, 99, 30, 40]
id(x)
~~~
<br>

- String e tuplas são imutáveis - operações que modificariam essas sequencias não funcionam

~~~Python
x = (10, 20, 30, 40)
x[1]
x[1]= 99
~~~
<br>

- dicionarios e conjuntos (set) mutáveis, frozensets sao imutaveis.
<br>

# atribuição
~~~Python
x=[1,2,3]
id(x)
y=x
id(y)
z=x[:]
id(z)
~~~
O jeito simples de pensar é que uma expressão do lado direito da atribuição **retorna um apontador** para um valor e nao o valor. Pode ser que o lado direito precisa ser avaliado e um valor é computado, mas o que é passado para o lado esquerdo é o apontador para esse valor.

atribuição apenas faz a variável do lado esquerdo apontar para esse apontador
~~~Python
a=2
b=a
id(a)
id(b)
b=b+1
a
id(b)
f=1+1
id(f)
~~~
Note que id(a) == id(f)

Python predefine inteiros pequenos (de -5 a 256)
https://realpython.com/lessons/small-integer-caching/

# Listas ( e sequencias)
- indexação começando em 0

- indices não podem passar do fim

- indices negativos - do fim para o começo
~~~Python
x = [10, 20 , 30, 40, 50]
x[0]
x[7]
x[-2]
x[-7]
~~~
<br>

## slices
subsequencias de listas
~~~Python
x = [10,11,12,13,14,15,16,17,18]
x[2:5]
~~~
elementos nas posicoes 2 até antes do 5
<br>

Abreviações:
~~~Python
x[:3] => x[0:3]
x[3:] => x[3:final]
~~~
<br>

Pode ter passo diferente de 1
~~~Python
x[1:20:3]
x[::-1] - lista revertida
~~~
<br>

Pode atribuir valor a slices, de diferentes tamanhos
~~~Python
x[2:5] = [1,2]
x[2:5] = []
~~~
<br>

## Copia rasa e copia profunda
`[:]` copia a lista (copia **rasa**)
~~~Python
a= [1,[2,3],4]
b=a[:]
b[0]=9
b[1][0]=99
~~~

https://docs.python.org/3/library/copy.html veja deepcopy
<br>

## operadores, funções e metodos em lista
- len(l) tamanho
- l.append(v) insere v no final de l
- x in l - True se x aparece na lista l
- x not in l
- l1 + l2 - append
- 5 * [1,2,3] = [1,2,3,1,2,3,1,2,3]
- lista1 < lista2 - ordem lexicográfica
- lista2 == lista2
- max(l) - maior valor em l
- l.sort - modifica l (mas nao retorna nada)
- sorted(l) - retorna nova lista ordenada
- [outros metodos](https://docs.python.org/3/tutorial/datastructures.html)
- del x[1] - remove - é um operador e não uma função (sem parênteses) ou metodos (sem ponto).
- lista (e tuplas e dicionarios podem terminar com ,
~~~Python
x = [1,
    2,
    3,
    ]
~~~
<br>

## List comprehensions
como no Haskel mas com uma sintaxe diferente

~~~Python
[f(x) for x in fonte if condicao]

[x**2 for x in [2,3,4,5,6,7] if x % 2 == 0]
~~~
<br>

## implementação de listas
<br>

## Tuplas
sequencias como lista mas imutáveis

metodos de lista não funcionam

funções de lista funcionam.
~~~Python
x = (1,2,3,4,5)
x[1]
x[3:]
max(x)
~~~
<br>

# pattern matching
Para atribuição (lado esquerdo são variáveis).

- funciona para tuplas
~~~Python
(a,b)  = (10,"qwerty")
~~~
<br>

- em atribuicoes, valores separados por , são implicitamente tuplas
~~~Python
(a,b) = 10, "querty"
a,b = (10,"querty")
a,b = 10 , "querty"
a,b = b,a
~~~
<br>

- para listas *var é para o resto da lista
~~~Python
[a,b,c] = [1,4.5, "zzz"]
[a,*b] = [1,4.5, "zzz"]
~~~
<br>

python 3.10 introduz um outro pattern matching tipo switch (match - case https://www.python.org/dev/peps/pep-0636/#matching-sequences

testa por igualdade e por estrutura
~~~Python
match command.split():
    case []:
        ....
    case ["quit"]:
        print("Goodbye!")
        quit_game()
    case ["look"]:
        current_room.describe()
    case ["get", obj]:
        character.get(obj, current_room)
    case ["go", direction]:
        current_room = current_room.neighbor(direction)
    # The rest of your commands go here
~~~
<br>

# Strings
- sequencia
- ente ” ou ’
- imutáveis
- caracteres Unicode,
- sintaticamente, não existe o tipo caracter
~~~Python
x = "qwerty"
x[2]
x[2][2]
~~~
<br>

~~~Python
in testa por substrings
x = 'qwerty'
'wer' in x
~~~

- s.split() - words do haskell mas permite outros separadores
- s.splitlines() - lines do haskell
- outros [metodos para strings](https://docs.python.org/3/library/stdtypes.html#text-sequence-type-str) e [mais outros](https://docs.python.org/3/library/string.html)
<br><br>

# Dicionários
~~~Python
x = { 'asd': 56, 'qwerty': -8, 'zxcv': 3}
x['qwerty']
x['zzz']
x['qwerty'] = 9
'zzz' in x
~~~
<br>

qualquer tipo imutável pode ser a chave, qq tipo pode ser o valor

[metodos para dicionarios](https://docs.python.org/3/library/stdtypes.html#mapping-types-dict)

Implementado como uma hash table que usa a funcão interna hash para gerar um indicator para cada valor. https://stackoverflow.com/questions/327311/how-are-pythons-built-in-dictionaries-implemented
<br><br>

# Set
[sets](https://docs.python.org/3/tutorial/datastructures.html#sets)
<br><br>

# None
tipo com apenas um valor None.

- no REPL nao imprime nada
- valor retornado se funçoes que nao retornam nada explicito
- valor de parametros de funções que nao sao passados na chamada
- var `is None` para testar
<br>

# for
- o comando for passeia pelos elementos de uma sequencia (no futuro veremos sao os elementos de um iterator).

- para listas, tuplas, strings, e sets são seus elementos

- para dicionarios sao as chaves

- para gerar números no `for`: `range`

~~~Python
list(range(10))
list(range(2,10))
list(range(2,10,3))
~~~
~~~Python
for i in range(len(lista)):
~~~
list converte o objeto para listas
<br>

# Exercícios
- criar uma lista com apenas os valores pares de outra lista
- criar uma lista com os valores nas posicoes pares
- criar um dicionário com a contagem de cada elemento numa lista
- qual é a chave associada ao maior valor num dicionario
- qual o elemento mais comum numa lista
- uma lista é sublista de outra?
- dado 2 strings o fim de um é igual ao comeco do outro?
</details>


<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->

<details>
  <summary>Aula 15 - Exceptions, Funções, Variáveis locais e globais, closures, Orientação a Objetos</summary>

# Aula 15
##### [Python online](https://repl.it/)
##### [Python Tutorial](https://docs.python.org/3.9/tutorial/index.html)
##### [Standard library](https://docs.python.org/3.9/library/index.html)

# Exception
~~~Python
try:
   ----
   ---- AAA
   ----
except:
   ----
   ----
~~~
Um erro/exception em AAA interrompe o bloco e executa o except
<br>

# exceptions
- `NameError`: nome nao definido, variavel sem valor
- `TypeError`
- `KeyError`: chave não existe no dicionario
- `IndexError`: index numa lista
- `MemoryError`: nao consegue alocar memoria
[lista de exceptions predefinidas](https://docs.python.org/3/library/exceptions.html#bltin-exceptions)

user defined exceptions
<br>

# outras versoes de try/except
Diferentes tratamentos para diferentes exceptions
~~~Python
try:
  ---
except TypeError:
  ---   
except (KeyError,IndexError):
  ---
except:
  ---
~~~
Nao usar except sem argumento
<br><br>

~~~Python
try: 
  ----
except Exception:
  ----
~~~
captura todas as exceptions menos control-C
<br>

# Else e finally
~~~Python
try:
   ----
except Exception:
   ----
else:
   ---  so executa se nao houve exception
try:
   ----
except A:
   ----
finally:
   ---  sempre executa mesmo que tenha exceptions que nao foram pegas
~~~
finally sera discutido abaixo
<br>

# outros
Como levantar uma exception: `raise`

Como definir sua propria exception

https://docs.python.org/3/tutorial/errors.html
<br>

# Commando pass
~~~Python
try:
    ----
    ----
except  Exception as e:
    pass
~~~
<br>

~~~Python
truque p/ dicionários
try:
   dic[x]+=1
except:
   dic[x]=1
~~~
<br>

em vez de
~~~Python
if x in dic: 
   dic[x]+=1
else:
   dic[x]=1
~~~
<br>

# pilha de execução
Exceções vão interrompendo a execução dos _contextos_ (funções - pilha de execução) até que um `except` capture a exceção

~~~Python
def a():
   -- raise X

def b():
   ...
   a()
   ...
   
def c():
    ...
    b()
    ...
    
def d():
    try:
      c()
    except X:
      -- trata
~~~
a exceção gerada la dentro. Todos os contextos sao percorridos e removidos até chegar no d

O ambiente iterativo ou o ambiente em batch capturam todas as exceções que chegam neles - no ambiente em batch o programa é terminado. No iterativo só a pilha de execução é interrompida e a execução volta para o REPL

O `finally` (ate onde eu entendo)
~~~Python
def a()
    try:
        --- raise X
    finally:
        print(y)
~~~
o finally do `a` é executado antes de jogar a exceção para cima no contexto do `a`
<br>

# Funções
~~~Python
def func(a,b,linha):
    ''' descricao 
       descricao'''
    ----
    ----
    ----
    return c
~~~
<br>

# return
- return expressao
- return `a,b` - tupla
- return `None` a funçao é sintaticamente/praticamente um procedimento/comando
<br>

~~~Python
def f(x):
    ----
    return None

f(4)
~~~
<br>

# default arguments
~~~Python
def askok(prompt, retries=4, reminder='Please try again!'):
  ----
~~~
`prompt` é obrigatório

- askok('Do you really want to quit?')
- askok('Do you really want to quit?',2)
- askok('Do you really want to quit?',2,'Sim ou nao')
<br>

# Chamando a função
Parametros casados por posição:
- askok('Do you really want to quit?',2,'Sim ou nao')
  
ou por nome:
- askok(‘Do you really want to quit?’,remainder = ‘Sim ou nao’)
- askok(‘Do you really want to quit?’,retries = 2)
- askok(retries = 2,prompt = ‘Do you really want to quit?’)
  
http://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html
<br><br>

# valores default
Cuidado: o default só é avaliado uma vez (quando a função é carregada??)
~~~Python
def f(a, L=[]):
    L.append(a)
    return L

print(f(1))
print(f(10))
print(f(30))
~~~
<br>

# numero qq de argumentos
~~~Python
def somatoria(*lista):
    soma=0.0
    for x in lista:
       soma+=x
    return soma
~~~
todos os valores passados são coletados na `lista`

ha também a possibilidade de passar numero qq de argumentos por nome `(a=3,b="string", velocidade=9.7)` que sao coletados num dicionário (notação `**var`)
<br>

~~~Python
def somatoria(**dic):
    if "b" in dic and len(dic["b"]) > 10 :
    ---
    ---
~~~
<br>

# Variaveis locais e globais
Não há declaracao de variáveis entao vc não sabe só vendo se uma variavel é local ou global

**Uma variavel é em principio local se a função atribui um valor a ela**
~~~Python
x=0
y=10

def f():
  x=100
  print(x+1)
  print(y+1)

f()
print(x)
~~~

`x` é local na funçao, `y` é global
<br>

Onde voce atribui o valor à variavel não é importante
~~~Python
x=0
y=10

def f():
  print(x+1)
  print(y+1)
  if False: 
     x=100   # nunca é executado!

f()
~~~
```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 4, in f
UnboundLocalError: local variable 'x' referenced before assignment
```
no caso acima, x é local por causa da atribuição que nunca é executada.

ATENCAO: Modificar uma variavel mutavel não é atribuir um valor a ela e não torna ela local
~~~Python
l={'a':1,'b':2,'c':3}
def ff():
  l['x']=44  # l é global


ff()
print(l)
~~~
<br>

# global
a declaraçao `global` indica que a variavel sera global
~~~Python
x=0
def f():
  global x
  x=100
  print(x+1)
  print(y+1)


f()
x
~~~
<br>

# Funcoes internas a outras funções
~~~Python
def fora(x):
   ---- 
   def dentro(y):
      ---
      z = x+y
      return z
   ---
~~~
`x` é local a `fora` mas é global para `dentro` O mais correto é dizer que x é não-local para `dentro`
<br>

# nonlocal
~~~Python
def fora(x):
   z=10
   def dentro(y):
      z = x+y
~~~
z é local a dentro
~~~Python
z=100
def fora(x):
    z=10
    def dentro(y):
      nonlocal z
      z = x+y
    
    dentro(10)
    print("z fora = ",z)
    
fora(0)
~~~
`z` é o `z` de `fora` (mas `z` não é global).

~~~Python
z=100
def fora(x):
   z=10
   def dentro(y):
      global z
      z = x+y
   
   dentro(10) 
   print("z fora = ",z)

fora(0)
~~~
<br>

# funções que retornam funções
~~~Python
def gg():

    def aux(l):
      l.reverse()
      return l

    return aux

a = gg()
a([1,2,3])
~~~
<br>

# closures

~~~Python
def gera():
   x=0

   def aux():
     nonlocal x
     x +=1
     print(x)

   return aux

a = gera()

a()
~~~
`x` é uma variavel local de `gera` e não local de `aux` mas que se mantem viva por todo o programa

- escopo é a região do programa que pode acessar uma variável pelo seu nome
- extensão é o duração temporal de uma variável
- para variáveis locais a extensão é a duração do escopo, a não ser que a variável seja um clousure.
<br>

# OO in Python
## class
~~~Python
class Pessoa:
   def setidade(self,x):
       if x >0 :
         self.idade=x

   def getidade(self):
        return self.idade
~~~
Só dá para definir os métodos. (Normalmente) não há a definição de atributos/campos/variavies

Há sempre o parâmetro `self` para os metodos, que indicam o objeto sobre o qual o método esta sendo executado. Ate onde eu sei vc pode usar qq nome para o primeiro argumento, mas eu so vi `self` sendo usado.
<br>

# objetos
Atribuos/campos/variaveis dos objetos são sempre visiveis e modificaveis!! Nao ha atributos privados
~~~Python
x=Pessoa()

x.setidade(12)
x.getidade()

x.idade

x.idade=99

x.nome="jose"
~~~
Usualmente indica-se um atributo privado usando dois underscores no inicio e no fim (regra para programadores, não para o ambiente de execução) `__nome__`
<br>

# Construtor
`Pessoa()` cria um objeto, se existe isso chama o construtor `__init__`
~~~Python
class Pessoa:
   def __init__(self,idade,nome):
      if idade>0:
         self.idade=idade
      self.nome=nome

x = Pessoa(-45,"jose")
~~~
<br>

# Herança
~~~Python
class Aluno(Pessoa):
   pass

a=Aluno()
isinstance(a,Aluno)
isinstance(a,Pessoa)
~~~
<br>

# atributos de classe

~~~Python
class Pessoa:
   npernas=2

x=Pessoa()
y=Pessoa()

x.npernas
x.npernas=9
x.npernas
y.npernas
Pessoa.npernas
Pessoa.npernas=10
y.npernas
x.npernas
~~~
<br>

# OO in python?
Usualmente não se cria um monte de objetos.

Usualmente objetos são uma interface para as bibliotecas

http://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html
<br>

# Python object model
https://docs.python.org/3/reference/datamodel.html

operator overloading; definir diferentes ações para o mesmo operador

`x[i]` acesso em listas e dicionários

- x[i] na verdade chama o metodo `x.__getitem__(i)`
- `__str__` é chamado pelo print para imprimir um dado (converte p/ string)
- `__init__` e `__new__` sao chamados pelo construtor
- `__eq__(x,y)` é chamado na comparação `x == y`
- `x.__getattr__("a")` chamado em `x.a`
- `__setattr__` para setar um atributo
- `__call__(self[, args...])` chamado em `x(a,b,c)`
- `__len__(self)` para len
- `__iter__(self)` e `__next__(self)` veremos em interators
- `__add__` para +
  
</details>


<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->

<details>
  <summary>Aula 16 - Decorators, @, Iterator, Classe, For, Generators, Itertools, Coroutines</summary>

  # Aula 16
##### [Python online](https://repl.it/)
##### [Python Tutorial](https://docs.python.org/3.9/tutorial/index.html)
##### [Standard library](https://docs.python.org/3.9/library/index.html)

# Decorators
Forma de modificar o comportamento (externo) de classes e funções.

- funções que se lembram de execuções passadas
- funções que fazem logs
são funções que recebem funções como argumentos e retornam uma outra função (que cuida dessa parte externa)
~~~Python
def llog(f):
   def wrapper(*args): 
      print("entrada:",args)
      x = f(*args)
      print("saida:",x)
      return x
   return wrapper

def aux(x,y):
   return 2*x+y

zz = llog(aux)
~~~
<br>

# notação @
~~~Python
aux = llog(aux)

@llog
def aux(x,y):
   return 2*x+y
~~~
<br>

# Decorators com estado - decorators como objetos
Voce pode retornar um objeto. Se o objeto for chamado como função, o método `__call__` desse objeto será executado

~~~Python
class decconta:
   def __init__(self,f):
      self.funcao=f
      self.conta=0
   def __call__(self,*args):
      self.conta += 1
      return self.funcao(*args)

xx=decconta(aux)
~~~
<br>

# mais info
[a primer on decorators](https://realpython.com/primer-on-python-decorators/)


# Exercícios
- decorator para imprimir o tempo de execução
- decorator para construir um string com linhas para a hora e argumentos e saida de cada chamada da função. O string será acessado via atributo
- decorator para memoizar a função. Memoização é criar um dicionário que se lembra dos valores de entrada e de saída da função ja executado. Se um desses valores de entrada for re-executado, a função não será re-executada - ela apenas retorna o valor de saída memoizado
- decorator para log argumentos e horario num arquivo (append no arquivo) dado como argumento do decorator (ver o primer on decorators )
<br>

# Iterator
Iterator é um thunk do haskell - uma promessa de computação que retorna um elemento por vez.

Funciona dentro de um `for`

# classe
- tem que ter um metodo `__iter__` que retorna um interator. A funçao iter chama o metodo `__iter__`
- tem que ter o metodo `__next__` que retorna o proximo elemento. A função next chama o metodo `__next__`
- gera a exception `StopIteration` quando não há mais elementos
~~~Python
x = iter([2,3])
next(x)
next(x)
next(x)
~~~
<br>


# for
~~~Python
for x in coisa:
  ...
~~~
é na verdade uma abreviação para
~~~Python
ii=iter(coisa)
try: 
  while True:
    x = ii.__next__()
    ...
except StopIteration:
    pass
~~~
<br>

# exemplo
~~~Python
class Repetidor:
   def __init__(self,x,n=4):
      self.n=n
      self.x=x
   def __iter__(self):
      return self
   def __next__(self):
      if self.n<=0: 
         raise StopIteration
      else:
         self.n-=1
         return self.x
~~~
<br>

# generators
Generators são funções que guardam o estado entre uma chamada e outra. Sintaticamente a unica diferença é usar um `yield` em vez do `return`

A cada execuçao, o `yield`computa o proximo valor a ser retornado e interrompe a execuçao. No proximo `next` o generator continua executando do ultimo `yield`.
~~~Python
def rep(x,n=4):
  while n>0:
     n-=1
     yield x
>>> z = rep(77)
>>> z.__next__()
77
>>> next(z)
77
>>> next(z)
77
>>> next(z)
77
>>> next(z)
~~~
```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
```
<br>

# generator comprehension
- Como list comprehention, mas usando ( e )
~~~Python
zz= (x*x for x in range(10,1000) if x % 4 == 0)

zz.__next__()
next(zz)
~~~
<br>

# itertools
uma biblioteca para iterators https://docs.python.org/3/library/itertools.html
<br>

# iterators no python
iterators no Python não sao exatamente bem conectados com o resto do python como os thunks sao em haskell (na minha opinião).

- algumas coisas retornam um iterator e coisas similares não
~~~Python
a = [6,5,3,1,7]
sorted(a)
reversed(a)
~~~

- == explora toda as 2 listas para ver se são iguas, mas nao iterators
~~~Python
list(range(1:4))
[1,2,3] == range(1,4)
~~~

por outro lado faz algum sentido não expandir os iterators - eles vao gerando novos elementos e não dá para `rewind`/ voltar atras num iterator (por exemplo o iterator que le linhas de um arquivo)!
<br>

# coroutines
processos que enviam mensagens de um para outro. Normalmente produtores, filtros e consumidores

um `filtro` precisa receber uma mensagem, e talvez enviar uma outra mensagem para o consumidor final

- enviar mensagem `consumidor.send(msg)` - manda a mensagem msg para o objeto `consumidor`
- receber mensagem msg = `(yield)`

~~~Python
def filtro(padrao,proximo):
   print("Comecando filtro")
   while True:
     msg = (yield)
     if padrao in msg:
        proximo.send(msg)



def consumidor():
    print("Comecando consumidor final")
    while True:
       l=(yield)
       print(l)

c=consumidor()
f=filtro("ab",c)
c.__next__() #para chegar no yield
f.__next__() # para chegar no yield
for x in "afh ahabcj agdb yyabctt abc abdddc".split():
    f.send(x)
~~~
<br>

# exercícios
Sem usar a itertools

- `pares`: dado um iterator, retorna um iterator com os elementos nas posicoes pares (0,2,..)
- `reverte`: dado um iterator, reverte ele (obviamente é preciso expandir of interator para chegar no ultimo elemento - * )
- `ziper`: dado 2 iterators, retorna um iterator que retorna os elementos intercalados
- `cart`: dado 2 iterators, retorna um iterator com o produto cartesiano dos elementos (todos os pares entre os 2 iterators) *
- `ciclo`: dado um iterator, retorna os elementos num ciclo infinito
- `rangeinf(init,passo=1)`: retorna um iterator que gera numeros de init ate infinito, com passo
- `take`: como o take do haskell
- `drop` - como o drop do haskell
  
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
<br>

![NumPy](https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white)

<details>
  <summary>Aula 17 - Numpy</summary>

# Aula 17 Numpy

# Numpy
**Arrays** em numpy são diferentes de listas ou listas de listas. Eles são mais eficientes e ninguém usa listas ou lista de listas em aplicações cientificas, que precisam ser eficientes tanto em memoria utilizada como em tempo de execução.

> <img src="https://img.shields.io/badge/YouTube-0d1116.svg?style=for-the-badge&logo=YouTube&logoColor=red" height="25"/><br>
&emsp;&nbsp;&nbsp; Veja os 3 primeiros videos em [codebasics](https://www.youtube.com/watch?v=rN0TREj8G7U&list=PLeo1K3hjS3uset9zIVzJWqplaWBiacTEU) que mostram bem os conceitos basicos de numpy.


> [Datacamp - Python Numpy Array Tutorial](https://www.datacamp.com/community/tutorials/python-numpy-tutorial) é um texto tambem bom <br>
> [Scypy Org - Quickstart tutorial](https://docs.scipy.org/doc/numpy-1.15.1/user/quickstart.html) é user guide do numpy mas eu acho o texto um pouco difícil para aprender.

numpy **não** vem pre-instalado no Python.

~~~Python
import numpy as np
~~~
(há um pacote de arrays no standard library array https://docs.python.org/3/library/array.html mas que nao é usado na prática, nao sei bem por que).
<br><br>

## criação array
[Array Creation - Numpy Org](https://numpy.org/doc/stable/reference/routines.array-creation.html)
<br>


`np.array` (inicializa os valores)

- 1D (inicializa com uma lista)

- 2D - lista de linhas

- 3 e nD - tensor

- ndim (numero de dimensões)

- shape (tamanho da cada dimensão)

~~~Python
import numpy as np

a = np.array([5,4,3.1,2,5])
a
X = np.array([[1,2,3],[10,20,30],[100,200,300]])
X
X.ndim
X.shape
~~~
<br>

Sem valores iniciais diferentes
- `np.ones` , `np.zeros`, `np.eye` (identidade) , `np.empty`

<br>

## Indexação de arrays
[Arrays Indexing](https://numpy.org/doc/stable/reference/arrays.indexing.html)
<br>

- tradicional
~~~Python
X = np.arange(1000).reshape((10,100)) 
X.shape # 10 linhas 100 colunas

X[2,3]
~~~
<br>

- por slices
~~~Python
X[0:4,8]
X[:,8]
X[0:4,8:10]
~~~
<br>

- menos dimensões
~~~Python
X[1] - 2a linha
~~~
<br>

- **por outro array** ou lista
~~~Python
arr = np.array([3,39,29,12])
lis = [3,39,29,12]

X[3,arr]
X[3,lis]
~~~
<br>

- **por array booleano**
~~~Python
arr
arr[np.array([True,False,False,True])

e = np.array([True,False,False,True,False,False,True,False,False,True,False])
X[e,8]
~~~
<br>

- indexacao por array de inteiros e por boleanos é comum em outras linguagens que tem array como tipo pre definido (R, Matlab, julia)
<br><br>

# indexação por 2 arrays - cuidado
Usar 2 arrays ou 2 listas para os indexadores ao mesmo tempo **NAO** faz o que vc esperaria. O numpy faz a indexação par a par nas 2 listas

~~~Python
X[[3,4], [11,12] ] 
X[np.array([3,4]), np.array([11,12]) ] 

X[3,11]
X[4,12]

X[[3,4], [11,12,13,14] ]
~~~
<br>

mas veja que com slices isso funciona como esperado
~~~Python
X[3:5,11:15]
~~~
<br>

para ter o efeito esperado com multiplas listas de indexadores use o `np.ix_`
~~~Python
X[ np.ix_(np.array([3,4]), np.array([11,12,13,14])) ]


X[ np.ix_([3,4], [11,12,13,14]) ] - funciona para listas de indices
~~~
**LEIA** a parte de indexação do manual do numpy https://numpy.org/doc/stable/reference/arrays.indexing.html

- np.newaxis
- ...
- np.slice
<br><br>

# Operações em arrays
- \+ \- \* \/ funcionam para array (operação elemento por elemento)

- \* não é a multiplicação de matrizes (isso é o método dot)

~~~Python
a = np.array([10,20,30])
b = np.array([1,2,3])
a+b
a*b
a/b
~~~
<br>

- multiplicação de matrizes (como em algebra linear)
~~~Python
a.dot(b)

np.dot(a,b)
~~~
<br>

- comparacoes funcionam para arrays (elemento por elemento)
~~~Python
a = np.array([1,2,3])
b = np.array([1,4,3])
a == b
np.greater(a,b)
~~~
<br>

diferente de listas que verificam se as 2 listas sao iguais
~~~Python
[1,2,3] == [1,4,3]

np.all( np.array([1,2,3]) == np.array([1,4,3]) )
~~~
<br><br>

# broadcast
os argumentos não precisam ter a mesmas ndim (inclusive atribuição)
~~~Python
a+2
4*X
np.array([1,2,3]) == 1

X % 2 == 0
~~~
<br>

- broadcast para array 2D e mais é mais complicado. https://docs.scipy.org/doc/numpy/user/basics.broadcasting.html
<br><br>

# indexação avançada + broadcast ( exemplo)
Rodar in ipython
~~~Python
import numpy as np

def g1():
    global x
    for i in range(x.shape[0]):
        for j in range(x.shape[1]):
            if x[i,j] < 0.5:
                x[i,j]=0.0
    return None
    
def g2():
    global x
    x[x<0.5]=0.0
    return None
    
y = np.random.rand(4000,30)
x = np.array(y,copy=True)
%timeit g1()
x = np.array(y,copy=True)
%timeit g2()
~~~

x<0.5 é um array 2D booleano que sever para indexar os elementos de x que vao trocar de valor
<br><br>

# tipo
- arrays numpy sao implementados como arrays em C - memoria contigua
- tipo np.int16 np.int32 np.float32
- e não o inteiro do Python que é sem limite
~~~Python
X.dtype
a.dtype
~~~
<br>

- existe o tipo caracter e sequencia de caracter
- existe o tipo np.object para apontador para qq coisa
~~~Python
c = np.array("qwert")
c.dtype
c = np.array(["qwert","asd","longo muitoooooooooooooooo longo",57])
c.dtype
~~~
<br>

# reshape
- a operacao de modificar o formato de um array é barata. Não há copia dos dados
~~~Python
a = np.array([1,2,3,4,5,6,7,8,9,10,11,12])
a
b=a.reshape((3,4))
b

c = np.reshape(a,(1,12))
~~~
note a diferença entre a e c
<br><br>

# np.info
~~~Python
np.info(a)
np.info(b)
X = np.array([ [1,2],
               [3,4],
               [5,6],
               [7,8])
~~~
<br>

- shape

- type

- itemsize

- fortran
  - ordem fortran 1,3,5… - column major
  - ordem C 1,2,3,.. row major
    
- stride https://stackoverflow.com/questions/53097952/how-to-understand-numpy-strides-for-layman como achar o proximo elemento, na linha (stride[1]) e na coluna (stride[0])

- data - o block de memoria com os dados brutos do array. O Python reusa o data sempre que possível, trocando o stride para representar diferentes “formatos” do array. Veja que o reshape reusa o data.

`np.info(c)` reusa o data tambem.
<br>

# Funçoes em numpy
## Funções elemento por elemento
- np.log

- \+ \- \/ \*

- np.add

- np.greater >

- np.logical_and
<br>

## Funções que agregam varios valores
- np.all
- np.sum https://numpy.org/doc/stable/reference/generated/numpy.sum.html#numpy.sum
- np.amax
`axis` - faz a operação agregação **nessa dimensão** - sobram as outras
~~~Python
a = np.arange(24).reshape(3,4,2)
a

np.sum(a,axis=0)

np.amax(a,axis=(1,2))
~~~
<br>

## Junta e quebra arrays
https://numpy.org/doc/stable/reference/routines.array-manipulation.html#joining-arrays

- `concatenate` - numa dimensão que ja existe - para arrays 2D `vstack` e `hstack` para juntar na vertical ou na horizontal
- `stack` numa nova dimensão
<br>

## Algebra linear
https://numpy.org/doc/stable/reference/routines.linalg.html

- produto de matrizes e vetores
- inversão de matrizes
- fatoração de matrizes
- auto-vetores e auto-valores
<br>

## I/O
Formato interno para matrizes npy

- save
- load
<br>

Texto
- savetxt
- loadtxt

csv
- pacote da standard library [csv](https://docs.python.org/3/library/csv.html)
- funcão do [pandas](https://pandas.pydata.org/index.html) `pandas.read_csv`
<br>

## bibliotecas de algebra linear
as operações (e algumas funções - autovalores e auto vetores, determinantes, etc) do numpy são implementadas por bibliotecas de baixo nivel que operam diretamente no `data`

Bibliotecas de algebra linear de baixo nivel
- BLAS http://www.netlib.org/blas/
- openBLAS https://github.com/xianyi/OpenBLAS/releases
- LAPACK http://www.netlib.org/lapack/lug/
- MKL https://software.intel.com/en-us/mkl
- ATLAS
- Armadillo http://arma.sourceforge.net/
- 
contiguous indica se o data pode ser enviado diretamente para a biblioteca de baixo nivel. Se nao, o numpy cria uma nova versão do array (copiado o `data`) de forma que possa ser usada pela biblioteca!

# Loops mais complexos
de uma olhada no 4a video de https://www.youtube.com/playlist?list=PLeo1K3hjS3uset9zIVzJWqplaWBiacTEU que fala sobre uma função util para fazer iteração em arrays.
<br>

# Cython
Extensões tipo C do python https://cython.org/

- sintaxe de controle do python
- declaração de tipos de variáveis locais
- pode incluir operações/funções do python (mas isso torna o código mais lento pois tem que haver a conversão para objetos python)

Veja a função Primes em https://cython.readthedocs.io/en/latest/src/tutorial/cython_tutorial.html

curso sobre cython https://nyu-cds.github.io/python-cython/

Ha poucos sites discutindo cython + numpy
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
<br>

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=yellow)

<details>
  <summary>Aula 18 - Extras de Python - Exercícios, Pacotes e módulos, Programação Funcional, Debug </summary>


# Aula 18 Extras de Python
## Exercícios

1. Dado X um array 2D com 10 linhas. Some 10 aos elementos da 1a linha, 20 aos da 2a, 30 aos da terceira e assim por diante
2. Dado X um array 2D com 10 Colunas. Some 10 aos elementos da 1a coluna, 20 aos da 2a, 30 aos da terceira e assim por diante
3. Dado z um array 1D. Remova de a todos os elementos negativos (retorna um novo array)
4. Dado z um array 1D. substitua por 0 todos os elementos negativos de z
5. Dado z um array 1D. Qual o maior valor em z
6. Dado z um array 1D. Qual a posicao do maior valor em z
7. Dado z um array 1D. Qual o valor em z com o maior valor absoluto? Se z = np.array([4,-5,2]), 4 é o maior valor, mas -5 é o dado com maior valor absoluto. A resposta deve ser -5 e nao 5 (eu nao quero o maior valor absoluto, eu quero o valor no array the yem o maior valor absoluto)
8. Dado X um array 2D, compute a soma de cada linha.
9. Dado X um array 2D compute a soma de cada coluna
10. Dado X um array 2D, normalize cada linha, de forma que a soma dos valores das linhas é 1
<hr>
<br>

# broadcast
os argumentos não precisam ter a mesmas ndim (inclusive atribuição)

~~~Python
a = np.array([-3,-4,-5])

X = np.array([[3,4,5],[6,7,8]])


a+2
4*X
np.array([1,2,3]) == 1

X % 2 == 0
~~~

Os argumentos não precisam tem o mesmo tamanho em cada uma das dimensões - esse tamanho pode ser 1.

~~~Python
a1 = np.array([100,200])

a2 = np.array([[10,20,30]]

X.shape
a1.shape
a2.shape

X + a1

X+ a2
~~~

- broadcast para array 2D e mais é mais complicado. https://docs.scipy.org/doc/numpy/user/basics.broadcasting.html
<br>

# Transposta

é um atributo(?) e nao um metodo
~~~Python
np.info(X)

Y = X.T

np.info(Y)
~~~
<br>

- reusa o `data`, mas o `continous` passa a ser falso e nao pode ser usado por bibliotecas de baixo novel de algebra linear
  
# pacotes/modulos
Veja o link para o standard library

- math - funcoes matemáticas
- random - geracao de numeros aleatórios
- re - expressoes regulares
- os.path - diretorios e arquivos
- sys e os - interface com o sistema operacional
- collections - typos de dados para collections
- itertools - iterators (próxima aula)
- functools - programacao funcional
- operator - operadores como função
- pickle - salva e le objetos python
- concurrent.futures - processamento em paralelo
- requests - acesso ao http
- time - informacoes temporais
<br>

Pacotes externos - requer instalacao `pip` ou `conda`
- numpy - arrays
- pandas - data frames (tabelas) e Polars (mais rapido)
- scipy - operacoes scientificas e estatísticas
- statsmodels mais estatistica
- scikit-learn - aprendizado de maquina
- beautifulsoup - processar paginas html
- cherrypy - web server
- Matplotlib e seaborn e Bokeh - graficos
- SQLAlchemy - banco de dados
- flask e streamlit e fastAPI - web ap builders
<br>

A interface para os modulos é normalmente através de objetos.

Mas nem sempre - todas as funções em `math` e algumas no `scipy` são funções e não objetos/métodos

Programas externos uteis
- ruff lint
- ipython, bpython - REPLs
- virtual environments em python https://realpython.com/python-virtual-environments-a-primer/
- python 3.9
<br>


# Programação funcional
## funcoes anônimas
lambda mas a funcao so pode ter 1 linha
~~~Python
lambda x : x > 0
~~~
<br>

## map, filter
~~~Python
map(lambda x : x+3, [4,5,6,7])

filter(lambda x: x>0, [4,-5,6,-7])
~~~
mas use o list comprehension em vez de map+filter
<br>

## fold (reduce)
foldl:
~~~Python
from functools import reduce

reduce(combinacao, lista, inicial)
~~~
<br>

## funções que recebem funções como um argumento extra
key: uma funçao que é aplicada em cada elemento e cujo valor é usado na computação
~~~Python
max( iteratable, key=func)
list.sort(key=func)
sorted( iteratable, key=func)
max(lista,key=func)
=
max([(func(x),x) for x in lista])[1]
~~~
<br>

## modulo operator
x[i] ou x['chave'] ou x.chave podem ser convertidos em funções para o argumento x
- itemgetter - f = itemgetter(2) entao f(x) retorna x[2]
- f = itemgetter(2,3,5) entao f(x) retorna (x[2],x[3],x[5])
- attrgetter - f = attrgetter("chave") entao f(x) retorna x.chave
<br>

# Debug
em python modulo pbd https://docs.python.org/3/library/pdb.html
~~~Python
>>> import pdb
>>> import mymodule
>>> pdb.run('mymodule.test()')
~~~
ou

~~~Python
python3 -m pdb meuprog.py
~~~

Exemplo https://realpython.com/python-debugging-pdb/

video https://www.youtube.com/watch?v=6RkGmqcfiTw
<br>

## breakpoint
interrompe a execução e entra no modo debug

coloque

breakpoint()
na linha do código.

ou (isso é o que realmente acontece)

import pdb; pdb.set_trace()
o prompt muda para (pdb)

## ponto da execução
antes da execução de uma linha de codigo

## next (n)
executa ate a proxima linha da mesma função
```
--> m = func(4)
    proc(m+5)
```

next executa m=func(4) e vai para antes de proc(m+4)
<br>

## step (s)
entra no debug da proxima função na execução, nesse caso entra e para na 1a linha de func

## continue
roda normalmente até o fim do programa ou ate o proximo breakpoint

## inspecionar e modificar o estado
print var

interact cria um REPL neste ponto (com acesso a variáveis locais)

é possivel trocar o valor de variaveis locais e continuar a execução usando os novos valores

## mover na pilha de execução (e inspecionar o estado nela)
up (função que chamou) e down

## checagem de tipo em tempo de execução
variável x

isinstance(x, str)
ou

type(x) is srt
<br>

# type hints
https://www.python.org/dev/peps/pep-0484/

def soma(x: int, y: int):
mas ok rodar

soma('3','4')
vc precisa rodar usando um interpretador estendido mypy

## linguagem para definir os tipos
voce precisa de uma linguagem para definir tipos complexos e é isso que o PEP define

- se soma pode aceitar `int` e `float`
- uma lista qualquer
- lista de `str`
- um dicionário cuja chave é uma tupla de valores x e y
- qualquer tipo
- funções de um tipo particular
- etc
<br>
  
# Cython
Extensões tipo C do python https://cython.org/

sintaxe de controle do python
declaração de tipos de variáveis locais
pode incluir operações/funções do python (mas isso torna o código mais lento pois tem que haver a conversão para objetos python)
Veja a função Primes em https://cython.readthedocs.io/en/latest/src/tutorial/cython_tutorial.html

curso sobre cython https://nyu-cds.github.io/python-cython/

Ha poucos sites discutindo cython + numpy
</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
<br>

![Lisp](https://img.shields.io/badge/%CE%BB-%20Lisp-%2300599C.svg?style=for-the-badge&logo=%CE%BB&logoColor=white)

<details>
  <summary>Aula 19 - Lisp</summary>

# Aula 19 - Lisp
##### https://lisp-lang.org ou https://common-lisp.net/downloads (common lisp)

##### https://common-lisp.net/downloads lisp online

##### https://clojure.org/index Clojure

- 1958
- primeira linguagem funcional
- primeiro REPL
- vários dialetos
  - metaprogramcaçao ou macros
  - varias implementações (com diferenças)
- scheme 1970
- common lisp 1975 - virou o padrão
- clojure 2005
- racket 2010 - para criar outras linguagens de programação


Lisp é facilmente modificável e acaba incorporando ideias novas em programação
- OO (1983 logo depois de Modula)
- call with continuation
- pattern matching
- lazy evaluation(??)
- etc
<br><br>

# Listas
Entre pareteses, heterogenea, separa por brancos
~~~Lisp
(5  6  9.8 abobora () (5 6)  "abc")
~~~
abobora é um simbolo/atomo, como em prolog.
<br><br>

# Sintaxe
~~~Lisp
(funcao arg1  arg2 ...)

(operador arg1 arg2 ...)

(special-form arg1 arg2 ...)
(+ 4 5 6 (cos 4))

(if (> x 0) (* x 4) (- x 2))
~~~
<br><br>

# Diferença de função e comando (special form)
Em outras linguagens de programação uma diferença é a sintaxe
~~~Lisp
 if (a<b)  a else b 

 if(a<b,a,b)
~~~
<br>

mas em lisp nao há diferença sintática
~~~Lisp
     (if (> a b) a b)
          
     (func (> a b) a b)
~~~
<br>

A diferença central é que funções sempre avaliam seus argumentos e comandos podem nao avaliar todos
~~~Lisp
(if (> a b) a (/ 1 0))
~~~
se a > b (/ 1 0) não é avaliado e nao da problema. Se fosse uma funçao (que avalia seus argumentos antes de rodar - a nao ser o Haskell por causa do lazy!) isso daria problema.
<br><br>

# let
versão simples
~~~Lisp
(let ()
    exp1
    exp2
    ...
    expn)
~~~
avalia cada expressão **na ordem**. Retorna o valor da ultima expressão
<br>

versão com variáveis locais
~~~Lisp
(let ((var1 val1)
      (var2 val2)
      ...
      )
    exp1
    exp2
    ...
    expn)
~~~
cria as variáveis locais **var1** … e atribui os valores **val1** … (como no haskell)
<br><br>

# setf
(setf x exp) avalia a expressão e atribui a variável x (local ou global)
<br><br>

# defun
define funções
~~~Lisp
(defun double (x)
    (* x 2)
    )
    
(defun aux (x y)
    (let ((a (+ x y))
          b
          )
     ...
    )
)
~~~
<br><br>

# listas (funcoes)
- `cons` gruda na frente de uma lista (: do haskell)
- `car first` a cabeça da lista
- `cdr rest` o resto da lista
- `null` testa se a lista é vazia
- `NIL` ou `()` lista vazia
- `append` gruda 2 ou mais listas
- `list` cria uma lista de seus argumentos
- `eq eql equal equalp =` testes de igualdade https://eli.thegreenplace.net/2004/08/08/equality-in-lisp
- igualdades rapidas/atomicas O(1) `eq eql =` e igualdades lógicas O(n) listas, etc
- há o problema do caso infinito para igualdades lógicas

~~~Lisp
class X
 pass
 
a = X()
a.nome = "jose" 
a.dado = a

b = X()
b.nome = "jose" 
b.dado = b

a==b
~~~
<br><br>

# Exemplos de programas
~~~Lisp
(defun reverte (lista)
    (if (null lista) NIL
        (append (reverte (rest lista)) 
                (list (first lista)))
        ))
(defun revacc (lista acc)
    (if (null lista) acc
        (revacc (rest lista) 
                (cons (first lista) acc))
        ))
(defun trocatodos (novo velho lista)
    (if (null lista) nil
        (if (eql (first lista) velho) 
            (cons novo (trocatodos novo velho (rest lista)))
            (cons (first lista) (trocatodos novo velho (rest lista)))
        )
    )
)
~~~
<br>
ou
~~~Lisp
(defun trocatodos (novo velho lista)
    (if (null lista) nil
        (let ((a (first lista))
              (r (rest lista))
             )
           (if (eql a velho) 
               (cons novo (trocatodos novo velho r))
               (cons a (trocatodos novo velho r))
           )
       )
    )
)
~~~
<br>

ou ainda
~~~Lisp
(defun trocatodos (novo velho lista)
    (if (null lista) nil
        (let* ((a (first lista))       <---- let*
               (r (rest lista))
               (resto (trocatodos novo velho r))
             )
           (if (eql a velho) 
               (cons novo resto)
               (cons a resto))
           )))
~~~
<br><br>

# Exercicios
os mesmos da 1a aula do haskell (e do prolog)

- dado um item e uma lista, escreva a funcao separa que retorna um lista com 2 sublistas, a primeira sao os itens da lista antes do separador e a segunda os itens apos o separador
~~~Lisp
(defun separa (item lista)
    (if (null lista) (list nil nil)
        (if (eql item (first lista)) 
            (list nil (rest lista))
            (let* ((x (separa item (rest lista)))
                   (y (first x))
                   (z (rest x))
                  )
                  (cons (cons (first lista) y) z)
              ))))
~~~
<br><br>

# quote
`(1 2 3)` não funciona, `1` não é uma função/operador/forma especial

listas são avaliadas como expressões.

eu preciso desligar o avaliador para criar a lista (1 2 3)

~~~Lisp
(quote (1 2 3))

'(1 2 3)
~~~
<br>

ou
~~~Lisp
(list 1 2 3)
(cons 1 (cons 2 (cons 3 nil)))
~~~
<br><br>

# avaliação
Como `(list 1 2 (+ 4 5))` avalia?

- o 1º elemento da lista é uma funçao list
- avalia cada um dos argumentos
- números avaliam para eles mesmos `1 ==> 1, 2 ==> 2`
- `(+ 4 5)` é uma nova lista/expressão. + é uma função.
- recursivamente avalia `(+ 4 5)` para 9
- roda o `list` que cira uma lista com 1 2 e 9
- retorna `(1 2 9)`


Outras coisas além de números avaliam para si mesmos
- strings
- nil avalia para ()
- () avalia para si mesmo
- ‘T’ avalia para si mesmo (True)
- simbolos começando com : (keywords)

A avaliação de um simbolo retorna o valor armazenado (via let ou setf) no simbolo/variável
~~~Lisp
(setf x (+ 1 2))
x

(let ((x 99.7))
    (print x))
~~~

quote simbolo retorna o simbolo: `'abc` retorna o simbolo `abc`
<br><br>

# Static & Dynamic scope
variavies livres em funções.
~~~Lisp
(setf x 8)
(defun f1 (a) (+ x a))
   
(let ((x 100)) 
        (f1 4))
        
~~~
==> 12
<br>

em python
~~~Python
x = 8
def f1 (a):
    return x+a
    
def f2():
    x = 100
    f1(4)

f2()
~~~
==> 12
<br>

que é o comum em outras linguagens de programação. A variavel “livre” x de f1 vem do contexto sintatico onde a definição de f1 esta. Nesse caso a variavel global.

Isto é o escopo **estatico**

Lisp permite o escopo **dinamico**
~~~Lisp

(defvar x 8)   <--- declara um escopo dinamico para x
(defun f1 (a) 
    (+ x a))

(let ((x 100)) (f1 4))
~~~
==> 104

no segundo caso, o escopo de x é **dinamico**, e o valor usado será o último disponível na pilha de execuçao.
<br><br>

# como construir um programa montando uma lista
~~~Lisp
(list 'if '(> x 0) (cons '* '(x 4))
      (list '- 'x 2))
~~~      
==>       
      
(if (> x 0) (* x 4) (- x 2))      
      
isso é o central na metaprogramação
<br><br>

# macros/metaprogramming
“funções” que nao avaliam seus argumentos, mas geram uma lista usando esses argumentos, que é uma expressão Lisp. Essa lista gerada é avaliada ou compilada
~~~Lisp
(when teste a1 a2 .. an) 
~~~

===> converte para
~~~Lisp
(if teste (let ()
           a1 a2 .. an))
(defmacro when2 (teste &rest resto)
    (list 'if teste (cons 'let (cons () resto)))
    )

(macroexpand '(when2 (pos a) (incf a) (print a)))
(pyif  teste t1 t2 t3 else: e1 e2)
~~~

==> converte para 
~~~Lisp
(if teste (let () t1 t2 t3) (let () e1 e2))

(defmacro pyif (teste &rest resto)
    (let* ((troca (separa `else: resto))
           (pthen  (first troca))
           (pelse  (second troca))
           (xthen (if (null pthen) nil
                      (cons 'let (cons nil pthen))))
           (xelse (if (null pelse) nil
                      (cons 'let (cons nil pelse))))
          )
       (list 'if teste xthen xelse)
       ))
~~~
<br><br>

# read macros
define comportamentos na leitura para caracteres especias

`'( a b c)` ==> `(quote (a b c))`
`quote` é uma forma especial que nao avalia seu argumento e retorna ele

- backquote - para macros
- #' para funções
- #(1 2 3) ==> (vector 1 2 3)
- etc

~~~Lisp
(defmacro when2 (teste &rest resto)
    `(if ,teste 
         (let () ,@resto)
         )
)
~~~
<br><br>

# lisp-1 vs lisp-2
Se variáveis podem ter tanto um valor e uma função associada (lisp-2) ou apenas um valor (que pode ser uma função) (lisp-1)

python
~~~Python
soma1 = 6

def soma1 (a):
    return a*2
~~~
x só pode ter um valor (e vira uma função no def)

common lisp
~~~Common-Lisp
(setf soma1 6)
(defun soma1 (a) (+ 1 a))
~~~
common lisp é um lisp-2
scheme é um lisp-1
<br>

O problema de um lisp-2 sao as funções de alto nível
~~~Common-Lisp
(map soma1 '(1 2 3 4))
~~~
- em lisp-2 `soma1` vai ser avaliado e retorna o valor armazenado no simbolo e não a função definida.

- é preciso uma forma especial que retorna a função associada a um simbolo
~~~Common-Lisp
(map #'soma1 '(1 2 3))
~~~
<br><br>

# Clojure
- como Scala, compila para JVM, e é compatível com bibliotecas e código já escrito em java

- usado como linguagem principal(?) de desenvolvimento no Nubank https://building.nubank.com.br/clojure-15th-anniversary-a-retrospective/ que comprou a Clojure https://olhardigital.com.br/2020/07/24/pro/nubank-compra-criadora-das-linguagens-de-programacao-clojure-e-datomic/

- mudanças sintáticas.

A mais importante é listas que não vão ser avaliadas (em formas especiais) são trocadas por [ ]
~~~Common-Lisp
(defun soma (x y)
   (let ((soma (+ x y))
        )
    soma
    ))
    
(defn soma [x y]
   (let [soma (+ x y)]
    soma))
~~~
- interoperabilidade com java: veja em https://clojure.org/guides/learn/functions Java Interop

- vetores, dicionários, sets
<br><br>

# Implementação de lisp
uma implementação inicial de lisp é fácil.

processamento sinatico é facil - expressões estão entre ( e ) casados

implemente (no baixo nível) apenas alguns primitivos

- atribuição (setf)
- construção de lista (cons)
- um condicional (if)
- quote
- definição de função anonima
- macros
- aplicação de uma função
- operacoes aritmeticas em numeros e 2 funcoes em listas (cons, first e rest)
- mais alguns poucas coisas….

Por exemplo https://homes.cs.aau.dk/~normark/prog3-03/html/notes/languages_themes-list-in-lisp.html

https://stackoverflow.com/questions/2664618/what-does-it-mean-that-lisp-can-be-written-in-itself

https://github.com/fluentpython/lispy/tree/main

As outras coisas são macros do próprio lisp

**Meta-circular evaluator**
</details>


<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
<br>

![OCaml](https://img.shields.io/badge/OCaml-%23E98407.svg?style=for-the-badge&logo=ocaml&logoColor=white) ![F# Badge](https://img.shields.io/badge/F%23-378BBA?logo=fsharp&logoColor=fff&style=for-the-badge) 

<details>
  <summary>Aula 20(Parte 1) - oCaml e F#</summary>

  # Aula 11 OCAML e F#
##### [OCAML online](https://try.ocamlpro.com/)

##### [tutoriais](https://ocaml.org/learn/tutorials/)

# OCaml e F#
## OCaml
outra linguagem funcional mas com componentes de linguagem imperativa

## Coisas parecidas
### listas
como em Haskell (homogênea) mas separado por ;
~~~ocaml
let a = [1; 2; 3; 7; 5; 1]
~~~
No pattern matching e na construção, o operador que separa head de tail é :: e não : (no Haskell)
~~~ocaml
let b = 7 :: a
~~~
<br><br>

### Aplicação de função
Como em Haskell - mesma sintaxe sem parenteses e virgula separando função de argumento
~~~ocaml
let f x y = 2*x+y

f 4 3
~~~
- currying tambem vale
<br><br>

### Funcoes recursivas
precisa usar a palavre rec
~~~ocaml
let rec gera n =
    if n=0 then []
    else n :: gera (n-1)
~~~
<br><br>

# Pattern matching e Guards (usando o match +when)
~~~ocaml
let rec pertence x lista =
    match lista with
     |  []               -> false
     |  a::_   when  x = a -> true
     |  _::as            -> pertence x as
~~~
<br><br>

# Outras
- `let ... in` para definir funções e variáveis locais
- `List.map` e `List.fold_left` em vez de `map` e `foldl`
<br><br>

# Coisas diferentes
## =
- teste de igualdade é apenas um = que é tambem o operador para “definição de função” (super confuso) (veja o código do pretence acima)
<br><br>

## strict (nao Lazy)
Haskell 
~~~haskell
f _ = 3

f (1/0) -> 3
~~~
<br>

OCAML
~~~ocaml
let f _ = 3

f (1/0) -> erro divisão por 0
~~~
<br><br>

## tipagem forte
- não converte de `int` para `float` automaticamente
- tem operações diferentes para `int` e `float`: `+` para int, `+.` para float
<br><br>

## permite modificar (algumas) variáveis
~~~ocaml
let quit_loop = ref false in
  while not !quit_loop do
    print_string "Have you had enough yet? (y/n) ";
    let str = read_line () in
      if str.[0] = 'y' then
        quit_loop := true
  done;;
~~~

- `quit_loop` é um “apontador” (ref) para bool

- `!quit_loop` é o valor de quit_loop
- `:=` é atribuição
- `read_line` tem tipo `unit -> string` e o `()` o único dado to tipo `unit`
- `read_line ()` é escrito como `read_line()` que se parace com uma função sem argumentos na sintaxe mais tradicional.
<br><br>


##  Arrays
Arrays sao vetores modificáveis
~~~ocaml
let add_vect v1 v2 =
   let len = min (Array.length v1) (Array.length v2) in
   let res = Array.make len 0.0 in
   for i = 0 to len - 1 do
     res.(i) <- v1.(i) +. v2.(i)
   done;
   res;;
~~~

- note a operação <- (e nao o :=)

- note tambem o for que é apenas para gerar números.

- nao existe o break para sair de um loop
<br><br>


## Comandos
- Existe um tipo unit ou () que é um comando (que não retorna nada - o importante é seu efeito colateral)

- voce pode usar o padrão
```
comando;
comando;
..
comando;
expressão
```
no lugar de expressões.

Veja de novo
~~~ocaml
let quit_loop = ref false in
while not !quit_loop do
  print_string "Have you had enough yet? (y/n) "; --> comando
  let str = read_line () in
  if str.[0] = 'y' then                  -> um if sem else!
    quit_loop := true                             -> comando
done;;
~~~

me parece que o `while` é um comando tambem que retorna `()`
<br><br>

# haskell vs OCaml
https://markkarpov.com/post/haskell-vs-ocaml.html
<br><br>
<hr>
<br>

# F#
##### (fonte https://learn.microsoft.com/en-gb/dotnet/fsharp/

Bem parecido com OCaml
- declaracao de função
~~~F#
let doubleIt x = 2*x

let doubleIt = fun n -> 2 * n

fun n é uma lambda expression
~~~
<br>

- sintaxe de metodos para alguns tipos pre definidos
~~~F#
let str = "F#"
let lowercase = str.ToLower()
~~~
<br>

- pattern matching parecido mas nao igual ao OCaml
~~~F#
// This example uses a record pattern.

type MyRecord = { Name: string; ID: int }

let IsMatchByName record1 (name: string) =
  match record1 with
  | {MyRecord.Name = nameFound; MyRecord.ID = _;} when nameFound = name -> true
  | _ -> false
~~~
<br>

-  variaveis mutaveis
~~~F#
let mutable x = 1
x <- x + 1
~~~
<br>

- <- atribuicao
- listas [1; 2; 3 ]
- arrays como tipo basico , com representacao sintatica [| 1;2;3 |] e mutavel.
- unidades metricas para os valores https://learn.microsoft.com/en-gb/dotnet/fsharp/language-reference/units-of-measure o compilador checa unidades corretas (inclui conversão??) - talvez exista algo assim tambem em haskell?
- OO (uma classe na verdade é um novo tipo)

~~~F#
module DefiningGenericClasses = 

    type StateTracker<'T>(initialElement: 'T) = 

        /// This internal field store the states in a list.
        let mutable states = [ initialElement ]

        /// Add a new element to the list of states.
        member this.UpdateState newState = 
            states <- newState :: states  // ***use the '<-' operator to mutate the value.***

        /// Get the entire list of historical states.
        member this.History = states

        /// Get the latest state.
        member this.Current = states.Head

/// An 'int' instance of the state tracker class. Note that the type parameter is inferred.
let tracker = StateTracker 10

// Add a state
tracker.UpdateState 17
~~~

</details>


<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
<br>

![Scala](https://img.shields.io/badge/scala-%23DC322F.svg?style=for-the-badge&logo=scala&logoColor=white)

<details>
  <summary>Aula 20(Parte 2) - Scala</summary>
  
  # Aula 11 Scala
##### [Scala online](https://scastie.scala-lang.org/)
##### https://learnxinyminutes.com/docs/scala/
##### https://docs.scala-lang.org

compila p/ JVM - permite rodar bibliotecas compiladas de Java

acoplado a um ambiente de execucão distribuida Apache Spark https://spark.apache.org

algumas diferenças entre Scala 2 e 3 (como Python 2 e 3)
- sintaxe similar ao Python (mudança de linha e indentação)
- variáveis mutáveis `var`e imutáveis `val`
- List (homogenea) Array
- `{comando; comando .., expressão}` retorna o valor da expressao
- funcoes

~~~scala
val addOne = (x: Int) => x + 1
~~~
<br>

metodo
~~~scala
def addOne(x:Int) : Int => {
  ...;
  ...;
  x+1
  }
~~~
<br>

- classes
~~~scala
class Point(var x: Int, var y: Int):

  def move(dx: Int, dy: Int): Unit =
    x = x + dx
    y = y + dy

  override def toString: String =
    s"($x, $y)"
end Point
~~~

parametros do construtor na definicao da classe

paramentros do construtor sao automaticamente atributos

override explicito
- list comprehention
~~~scala
val twentySomethings =
  for user <- userBase if user.age >=20 && user.age < 30
  yield user.name
~~~
<br>

- funcoes de alto nivel (map filter foldLeft foldRight, etc
~~~scala
val salaries = Seq(20_000, 70_000, 40_000)
val newSalaries = salaries.map(x => x * 2)
  
val a = List("jane", "jon", "mary", "joe")
val b = a.filter(_.startsWith("j"))
         .map(_.capitalize)  
  
def promotion(salaries: List[Double], promotionFunction: Double => Double): List[Double] =
    salaries.map(promotionFunction)  
~~~
<br>

- maybe
~~~scala
def makeInt(s: String): Option[Int] =
  try
    Some(Integer.parseInt(s.trim))
  catch
    case e: Exception => None

val stringA = "one"
val stringB = "2"
val stringC = "3"

val y = for
  a <- makeInt(stringA)
  b <- makeInt(stringB)
  c <- makeInt(stringC)
yield
  a + b + c
~~~

</details>

<!-- 
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
##########################################################################################################################################################
-->
