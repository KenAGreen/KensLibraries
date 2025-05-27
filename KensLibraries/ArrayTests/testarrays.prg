#IF 0                         TestArrays.prg

  Purpose:  Test ..\Karrays.prg

Revisions:  May 12, 2025 - Ken Green - Original

*****************************************************************************
#ENDIF

SET PROCEDURE TO ..\KStrings, ..\Karrays

* Setup for printing to KArraysResults.txt
SET PRINTER TO
IF FILE('KArraysResults.txt')
    ERASE KArraysResults.txt
ENDIF

SET DEVICE TO PRINT
SET PRINTER TO KArraysResults.txt
SET PRINTER ON
SET CONSOLE ON

?? SPACE(26) + 'Testing KArrays.prg Library'
?

?
? 'Object Tests:'
? '-------------'

* Init([nCols]) - Initialize an array object
*     Parameters: nCols (REQUIRED for multi-dimensional arrays)
*       Note - nRows will be 0 after Init()
oRATest = CREATEOBJECT('ArrayObj', 4)
cStr = 'Init() Error: '
bIsGood = .F.
DO CASE     && Tests
CASE VARTYPE(oRATest) <> 'O'
    ? cStr +  'VARTYPE(oRATest) = ' + VARTYPE(oRATest)
CASE oRATest.nRows <> 0
    ? cStr +  'oRATest.nRows = ' + TRANSFORM(oRATest.nRows)
CASE oRATest.nCols <> 4
    ? cStr +  'oRATest.nCols = ' + TRANSFORM(oRATest.nCols)
CASE ALEN(oRATest.aRA, 1) <> 1
    ? cStr +  'ALEN(oRATest.aRA, 1) = ' + TRANSFORM(ALEN(oRATest.aRA, 1))
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.Init() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.Init() Failed!'
    RETURN
ENDIF

* IsEmpty() - Returns .T. if the array has no rows
bIsEmpty = oRATest.IsEmpty()
cStr = 'IsEmpty() Error: '
IF bIsEmpty
    ? 'ArrayObj.IsEmpty() is OK!'
ELSE
    ? cStr +  'ArrayObj.IsEmpty() Failed!'
    RETURN
ENDIF

* AddRow(xVal1 [,xVal2] [,xVal3]...) - Add a row to the array
*     Parameters: xVal1 [,xVal2] [,xVal3] [...to xVal20]
*     Returns: the new row number
*     Note - xValX values are ignored if they exceed the number of columns
oRATest.AddRow(1, 2, 3, 4)
cStr = 'AddRow() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.nRows <> 1
    ? cStr +  'oRATest.nRows = ' + TRANSFORM(oRATest.nRows)
CASE oRATest.aRA[1,1] <> 1
    ? cStr +  'oRATest.aRA[1,1] = ' + TRANSFORM(oRATest.aRA[1,1])
CASE oRATest.aRA[1,2] <> 2
    ? cStr +  'oRATest.aRA[1,2] = ' + TRANSFORM(oRATest.aRA[1,2])
CASE oRATest.aRA[1,3] <> 3
    ? cStr +  'oRATest.aRA[1,3] = ' + TRANSFORM(oRATest.aRA[1,3])
CASE oRATest.aRA[1,4] <> 4
    ? cStr +  'oRATest.aRA[1,4] = ' + TRANSFORM(oRATest.aRA[1,4])
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.AddRow() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.AddRow() Failed!'
    RETURN
ENDIF

* InsertRow([nBeforeRow]) - Add a row to the array (resize it larger)
*     Parameters: [nBeforeRow]
*     Returns: The new number of rows in the array
oRATest.InsertRow(1)
WITH oRATest
    .aRA[1,1] = 5
    .aRA[1,2] = 6
    .aRA[1,3] = 7
    .aRA[1,4] = 8
ENDWITH
cStr = 'InsertRow() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.nRows <> 2
    ? cStr +  'oRATest.nRows = ' + TRANSFORM(oRATest.nRows)
CASE oRATest.aRA[1,1] <> 5
    ? cStr +  'oRATest.aRA[1,1] = ' + TRANSFORM(oRATest.aRA[1,1])
