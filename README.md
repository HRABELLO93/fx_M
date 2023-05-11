# fx_M
Esse repositório contém funções da Linguagem M do suplemento Power Queryutilizadas nas ferramentas do Excel e Power BI. 

1. Para utilização das funções em M dispobilizadas no repositório do Github deverá ser utilizada a consulta de exemplo abaixo:

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
    
    link = "https://github.com/HRABELLO93/fx_M/blob/main/fxVerificaErro"
    
    ConteudoGit = Web.Contents(link),

    // lendo o binario do conteudo
    Script = Text.FromBinary(ConteudoGit),

    // executando
    Run = Expression.Evaluate(Script)

in
    Run
```
