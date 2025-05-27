#IF 0                         TestStrings.prg

  Purpose:  Test ..\KStrings.prg

Revisions:  May 13, 2025 - Ken Green - Original

*****************************************************************************
#ENDIF

#DEFINE CR           CHR(13)
#DEFINE LF           CHR(10)
#DEFINE CR_LF        CHR(13) + CHR(10)
#DEFINE HEX_FF       CHR(255)

CLOSE ALL
CLEAR ALL
SET CENTURY ON
SET PROCEDURE TO ..\KStrings, ..\Karrays

goStr = CREATEOBJECT('KStrings')

* Setup for printing to KArraysResults.txt
SET PRINTER TO
IF FILE('KStringsResults.txt')
    ERASE KStringsResults.txt
ENDIF

SET DEVICE TO PRINT
SET PRINTER TO KStringsResults.txt
SET PRINTER ON
SET CONSOLE ON
CLEAR

?? SPACE(26) + 'Testing KStrings.prg Library'
?
gnCnt = 1

? 'Get Information Section:'
? '------------------------'

* AllDigits() - Return .T. if the passed string contains only digits
*    Input: cTheStr - The string to check
*     Retn: .T. if it's all digits, else .F.
cStr1 = '12346'
cStr2 = '123A6'
cFunc = 'AllDigits()'
bIsGood = .F.
DO CASE
CASE NOT goStr.AllDigits(cStr1)
    ? cFunc + 'AllDigits() reported not all digits in "' + cStr1 + '"'
CASE goStr.AllDigits(cStr2)
    ? cFunc + 'AllDigits() reported all were digits in "' + cStr2 + '"'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* AnyDigits() - Return .T. if the passed string contains ANY digits
*    Input: cTheStr - The string to check
*     Retn: .T. if there are any digits, else .F.
cStr1 = 'ABCDE'
cStr2 = '1DEF6'
cFunc = 'AnyDigits()'
bIsGood = .F.
DO CASE
CASE goStr.AnyDigits(cStr1)
    ? cFunc + 'AnyDigits() reported having digits in "' + cStr1 + '"'
CASE NOT goStr.AnyDigits(cStr2)
    ? cFunc + 'AnyDigits() reported not having digits in "' + cStr2 + '"'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* AllCAPS() - Return .T. if a string contains only digits and CAPITAL letters
*    Input: cTheStr - The string to check
*     Retn: .T. if it's all digits and CAPITAL letters, else .F.
cStr1 = 'AB56E'
cStr2 = '1Def6'
cFunc = 'AllCAPS()'
bIsGood = .F.
DO CASE
CASE NOT goStr.AllCAPS(cStr1)
    ? cFunc + 'AllCAPS() reported having no CAPS/digits in "' + cStr1 + '"'
CASE goStr.AllCAPS(cStr2)
    ? cFunc + 'AllCAPS() reported having CAPS/digits in "' + cStr2 + '"'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IsNumber() - Return .T. if the passed string starts with a number
*    Input: cTheStr - The string to check (pass as @cTheStr if you want
*                      the numeric portion)
*           cRem - Trailing characters after number (optional; passed as
*                      @cRem)
*     Retn: .T. if it's a number, else .F.
*           cRem has trailing characters if passed as @cRem
cFunc = 'IsNumber()'
cStr1 = '123ABcde'
cStr2 = 'ABcde'
cRem = ''
bIsGood = .F.
DO CASE
CASE (NOT goStr.IsNumber(@cStr1, @cRem)) OR cStr1 <> '123' OR cRem <> 'ABcde'
    ? cFunc + 'IsNumber() reported having no number in "' + cStr1 + '"'
CASE goStr.IsNumber(cStr2)
    ? cFunc + 'IsNumber() reported having a number in "' + cStr2 + '"'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* AtNotInDelim() - Return the pos'n of a char NOT within delimeters
*    Input: cTheChar - The character in question
*           cTheStr  - The string to search
*           cDelim  - The left and right delimeter pair
*     Retn: The position (0 if not there or if only within ())
cFunc = 'AtNotInDelim()'
cStr1 = '12(DE)dE'
bIsGood = .F.
DO CASE
CASE goStr.AtNotInDelim('E', cStr1, '()') <> 8
    ? cFunc + 'AtNotInDelim() reported no "E", outside ()s in "' + cStr1 + '"'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* AtNotInParen() - Return the position of a char in a string outside of any ()
*    Input: cTheChar - The character in question
*           cTheStr - The string to search
*     Retn: The position (0 if not there or if only within ())
cFunc = 'AtNotInParen()'
cStr1 = '12(DE)dE'
bIsGood = .F.
DO CASE
CASE goStr.AtNotInParen('E', cStr1) <> 8
    ? cFunc + 'AtNotInParen() reported no "E", outside ()s in "' + cStr1 + '"'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FldsInExpr() - Returns a list of field names within an index expression
*    Input: cExpr - The index expression in question
*     Retn: List of Field Names
cFunc = 'FldsInExpr()'
cStr1 = 'UPPER(ISSUE + SECT_ID + CATEGORY)'
bIsGood = .F.
cFldList = goStr.FldsInExpr(cStr1)
DO CASE
CASE NOT cFldList = 'ISSUE,SECT_ID,CATEGORY'
    ? cFunc + 'FldsInExpr() said "' + cStr1 + '" fields are in "' + cStr1 + '"'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FirstAt() - Find the first position of some strings in some text
*    Input: cStrList - Comma-delimited strings to search for (e.g.
*                          "ABC,DEF,GHI")
*           cText    - Search for them in this text
*           cFndStr  - (optional) if passed as @cFndStr, will contain the
*                          string found
*     Retn: The position number of the first string found
*        12345678901
cFunc = 'FirstAt()'
cStr1 = [He said, "DEF". She said, "ABCDEF"]
bIsGood = .F.
cStrList = "ABC,DEF,GHI"
cFndStr = ''
nPosn = goStr.FirstAt(cStrList, cStr1, @cFndStr)
DO CASE
CASE nPosn <> 11 OR cFndStr <> 'DEF'
    ? cFunc + 'FirstAt() said nPosn was ' + TRANSFORM(nPosn) + ;
      ' and the string found was: "' + cFndStr + '"'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FirstCap() - Return the first number or capital letter of a string
*    Input: cStrIn - String for evaluation
*     Retn: 1st number or capital letter in string
cFunc = 'FirstCap()'
cStr1 = [he said, "DEF". She said, "4"]
bIsGood = .F.
cChar = goStr.FirstCap(cStr1)
DO CASE
CASE cChar <> 'D'
    ? cFunc + 'FirstCap() found "' + cChar + '" in "' + cStr1
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* Get1stPosn() - Get the 1st position (R or L) of any of some chars
*    Input: cCharList - A string of characters to look for
*           cLongString - The string to search
*           bFromRight - If .T., search starts from right, else from left
*     Retn: 1st position number of one of the characters
*                 1         2
*        123456789012345678901234567890
cFunc = 'Get1stPosn()'
cStr1 = [he said, "DEF". She said, "4"]
bIsGood = .F.
nPosn = goStr.Get1stPosn('dD', cStr1, .T.)      && .T. = from right
DO CASE
CASE nPosn <> 24
    ? cFunc + 'Get1stPosn() said nPosn was ' + TRANSFORM(nPosn)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetArg - Return the contents within parentheses for a passed name