CASE oRATest.aRA[1,2] <> 6
    ? cStr +  'oRATest.aRA[1,2] = ' + TRANSFORM(oRATest.aRA[1,2])
CASE oRATest.aRA[1,3] <> 7
    ? cStr +  'oRATest.aRA[1,3] = ' + TRANSFORM(oRATest.aRA[1,3])
CASE oRATest.aRA[1,4] <> 8
    ? cStr +  'oRATest.aRA[1,4] = ' + TRANSFORM(oRATest.aRA[1,4])
CASE oRATest.aRA[2,1] <> 1
    ? cStr +  'oRATest.aRA[2,1] = ' + TRANSFORM(oRATest.aRA[2,1])
CASE oRATest.aRA[2,2] <> 2
    ? cStr +  'oRATest.aRA[2,2] = ' + TRANSFORM(oRATest.aRA[2,2])
CASE oRATest.aRA[2,3] <> 3
    ? cStr +  'oRATest.aRA[2,3] = ' + TRANSFORM(oRATest.aRA[2,3])
CASE oRATest.aRA[2,4] <> 4
    ? cStr +  'oRATest.aRA[2,4] = ' + TRANSFORM(oRATest.aRA[2,4])
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.InsertRow() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.InsertRow() Failed!'
    RETURN
ENDIF

* AddBlankRows(nRowsWanted) - Add many rows to the array by reDIMENSIONing
*     Parameters: nRowsWanted
*     Returns: the new row count
oRATest.AddBlankRows(2)
cStr = 'AddBlankRows() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.nRows <> 4
    ? cStr +  'oRATest.nRows = ' + TRANSFORM(oRATest.nRows)
CASE NOT oRATest.aRA[3,1] == ''
    ? cStr +  'oRATest.aRA[3,1] = ' + oRATest.aRA[3,1]
CASE NOT oRATest.aRA[3,2] == ''
    ? cStr +  'oRATest.aRA[3,2] = ' + oRATest.aRA[3,2]
CASE NOT oRATest.aRA[3,3] == ''
    ? cStr +  'oRATest.aRA[3,3] = ' + oRATest.aRA[3,3]
CASE NOT oRATest.aRA[3,4] == ''
    ? cStr +  'oRATest.aRA[3,4] = ' + oRATest.aRA[3,4]
CASE NOT oRATest.aRA[4,1] == ''
    ? cStr +  'oRATest.aRA[4,1] = ' + oRATest.aRA[4,1]
CASE NOT oRATest.aRA[4,2] == ''
    ? cStr +  'oRATest.aRA[4,2] = ' + oRATest.aRA[4,2]
CASE NOT oRATest.aRA[4,3] == ''
    ? cStr +  'oRATest.aRA[4,3] = ' + oRATest.aRA[4,3]
CASE NOT oRATest.aRA[4,4] == ''
    ? cStr +  'oRATest.aRA[4,4] = ' + oRATest.aRA[4,4]
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.InsertRow() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.InsertRow() Failed!'
    RETURN
ENDIF

* DeleteRow(nRowNum) - Remove a row to the array (re-size it smaller)
*     Parameters: nRowNum
*     Returns: The new number of rows in the array
oRATest.DeleteRow(2)
cStr = 'DeleteRow() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.nRows <> 3
    ? cStr +  'oRATest.nRows = ' + TRANSFORM(oRATest.nRows)
CASE oRATest.aRA[1,1] <> 5
    ? cStr +  'oRATest.aRA[1,1] = ' + TRANSFORM(oRATest.aRA[1,1])
CASE oRATest.aRA[1,2] <> 6
    ? cStr +  'oRATest.aRA[1,2] = ' + TRANSFORM(oRATest.aRA[1,2])
CASE oRATest.aRA[1,3] <> 7
    ? cStr +  'oRATest.aRA[1,3] = ' + TRANSFORM(oRATest.aRA[1,3])
CASE oRATest.aRA[1,4] <> 8
    ? cStr +  'oRATest.aRA[1,4] = ' + TRANSFORM(oRATest.aRA[1,4])
