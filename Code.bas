Attribute VB_Name = "Module1"
Sub ResetAllWorksheet():

Dim Current As Worksheet

Application.ScreenUpdating = False

For Each Current In Worksheets

    Current.Select
    
    Call Reset

Next

    Application.ScreenUpdating = True

End Sub

'Clear data from column K to z
Sub Reset():

Range("K:Z").ClearContents

Range("K:Z").ClearFormats

End Sub

Sub RunMacroForAllWorksheet():

Dim Current As Worksheet

Application.ScreenUpdating = False

For Each Current In Worksheets

    Current.Select
    
    Call Run

Next

    Application.ScreenUpdating = True

End Sub

'Primary Sub to run the below subs
Sub Run():
    
    Call TickerSymbol_StockVolume 'Run Sub TickerSymbol_StockVolume() to create the summary table
    Call YearChange_PercentChange 'Run Sub YearChange_PercentChange() to calculate yearly change and percent change
    Call FormatYearlyChange 'Run Sub FormatYearlyChange{} to format Yearly Change column in SummaryTable
    Call ComparingTable 'Run Sub ComparingTable ()
    Call AutoFit 'Format all columns and rows (K - Z) to auto fit
End Sub

Sub AutoFit():
    Cells.EntireColumn.AutoFit
End Sub

Sub TickerSymbol_StockVolume():

'Create headers for SummaryTable
Cells(1, 11).Value = "Ticker Symbol"
Cells(1, 12).Value = "Yearly Change"
Cells(1, 13).Value = "Percent Change"
Cells(1, 14).Value = "Total Stock Volume"

Dim SummaryTableRow As Integer 'Create SummaryTableRow as Interger

SummaryTableRow = 2 'Assign 1st row of SummaryTableTable = 2

Dim TickerSymbol As String 'Create TickerSymbol variable as string

TickerSymbol = Cells(2, 1).Value 'Assign 1st <Ticker> Value to variable TickeSymbol

Cells(SummaryTableRow, 11).Value = TickerSymbol 'Show TickerSymbol with assigned value above in cells(2,11)

Dim TotalStockVolume As Double 'Create TotalStockVolume variable as Double

TotalStockVolume = Cells(2, 7) 'Assign 0  to variable TickeSymbol

Cells(SummaryTableRow, 14).Value = TotalStockVolume

Dim LastRow As Long 'Assigned LastRow variable as Long

LastRow = Range("A" & Rows.Count).End(xlUp).Row 'Find LastRow value

For i = 2 To LastRow 'Start from row 2 to LastRow
    If Cells(i + 1, 1).Value <> Cells(i, 1).Value Then
    
        TickerSymbol = Cells(i + 1, 1).Value 'Assign the new value to TickerSymbol
        
        TotalStockVolume = Cells(i + 1, 7).Value 'Assign the new value to TotalStockVolume
        
        SummaryTableRow = SummaryTableRow + 1 'Move the SummaryTableRow down 1
        
        Cells(SummaryTableRow, 11).Value = TickerSymbol 'Show the new TickerSymbol in SummaryTableRow
        
        Cells(SummaryTableRow, 14).Value = TotalStockVolume 'Show the new TotalStockVolume in SummaryTableRow
           
    Else
    
        TotalStockVolume = TotalStockVolume + Cells(i + 1, 7).Value
        
        Cells(SummaryTableRow, 14).Value = Str(TotalStockVolume)
        
    End If
    
Next i

End Sub


Sub YearChange_PercentChange():

Dim i, LastRow As Long  'Assigned LastRow variable as Long

LastRow = Range("A" & Rows.Count).End(xlUp).Row 'Find LastRow value

Dim SummaryTableRow As Double 'Create SummaryTableRow as Double

SummaryTableRow = 2 'Assign 1st row of SummaryTableTable = 2

Dim LastDate, FirstDate, FirstDateOpen, LastDateClose, YearlyChange, PercentChange As Double

