let
    funcao = 

    // ====================================== COMEÇA FUNÇÃO ======================================

(
    Sections, // informar -->> #sections[Section1]
    optional ListaTabelasDesconsiderar as list
) =>

let

    //  Lista da Função e Tabela Retorno da Função a ser desconsiderada
    ConsultaAtual = {"fxVerificaErro_Resumo","fxVerificaErro"},

    //  Converter Registro da Seção em Tabela
    SectionsParaTabela = Record.ToTable(Sections),

    // Retirar as Tabelas a serem desonconsideradas
    TirarTabelaAtual = Table.SelectRows(
        SectionsParaTabela, 
        each not 
        List.Contains(
            if ListaTabelasDesconsiderar = null 
            then ConsultaAtual 
            else ListaTabelasDesconsiderar & ConsultaAtual, 
            [Name]
        )
    ),

    // ---------- Erros Tipo 1 - Para cada Linha da Tabela
    
    ErrosRemovidos = Table.RemoveRowsWithErrors(TirarTabelaAtual, {"Value"}), 

    SomenteTabelas = Table.SelectRows(ErrosRemovidos, each ([Value] is table)), 

    TentaExecutarPrimeiraLinhaTabela = Table.AddColumn(
        SomenteTabelas, 
        "ErroLinhasTabela", 
        each 
            let
                linhas_erros = Table.SelectRowsWithErrors([Value]), 
                primeira_linha = Table.FirstN(linhas_erros, 1), 
                despivotar = Table.UnpivotOtherColumns(primeira_linha, {}, "Atributo", "_Valor_"), 
                linhas_erros2 = Table.SelectRowsWithErrors(despivotar)[_Valor_]
            in
                if List.IsEmpty(linhas_erros2) then null else linhas_erros2{0}
    ), 

    SeErroEntaoMostra = Table.AddColumn(
        TentaExecutarPrimeiraLinhaTabela, 
        "RegistroErro_1", 
        each try [ErroLinhasTabela]
    ), 

    ErroDetalhes = Table.ExpandRecordColumn(
        SeErroEntaoMostra, 
        "RegistroErro_1", 
        {"Error"}, 
        {"Value.1"}
    ), 

    ErroExpandido = Table.ExpandRecordColumn(
        ErroDetalhes, 
        "Value.1", 
        {"Message", "Detail"}, 
        {"Message", "Detail"}
    ), 

    DetalhesFormado = Table.TransformColumns(
        ErroExpandido, 
        {
            {
                "Detail",
                each 
                    "Primeira Linha com erro => " & Text.Combine(Record.ToList(_), " | "), 
                type text
            }
        }
    ), 

    SomenteLinhasComErro = Table.SelectRows(DetalhesFormado, each ([Message] <> null)), 

    SomenteColunasSelecionadas = Table.SelectColumns(
        SomenteLinhasComErro, 
        {"Name", "Detail", "Message"}
    ),

    _ErrosTipo1_ = Table.ReplaceErrorValues(SomenteColunasSelecionadas, {{"Detail", null}}),

    // ---------- Erros Tipo 1


    // ---------- Erros Tipo 2 - Para a Tabela Diretamente

    ErrosTipo2 = Table.SelectRowsWithErrors(TirarTabelaAtual, {"Value"}),
    RegistroErro_2 = Table.AddColumn(ErrosTipo2, "RegistroErro_2", each try [Value]),
    RegistroErro_2_Expandido = Table.ExpandRecordColumn(RegistroErro_2, "RegistroErro_2", {"Error"}, {"Error"}),
    ErrorExpandido = Table.ExpandRecordColumn(RegistroErro_2_Expandido, "Error", {"Message", "Detail"}, {"Message", "Detail"}),
    _ErrosTipo2_ = Table.SelectColumns(ErrorExpandido,{"Name", "Detail", "Message"}),

    // ---------- Erros Tipo 2

    // Tabelas Consolidadas
    TabelasCombinadas = Table.Combine({_ErrosTipo1_, _ErrosTipo2_})

in
    TabelasCombinadas

    // ====================================== TERMINOU FUNÇÃO ======================================


    // ====================================== METADADOS DA FUNÇÃO ==================================

    , metadados = [
        Documentation.Name  = "fxVerificaErro",
        Documentation.Description = "Essa função será útil para criar uma tabela nomeada 'fxVerificaErro_Resumo' com resumo de todos os erros na seção do Power Query",
        Documentation.Examples = {

            // exemplo 01
            [
                Description = "Exemplo 01",
                Code = "fxVerificaErro(#sections[Section1], null)",
                Result = "
                ================ IMPORTANTE ================

                Ao Invocar a Função fxVerificaErro deverá ser alterado o nome da Consulta Invocada para 'fxVerificaErro_Resumo', dessa forma a tabela será desconsiderada da seção, caso contrário haverá estouro de pilha ou looping eterno.
                
                Name        | Detail   |   Message
                Consulta1   | Record   |   Não conseguimos aplicar o operador * aos tipos Number e Text.
                
                "
            ]
        }
    ]

in

    Value.ReplaceType(
        funcao,
        Value.ReplaceMetadata(
            Value.Type(funcao),metadados
        )
    )
