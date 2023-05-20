let
  //Altere o ano conforme necessidade
  DataMin = #date(2016, 01, 01),
  DataMax = Date.EndOfYear(Date.From(DateTime.LocalNow())),
  QtdDias = Duration.Days(DataMax - DataMin) + 1,
  ListaDatas = List.Dates(DataMin, QtdDias, #duration(1, 0, 0, 0)),
  ConvertidoTabela = Table.FromList(
    ListaDatas,
    Splitter.SplitByNothing(),
    {"Data"},
    null,
    ExtraValues.Error
  ),
  TipoAlterado = Table.TransformColumnTypes(ConvertidoTabela, {{"Data", type date}}),
  Ano = Table.AddColumn(TipoAlterado, "Ano", each Date.Year([Data]), Int64.Type),
  NomeMes = Table.AddColumn(Ano, "Nome do Mês", each Text.Proper(Date.MonthName([Data])), type text),
  NomeMesAbreviado = Table.AddColumn(
    NomeMes,
    "Nome do Mês Abreviado",
    each Text.Start([Nome do Mês], 3),
    type text
  ),
  InicioMes = Table.AddColumn(
    NomeMesAbreviado,
    "Início do Mês",
    each Date.StartOfMonth([Data]),
    type date
  ),
  Mes = Table.AddColumn(InicioMes, "Mês", each Date.Month([Data]), Int64.Type),
  Dia = Table.AddColumn(Mes, "Dia", each Date.Day([Data]), Int64.Type),
  NumeroTrimestre = Table.AddColumn(
    Dia,
    "Nº Trimestre",
    each Date.QuarterOfYear([Data]),
    Int64.Type
  ),
  Trimestre = Table.AddColumn(
    NumeroTrimestre,
    "Trimestre",
    each "Q" & Text.From(Date.QuarterOfYear([Data])),
    type text
  ),
  Bimestre = Table.AddColumn(
    Trimestre,
    "Bimestre",
    each Number.RoundUp(Date.Month([Data]) / 2, 0),
    type number
  ),
  Semestre = Table.AddColumn(Bimestre, "Semetre", each Number.RoundUp(Date.Month([Data]) / 6, 0)),
  MesAno = Table.AddColumn(
    Semestre,
    "MesAno",
    each Text.From(Date.Month([Data])) & "" & Text.From(Date.Year([Data])),
    type text
  ),
  Periodo = Table.AddColumn(
    MesAno,
    "Período",
    each //Regra Anterior a 17/07/2023 considerando do Inicio até a Data Atual                                                                                                                                                                                                           
      /*if Number.From(
        Text.From(Date.Month([Data])) & Text.PadStart(Text.From(Date.Day([Data])), 2, "0")
      )
        <= Number.From(
          Text.From(Date.Month(DataAtual))
            & Text.PadStart(Text.From(Date.Day(DataAtual)), 2, "0")
        )
      then
        "YTD"
      else
        null
    */
      //Nova regra definida em reunião no dia 17/07/2023                                                  
      //Considera até o mês anterior a data Atual, Mês fechado

        if [Mês] <= Date.Month(Date.AddMonths(DataAtual, - 1)) then
          "YTD"
        //Considera do inicio do Mês atual até a Data Atual
      else if [Mês] = Date.Month(DataAtual) then
          "MTD"
        else
          null
  ),
  PeriodoAno = Table.AddColumn(
    Periodo,
    "Periodo Ano",
    each if Date.IsInCurrentYear([Data]) then "Ano Atual" else Text.From([Ano]),
    type text
  )
in
  PeriodoAno
