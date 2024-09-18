{-
###############################################################################
#                 MC346 - PARADIGMAS DE PROGRAMACAO - 2S_2024                 #
#                 PROFo:  JACQUES WAINER                                      #
#                 NOME:   RAONITON ADRIANO DA SILVA                           #
#                 RA:     186291                                              #
###############################################################################
-}

import Data.List
{-
1) incrementar (função auxiliar)
Implemente um contador. Esse contador pode ser implementado como uma lista de tuplas onde cada tupla é no formado (chave, contador). 
Ou o contador pode ser implementado usando um dicionario do Data.Map.Strict

Implemente a funçao:

incrementar :: Eq a => Conta -> a -> Conta
Onde Conta é o tipo do seu contador (nao precisa definir esse tipo usando o data). 
A funcao recebe um contador, um item e incrementa no contador a contagem do item, retornando o contador atualizado.
-}

incrementar :: Eq a => [(a,Int)] -> a -> [(a,Int)]
incrementar list chave = map (\(c,v) -> if c == chave then (c, v+1) else (c,v)) list


{-
2) letra mais comum
usando o incrementar acima, escreva a função

letra_mais_comum :: [Char] -> Char
que recebe um string e retorna a letra mais comum no string. Use as seguintes regras
    letras sao apenas a..z (sem digitos, sem pontuação e sem brancos)
    letras maiusculas e minusculas são consideradas a mesma letra
    voce precisa usar a funçao incrementar acima

Assim:

letra_mais_comum  "77,88 a!? abc BB 8 8    8  fyt" 
=> b  -- (ou B)
-}

-- letra_mais_comum:    recebe uma string e retorna a letra que mais vezes aparece na string
letra_mais_comum :: [Char] -> Char
letra_mais_comum [] = ' '
letra_mais_comum string = 
    let 
        sohLetras = filtTransf string                       -- "AaBb12" -> "aabb"
        lista = map (\x-> (x, 0)) (criaSet sohLetras)       -- Cria uma lista dessa forma: [('a',0)], eleminando as duplicatas que houverem na string 
        listaAtualizada = foldl incrementar lista sohLetras -- ### Aqui a função incrementa eh utilizada
        letMaisComum = if sohLetras == [] then ' ' else 
                        fst (head (reverte (sortOn  snd listaAtualizada))) -- prepara a saida
    in  letMaisComum

-- reverte:     reverte uma lista, idependente do tipo da lista
reverte list = foldr (\x acc -> acc ++ [x]) [] list

-- ehLetra:     verifica se o caracter passado ehLetra
ehLetra c = if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) then True else False

-- minuscula:   transforma as maiusculas em minusculas, caso a letra ja seja minuscula, retorna ela mesma
-- Unicode de 'A' é 65 e de 'a' é 97.
minuscula c = if (c >= 'A' && c <= 'Z') then toEnum(fromEnum c + 32) else c 

-- filtransf:   utiliza as funcoes 'ehLetra' e 'minuscula', primeiro filtra somente as letras e depois mapeia aplicando a funcao minusucla
filtTransf list = map minuscula (filter ehLetra list)

-- criaSet:     remove os elementos duplicados de 'list' e retorna essa nova lista
criaSet list = nub list