CASE NOT oRATest.aRA[3,1]  == ''
    ? cStr +  'oRATest.aRA[3,1] = ' + TRANSFORM(oRATest.aRA[3,1])
CASE NOT oRATest.aRA[3,2]  == ''
    ? cStr +  'oRATest.aRA[3,2] = ' + TRANSFORM(oRATest.aRA[3,2])
CASE NOT oRATest.aRA[3,3]  == ''
    ? cStr +  'oRATest.aRA[3,3] = ' + TRANSFORM(oRATest.aRA[3,3])
CASE NOT oRATest.aRA[3,4]  == ''
    ? cStr +  'oRATest.aRA[3,4] = ' + TRANSFORM(oRATest.aRA[3,4])
OTHERWISE
    ? 'ArrayObj.DeleteRow() is OK!'
    bIsGood = .T.
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.DeleteRow() Failed!'
    RETURN
ENDIF

* DeleteRemainingRows() - Remove rows from the bottom of the array
*     Parameters: nRowCount
*     Returns: The new number of rows in the array
oRATest.DeleteRemainingRows(1)
cStr = 'DeleteRemainingRows() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.nRows <> 2
    ? cStr +  'oRATest.nRows = ' + TRANSFORM(oRATest.nRows)
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.DeleteRemainingRows() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.DeleteRemainingRows() Failed!'
    RETURN
ENDIF

* InsertCols(nNumNewCols) - Add columns to the array (re-size it larger)
*     Parameters: nNumNewCols
*     Returns: The new number of columns in the array
oRATest.InsertCols(1)
cStr = 'InsertCols() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.nCols <> 5
    ? cStr +  'oRATest.nCols = ' + TRANSFORM(oRATest.nCols)
CASE NOT oRATest.aRA[1,5] == ''
    ? cStr +  'oRATest.aRA[3,4] = ' + oRATest.aRA[3,4]
CASE NOT oRATest.aRA[2,5] == ''
    ? cStr +  'oRATest.aRA[4,1] = ' + oRATest.aRA[4,1]
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.InsertCols() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.InsertCols() Failed!'
    RETURN
ENDIF

* DeleteCol(nCol2Remove) - Delete a column from the array (re-size it smaller)
*     Parameters: nCol2Remove
*     Returns: The new number of columns in the array
oRATest.DeleteCol(5)
cStr = 'DeleteCol() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.nCols <> 4
    ? cStr +  'oRATest.nCols = ' + TRANSFORM(oRATest.nCols)
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.DeleteCol() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.DeleteCol() Failed!'
    RETURN
ENDIF

* Update the empty rows in row 2
WITH oRATest
    .aRA[2,1] = 1
    .aRA[2,2] = 2
    .aRA[2,3] = 3
    .aRA[2,4] = 4
ENDWITH

* Sort([nSortCol[, bDescending[, bCaseInSensitive]]]) - Sort the array
*   Parameters: [nSortCol,] [bDescending,]  [, bCaseInSensitive]
*   Returns: nothing, but array is sorted
oRATest.Sort(3)
cStr = 'Sort() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.aRA[1,3] <> 3
    ? cStr +  'oRATest.aRA[1,3] = ' + oRATest.aRA[1,3]
CASE oRATest.aRA[2,3] <> 7
    ? cStr +  'oRATest.aRA[2,3] = ' + oRATest.aRA[2,3]
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.Sort() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.Sort() Failed!'
    RETURN
ENDIF

* Change cols 1-3 for date sorting
WITH oRATest
    .aRA[1,1] = '07'
    .aRA[1,2] = '04'
    .aRA[1,3] = '2025'
    .aRA[2,1] = '12'
    .aRA[2,2] = '25'
    .aRA[2,3] = '2024'
ENDWITH

* MultiColSort(nCol1, nCol2...[bDescending,] [, bCaseInSensitive]) - Sort the array by multiple columns
*   Parameters: nCol1, nCol2 [, nCol3] [, nCol4] [, nCol5,] [bDescending,]
*                 [, bCaseInSensitive]
*   Returns: nothing, but array is sorted
oRATest.MultiColSort(3, 2, 1)
cStr = 'MultiColSort() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.aRA[1,1] <> '12'
    ? cStr +  'oRATest.aRA[1,1] = ' + oRATest.aRA[1,1]
