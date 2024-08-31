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

<details>
  <summary>Projeto 3</summary>
</details>  

<details>
  <summary>Projeto 4</summary>
</details>  

<details>
  <summary>Projeto 5</summary>
</details>  

<details>
  <summary>Projeto 6</summary>
</details>  

<details>
  <summary>Projeto 7</summary>
</details>  