*    Input: cSrcTxt - String containing "name1,name2(arg2),name3(arg3)" text
*           cFuncName - Function name
*           cSepChar - optional, character separating arguments (e.g. ",")
*     Retn: Argument text within the parentheses (if any)
cFunc = 'GetArg()'
cStr1 = 'SRCH(STATSRCH),MUSTEXIST(IN STATES[]),FL-L,NOSPACE'
bIsGood = .F.
cArg = goStr.GetArg(cStr1, 'SRCH')
DO CASE
CASE cArg <> 'STATSRCH'
    ? cFunc + 'GetArg() said argument was ' + cArg
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetArgValue() - Return the Value from a Name=Value clause
*    Input: cTextIn - Text containing Name=Value clauses (NOTE: Pass this
*                      as @cTextIn and the Name=Value clause will be
*                      extracted.)
*           cName - Name where Value is desired
*     Retn: The Value argument after the = sign
cFunc = 'GetArgValue()'
cStr1 = [Dir=\Status Name=Rodney Value=45.6]
bIsGood = .F.
cValue = goStr.GetArgValue(cStr1, 'Name')
DO CASE
CASE cValue <> 'Rodney'
    ? cFunc + 'GetArgValue() said argument was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetArticle() - Return the appropriate article for the passed noun
*    Input: cNoun - Noun in question
*           bNoFirstCap - .T. if first letter of article should NOT be cap
*     Retn: 'A ' or 'An '
cFunc = 'GetArticle()'
cStr1 = [egghead]
bIsGood = .F.
cValue = goStr.GetArticle(cStr1, .T.)
DO CASE
CASE NOT cValue == 'an '
    ? cFunc + 'GetArticle() said Article was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetInitials() - Return the initials for the passed name
*    Input: cNameIn - Name from which initials are to be extracted
*     Retn: Up to 5 initials within the name
cFunc = 'GetInitials()'
cStr1 = [Alfred E. Neuman]
bIsGood = .F.
cValue = goStr.GetInitials(cStr1)
DO CASE
CASE NOT cValue == 'AEN'
    ? cFunc + 'GetInitials() said initials were ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetEndingDigits() - Return the trailing digits (if any) in a passed string
*    Input: cFunc - String in question
*     Retn: The trailing digits in the string, e.g. "ABC45DH132" --> "132"
cFunc = 'GetEndingDigits()'
cStr1 = [ABC45DH132]
bIsGood = .F.
cValue = goStr.GetEndingDigits(cStr1)
DO CASE
CASE NOT cValue == '132'
    ? cFunc + 'GetEndingDigits() said digits were ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

*  HasLowerCase() - Return .T. if the passed string has any lowercase letters
*     Input: cFunc - String in question
*      Retn: .T. if there are any lowercase letters in cStr
cFunc = 'HasLowerCase()'
cStr1 = [ABC45dH132]
bIsGood = .F.
DO CASE
CASE NOT goStr.HasLowerCase(cStr1)
    ? cFunc + 'HasLowerCase() said no lower case letters.'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

*  HasUpperCase() - Return .T. if the passed string has any uppercase letters
*     Input: cFunc - String in question
*      Retn: .T. if there are any uppercase letters in cStr
cFunc = 'HasUpperCase()'
cStr1 = [ABC45dH132]
bIsGood = .F.
DO CASE
CASE NOT goStr.HasUpperCase(cStr1)
    ? cFunc + 'HasUpperCase() said no upper case letters.'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Extract String Parts:'
? '---------------------'

* GetEmailDomain() - Return the domain from an email address
*    Input: cFunc - Email address string
*     Retn: The domain from that email address
cFunc = 'GetEmailDomain()'
cStr1 = [MelvinFurd@gmail.com]
bIsGood = .F.
cValue = goStr.GetEmailDomain(cStr1)
DO CASE
CASE NOT cValue == 'gmail.com'
    ? cFunc + 'GetEmailDomain() said the domain was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrNumber() - Extract a number from the beginning of a string
*    Input: cFunc - String for extraction (passed as @cFunc if you want
*                      the remainder returned)
*     Retn: Number or Numeric Expression extracted from the string
*           Remainder in cFunc if it was passed as @cStr
cFunc = 'ExtrNumber()'
cStr1 = [12345 Who do we appreciate?]
bIsGood = .F.
cValue = goStr.ExtrNumber(cStr1)
DO CASE
CASE NOT cValue == '12345'
    ? cFunc + 'ExtrNumber() said the number was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* EvalLogicExpr() - Evaluate "Arg" in a Name(Arg) str as .T. (default) or .F.
*    Input: cSrcTxt - String containing Name(Arg) clause like:
*                      "Name1(arg1), Name2(arg2), ..."
*           cFuncName - Name in the Name(Arg) clause
*           cClauSep - Character separating multiple clauses (e.g. ",")
*     Retn: .T. or .F.
xy = 'A45'
cFunc = 'EvalLogicExpr()'
cStr1 = [Prg1('haha'),Prg2(xy),Prg3(45)]
bIsGood = .F.
cValue = goStr.EvalLogicExpr(cStr1, 'Prg2', ',')
DO CASE
CASE NOT cValue == 'A45'
    ? cFunc + 'EvalLogicExpr() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrClauseArg() - Extract a clause argument: (IN clause AS clause)
*    Input: cSrcTxt - String for extraction (must be passed as @cStrIn for
*                      any extraction to actually take place)
*           cIDWord - Word in cSrcText (such as "IN" or "AS")
*     Retn: Extracted clause
cFunc = 'ExtrClauseArg()'
cStr1 = [IN ITEMS AS ITEM_NUMB]
bIsGood = .F.
cValue = goStr.ExtrClauseArg(cStr1, 'AS')
DO CASE
CASE NOT cValue == 'ITEM_NUMB'
    ? cFunc + 'ExtrClauseArg() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrFldName() - Extract the first field name from an expression
*    Input: cExpr - String for extraction
*     Retn: Extracted field name
cFunc = 'ExtrFldName()'
cStr1 = [STR(MY_FIELD,45,12)]
bIsGood = .F.
cValue = goStr.ExtrFldName(cStr1)
DO CASE
CASE NOT cValue == 'MY_FIELD'
    ? cFunc + 'ExtrFldName() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrLine() - Extract a max length line from a large string
