# fx_M



Esse repositório contém funções da Linguagem M, suplemento Power Query utilizado nas ferramentas do Excel e Power BI. 

Para a utilização das funções em M dispobilizadas neste repositório, poderá ser utilizado o código abaixo:

*Obs: Essa técnica poderá ser importante para situações de uso do mesmo código em vários arquivos Excel e Power BI a exemplo da Tabela dCalenario.
Ou seja toda modificação do código no repositório do Git acaba valendo para todos os arquivos que estão conectados a ele.*

## 1. Código M:


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

#### Uso do #shared na Expression.Evaluate:

- [x] Excel

~~~~js 
    Expression.Evaluate(Script.#shared)
~~~~
    
- [ ] Power BI

~~~~js 
    Expression.Evaluate(Script)
~~~~

## 2. Obtendo o Link com Código

Para abrir o link com o formato texto devemos selecionar a opção raw do código

2.1. **Opção do raw**

![RawOption](https://github.com/hrabellodev/fx_M/assets/113308786/33a15454-dc5e-4fb6-89cf-d62215f032cc)

2.2. **Tela com código**

![Code_Link](https://github.com/hrabellodev/fx_M/assets/113308786/7b5dfc6c-8b5e-4879-839f-d282defc71bd)

## 3. Exemplo:

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

3.1 Retorno

![image](https://github.com/hrabellodev/fx_M/assets/113308786/87c1e906-aa73-4758-9f43-751024a07055)

