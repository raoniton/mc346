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