*    Input: cStrIn - String for extraction (must be passed as @cStrIn for
*                      any extraction to actually take place)
*           nDesLen - Desired length of string
*           bKillIntEnds - (Optional) .T. if internal blank lines are to
*                      be removed (default = .F.)
*     Retn: Extracted line
*           cStrIn is split on whitespace as close to nDesLen as possible
*              (if there is no whitespace, it's just chopped).  Whitespace
*              is: spaces, TABs, CRs, LFs, and HEX_FFs.
cFunc = 'ExtrLine()'
*                 1         2     v   3         4         5         6         7
*        1234567890123456789012345678901234567890123456789012345678901234567890
cStr1 = [Now is the time for all good men to come to the aid of their country.]
bIsGood = .F.
cValue = goStr.ExtrLine(cStr1, 26)
DO CASE
CASE NOT cValue == 'Now is the time for all '
    ? cFunc + 'ExtrLine() said the value was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrLineWithText() - Extract entire line containing some text
*    Input: cStrIn - String for extraction
*           cSrchTxt - Text to look for
*     Retn: Text but without the line(s) that had cSrchTxt
cFunc = 'ExtrLineWithText()'
cStr1 = [Now is the time for all ] + CR_LF + ;
  [good men to come to the ] + CR_LF + ;
  [aid of their country.]
bIsGood = .F.
cValue = goStr.ExtrLineWithText(cStr1, 'men to come to')
DO CASE
CASE NOT cValue == [Now is the time for all ] + CR_LF + ;
  [aid of their country.]
    ? cFunc + 'ExtrLineWithText() said the value was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IsQuoted() - Return .T. if the string is surrounded by quotes
*    Input: cStrIn - String for evaluation
*           cQuoteChar - (optional; passed as @cQuoteChar) The quote
*                  character use for quotation
*     Retn: .T. if the string is quoted and cQuoteChar filled in, or .F.
cFunc = 'IsQuoted()'
*                 1         2     v   3         4         5         6         7
*        1234567890123456789012345678901234567890123456789012345678901234567890
cStr1 = ["Jump in a lake."]
bIsGood = .F.
cValue = goStr.IsQuoted(cStr1)
DO CASE
CASE NOT cValue == .T.
    ? cFunc + 'IsQuoted() said the value was: ' + TRANSFORM(cValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrQuoted() - Extract the contents, within quotes, from a string
*    Input: cStrIn - String for extraction (must be passed as @cStrIn for
*                      any extraction to actually take place)
*           cQuoteChar - The quotation character (' or ")
*     Retn: Quoted contents
*           cStrIn - String without the quoted contents or quotes
cFunc = 'ExtrQuoted()'
cStr1 = [He said, "She won't do that again!" So, she said, "Jump in a lake."]
bIsGood = .F.
cValue = goStr.ExtrQuoted(cStr1, ["])
DO CASE
CASE NOT cValue == "She won't do that again!"
    ? cFunc + 'ExtrQuoted() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrToken() - Extract and return the text before a passed token (char)
*    Input: cStrIn - String for extraction (if passed as @cStrIn, the
*                      fragment and token are really extracted)
*           cTokenChar - Character separator
*     Retn: Text in cStrIn before the first cTokenChar
cFunc = 'ExtrToken()'
cStr1 = 'ISSUE,SECT_ID,CATEGORY'
bIsGood = .F.
cValue = goStr.ExtrToken(@cStr1, [,])
DO CASE
CASE cValue <> 'ISSUE' OR NOT cStr1 == 'SECT_ID,CATEGORY'
    ? cFunc + 'ExtrToken() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrVarValue() - Return "Val" from many "VarName=Val^" entries in text
*    Input: cVarName - The name of the variable
*           cTextIn - The string that might contain a "VarName=Value^"
*                      line.
*                     Notice that values are terminated with ^s or CRs.
*     Retn: The "Val" clause of the value line
cFunc = 'ExtrVarValue()'
cStr1 = 'MultiTask=No^MaxThreads=3'
bIsGood = .F.
cValue = goStr.ExtrVarValue('MaxThreads', cStr1)
DO CASE
CASE not cValue == '3'
    ? cFunc + 'ExtrVarValue() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetVarValue - Return the value in a "VarName=Val[CR_LF]" line
*    Input: cValLine - The string containing a "VarName=Val" line.  The
*                      string can contain more than one of these but only
*                      the value after the first = sign is returned.
*     Retn: The "Val" clause of the value line
cFunc = 'GetVarValue()'
cStr1 = 'MultiTask=No' + CR_LF + '^MaxThreads=3'
bIsGood = .F.
cValue = goStr.GetVarValue(cStr1)
DO CASE
CASE NOT cValue == 'No'
    ? cFunc + 'GetVarValue() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* SplitPosition() - Cut a string at the passed position number and return the left side
*    Input: cStrIn - The input string to be split (passed as @cStrIn)
*           nPosn - The position to cut the string at
*     Retn: The LEFT part of the string up to and including nPosn
*           cStrIn - RIGHT part of the string starting at nPosn + 1
*     Note: If nPosn < 1, the returned string will be empty and cStrIn
*              is unchanged.
cFunc = 'SplitPosition()'
*                 1    v    2         3
*        12345678901234567890123456789012
cStr1 = [Now is the time for all good men]
bIsGood = .F.
cValue = goStr.SplitPosition(@cStr1, 15)
DO CASE
CASE NOT (cValue == 'Now is the time' OR cStr1 == ' for all good men')
    ? cFunc + 'SplitPosition() said the value was: ' + cValue + ;
      ' or the remainder was: ' + cStr1
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* SplitString() - Split a string to whole words at the desired length
*    Input: cStrIn - The input string to be split (passed as @cStrIn)
*           nLength - Desired line length
*     Retn: String returned as the leftmost part of cStrIn after split
*           cStrIn - LTRIMmed remainder of cStrIn after split (only if
*                  passed as @cStrIn)
*           vbHardCR - (must have been setup as PRIVATE) set as .T. if
*                  split occurs at HEX_FF
*     Note: Will convert CR_LFs to HEX_FFs.
cFunc = 'SplitString()'
*                 1    v    2         3
*        12345678901234567890123456789012
cStr1 = [Now is the time for ] + CR_LF + [all good men]
bIsGood = .F.
cValue = goStr.SplitString(@cStr1, 15)
DO CASE
CASE NOT (cValue == 'Now is the ' OR cStr1 == 'time for ' + HEX_FF + 'all good men')
    ? cFunc + 'SplitString() said the value was: ' + cValue + ;
      ' or the remainder was: ' + cStr1
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* CleanString() - Remove non-alpha, non-digit, non-space characters
*    Input: cStrIn - The input string to be checked
*           cExceptions - (optional) Characters to leave in (e.g. ".")
*     Retn: String returned with only alpha or digit characters
cFunc = 'CleanString()'
cStr1 = [Now is the time. For ] + CR_LF + [all, good men.]
bIsGood = .F.
cValue = goStr.CleanString(cStr1, '.,')
DO CASE
CASE NOT cValue == [Now is the time. For all, good men.]
    ? cFunc + 'CleanString() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetNextWord() - Extract the next word from a string
*    Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
*                      for the extraction to take place.
*           cAddChars - (Optional) Chars to be added to THIS.cWordChars
*                      for check.
*     Retn: The next word ending at the first non-word character
*           cTextIn will have the remaining text starting with that
*              non-word character - if passed as @cTextIn.
cFunc = 'GetNextWord()'
cStr1 = [Now is the time. For all, good men.]
bIsGood = .F.
cValue = goStr.GetNextWord(@cStr1)
DO CASE
CASE NOT (cValue == [Now] OR cStr1 == [is the time. For all, good men.])
    ? cFunc + 'GetNextWord() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetLastWord() - Extract the last word from a string
*    Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
*                      for the extraction to take place.
*           cAddChars - (Optional) Chars to be added to THIS.cWordChars
*                       for check.
*     Retn: The Last word ending at the first non-word character
*           cTextIn will have the text prior to that word - if passed as
*              @cTextIn.
cFunc = 'GetLastWord()'
cStr1 = [Now is the time. For all, good men]
bIsGood = .F.
cValue = goStr.GetLastWord(@cStr1)
DO CASE
CASE NOT (cValue == [men] OR cStr1 == [Now is the time. For all, good])
    ? cFunc + 'GetLastWord() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtractWords() - Extract only whole words up to a maximum length
*    Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
*                      for the extraction to take place.
*           nMaxLen - Maximum length of returned string of words
*  CAUTION: Be sure there are no CRs or LFs in cTextIn; that's confusing
*     Retn: A string of whole words not exceeding nMaxLen
cFunc = 'ExtractWords()'
*                 1     v   2         3
*        12345678901234567890123456789012
cStr1 = [Now is the time. For all, good men]
bIsGood = .F.
cValue = goStr.ExtractWords(@cStr1, 16)
DO CASE
CASE NOT cValue == [Now is the time.]
    ? cFunc + 'ExtractWords() said the value was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Modify the String:'
? '------------------'

* CheckStrValues() - Separate a string of entries into good and bad strings
*     Input: cEntries - String needing checking, eg. 'AAA,DDD,FFF'
*            cCheckStr - String of valid entries, eg. 'AAA,BBB,CCC,FFF'
*           cBadEnts - Passed as @cBadEnts will contain invalid entries
*           cSeparator - optional, Character separating entries and cCheckStr,
*                the default value = ","
*     Retn: cGoodEnts - Will contain only entries that are valid
*           cBadEnts - Will contain invalid entries
*     WARNING: Not reliable if entries contain quotes or if passed values have
*           internal spaces before of after the separator
cFunc = 'CheckStrValues()'
*                 1     v   2         3
*        12345678901234567890123456789012
cStr1 = [AAA,DDD,FFF]
bIsGood = .F.
cBadList = ''
cValue = goStr.CheckStrValues(cStr1, 'AAA,BBB,CCC,FFF', @cBadList)
DO CASE
CASE NOT (cValue == [AAA,FFF] OR cBadList == 'DDD')
    ? cFunc + 'CheckStrValues() said the value was: ' + cValue + ;
      ' and the bad entries were: ' + cBadList
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* SetTextLeftMargin() - Change the left margin of the passed text block
*    Input: cTextIn - String needing reduced/added margin
*           nWantLMarg - Desired new margin
*     Retn: cTextIn has spaces at left matching new margin
cFunc = 'SetTextLeftMargin()'
*                 1         2
*        123456789012345678901234
cStr1 = [Now is the time for all ] + CR_LF + ;
  [good men to come to the ] + CR_LF + ;
  [aid of their country.]
bIsGood = .F.
cValue = goStr.SetTextLeftMargin(cStr1, 4)
nPosn = AT('N', cValue)
DO CASE
CASE nPosn <> 5
    ? cFunc + 'SetTextLeftMargin() said nPosn was: ' + TRANSFORM(nPosn)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* NormalizeNumber() - Return a number string in normal d.ddEee  forma
*    Input: cStrIn - Number string to be normalized
*     Retn: cStrIn converted 3 significant digits in d.ddEee form
cFunc = 'NormalizeNumber()'
cStr1 = '4560.22'
bIsGood = .F.
cValue = goStr.NormalizeNumber(cStr1)
DO CASE
CASE NOT cValue == '4.56E3'
    ? cFunc + 'NormalizeNumber() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ClearPunct() - Remove all except characters and digits from passed string
*    Input: cStrIn - String to process
*           bKeepSpcs - If .T., spaces are retained (default = .F.)
*     Retn: String with non-formatting chars removed
cFunc = 'ClearPunct()'
cStr1 = "I'm OK, I think!"
bIsGood = .F.
cValue = goStr.ClearPunct(cStr1, .T.)
DO CASE
CASE NOT cValue == "Im OK I think"
    ? cFunc + 'ClearPunct() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ClearEndPunct() - Remove ending punctuation characters
*    Input: cTheStr - The passed string to de-punctuate (is that a word?)
*     Retn: String with trailing punctuation chars removed
cFunc = 'ClearEndPunct()'
cStr1 = "I'm OK, I think!"
bIsGood = .F.
cValue = goStr.ClearEndPunct(cStr1)
DO CASE
CASE NOT cValue == "I'm OK, I think"
    ? cFunc + 'ClearEndPunct() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* AddQuotes2Text() - Add appropriate quote characters to the passed text
*     Input: cStrIn - String that may have embedded quotes
*      Retn: cStrIn with quotes added no matter what
cFunc = 'AddQuotes2Text()'
cStr1 = ["I'm OK," he said.]
bIsGood = .F.
cValue = goStr.AddQuotes2Text(cStr1)
DO CASE
CASE NOT cValue == ['"I' + "'m OK," + '" he said.']
    ? cFunc + 'AddQuotes2Text() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* CleanMemo() - Remove a memo's leading lines and trailing white space
*    Input: cMemoIn - Memo string to be cleaned up
*           cLeadOpt - (optional) Char. that defines what to cleanup:
*                  'B' - (default) Cleanup both the start and the end
*                  'L' - Only remove completely blank beginning lines
*                      (but no other whitespace on a line with real
*                      characters)
*                  'N' - Don't remove anything from the start; only at
*                      the end
*     Retn: Cleaned up memo string
cFunc = 'CleanMemo()'
cStr1 = CR_LF + [Now is the time for all ] + CR_LF + ;
  [good men to come to the ] + CR_LF + ;
  [aid of their country.   ] + CR_LF
bIsGood = .F.
cValue = goStr.CleanMemo(cStr1)
DO CASE
CASE NOT cValue == [Now is the time for all ] + CR_LF + ;
  [good men to come to the ] + CR_LF + ;
  [aid of their country.]
    ? cFunc + 'CleanMemo() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FormatPhone() - Apply the correct formatting to the passed phone
*    Input: cPhoneIn - 9999999 or 9999999999 or empty string
*     Retn: 999-9999 or (999) 999-9999 or ''
cFunc = 'FormatPhone()'
cStr1 = '9891234567'
bIsGood = .F.
cValue = goStr.FormatPhone(cStr1)
DO CASE
CASE NOT cValue == '(989) 123-4567'
    ? cFunc + 'FormatPhone() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FlushLeft() - Return a string with characters moved flush left
*    Input: cStrIn - String that may not be flush left
*     Retn: cStrIn guaranteed to be flush left
cFunc = 'FlushLeft()'
cStr1 = '  ABC4567890  '
bIsGood = .F.
cValue = goStr.FlushLeft(cStr1)
DO CASE
CASE NOT cValue == 'ABC4567890    '
    ? cFunc + 'FlushLeft() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FlushRight() - Return a string with characters moved flush right
*   Input: cStrIn - String that may not be flush right
*     Retn: cStrIn guaranteed to be flush right
cFunc = 'FlushRight()'
cStr1 = '  ABC4567890  '
bIsGood = .F.
cValue = goStr.FlushRight(cStr1)
DO CASE
CASE NOT cValue == '    ABC4567890'
    ? cFunc + 'FlushRight() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FlushRZero() - Return a string with characters flush right, 0-filled
*    Input: cStrIn - String that may not be flush right or 0-filled
*     Retn: cStrIn guaranteed to be flush right and 0-filled if needed
cFunc = 'FlushRZero()'
cStr1 = '  ABC4567890  '
bIsGood = .F.
cValue = goStr.FlushRZero(cStr1)
DO CASE
CASE NOT cValue == '0000ABC4567890'
    ? cFunc + 'FlushRZero() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ListMemo() - Return a memo converted to CR_LF terminated lines
*    Input: cMemo - Memo field or string
*           nMaxLen - Maximum desired line length
*           cIndentStr - Preface to 2nd and remaining lines
*           bIsDisplay - If .T. and EMPTY(cMemo), "(none>" is returned, else
*    Retn:  str1 + CR_LF +
*           cIndentStr + str2 + CR_LF +
*           cIndentStr + str3 + CR_LF... +
*           cIndentStr + strX
cFunc = 'ListMemo()'
*                 1         2    v
*        12345678901234567890123456789
cStr1 = [Now is the time for all good ] + ;
  [men to come to the aid of their country.]
bIsGood = .F.
cValue = goStr.ListMemo(cStr1, 25, '  ')
cResult = [Now is the time for all ] + CR_LF + ;
          [  good men to come to the] + CR_LF + ;
          [  aid of their country.]
DO CASE
CASE NOT cValue == cResult
    ? cFunc + 'ListMemo() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* MakeLen() - Return a string at the desired length (chop or space fill)
*    Input: cStrIn - String to have length changed
*           nDesLen - New desired length
*           bAddMT - .T. if "<empty>" should be put in empty strings that
*                      are long enough
*     Retn: cStrIn at the new length
cFunc = 'MakeLen()'
*                 1         2    v    3
*        12345678901234567890123456789012
cStr1 = [Now is the time for all good men]
bIsGood = .F.
cValue = goStr.MakeLen(cStr1, 25)
DO CASE
CASE NOT cValue == [Now is the time for all g]
    ? cFunc + 'MakeLen() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* MakeProper() - PROPERly capitalize a string IF it's all UC or all LC
*    Input: cStrIn - String to be checked
*     Retn: String with proper capitalization
cFunc = 'MakeProper()'
cStr1 = [now is the. time for all]
bIsGood = .F.
cValue = goStr.MakeProper(cStr1)
DO CASE
CASE NOT cValue == [Now Is The. Time For All]
    ? cFunc + 'MakeProper() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ForceProper() - Convert string to lower, then proper capitalization
*    Input: cStrIn - String to be checked
*     Retn: String with proper capitalization
cFunc = 'ForceProper()'
cStr1 = [now is THE. TIME for all]
bIsGood = .F.
cValue = goStr.ForceProper(cStr1)
DO CASE
CASE NOT cValue == [Now Is The. Time For All]
    ? cFunc + 'ForceProper() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrQuotes() - Return an array object with quoted and non-quoted parts
*    Input: cLineIn - String line to be split
*     Retn: Array Object with rows for quoted and unquoted lines as:
*              oObj.aRA[x,1] = Text part of line
*              oObj.aRA[x,2] = .T. if text is quoted
cFunc = 'ExtrQuotes()'
cStr1 = ["Hi there, big boy." He blushed.]
bIsGood = .F.
oValue = goStr.ExtrQuotes(cStr1)
DO CASE
CASE NOT (oValue.aRA[1,1] == ["Hi there, big boy."] AND ;
  oValue.aRA[1,2] == .T. AND ;
  oValue.aRA[2,1] == [ He blushed.] AND ;
  oValue.aRA[2,2] == .F.)
    ? cFunc + 'ExtrQuotes() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* Plural() - Return the plural form of the passed noun
*    Input: cNoun - The singular noun to "pluralize"
*           nNumber - The number in question
*           cPluralExt - (optional) The string to add to the noun if the
*                   number is a plural (default = 's')
*     Retn: If nNumber = 1: only the cNoun is returned
*           Else: the cNoun + cPluralExt are returned
cFunc = 'Plural()'
cStr1 = "Car"
bIsGood = .F.
cValue = goStr.Plural(cStr1, 3)
DO CASE
CASE NOT cValue == 'Cars'
    ? cFunc + 'Plural() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* CountPlural() - Return the count and plural form of the passed noun
*    Input: cNoun - The singular noun to "pluralize"
*           nNumber - The number in question
*           cPluralExt - (optional) The string to add to the noun if the
*                   number is a plural (default = 's')
*           bFirstCap - .T. if the first return letter is to be capitalized
*     Retn: If nNumber = 0: "no " + cNoun + cPluralExt is returned
*           If nNumber = 1: "one " and the cNoun is returned
*           Else: the number + cNoun + cPluralExt are returned
cFunc = 'CountPlural()'
cStr1 = "body"
bIsGood = .F.
cValue = goStr.CountPlural(cStr1, 3, 'ies', .T.)
DO CASE
CASE NOT cValue == '3 bodies'
    ? cFunc + 'CountPlural() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ExtrPlural() - Return the singular form of the passed plural
*    Input: cPlural - The plural noun
*     Retn: The singular form of that plural
cFunc = 'ExtrPlural()'
cStr1 = "bodies"
bIsGood = .F.
cValue = goStr.ExtrPlural(cStr1)
DO CASE
CASE NOT cValue = 'body'
    ? cFunc + 'ExtrPlural() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* StrToHTML() - Convert &, <, > chars for HTML output
*    Input: cStrIn - Incoming string
*    Output: TRIMmed cStrIn where &, < and >s are converted to escaped
*            equivalents. If cStrIn is empty, it becomes "&nbsp;".
*    CAUTION: Not to be used for INPUT values
cFunc = 'StrToHTML()'
cStr1 = "<>&HaHa"
bIsGood = .F.
cValue = goStr.StrToHTML(cStr1)
DO CASE
CASE NOT cValue == "&lt;&gt;&amp;HaHa"
    ? cFunc + 'StrToHTML() said cValue was: ' + '|' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* CharsToHTML() - Convert special characters into HTML equivalents
*    Input: cStrIn - Incoming string
*    Output: cStrIn where &, < and >s are converted to escaped HTML
*            equivalents.
*    CAUTION: Not to be used for INPUT values
cFunc = 'CharsToHTML()'
cStr1 = "<Y&up>"
bIsGood = .F.
cValue = goStr.CharsToHTML(cStr1)
DO CASE
CASE NOT cValue == "&lt;Y&amp;up&gt;"
    ? cFunc + 'CharsToHTML() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* WebTrim() - Trim a string variable for HTML output
*    Input: cStrIn - String to be trimmed
*     Retn: Trimmed cStrIn, or non-breaking space if cStrIn is empty
cFunc = 'WebTrim()'
cStr1 = "  "
bIsGood = .F.
cValue = goStr.WebTrim(cStr1)
DO CASE
CASE NOT cValue == "&nbsp;"
    ? cFunc + 'WebTrim() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* PostTrim() - Trim a string variable and remove artifacts
*    Input: cStrIn - String to be checked
*     Retn: Trimmed cStrIn with Non-breaking spaces and 0FFhs removed
cFunc = 'PostTrim()'
cStr1 = "Here are 2 spaces:&nbsp;" + CHR(160)
bIsGood = .F.
cValue = goStr.PostTrim(cStr1)
DO CASE
CASE NOT cValue == "Here are 2 spaces:"
    ? cFunc + 'PostTrim() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* PostVal() - Return a numeric after removing artifacts
*    Input: cStrIn - String to be checked
*     Retn: VAL() of cStrIn after non-breaking spaces and 0FFhs removed
cFunc = 'PostTrim()'
cStr1 = "&nbsp;354.21&nbsp;"
bIsGood = .F.
cValue = goStr.PostTrim(cStr1)
DO CASE
CASE NOT cValue == "354.21"
    ? cFunc + 'PostTrim() said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* StripChrs() - Remove one or more characters from a passed string
*    Input: cStrIn - String to be checked
*           cDelChars - String of characters to be removed
*     Retn: String with cDelChars characters removed
cFunc = 'StripChrs()'
cStr1 = "I don't like Zs; they put me to sleep:ZZZ."
bIsGood = .F.
cValue = goStr.StripChrs(cStr1, 'Z')
DO CASE
CASE NOT cValue == "I don't like s; they put me to sleep:."
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* WordWrapString() - Reformat a string with CR_LF lines
*    Input: cStrIn - String to be word-wrapped
*           nMaxLinLen - Max. length of a line
*           nIndentSpcs - Prepend this from 2nd line on
*           bKillIntEnds - (Optional) .T. if internal blank lines are to
*                      be removed (default = .F.)
*     Retn: Word-wrapped string
cFunc = 'WordWrapString()'
*                 1         2    v
*        12345678901234567890123456789
cStr1 = [Now is the time for all good ] + ;
  [men to come to their senses.]
bIsGood = .F.
cValue = goStr.WordWrapString(cStr1, 25, 2)
cResult = [Now is the time for all ] + CR_LF + ;
          [  good men to come to ] + CR_LF + ;
          [  their senses.] + CR_LF
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* SwapPhrase() - Substitute all instances of a word/phrase with a 2nd word/phrase
*    Input: cStrIn - String to be changed
*           cPhraseIn - Phrase to be changed
*           cNewPhrase - Phrase to be put in plase of cPhraseIn
*     Retn: Changed string
*    Notes: 1. This is a case-insensitive swap.
*           2. cPhraseIn must be within word boundaries at each end
cFunc = 'SwapPhrase()'
cStr1 = [Now is the time for all good men to come to their senses.]
bIsGood = .F.
cValue = goStr.SwapPhrase(cStr1, [good men], [bad women])
cResult = [Now is the time for all bad women to come to their senses.]
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* CreateSpecialKey() - Return a key with 1 of 72 possible characters
*    Input: nStrLen - Desired length of string
*     Retn: New string containing a random selection of these characters:
*            0-9, A-Z, a-z and !@#$%*()+
cFunc = 'CreateSpecialKey()'
bIsGood = .F.
cValue = goStr.CreateSpecialKey(30)
DO CASE
CASE NOT LEN(cValue) == 30
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)
?? ' - New key is: ' + cValue

?
? 'Output Formatting:'
? '------------------'

* Format() - Return the passed string with variable values inserted
*     Input: cString - String to have variable values inserted. Example:
*               {0}, your {1:D} purchase total was {2:c}. Thank you {0}."
*                   The curly brackets define the variable number to be
*                   inserted (0-based). the : defines formatting codes.
*            vPara0, vPara1,...vPara9 - Variables to be converted to
*               strings and inserted (up to 9 variables)
*      Retn: String with variable values inserted.  For example, if the
*            variable values were:
*               cUserName   = "Joe"
*               dBuyDate    = {03/19/2010}
*               nInvoiceAmt = $43.63
*            The string would be: "Joe, your March 19, 2010 purchase total
*                                  was $43.63. Thank you Joe."
cFunc = 'Format()'
cStr1 = "{0}, your {1:D} purchase total was {2:c}. Thank you {0}."
bIsGood = .F.
cUserName   = "Joe"
dBuyDate    = {03/19/2025}
nInvoiceAmt = $43.63
cValue = goStr.Format(cStr1, cUserName, dBuyDate, nInvoiceAmt)
cResult = "Joe, your Mar. 19, 2025 purchase total was $43.63. Thank you Joe."
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* DateFormat() - Format a Date or DateTime into a string
*    Input: dtConvert - Date or DateTime variable to be converted
*           cFormat - Formatting codes
*     Retn: String of Date or DateTime converted according to the format
*    Formatting Codes are:
*      Code      Convert to                    Output Format
*      ----    --------------------------  -----------------------------
*        d     Short date                  10/12/2002
*        D     Long date, short month      Dec. 10, 2002
*        L     Long date                   December 10, 2002
*        f     Full date & time            December 10, 2002 10:11 PM
*        F     Full date & time (long)     December 10, 2002 10:11:29 PM
*        g     Default date & time         10/12/2002 10:11 PM
*        G     Default date & time (long)  10/12/2002 10:11:29 PM
*        M     Month day pattern           December 10
*        r     RFC1123 date string         Tue, 10 Dec 2002 22:11:29 GMT
*        s     Sortable date string        2002-12-10T22:11:29
*        t     Short time                  10:11 PM
*        T     Long time                   10:11:29 PM
*        u     UTC sortable format*        2002-12-10 22:13:50Z
*        U     UTC time (long)*            December 11, 2002 3:13:50 AM
*        Y     Year month pattern          December, 2002
*      * This format does no conversion from the passed date/time variable - it
*        must already be a UTC date or date/time value.
cFunc = 'DateFormat()'
tStr1 = DATETIME(2024, 7, 10, 9, 30, 24)
bIsGood = .F.
cValue = goStr.DateFormat(tStr1, 'F')
DO CASE
CASE NOT cValue == 'July 10, 2024 9:30:24 AM'
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* NumericFormat() - Format a Number or Currency value into a string
*    Input: nConvert - Number or Currency variable to be converted
*           cFormat - Formatting codes
*     Retn: String of Number or Currency converted according to the format
*    Formatting Codes are (these codes may be followed by an integer, y):
*      Codes   Type       y = (default)   Example                      Notes
*      -----  ----------- -------------  --------------------------  ---------------
*      Cy cy  Currency    Decimals (2)   C2: -123.456 -> ($123.46)   Rounded
*      Iy Iy  Integer     Min. digits    I6: -1234 -> -001234        Note 1
*      Ey ey  Exponent    Decimals (6)   e3: -1052.9 -> -1.053e3     Note 2, rounded
*      Fy fy  Fixed-pt    Decimals (6)   F4: -1234.56 -> -1234.5600  Rounded
*      Gy gy  General     Sig. Digits    G4: 123.4546 -> 123.5       Rounded, 9 max.
*      Ny ny  Number      Decimals (2)   N1: 1234.567 -> 1,234.6     Rounded
*      Py py  Percent     Decimals (2)   P1: -0.39678 -> -39.7%      Rounded, * 100
*      Xy xy  Hexadecimal Min. digits    x4: 255 -> 0x00ff           Note 2
*      Notes:
*      1. I Format: This is not used in C#. We use it here because the numbers
*         to be formatted are supposed to be integers.  However, in C# this is
*         called the D(ecimal) format -- which makes no sense to me. Though not
*         shown above the D format is implemented in KStrings and it does the
*         same thing as the I format.
*      2. Note that output letters are the same case as the passed format
*         letter.
*      3. C# implements a Ry/ry Round-Trip code. Its purpose is to define a
*         string that can go on a round-trip and be comverted back to the same
*         number. It only applies to Single, Double, and BigInteger numbers.
*         That code is not implemented here as it isn't of any use.
*      4. For more examples, see Ref\Numeric.txt.
cFunc = 'NumericFormat()'
nVal1 = -1052.9
bIsGood = .F.
cValue = goStr.NumericFormat(nVal1, 'e3')
DO CASE
CASE NOT cValue == '-1.053e3'
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* LogicalFormat() - Format a Logical value into a string
*    Input: bValue - Logical value to be converted
*           cFormat - Formatting codes
*     Retn: String of Logical converted according to the format
*    Formatting Codes are (these codes may be followed by an integer, y):
*      Codes   Type            z =          Example            Notes
*      -----  ------------- -------------  ------------------  ------
*      Tz tz  True or False Chars to show  T4: .F. -> False    Note 1
*      Yz yz  Yes or No     Chars to show  y3: .F. -> no       Note 1
*      Notes:
*      1. Note that the first output letter is the same case as the passed
*         format letter.
cFunc = 'LogicalFormat()'
bVal1 = .F.
bIsGood = .F.
cValue = goStr.LogicalFormat(bVal1, 'T5')
DO CASE
CASE NOT cValue == 'False'
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'VFP Code Formatting:'
? '--------------------'

* Comm2Code() - Format one comment line to fit within a specified length
*    Input: cLineIn - Comment line to be formatted
*           nMaxLen - Max. length of output string
*     Retn: Formatted line with any necessary " ;" line continuations.
*
* Line2Code() - Format one line of code to fit within a specified length
*    Input: cLineIn - String line to be formatted
*           nMaxLen - Max. length of output string
*     Retn: Formatted line with any necessary " ;" line continuations.
*              Quoted strings will be split properly (with quotes at split)
cFunc = 'Comm2Code()'
*                 1         2    v    3
*        123456789012345678901234567890123
cVal1 = '* This is a much too long comment'
bIsGood = .F.
cValue = goStr.Comm2Code(cVal1, 25)
cResult = '* This is a much too ' + CR_LF + ;
  '*   long comment' + CR_LF
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FormatCode() - Format a block of text as VFP Code with ; carry-overs
*    Input: cTextIn - String to be formatted (can be multiple lines)
*           nRightMargin - (optional) desired right margin (e.g. max.
*                  length of output string - default = 80)
*     Retn: Formatted string with any necessary " ;" line continuations.
*              Quoted strings will be split properly (with quotes at split)
cFunc = 'FormatCode()'
*                 1         2    v
*        12345678901234567890123456789
cVal1 = [IF nX > 365 AND NOT bIsLeapYr] + CR_LF + ;
        [    nYear = nYear + 1] + CR_LF + ;
        [ENDIF] + CR_LF
bIsGood = .F.
cValue = goStr.FormatCode(cVal1, 25)
cResult = [IF nX > 365 AND NOT  ;] + CR_LF + ;
  [  bIsLeapYr] + CR_LF + ;
  [    nYear = nYear + 1] + CR_LF + ;
  [ENDIF] + CR_LF
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Encoding/Encrypting:'
? '--------------------'

* EncryptIt(cStrIn) - Return an encrypted string
*     Input: cStrIn - URL String to be encrypted
*      Retn: Encrypted string
cFunc = 'EncryptIt()'
cVal1 = 'https://www.amazon.com/'
bIsGood = .F.
cValue = goStr.EncryptIt(cVal1)
bIsGood = .T.       && Give it a pass: it's hex chars; we'll check it next
ShowResult(cFunc, bIsGood)

* DecryptIt(cStrIn) - Decrypt a string that was encrypted with EncryptIt()
*     Input: cStrIn - URL String to be decrypted
*      Retn: Decrypted string
cFunc = 'DecryptIt()'
cVal1 = cValue
bIsGood = .F.
cValue = goStr.DecryptIt(cVal1)
cResult = 'https://www.amazon.com/'
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* EncodeURL(cStrIn) - Encode a string in an HTML FORM's GET METHOD format
*     Input: cStrIn - String to be URL encoded
*      Retn: Encoded string
cFunc = 'EncodeURL()'
cVal1 = "/Fox/wc.dll?wTasks~CRFQTask~&amp;Task=FullASNEdit&amp"
bIsGood = .F.
cValue = goStr.EncodeURL(cVal1)
cResult = '%2FFox%2Fwc%2Edll%3FwTasks%7ECRFQTask%7E%26amp%3BTask%3DFullASNEdit%26amp'
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* DecodeURL(cStrIn) - Decode a string in an HTML FORM's GET METHOD format
*    Input: cStrIn - URL String to be decoded
*     Retn: Decoded string
cFunc = 'DecodeURL()'
cVal1 = cResult
bIsGood = .F.
cValue = goStr.DecodeURL(cVal1)
cResult = "/Fox/wc.dll?wTasks~CRFQTask~&amp;Task=FullASNEdit&amp"
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* Base64Encode(cStr) - Convert the passed string by BASE64 encoding
*     Input: cFunc - String to be BASE64 encoded
*      Retn: Encoded string
cFunc = 'Base64Encode()'
cVal1 = "John,Joe,Ruth,Helen,Max,Whizbang"
bIsGood = .F.
cValue = goStr.Base64Encode(cVal1)
cResult = "Sm9obixKb2UsUnV0aCxIZWxlbixNYXgsV2hpemJhbmc="
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* Base64Decode(cStr) - Decode the passed BASE64 string
*    Input: cFunc - String to be BASE64 decoded
*     Retn: Decoded string
cFunc = 'Base64Decode()'
cVal1 = cResult
bIsGood = .F.
cValue = goStr.Base64Decode(cVal1)
cResult = "John,Joe,Ruth,Helen,Max,Whizbang"
DO CASE
CASE NOT cValue == cResult
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'PICTURE Methods:'
? '----------------'

* ClearPict() - Remove all except characters and digits from passed string
*    Input: cTheVar - Passed PICTURE string
*           bKeepSpcs - (optional) .T. if you want to keep spaces
*     Retn: String with non-formatting chars removed
cFunc = 'ClearPict()'
cVal1 = '(999) 999-9999'
bIsGood = .F.
cValue = goStr.ClearPict(cVal1)
DO CASE
CASE NOT cValue == '9999999999'
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetPicChrs() - Return the text substitute chars in a "PICTURE" string
*    Input: cTheVar - Passed PICTURE string
*     Retn: String with non-formatting chars removed
cFunc = 'GetPicChrs()'
cVal1 = "Hello! I'm at (999) 999-9999"
bIsGood = .F.
cValue = goStr.GetPicChrs(cVal1)
DO CASE
CASE NOT cValue == "Hello I'm at () -"
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* TrimPict() - Remove trailing picture characters from the passed string
*    Input: cTheVar - Passed string
*     Retn: String with trailing -,./\s removed
*   Note: Commonly used to clean up HTML GET field responses
cFunc = 'TrimPict()'
cVal1 = "Some stuff goes here.\"
bIsGood = .F.
cValue = goStr.TrimPict(cVal1)
DO CASE
CASE NOT cValue == "Some stuff goes here  "
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* RemoveOddHexChars() - Remove hex characters 0h-31h, 255h except LF, CR, FF
*    Input: cMemoIn - Memo string to be cleaned up
*           bKillFF - Also remove the Form-Feed character (12h)
cFunc = 'RemoveOddHexChars()'
cVal1 = "Hello! " + HEX_FF + 'There.'
bIsGood = .F.
cValue = goStr.RemoveOddHexChars(cVal1)
DO CASE
CASE NOT cValue == "Hello! There."
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Type Conversions:'
? '-----------------'

* CharToX() - Convert a string to a variable of the passed type
*     Input: cTextIn - String that may have embedded quotes
*            cType - Type of conversion desired
*      Retn: Desired value
cFunc = 'CharToX()'
cVal1 = '2023/12/22'
bIsGood = .F.
dValue = goStr.CharToX(cVal1, 'D')
IF NOT dValue == {12/22/2023}
    ? cFunc + ' said dValue was: ' + DTOC(dValue)
ELSE
    bIsGood = .T.
ENDIF
IF bIsGood
    dValue = goStr.CharToX('2023-12-22','D')
    IF NOT dValue == {12/22/2023}
        ? cFunc + ' said dValue was: ' + DTOC(dValue)
        bIsGood = .F.
    ENDIF
ENDIF
IF bIsGood
    dValue = goStr.CharToX('2023 DEC 5','D')
    IF NOT dValue == {12/05/2023}
        ? cFunc + ' said dValue was: ' + DTOC(dValue)
        bIsGood = .T.
    ENDIF
ENDIF
IF bIsGood
    dValue = goStr.CharToX('20231205','D')
    IF NOT dValue == {12/05/2023}
        ? cFunc + ' said dValue was: ' + DTOC(dValue)
        bIsGood = .F.
    ENDIF
ENDIF
ShowResult(cFunc, bIsGood)


* XToChar() - Convert any value into a string
*    Input: xValue - Value to be converted
*     Retn: String after conversion
cFunc = 'XToChar()'
nVal1 = 4.501e4
bIsGood = .F.
cValue = goStr.XToChar(nVal1)
DO CASE
CASE NOT cValue == '45010'
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* EscapeXML() - Escape special XML characters
*    Input: cStrIn - String for XML to be checked
*     Retn: String with special XML characters escaped
cFunc = 'EscapeXML()'
cVal1 = [Hi "'&<> there.]
bIsGood = .F.
cValue = goStr.EscapeXML(cVal1)
DO CASE
CASE NOT cValue == "Hi &quot;&apos;&amp;&lt;&gt; there."
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetDurationStr() - Return a human readable time string
*    Input: xSeconds - Number of elapsed seconds
*     Retn: ww days, xx hrs, yy mins and zz secs
*     Note: The leading items won't be shown if they're 0
cFunc = 'GetDurationStr()'
nVal1 = 178567
bIsGood = .F.
cValue = goStr.GetDurationStr(nVal1)
DO CASE
CASE NOT cValue == "2 days, 1 hr, 36 mins and 7 secs"
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* RoundOff() - Round off a number to x decimal places
cFunc = 'RoundOff()'
nVal1 = 17.856
bIsGood = .F.
nValue = goStr.RoundOff(nVal1, 2)
DO CASE
CASE NOT nValue == 17.86
    ? cFunc + ' said nValue was: ' + TRANSFORM(nValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* RoundUp() - Round up a number it's hightest possible integer: 2.0003 --> 3
cFunc = 'RoundUp()'
nVal1 = 17.01
bIsGood = .F.
nValue = goStr.RoundUp(nVal1)
DO CASE
CASE NOT nValue == 18
    ? cFunc + ' said nValue was: ' + TRANSFORM(nValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'String Incrementing:'
? '--------------------'

* IncrNumbPart() - Increment numbers within a string keeping any chars
*      Base 10; no length change, will use spaces on right if needed.
*    Input: cStrIn - String to be incremented
*     Retn: Incremented String
cFunc = 'IncrNumbPart()'
cVal1 = 'WFL7111RL'
bIsGood = .F.
cValue = goStr.IncrNumbPart(cVal1)
DO CASE
CASE NOT cValue == 'WFL7112RL'
    ? cFunc + ' said cValue was: ' + TRANSFORM(nValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IncrNumeric() - Numerically increment a string and 0-fill on left
*      Base 10; no length change, will 0-fill from left if needed.
*    Input: cStrIn - String to be incremented
*           nIncrAmt - (optional) desired incrementing amount (default = 1)
*           cLeftFill - (optional) Other left filling character (default = '0')
*     Retn: Incremented String
cFunc = 'IncrNumeric()'
cVal1 = '129'
bIsGood = .F.
cValue = goStr.IncrNumeric(cVal1)
DO CASE
CASE NOT cValue == '130'
    ? cFunc + ' said cValue was: ' + TRANSFORM(nValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IncrAlpha() - Alpha- or Alphanum- increment a string and zero-fill on left
*      Base 26 (alpha) or 36 (alphanum); no length change, will 0 fill
*      (alphanum) or space fill (alpha) from left if needed; ignores
*      trailing spaces.
*    Input: cStrIn - String to be incremented
*           bAlphaOnly - (optional) .T. if base 26 incrementing is wanted,
*                          default = .F.
*     Retn: Incremented String
cFunc = 'IncrAlpha()'
cVal1 = '199'
bIsGood = .F.
cValue = goStr.IncrAlpha(cVal1)
DO CASE
CASE NOT cValue == '19A'
    ? cFunc + ' said cValue was: ' + TRANSFORM(nValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IncrFLStr() - Alphanum- or numerically-increment a flush left string
*      Base 36 (alphanum) or 10 (numeric); no length change but spaces on
*      the right may be used if needed, no other fills.
*    Input: cStrIn - String to be incremented
*           cIncrType - (optional) Increment type:
*                          'A' - alphanumeric incrementing (base 36)
*                          '1' - numeric incrementing (base 10)
*                      default is: do an alphanumeric increment if the passed
*                      string has any characters, else to do a numeric
*                      increment.
*     Retn: Incremented Trimmed String
cFunc = 'IncrFLStr()'
cVal1 = '189Z  '
bIsGood = .F.
cValue = goStr.IncrFLStr(cVal1)
DO CASE
CASE NOT cValue == '18A0  '
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IncrFRStr() - Alphanum- or numerically-increment a flush right string
*      Base 36 (alphanum) or 10 (numeric); no length change but spaces on
*      the left may be used if needed, no other fills.
*    Input: cStrIn - String to be incremented
*           cIncrType - (optional) Increment type:
*                          'A' - alphanumeric incrementing (base 36)
*                          '1' - numeric incrementing (base 10)
*                      default is to do an alphanumeric increment if the
*                      passed string has any characters, else to do a
*                      numeric increment.
*     Retn: Incremented Trimmed String
cFunc = 'IncrFRStr()'
cVal1 = 'B199Z '
bIsGood = .F.
cValue = goStr.IncrFRStr(cVal1)
DO CASE
CASE NOT cValue == ' B19A0'
    ? cFunc + ' said cValue was: |' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Multiple Option Strings:'
? '------------------------'

* GetNextOption() - Extract the next Name:Value pair from an option string
*    Input: cOptStr - String of options containing Name=Value pairs like:
*                      "Name1=Value1^Name2=Value2^Name3=Value3^..."
*           cValue - The option's value (passed as @cValue; default = '')
*           cNameSep - (optional) char separating Name and Value (default = ':')
*           cOptionSep - (optional) char separating Options (default = '~')
*     Retn: The Name of the option; cValue is filled in
cFunc = 'GetNextOption()'
cVal1 = "Temp=C:\Temp^RunAt=10:00^StopAt=15:00^"
bIsGood = .F.
cValue = ''
cName= goStr.GetNextOption(cVal1, @cValue, '=', '^')
DO CASE
CASE NOT (cValue == 'C:\Temp' AND cName = 'Temp')
    ? cFunc + ' said cName was: ' + cName + ' and cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Combining Strings:'
? '------------------'

* SetCityStateZip() - Return City, State, Zip combined
*     Input: cCity - The city in question
*            cState - The state
*            cZip - The Zip code
* Retn: [City, State  Zip]
cFunc = 'SetCityStateZip()'
cVal1 = "Yucaipa"
cState = 'CA'
cZip = '92399'
bIsGood = .F.
cValue = goStr.SetCityStateZip(cVal1, cState, cZip)
DO CASE
CASE NOT cValue == 'Yucaipa, CA  92399'
    ? cFunc + ' said cValue was: ' + cCityStZip
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* AddToString() - Add string to another with separator if neither is empty
*    Input: cStr1 - The starting string
*           cStr2 - The string to be added
*           cSep - The separator (, ; and so forth)
*    Retn: If neither string is empty: cStr1 + cSep + ' ' + cStr2
*          If either string is empty, it's just the non-empty string
cFunc = 'AddToString()'
cVal1 = "I'm happy"
cVal2 = 'old'
bIsGood = .F.
cValue = goStr.AddToString(cVal1, cVal2, ' and')
DO CASE
CASE NOT cValue == "I'm happy and old"
    ? cFunc + ' said cValue was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Done! All tests have been completed successfully.'
?

SET CONSOLE OFF
SET PRINTER OFF
SET PRINTER TO
SET DEVICE TO SCREEN

 * Done
RETURN


***** Functions

*- ShowResult() - Display the test status
FUNCTION ShowResult(cNameStr, bIsOK)
    ? PADL(gnCnt, 2, ' ') + '. ' + cNameStr + IIF(bIsOK, ' is OK!', ' Failed!')
    gnCnt = gnCnt + 1
    IF NOT bIsOK
        SET CONSOLE OFF
        SET PRINTER OFF
        SET PRINTER TO
        SET DEVICE TO SCREEN
        CANCEL
    ENDIF
    RETURN
ENDFUNC

* RoundUp() - Round off a number to x decimal places.
FUNCTION RoundUp(nNumVar, nDecPlcs)

    * This cannot handle negative decimal places
    IF nDecPlcs < 0
        ERROR 'KStrings::RoundUp() cannot handle negative numbers'
    ENDIF

    * Note: This correctly handles negative numbers and halves (if previous
    *   digit is even, rounds up, else truncates).
    nPower = 10 ^ nDecPlcs
    nNumb = nNumVar * nPower

    * Delta is what we add to nNumb before taking the integer.  However, the
    *   special case of exactly half must be dealt with (round up if the next
    *   highest integer is even; round down if odd).  Then we have to make
    *   delta negative if we're dealing with a negative number.
    nDelta = IIF( MOD(nNumb,1) = 0.500000 AND ;
      MOD(INT(nNumb),2)=1, 0, 0.5 ) * IIF( nNumVar < 0, -1, 1 )

    * Add the delta based on whether this is a negative number or not, take the
    *   integer, divide by the power, and return.
    RETURN INT(nNumb + nDelta) / nPower
ENDFUNC

* IsArray() - Return .T. if the passed variable name is an array
FUNCTION IsArray(cVarName)
    LOCAL bRAError, nRows

    * We've found no reliable test except to trap any ALEN() errors.
    *   TYPE() returns true for oObj.Baseclass[1] and oObj.Baseclass[1,1]
    * So, we'll have to trap for not an array errors (#232)
    bRAError = .F.

    * Get the number of rows in the "array"
    TRY
        nRows = ALEN( &cVarName )
    CATCH
        bRAError = .T.
    ENDTRY
    RETURN (NOT bRAError)
ENDFUNC

* RoundOff - Round off a number to x decimal places.
FUNCTION RoundOff(nNumVar, nDecPlcs)

    * This cannot handle negative decimal places
    IF nDecPlcs < 0
        ERROR 'KStrings::RoundOff() cannot handle negative numbers'
    ENDIF

    * Note: This correctly handles negative numbers and halves (if previous
    *   digit is even, rounds up, else truncates).
    nPower = 10 ^ nDecPlcs
    nNumb = nNumVar * nPower

    * Delta is what we add to nNumb before taking the integer.  However, the
    *   special case of exactly half must be dealt with (round up if the next
    *   highest integer is even; round down if odd).  Then we have to make
    *   delta negative if we're dealing with a negative number.
    nDelta = IIF( MOD(nNumb,1) = 0.500000 AND ;
      MOD(INT(nNumb),2)=1, 0, 0.5 ) * IIF( nNumVar < 0, -1, 1 )

    * Add the delta based on whether this is a negative number or not, take the
    *   integer, divide by the power, and return.
    RETURN INT(nNumb + nDelta) / nPower
ENDFUNC
