#IF 0                           KArrays.prg

  Purpose:  Special Array handling objects

Revisions:  August 20, 1998 - Ken Green - Original to 1/30/24
             5/23/2025 - Special VFPX Edition

     Uses:  None

************************** Functions and Procedures *************************

* Split(cStr, [cDelim]) - Split a delimited string into a 1-dimensional array object
* SplitCSV(cStr) - Split delimited string into array but keep delims within ""s

***************************** Class Definitions *****************************

* ArrayObj Class Definition - General Array Object
*   DirArray Class (parent ArrayObj) - loads array with files matching spec
*   FileLines Class - Array object from lines in a file or text string
*   StringArray Class - Array object from a string list
*   MemoArray Class - Array Object for formatting blocks of text

****************************  Class PEM Summary *****************************

Properties:
    aRA        - The actual array
    nRows      - Number of rows in the array
    nCols      - Number of columns in the array
    nNearRow   - Next larger row in a failed Seek

Methods:
    Init([nCols]) - Initialize an array object
      Parameters: nCols (REQUIRED for multi-dimensional arrays)
        Note - nRows will be 0 after Init()

    IsEmpty() - Returns .T. if the array has no rows

    AddRow(xVal1 [,xVal2] [,xVal3]...) - Add a row to the array
        Parameters: xVal1 [,xVal2] [,xVal3] [...to xVal20]
        Returns: the new row number
        Note - xValX values are ignored if they exceed the number of columns

    InsertRow([nBeforeRow]) - Add a row to the array (resize it larger)
        Parameters: [nBeforeRow]
        Returns: The new number of rows in the array
        Notes:
            1. If nBeforeRow is passed, the new row is inserted into the array
                just before that row.  If not passed, the new row is added to
                the end of the array.
            2. All columns in the new row are initialized to ''

    AddBlankRows(nRowsWanted) - Add many rows to the array by reDIMENSIONing
        Parameters: nRowsWanted
        Returns: the new row count

    DeleteRow(nRowNum) - Remove a row to the array (re-size it smaller)
        Parameters: nRowNum
        Returns: The new number of rows in the array

    DeleteRemainingRows() - Remove rows from the bottom of the array
        Parameters: nRowCount
        Returns: The new number of rows in the array

    InsertCols(nNumNewCols) - Add columns to the array (re-size it larger)
        Parameters: nNumNewCols
        Returns: The new number of columns in the array
        Note: All elements in the new columns are initialized to ''

    DeleteCol(nCol2Remove) - Delete a column from the array (re-size it smaller)
        Parameters: nCol2Remove
        Returns: The new number of columns in the array

    Sort([nSortCol[, bDescending[, bCaseInSensitive]]]) - Sort the array
      Parameters: [nSortCol,] [bDescending,]  [, bCaseInSensitive]
      Returns: nothing, but array is sorted
      Notes: 1. nSortCol is REQUIRED for multi-dimensional arrays or column
                  1 will be used for the sort
             2. All elements in the sort must be of the same data type.
             3. If a bCaseInSensitive sort is desired, the first 2
                  parameters MUST be passed

    MultiColSort(nCol1, nCol2...[bDescending,] [, bCaseInSensitive]) - Sort the array by multiple columns
      Parameters: nCol1, nCol2 [, nCol3] [, nCol4] [, nCol5,] [bDescending,]
                    [, bCaseInSensitive]
      Returns: nothing, but array is sorted
      Notes: 1. At least 2 columns ARE REQUIRED for this sort (otherwise, use
                  the Sort() method instead)
             2. All elements in the sort must be of the same data type.
             3. If a bCaseInSensitive sort is desired, the first 5
                  parameters MUST be passed

    Locate() - Case-Insensitive look thru a non-ordered array for a value
       Parameters: xLookFor[, nSrchCol[, bExactOn]]
       Returns: Row found matching xLookFor (0 if not found)
       Notes: 1. nSrchCol is REQUIRED for multi-dimensional arrays or column
                   1 will be used for the Locate
              2. xLookFor's data type must match nSrchCol's
              3. bExactOn - (optional) If .T., EXACT comparison will be done

    Seek(xLookFor[, nSrchCol]) - Look through an ordered array for a passed value
        Parameters: xLookFor[, nSrchCol]
        Returns: Row found matching xLookFor (0 if not found)
                 Object.nNearRow is set if xLookFor is not found and array
                    contains a row with a larger value
        Notes: 1. nSrchCol is REQUIRED for multi-dimensional arrays or column
                    1 will be used for the Seek
               2. xLookFor's data type must match nSrchCol's
               3. Assumes a sorted array (results can be spurious if not)
               4. nNearRow property is set if not found

    PrintToString() - Returns a string our array's contents

    PrintToFile(cFileName) - Outputs our array's contents to a text file
        Parameters: cFileName

    PrintToFileExtended(cFileName) - Outputs the array's contents vertically
        Parameters: cFileName

    Print() - Uses ? to display the array contents (max. 20 char elements)
        Parameters: [nLeftMargin] - number of spaces for left margin (default = 0)
        Returns: Nothing, output printed with ? command

    ZapArray() - Removes all data and rows in an array (columns are unchanged)

    Destroy() - Destory this object

    Release() - Release this object

*****************************************************************************
#ENDIF

#DEFINE     TAB     CHR(9)
#DEFINE     CR      CHR(13)
#DEFINE     LF      CHR(10)
#DEFINE     CR_LF   CR + LF
#DEFINE     HEX_FF  CHR(255)

************************** Functions and Procedures *************************

* Split() - Split a delimited string into a 1-dimensional array object
FUNCTION Split(cStr, cDelim)
    LOCAL cChar, oArray

    * Inputs:
    *   cStr - The string to split
    *   cDelim - The character delimiter for the split (default = ',')
    * Output: A 1 dimensional StringArray array object with each element of the
    *           string after the cDelim character has been removed.
    *   Note: See StringArray.Join() for getting the string back
    m.cChar = ','
    IF PCOUNT() > 1 AND VARTYPE(m.cDelim) = 'C' AND LEN(m.cDelim) = 1
        m.cChar = m.cDelim
    ENDIF
    m.oArray = CREATEOBJECT('StringArray', m.cStr, m.cChar)
    RETURN m.oArray
ENDFUNC

