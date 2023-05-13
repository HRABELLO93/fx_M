# fx_M
Esse repositório contém funções da Linguagem M do suplemento Power Query utilizadas nas ferramentas do Excel e Power BI. 

1. Para a utilização das funções em M dispobilizadas neste repositório, poderá ser utilizada a consulta de exemplo abaixo:

### Código M:
```js
let
    // Informar Link
    
    link = "Informe seu Link Aqui",
    
    ConteudoGit = Web.Contents(link),

    // lendo o binario do conteudo
    Script = Text.FromBinary(ConteudoGit),

    // executando
    Run = Expression.Evaluate(Script)

in
    Run
```

### Exemplo:

Para abrir o link com o formato texto devemos selecionar a opção raw do código

![image](https://github.com/hrabellodev/fx_M/assets/113308786/33a15454-dc5e-4fb6-89cf-d62215f032cc)

abrindo a tela com o código em texto:

![image](https://github.com/hrabellodev/fx_M/assets/113308786/7b5dfc6c-8b5e-4879-839f-d282defc71bd)


```js
let
    // Informar Link
    
    link = "https://raw.githubusercontent.com/hrabellodev/fx_M/main/fxVerificaErro.txt",
    
    ConteudoGit = Web.Contents(link),

    // lendo o binario do conteudo
    Script = Text.FromBinary(ConteudoGit),

    // executando
    Run = Expression.Evaluate(Script)

in
    Run
```
