# fx_M
Esse repositório contém funções da Linguagem M do suplemento Power Query utilizadas nas ferramentas do Excel e Power BI. 

1. Para a utilização das funções em M dispobilizadas neste repositório, deverá ser utilizada a consulta de exemplo abaixo:

### Código M:
```js
let
    // Informar Link
    
    link = "Informe seu Link Aqui"
    
    ConteudoGit = Web.Contents(link),

    // lendo o binario do conteudo
    Script = Text.FromBinary(ConteudoGit),

    // executando
    Run = Expression.Evaluate(Script)

in
    Run
```

### Exemplo:

```js
let
    // Informar Link
    
    link = "https://raw.githubusercontent.com/hrabellodev/fx_M/main/fxVerificaErro.txt"
    
    ConteudoGit = Web.Contents(link),

    // lendo o binario do conteudo
    Script = Text.FromBinary(ConteudoGit),

    // executando
    Run = Expression.Evaluate(Script)

in
    Run
```