* SplitCSV() - Split delimited string into array but keep delims within ""s
FUNCTION SplitCSV(cStr)
    LOCAL oCells, nX, nQuotes, cValue

    * Get an array
    m.oCells = SPLIT(m.cStr, ",")

    * Go thru each cell looking for "s. But as we'll delete rows we musts go
    *   from bottom up.
    WITH m.oCells
        FOR m.nX = .nRows TO 1 STEP -1
            m.nQuotes = OCCURS(["], .aRA[m.nX])
            DO CASE
            CASE m.nQuotes = 1
                m.cValue = .aRA[m.nX-1] + ',' + .aRA[m.nX]
                .aRA[m.nX-1] = ALLTRIM( STRTRAN(m.cValue, ["], ''))
                .DeleteRow(m.nX)

            * Some strings have a lot of internal quotes.
            *   Example: "8978 ""E"" Ave"
            CASE m.nQuotes > 1
                m.cValue = .aRA[m.nX]                       && "8978 ""E"" Ave"

                * Toss leading and trailing quotes
                m.cValue = SUBSTR(m.cValue, 2)              && 8978 ""E"" Ave"
                m.cValue = LEFT(m.cValue, LEN(m.cValue)-1)    && 8978 ""E"" Ave

                * Toss any duplications
                m.cValue = STRTRAN(m.cValue, [""], ["])     && 8978 "E" Ave"
                .aRA[m.nX] = m.cValue
            ENDCASE
        ENDFOR
    ENDWITH

    * Done
    RETURN m.oCells
ENDFUNC

***************************** Class Definitions *****************************

* ArrayObj Class Definition - General Array Object
DEFINE CLASS ArrayObj AS Custom

    * Standard Properties
    Name = 'ArrayObj'

    * Custom Properties
    PROTECTED bMultiCol, nSortedCol
    DIMENSION aRA[1]
    nRows = 0               && Rows in the array
    nCols = 1               && Columns in the array
    bMultiCol = .F.         && Single-column array; .T. = multi-column
    nSortedCol = 0          && Unsorted, if > 0, the sort column number
    nNearRow = 0            && Next larger row in unfound Seek

    * Block the base class properties we'll never need
    PROTECTED Application, ClassLibrary, Comment, Height, HelpContextID, Left, ;
      Object, Picture, Top, WhatsThisHelpID, Width

    * Block the base class methods we'll never need
    PROTECTED ReadExpression, ReadMethod, ResetToDefault, SaveAsClass, ;
      ShowWhatsThis, WriteExpression, WriteMethod

    * Custom Method List
    *- Init() - Initialize an array object
    *- IsEmpty() - Returns .T. if the array has no rows
    *- AddRow() - Add a row to the array and load up to 20 columns in that row
    *- InsertRow() - Add a row to the array (re-size it larger)
    *- DeleteRow() - Remove a row to the array (re-size it smaller)
    *- DeleteRemainingRows() - Remove rows from the bottom of the array
    *- InsertCols() - Add columns to the array (re-size it larger)
    *- DeleteCol() - Delete a column from the array (re-size it smaller)
    *- Sort() - Sort the array
    *- MultiColSort() - Sort the array by multiple columns
    *- Locate() - Case-Insensitive look thru a non-ordered array for a value
    *- Seek() - Look through an ordered array for a passed value

    *- PROT MoveColTo1() - Move the passed column to col 1
    *- PROT ClnElem() - Return a "clean" element's contents for printing
    *- PrintToFile() - Outputs our array's contents to a text file
    *- Print() - Uses ? to display the array contents (max. 20 char elements)
    *- PROT SetPrtWid() - Set our Print() column width
    *- ZapArray() - Removes all data and rows in an array (columns are unchanged)
    *- PROT XToChar() - Convert any value into a string
    *- PROT MakeLen() - Make a string to the length specified (space filled if needed)
    *- PROT FldsInExpr() - Returns a list of field names within an index expression
    *- PROT ExtrToken() - Extract and return the text before a passed token (char)
    *- PROT AtNotInParen() - Return the pos'n of a char NOT within parentheses
    *- PROT AtNotInDelim() - Return the pos'n of a char NOT within delimeters
    *- Error() - Handle/pass up any errors
    *- Destroy() - Kill our contents
    *- Release() - Remove this object from memory

    * Custom Method Code:

    *- Init() - Initialize an array object
    *   Parameters: [nCols] (REQUIRED for multi-dimensional arrays)
    *     Note - nRows will be 0 after Init()
    FUNCTION Init( nColCnt )
        IF NOT DODEFAULT()
            RETURN .F.
        ENDIF

        * Define the column count if it was passed
        IF TYPE('nColCnt') = 'N' AND m.nColCnt >= 1
            THIS.nCols = m.nColCnt
        ENDIF

        * Create the barebones array
        IF THIS.nCols = 1
            THIS.bMultiCol = .F.
        ELSE
            DIMENSION THIS.aRA[ 1, THIS.nCols ]
            THIS.bMultiCol = .T.
        ENDIF
        STORE '' TO THIS.aRA
        THIS.nRows = 0
        THIS.nSortedCol = 0
        NODEFAULT
        RETURN .T.
    ENDFUNC

    *- IsEmpty() - Returns .T. if the array has no rows
    FUNCTION IsEmpty()
        RETURN (THIS.nRows = 0)
    ENDFUNC

    *- AddRow() - Add a row to the array and load up to 20 columns in that row
    *     Parameters: xVal1 [,xVal2] [,xVal3] [...to xVal20]
    *     Returns: the new row number
    *     Note - xValX values are ignored if they exceed the number of columns
    FUNCTION AddRow (xVal1, xVal2, xVal3, xVal4, xVal5, xVal6, xVal7, xVal8, ;
      xVal9, xVal10, xVal11, xVal12, xVal13, xVal14, xVal15, xVal16, xVal17, ;
      xVal18, xVal19, xVal20 )
        LOCAL nNewRowNum, nX, cVarName, xValue

        * Add a new row
        m.nNewRowNum = THIS.InsertRow()

        * We must always have the first value
        IF THIS.bMultiCol
            THIS.aRA[m.nNewRowNum, 1] = m.xVal1
        ELSE
            THIS.aRA[m.nNewRowNum] = m.xVal1
        ENDIF

        * How many values did we receive?  Or, rather, will we use?
        m.nValCount = MIN( PCOUNT(), THIS.nCols )

        * Change only the passed parameters
        FOR m.nX = 2 TO m.nValCount
            m.cVarName = 'xVal' + LTRIM( STR(m.nX,2,0) )
            m.xValue = EVAL(m.cVarName)

            * These can only be for multicolumn arrays
            THIS.aRA[m.nNewRowNum, m.nX] = m.xValue
        ENDFOR
        RETURN m.nNewRowNum
    ENDFUNC

    *- InsertRow() - Add a row to the array (re-size it larger)
    *   Parameters: [nBeforeRow]
    *   Returns: The new number of rows in the array
    *   Notes:
    *       1. If nBeforeRow is passed, the new row is inserted into the array
    *           just before that row.  If not passed, the new row is added to
    *           the end of the array.
    *       2. All columns in the new row are initialized to ''
    FUNCTION InsertRow(nRowNum)
        LOCAL nX
        WITH THIS

            * First, re-dimension the array, but there's a different syntax for
            *   single- vs multi-column array.
            IF .bMultiCol
                DIMENSION .aRA[.nRows+1, .nCols]
            ELSE
                DIMENSION .aRA[.nRows+1]
            ENDIF

            * Are we to insert a row or just add one at the end?
            IF TYPE('nRowNum') = 'N' AND BETWEEN(m.nRowNum, 1, .nRows)
                = AINS(.aRA, m.nRowNum)          && Insert the row
            ELSE

                * Add a row at the end (already done), just note the row
                m.nRowNum = .nRows + 1
            ENDIF

            * Initialize the new row
            IF .bMultiCol
                FOR m.nX = 1 to .nCols
                    .aRA[m.nRowNum, m.nX] = ''
                ENDFOR
            ELSE
                .aRA[m.nRowNum] = ''
            ENDIF

            * Reset the row count
            .nRows = ALEN(.aRA, 1)
        ENDWITH

        * Return the new row total
        RETURN THIS.nRows
    ENDFUNC

    *- AddBlankRows() - Add many rows to the array by reDIMENSIONing
    *   Parameters: nRowsWanted
    *   Returns: the new row count
    FUNCTION AddBlankRows(nRowsWanted)
        LOCAL nOldRows, nTotRows, nRow, nCol

        * First, re-dimension the array, but there's a different syntax for
        *   single- vs multi-column array.
        m.nOldRows = THIS.nRows
        m.nTotRows = m.nOldRows + m.nRowsWanted
        IF THIS.bMultiCol
            DIMENSION THIS.aRA[m.nTotRows, THIS.nCols]
        ELSE
            DIMENSION THIS.aRA[m.nTotRows]
        ENDIF

        * Initialize the new row
        FOR m.nRow = m.nOldRows + 1 TO m.nTotRows
            IF THIS.bMultiCol
                FOR m.nCol = 1 to THIS.nCols
                    THIS.aRA[m.nRow, m.nCol] = ''
                ENDFOR
            ELSE
                THIS.aRA[m.nRow] = ''
            ENDIF
        ENDFOR

        * Reset the row count
        THIS.nRows = m.nTotRows

        * Return the new row total
        RETURN m.nTotRows
    ENDFUNC

    *- DeleteRow() - Remove a row to the array (re-size it smaller)
    *   Parameters: nRowNum
    *   Returns: The new number of rows in the array
    FUNCTION DeleteRow( nRowNum )

        * If we have no rows, don't do anything
        DO CASE
        CASE THIS.nRows = 0

            * We're already happy

        * If this is the last row, don't delete anything
        CASE THIS.nRows = 1
            IF THIS.bMultiCol
                FOR m.nJ = 1 TO THIS.nCols
                    THIS.aRA[1,m.nJ] = ''
                ENDFOR
            ELSE
                THIS.aRA[1] = ''
            ENDIF
            THIS.nRows = 0
        OTHERWISE

            * Delete the row
            = ADEL( THIS.aRA, m.nRowNum )

            * Redimension the array
            IF THIS.bMultiCol
                DIMENSION THIS.aRA[ THIS.nRows-1, THIS.nCols ]
            ELSE
                DIMENSION THIS.aRA[ THIS.nRows-1 ]
            ENDIF

            * Decrement the row count and return the new total
            THIS.nRows = THIS.nRows - 1
        ENDCASE
        RETURN THIS.nRows
    ENDFUNC

    *- DeleteRemainingRows() - Remove rows from the bottom of the array
    *      Parameters: nRowCount
    *      Returns: The new number of rows in the array
    FUNCTION DeleteRemainingRows( nRowCount )

        * Here, we know we have at least 1 row in the array
        IF THIS.nRows = 1
            IF THIS.bMultiCol
                FOR m.nJ = 1 TO THIS.nCols
                    THIS.aRA[1,m.nJ] = ''
                ENDFOR
            ELSE
                THIS.aRA[1] = ''
            ENDIF
            THIS.nRows = 0
        ELSE

            * How many rows will we end up with?
            m.nNewRows = THIS.nRows - m.nRowCount

            * Redimension the array
            IF THIS.bMultiCol
                DIMENSION THIS.aRA[ m.nNewRows, THIS.nCols ]
            ELSE
                DIMENSION THIS.aRA[ m.nNewRows ]
            ENDIF

            * Define our new row count
            THIS.nRows = m.nNewRows
        ENDIF
        RETURN THIS.nRows
    ENDFUNC

    *- InsertCols() - Add columns to the array (re-size it larger)
    *   Parameters: nNumNewCols
    *   Returns: The new number of columns in the array
    *   Note: All elements in the new columns are initialized to ''
    FUNCTION InsertCols( nNumNewCols )
        LOCAL nOldCols, nNewCols, nX, nY, aTemp[1]

        * Copy the current array to aTemp[]
        = ACOPY( THIS.aRA, m.aTemp )

        * What's our old column count?
        m.nOldCols = THIS.nCols

        * Re-dimension our array
        m.nNewCols = THIS.nCols + m.nNumNewCols
        IF THIS.nRows = 0
            DIMENSION THIS.aRA[1, m.nNewCols]
        ELSE
            DIMENSION THIS.aRA[ THIS.nRows, m.nNewCols]
        ENDIF
        STORE '' TO THIS.aRA

        * Copy everything from aTemp into the new array
        FOR m.nX = 1 TO THIS.nRows
            FOR m.nY = 1 TO THIS.nCols
                IF m.nOldCols = 1
                    THIS.aRA[m.nX, m.nY] = m.aTemp[m.nX]
                ELSE
                    THIS.aRA[m.nX, m.nY] = m.aTemp[m.nX, m.nY]
                ENDIF
            ENDFOR
        ENDFOR

        * Reset our values
        THIS.nCols = m.nNewCols
        THIS.bMultiCol = (THIS.nCols > 1)

        * Return the new column count
        RETURN THIS.nCols
    ENDFUNC

    *- DeleteCol() - Delete a column from the array (re-size it smaller)
    *     Parameters: nCol2Remove
    *     Returns: The new number of columns in the array
    FUNCTION DeleteCol( nCol2Remove )
        LOCAL nX, nY, aTemp

        * Create a temporary array
        DIMENSION m.aTemp[ MAX(THIS.nRows,1), THIS.nCols]

        * Copy the current array to aTemp[]
        = ACOPY( THIS.aRA, m.aTemp )

        * Re-dimension our array
        DIMENSION THIS.aRA[ MAX(THIS.nRows,1), THIS.nCols-1]

        * Copy all from aTemp into the new array except the column we removed
        FOR m.nX = 1 TO THIS.nRows
            FOR m.nY = 1 TO THIS.nCols
                DO CASE
                CASE m.nY > m.nCol2Remove
                    THIS.aRA[m.nX, m.nY-1] = m.aTemp[m.nX, m.nY]
                CASE m.nY < m.nCol2Remove
                    THIS.aRA[m.nX, m.nY] = m.aTemp[m.nX, m.nY]
                ENDCASE
            ENDFOR
        ENDFOR

        * Reset our values
        THIS.nCols = THIS.nCols - 1
        THIS.bMultiCol = (THIS.nCols > 1)

        * Return the new column count
        RETURN THIS.nCols
    ENDFUNC

    *- Sort() - Sort the array
    *   Parameters: [nSortCol[, bDescending[, bCaseInSensitive]]]
    *   Returns: nothing, but array is sorted
    *   Notes: 1. nSortCol is REQUIRED for multi-dimensional arrays or column
    *               1 will be used for the sort
    *          2. All elements in the sort must be of the same data type.
    *          3. If a bCaseInSensitive sort is desired, the first 2
    *               parameters MUST be passed
    PROCEDURE Sort( nSortCol, bDescend, bCaseInSensitive )
        LOCAL nAscend, bChkCase, nNewCol, nM

        * Return quickly if < 2 rows
        IF THIS.nRows < 2
            RETURN
        ENDIF

        * If we got no sort col, make it column 1
        IF TYPE('nSortCol') <> 'N' OR NOT BETWEEN(m.nSortCol, 1, THIS.nCols)
            m.nSortCol = 1
        ENDIF

        * Check our ascending/descending parameter
        m.nAscend = 0         && Default is Ascending
        IF PCOUNT() > 1 AND TYPE('bDescend') = 'L'
            m.nAscend = IIF(m.bDescend, 1, 0)
        ENDIF

        * Check our case sensitivity parameter
        m.bChkCase = .F.      && Default is no case sensitivity
        IF TYPE('bCaseInSensitive') = 'L'
            m.bChkCase = m.bCaseInSensitive
        ENDIF

        * If this is a case insensitive sort, we have some special work to do
        IF m.bChkCase
            THIS.InsertCols(1)
            m.nNewCol = THIS.nCols
            FOR m.nM = 1 TO THIS.nRows
                THIS.aRA[m.nM,m.nNewCol] = UPPER( THIS.aRA[m.nM,m.nSortCol] )
            ENDFOR

            * Sort on our uppercase column
            = ASORT( THIS.aRA, m.nNewCol, THIS.nRows, m.nAscend )

            * Delete our added column
            THIS.DeleteCol(m.nNewCol)
        ELSE

            * Otherwise, just a normal sort - Well, maybe not
            = ASORT( THIS.aRA, m.nSortCol, THIS.nRows, m.nAscend )
        ENDIF

        * Note our sort column
        THIS.nSortedCol = m.nSortCol
        RETURN
    ENDPROC

    *- MultiColSort() - Sort the array by multiple columns
    *   Parameters: nCol1, nCol2 [, nCol3] [, nCol4] [, nCol5,] [bDescending,]
    *                 [, bCaseInSensitive]]
    *   Returns: nothing, but array is sorted
    *   Notes: 1. At least 2 columns ARE REQUIRED for this sort (otherwise, use
    *               the Sort() method instead)
    *          2. All elements in the sort must be of the same data type.
    *          3. If a bCaseInSensitive sort is desired, the first 5
    *               parameters MUST be passed
    PROCEDURE MultiColSort(nCol1, nCol2, nCol3, nCol4, nCol5, bDescend, bCaseInSensitive)
        LOCAL nAscend, bChkCase, nNewSortCol, nM, cNewData

        * Return quickly if < 2 rows
        IF THIS.nRows < 2
            RETURN
        ENDIF

        * We must have the 1st 2 sort columns; check the others
        IF VARTYPE(m.nCol3) <> 'N' OR NOT BETWEEN(m.nCol3, 1, THIS.nCols)
            m.nCol3 = 0
        ENDIF
        IF VARTYPE(m.nCol4) <> 'N' OR NOT BETWEEN(m.nCol4, 1, THIS.nCols)
            m.nCol4 = 0
        ENDIF
        IF VARTYPE(m.nCol5) <> 'N' OR NOT BETWEEN(m.nCol5, 1, THIS.nCols)
            m.nCol5 = 0
        ENDIF

        * Check our ascending/descending parameter
        m.nAscend = 0         && Default is Ascending
        IF PCOUNT() > 1 AND TYPE('bDescend') = 'L'
            m.nAscend = IIF(m.bDescend, 1, 0)
        ENDIF

        * Check our case sensitivity parameter
        m.bChkCase = .F.      && Default is no case sensitivity
        IF TYPE('bCaseInSensitive') = 'L'
            m.bChkCase = m.bCaseInSensitive
        ENDIF

        * We'll create the sort expression made up of multiple column's
        *   values and put it in a new column.  Then, we'll sort on that.
        THIS.InsertCols(1)
        m.nNewSortCol = THIS.nCols

        * Now, go thru each row and create the sort expression
        FOR m.nM = 1 TO THIS.nRows

            * Create an expression from the affected columns
            m.cNewData = THIS.aRA[m.nM,m.nCol1] + THIS.aRA[m.nM,m.nCol2]
            IF m.nCol3 > 0
                m.cNewData = m.cNewData + THIS.aRA[m.nM,m.nCol3]
            ENDIF
            IF m.nCol4 > 0
                m.cNewData = m.cNewData + THIS.aRA[m.nM,m.nCol4]
            ENDIF
            IF m.nCol5 > 0
                m.cNewData = m.cNewData + THIS.aRA[m.nM,m.nCol5]
            ENDIF

            * If this is a case insensitive sort, make it uppercase
            IF m.bChkCase
                m.cNewData = UPPER(m.cNewData)
            ENDIF
            THIS.aRA[m.nM,m.nNewSortCol] = m.cNewData
        ENDFOR

        * Sort on our uppercase column
        = ASORT( THIS.aRA, m.nNewSortCol, THIS.nRows, m.nAscend )

        * Delete our added column
        THIS.DeleteCol(m.nNewSortCol)

        * Note our sort column
        THIS.nSortedCol = m.nCol1
        RETURN
    ENDPROC

    *- Locate() - Case-Insensitive look thru a non-ordered array for a value
    *     Parameters: xLookFor[, nSrchCol[, bExactOn]]
    *     Returns: Row found matching xLookFor (0 if not found)
    *     Notes: 1. nSrchCol is REQUIRED for multi-dimensional arrays or column
    *                 1 will be used for the Locate
    *            2. xLookFor's data type must match nSrchCol's
    *            3. bExactOn - (optional) If .T., EXACT comparison will be done
    FUNCTION Locate(xLookFor, nSrchCol, bExactOn)
        LOCAL cSrchType, nRowx, xChkVal, bGotIt

        * If we got no search col, make it column 1
        IF TYPE('nSrchCol') <> 'N' OR NOT BETWEEN(m.nSrchCol, 1, THIS.nCols)
            m.nSrchCol = 1
        ENDIF

        * What's the type of the variable we're looking for?  If it's
        *   Character, make it uppercase
        m.cSrchType = TYPE('xLookFor')
        IF m.cSrchType = 'C'
            m.xLookFor = UPPER(m.xLookFor)
        ENDIF

        * Set our default near row
        THIS.nNearRow = 0

        * Search thru the array
        FOR m.nRowx = 1 TO THIS.nRows

            * Get this row's value
            IF THIS.bMultiCol
                m.xChkVal = THIS.aRA[m.nRowx, m.nSrchCol]
            ELSE
                m.xChkVal = THIS.aRA[m.nRowx]
            ENDIF

            * If character, make it uppercase
            IF m.cSrchType = 'C'
                m.xChkVal = UPPER( m.xChkVal )
            ENDIF

            * Does it match what we're looking for?
            IF m.bExactOn
                m.bGotIt = (m.xChkVal == m.xLookFor)
            ELSE
                m.bGotIt = (m.xChkVal = m.xLookFor)
            ENDIF
            IF m.bGotIt
                RETURN m.nRowx
            ENDIF

            * Set Near Row (though I'm not sure what it's good for)
            IF m.xChkVal > m.xLookFor AND THIS.nNearRow = 0
                THIS.nNearRow = m.nRowx
            ENDIF
        ENDFOR

        * If we didn't return by now, it's not there
        RETURN 0
    ENDFUNC

    *- Seek() - Look through an ordered array for a passed value
    *   Parameters: xLookFor[, nSrchCol]
    *   Returns: Row found matching xLookFor (0 if not found)
    *            Object.nNearRow is set if xLookFor is not found and array
    *               contains a row with a larger value
    *   Notes: 1. nSrchCol is REQUIRED for multi-dimensional arrays or column
    *               1 will be used for the Seek
    *          2. xLookFor's data type must match nSrchCol's
    *          3. Assumes a sorted array (results can be spurious if not)
    FUNCTION Seek( xLookFor, nSrchCol )
        LOCAL cSrchType, nRowx, xChkVal

        * If we got no Seek col, make it column 1
        IF TYPE('nSrchCol') <> 'N' OR NOT BETWEEN(m.nSrchCol, 1, THIS.nCols)
            m.nSrchCol = 1
        ENDIF

        * What's the type of the variable we're looking for?  If it's
        *   Character, make it uppercase
        m.cSrchType = TYPE('xLookFor')
        IF m.cSrchType = 'C'
            m.xLookFor = UPPER(m.xLookFor)
        ENDIF

        * Set our default near row
        THIS.nNearRow = 0

        * Search thru the array
        FOR m.nRowx = 1 TO THIS.nRows

            * Get this row's value
            IF THIS.bMultiCol
                m.xChkVal = THIS.aRA[m.nRowx, m.nSrchCol]
            ELSE
                m.xChkVal = THIS.aRA[m.nRowx]
            ENDIF

            * If character, make it uppercase
            IF m.cSrchType = 'C'
                m.xChkVal = UPPER( m.xChkVal )
            ENDIF

            * Does it match what we're looking for?  Is it > than that?
            IF m.xChkVal >= m.xLookFor

                * If it's a match, return the row
                IF m.xChkVal = m.xLookFor
                    RETURN m.nRowx
                ENDIF

                * It must be > than what we're looking for, set nNearRow and
                *   return noting a failed Seek
                THIS.nNearRow = m.nRowx
                RETURN 0
            ENDIF
        ENDFOR

        * If we didn't return by now, it's not there
        RETURN 0
    ENDFUNC

    *- PROT MoveColTo1() - Move the passed column to col 1
    *   Parameters: nMoveCol
    *   Note - ONLY APPLIES to multi-column arrays
    PROTECTED PROCEDURE MoveColTo1( m.nMoveCol )
        LOCAL nRowx, nColx
        LOCAL ARRAY aTemp[ THIS.nRows, THIS.nCols ]

        * Copy the existing array into a temporary array
        ACOPY( THIS.aRA, m.aTemp )

        * Now, copy the temporary array back into our array, moving columns
        FOR m.nRowx = 1 TO THIS.nRows

            * Copying is done as follows (assume 4 cols, we're to move #3)
            *   Old array col       New array col
            *        1                    2
            *        2                    3
            *        3      move col      1
            *        4                    4
            * So, the move rules are:
            *   A. Move the nMoveCol to column 1
            *   B. If the old column < nMoveCol, move it to col + 1
            *   C. Else, move it to the same column number
            FOR m.nColx = 1 TO THIS.nCols
                DO CASE
                CASE m.nColx = m.nMoveCol
                    THIS.aRA[m.nRowx,1] = m.aTemp[m.nRowx,m.nMoveCol]
                CASE m.nColx < m.nMoveCol
                    THIS.aRA[m.nRowx,m.nColx+1] = m.aTemp[m.nRowx,m.nColx]
                OTHERWISE
                    THIS.aRA[m.nRowx,m.nColx] = m.aTemp[m.nRowx,m.nColx]
                ENDCASE
            ENDFOR
        ENDFOR
        RETURN
    ENDPROC

    *- PROT ClnElem() - Return a "clean" element's contents for printing
    *   Parameters: xElem, nMaxLen
    *   Returns: Trimmed string, <= nMaxLen with no internal CR, LF, or TABs)
    *               ready for printing
    PROTECTED FUNCTION ClnElem( m.xElem, m.nMaxLen )
        LOCAL cStrOut

        * Convert the passed element into a string
        m.cStrOut = TRIM( THIS.XToChar( m.xElem ) )

        * Convert TABs into 2 spaces
        IF TAB $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, TAB, '  ')
        ENDIF

        * But, the string ends at the first CR or LF
        IF CR $ m.cStrOut
            m.cStrOut = LEFT(m.cStrOut, AT(CR, m.cStrOut)-1 )
        ENDIF
        IF LF $ m.cStrOut
            m.cStrOut = LEFT(m.cStrOut, AT(LF, m.cStrOut)-1 )
        ENDIF

        * Chop it if it's greater than nMaxLen (if we have nMaxLen)
        IF VARTYPE(m.nMaxLen) = 'N' AND m.nMaxLen > 0 AND LEN(m.cStrOut) > m.nMaxLen
            m.cStrOut = LEFT(m.cStrOut, m.nMaxLen)
        ENDIF

        * Done
        RETURN m.cStrOut
    ENDFUNC

    *- PrintToString() - Returns a string our array's contents
    FUNCTION PrintToString()
        LOCAL cTmpFile, cStr

        * Get a temporary file name
        IF VARTYPE('goFiles') = 'O' AND NOT ISNULL(goFiles)
            m.cTmpFile = goFiles.UniqueTempName('txt')
        ELSE
            m.cTmpFile = SYS(3) + [.txt]
        ENDIF
        THIS.PrintToFile(m.cTmpFile)
        m.cStr = FILETOSTR(m.cTmpFile)

        * Done
        ERASE (m.cTmpFile)
        RETURN m.cStr
    ENDFUNC

    *- PrintToFile() - Outputs our array's contents to a text file
    PROCEDURE PrintToFile(cFileName)
        SET DEVICE TO PRINT
        SET PRINTER TO &cFileName
        SET PRINTER ON
        SET CONSOLE OFF
        THIS.Print(0)
        SET CONSOLE ON
        SET PRINTER OFF
        SET PRINTER TO
        SET DEVICE TO SCREEN
        RETURN
    ENDPROC

    *- PrintToFileExtended() - Outputs the array's contents vertically
    PROCEDURE PrintToFileExtended(cFileName)
        LOCAL cStr, nX, cRow, nY, xVal

        * <ArrayName>'s Contents; 99999 rows, 9999 columns:
        WITH THIS
            m.cStr = .Name + "'s Contents; " + TRANSFORM(.nRows) + " rows, " + ;
              TRANSFORM(.nCols) + " columnss:" + CR_LF + CR_LF

            * Each row is printed as:
            *   Row <row>:
            *       [col]: data
            *       [col]: data
            FOR m.nX = 1 TO .nRows
                m.cRow = '  Row ' + TRANSFORM(m.nX) + ':' + CR_LF
                FOR m.nY = 1 TO .nCols
                    m.xVal = .aRA[m.nX,m.nY]
                    IF VARTYPE(m.xVal) <> 'C'
                        m.xVal = ALLTRIM(THIS.XToChar(m.xVal))
                    ENDIF
                    m.cRow = m.cRow + SPACE(4) + '[' + TRANSFORM(m.nY) + ']: ' + ;
                      m.xVal + CR_LF
                ENDFOR

                * Add this to the pile
                m.cStr = m.cStr + m.cRow + CR_LF
            ENDFOR
        ENDWITH

        * Put this into the output file
        STRTOFILE(m.cStr, m.cFileName)

        * Done
        RETURN
    ENDPROC

    *- Print() - Uses ? to display the array contents (max. 20 char elements)
    *   Parameters: [nLeftMargin] - number of spaces for left margin (default = 0)
    PROCEDURE Print( nLeftMargin )
        LOCAL cMargin, cRows, cCols, cColGap, cHdg, cStrOut, nR, nC, nMaxCols, ;
          cThisElem
        LOCAL WidthRA[1]

        * What's our left margin
        m.cMargin = ''
        IF TYPE('nLeftMargin') = 'N' AND m.nLeftMargin > 0
            m.cMargin = SPACE(m.nLeftMargin)
        ENDIF

        * Print the heading - first, get a row and column string
        m.cRows = ALLTRIM( THIS.XToChar( THIS.nRows ) ) + ' row' + ;
          IIF( THIS.nRows = 1, '', 's')
        m.cCols = ALLTRIM( THIS.XToChar( THIS.nCols ) ) + ' column' + ;
          IIF( THIS.nCols = 1, '', 's')
        ?? m.cMargin + THIS.Name + "'s aRA[] contents - " + m.cRows + ', ' + ;
          m.cCols + ':'

        * We want to print out the array kinda like:
        *       nnnn:  Cell1    Cell2   Cell3   ...
        * where nnnn = row number.  But, each element might have long
        * strings and we want this all to line up.  So, we'll determine the
        * maximum width for each column.  We'll make a quick little array
        * where each row is the maximum column width.
        m.cColGap = SPACE(2)

        * Create another array to hold the widths
        DIMENSION m.WidthRA[ THIS.nCols ]
        STORE 0 TO m.WidthRA

        * If this is a multi-column array, things are tricky
        IF THIS.bMultiCol
            m.cHdg = THIS.SetPrtWid( @m.WidthRA, 6+LEN(m.cMargin), LEN(m.cColGap) )
            m.cStrOut = m.cMargin + SPACE(4) + '  ' + m.cHdg
            ? m.cStrOut
        ELSE
            m.WidthRA[1] = 80
            m.cHdg = ''
        ENDIF

        * Go thru and print all rows in the array
        FOR m.nR = 1 TO THIS.nRows

            * Define our row number string
            m.cStrOut = m.cMargin + STR( m.nR, 4, 0) + ': '

            * Add all columns
            FOR m.nC = 1 TO THIS.nCols

                * What's our maximum length
                m.nMaxCols = m.WidthRA[m.nC]
                IF THIS.bMultiCol
                    m.cThisElem = THIS.ClnElem( THIS.aRA[m.nR,m.nC] )
                ELSE
                    m.cThisElem = THIS.ClnElem( THIS.aRA[m.nR] )
                ENDIF
                IF LEN(m.cThisElem) > m.nMaxCols
                    m.cThisElem = LEFT(m.cThisElem,m.nMaxCols-3) + '...'
                ELSE
                    m.cThisElem = THIS.MakeLen( m.cThisElem, m.nMaxCols)
                ENDIF
                m.cStrOut = m.cStrOut + m.cThisElem + m.cColGap
            ENDFOR

            * Print this line
            ? m.cStrOut
        ENDFOR

        * Add a blank line and we're done
        ?
        RETURN
    ENDPROC

    *- PROT SetPrtWid() - Set our Print() column width
    PROTECTED FUNCTION SetPrtWid( m.aColWidths, m.nMargLen, m.nColGap)
        EXTERNAL ARRAY aColWidths
        LOCAL nE, nF, cThisElem, nLen, nOAWid, nCols, nMaxWid, nToCut, nChg, ;
          cHdgLine

        * This is a multi-dimensional array.  We want to print it out at a
        *   maximum width of 80 characters including the left margin.  Like:
        *       Row#:  Cell1    Cell2   Cell3   ...

        * First, find the maximum width of each column
        FOR m.nE = 1 TO THIS.nRows
            FOR m.nF = 1 TO THIS.nCols
                m.cThisElem = THIS.ClnElem( THIS.aRA[m.nE,m.nF], 80 )
                m.nLen = LEN(m.cThisElem)
                IF m.nLen > m.aColWidths[m.nF]
                    m.aColWidths[m.nF] = m.nLen
                ENDIF
            ENDFOR
        ENDFOR

        * Make sure we at least have room for the heading and calculate the
        *   overall width
        m.nOAWid = 0
        m.nCols = THIS.nCols
        FOR m.nF = 1 TO m.nCols
            m.nLen = m.aColWidths[m.nF]

            * We must have at least room for the heading
            IF m.nLen < LEN( LTRIM( STR(m.nF) ))
                m.nLen = LEN( LTRIM( STR(m.nF) ))
                m.aColWidths[m.nF] = m.nLen
            ENDIF

            * Add to the overall totals
            m.nOAWid = m.nOAWid + m.aColWidths[m.nF] + IIF(m.nF < m.nCols, m.nColGap, 0)
        ENDFOR

        * If we're over our 80 column length, we'll have to do some chopping
        m.nMaxWid = 80 - m.nMargLen + 5         && An extra 5 is OK
        IF m.nOAWid > m.nMaxWid

            * How much do we have to cut?
            m.nToCut = m.nOAWid - m.nMaxWid

            * We'll take it all from columns > 20 chars starting from the end
            FOR m.nF = m.nCols TO 1 STEP -1
                IF m.aColWidths[m.nF] > 20
                    m.nChg = m.aColWidths[m.nF] - 20
                    m.aColWidths[m.nF] = 20
                    m.nToCut = m.nToCut - m.nChg
                    IF m.nToCut <= 0
                        EXIT
                    ENDIF
                ENDIF
            ENDFOR
        ENDIF

        * Now, create a heading line
        m.cHdgLine = ''
        FOR m.nF = 1 TO m.nCols
            m.cHdgLine = m.cHdgLine + ;
              PADC( LTRIM( STR( m.nF )), m.aColWidths[m.nF], '-') + SPACE(m.nColGap)
        ENDFOR

        * Done, return the heading line
        RETURN m.cHdgLine
    ENDFUNC

    *- ZapArray() - Removes all data and rows in an array (columns are unchanged)
    PROCEDURE ZapArray()
        IF THIS.bMultiCol
            DIMENSION THIS.aRA[ 1, THIS.nCols ]
        ELSE
            DIMENSION THIS.aRA[1]
        ENDIF
        THIS.nRows = 0
        STORE '' TO THIS.aRA
        RETURN
    ENDPROC

    *- PROT XToChar() - Convert any value into a string
    *     Input: xValue - Value to be converted
    *      Retn: String after conversion
    *      Note: Was XTOCHAR
    PROTECTED FUNCTION XToChar(m.xValue)
        LOCAL cOldSet, cRetVal

        * Do the conversion, logicals are special
        DO CASE

        * Nulls
        CASE ISNULL(m.xValue)
            RETURN '.NULL.'

        * Objects
        CASE VARTYPE(m.xValue) = 'O'
            IF PEMSTATUS(m.xValue, [Name], 5)
                RETURN 'Object: ' + m.xValue.Name
            ENDIF
            RETURN 'Object: Empty class'

        * Logicals
        CASE VARTYPE(m.xValue) = 'L'
            RETURN TRANSFORM(m.xValue, "Y")

        * Use DTOS for dates.  DTOS() is independent of the SET DATE or SET
        *   CENTURY settings - but be aware that all returns are in yyyymmdd format.
        CASE VARTYPE(m.xValue) = 'D'
            RETURN DTOS(m.xValue)

        * Use TTOS for DateTimes.  TTOS() is independent of the SET SECONDS or
        *   SET CENTURY settings, but the string will be in
        *   yyyy:mm:dd:hh:mm:ss format.  If the DateTime contains only a time,
        *   VFP adds the default date of 12/30/1899.  If it's only a date, VFP
        *   adds the default time of midnight (12:00:00 A.M.).
        CASE VARTYPE(m.xValue) = 'T'
            RETURN TTOC(m.xValue, 1)

        * Numerics are tricky as we'll get a bunch of trailing 0's depending on
        *   the SET DECIMALS setting
        CASE VARTYPE(m.xValue) = 'N'
            m.cOldSet = SET('DECIMALS')
            SET DECIMALS TO 10
            m.cRetVal = ALLTRIM( TRANSFORM(m.xValue, "") )

            * Strip any trailing 0s and .s from fractions
            DO WHILE '.' $ m.cRetVal AND RIGHT(m.cRetVal, 1) $ '0.'
                m.cRetVal = LEFT(m.cRetVal, LEN(m.cRetVal)-1 )
            ENDDO
            SET DECIMALS TO m.cOldSet
            RETURN m.cRetVal

        * Character and memos are the easiest
        CASE VARTYPE(m.xValue) $ 'CMG'
            RETURN m.xValue

        * Objects???  Does anyone care?
        CASE VARTYPE(m.xValue) = 'O'
            RETURN 'Object: ' + m.xValue.Name

        * Everything else
        OTHERWISE
            RETURN ALLTRIM( TRANSFORM(m.xValue, "") )
        ENDCASE
    ENDFUNC

    *- PROT MakeLen() - Make a string to the length specified (space filled if needed)
    PROTECTED FUNCTION MakeLen(m.cStrIn, m.nDesLen, m.bAddMT)
        LOCAL cRetStr

        * If this is a memo field, pick only the stuff to the left of CR's.
        m.cRetStr = m.cStrIn
        DO CASE
        CASE CR_LF $ m.cStrIn
            m.cRetStr = LEFT(m.cStrIn, AT( CR, m.cStrIn) - 1)

        * If it's empty, say so if they asked for it
        CASE EMPTY(m.cStrIn)
            m.cRetStr = IIF( m.nDesLen >= 7 AND m.bAddMT, '<empty>', SPACE(m.nDesLen) )
        ENDCASE

        * Now, adjust the length
        DO CASE
        CASE LEN(m.cRetStr) > m.nDesLen
            m.cRetStr = LEFT(m.cRetStr, m.nDesLen)
        CASE LEN(m.cRetStr) < m.nDesLen
            m.cRetStr = m.cRetStr + SPACE(m.nDesLen - LEN(m.cRetStr) )
        OTHERWISE
            m.cRetStr = m.cRetStr
        ENDCASE
        RETURN m.cRetStr
    ENDFUNC

    *- PROT FldsInExpr() - Returns a list of field names within an index expression
    *     Input: cExpr - The index expression in question
    *      Retn: List of Field Names
    *      Note: Was EXPRFLDS
    PROTECTED FUNCTION FldsInExpr( m.pcExpr )
        LOCAL cWkgExpr, cFldList, nX, cThisFld

        * First, extract any special clauses
        m.cWkgExpr = UPPER( ALLTRIM(m.pcExpr) )
        IF ' FOR ' $ m.cWkgExpr
            m.cWkgExpr = LEFT( m.cWkgExpr, AT(' FOR ',m.cWkgExpr)-1 )
        ENDIF
        IF ' UNIQUE' $ m.cWkgExpr
            m.cWkgExpr = LEFT( m.cWkgExpr, AT(' UNIQUE',m.cWkgExpr)-1 )
        ENDIF
        IF ' DESCENDING' $ m.cWkgExpr
            m.cWkgExpr = LEFT( m.cWkgExpr, AT(' DESCENDING',m.cWkgExpr)-1 )
        ENDIF
        IF ' ASCENDING' $ m.cWkgExpr
            m.cWkgExpr = LEFT( m.cWkgExpr, AT(' ASCENDING',m.cWkgExpr)-1 )
        ENDIF

        * Initialize our return field list string
        m.cFldList = ''

        * Now, the expression is of the form:
        *   fld_nm1 + fld_nm2 + fld_nm3 ...
        * So, we have to extract the fields between plus signs.  However, they
        *   could be of the form: UPPER(fld_nm1+fld_nm3) + DTOS(fld_nm3)...
        DO WHILE LEN(m.cWkgExpr) > 0
            m.nX = THIS.AtNotInParen('+', m.cWkgExpr)    && But not within parentheses

            * Extract the field from cWkgExpr
            IF m.nX = 0
                m.cThisFld = m.cWkgExpr
                m.cWkgExpr = ''
            ELSE
                m.cThisFld = TRIM( LEFT(m.cWkgExpr, m.nX-1) )
                m.cWkgExpr = LTRIM( SUBSTR(m.cWkgExpr, m.nX+1) )
            ENDIF

            * Remove any field conversions
            m.cThisFld = THIS.ExtrFldName(m.cThisFld)

            * If we still have a '+' sign in cThisFld, it needs more
            *   processing, so put it back in cWkgExpr.  Otherwise, add it to
            *   our return string
            IF '+' $ m.cThisFld
                m.cWkgExpr = m.cThisFld + m.cWkgExpr
            ELSE
                m.cFldList = m.cFldList + IIF( EMPTY(m.cFldList), '', ',') + m.cThisFld
            ENDIF
        ENDDO
        RETURN m.cFldList
    ENDFUNC

    *- PROT ExtrToken() - Extract and return the text before a passed token (char)
    *     Input: cStrIn - String for extraction (if passed as @cStrIn, the
    *                       fragment and token are really extracted)
    *            cTokenChar - Character separator
    *      Retn: Text in cStrIn before the first cTokenChar
    *     Tests: 1: ExtrToken('AB^CD', '^') --> 'AB'
    *            2: cVar = '123.45'
    *               ExtrToken( @cVar, '.') --> '123'
    *               cVar now = '45'
    *      Note: Was EXTR_TKN
    PROTECTED FUNCTION ExtrToken(m.cStrIn, m.cToken)
        LOCAL cRetTxt, nChrPosn

        * We're passed a block of text (cStrIn) supposedly containing at
        *   least one instance of a character (cToken).  Our job is to
        *   extract and return the text UP TO but not including cToken,
        *   and to remove that text and cToken from cStrIn (will only
        *   work if cStrIn passed as @cStrIn).
        * If the text doesn't have the character, we'll return the full string
        *   and empty out cStrIn.
        m.cRetTxt = ''

        * Look for cToken
        m.nChrPosn = AT(m.cToken, m.cStrIn)

        * If it isn't there, clear cStrIn
        IF m.nChrPosn = 0
            m.cRetTxt = m.cStrIn
            m.cStrIn = ''
        ELSE

            * Get the text to the left of the character
            m.cRetTxt = LEFT(m.cStrIn, m.nChrPosn-1)

            * Remove the text and character from cStrIn
            IF m.nChrPosn+1 > LEN(m.cStrIn)
                m.cStrIn = ''
            ELSE
                m.cStrIn = SUBSTR(m.cStrIn, m.nChrPosn + LEN(m.cToken))
            ENDIF
        ENDIF
        RETURN m.cRetTxt
    ENDFUNC

    *- PROT AtNotInParen() - Return the pos'n of a char NOT within parentheses
    *     Input: cTheChar - The character in question
    *            cTheStr - The string to search
    *      Retn: The position (0 if not there or if only within ())
    *      Note: Was AT_NOPAR
    PROTECTED FUNCTION AtNotInParen( m.pcTheChar, m.pcTheStr )
        RETURN THIS.AtNotInDelim( m.pcTheChar, m.pcTheStr, '()' )
    ENDFUNC

    *- PROT AtNotInDelim() - Return the pos'n of a char NOT within delimeters
    *     Input: cTheChar - The character in question
    *            cTheStr  - The string to search
    *            pcDelim  - The left and right delimeter pair
    *      Retn: The position (0 if not there or if only within ())
    *      Note: Was AT_DELIM
    PROTECTED FUNCTION AtNotInDelim( m.pcTheChar, m.pcTheStr, m.pcDelim )
        LOCAL cRDelim, cLDelim, cWkgStr, cDiscards, nCharPosn, nLPosn, nRPosn, ;
          cLeftSide, cRightSide

        * This function will look for, and return, the position of a character
        *   in a string but NOT within the passed delimiters.
        *            12345678901
        *   Example: ABC(DEF)GFX  For "F", returns 10

        * Delimiters may be passed as one pair rather than 2 separate
        *   characters.  Delimiter pairs can be anything reasonable (except
        *   the character being searched for); for example: "", '', (), {},
        *   [], <>, etc.

        * Return quickly if the character isn't in the string at all
        IF NOT m.pcTheChar $ m.pcTheStr
            RETURN 0
        ENDIF

        * Separate our delimiters
        m.cRDelim = SUBSTR(m.pcDelim, 2)
        m.cLDelim = LEFT(m.pcDelim, 1)

        * Return almost as quickly if the left delimiter isn't in the string --
        *   giving the best answer we can
        IF NOT m.cLDelim $ m.pcTheStr
            RETURN AT(m.pcTheChar,m.pcTheStr)
        ENDIF

        * Now, we know the character is in the string and we DO have
        *   delimiters.  But, we really have 2 routines:
        *       1. If the delimeters are the same
        *       2. If they're different
        IF m.cRDelim = m.cLDelim

            * This is simpler than different delimeters as, by definition,
            *   nested delimeters is a meaningless term
            m.cWkgStr = m.pcTheStr
            m.cDiscards = ''
            m.nCharPosn = 0
            DO WHILE LEN(m.cWkgStr) > 0

                * Find the first instance of left and right delimiters
                m.nLPosn = AT( m.cLDelim, m.cWkgStr )
                m.nRPosn = AT( m.cLDelim, m.cWkgStr, 2 )

                * Find the first instance of our character
                m.nCharPosn = AT(m.pcTheChar,m.cWkgStr)

                * Possibilities
                *   1. nCharPosn = 0 -- just return 0 because it was only
                *       in the string inside of delimiters
                IF m.nCharPosn = 0
                    RETURN 0
                ENDIF

                *   2. nCharPosn < nLPosn -- return nCharPosn + cDiscards length
                IF m.nCharPosn < m.nLPosn OR m.nLPosn = 0 OR m.nRPosn = 0 OR m.nRPosn < m.nLPosn
                    RETURN m.nCharPosn + LEN(m.cDiscards)
                ENDIF

                *   3. nCharPosn < nRPosn -- doesn't count as it's within the
                *       delimeters
                *   4. nCharPosn > nRPosn -- indeterminate as that might be within
                *       a later set of delimeters
                * Put everything up to and including the right position into Discards
                m.cDiscards = m.cDiscards + LEFT( m.cWkgStr, m.nRPosn )
                IF m.nRPosn = LEN(m.cWkgStr)
                    m.cWkgStr = ''
                ELSE
                    m.cWkgStr = SUBSTR(m.cWkgStr, m.nRPosn+1 )
                ENDIF
            ENDDO   && WHILE LEN(cWkgStr) > 0
        ELSE    && Delimiters are different

            * The tricky part with different delimiters is that the delimiters might
            *   be nested.
            m.cWkgStr = m.pcTheStr
            m.cDiscards = ''
            m.nCharPosn = 0
            DO WHILE LEN(m.cWkgStr) > 0

                * Find the first instances of left and right delimiters
                m.nLPosn = AT( m.cLDelim, m.cWkgStr )
                m.nRPosn = AT( m.cRDelim, m.cWkgStr )

                * Find the first instance of our character
                m.nCharPosn = AT(m.pcTheChar,m.cWkgStr)

                * Possibilities
                *   1. nCharPosn = 0 -- just return 0 because it was only
                *       in the string inside of delimiters
                *   2. nCharPosn < nLPosn -- return nCharPosn + cDiscards length
                *   3. Delimeters don't match:  i.e. just "(" or just ")" --
                *       by definition, the character isn't within nested parens, so
                *       return nCharPosn + cDiscards length
                *   4. nCharPosn > nRPosn -- indeterminate yet until we extract nested
                *       delimiters
                IF m.nCharPosn = 0
                    RETURN 0
                ENDIF
                IF m.nCharPosn < m.nLPosn OR m.nLPosn = 0 OR m.nRPosn = 0 OR m.nRPosn < m.nLPosn
                    RETURN m.nCharPosn + LEN(m.cDiscards)
                ENDIF

                *   3. nCharPosn > nRPosn -- indeterminate yet until we extract nested
                *       delimiters
                m.nLPosn = RAT( m.cLDelim, LEFT(m.cWkgStr,m.nRPosn) )        && Match right paren

                * Save that which we are about to extract
                m.cDiscards = m.cDiscards + SUBSTR( m.cWkgStr, m.nLPosn, m.nRPosn-m.nLPosn+1 )

                * Extract the nested parenthesis
                m.cLeftSide = IIF( m.nLPosn=1, '', LEFT(m.cWkgStr,m.nLPosn-1) )
                m.cRightSide = IIF( m.nRPosn=LEN(m.cWkgStr), '', SUBSTR(m.cWkgStr,m.nRPosn+1) )
                m.cWkgStr = m.cLeftSide + m.cRightSide

                * Reset for our loop
                m.nCharPosn = 0
            ENDDO   && WHILE LEN(cWkgStr) > 0
        ENDIF

        * Done
        RETURN m.nCharPosn + LEN(m.cDiscards)
    ENDFUNC

    *- ExtrFldName() - Extract the first field name from an expression
    *     Input: cExpr - String for extraction
    *      Retn: Extracted field name
    *      Note: Was EXTRFNAM
    FUNCTION ExtrFldName(cExpr)
        LOCAL cRetName, nX, nY

        * Expressions can have the form:
        *   Character fields: field or UPPER(field) or LEFT(field,n)
        *        Date fields: DTOS(field)
        *     Numeric fields: STR(field,len,dec) or STR(INT(field+str),len,dec)
        *     Logical fields: IIF(field,'Y','N')
        * Conditional fields: IIF(EMPTY(field),expr1,DTOS(date))
        *                 or: IIF(field='A',uvw,xyz)
        m.cRetName = m.cExpr

        * In most cases, we'll:
        *   A. Throw away whatever's to the left of any '('
        *   B. Throw away whatever's to the right of any ')'
        * But, notice that the conditional expression has some special problems:
        *   1st () removal --> EMPTY(field),expr1,DTOS(date)
        *   2nd () removal --> field),expr1,DTOS(date
        *   3rd () removal --> ''
        DO WHILE '(' $ m.cRetName
            m.nX = AT('(', m.cRetName)
            m.nY = RAT(')', m.cRetName)
            IF m.nY > m.nX
                m.cRetName = SUBSTR( m.cRetName, m.nX+1, m.nY-m.nX-1)
            ELSE

                * nY < nX: field),expr1,DTOS(date  ... so throw away all to the right
                *   of ")"
                m.cRetName = LEFT(m.cRetName, m.nY-1)
            ENDIF
        ENDDO

        *   C. Remove any rightmost portions after commas
        DO WHILE ',' $ m.cRetName
            m.nY = RAT(',', m.cRetName)
            m.cRetName = LEFT(m.cRetName, m.nY-1)
        ENDDO

        *   D. Remove any rightmost portions after the equals sign
        DO WHILE '=' $ m.cRetName
            m.nY = RAT('=', m.cRetName)
            m.cRetName = LEFT(m.cRetName, m.nY-1)
        ENDDO

        * Done
        RETURN m.cRetName
    ENDFUNC

    *- Error() - Handle/pass up any errors
    PROCEDURE Error()
        LPARAMETERS nError, cMethod, nLine
        LOCAL aErrInfo[7], cMethName, cSys16, cCmd, oParent, bGotGlobal, ;
          cAction, cHndlCmd, nChoice

        * Get the error info and define stuff about ourselves
        AERROR(aErrInfo)
        m.cMethName = THIS.Name + '.' + m.cMethod
        m.cSys16 = SYS(16)
        m.cCmd = MESSAGE(1)

        * First, do we have a parent?
        m.oParent = NULL
        IF PEMSTATUS(THIS, [Parent], 5) AND TYPE([THIS.Parent]) = [O] AND ;
          PEMSTATUS(THIS.Parent, [Error], 5)
            m.oParent = THIS.Parent
        ENDIF

        * Now, register the error if we have a global handler
        m.bGotGlobal = .F.
        IF TYPE('goError.Name') = 'C'
            goError.RegisterError(m.nError, m.cMethName, m.nLine, @m.aErrInfo, m.cSys16, ;
              THIS)
            m.bGotGlobal = .T.
        ENDIF

        * Handle this error as best we can after assuming our return action
        m.cAction = 'RETURN'
        DO CASE

        * First, try the parent
        CASE NOT ISNULL(m.oParent)
            m.cAction = m.oParent.Error(m.nError, m.cMethName, m.nLine)

        * Next, the global error handling object
        CASE m.bGotGlobal
            m.cAction = goError.HandleError(m.nError, m.cMethName, m.nLine, @m.aErrInfo, ;
              m.cSys16, THIS)

        * There may be some other global error handler.  So give it what it
        *   wants.  Caution: It may be called as a function or with a DO
        CASE NOT EMPTY( ON('ERROR') )
            m.cHndlCmd = UPPER(ON('ERROR') )
            m.cHndlCmd = STRTRAN( STRTRAN( STRTRAN( STRTRAN( STRTRAN( m.cHndlCmd, ;
              'PROGRAM()', '"' + m.cMethName + '"'), ;
              'ERROR()',   'nError'), ;
              'LINENO()',  'nLine'), ;
              'MESSAGE()', 'aErrInfo[2]'), ;
              'SYS(2018)', 'aErrInfo[3]')
            IF LEFT(m.cHndlCmd, 3) = [DO ]
                &cHndlCmd
            ELSE
                m.cAction = &cHndlCmd
            ENDIF
        OTHERWISE

            * Nothing else left to do.  Ask if they want to Continue, Cancel or
            *   get the debugger; this must only happen in test.  The
            *   parameter MB_YESNOCANCEL = 3 + MB_ICONSTOP = 16 = 19
            m.nChoice = MESSAGEBOX('Error #: ' + LTRIM(STR(m.nError)) + CHR(13) + ;
              'Message: ' + m.aErrInfo[2] + CHR(13) + ;
              'Line: ' + LTRIM(STR(m.nLine)) + CHR(13) + ;
              'Code: ' + m.cCmd + CHR(13) + ;
              'Method: ' + m.cMethName + CHR(13) + ;
              'Object: ' + THIS.Name + CHR(13) + CHR(13) + ;
              'Choose Yes to display the debugger, No to ' + ;
              'Continue without the debugger, or Cancel to ' + ;
              'cancel execution', 19, _VFP.Caption)

            * If we're to debug, do it here and set for RETURN
            DO CASE
            CASE m.nChoice = 6            && IDYES
                m.cAction = [RETURN]
                DEBUG
                SUSPEND
            CASE m.nChoice = 7            && IDNO
                m.cAction = [RETURN]
            CASE m.nChoice = 2            && IDCANCEL
                m.cAction = [CANCEL]
            ENDCASE
        ENDCASE

        * Handle the return value but check the hierarchy first
        DO CASE
        CASE '.' $ m.cMethName
            RETURN m.cAction              && Calling method
        CASE m.cAction = 'CLOSEFORM'
            THISFORM.Release()
        CASE NOT EMPTY(m.cAction)         && RETURN, RETRY, CANCEL
            &cAction                    && Do it
        ENDCASE
        RETURN                          && What else?
    ENDPROC

    *- Destroy() - Kill our contents
    PROCEDURE Destroy()
        LOCAL nX

        * Kill any objects we added
        FOR m.nX = THIS.ControlCount TO 1 STEP -1
            DO CASE
            CASE ISNULL( THIS.Controls[m.nX] )
                RELEASE THIS.Controls[m.nX]
            CASE PEMSTATUS(THIS.Controls[m.nX], 'Release', 5)
                THIS.Controls[m.nX].Release()
            OTHERWISE
                THIS.Controls[m.nX].Destroy()
                RELEASE (THIS.Controls[m.nX].Name)
            ENDCASE
        ENDFOR
        DODEFAULT()
    ENDPROC

    *- Release() - Remove this object from memory
    PROCEDURE Release()
        THIS.Destroy()
        Release THIS
    ENDPROC
ENDDEFINE

*   DirArray Class (parent ArrayObj) - loads array with files matching file spec
DEFINE CLASS DirArray AS ArrayObj

    * Array structure definition
    *   .aRA[x,1] - File name (C) (includes extension)
    *   .aRA[x,2] - File size (N):
    *   .aRA[x,3] - File date (D)
    *   .aRA[x,4] - File Time (C)
    *   .aRA[x,5] - File Attributes (C):

    * Standard Properties
    Name = 'DirArray'

    * All ArrayObj properties are the same, but we'll add the file spec
    cFileSpec = ''
    cDirAttr = ''
    nCaseFlag = 0               && VFP's default = 0; make filenames uppercase

    * Custom Method List:
    *- Init() - Initialize our array object
    *- Dir2Array() - Create an array of files matching a passed filespec
    *- AddExts() - Add more files to the array for different extensions
    *- DeleteExts() - Delete all files matching the passed extensions
    *- DeleteFiles() - Remove all files matching the passed list

    * Custom Method Code:

    *- Init() - Initialize our array object
    *     Parameters: cFileSpec [, cAttrib [, cKeepCase]]
    *     Notes: This creates an array of the files matching cFileSpec.  The
    *             array is automatically sized as needed.
    FUNCTION Init(cSpec, cAttr, bKeepCase)

        * Do the default Init() for 5 columns
        IF NOT DODEFAULT(5)
            RETURN .F.
        ENDIF

        * Load the array based on the passed file spec
        THIS.Dir2Array(m.cSpec, m.cAttr, m.bKeepCase)
        NODEFAULT
        RETURN .T.
    ENDFUNC

    *- Dir2Array() - Create an array of files matching a passed filespec
    *     Parameters: cFileSpec [, cAttrib [, cKeepCase]]
    *     Returns: The number of files found (if 0, THIS.nRows will be 1)
    *     Notes: 1. If called directly, the array must have been initialized
    *                first, but rows and columns may be changed here.
    *            2. Attributes are (also see notes below):
    *                A - Archive (Read and Write), H - Hidden, R - Read only,
    *                S - System, D - Directory, V - Volume Label
    FUNCTION Dir2Array(cDirSpec, cDirAttr, bKeepCase)
        LOCAL nFileCnt, nW, nCase

        * cDirSpec notes - This is any normal DOS file spec (e.g. "*.*") and
        *   it can include drive and directory paths.  However, if cDirSpec
        *   is a null string (and the appropriate attribute letters have also
        *   been sent (see below), you will ONLY get Directory names, Hidden
        *   files or System files.

        * cDirAttr Attribute notes - Generally, this function will return
        *   a list of all files, including Read-Only files, matching
        *   cDirSpec.  If that's all you want, don't use the cDirAttr
        *   parameter.
        * But, for Hidden, System or Directories, use any combination of the
        *   following letters:
        *       Letter        Attribute
        *       컴컴컴        컴컴컴컴�
        *         H            Hidden
        *         S            System
        *         D            Directory
        *   For example, using "HS" would include all Hidden and System files
        *   (in addition to the regular files) but would not include
        *   Directories.
        * For Volume Labels, use only:
        *       Letter        Attribute
        *       컴컴컴        컴컴컴컴�
        *         V            Volume Label
        *   (other letters with "V" will be ignored).

        * bKeepCase notes - By default, VFP converts all filenames into
        *   uppercase. This optional flag allows keeping the current case
        *   used in naming the file.

        * Set our name case flag for ADIR()
        IF PCOUNT() = 3 AND VARTYPE(m.bKeepCase) = 'L'
            THIS.nCaseFlag = IIF(m.bKeepCase, 1, 0)
        ENDIF

        * We'll use ADIR() to get the directory info, it will automatically
        *   adjust the size of the array.  But, reset it to 1 row and 5
        *   columns first.
        IF THIS.nCols < 5
            THIS.InsertCols(5 - THIS.nCols)
        ENDIF
        IF THIS.nRows > 0
            THIS.ZapArray()
        ENDIF

        * Save this file spec
        THIS.cFileSpec = m.cDirSpec

        * We may not have an attribute parameter
        IF TYPE('cDirAttr') = 'C'
            m.nFileCnt = ADIR(THIS.aRA, m.cDirSpec, m.cDirAttr, THIS.nCaseFlag)
            THIS.cDirAttr = m.cDirAttr
        ELSE
            m.nFileCnt = ADIR(THIS.aRA, m.cDirSpec, '', THIS.nCaseFlag)
        ENDIF

        * Our structure is:
        *   .aRA[x,1] - File name (C) (includes extension)
        *   .aRA[x,2] - File size (N):
        *   .aRA[x,3] - File date (D)
        *   .aRA[x,4] - File Time (C)
        *   .aRA[x,5] - File Attributes (C):
        *         Letter        Attribute
        *         컴컴컴        컴컴컴컴�
        *           A            Archive (Read and Write)
        *           H            Hidden
        *           R            Read only
        *           S            System
        *           D            Directory
        *       These may be combined.

        * Do some tweaking of the results
        THIS.nRows = m.nFileCnt
        IF m.nFileCnt > 0

            * Clean up time and attributes
            FOR m.nW = 1 TO m.nFileCnt

                * Time can have spaces for AM hours
                IF ' ' $ THIS.aRA[m.nW,4]
                    THIS.aRA[m.nW,4] = STRTRAN(THIS.aRA[m.nW,4], ' ', '0')
                ENDIF

                * Attributes come in a form of ".A..."; get rid of the periods
                THIS.aRA[m.nW,5] = ALLTRIM( STRTRAN( THIS.aRA[m.nW,5], '.', '') )
            ENDFOR
        ELSE

            * Make sure each column is the right data type
            WITH THIS
                IF VARTYPE( .aRA[1,1] ) <> 'C'
                    .aRA[1,1] = ''
                ENDIF
                IF VARTYPE( .aRA[1,2] ) <> 'N'
                    .aRA[1,2] = 0
                ENDIF
                IF VARTYPE( .aRA[1,3] ) <> 'D'
                    .aRA[1,3] = {}
                ENDIF
                IF VARTYPE( .aRA[1,4] ) <> 'C'
                    .aRA[1,4] = ''
                ENDIF
                IF VARTYPE( .aRA[1,5] ) <> 'C'
                    .aRA[1,5] = ''
                ENDIF
            ENDWITH
        ENDIF

        * Done
        RETURN m.nFileCnt
    ENDFUNC

    *- AddExts() - Add more files to the array for different extensions
    *     Parameters: cExtList - Comma-delimited list of file extensions to
    *                               add to the array.  Example:
    *                               "FXP,PRG,TXT" - NO SPACES
    *     Returns: The total number of files in the array
    FUNCTION AddExts(cExtList)
        LOCAL cFileSpec, cDirAttr, cExts2Do, nPosn, cExt, nFileCnt, nOldRows, ;
          nX, cTime
        LOCAL aTemp[1]

        * We're passed a comma-delimeted list of file extensions.  We're to
        *   add any new files to our array having those extensions
        WITH THIS
            m.cFileSpec = .cFileSpec
            m.cDirAttr = .cDirAttr
            m.cExts2Do = ALLTRIM(m.cExtList)
            DO WHILE NOT EMPTY(m.cExts2Do)

                * Get this extension
                m.nPosn = AT([,], m.cExts2Do)
                IF m.nPosn = 0
                    m.cExt = m.cExts2Do
                    m.cExts2Do = []
                ELSE
                    m.cExt = LEFT(m.cExts2Do, m.nPosn-1)
                    m.cExts2Do = SUBSTR(m.cExts2Do, m.nPosn+1)
                ENDIF

                * Get an array of these files
                m.cFileSpec = FORCEEXT(m.cFileSpec, m.cExt)
                IF NOT EMPTY(m.cDirAttr)
                    m.nFileCnt = ADIR(aTemp, m.cFileSpec, m.cDirAttr, THIS.nCaseFlag)
                ELSE
                    m.nFileCnt = ADIR(aTemp, m.cFileSpec, '', THIS.nCaseFlag)
                ENDIF

                * Re-dimension our array
                IF m.nFileCnt > 0
                    m.nOldRows = .nRows
                    .nRows = m.nOldRows + m.nFileCnt
                    DIMENSION .aRA(.nRows, 5)

                    * Now, clean up each row as we put it in the array
                    FOR m.nX = 1 TO m.nFileCnt

                        * Time needs special handling
                        m.cTime = m.aTemp[m.nX,4]
                        IF ' ' $ m.cTime
                            m.cTime = STRTRAN(m.cTime, ' ', '0')
                        ENDIF

                        * Add this to our array
                        m.nRow = m.nX + m.nOldRows
                        .aRA[m.nX,1] = m.aTemp[m.nX,1]
                        .aRA[m.nX,2] = m.aTemp[m.nX,2]
                        .aRA[m.nX,3] = m.aTemp[m.nX,3]
                        .aRA[m.nX,4] = m.cTime
                        .aRA[m.nX,5] = ALLTRIM( STRTRAN( m.aTemp[m.nX,5], '.', '') )
                    ENDFOR
                ENDIF

                * Next extension
            ENDDO
        ENDWITH

        * Done
        RETURN THIS.nRows
    ENDFUNC

    *- DeleteExts() - Remove all files matching the passed extensions
    *     Parameters: cExtList - Comma-delimited list of file extensions to
    *                               remove from the array.  Example:
    *                               "FXP,PRG,TXT" - NO SPACES
    *     Returns: The number of files removed from the array
    FUNCTION DeleteExts(cExtList)
        LOCAL nCnt, nZ, cExt

        * We're passed a comma-delimeted list of file extensions.  We're to
        *   remove all files in our array having those extensions.
        m.nCnt = 0
        m.cExtList = ',' + UPPER(m.cExtList) + ','
        WITH THIS
            FOR m.nZ = .nRows TO 1 STEP -1
                m.cExt = ',' + UPPER( TRIM(JUSTEXT( .aRA[m.nZ,1] ))) + ','
                IF m.cExt $ m.cExtList
                    .DeleteRow(m.nZ)
                    m.nCnt = m.nCnt + 1
                ENDIF
            ENDFOR
        ENDWITH

        * Done
        RETURN m.nCnt
    ENDFUNC

    *- DeleteFiles() - Remove all files matching the passed list
    *     Parameters: cFileList - Comma-delimited list of file names to remove
    *                               from the array.  Example:
    *                               "JUNK.TXT,TEMP.DBF"
    *     Returns: The number of files removed from the array
    FUNCTION DeleteFiles(cFileList)
        LOCAL nCnt, nZ, cFile

        * We're passed a comma-delimeted list of files.  We're to remove
        *   those from our array.
        m.nCnt = 0
        m.cFileList = ',' + UPPER(m.cFileList) + ','
        WITH THIS
            FOR m.nZ = .nRows TO 1 STEP -1
                m.cFile = ',' + UPPER( TRIM(.aRA[m.nZ,1] )) + ','
                IF m.cFile $ m.cFileList
                    .DeleteRow(m.nZ)
                    m.nCnt = m.nCnt + 1
                ENDIF
            ENDFOR
        ENDWITH

        * Done
        RETURN m.nCnt
    ENDFUNC
ENDDEFINE

*   FileLines Class - Array object from lines in a file or text string
DEFINE CLASS FileLines AS ArrayObj

    * This is a fast ArrayObj that reads all of the lines in a file into a
    *   single column array. The default line terminator is CR_LF; whatever
    *   terminator is used, it is removed from the line upon loading.

    * Standard Properties
    Name = 'cusFileLines'

    * Line Terminator (removed from line in array)
    cLineEnd = CR_LF
    cFileName = ''

    * Custom Method List
    *- Init() - Initialize our array object
    *- File2Array() - Load the array from the passed memo string
    *- String2Array() - Load the passed string into the array

    * Custom Method Code:

    *- Init() - Initialize our array object
    *   Parameters: cFileOrStr[, cLineEnd[, bIsString]]
    FUNCTION Init(cFileOrStr, cLineEnd, bIsString)
        IF NOT DODEFAULT(1)
            RETURN .F.
        ENDIF

        * Redefine our line terminator if appropriate
        IF TYPE('cLineEnd') = 'C' AND LEN(m.cLineEnd) = 1
            THIS.cLineEnd = m.cLineEnd
        ENDIF

        * Load the array from the passed string (if available)
        DO CASE
        CASE PCOUNT() < 3 AND NOT EMPTY(m.cFileOrStr)
            THIS.File2Array(m.cFileOrStr)
        CASE PCOUNT() = 3 AND m.bIsString
            THIS.String2Array(m.cFileOrStr)
        ENDCASE
        RETURN .T.
    ENDFUNC

    *- File2Array() - Load the array from the tokenized string
    FUNCTION File2Array(cFileNm)
        LOCAL cText

        * Save the file name property and get the file's contents
        THIS.cFileName = m.cFileNm
        m.cText =  FILETOSTR(m.cFileNm)
        RETURN THIS.String2Array(m.cText)
    ENDFUNC

    *- String2Array() - Load the passed string into the array
    FUNCTION String2Array(cTextIn)

        * The reason that this is so fast is because it uses VFP's ALINES()
        IF THIS.cLineEnd = CR_LF
            THIS.nRows = ALINES(THIS.aRA, m.cTextIn)
        ELSE
            THIS.nRows = ALINES(THIS.aRA, m.cTextIn, .F., THIS.cLineEnd)
        ENDIF

        * Done
        RETURN THIS.nRows
    ENDFUNC
ENDDEFINE

*   StringArray Class - Array object from a string list
DEFINE CLASS StringArray AS ArrayObj

    * Standard Properties
    Name = 'cusStringArray'

    * This is an ArrayObj that can be loaded from a string (one element/row
    *   per token).  It can also regenerate the string.

    * All ArrayObj properties are the same, but we need to define our token
    cToken = '^'        && Default

    * Custom Method List
    *- Init() - Initialize our array object
    *- String2Array() - Load the array from the tokenized string
    *- Join() - Create a tokenized string from the array
    *- Array2String() - Create a tokenized string from the array

    * Custom Methods:

    *- Init() - Initialize our array object
    *   Parameters: cString [, cToken]
    FUNCTION Init(cString, cToken)

        * Do the default Init() for 1 column
        IF NOT DODEFAULT(1)
            RETURN .F.
        ENDIF

        * Redefine our token if appropriate
        IF TYPE('cToken') = 'C' AND BETWEEN(LEN(m.cToken), 1, 2)
            THIS.cToken = m.cToken
        ENDIF

        * Load the array from the passed string
        THIS.String2Array(m.cString)
        NODEFAULT
        RETURN .T.
    ENDFUNC

    *- String2Array() - Load the array from the tokenized string
    FUNCTION String2Array( cStrIng )
        LOCAL cString, nRowsDone, cThisItem

        * THIS.cToken already has the token we'll use
        m.cString = m.cStrIng
        m.nRowsDone = 0
        DO WHILE NOT EMPTY(m.cString)
            m.cThisItem = THIS.ExtrToken( @m.cString, THIS.cToken )

            * If the row already exists, just change it; else add it
            IF THIS.nRows <= m.nRowsDone
                THIS.AddRow( m.cThisItem )
            ELSE
                THIS.aRA[m.nRowsDone+1] = m.cThisItem
            ENDIF
            m.nRowsDone = m.nRowsDone + 1
        ENDDO

        * If there are more rows, delete them
        DO WHILE THIS.nRows > m.nRowsDone
            THIS.DeleteRow( THIS.nRows )
        ENDDO

        * Done
    ENDFUNC

    *- Join() - Create a tokenized string from the array
    *   Inputs: cSeparator - Separator between items, can be > 1 char (default
    *               = THIS.cToken)
    FUNCTION Join(cSeparator)
        LOCAL cStr
        m.cStr = THIS.Array2String(m.cSeparator)
        RETURN m.cStr
    ENDFUNC

    *- Array2String() - Create a tokenized string from the array
    *   Inputs: cPicture - Optional, used with TRANSFORM() to generate output
    *           cSeparator - Separator between items, can be > 1 char (default
    *               = THIS.cToken)
    FUNCTION Array2String(cPicture, cSeparator)
        LOCAL cString, nX

        * Make sure we use the right separator
        m.cSep = THIS.cToken
        IF TYPE('cSeparator') = 'C' AND NOT EMPTY(m.cSeparator)
            m.cSep = m.cSeparator
        ENDIF

        * Define the picture
        m.cPic = ''
        IF TYPE('cPicture') = 'C'
            m.cPic = m.cPicture
        ENDIF

        * Generate the string
        m.cString = ''
        FOR m.nX = 1 TO THIS.nRows

            * Define our item (apply the picture if we have one)
            IF EMPTY(m.cPic)
                m.cThisItem = THIS.aRA[m.nX]
            ELSE
                m.cThisItem = TRANSFORM( THIS.aRA[m.nX], m.cPic )
            ENDIF

            * Preface this item with the separator if it's not item #1
            IF m.nX > 1
                m.cString = m.cString + m.cSep + m.cThisItem
            ELSE
                m.cString = m.cString + m.cThisItem
            ENDIF
        ENDFOR

        * Done
        RETURN m.cString
    ENDFUNC
ENDDEFINE

*   MemoArray Class - Array Object for formatting blocks of text
DEFINE CLASS MemoArray AS ArrayObj

    * Standard Properties
    Name = 'cusMemoArray'

    * This is an ArrayObj that can be loaded from any text as:
    *   oObj.aRA[x,1] - The line no longer than THIS.nLineWidth
    *   oObj.aRA[x,2] - .T. if the line was terminated with a CR_LF (hard)
    * This can also regenerate the memo.

    * All ArrayObj properties are the same, but we need to define our token
    nLineWidth = 80             && MEMOWIDTH for this object

    * Custom Method List
    *- Init(cMemoStr, nLineWidth) - Initialize our array object
    *- Memo2Array() - Load the array from the passed memo string
    *- SplitString() - Split the passed string to the desired length
    *- Array2Memo() - Create a memo string from the array
    *- ChangeLeftMargin() - Change the left margin of the current text
    *- GetLeftMargin() - Return the current left margin of the text

    * Custom Methods:

    *- Init() - Initialize our array object
    FUNCTION Init(cMemoStr, nLineWidth)

        * Do the default Init() for 2 columns
        IF NOT DODEFAULT(2)
            RETURN .F.
        ENDIF

        * Define our line width
        IF TYPE('nLineWidth') = 'N' AND m.nLineWidth > 10
            THIS.nLineWidth = m.nLineWidth
        ELSE
            m.nLineWidth = SET('MEMOWIDTH')
            IF m.nLineWidth > 10
                THIS.nLineWidth = m.nLineWidth
            ENDIF
        ENDIF

        * Load the array from the passed memo
        THIS.Memo2Array(m.cMemoStr)
        NODEFAULT
        RETURN .T.
    ENDFUNC

    *- Memo2Array() - Load the array from the passed string
    FUNCTION Memo2Array( cStrIng )
        LOCAL aMemoLns[1], nLines, nMaxLen, nX, cLine2Do, cLine
        PRIVATE vbHardCR

        * Ignore empty incoming strings
        IF NOT EMPTY(m.cStrIng)

            * This process uses ALINES() to get each line from the memo into an
            *   array very quickly.  But, that ignores the line length; so, for
            *   longer lines, we'll still have to split them.  (This scheme proved
            *   to be 28% faster than just always calling SplitString() for the
            *   entire memo.

            * Put this into a separate array
            m.nLines = ALINES(aMemoLns, m.cStrIng)

            * Go convert the entire memo
            m.nMaxLen = THIS.nLineWidth
            FOR m.nX = 1 TO m.nLines
                m.cLine2Do = m.aMemoLns[m.nX]
                IF LEN(m.cLine2Do) <= m.nMaxLen
                    THIS.AddRow(m.cLine2Do, .T.)
                ELSE

                    * Split this line
                    DO WHILE NOT EMPTY(m.cLine2Do)

                        * Extract the next line
                        m.vbHardCR = .F.
                        m.cLine = THIS.SplitString( @m.cLine2Do )

                        * Add this to our memo
                        THIS.AddRow(m.cLine, m.vbHardCR)
                    ENDDO
                ENDIF
            ENDFOR
        ENDIF

        * We're done
        RETURN THIS.nRows
    ENDFUNC

    *- SplitString() - Split the passed string to the desired length
    FUNCTION SplitString( cStrIn )
        LOCAL cStrOut, cWhiteSpace, nSplitPoint

        * Parameter Notes:
        *       cStrIn - The input string to be split (passed as @cStrIn)
        * Operations:
        *       cStrIn is split on spaces as close to THIS.nLineWidth as
        *           possible (if there are no spaces, it's just chopped).
        * Returned values:
        *       cStrOut - Returned as the leftmost part of cStrIn after split
        *       cStrIn - LTRIMmed remainder of cStrIn after split (only if
        *           passed as @cStrIn)
        *       vbHardCR - Must be PRIVATE, set based on split type

        * Initialize our return string
        m.cStrOut = ''
        IF VARTYPE(m.vbHardCR) = 'U'
            PRIVATE vbHardCR
            m.vbHardCR = .F.
        ENDIF

        * We may have nothing to do
        IF LEN(m.cStrIn) <= THIS.nLineWidth AND NOT HEX_FF $ m.cStrIn
            m.cStrOut = m.cStrIn
            m.cStrIn = ''
            RETURN m.cStrOut
        ENDIF

        * Define what whitespace looks like
        m.cWhiteSpace = TAB + CR + LF + HEX_FF

        * Look for the first HEX_FF character.  If that's before
        *   THIS.nLineWidth, extract the string and return.
        m.nSplitPoint = AT( HEX_FF, m.cStrIn )
        IF BETWEEN( m.nSplitPoint, 1, THIS.nLineWidth)
            m.vbHardCR = .T.
            m.cStrOut = TRIM( LEFT(m.cStrIn, m.nSplitPoint-1) )
            m.cStrIn = SUBSTR(m.cStrIn, m.nSplitPoint+1)
            DO WHILE RIGHT( m.cStrOut, 1) $ m.cWhiteSpace
                m.cStrOut = LEFT(m.cStrOut, LEN(m.cStrOut)-1)
            ENDDO
        ELSE

            * Otherwise, find the first space character starting at
            *   THIS.nLineWidth and working backwords.
            m.nSplitPoint = RAT(' ', LEFT(m.cStrIn, THIS.nLineWidth) )

            * If we didn't find any spaces, just chop it
            IF m.nSplitPoint = 0
                m.cStrOut = LEFT(m.cStrIn,THIS.nLineWidth)
                m.cStrIn = SUBSTR(m.cStrIn,THIS.nLineWidth+1)
            ELSE

                * We got a split point, use it
                m.cStrOut = TRIM( LEFT(m.cStrIn,m.nSplitPoint) )
                m.cStrIn = SUBSTR(m.cStrIn,m.nSplitPoint+1)
                DO WHILE RIGHT( m.cStrOut, 1) $ m.cWhiteSpace
                    m.cStrOut = LEFT(m.cStrOut, LEN(m.cStrOut)-1)
                ENDDO
            ENDIF
        ENDIF

        * Return our result
        RETURN m.cStrOut
    ENDFUNC

    *- Array2Memo() - Create a memo string from the array
    FUNCTION Array2Memo( bUseCRLFs )
        LOCAL cRetMemo, nX

        * This will recreate the memo string from the array.
        * If bUseCRLFs = .T., it will use CR_LFs as all line separators
        * Else, it will add either a space or a CR_LF between lines based
        *   on the orginal settings for the memo.
        m.cRetMemo = ''
        FOR m.nX = 1 TO THIS.nRows

            * Add a space or CR_LF as needed
            IF m.nX > 1
                IF m.bUseCRLFs OR THIS.aRA[m.nX-1,2]
                    m.cRetMemo = m.cRetMemo + CR_LF
                ELSE
                    m.cRetMemo = m.cRetMemo + ' '
                ENDIF
            ENDIF

            * Now, add the line
            m.cRetMemo = m.cRetMemo + THIS.aRA[m.nX,1]
        ENDFOR
        RETURN m.cRetMemo
    ENDFUNC

    *- ChangeLeftMargin() - Change the left margin of the current text
    PROCEDURE ChangeLeftMargin(nNewLMarg, bTossLast)
        LOCAL cText, nMargNow, cAdd, nX, nNewPosn

        * Inputs:
        *   nNewLMarg - Desired new margin
        *   bTossLast - If .T. and the last line is empty, it will be deleted
        * Note: No text is thrown away (see bTossLast for the one exception).
        *       This will first determine the existing left margin and then
        *       add or remove spaces as needed.

        * Toss the last row if we're supposed to and it's empty
        m.cText = THIS.aRA[THIS.nRows,1]
        IF m.bTossLast AND EMPTY(m.cText)
            THIS.DeleteRow(THIS.nRows)
        ENDIF

        * Get the existing left margin
        m.nMargNow = THIS.GetLeftMargin()

        * Now change the margin as appropriate
        WITH THIS
            DO CASE
            CASE m.nMargNow < m.nNewLMarg           && Add spaces
                m.cAdd = SPACE(m.nNewLMarg - m.nMargNow)
                FOR m.nX = 1 TO THIS.nRows
                    IF NOT EMPTY(.aRA[m.nX,1])         && Ignore empty rows
                        .aRA[m.nX,1] =  m.cAdd + .aRA[m.nX,1]
                    ENDIF
                ENDFOR
            CASE m.nMargNow > m.nNewLMarg           && Remove spaces

                * 1234567890                    WANT = 2
                *      Text starts here         OLD = 5
                *   Text starts here            NEW = 2 = SUBSTR(OLD, 3)
                m.nNewPosn = (m.nMargNow - m.nNewLMarg + 1)
                FOR m.nX = 1 TO THIS.nRows
                    IF NOT EMPTY(.aRA[m.nX,1])         && Ignore empty rows
                        .aRA[m.nX,1] =  SUBSTR(.aRA[m.nX,1], m.nNewPosn)
                    ENDIF
                ENDFOR
            ENDCASE
        ENDWITH
        RETURN
    ENDPROC

    *- GetLeftMargin() - Return the current left margin of the text
    FUNCTION GetLeftMargin()
        LOCAL nMarg, nRow, cText, nThisMarg
        m.nMarg = 1000
        WITH THIS
            FOR m.nRow = 1 TO .nRows
                m.cText = .aRA[m.nRow,1]
                IF EMPTY(m.cText)         && Ignore empty rows
                    LOOP
                ENDIF
                m.nThisMarg = AT(LTRIM(m.cText), m.cText) - 1
                IF m.nThisMarg < m.nMarg
                    m.nMarg = m.nThisMarg
                    IF m.nMarg = 0
                        EXIT
                    ENDIF
                ENDIF
            ENDFOR
        ENDWITH
        RETURN m.nMarg
    ENDFUNC
ENDDEFINE
