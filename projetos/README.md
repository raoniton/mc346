# Projetos 
Ao logo do semestre foram propóstos alguns projetos em linguagens diferentes, abaixo é possível encontrar a descrição de cada projeto.

<details>
  <summary>Projeto 1 - Haskell </summary>

  # Projeto 1 - ![Haskell](https://img.shields.io/badge/Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)

  <b> Entrega: Até meida noite de 26/08</b>
  
  Submeta o arquivo **proj1.hs** em texto com o programa via classroom.

  # 1
  Implemente a função  **trocatodos**  que recebe o valor  `velho`  e o valor  `novo`  e uma  `lista`  e retorna a lista com  **todas**  as instancias de velho na lista trocada por novo.

  ```
  trocatodos 4 10 [1,2,3,4,5,4,6,7,4] 
  ==> [1, 2, 3, 10, 5, 10, 6, 7, 10]

  trocatodos 4 10 [1,2,3,5,6,7]
  ==> [1,2,3,5,6,7]
  ```

  # 2

  implemente a função  **cumsum**  que dado uma  `lista`  de números retorna a lista com a soma cumulativa desses números. (na lista retornarda, a posição  ii  contem a soma dos elementos da lista original até a posição  ii)

  ```
  cumsum [4]
  ==> [4]

  cumsum [5,10,2,3]
  ==> [5,15,17,20]
  ```

  ## Detalhes

  As duas funções devem estar num mesmo arquivo submetido  **proj1.hs**

  Eu nao vou rodar o arquivo em batch assim não se preocupe com as mensagens de erro sobre a função  `main`

  Para as 2 funções, voce pode definir funções auxiliares (fora do corpo) ou funções locais mas as funções  `trocatodos`  recebe 2 valores e uma lista apenas, e a  `cumsum`  1 lista apenas, respectivamente.

  -   As implementações não podem usar funções pre-definidas do Haskell, com a excessão dos operadores matemáticos e as funções  `head`  e  `tail`. Se vc precisa de alguma função, precisa implementa-la
      
  -   haverá uma pequena perda na nota se as funções não usam o mecanismo de regras e pattern matching. Nao é necessario usar guards, mas pense em usa-los se for o caso.

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
  <summary>Projeto 2 - Haskell - Compressão e Descompressão de Listas</summary>

   # Projeto 2 - ![Haskell](https://img.shields.io/badge/Haskell-5e5086?style=for-the-badge&logo=haskell&logoColor=white)

<b>Entrega: Até meia noite de 02/09</b>
<br>

# Compressão e descompressão de listas
dada a lista ( de caracteres neste exemplo)

`"aaabbaasxbbbb"`  
vamos definir uma lista comprimida cujos elementos são pares (item, quantidade) onde quantidade é o número de vezes que o item aparece sequenciamente na lista. Assim, a compressão dessa lista seria:

`[('a',3),('b',2),('a',2),('s',1),('x',1),('b',4)]`
- Implemente a função comprime :: Eq a => [a] -> [(a,Int)]
```
comprime [3,3,3,4,5,6,5,5,5,5,7]

=> [(3,3),(4,1),(5,1),(6,1),(5,4),(7,1)]
```
- Implemente a função descomprime :: Eq a => [(a,Int)] -> [a] que é o inverso de comprime
```
descomprime [(3,3),(4,1),(5,1),(6,1),(5,4),(7,1)]

==> [3,3,3,4,5,6,5,5,5,5,7]
```
<br>