CASE oRATest.aRA[1,2] <> '25'
    ? cStr +  'oRATest.aRA[1,2] = ' + oRATest.aRA[1,2]
CASE oRATest.aRA[1,3] <> '2024'
    ? cStr +  'oRATest.aRA[1,3] = ' + oRATest.aRA[1,3]
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.MultiColSort() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.MultiColSort() Failed!'
    RETURN
ENDIF

* Add another row and some text for new column 4
WITH oRATest
    .InsertCols(1)
    .AddRow('06', '06', '2020', 'Johnny')
    .aRA[1,4] = 'new year'
    .aRA[2,4] = 'CHRISTMAS'
ENDWITH

* Locate() - Case-Insensitive look thru a non-ordered array for a value
*    Parameters: xLookFor[, nSrchCol[, bExactOn]]
*    Returns: Row found matching xLookFor (0 if not found)
nRow = oRATest.Locate('Johnny', 4, .T.)
cStr = 'Locate() Error: '
bIsGood = .F.
DO CASE
CASE nRow <> 3
    ? cStr +  'nRow  = ' + TRANSFORM(nRow)
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.Locate() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.Locate() Failed!'
    RETURN
ENDIF

* Sort the array by name ([nSortCol[, bDescending[, bCaseInSensitive]]])
oRATest.Sort(4, .F., .T.)

* Seek(xLookFor[, nSrchCol]) - Look through an ordered array for a passed value
*     Parameters: xLookFor[, nSrchCol]
*     Returns: Row found matching xLookFor (0 if not found)
*              Object.nNearRow is set if xLookFor is not found and array
*                 contains a row with a larger value
nRow = oRATest.Seek('NEW', 4)
cStr = 'Seek() Error: '
bIsGood = .F.
DO CASE
CASE nRow <> 3
    ? cStr +  'nRow  = ' + TRANSFORM(nRow)
CASE oRATest.nNearRow <> 0      && 0 because we got an exact match
    ? cStr +  '.nNearRow  = ' + TRANSFORM(oRATest.nNearRow)
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.Seek() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.Seek() Failed!'
    RETURN
ENDIF

* PrintToFile(cFileName) - Outputs our array's contents to a text file
*     Parameters: cFileName
cFileName = 'PrintToFileTest.txt'
IF FILE(cFileName)
    ERASE (cFileName)
ENDIF
oRATest.PrintToFile(cFileName)
SET DEVICE TO PRINT
SET PRINTER TO KArraysResults.txt ADDITIVE
SET PRINTER ON
SET CONSOLE ON
cStr = 'PrintToFile() Error: '
bIsGood = .F.
DO CASE
CASE NOT FILE(cFileName)
    ? cStr +  'File: ' + cFileName + ' not printed'
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.PrintToFile() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.PrintToFile() Failed!'
    RETURN
ENDIF

* Read in that last file
cTestString = FILETOSTR(cFileName)

* PrintToString() - Returns a string our array's contents
cStrOut = oRATest.PrintToString()
SET DEVICE TO PRINT
SET PRINTER TO KArraysResults.txt ADDITIVE
SET PRINTER ON
SET CONSOLE ON
cStr = 'PrintToString() Error: '
bIsGood = .F.
DO CASE
CASE NOT cStrOut $ cTestString
    ? cStr +  "File Strings don't match"
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.PrintToString() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.PrintToString() Failed!'
    RETURN
ENDIF

* PrintToFileExtended(cFileName) - Outputs the array's contents vertically
*     Parameters: cFileName
cFileName = 'PrintToFileExtendedTest.txt'
IF FILE(cFileName)
    ERASE (cFileName)
ENDIF
oRATest.PrintToFileExtended(cFileName)
cStr = 'PrintToFileExtended() Error: '
bIsGood = .F.
DO CASE
CASE NOT FILE(cFileName)
    ? cStr +  'File: ' + cFileName + ' not printed'
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.PrintToFileExtended() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.PrintToFileExtended() Failed!'
    RETURN