FirstDate = Cells(2, 2).Value

LastDate = Cells(2, 2).Value

Dim SummaryTable_TickerSymbol As String

SummaryTable_TickerSymbol = Cells(SummaryTableRow, 11).Value


For i = 2 To LastRow

    If Cells(i, 1).Value = SummaryTable_TickerSymbol Then
    
        If Cells(i, 2).Value <= FirstDate Then
            
            FirstDateOpen = Cells(i, 3).Value
            
            ElseIf Cells(i, 2).Value > LastDate Then
            
            LastDate = Cells(i, 2).Value
            
            LastDateClose = Cells(i, 6).Value
            
            YearlyChange = LastDateClose - FirstDateOpen
            
            Cells(SummaryTableRow, 12).Value = YearlyChange
            
            PercentChange = YearlyChange / FirstDateOpen
            
            Cells(SummaryTableRow, 13).Value = FormatPercent(PercentChange)
            
            End If
            
        Else
  
        SummaryTableRow = SummaryTableRow + 1
        
        SummaryTable_TickerSymbol = Cells(SummaryTableRow, 11).Value
        
        FirstDate = Cells(i, 2).Value
    
        LastDate = Cells(i, 2).Value
        
        FirstDateOpen = Cells(i, 3).Value
        
        LastDateClose = Cells(i, 6).Value
        
        YearlyChange = 0
        
        PercentChange = 0
        
    End If
    
Next i

End Sub

Sub FormatYearlyChange():

Dim i, SummaryTable_LastRow As Long  'Assigned LastRow variable as Long

SummaryTable_LastRow = Range("L" & Rows.Count).End(xlUp).Row 'Find LastRow value

For i = 2 To SummaryTable_LastRow

    If Cells(i, 12).Value < 0 Then
    
    Cells(i, 12).Interior.ColorIndex = 3
    
    Else
    
    Cells(i, 12).Interior.ColorIndex = 4
    
End If

Next i

End Sub

Sub ComparingTable():

'Create headers for columns and rows for ComparingTable
Cells(2, 17).Value = "Greatest % Increase"
Cells(3, 17).Value = "Greatest % Decrease"
Cells(4, 17).Value = "Greatest Total Volume"
Cells(1, 18).Value = "Ticker"
Cells(1, 19).Value = "Value"

Dim i, SummaryTable_LastRow As Long

i = 2

SummaryTable_LastRow = Range("L" & Rows.Count).End(xlUp).Row 'Find LastRow value in SummaryTable

Dim GreatestIncrease, GreatestDecrease, GreatestTotalVolume As Double

GreatestIncrease = Cells(2, 13).Value

GreatestDecrease = Cells(2, 13).Value

GreatestTotalVolume = Cells(2, 14).Value

For i = 2 To SummaryTable_LastRow

    If Cells(i + 1, 13).Value > GreatestIncrease Then
    
    GreatestIncrease = Cells(i + 1, 13).Value
    
    Range("R2").Value = Cells(i + 1, 11).Value 'Show Ticker with Greatest%Increase
    
    Range("S2").Value = FormatPercent(GreatestIncrease) 'Show Ticker with Greatest%Increase
    
    ElseIf Cells(i + 1, 13).Value < GreatestDecrease Then
    
    GreatestDecrease = Cells(i + 1, 13).Value
    
    Range("R3").Value = Cells(i + 1, 11).Value 'Show Ticker with Greatest%Decrease
    
    Range("S3").Value = FormatPercent(GreatestDecrease) 'Show Ticker with Greatest%Decrease
    
    End If
    
    If Cells(i + 1, 14).Value > GreatestTotalVolume Then
    
    GreatestTotalVolume = Cells(i + 1, 14).Value
    
    Range("R4").Value = Cells(i + 1, 11).Value
    
    Range("S4").Value = Str(GreatestTotalVolume)
    
    End If
    
Next i

End Sub