# Restrições
Nesse projeto voce pode usar qualquer função já predefinida no [Prelude do Haskell](https://hackage.haskell.org/package/base-4.20.0.1/docs/Prelude.html#g:13) mas nao pode usar funções definidas nos modulos
<br>

# Comentários
eu acho que nao é claro como usar programação de alto nivel (funções que operam em funções) no problema de comprimir. Acho que seria uma recursao tradicional. Na minha cabeça um foldr é mais claro nesse problema, mas vc pode resolver como quiser

O descomprime é muito mais próximo de uma abordagem usando programação de alto nivel. Cada elemento da lista comprimida , algo como `(5,4)` precisa ser transformado em `[5,5,5,5]`. Nesse primeiro passo vc obtem uma lista de listas. Mas veja o que a função concat, já definida no prelude faz:
```
ghci> concat [[1],[3,4,9],[],[5,6,7,10],[],[4]]
[1,3,4,9,5,6,7,10,4]
```
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
  <summary>Projeto 3 - Haskell - Manipulando Tuplas</summary>

  # Projeto 3
  <b>Entrega: Até meia noite de 18/09</b>
  

# 1) incrementar (função auxiliar)
Implemente um contador. Esse contador pode ser implementado como uma lista de tuplas onde cada tupla é no formado `(chave, contador)`. Ou o contador pode ser implementado usando um dicionario do `Data.Map.Strict`

Implemente a funçao:
~~~Haskell
incrementar :: Eq a => Conta -> a -> Conta
~~~

Onde `Conta` é o tipo do seu contador `(nao precisa definir esse tipo usando o data)`. A funcao recebe um contador, um item e incrementa no contador a contagem do item, retornando o contador atualizado.

# 2) letra mais comum
usando o `incrementar` acima, escreva a função

~~~Haskell
letra_mais_comum :: [Char] -> Char
~~~

que recebe um string e retorna a letra mais comum no string. Use as seguintes regras

- letras sao apenas a..z (sem digitos, sem pontuação e sem brancos)
- letras maiusculas e minusculas são consideradas a mesma letra
- voce precisa usar a funçao incrementar acima

Assim
~~~Haskell
letra_mais_comum  "77,88 a!? abc BB 8 8    8  fyt" 
==> b  -- (ou B)
~~~

- b e B sao a mesma letra
- branco e 8 que aparecem mais vezes no string não são considerados letras.
Voce pode utilizar todas as funções do `Data.List` e `Data.Map.Strict`. Relevantes para o problema sao funcoes como sort e suas variaçõoes ou maximum e suas variacoes.

Para usar o sort, por exemplo, use
~~~
import Data.List sort
~~~
no comeco do seu programa.

Como sempre, voce pode definir quaisquer funçoes auxiliares que voce quiser.

A correção da 2a parte letra_mais_comum nao vai depender se sua implementacao do incrementar esta certa ou não.Ou seja, eu vou considerar que o incrementar funciona corretamente na correcao da parte 2.

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
  <summary>Projeto 4 - Haskell - Dijkstra </summary>
  
  # Projeto 4
  
<b> Data: 25/9 (ate meia noite) </b>

Pode ser feito individualmente ou em grupos de até 2 pessoas.

- se for feito em duplas, escreva um comentário no topo do arquivo com o nome e RA dos membros do grupo

- se for feito em duplas, apenas um dos membros do grupo submete.

<br>

# 1 Uma versão simplificada do Dijkstra

Para um gráfico não direcionado, e dado um vértice de origem e um de destino, usar o algoritmo de Dykstra para calcular a menor distancia entre a origem e o destino.

O gráfico será dado como uma lista de triplas `[("ab1","b67",10.4),("ab1","cc",11.2)...]` onde os 2 primeiros componentes da tupla são os nomes (um string) dos vértices, e o terceiro componente a distancia entre os 2 vértices. **Note que se a distancia entre os vértices “ab1” e “b67” é 10.4 então a distancia entre “b67” e “ab1” também é de 10.4 mas a lista não vai conter uma entrada ( "b67",  "ab1", 10,4).
**

O problema é uma versão simplificada do `Dykstra`. Na versão “normal” do Dijkstra queremos não só a menor distancia entre 2 vértices mas também o caminho com essa menor distancia. Mas para esse problema não precisa computar o caminho, apenas a menor distancia.

Você pode assumir que o grafo é conectado, ou seja existe um caminho entre quaisquer 2 nós do grafo.

Você não precisa usar estruturas de dados complexas como um “priority queue” que sao `O(1)` para achar o minimo. Pode fazer uma busca linear para achar o mínimo e usar as funções já disponíveis no Haskell.

A função principal deve se chamar `proj4` e ela recebe 3 argumentos, o grafo no formato especificado, o nó origem e o nó destino.

Vc pode usar as bibliotecas padrão do haskell.

A pagina do Dykstra na wikipedia https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm tem uma animaçao do algoritmo para um grafo simples. Aquele grafo corresponde ao dado abaixo.

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
<br><br>

# 2 grafo não necessariamente conectado
Esta parte do projeto vale apenas 1/4 da nota total do projeto.

Na parte anterior assuminos que o grafo era conectado. No miolo do Dijkstra, ha o passo onde precisamos achar a aresta de menor tamanho que liga um vertice já visitado com um não visitado. Se o grafo é conectado havera sempre pelo menos 1 aresta entre os 2 conjuntos de nós. Se o grafo não é conectado, pode não haver nenhuma aresta ligando esses 2 conjuntos.

Agora o grafo não será necessariamente conectado e sua funcão deve retornar alguma indicacão que não existe um caminho que liga o vertice origem do vertice destino. Voce deve retornar um `Maybe distancia-minima`: um `Just x` indica que a distancia minima é x e o `Nothing` indica que não há um caminho.

Sem ter ainda implementado esse problema, eu acho que é suficiente no passo acima, vc pode retornar um `Maybe` aresta. Eu acho que se não há essa aresta isso vai acabar contaminando as computações subsequentes em `Nothing`. Infelizmente vc precisará mudar a sintaxe do programa, para usar o do e utilizar a monada de forma conveniente.
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
  <summary>Projeto 5 - Prolog - Compressão e Descompressão de Listas</summary>

<b> Data: 7/10 (ate meia noite) </b>

# Projeto 5

## Compressão e descompressão de listas
dada a lista

`[4,4,4,7,7,4,4,0,3,7,7,7,7]`
vamos definir uma lista comprimida cujos elementos são listas de 2 elementos [item, quantidade] onde quantidade é o número de vezes que o item aparece sequenciamente na lista. Assim, a compressão dessa lista seria:

`[[4,3],[7,2],[4,2],[0,1],[3,1],[7,4]]`
1) Implemente o predicado comprime(ListaOriginal, ListaComprimida)