ENDIF

* Print() - Uses ? cStr +  to display the array contents (max. 20 char elements)
*     Parameters: [nLeftMargin] - number of spaces for left margin (default = 0)
*     Returns: Nothing, output printed with ? cStr +  command
? 'ArrayObj.Print() - Test Start:'
?
oRATest.Print()
? 'ArrayObj.Print() - Test End; judge for yourself.'

* ZapArray() - Removes all data and rows in an array (columns are unchanged)
oRATest.ZapArray()
cStr = 'ZapArray() Error: '
bIsGood = .F.
DO CASE
CASE oRATest.nRows <> 0
    ? cStr +  'nRows  = ' + TRANSFORM(oRATest.nRows)
OTHERWISE
    bIsGood = .T.
    ? 'ArrayObj.ZapArray() is OK!'
ENDCASE
IF NOT bIsGood
    ? 'ArrayObj.ZapArray() Failed!'
    RETURN
ENDIF

* Destroy() - Destory this object
* Release() - Release this object
? 'oRATest.Release(); which also calls oRATest.Destroy():'
oRATest.Release()
cStr = 'Release() Error: '
bIsGood = .F.
IF NOT VARTYPE(oRATest) $ 'UX'    && 'U'nkonwn variable, 'X' = NULL
    ? cStr +  'Method failed'
ELSE
    bIsGood = .T.
    ? 'ArrayObj.Release() is OK!'
ENDIF
IF NOT bIsGood
    ? 'ArrayObj.Release() Failed!'
    RETURN
ENDIF

?
? 'Function Tests:'
? '---------------'

* Split(cStr, [cDelim]) - Split a delimited string into a 1-dimensional array object
cTestStr = 'A,B,C'
? 'Split(' + cTestStr + '):'
oSplitObj = Split(cTestStr)
bIsGood = .F.
DO CASE
CASE oSplitObj.nRows <> 3
    ? cStr +  '.nRows  = ' + TRANSFORM(oSplitObj.nRows)
CASE oSplitObj.aRA[1] <> 'A'
    ? cStr +  'oSplitObj.aRA[1] = ' + oSplitObj.aRA[1]
CASE oSplitObj.aRA[2] <> 'B'
    ? cStr +  'oSplitObj.aRA[2] = ' + oSplitObj.aRA[2]
CASE oSplitObj.aRA[3] <> 'C'
    ? cStr +  'oSplitObj.aRA[3] = ' + oSplitObj.aRA[3]
OTHERWISE
    bIsGood = .T.
    ? '    Split() Function is OK!'
ENDCASE
IF NOT bIsGood
    ? '    Split() Function Failed!'
    RETURN
ENDIF

* SplitCSV(cStr) - Split delimited string into array but keep delims within ""s
cTestStr = [A,"Him,Her",C]
? 'SplitCSV(' + cTestStr + '):'
oSplitCSVObj = SplitCSV(cTestStr)
bIsGood = .F.
DO CASE
CASE oSplitCSVObj.nRows <> 3
    ? cStr +  '.nRows  = ' + TRANSFORM(oSplitCSVObj.nRows)
CASE oSplitCSVObj.aRA[1] <> 'A'
    ? cStr +  'oSplitCSVObj.aRA[1] = ' + oSplitCSVObj.aRA[1]
CASE oSplitCSVObj.aRA[2] <> "Him,Her"
    ? cStr +  'oSplitCSVObj.aRA[2] = ' + oSplitCSVObj.aRA[2]
CASE oSplitCSVObj.aRA[3] <> 'C'
    ? cStr +  'oSplitCSVObj.aRA[3] = ' + oSplitCSVObj.aRA[3]
OTHERWISE
    bIsGood = .T.
    ? '    SplitCSV() Function is OK!'
ENDCASE
IF NOT bIsGood
    ? '    SplitCSV() Function Failed!'
    RETURN
ENDIF

?
? 'Done! All tests have been completed successfully.'
?

* Done
SET CONSOLE OFF
SET PRINTER OFF
SET PRINTER TO
SET DEVICE TO SCREEN
RETURN
