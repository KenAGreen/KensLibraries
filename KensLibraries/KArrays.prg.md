# <center>KArrays.prg - Array Object for VFP</center>

1. [Introduction](#introduction)
2. [Commonly Used Methods](#commonly-used-methods)
3. [Special Functions](#special-functions)
4. [Other Array Objects](#other-array-objects)
5. [Test Program](#test-program)

### Introduction

Arrays are incredibly useful, but sometimes they can require a lot of work. For example, adding a new row to an existing array of 4 columns requires:
```foxpro
nRows = ALEN(aMyArray,1) + 1
DIMENSION aMyArray[nRows, 4]
aMyArray[nRows,1] = 'A'
aMyArray[nRows,2] = 456
aMyArray[nRows,3] = .F.
aMyArray[nRows,4] = 8.500
```

I've found that using kArrays.prg, there is a simpler way for an existing array object:
```foxpro
oMyArray.AddRow('A', 456, .F., 8.500)
```

Or, you've forgotten how to find out the number of rows or columns in the array so you have to look up VFP's help. Instead, you could easily do this:
```foxpro
? oMyArray.nRows
? oMyArray.nCols
```

Maybe you're passed a multi-column array and want to add another column. Beware: VFP rarely gets this right but with an array object you can do this reliably:
```foxpro
oMyArray.InsertCols(nNumNewCols)
```

Creating an array object is trivial - assuming KArrays.prg is in SET('Proc'):
```foxpro
oMyArray = CREATEOBJECT('ArrayObj'[, nColCnt])
```

The array name is always **.aRA[]**. For example:
```foxpro
? oMyArray.aRA[nRows,2]     && --> 456
```

### Commonly Used Methods
The array object's methods are detailed at the top of Karrays.prg complete with syntax and other notes. However, these are some of the more common array methods:
```foxpro
*- Init([nCols]) - Initialize an array object
*- AddRow(xVal1 [,xVal2] [,xVal3]...) - Add a row to the array
*- DeleteRow(nRowNum) - Remove a row to the array (re-size it smaller)
*- InsertCols(nNumNewCols) - Add columns to the array (re-size it larger)
*- DeleteCol(nCol2Remove) - Delete a column from the array (re-size it smaller)
*- Sort([nSortCol[, bDescending[, bCaseInSensitive]]]) - Sort the array
*- MultiColSort(nCol1, nCol2...[bDescending[, bCaseInSensitive]]) - Sort the array by multiple columns
*- Locate(xLookFor, nSrchCol, bExactOn) - Case-Insensitive look thru a non-ordered array for a value
*- Seek(xLookFor[, nSrchCol]) - Look through an ordered array for a passed value
*- PrintToFile(cFileName) - Outputs our array's contents to a text file
*- PrintToFileExtended(cFileName) - Outputs the array's contents vertically
*- Print() - Print() - Uses ? to display the array contents (max. 20 char elements)
*- ZapArray() - Removes all data and rows in an array (columns are unchanged)
```

### Special Functions
```foxpro
* Split(cStr, [cDelim]) - Split a delimited string into a 1-dimensional array object
* SplitCSV(cStr) - Split delimited string into array but keep delims within ""
```

### Other Array Objects
These other objects are all child classes of ArrayObj.
```foxpro
*   DirArray Class (parent ArrayObj) - Loads array with files matching file spec
    *- Init(cFileSpec [, cAttrib [, cKeepCase]])
    *- Dir2Array() - Create an array of files matching a passed filespec
    *- AddExts() - Add more files to the array for different extensions
    *- DeleteExts() - Delete all files matching the passed extensions
    *- DeleteFiles() - Remove all files matching the passed list
* FileLines Class - Array object from lines in a file or text string
    *- Init(cFileOrStr[, cLineEnd[, bIsString]])
    *- File2Array() - Load the array from the passed memo string
    *- String2Array() - Load the passed string into the array
* StringArray Class (parent ArrayObj) - Array Object to/from string list
    *- Init(cString [, cToken]) array object
    *- String2Array() - Load the array from the tokenized string
    *- Join() - Create a tokenized string from the array
    *- Array2String() - Create a tokenized string from the array
* MemoArray Class - Array Object for formatting blocks of text
    *- Init(cMemoStr, nLineWidth)
    *- Memo2Array() - Load the array from the passed memo string
    *- SplitString() - Split the passed string to the desired length
    *- Array2Memo() - Create a memo string from the array
    *- ChangeLeftMargin() - Change the left margin of the current text
    *- GetLeftMargin() - Return the current left margin of the text
```
### Test Program:
The test Program is at: [TestArrays.prg](file:///ArrayTests/TestArrays.prg).

See also the notes on [Hungarian Notation](file:///./HungarianNotation.md).

<font size="2"><center>
by Ken Green - [AdvanceDataSystems.biz](http://AdvanceDataSystems.biz), May 2025
</center></font>