~~~Prolog
  comprime([3,3,3,4,5,6,5,5,5,5,7], X].
  X =  [[3,3],[4,1],[5,1],[6,1],[5,4],[7,1]]
~~~
<br>

2) Implemente a função descomprime(ListaComprimida, ListaExpandida) que é o inverso de comprime
~~~Prolog
  descomprime([[3,3],[4,1],[5,1],[6,1],[5,4],[7,1]], X).
  X =  [3,3,3,4,5,6,5,5,5,5,7]
~~~

<br>

### Comentário
É possivel que voce so precise escrever um predicado comprime(A,B) que quando dado A computa em B a compressão, e quando dado B (uma lista comprimida) e A é uma variavel sem valor, retorna em A a lista original. Nós ja vimos pelo menos dois predicados que funcionam dessa forma bidirecional o tam (tamanho de uma lista) e o append. Em ambos, nao pensamos explicitamente em implementar o predicado de forma bidirecional. Isso aconteceu sem querer. Isso pode acontecer nesse problema. Eu ainda nao implementei esse predicado mas minha intuição diz que isso pode acontecer. Mesmo com a minha experiencia de Prolog eu nao sei como escrever predicados que deliberadamente funcionem de forma bidirecional mesmo quando isso é possivel. Em suma, implementem o comprime, e testem se ele funciona de forma bidirecional - e assim voce não precisarão implementar o descomprime.

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
  <summary>Projeto 6</summary>
</details>  

<details>
  <summary>Projeto 7</summary>
</details>  
