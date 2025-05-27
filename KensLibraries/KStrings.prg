#IF 0                          KStrings.prg

  Purpose:  General purpose String Handling

Revisions:  October 27, 2002 - Ken Green - Original to 4/25/25
             5/23/2025 - Special VFPX Edition

******************************* Program Notes *******************************

    The KStrings class is just a front-end object for a function collection.
The goStr object was initialized upon startup.  So, calls to this are really
just method invocations.  For example, to force a string to a certain length,
you'd call this like:
        cNewStr = goStr.MakeLen(cOldStr, 25)

****************************** Classes Defined ******************************

* KStrings Class Definition for this function class
* CTypeNumber Class Definition for Currency numbers
* ITypeNumber Class Definition for Integer numbers
* ETypeNumber Class Definition for Exponential numbers
* FTypeNumber Class Definition for Fixed-point numbers
* GTypeNumber Class Definition for General numbers
* NTypeNumber Class Definition for Plain ol' numbers (integer or decimal)
* PTypeNumber Class Definition for Percentage numbers
* XTypeNumber Class Definition for Hexadecimal numbers
* KNumbers Base Class Definition for numbers

***************************** Available Methods *****************************

These methods are broken down by categories.  Available categories are:
    Get Information                     PICTURE Methods
    Extract Parts (of a string)         Type Conversions
    Modify the String                   String Incrementing
    Output Formatting                   Multiple Option Strings
    VFP Code Formatting                 Combining Strings
    Encoding/Encrypting

Get Information:
----------------
 AllDigits() - Return .T. if the passed string contains only digits
    Input: cTheStr - The string to check
     Retn: .T. if it's all digits, else .F.

 AnyDigits() - Return .T. if the passed string contains ANY digits
    Input: cTheStr - The string to check
     Retn: .T. if there are any digits, else .F.

 AllCAPS() - Return .T. if a string contains only digits and CAPITAL letters
    Input: cTheStr - The string to check
     Retn: .T. if it's all digits and CAPITAL letters, else .F.

 IsNumber() - Return .T. if the passed string starts with a number
    Input: cTheStr - The string to check (pass as @cTheStr if you want
                      the numeric portion)
           cRem - Trailing characters after number (optional; passed as
                      @cRem)
     Retn: .T. if it's a number, else .F.
           cRem has trailing characters if passed as @cRem

 AtNotInDelim() - Return the pos'n of a char NOT within delimeters
    Input: cTheChar - The character in question
           cTheStr  - The string to search
           cDelim  - The left and right delimeter pair
     Retn: The position (0 if not there or if only within ())

 AtNotInParen() - Return the position of a char in a string outside of any ()
    Input: cTheChar - The character in question
           cTheStr - The string to search
     Retn: The position (0 if not there or if only within ())

 FldsInExpr() - Returns a list of field names within an index expression
    Input: cExpr - The index expression in question
     Retn: List of Field Names

 FirstAt() - Find the first position of some strings in some text
    Input: cStrList - Comma-delimited strings to search for (e.g.
                          "ABC,DEF,GHI")
           cText    - Search for them in this text
           cFndStr  - (optional) if passed as @cFndStr, will contain the
                          string found
     Retn: The position number of the first string found

 FirstCap() - Return the first number or capital letter of a string
    Input: cStrIn - String for evaluation
     Retn: 1st number or capital letter in string

 Get1stPosn() - Get the 1st position (R or L) of any of some chars
    Input: cCharList - A string of characters to look for
           cLongString - The string to search
           bFromRight - If .T., search starts from right, else from left
     Retn: 1st position number of one of the characters

 GetArg - Return the contents within parentheses for a passed name
   Input: cSrcTxt - String containing "name1,name2(arg2),name3(arg3)" text
          cFuncName - Function name
          cSepChar - Character separating arguments (e.g. ",")
    Retn: Argument text within the parentheses (if any)

 GetArgValue() - Return the Value from a Name=Value clause
    Input: cTextIn - Text containing Name=Value clause (NOTE: Pass this
                      as @cTextIn and the Name=Value clause will be
                      extracted.)
           cName - Name where Value is desired
     Retn: The Value argument after the = sign

 GetArticle() - Return the appropriate article for the passed noun
    Input: cNoun - Noun in question
           bNoFirstCap - .T. if first letter of article should NOT be cap
    Retn: 'A ' or 'An '

 GetInitials() - Return the initials for the passed name
    Input: cNameIn - Name from which initials are to be extracted
     Retn: Up to 5 initials within the name

 GetEndingDigits() - Return the trailing digits (if any) in a passed string
    Input: cStr - String in question
     Retn: The trailing digits in the string, e.g. "ABC45DH132" --> "132"

  HasLowerCase() - Return .T. if the passed string has any lowercase letters
     Input: cStr - String in question
      Retn: .T. if there are any lowercase letters in cStr

  HasUpperCase() - Return .T. if the passed string has any uppercase letters
     Input: cStr - String in question
      Retn: .T. if there are any uppercase letters in cStr


Extract Parts (of a string):
----------------------------
 GetEmailDomain() - Return the domain from an email address
    Input: cStr - Email address string
     Retn: The domain from that email address

 ExtrNumber() - Extract a number from the beginning of a string
    Input: cStr - String for extraction (passed as @cStr if you want
                      the remainder returned)
     Retn: Number or Numeric Expression extracted from the string
           Remainder in cStr if it was passed as @cStr

 EvalLogicExpr() - Evaluate "Arg" in a Name(Arg) str as .T. (default) or .F.
    Input: cSrcTxt - String containing Name(Arg) clause like:
                      "Name1(arg1), Name2(arg2), ..."
           cFuncName - Name in the Name(Arg) clause
           cClauSep - Character separating multiple clauses (e.g. ",")
     Retn: Retn: .T. or .F.

 ExtrClauseArg() - Extract a clause argument: (IN clause AS clause)
    Input: cSrcTxt - String for extraction (must be passed as @cStrIn for
                      any extraction to actually take place)
           cIDWord - Word in cSrcText (such as "IN" or "AS")
     Retn: Extracted clause

 ExtrFldName() - Extract the first field name from an expression
    Input: cExpr - String for extraction
     Retn: Extracted field name

 ExtrLine() - Extract a max length line from a large string
    Input: cStrIn - String for extraction (must be passed as @cStrIn for
                      any extraction to actually take place)
           nDesLen - Desired length of string
           bKillIntEnds - (Optional) .T. if internal blank lines are to
                      be removed (default = .F.)
     Retn: Extracted line
           cStrIn is split on whitespace as close to nDesLen as possible
              (if there is no whitespace, it's just chopped).  Whitespace
              is: spaces, TABs, CRs, LFs, and HEX_FFs.

 ExtrLineWithText() - Extract entire line containing some text
    Input: cStrIn - String for extraction
           cSrchTxt - Text to look for
     Retn: Text but without the line(s) that had cSrchTxt

 IsQuoted() - Return .T. if the string is surrounded by quotes
    Input: cStrIn - String for evaluation
           cQuoteChar - (optional; passed as @cQuoteChar) The quote
                  character use for quotation
     Retn: .T. if the string is quoted and cQuoteChar filled in, or .F.

 ExtrQuoted() - Extract the contents, within quotes, from a string
    Input: cStrIn - String for extraction (must be passed as @cStrIn for
                      any extraction to actually take place)
           cQuoteChar - The quotation character (' or ")
     Retn: Quoted contents
           cStrIn - String without the quoted contents or quotes

 ExtrToken() - Extract and return the text before a passed token (char)
    Input: cStrIn - String for extraction (if passed as @cStrIn, the
                      fragment and token are really extracted)
           cTokenChar - Character separator
     Retn: Text in cStrIn before the first cTokenChar

 ExtrVarValue() - Return "Val" from many "VarName=Val^" entries in text
    Input: cVarName - The name of the variable
           cTextIn - The string that might contain a "VarName=Value^"
                      line.
                     Notice that values are terminated with ^s or CRs.
     Retn: The "Val" clause of the value line

 GetVarValue - Return the value in a "VarName=Val" line
    Input: cValLine - The string containing a "VarName=Val" line.  The
                      string can contain more than one of these but only
                      the value after the first = sign is returned.
     Retn: The "Val" clause of the value line

 SplitPosition() - Cut a string at the passed position number and return the left side
    Input: cStrIn - The input string to be split (passed as @cStrIn)
           nPosn - The position to cut the string at
     Retn: The LEFT part of the string up to and including nPosn
           cStrIn - RIGHT part of the string starting at nPosn + 1
     Note: If nPosn < 1, the returned string will be empty and cStrIn
              is unchanged.

 SplitString() - Split the passed string to the desired length
    Input: cStrIn - The input string to be split (passed as @cStrIn)
           nLength - Desired line length
     Retn: String returned as the leftmost part of cStrIn after split
           cStrIn - LTRIMmed remainder of cStrIn after split (only if
                  passed as @cStrIn)
           vbHardCR - (must have been setup as PRIVATE) set as .T. if
                  split occurs at HEX_FF
     Note: Will convert CR_LFs to HEX_FFs.

 CleanString() - Remove non-alpha, non-digit, non-space characters
    Input: cStrIn - The input string to be checked
           cExceptions - (optional) Characters to leave in (e.g. ".")
     Retn: String returned with only alpha or digit characters

 GetNextWord() - Extract the next word from a string
    Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
                      for the extraction to take place.
           cAddChars - (Optional) Chars to be added to THIS.cWordChars
                       for check.
     Retn: The next word ending at the first non-word character
           cTextIn will have the remaining text starting with that
              non-word character - if passed as @cTextIn.

 GetLastWord() - Extract the last word from a string
    Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
                      for the extraction to take place.
           cAddChars - (Optional) Chars to be added to THIS.cWordChars
                       for check.
     Retn: The Last word ending at the first non-word character
           cTextIn will have the text prior to that word - if passed as
              @cTextIn.

 ExtractWords() - Extract only whole words up to a maximum length
    Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
                      for the extraction to take place.
           nMaxLen - Maximum length of returned string of words
  CAUTION: Be sure there are no CRs or LFs in cTextIn; that's confusing
     Retn: A string of whole words not exceeding nMaxLen

 CSVToArray() - Convert a CSV line's elements into an array
    Input: cCSVLineIn - The CSV Line, e.g. 12345,"Last, First",45TSS,...
     Retn: An array object separated based on quotes, e.g.
              .aRA[1] - 12345
              .aRA[2] - Last, First
              .aRA[3] - 45TS

Modify the String:
------------------
 CheckStrValues() - Separate a string of entries into good and bad strings
    Input: cEntries - String needing checking
           cCheckStr - String of valid entries
           cBadEnts - Passed as @cBadEnts will contain invalid entries
           cSeparator - optional, Character separating entries and cCheckStr,
                the default value = ","
     Retn: cGoodEnts - Will contain only entries that are valid
           cBadEnts - Will contain invalid entries
     WARNING: Not reliable if entries contain quotes or if passed values have
           internal spaces before of after the separator

 SetTextLeftMargin() - Change the left margin of the passed text block
    Input: cTextIn - String needing reduced/added margin
           nWantLMarg - Desired new margin
     Retn: cTextIn has spaces at left matching new margin

 NormalizeNumber() - Return a number string in normal d.ddEee  format
    Input: cStrIn - Number string to be normalized
     Retn: cStrIn converted 3 significant digits in d.ddEee form

 ClearPunct() - Remove all except characters and digits from passed string
    Input: cStrIn - String to process
           bKeepSpcs - If .T., spaces are retained (default = .F.)
     Retn: String with non-formatting chars removed

 ClearEndPunct() - Remove ending punctuation characters
    Input: cTheStr - The passed string to de-punctuate (is that a word?)
     Retn: String with trailing punctuation chars removed

 AddQuotes2Text() - Add appropriate quote characters to the passed text
     Input: cStrIn - String that may have embedded quotes
      Retn: cStrIn with quotes added no matter what

 CleanMemo() - Remove a memo's leading lines and trailing white space
    Input: cMemoIn - Memo string to be cleaned up
           cLeadOpt - (optional) Char. that defines what to cleanup:
                  'B' - (default) Cleanup both the start and the end
                  'L' - Only remove completely blank beginning lines
                      (but no other whitespace on a line with real
                      characters)
                  'N' - Don't remove anything from the start; only at
                      the end
     Retn: Cleaned up memo string

 FormatPhone() - Apply the correct formatting to the passed phone
    Input: cPhoneIn - 9999999 or 9999999999 or empty string
     Retn: 999-9999 or (999) 999-9999 or ''

 FlushLeft() - Return a string with characters moved flush left
    Input: cStrIn - String that may not be flush left
     Retn: cStrIn guaranteed to be flush left

 FlushRight() - Return a string with characters moved flush right
    Input: cStrIn - String that may not be flush right
     Retn: cStrIn guaranteed to be flush right

 FlushRZero() - Return a string with characters flush right, 0-filled
    Input: cStrIn - String that may not be flush right or 0-filled
     Retn: cStrIn guaranteed to be flush right and 0-filled if needed

 ListMemo() - Return a memo converted to CR_LF terminated lines
    Input: cMemo - Memo field or string
           nMaxLen - Maximum desired line length
           cIndentStr - Preface to 2nd and remaining lines
           bIsDisplay - If .T. and EMPTY(cMemo), "(none>" is returned, else
    Retn:  str1 + CR_LF +
           cIndentStr + str2 + CR_LF +
           cIndentStr + str3 + CR_LF... +
           cIndentStr + strX

 MakeLen() - Return a string at the desired length (chop or space fill)
    Input: cStrIn - String to have length changed
           nDesLen - New desired length
           bAddMT - .T. if "<empty>" should be put in empty strings that
                      are long enough
     Retn: cStrIn at the new length

 MakeProper() - PROPERly capitalize a string IF it's all UC or all LC
    Input: cStrIn - String to be checked
     Retn: String with proper capitalization

 ForceProper() - Convert string to lower, then proper capitalization
    Input: cStrIn - String to be checked
     Retn: String with proper capitalization

 ExtrQuotes() - Return an array object with quoted and non-quoted parts
    Input: cLineIn - String line to be split
     Retn: Array Object with rows for quoted and unquoted lines as:
              oObj.aRA[x,1] = Text part of line
              oObj.aRA[x,2] = .T. if text is quoted

 Plural() - Return the plural form of the passed noun
    Input: cNoun - The singular noun to "pluralize"
           nNumber - The number in question
           cPluralExt - (optional) The string to add to the noun if the
                   number is a plural (default = 's')
     Retn: If nNumber = 1: only the cNoun is returned
           Else: the cNoun + cPluralExt are returned

 CountPlural() - Return the count and plural form of the passed noun
    Input: cNoun - The singular noun to "pluralize"
           nNumber - The number in question
           cPluralExt - (optional) The string to add to the noun if the
                   number is a plural (default = 's')
           bFirstCap - .T. if the first return letter is to be capitalized
     Retn: If nNumber = 0: "no " + cNoun + cPluralExt is returned
           If nNumber = 1: "one " and the cNoun is returned
           Else: the number + cNoun + cPluralExt are returned

 ExtrPlural() - Return the singular form of the passed plural
    Input: cPlural - The plural noun
     Retn: The singular form of that plural

 StrToHTML() - Convert &, <, > chars for HTML output
    Input: cStrIn - Incoming string
    Output: TRIMmed cStrIn where &, < and >s are converted to escaped
            equivalents. If cStrIn is empty, it becomes "&nbsp;".
    CAUTION: Not to be used for INPUT values

 CharsToHTML() - Convert special characters into HTML equivalents
    Input: cStrIn - Incoming string
    Output: cStrIn where &, < and >s are converted to escaped HTML
            equivalents.
    CAUTION: Not to be used for INPUT values

 WebTrim() - Trim a string variable for HTML output
    Input: cStrIn - String to be trimmed
     Retn: Trimmed cStrIn, or non-breaking space if cStrIn is empty

 PostTrim() - Trim a string variable and remove artifacts
    Input: cStrIn - String to be checked
     Retn: Trimmed cStrIn with Non-breaking spaces and 0FFhs removed

 PostVal() - Return a numeric after removing artifacts
    Input: cStrIn - String to be checked
     Retn: VAL() of cStrIn after non-breaking spaces and 0FFhs removed

 StripChrs() - Remove one or more characters from a passed string
    Input: cStrIn - String to be checked
           cDelChars - String of characters to be removed
     Retn: String with cDelChars characters removed

 WordWrapString() - Reformat a string with CR_LF lines
    Input: cStrIn - String to be word-wrapped
           nMaxLinLen - Max. length of a line
           nIndentSpcs - Prepend this from 2nd line on
           bKillIntEnds - (Optional) .T. if internal blank lines are to
                      be removed (default = .F.)
     Retn: Word-wrapped string

 SwapPhrase() - Substitute all instances of a word/phrase with a 2nd word/phrase
    Input: cStrIn - String to be changed
           cPhraseIn - Phrase to be changed
           cNewPhrase - Phrase to be put in plase of cPhraseIn
     Retn: Changed string
    Notes: 1. This is a case-insensitive swap.
           2. cPhraseIn must be within word boundaries at each end

 CreateSpecialKey() - Return a key with 1 of 72 possible characters
    Input: nStrLen - Desired length of string
     Retn: New string containing a random selection of these characters:
            0-9, A-Z, a-z and !@#$%*()+


Output Formatting:
------------------
 Format() - Return the passed string with variable values inserted
    Input: cString - String to have variable values inserted. Example:
              {0}, your {1:D} purchase total was {2:c}. Thank you {0}."
                  The curly brackets define the variable number to be
                  inserted (0-based). the : defines formatting codes.
           vPara0, vPara1,...vPara9 - Variables to be converted to
              strings and inserted (up to 9 variables)
     Retn: String with variable values inserted.  For example, if the
           variable values were:
              cUserName   = "Joe"
              dBuyDate    = {03/19/2010}
              nInvoiceAmt = $43.63
           The string would be: "Joe, your March 19, 2010 purchase total
                                 was $43.63. Thank you Joe."

 DateFormat() - Format a Date or DateTime into a string
    Input: dtConvert - Date or DateTime variable to be converted
           cFormat - Formatting codes
     Retn: String of Date or DateTime converted according to the format
    Formatting Codes are:
      Code      Convert to                    Output Format
      ----    --------------------------  -----------------------------
        d     Short date                  10/12/2002
        D     Long date, short month      Dec. 10, 2002
        L     Long date                   December 10, 2002
        f     Full date & time            December 10, 2002 10:11 PM
        F     Full date & time (long)     December 10, 2002 10:11:29 PM
        g     Default date & time         10/12/2002 10:11 PM
        G     Default date & time (long)  10/12/2002 10:11:29 PM
        M     Month day pattern           December 10
        r     RFC1123 date string         Tue, 10 Dec 2002 22:11:29 GMT
        s     Sortable date string        2002-12-10T22:11:29
        t     Short time                  10:11 PM
        T     Long time                   10:11:29 PM
        u     UTC sortable format*        2002-12-10 22:13:50Z
        U     UTC time (long)*            December 11, 2002 3:13:50 AM
        Y     Year month pattern          December, 2002
      * This format does no conversion from the passed date/time variable - it
        must already be a UTC date or date/time value.

 NumericFormat() - Format a Number or Currency value into a string
    Input: nConvert - Number or Currency variable to be converted
           cFormat - Formatting codes
     Retn: String of Number or Currency converted according to the format
    Formatting Codes are (these codes may be followed by an integer, y):
      Codes   Type       y = (default)   Example                      Notes
      -----  ----------- -------------  --------------------------  ---------------
      Cy cy  Currency    Decimals (2)   C2: -123.456 -> ($123.46)   Rounded
      Iy Iy  Integer     Min. digits    I6: -1234 -> -001234        Note 1
      Ey ey  Exponent    Decimals (6)   e3: -1052.9 -> -1.053e+003  Note 2, rounded
      Fy fy  Fixed-pt    Decimals (6)   F4: -1234.56 -> -1234.5600  Rounded
      Gy gy  General     Sig. Digits    G4: 123.4546 -> 123.5       Rounded, 9 max.
      Ny ny  Number      Decimals (2)   N1: 1234.567 -> 1,234.6     Rounded
      Py py  Percent     Decimals (2)   P1: -0.39678 -> -39.7%      Rounded, * 100
      Xy xy  Hexadecimal Min. digits    x4: 255 -> 0x00ff           Note 2
      Notes:
      1. I Format: This is not used in C#. We use it here because the numbers
         to be formatted are supposed to be integers.  However, in C# this is
         called the D(ecimal) format -- which makes no sense to me. Though not
         shown above the D format is implemented in KStrings and it does the
         same thing as the I format.
      2. Note that output letters are the same case as the passed format
         letter.
      3. C# implements a Ry/ry Round-Trip code. Its purpose is to define a
         string that can go on a round-trip and be comverted back to the same
         number. It only applies to Single, Double, and BigInteger numbers.
         That code is not implemented here as it isn't of any use.
      4. For more examples, see Ref\Numeric.txt.

 LogicalFormat() - Format a Logical value into a string
    Input: bValue - Logical value to be converted
           cFormat - Formatting codes
     Retn: String of Logical converted according to the format
    Formatting Codes are (these codes may be followed by an integer, y):
      Codes   Type            z =          Example            Notes
      -----  ------------- -------------  ------------------  ------
      Tz tz  True or False Chars to show  T4: .F. -> Fals     Note 1
      Yz yz  Yes or No     Chars to show  y3: .F. -> no       Note 1
      Notes:
      1. Note that the first output letter is the same case as the passed
         format letter.


VFP Code Formatting:
--------------------
 Comm2Code() - Format one comment line to fit within a specified length
    Input: cLineIn - Comment line to be formatted
           nMaxLen - Max. length of output string
     Retn: Formatted line with any necessary " ;" line continuations.

 Line2Code() - Format one line of code to fit within a specified length
    Input: cLineIn - String line to be formatted
           nMaxLen - Max. length of output string
     Retn: Formatted line with any necessary " ;" line continuations.
              Quoted strings will be split properly (with quotes at split)

 FormatCode() - Format a block of text as VFP Code with ; carry-overs
    Input: cTextIn - String to be formatted (can be multiple lines)
           nRightMargin - (optional) desired right margin (e.g. max.
                  length of output string - default = 80)
     Retn: Formatted string with any necessary " ;" line continuations.
              Quoted strings will be split properly (with quotes at split)


Encoding/Encrypting:
--------------------
 EncryptIt(cStrIn) - Return an encrypted string
     Input: cStrIn - URL String to be encrypted
      Retn: Encrypted string

 DecryptIt(cStrIn) - Decrypt a string that was encrypted with EncryptIt()
     Input: cStrIn - URL String to be decrypted
      Retn: Decrypted string

 EncodeURL(cStrIn) - Encode a string in an HTML FORM's GET METHOD format
     Input: cStrIn - String to be URL encoded
      Retn: Encoded string

 DecodeURL(cStrIn) - Decode a string in an HTML FORM's GET METHOD format
    Input: cStrIn - URL String to be decoded
     Retn: Decoded string

 Base64Encode(cStr) - Convert the passed string by BASE64 encoding
     Input: cStr - String to be BASE64 encoded
      Retn: Encoded string

 Base64Decode(cStr) - Decode the passed BASE64 string
    Input: cStr - String to be BASE64 decoded
     Retn: Decoded string


PICTURE Methods:
------------------
 ClearPict() - Remove all except characters and digits from passed string
    Input: cTheVar - Passed PICTURE string
           bKeepSpcs - (optional) .T. if you want to keep spaces
     Retn: String with non-formatting chars removed

 GetPicChrs() - Return the text substitute chars in a "PICTURE" string
    Input: cTheVar - Passed PICTURE string
     Retn: String with non-formatting chars removed

 TrimPict() - Remove trailing picture characters from the passed string
    Input: cTheVar - Passed string
     Retn: String with trailing -,./\s removed

 RemoveOddHexChars() - Remove hex characters 0h-31h, 255h except LF, CR, FF
    Input: cMemoIn - Memo string to be cleaned up
           bKillFF - Also remove the Form-Feed character (12h)


Type Conversions:
-----------------
 CharToX() - Convert a string to a variable of the passed type
     Input: cTextIn - String that may have embedded quotes
            cType - Type of conversion desired
      Retn: Desired value

 XToChar() - Convert any value into a string
    Input: xValue - Value to be converted
     Retn: String after conversion

 EscapeXML() - Escape special XML characters
    Input: cStrIn - String for XML to be checked
     Retn: String with special XML characters escaped

 GetDurationStr() - Return a human readable time string
    Input: xSeconds - Number of elapsed seconds
     Retn: ww days, xx hrs, yy mins and zz secs
     Note: The leading items won't be shown if they're 0

 RoundOff() - Round off a number to x decimal places

 RoundUp() - Round up a number it's hightest possible integer: 2.0003 --> 3

String Incrementing:
--------------------
    Notes: There are 5 incrementing methods.  They all take an input string as
           the starting point and that string length is never increased.  But,
           some functions will fill in spaces within the string if they need
           to.

 IncrNumbPart() - Increment numbers within a string keeping any chars
      Base 10; no length change, will use spaces on right if needed.
    Input: cStrIn - String to be incremented
     Retn: Incremented String

 IncrNumeric() - Numerically increment a string and 0-fill on left
      Base 10; no length change, will 0-fill from left if needed.
    Input: cStrIn - String to be incremented
           nIncrAmt - (optional) desired incrementing amount (default = 1)
           cLeftFill - (optional) Other left filling character (default = '0')
     Retn: Incremented String

 IncrAlpha() - Alpha- or Alphanum- increment a string and zero-fill on left
      Base 26 (alpha) or 36 (alphanum); no length change, will 0 fill
      (alphanum) or space fill (alpha) from left if needed; ignores
      trailing spaces.
    Input: cStrIn - String to be incremented
           bAlphaOnly - (optional) .T. if base 26 incrementing is wanted,
                          default = .F.
     Retn: Incremented String

 IncrFLStr() - Alphanum- or numerically-increment a flush left string
      Base 36 (alphanum) or 10 (numeric); no length change but spaces on
      the right may be used if needed, no other fills.
    Input: cStrIn - String to be incremented
           cIncrType - (optional) Increment type:
                          'A' - alphanumeric incrementing (base 36)
                          '1' - numeric incrementing (base 10)
                      default is: do an alphanumeric increment if the passed
                      string has any characters, else to do a numeric
                      increment.
     Retn: Incremented String

 IncrFRStr() - Alphanum- or numerically-increment a flush right string
      Base 36 (alphanum) or 10 (numeric); no length change but spaces on
      the left may be used if needed, no other fills.
    Input: cStrIn - String to be incremented
           cIncrType - (optional) Increment type:
                          'A' - alphanumeric incrementing (base 36)
                          '1' - numeric incrementing (base 10)
                      default is to do an alphanumeric increment if the
                      passed string has any characters, else to do a
                      numeric increment.
     Retn: Incremented String


Multiple Option Strings:
------------------------
 GetNextOption() - Extract the next Name:Value pair from an option string
    Input: cOptStr - String of options containing Name=Value pairs like:
                      "Name1=Value1^Name2=Value2^Name3=Value3^..."
           cValue - The option's value (passed as @cValue; default = '')
           cNameSep - (optional) char separating Name and Value (default = ':')
           cOptionSep - (optional) char separating Options (default = '~')
     Retn: The Name of the option; cValue is filled in


Combining Strings:
------------------
 SetCityStateZip() - Return City, State, Zip combined
    Input: cOptStr - String of options containing Name=Value pairs like:
                      "Name1:Value1^Name2:Value2^Name3:Value3^...".  Must
                      be passed as @cOptStr for extraction to take place
           cValue - The option's value (passed as @cValue; default = '')
           cNameSep - (optional) char separating Name and Value (default = ':')
           cOptionSep - (optional) char separating Options (default = '~')
     Retn: The Name of the option; cValue is filled in
     Note: Only string options are used.

 AddToString() - Add string to another with separator if neither is empty
    Input: cStr1 - The starting string
           cStr2 - The string to be added
           cSep - The separator (, ; and so forth)
    Retn: If neither string is empty: cStr1 + cSep + ' ' + cStr2
          If either string is empty, it's just the non-empty string

*****************************************************************************
#ENDIF

* Some Defines
#DEFINE CR           CHR(13)
#DEFINE LF           CHR(10)
#DEFINE CR_LF        CHR(13) + CHR(10)
#DEFINE TAB          CHR(9)
#DEFINE FORMFEED     CHR(12)
#DEFINE HEX_FF       CHR(255)

* Create and return our object
LOCAL oObj
m.oObj = CREATEOBJECT('KStrings')
RETURN m.oObj


****************************** Classes Defined ******************************

* KStrings Class Definition for this function class
DEFINE CLASS KStrings AS Custom

    * Standard Properties
    Name = 'KStrings'

    * Custom Properties
    cPictFormatChrs = '@ANXY9#!$'   && PICTURE format directive characters
    cPictTextChrs = '-,./\'         && PICTURE Textual substitution characters
    cWhiteSpace = ' ' + TAB         && What whitespace is within a line
    cLineEnds = CR + LF + HEX_FF    && Line ending chars (also whitespace)
    cWordChars = 'abcdefghijklmnopqrstuvwxyz01234567890'
    cComplexChars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%*()+' + ;
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

    * Block the Properties not relevant here
    PROTECTED ClassLibrary, Comment, ControlCount, Controls, Height, Left, ;
      Object, Picture, Tag, Top, Width

    * Block the Methods not relevant here
    PROTECTED AddObject, AddProperty, NewObject, ReadExpression, ReadMethod, ;
      RemoveObject, ResetToDefault, SaveAsClass, WriteExpression, WriteMethod

    * Custom Methods (see list above)

        ***** Get Information *****

    *- AllDigits() - Return .T. if the passed string contains only digits
    *     Input: cTheStr - The string to check
    *      Retn: .T. if it's all digits, else .F.
    FUNCTION AllDigits(cTheStr)
        LOCAL cGoodChars, nX

        * Check for the digits
        m.cGoodChars = '1234567890'
        FOR m.nX = 1 TO LEN(m.cTheStr)
            IF NOT SUBSTR(m.cTheStr, m.nX, 1) $ m.cGoodChars
                RETURN .F.
            ENDIF
        ENDFOR
        RETURN .T.
    ENDFUNC

    *- AnyDigits() - Return .T. if the passed string contains ANY digits
    *     Input: cTheStr - The string to check
    *      Retn: .T. if there are any digits, else .F.
    FUNCTION AnyDigits(cTheStr)
        LOCAL cGoodChars, nX

        * Check for the digits
        m.cGoodChars = '1234567890'
        FOR m.nX = 1 TO LEN(m.cTheStr)
            IF SUBSTR(m.cTheStr, m.nX, 1) $ m.cGoodChars
                RETURN .T.
            ENDIF
        ENDFOR
        RETURN .F.
    ENDFUNC

    *  AllCAPS() - Return .T. if a string contains only digits and CAPITAL letters
    *     Input: cTheStr - The string to check
    *      Retn: .T. if it's all digits and CAPITAL letters, else .F.
    FUNCTION AllCAPS(cTheStr)
        LOCAL cGoodChars, nX

        * Check for the digits
        m.cGoodChars = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ '
        FOR m.nX = 1 TO LEN(m.cTheStr)
            IF NOT SUBSTR(m.cTheStr, m.nX, 1) $ m.cGoodChars
                RETURN .F.
            ENDIF
        ENDFOR
        RETURN .T.
    ENDFUNC

    *- IsNumber() - Return .T. if the passed string starts with a number
    *     Input: cTheStr - The string to check (pass as @cTheStr if you want
    *                       the numeric portion)
    *            cRem - Trailing characters after number (optional; passed as
    *                       @cRem)
    *      Retn: .T. if it's a number, else .F.
    *            cRem has trailing characters if passed as @cRem
    FUNCTION IsNumber(cTheStr, cRem)
        LOCAL cNumb, cGoodChars, nX

        * Assumption: 8X9216 is NOT a number; 45" IS a number as is 25YARDS

        * We're to:
        *   1. Extract non-numeric trailing characters
        *   2. See if what's left is a number

        * Extract the numeric part
        m.cRem = m.cTheStr
        m.cNumb = THIS.ExtrNumber(@m.cRem)
        IF EMPTY(m.cNumb)     && Not a number
            RETURN .F.
        ENDIF

        * Here, we know we start with a number and cRem has any trailing
        *   characters.  Now, we have to check each digit.
        *   Note: Commas were removed by ExtrNumber()
        m.cGoodChars = '1234567890+-*/.'
        FOR m.nX = 1 TO LEN(m.cNumb)
            IF NOT SUBSTR(m.cNumb, m.nX, 1) $ m.cGoodChars
                RETURN .F.
            ENDIF
        ENDFOR

        * Here, we know it's a number, put it in the passed string
        m.cTheStr = m.cNumb
        RETURN .T.
    ENDFUNC

    *- AtNotInDelim() - Return the pos'n of a char NOT within delimeters
    *     Input: cTheChar - The character in question
    *            cTheStr  - The string to search
    *            cDelim  - The left and right delimeter pair
    *      Retn: The position (0 if not there or if only within ())
    FUNCTION AtNotInDelim(cTheChar, cTheStr, cDelim)
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
        IF NOT m.cTheChar $ m.cTheStr
            RETURN 0
        ENDIF

        * Separate our delimiters
        m.cRDelim = SUBSTR(m.cDelim, 2)
        m.cLDelim = LEFT(m.cDelim, 1)

        * Return almost as quickly if the left delimiter isn't in the string --
        *   giving the best answer we can
        IF NOT m.cLDelim $ m.cTheStr
            RETURN AT(m.cTheChar,m.cTheStr)
        ENDIF

        * Now, we know the character is in the string and we DO have
        *   delimiters.  But, we really have 2 routines:
        *       1. If the delimeters are the same
        *       2. If they're different
        IF m.cRDelim = m.cLDelim

            * This is simpler than different delimeters as, by definition,
            *   nested delimeters is a meaningless term
            m.cWkgStr = m.cTheStr
            m.cDiscards = ''
            m.nCharPosn = 0
            DO WHILE LEN(m.cWkgStr) > 0

                * Find the first instance of left and right delimiters
                m.nLPosn = AT(m.cLDelim, m.cWkgStr)
                m.nRPosn = AT(m.cLDelim, m.cWkgStr, 2)

                * Find the first instance of our character
                m.nCharPosn = AT(m.cTheChar,m.cWkgStr)

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
                m.cDiscards = m.cDiscards + LEFT(m.cWkgStr, m.nRPosn)
                IF m.nRPosn = LEN(m.cWkgStr)
                    m.cWkgStr = ''
                ELSE
                    m.cWkgStr = SUBSTR(m.cWkgStr, m.nRPosn+1)
                ENDIF
            ENDDO   && WHILE LEN(cWkgStr) > 0
        ELSE    && Delimiters are different

            * The tricky part with different delimiters is that the delimiters might
            *   be nested.
            m.cWkgStr = m.cTheStr
            m.cDiscards = ''
            m.nCharPosn = 0
            DO WHILE LEN(m.cWkgStr) > 0

                * Find the first instances of left and right delimiters
                m.nLPosn = AT(m.cLDelim, m.cWkgStr)
                m.nRPosn = AT(m.cRDelim, m.cWkgStr)

                * Find the first instance of our character
                m.nCharPosn = AT(m.cTheChar,m.cWkgStr)

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
                m.nLPosn = RAT(m.cLDelim, LEFT(m.cWkgStr,m.nRPosn)) && Match right paren

                * Save that which we are about to extract
                m.cDiscards = m.cDiscards + SUBSTR(m.cWkgStr, m.nLPosn, m.nRPosn-m.nLPosn+1)

                * Extract the nested parenthesis
                m.cLeftSide = IIF(m.nLPosn=1, '', LEFT(m.cWkgStr,m.nLPosn-1))
                m.cRightSide = IIF(m.nRPosn=LEN(m.cWkgStr), '', SUBSTR(m.cWkgStr,m.nRPosn+1))
                m.cWkgStr = m.cLeftSide + m.cRightSide

                * Reset for our loop
                m.nCharPosn = 0
            ENDDO   && WHILE LEN(cWkgStr) > 0
        ENDIF

        * Done
        RETURN m.nCharPosn + LEN(m.cDiscards)
    ENDFUNC

    *- AtNotInParen() - Return the pos'n of a char NOT within parentheses
    *     Input: cTheChar - The character in question
    *            cTheStr - The string to search
    *      Retn: The position (0 if not there or if only within ())
    FUNCTION AtNotInParen(cTheChar, cTheStr)
        RETURN THIS.AtNotInDelim(m.cTheChar, m.cTheStr, '()')
    ENDFUNC

    *- FldsInExpr() - Returns a list of field names within an index expression
    *     Input: cExpr - The index expression in question
    *      Retn: List of Field Names
    FUNCTION FldsInExpr(cExpr)
        LOCAL cWkgExpr, cFldList, nX, cThisFld

        * First, extract any special clauses
        m.cWkgExpr = UPPER(ALLTRIM(m.cExpr))
        IF ' FOR ' $ m.cWkgExpr
            m.cWkgExpr = LEFT(m.cWkgExpr, AT(' FOR ',m.cWkgExpr)-1)
        ENDIF
        IF ' UNIQUE' $ m.cWkgExpr
            m.cWkgExpr = LEFT(m.cWkgExpr, AT(' UNIQUE',m.cWkgExpr)-1)
        ENDIF
        IF ' DESCENDING' $ m.cWkgExpr
            m.cWkgExpr = LEFT(m.cWkgExpr, AT(' DESCENDING',m.cWkgExpr)-1)
        ENDIF
        IF ' ASCENDING' $ m.cWkgExpr
            m.cWkgExpr = LEFT(m.cWkgExpr, AT(' ASCENDING',m.cWkgExpr)-1)
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
                m.cThisFld = TRIM(LEFT(m.cWkgExpr, m.nX-1))
                m.cWkgExpr = LTRIM(SUBSTR(m.cWkgExpr, m.nX+1))
            ENDIF

            * Remove any field conversions
            m.cThisFld = THIS.ExtrFldName(m.cThisFld)

            * If we still have a '+' sign in cThisFld, it needs more
            *   processing, so put it back in cWkgExpr.  Otherwise, add it to
            *   our return string
            IF '+' $ m.cThisFld
                m.cWkgExpr = m.cThisFld + m.cWkgExpr
            ELSE
                m.cFldList = m.cFldList + IIF(EMPTY(m.cFldList), '', ',') + m.cThisFld
            ENDIF
        ENDDO
        RETURN m.cFldList
    ENDFUNC

    *- FirstAt() - Find the first position of some strings in some text
    *     Input: cStrList - Comma-delimited strings to search for (e.g.
    *                           "ABC,DEF,GHI")
    *            cText    - Search for them in this text
    *            cFndStr  - (optional) if passed as @cFndStr, will contain the
    *                           string found
    *      Retn: The position number of the first string found
    FUNCTION FirstAt(cStrList, cTextIn, cFoundStr)
        LOCAL nFndPosn, cLookFor, nZ

        * Example:
        *   cStrList = "ABC,DEF,GHI"
        *               1234567890123456789012345678901
        *   cTextIn = "Now I know my ABCs.  Oh DEF, GHI it!"
        *   Returns: 14 (position of ABC; DEF is at 24, GHI is at 27)
        *            cFoundStr = 'ABC'

        * Assume we'll find nothing
        m.nFndPosn = 0
        m.cFoundStr = ''

        * cStrList is a comma-delimited string of items to search for (e.g.
        *   "ABC,DEF,GHI".  We have to look for each one
        m.cTextIn = UPPER(m.cTextIn)
        DO WHILE LEN(m.cStrList) > 0
            m.cLookFor = THIS.ExtrToken(@m.cStrList, ',')
            m.nZ = AT(UPPER(m.cLookFor), m.cTextIn)
            IF m.nZ > 0 AND (m.nFndPosn = 0 OR m.nZ < m.nFndPosn)
                m.nFndPosn = m.nZ
                m.cFoundStr = m.cLookFor
            ENDIF
        ENDDO

        * Done
        RETURN m.nFndPosn
    ENDFUNC

    *- LastAt() - Find the LAST position of some strings in some text
    *     Input: cStrList - Comma-delimited strings to search for (e.g.
    *                           "ABC,DEF,GHI")
    *            cText    - Search for them in this text
    *            cFndStr  - (optional) if passed as @cFndStr, will contain the
    *                           string found
    *      Retn: The position number of one the first string found
    FUNCTION LastAt(cStrList, cTextIn, cFoundStr)
        LOCAL nFndPosn, cLookFor, nZ

        * Example:
        *   cStrList = "ABC,DEF,GHI"
        *               1234567890123456789012345678901
        *   cTextIn = "Now I know my ABCs.  Oh DEF, GHI it!"
        *   Returns: 14 (position of ABC; DEF is at 24, GHI is at 27)
        *            cFoundStr = 'ABC'

        * Assume we'll find nothing
        m.nFndPosn = 0
        m.cFoundStr = ''

        * cStrList is a comma-delimited string of items to search for (e.g.
        *   "ABC,DEF,GHI".  We have to look for each one
        m.cTextIn = UPPER(m.cTextIn)
        DO WHILE NOT EMPTY(m.cStrList)
            m.cLookFor = THIS.ExtrToken(@m.cStrList, ',')
            m.nZ = RAT(UPPER(m.cLookFor), m.cTextIn)
            IF m.nZ > 0 AND (m.nFndPosn = 0 OR m.nZ > m.nFndPosn)
                m.nFndPosn = m.nZ
                m.cFoundStr = m.cLookFor
            ENDIF
        ENDDO

        * Done
        RETURN m.nFndPosn
    ENDFUNC

    *- FirstCap() - Return the first number or capital letter of a string
    *     Input: cStrIn - String for evaluation
    *      Retn: 1st number or capital letter in string
    FUNCTION FirstCap(cStr)
        LOCAL nW, cLtr
        IF EMPTY(m.cStr)
            RETURN ''
        ENDIF
        FOR m.nW = 1 TO LEN(m.cStr)
            m.cLtr = SUBSTR(m.cStr, m.nW, 1)
            IF (UPPER(m.cLtr) == m.cLtr AND ISALPHA(m.cLtr)) OR ISDIGIT(m.cLtr)
                RETURN m.cLtr
            ENDIF
        ENDFOR

        * If we didn't find anything, just return the first letter
        RETURN UPPER(LEFT(m.cStr,1))
    ENDFUNC

    *- Get1stPosn()  Get the 1st position (R or L) of any of some chars
    *     Input: cCharList - A string of characters to look for
    *            cLongString - The string to search
    *            bFromRight - If .T., search starts from right, else from left
    *      Retn: 1st position number of one of the characters
    FUNCTION Get1stPosn(cCharList, cLongString, bFromRight)
        LOCAL nMinPosn, nListLen, nI, cThisChar, nCharAt

        * We have to return the leftmost position number (non-0) of any
        *   character (in cCharList) in the string cLongString.  If
        *   bFromRight = .T., we need to return the rightmost position.
        m.nMinPosn = 0
        m.nListLen = LEN(m.cCharList)

        * Look from the Right or Left
        IF m.bFromRight
            FOR m.nI = 1 TO m.nListLen
                m.cThisChar = SUBSTR(m.cCharList, m.nI, 1)
                IF m.cThisChar $ m.cLongString
                    m.nCharAt = RAT(m.cThisChar, m.cLongString)
                    IF m.nMinPosn = 0 OR m.nCharAt > m.nMinPosn
                        m.nMinPosn = m.nCharAt
                    ENDIF
                ENDIF
            ENDFOR
        ELSE            && From the left
            FOR m.nI = 1 TO m.nListLen
                m.cThisChar = SUBSTR(m.cCharList, m.nI, 1)
                IF m.cThisChar $ m.cLongString
                    m.nCharAt = AT(m.cThisChar, m.cLongString)
                    IF m.nMinPosn = 0 OR m.nCharAt < m.nMinPosn
                        m.nMinPosn = m.nCharAt
                    ENDIF
                ENDIF
            ENDFOR
        ENDIF
        RETURN m.nMinPosn
    ENDFUNC

    *- GetArg - Return the contents within parentheses for a passed name
    *    Input: cSrcTxt - String containing "name1,name2(arg2),name3(arg3)" text
    *           cFuncName - Function name
    *           cSepChar - Character separating arguments (e.g. ",")
    *     Retn: Argument text within the parentheses (if any)
    FUNCTION GetArg(cSrcTxt, cFuncName, cSepChar)
        LOCAL nPosn, cSrcRmndr, cSepar, nX, nY, cNounNArg

        * We're passed a block of text (cSrcTxt) supposedly containing at
        *   least one instance of cFuncName.  It may also have an argument
        *   within parentheses and will be separated from other functions (and
        *   args) by the cSepChar.  For example:
        *       cSrcTxt: "REQD(TYPE = 'A'), NOEDIT(TYPE = 'E')"
        * But, the control character may exist within the parentheses.  For
        *   example, if the control character is our default: ",":
        *       cSrcTxt: "REQD(TYPE = 'A'), VALID(TYPE $ 'EB', 'E or B')"

        * Our job is to get the entire argument for cFuncName, up to but
        *   excluding the cSepChar and to return the argument within the
        *   parentheses.

        * If cFuncName isn't in cSrcTxt, return quickly
        m.nPosn = AT(m.cFuncName, m.cSrcTxt)
        IF m.nPosn = 0
            RETURN ''
        ENDIF

        * Our name is in cSrcTxt, get everything from then on
        m.cSrcRmndr = SUBSTR(m.cSrcTxt, m.nPosn)

        * Remove the function name
        IF LEN(m.cSrcRmndr) = LEN(m.cFuncName)
            RETURN ''
        ELSE
            m.cSrcRmndr = LTRIM(SUBSTR(m.cSrcRmndr, LEN(m.cFuncName)+1))
        ENDIF

        * The default cSepar is ","; but use the passed one if appropriate
        m.cSepar = ','
        IF TYPE('cSepChar') = 'C' AND LEN(m.cSepChar) = 1
            m.cSepar = m.cSepChar
        ENDIF

        * Now, the next character should be the left parenthesis.  But, if we
        *   encounter a control character before that, there is no argument.
        m.nX = AT('(', m.cSrcRmndr)
        m.nY = AT(m.cSepar, m.cSrcRmndr)
        IF m.nX = 0 OR (m.nY > 0 AND m.nY < m.nX)
            RETURN ''
        ENDIF

        * Throw away everything before the left parenthesis
        THIS.ExtrToken(@m.cSrcRmndr, '(')

        * Return a null string if no no right parenthesis exists.
        IF NOT ')' $ m.cSrcRmndr
            RETURN ''
        ENDIF

        * Now we want to extract the contents up to the MATCHING right
        *   parenthesis but there may also be embedded parentheses
        m.nX = goStr.AtNotInParen(')', m.cSrcRmndr)
        m.cNounNArg = LEFT(m.cSrcRmndr, m.nX-1)

        * Done
        RETURN ALLTRIM(m.cNounNArg)
    ENDFUNC

    *- GetArgValue() - Return the Value from a Name=Value clause
    *     Input: cTextIn - Text containing Name=Value clause (NOTE: Pass this
    *                       as @cTextIn and the Name=Value clause will be
    *                       extracted.)
    *            cName - Name where Value is desired
    *      Retn: The Value argument after the = sign
    FUNCTION GetArgValue(cSrcTxt, cName)
        LOCAL nY, cValue, cQuote

        * There are many instances of Name=Value clauses in text.  These exist
        * in INI files as well has in HTML text.  Some HTML examples are:
        *   1. <FORM NAME="sol" ACTION="rfqquery.cfm" METHOD=POST>
        *   2. <input type="hidden" name="Query" value="F">
        *   3. <select name=date1>

        * In the above examples, we might want to know the value of the "NAME"
        *   label.  This function returns that value.  Note that in examples
        *   #1 and #2, the NAME value is surrounded by quotes (it isn't in
        *   #3). These quotes are stripped from the value before it's
        *   returned.

        * WARNING: This routine assumes the label's value ends at:
        *   1. If within quotes (" or '), the 2nd instance of the quote
        *   2. Else, the first space or '>' character; whichever comes first

        * Extract everything before the label
        m.cLeft = ''
        m.nY = AT(UPPER(m.cName), UPPER(m.cSrcTxt))
        DO CASE
        CASE m.nY = 0
            RETURN ''
        CASE m.nY > 1
            m.cLeft = TRIM(LEFT(m.cSrcTxt, m.nY-1))
            m.cClauseText = SUBSTR(m.cSrcTxt, m.nY)
        OTHERWISE
            m.cClauseText = m.cSrcTxt
        ENDCASE

        * Extract the = sign
        = THIS.ExtrToken(@m.cClauseText, '=')
        IF m.cClauseText = ' '
            m.cClauseText = LTRIM(m.cClauseText)
        ENDIF

        * Where does our value end.  That's at:
        *   1. If within quotes (" or '), the 2nd instance of the quote
        IF LEFT(m.cClauseText,1) $ '"' + "'"
            m.cQuote = LEFT(m.cClauseText,1)
            m.cClauseText = SUBSTR(m.cClauseText,2)
            m.cValue = THIS.ExtrToken(@m.cClauseText, m.cQuote)

        *   2. Else, the first space or '>' character; whichever comes first
        ELSE
            m.nY = THIS.FirstAt(' ,>', m.cClauseText)
            DO CASE
            CASE m.nY = 1
                m.cValue = ''
            CASE m.nY = 0
                m.cValue = m.cClauseText
                m.cClauseText = ''
            OTHERWISE   && nY > 0
                m.cValue = LEFT(m.cClauseText, m.nY-1)
            ENDCASE
            IF LEN(m.cClauseText) = m.nY
                m.cClauseText = ''
            ELSE
                m.cClauseText = SUBSTR(m.cClauseText,m.nY+1)
            ENDIF
        ENDIF

        * Put the overall argument back together.  Separate with a space unless
        *   one of them is empty
        IF (NOT EMPTY(m.cLeft)) AND NOT EMPTY(m.cClauseText)
            m.cSrcTxt = LTRIM(m.cLeft + ' ' + LTRIM(m.cClauseText))
        ELSE
            m.cSrcTxt = m.cLeft + LTRIM(m.cClauseText)
        ENDIF

        * Done
        RETURN m.cValue
    ENDFUNC

    *- GetArticle() - Return the appropriate article for the passed noun
    *     Input: cNoun - Noun in question
    *            bNoFirstCap - .T. if first letter of article should NOT be cap
    *      Retn: 'A ' or 'An '
    FUNCTION GetArticle(cNoun, bNoFirstCap)
        LOCAL cArticle
        m.cArticle = 'A '
        IF UPPER(LEFT(LTRIM(m.cNoun), 1)) $ 'AEIOU'
            m.cArticle = 'An '
        ENDIF
        IF m.bNoFirstCap
            m.cArticle = LOWER(m.cArticle)
        ENDIF
        RETURN m.cArticle
    ENDFUNC

    *- GetInitials() - Return the initials for the passed name
    *     Input: cNameIn - Name from which initials are to be extracted
    *      Retn: Up to 5 initials within the name
    FUNCTION GetInitials(cNameIn)
        LOCAL cName, cRetInits, nX

        * Initials are, of course, whatever starts a word; e.g. whatever's at
        *   the beginning and whatever follows a space
        m.cName = ALLTRIM(m.cNameIn)
        DO WHILE [  ] $ m.cName
            m.cName = STRTRAN(m.cName, [  ], [ ])
        ENDDO
        m.cRetInits = ''
        m.cName = THIS.CleanString(m.cName)

        * We'll return a maximum of 5 initials
        DO WHILE LEN(m.cRetInits) < 5
            m.cRetInits = m.cRetInits + LEFT(m.cName, 1)

            * Where's the space?
            m.nX = AT(' ', m.cName)
            IF m.nX = 0

                * There isn't one, so we're done
                EXIT
            ELSE
                m.cName = LTRIM(SUBSTR(m.cName, m.nX))
            ENDIF
        ENDDO

        * Return our initials
        RETURN UPPER(m.cRetInits)
    ENDFUNC

    *- GetEndingDigits() - Return the trailing digits (if any) in a string
    *     Input: cStr - String in question
    *      Retn: The trailing digits in the string, e.g. "ABC45DH132" --> "132"
    FUNCTION GetEndingDigits(cStr)
        LOCAL cRetStr, cChar

        * Go thru the entire string
        m.cRetStr = ''
        FOR m.nW = LEN(m.cStr) TO 1 STEP -1
            m.cChar = SUBSTR(m.cStr, m.nW, 1)
            IF ISDIGIT(m.cChar)
                m.cRetStr = m.cChar + m.cRetStr
            ELSE

                * Not a digit so we're done
                EXIT
            ENDIF
        ENDFOR
        RETURN m.cRetStr
    ENDFUNC

    *- HasLowerCase() - Return .T. if the passed string has any lowercase letters
    *     Input: cStr - String in question
    *      Retn: .T. if there are any lowercase letters in cStr
    FUNCTION HasLowerCase(cStr)
        LOCAL cChars, nX, cCh
        m.cChars = 'abcdefghijklmnopqrstuvwxyz'
        FOR m.nX = 1 TO LEN(m.cStr)
            m.cCh = SUBSTR(m.cStr, m.nX, 1)
            IF m.cCh $ m.cChars
                RETURN .T.
            ENDIF
        ENDFOR
        RETURN .F.
    ENDFUNC

    *-  HasUpperCase() - Return .T. if the passed string has any uppercase letters
    *      Input: cStr - String in question
    *       Retn: .T. if there are any uppercase letters in cStr
    FUNCTION HasUpperCase(cStr)
        LOCAL cChars, nX, cCh
        m.cChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        FOR m.nX = 1 TO LEN(m.cStr)
            m.cCh = SUBSTR(m.cStr, m.nX, 1)
            IF m.cCh $ m.cChars
                RETURN .T.
            ENDIF
        ENDFOR
        RETURN .F.
    ENDFUNC


        ***** Extract Parts *****

    *- GetEmailDomain() - Return the domain from an email address
    *     Input: cStr - Email address string
    *      Retn: The domain from that email address
    FUNCTION GetEmailDomain(cStrIn)
        LOCAL cStr, nPosn, cDomain

        * Emails are always of the form: LoginID@Domain so this is easy
        m.cStr = ALLTRIM(m.cStrIn)
        m.nPosn = AT('@', m.cStr)
        IF m.nPosn = LEN(m.cStr)
            m.cDomain = ''
        ELSE
            m.cDomain = SUBSTR(m.cStr, m.nPosn+1)
        ENDIF
        RETURN m.cDomain
    ENDFUNC

    *- ExtrNumber() - Extract a number from the beginning of a string
    *     Input: cStr - String for extraction (passed as @cStr if you want
    *                       the remainder returned)
    *      Retn: Number or Numeric Expression extracted from the string
    *            Remainder in cStr if it was passed as @cStr
    FUNCTION ExtrNumber(cStr)
        LOCAL cNumChars, cWhatsLeft, cNumber, nX, cChar

        * Expressions can have the form:
        *   1252 Yards      -30DegC
        *   1/4"
        *   0.375MM
        m.cNumChars = [01234567890.,+-*/]

        * Go thru the string extracting all numeric expression characters
        m.cWhatsLeft = m.cStr
        m.cNumber = []
        FOR m.nX = 1 TO LEN(m.cStr)
            m.cChar = SUBSTR(m.cStr, m.nX, 1)
            IF m.cChar $ m.cNumChars

                * Toss any commas - they mess up VAL() conversions
                IF NOT m.cChar = [,]
                    m.cNumber = m.cNumber + m.cChar
                ENDIF
                m.cWhatsLeft = SUBSTR(m.cStr, m.nX+1)
            ELSE
                EXIT
            ENDIF
        ENDFOR

        * Toss any trailing non-digit in the number
        DO WHILE (NOT EMPTY(m.cNumber)) AND RIGHT(m.cNumber, 1) $ [.+-*/]
            m.cNumber = LEFT(m.cNumber, LEN(m.cNumber)-1)
        ENDDO

        * Return whatever's left in the passed parameter
        m.cStr = m.cWhatsLeft

        * Return the number
        RETURN m.cNumber
    ENDFUNC

    *- EvalLogicExpr() - Evaluate "Arg" in a Name(Arg) str as .T. (default) or .F.
    *     Input: cSrcTxt - String containing Name(Arg) clause like:
    *                       "Name1(arg1), Name2(arg2), ..."
    *            cFuncName - Name in the Name(Arg) clause
    *            cClauSep - Character separating multiple clauses (e.g. ",")
    *      Retn: .T. or .F.
    FUNCTION EvalLogicExpr(cSrcTxt, cFuncName, cClauSep)
        LOCAL cArg

        * Get the argument from the source text
        m.cArg = THIS.GetArg(@m.cSrcTxt, m.cFuncName, m.cClauSep)

        * Throw away any leading "IF "
        IF (NOT EMPTY(m.cArg)) AND UPPER(LEFT(m.cArg,3)) = 'IF '
            IF LEN(m.cArg) = 3
                m.cArg = ''
            ELSE
                m.cArg = LTRIM(SUBSTR(m.cArg, 4))
            ENDIF
        ENDIF

        * If something's there, EVALuate it
        IF NOT EMPTY(m.cArg)
            RETURN EVAL(m.cArg)
        ENDIF

        * Our default return value is always .T.
        RETURN .T.
    ENDFUNC

    *- ExtrClauseArg() - Extract a clause argument: (IN clause AS clause)
    *     Input: cSrcTxt - String for extraction (must be passed as @cStrIn for
    *                       any extraction to actually take place)
    *            cIDWord - Word in cSrcText (such as "IN" or "AS")
    *      Retn: Extracted clause
    FUNCTION ExtrClauseArg(cSrcTxt, cIDWord)
        LOCAL nPosn, cClause, cRetCls

        * We're passed a block of text (cSrcTxt) containing a number of ID
        *   Words with following clauses.  For example:
        *           "IN ITEMS AS ITEM_NUMB"
        *   The ID words and clauses, in this case are:
        *       #1: ID: "IN", Clause: "ITEMS"
        *       #2: ID: "AS", Clause: "ITEM_NUMB"
        *   The key separators are spaces.
        * We're passed the ID Word.  Our job is to extract and return the ID
        *   Word and it's clause from the passed string.

        * Our ID word could be within a clause in the string.  (If the word is
        *   "IN" and we have a string: "AS FINAN_NTS".)  So, we have to be
        *   careful that we check for: ' ' + cIDWord + ' '.  Of course, it
        *   could be at the beginning of the string, in which case we wouldn't
        *   have the leading space.
        m.nPosn = AT(' ' + m.cIDWord + ' ', m.cSrcTxt)
        IF m.nPosn = 0
            m.nPosn = AT(m.cIDWord + ' ', m.cSrcTxt)
            IF m.nPosn > 1
                m.nPosn = 0
            ENDIF
        ELSE
            m.nPosn = m.nPosn + 1
        ENDIF

        * If the ID word isn't in the string, return quickly
        IF m.nPosn = 0
            RETURN ''
        ENDIF

        * OK, we've found our ID Word at nPosn.  Remove earlier parts of the
        *   string
        m.cClause = SUBSTR(m.cSrcTxt, m.nPosn)
        IF m.nPosn = 1
            m.cSrcTxt = ''
        ELSE
            m.cSrcTxt = LEFT(m.cSrcTxt, m.nPosn-1)
        ENDIF

        * Extract our ID Word and our clause from the remainder.  Note that
        *   our "separators" are spaces.
        THIS.ExtrToken(@m.cClause, ' ')
        m.cRetCls = THIS.ExtrToken(@m.cClause, ' ')

        * Add whatever's left back into the source string
        m.cSrcTxt = m.cSrcTxt + m.cClause

        * We're done
        RETURN m.cRetCls
    ENDFUNC

    *- ExtrFldName() - Extract the first field name from an expression
    *     Input: cExpr - String for extraction
    *      Retn: Extracted field name
    FUNCTION ExtrFldName(cExpr)
        LOCAL cRetName, nX, nY

        * Expressions can have the form:
        *   Character fields: field or UPPER(field) or LEFT(field,n)
        *        Date fields: DTOS(field)
        *     Numeric fields: STR(field,len,dec) or STR(INT(field+str),len,dec)
        *     Logical fields: IIF(field,'Y','N')
        * Conditional fields: IIF(EMPTY(field),expr1,DTOS(date))
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
                m.cRetName = SUBSTR(m.cRetName, m.nX+1, m.nY-m.nX-1)
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
        RETURN m.cRetName
    ENDFUNC

    *- ExtrLine() - Extract a max length line from a large string
    *     Input: cStrIn - String for extraction (must be passed as @cStrIn for
    *                       any extraction to actually take place)
    *            nDesLen - Desired length of string
    *            bKillIntEnds - (Optional) .T. if internal blank lines are to
    *                       be removed (default = .F.)
    *      Retn: Extracted line
    *            cStrIn is split on whitespace as close to nDesLen as possible
    *               (if there is no whitespace, it's just chopped).  Whitespace
    *               is: spaces and TABs; line ends are: CRs, LFs, and HEX_FFs.
    FUNCTION ExtrLine(cStrIn, nDesLen, bKillIntEnds)
        LOCAL cStrOut, cLineEnds, cWhiteSpc, nEndPosn, cChar, cFragment, ;
          nSplitPoint

        * Function Example:
        *       * Print the 150 character DESCR in 35 char lines
        *       cToPrint = TRIM(DESCR)
        *       DO WHILE NOT EMPTY(cToPrint)
        *           cPrtLine = goStr.ExtrLine(@cToPrint, 35)
        *           @ x,y SAY cPrtLine
        *           x = x + 1
        *       ENDDO

        * Initialize our return string
        m.cStrOut = ''

        * Bug if nDesLen isn't > 0
        IF m.nDesLen < 1
            ERROR [goStr.ExtrLine() Des. Length must be > 0]
        ENDIF

        * Define what we mean by white space and line ends
        m.cLineEnds = THIS.cLineEnds
        m.cWhiteSpc = THIS.cWhiteSpace

        * Find the first line ending character
        m.nEndPosn = THIS.Get1stPosn(m.cLineEnds, m.cStrIn)

        * We may have nothing to do
        IF LEN(m.cStrIn) <= m.nDesLen AND m.nEndPosn = 0
            m.cStrOut = m.cStrIn
            m.cStrIn = ''
            RETURN m.cStrOut
        ENDIF

        * Find the first line ending character
        DO WHILE BETWEEN(m.nEndPosn, 1, m.nDesLen)
            m.cChar = SUBSTR(m.cStrIn, m.nEndPosn, 1)
            m.cStrOut = LEFT(m.cStrIn, m.nEndPosn-1)     && Toss line ending char
            m.cStrIn = SUBSTR(m.cStrIn, m.nEndPosn+1)

            * If the line ended with a CR, toss the next LF character
            IF m.cChar = CR AND m.cStrIn = LF
                m.cStrIn = SUBSTR(m.cStrIn, 2)
            ENDIF

            * If we're to kill internal blank lines, keep going
            IF m.nEndPosn = 1 AND m.bKillIntEnds AND NOT EMPTY(m.cStrIn)
                m.nEndPosn = THIS.Get1stPosn(m.cLineEnds, m.cStrIn)
                LOOP
            ENDIF
            RETURN m.cStrOut
        ENDDO

        * Here we have no line ends within the desired length. So, get a
        *   of the string no longer than nDesLen
        IF LEN(m.cStrIn) <= m.nDesLen
            m.cFragment = m.cStrIn
        ELSE
            m.cFragment = LEFT(m.cStrIn, m.nDesLen)
        ENDIF

        * Find the last white space in the line (.T. = last one)
        m.nSplitPoint = THIS.Get1stPosn(m.cWhiteSpc, m.cFragment, .T.)

        * Act on that result
        DO CASE

        * No white space at all or if the split point is too small, just chop it
        CASE m.nSplitPoint = 0 OR m.nSplitPoint < (m.nDesLen/2)
            m.cStrOut = LEFT(m.cStrIn,m.nDesLen)
            m.cStrIn = SUBSTR(m.cStrIn,m.nDesLen+1)

        * Last space matches the desired length
        CASE m.nSplitPoint = LEN(m.cStrIn)
            m.cStrOut = m.cStrIn
            m.cStrIn = ''

        * We got a split point, use it
        OTHERWISE
            m.cStrOut = LEFT(m.cStrIn, m.nSplitPoint)        && Don't trim
            m.cStrIn = LTRIM(SUBSTR(m.cStrIn,m.nSplitPoint+1))
        ENDCASE

        * Return our result
        RETURN m.cStrOut
    ENDFUNC

    *- ExtrLineWithText() - Extract entire line containing some text
    *     Input: cStrIn - String for extraction
    *            cSrchTxt - Text to look for
    *      Retn: Text but without the line(s) that had cSrchTxt
    *- ExtrLineWithText() -
    FUNCTION ExtrLineWithText(cStrIn, cSrchTxt)
        LOCAL cText, cLookFor, nPosn, cLeft, cRight

        * What will we return
        m.cText = m.cStrIn

        * Look for all lines with cSrchTxt
        m.cLookFor = UPPER(m.cSrchTxt)
        m.nPosn = AT(m.cLookFor, UPPER(m.cText))
        DO WHILE m.nPosn > 0

            * Extract up to the  start of the line with cSrchTxt
            m.nPosn = RAT(LF, LEFT(m.cText, m.nPosn))
            m.cLeft = LEFT(m.cText, m.nPosn)

            * Now, toss the full line having cSrchTxt
            m.cRight = SUBSTR(m.cText, m.nPosn+1)
            goStr.ExtrToken(@m.cRight, LF)

            * Knit those two back together
            m.cText = m.cLeft + m.cRight

            * Any more instances?
            m.nPosn = AT(m.cLookFor, UPPER(m.cText))
        ENDDO

        * Done
        RETURN m.cText
    ENDFUNC

    *- IsQuoted() - Return .T. if the string is surrounded by quotes
    *     Input: cStrIn - String for evaluation
    *            cQuoteChar - (optional; passed as @cQuoteChar) The quote
    *                   character use for quotation
    *      Retn: .T. if the string is quoted and cQuoteChar filled in, or .F.
    FUNCTION IsQuoted(cStrIn, cQuoteChar)
        LOCAL cLeftChar, cRightChar

        * Handle the trivial situation first
        IF EMPTY(m.cStrIn)
            RETURN .F.
        ENDIF

        * There are only 2 kinds of quote characters: "" ''.  We won't use
        *   [] as they're string delimiters - not quotation characters
        m.cLeftChar = LEFT(m.cStrIn,1)
        m.cRightChar = RIGHT(m.cStrIn,1)

        * Test for quotations
        DO CASE
        CASE m.cLeftChar = ['] AND m.cRightChar = [']
            m.cQuoteChar = [']
            RETURN .T.
        CASE m.cLeftChar = ["] AND m.cRightChar = ["]
            m.cQuoteChar = ["]
            RETURN .T.
        ENDCASE
        RETURN .F.
    ENDFUNC

    *- ExtrQuoted() - Extract the contents, within quotes, from a string
    *     Input: cStrIn - String for extraction (must be passed as @cStrIn for
    *                       any extraction to actually take place)
    *            cQuoteChar - The quotation character (' or ")
    *      Retn: Quoted contents
    *            cStrIn - String without the quoted contents or quotes
    FUNCTION ExtrQuoted(cStrIn, cQuoteChar)
        LOCAL cLeftSide, cRightSide, cTheWord, nX

        * Setup
        STORE '' TO m.cLeftSide, m.cRightSide, m.cTheWord

        * Look for the first instance of the quote
        m.nX = AT(m.cQuoteChar, m.cStrIn)
        IF m.nX > 0
            IF m.nX = 1
                m.cRightSide = SUBSTR(m.cStrIn, 2)
            ELSE
                m.cLeftSide = LEFT(m.cStrIn, m.nX-1)
                m.cRightSide = SUBSTR(m.cStrIn, m.nX+1)
            ENDIF

            * Here, cLeftSide has the string before the quote and cRightSide
            *   has the string after the quote (the quote is gone).  Look for
            *   the next instance of the quote
            m.nX = AT(m.cQuoteChar, m.cRightSide)
            IF m.nX > 0
                IF m.nX = 1
                    m.cRightSide = SUBSTR(m.cRightSide, 2)
                ELSE
                    m.cTheWord = LEFT(m.cRightSide, m.nX-1)
                    m.cRightSide = SUBSTR(m.cRightSide, m.nX+1)
                ENDIF
            ENDIF   && nX > 0

            * Put the string back together
            m.cStrIn = m.cLeftSide + m.cRightSide
        ENDIF   && nX > 0
        RETURN m.cTheWord
    ENDFUNC

    *- ExtrToken() - Extract and return the text before a passed token (char)
    *     Input: cStrIn - String for extraction (if passed as @cStrIn, the
    *                       fragment and token are really extracted)
    *            cTokenChar - Character separator
    *      Retn: Text in cStrIn before the first cTokenChar
    *     Tests: 1: ExtrToken('AB^CD', '^') --> 'AB'
    *            2: cVar = '123.45'
    *               ExtrToken(@cVar, '.') --> '123'
    *               cVar now = '45'
    FUNCTION ExtrToken(cStrIn, cTokenChar)
        LOCAL cRetTxt, nChrPosn

        * We're passed a block of text (cStrIn) supposedly containing at
        *   least one instance of a character (cTokenChar).  Our job is to
        *   extract and return the text UP TO but not including cTokenChar,
        *   and to remove that text and cTokenChar from cStrIn (will only
        *   work if cStrIn passed as @cStrIn).
        * If the text doesn't have the character, we'll return the full string
        *   and empty out cStrIn.
        m.cRetTxt = ''

        * Look for cTokenChar
        m.nChrPosn = AT(m.cTokenChar, m.cStrIn)

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
                m.cStrIn = SUBSTR(m.cStrIn, m.nChrPosn + LEN(m.cTokenChar))
            ENDIF
        ENDIF
        RETURN m.cRetTxt
    ENDFUNC

    *- ExtrVarValue() - Return "Val" from many "VarName=Val^" entries in text
    *     Input: cVarName - The name of the variable
    *            cTextIn - The string that might contain a "VarName=Value^"
    *                       line.
    *                      Notice that values are terminated with ^s or CRs.
    *      Retn: The "Val" clause of the value line
    FUNCTION ExtrVarValue(cVarName, cTextIn)
        LOCAL nPosn, cRemText, cEndChar, cRetVal

        * Find the name
        m.nPosn = AT(UPPER(m.cVarName) + '=', UPPER(m.cTextIn))
        IF m.nPosn = 0
            RETURN ''
        ENDIF

        * Extract the "VarName=Value" line
        m.cRemText = SUBSTR(m.cTextIn, m.nPosn)
        m.cEndChar = ''
        THIS.FirstAt('^,' + CR, m.cRemText, @m.cEndChar)
        m.cRetVal = goStr.ExtrToken(m.cRemText, m.cEndChar)

        * Get the value after the '=' sign
        THIS.ExtrToken(@m.cRetVal, '=')
        RETURN m.cRetVal
    ENDFUNC

    *- GetVarValue - Return the value in a "VarName=Val[CR_LF]" line
    *     Input: cValLine - The string containing a "VarName=Val" line.  The
    *                       string can contain more than one of these but only
    *                       the value after the first = sign is returned.
    *      Retn: The "Val" clause of the value line
    FUNCTION GetVarValue(cValLine)
        LOCAL cRetVal, nX

        * Get the value after the '=' sign
        m.cRetVal = m.cValLine
        THIS.ExtrToken(@m.cRetVal, '=')

        * If we have a CR_LF, chop it just before that
        m.nX = AT(CR_LF, m.cRetVal)
        IF m.nX > 0
            m.cRetVal = LEFT(m.cRetVal, m.nX-1)
        ENDIF
        RETURN m.cRetVal
    ENDFUNC

    *- SplitPosition() - Cut a string at the passed position number and return the left side
    *     Input: cStrIn - The input string to be split (passed as @cStrIn)
    *            nPosn - The position to cut the string at
    *      Retn: The LEFT part of the string up to and including nPosn
    *            cStrIn - RIGHT part of the string starting at nPosn + 1
    *      Note: If nPosn < 1, the returned string will be empty and cStrIn
    *               is unchanged.  Was CUT_STRP
    FUNCTION SplitPosition(cStrIn, nPosn)
        LOCAL cRetStr

        * Examples of use:
        *   Given a string: "ABCDEFGHIJK" we want to cut it at position
        *       5 so that from F on will be in the second string.
        *           cMyStr = "ABCDEFGHIJK"
        *           cLeftStr = goStr.SplitPosition)@cMyStr, 5)
        *   Result:              12345
        *           cMyStr:     "ABCDE"
        *           cLeftStr:   "FGHIJK"

        * Trivial stuff first
        IF EMPTY(m.cStrIn) OR m.nPosn > LEN(m.cStrIn)
            RETURN ''
        ENDIF
        DO CASE
        CASE m.nPosn < 1
            m.cRetStr = ''
        CASE m.nPosn = LEN(m.cStrIn)
            m.cRetStr = m.cStrIn
            m.cStrIn = ''
        OTHERWISE
            m.cRetStr = LEFT(m.cStrIn, m.nPosn)
            m.cStrIn = SUBSTR(m.cStrIn, m.nPosn+1)
        ENDCASE
        RETURN m.cRetStr
    ENDFUNC

    *- SplitString() - Split a string to whole words at the desired length
    *     Input: cStrIn - The input string to be split (passed as @cStrIn)
    *            nLength - Desired line length
    *      Retn: String returned as the leftmost part of cStrIn after split
    *            cStrIn - LTRIMmed remainder of cStrIn after split (only if
    *                   passed as @cStrIn)
    *            vbHardCR - (must have been setup as PRIVATE) set as .T. if
    *                   split occurs at HEX_FF
    *      Note: Will convert CR_LFs to HEX_FFs.  Was SPLITSTR
    FUNCTION SplitString(cStrIn, nLength)
        LOCAL cStrOut, cWhiteSpc, nSplitPoint

        * Initialize our return string
        m.cStrOut = ''
        IF VARTYPE(m.vbHardCR) = 'U'
            PRIVATE vbHardCR
            vbHardCR = .F.
        ENDIF
        m.cWhiteSpc = THIS.cWhiteSpace + THIS.cLineEnds

        * Convert any CR_LFs to HEX_FFs
        IF CR_LF $ m.cStrIn
            m.cStrIn = STRTRAN(m.cStrIn, CR_LF, HEX_FF)
        ENDIF

        * We may have nothing to do
        IF LEN(m.cStrIn) <= m.nLength AND NOT HEX_FF $ m.cStrIn
            m.cStrOut = m.cStrIn
            m.cStrIn = ''
            RETURN m.cStrOut
        ENDIF

        * Look for the first HEX_FF character.  If that's before
        *   nLength, extract the string and return.
        m.nSplitPoint = AT(HEX_FF, m.cStrIn)
        IF BETWEEN(m.nSplitPoint, 1, m.nLength)
            m.vbHardCR = .T.
            m.cStrOut = TRIM(LEFT(m.cStrIn, m.nSplitPoint-1))
            m.cStrIn = LTRIM(SUBSTR(m.cStrIn, m.nSplitPoint+1))
            DO WHILE RIGHT(m.cStrOut, 1) $ m.cWhiteSpc
                m.cStrOut = LEFT(m.cStrOut, LEN(m.cStrOut)-1)
            ENDDO
        ELSE

            * Otherwise, find the first space character starting at
            *   nLength and working backwords.
            m.nSplitPoint = RAT(' ', LEFT(m.cStrIn, m.nLength))

            * If we didn't find any spaces, just chop it
            IF m.nSplitPoint = 0
                m.cStrOut = LEFT(m.cStrIn,m.nLength)
                m.cStrIn = SUBSTR(m.cStrIn,m.nLength+1)
            ELSE

                * We got a split point, use it
                m.cStrOut = TRIM(LEFT(m.cStrIn,m.nSplitPoint))
                m.cStrIn = LTRIM(SUBSTR(m.cStrIn,m.nSplitPoint+1))
                DO WHILE RIGHT(m.cStrOut, 1) $ m.cWhiteSpc
                    m.cStrOut = LEFT(m.cStrOut, LEN(m.cStrOut)-1)
                ENDDO
            ENDIF
        ENDIF

        * Return our result
        RETURN m.cStrOut
    ENDFUNC

    *- CleanString() - Remove non-alpha, non-digit, non-space characters
    *     Input: cStrIn - The input string to be checked
    *            cExceptions - (optional) Characters to leave in (e.g. ".")
    *      Retn: String returned with only alpha or digit characters
    FUNCTION CleanString(cStrIn, cExceptions)
        LOCAL cRetStr, nLen, nX, cChar

        * Check our optional parameter and add a space to the exceptions
        DO CASE
        CASE PCOUNT() = 1 OR VARTYPE(m.cExceptions) <> 'C'
            m.cExceptions = [ ]
        CASE NOT [ ] $ m.cExceptions
            m.cExceptions = m.cExceptions + [ ]
        ENDCASE

        * Check each character
        m.cRetStr = []
        m.nLen = LEN(m.cStrIn)
        FOR m.nX = 1 TO m.nLen
            m.cChar = SUBSTR(m.cStrIn, m.nX, 1)
            IF ISALPHA(m.cChar) OR ISDIGIT(m.cChar) OR m.cChar $ m.cExceptions
                m.cRetStr = m.cRetStr + m.cChar
            ENDIF
        ENDFOR
        RETURN m.cRetStr
    ENDFUNC

    *- GetNextWord() - Extract the next word from a string
    *     Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
    *                       for the extraction to take place.
    *            cAddChars - (Optional) Chars to be added to THIS.cWordChars
    *                        for check.
    *      Retn: The next word ending at the first non-word character
    *            cTextIn will have the remaining text starting with that
    *               non-word character - if passed as @cTextIn.
    FUNCTION GetNextWord(cText, cAddChars)
        LOCAL cWordChars, cRetWord, cChar

        * This is a simple chaaracter search but they might have added
        *   characters for identifiers.
        m.cWordChars = THIS.cWordChars
        IF VARTYPE(m.cAddChars) = 'C'
            m.cWordChars = m.cWordChars + m.cAddChars
        ENDIF

        * Go to it
        m.cRetWord = ''
        DO WHILE NOT EMPTY(m.cText)

            * Extract the character
            m.cChar = LEFT(m.cText, 1)
            m.cText = SUBSTR(m.cText, 2)

            * Is it a word char?
            IF LOWER(m.cChar) $ m.cWordChars
                m.cRetWord = m.cRetWord + m.cChar
            ELSE

                * Non-word character; put it back in and we're done
               m.cText = m.cChar + m.cText
               EXIT
            ENDIF
        ENDDO
        RETURN m.cRetWord
    ENDFUNC

    *- GetLastWord() - Extract the last word from a string
    *     Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
    *                       for the extraction to take place.
    *            cAddChars - (Optional) Chars to be added to THIS.cWordChars
    *                        for check.
    *      Retn: The Last word ending at the first non-word character
    *            cTextIn will have the text prior to that word - if passed as
    *               @cTextIn.
    FUNCTION GetLastWord(cText, cAddChars)
        LOCAL cWordChars, cRetWord, cChar

        * This is a simple chaaracter search but they might have added
        *   characters for identifiers.
        m.cWordChars = THIS.cWordChars
        IF VARTYPE(m.cAddChars) = 'C'
            m.cWordChars = m.cWordChars + m.cAddChars
        ENDIF

        * Go to it
        m.cRetWord = ''
        DO WHILE NOT EMPTY(m.cText)

            * Extract the last character
            m.cChar = RIGHT(m.cText, 1)
            m.cText = LEFT(m.cText, LEN(m.cText)-1)

            * Is it a word char?
            IF LOWER(m.cChar) $ m.cWordChars
                m.cRetWord = m.cChar + m.cRetWord
            ELSE

                * Non-word character; put it back in and we're done
               m.cText = m.cChar + m.cText
               EXIT
            ENDIF
        ENDDO
        RETURN m.cRetWord
    ENDFUNC

    *- ExtractWords() - Extract only whole words up to a maximum length
    *     Input: cTextIn - The string to work on - NUST BE PASSED as @cTextIn
    *                       for the extraction to take place.
    *            nMaxLen - Maximum length of returned string of words
    *   CAUTION: Be sure there are no CRs or LFs in cTextIn; that's confusing
    *      Retn: A string of whole words not exceeding nMaxLen
    FUNCTION ExtractWords(cTextIn, nMaxLen)
        LOCAL cToDo, cEnd, cNext, cReturn, nPosn

        * We're already done if the string is empty or if it's shorter than the
        *   Max. Length
        IF EMPTY(m.cTextIn)
            RETURN ''
        ENDIF
        m.cToDo = m.cTextIn
        IF LEN(m.cToDo) <= m.nMaxLen
            m.cTextIn = ''
            RETURN m.cToDo
        ENDIF

        * What's at the maximum length? And the char just after that?
        m.cEnd = SUBSTR(m.cToDo, m.nMaxLen, 1)
        m.cNext = ' '
        IF LEN(m.cToDo) > m.nMaxLen
            m.cNext = SUBSTR(m.cToDo, m.nMaxLen+1, 1)
        ENDIF

        * Handle accordingly:
        *            1         2         3
        *   123456789012345678901234567890
        *   word1 word2 word3 word4
        DO CASE
        CASE m.cNext = ' '
            m.cTextIn = SUBSTR(m.cTextIn, m.nMaxLen+2)
            m.cReturn = LEFT(m.cToDo, m.nMaxLen)
        CASE m.cEnd = ' '
            m.cTextIn = SUBSTR(m.cTextIn, m.nMaxLen+1)
            m.cReturn = TRIM(LEFT(m.cToDo, m.nMaxLen))
        OTHERWISE
            m.nPosn = RAT(' ', LEFT(m.cToDo, m.nMaxLen))
            IF m.nPosn = 0
                m.cTextIn = ''
                m.cReturn = m.cToDo
            ELSE
                m.cTextIn = SUBSTR(m.cTextIn, m.nPosn+1)
                m.cReturn = LEFT(m.cToDo, m.nPosn-1)
            ENDIF
        ENDCASE

        * Done
        RETURN m.cReturn
    ENDFUNC


        ***** Modify the String *****

    *- CheckStrValues() - Separate a string of entries into good and bad strings
    *     Input: cEntries - String needing checking, eg. 'AAA,DDD,FFF'
    *            cCheckStr - String of valid entries, eg. 'AAA,BBB,CCC,FFF'
    *            cBadEnts - Passed as @cBadEnts will contain invalid entries
    *            cSeparator - optional, Character separating entries and cCheckStr,
    *                 the default value = ","
    *      Retn: cGoodEnts - Will contain only entries that are valid
    *            cBadEnts - Will contain invalid entries
    *     WARNING: Not reliable if entries contain quotes or if passed values
    *           have internal spaces before of after the separator
    FUNCTION CheckStrValues(cEnts, cChkStr, cBads, cSep)
        LOCAL cGoodEnts, cEntry

        * Check the separator
        IF PCOUNT() = 2 OR VARTYPE(m.cSep) <> 'C' OR EMPTY(m.cSep)
            m.cSep = ','
        ENDIF

        * If Entries are empty, we're done
        m.cBads = ''
        IF EMPTY(m.cEnts)
            RETURN ''
        ENDIF

        * If checks are empty, every entry is bad
        IF EMPTY(m.cChkStr)
            m.cBads = m.cEnts
            RETURN ''
        ENDIF

        * Make sure we check only the full entry
        m.cChkStr = m.cSep + m.cChkStr + m.cSep

        * We'll just go thru each entry, check it and dump it in a good or bad
        *   bucket.
        m.cGoodEnts = ''
        DO WHILE NOT EMPTY(m.cEnts)
            m.cEntry = goStr.ExtrToken(@m.cEnts, ',')
            DO CASE
            CASE EMPTY(m.cEntry)
                LOOP
            CASE m.cSep + m.cEntry + m.cSep $ m.cChkStr
                m.cGoodEnts = m.cGoodEnts + m.cEntry + ','
            OTHERWISE
                m.cBads = m.cBads + m.cEntry + ','
            ENDCASE
        ENDDO

        * Done; we've created cGoodEnts having the validated entries and filled
        *   in cBads with the invalid entries. But toss any trailing commas
        IF NOT EMPTY(m.cGoodEnts)
            m.cGoodEnts = LEFT(m.cGoodEnts, LEN(m.cGoodEnts)-1)
        ENDIF
        IF NOT EMPTY(m.cBads)
            m.cBads = LEFT(m.cBads, LEN(m.cBads)-1)
        ENDIF
        RETURN m.cGoodEnts
    ENDFUNC

    *- SetTextLeftMargin() - Change the left margin of the passed text block
    *     Input: cTextIn - String needing reduced/added margin
    *            nWantLMarg - Desired new margin
    *      Retn: cTextIn has spaces at left matching new margin
    FUNCTION SetTextLeftMargin(cTextIn, nWantLMarg)
        LOCAL oText, cTextOut

        * The passed text could be empty
        IF EMPTY(m.cTextIn)
            m.cTextOut = SPACE(m.nWantLMarg)
        ELSE

            * Put the text into a memo array (we don't care about line length)
            m.oText = CREATEOBJECT('MemoArray', m.cTextIn, 400)

            * Change the margin
            m.oText.ChangeLeftMargin(m.nWantLMarg, .T.)    && .T. = toss last empty line

            * Get the resultant text
            m.cTextOut = m.oText.Array2Memo()
        ENDIF
        RETURN m.cTextOut
    ENDFUNC

    *- NormalizeNumber() - Return a number string in normal d.ddEee  format
    *     Input: cStrIn - Number string to be normalized
    *      Retn: cStrIn converted 3 significant digits in d.ddEee form
    FUNCTION NormalizeNumber(cNumbIn)
        LOCAL nNumber, bIsNeg, nPower, nMultiplier, bPowerNeg, cRetStr

        * Get the value
        m.nNumber = VAL(m.cNumbIn)

        * If the number is 0, we're done
        IF m.nNumber = 0
            RETURN '0.00'
        ENDIF

        * Is it negative?
        m.bIsNeg = (m.nNumber < 0)
        IF m.bIsNeg
            m.nNumber = ABS(m.nNumber)
        ENDIF

        * Get the logarithm (power of 10)
        m.nPower = LOG10(m.nNumber)

        * If this is negative, multiply the number by the power + 1 (it's a
        *   fraction)
        m.bPowerNeg = .F.
        DO CASE
        CASE m.nPower < 0
            m.nPower = ABS(INT(m.nPower)) + 1
            m.nMultiplier = (10 ^ m.nPower)
            m.bPowerNeg = .T.
        CASE INT(m.nPower) = 0
            m.nMultiplier = 1
        OTHERWISE       && nPower > 1, so divide by power of 10
            m.nPower = INT(m.nPower)
            m.nMultiplier = 1 / (10 ^ m.nPower)
        ENDCASE

        * Put the number in d.dd form but round off to 2 digits
        m.nNumber = RoundOff(m.nNumber * m.nMultiplier, 2)

        * Make this into our return string
        m.cRetStr = IIF(m.bIsNeg, '-', '') + STR(m.nNumber, 4, 2) + [E] + ;
          IIF(m.bPowerNeg, '-', '') + LTRIM(STR(m.nPower))
        RETURN m.cRetStr
    ENDFUNC

    *- ClearPunct() - Remove all except characters and digits from passed string
    *     Input: cStrIn - String to process
    *            bKeepSpcs - If .T., spaces are retained (default = .F.)
    *      Retn: String with non-formatting chars removed
    FUNCTION ClearPunct(cStrIn, bKeepSpcs)
        LOCAL cGoodChars, cStrIn, nLenIn, cRetStr, nX, cThisChar

        * Define the allowable characters
        m.cGoodChars = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ' + ;
          'abcdefghijklmnopqrstuvwxyz' + IIF(m.bKeepSpcs, ' ', '')

        * Copy only characters, digits, and (optionally) spaces into our return
        *   string
        m.cStrIn = m.cStrIn
        m.nLenIn = LEN(m.cStrIn)
        m.cRetStr = ''
        FOR m.nX = 1 TO m.nLenIn
            m.cThisChr = SUBSTR(m.cStrIn, m.nX, 1)

            * Skip the characters we want to remove
            IF m.cThisChr $ m.cGoodChars
                m.cRetStr = m.cRetStr + m.cThisChr
            ENDIF
        ENDFOR
        RETURN m.cRetStr
    ENDFUNC

    *- ClearEndPunct() - Remove ending punctuation characters
    *     Input: cTheStr - The passed string to de-punctuate (is that a word?)
    *      Retn: String with trailing punctuation chars removed
    FUNCTION ClearEndPunct(cStrIn)
        LOCAL cGoodChars, cRetStr

        * Define the allowable characters
        m.cGoodChars = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

        * Only look at trailing characters
        m.cRetStr = m.cStrIn
        DO WHILE LEN(m.cRetStr) > 0 AND NOT RIGHT(m.cRetStr,1) $ m.cGoodChars
            m.cRetStr = LEFT(m.cRetStr, LEN(m.cRetStr)-1)
        ENDDO
        RETURN m.cRetStr
    ENDFUNC

    *- AddQuotes2Text() - Add appropriate quote characters to the passed text
    *     Input: cStrIn - String that may have embedded quotes
    *      Retn: cStrIn with quotes added no matter what
    FUNCTION AddQuotes2Text(cStrIn)
        LOCAL cRetLine, nSglPosn, nDblPosn, cQuoteChar

        * We're passed a line of text that may have quote marks embedded
        *   within it.  We have to add quotes so that it can be output as part
        *   of a valid VFP string definition.

        * Example 1: I can't understand "THIS"
        *   becomes: "I can't understand " + '"THIS".'
        * Example 2: CTRL+S, 'CTRL+S'
        *   becomes: "CTRL+S, 'CTRL+S'"

        * Two simple cases (no quotes) means we can return quickly
        IF NOT ["] $ cStrIn        && No " quote marks
            RETURN ["] + m.cStrIn + ["]
        ENDIF
        IF NOT ['] $ cStrIn        && No ' quote marks
            RETURN ['] + m.cStrIn + [']
        ENDIF

        * Here, we know that we have both ' and " within the line.  So, we'll
        *   have to do some fancy footwork.
        m.cRetLine = ''
        DO WHILE NOT EMPTY(m.cStrIn)

            * Where are the quote marks?
            m.nSglPosn = AT(['], m.cStrIn)
            m.nDblPosn = AT(["], m.cStrIn)

            * Handle the possibilities.  But, note that the first time thru,
            *   both positions must be > 0.  After we've extracted a fragment,
            *   though, either position might be 0.

            DO CASE

            * No single quote in string (or remainder)
            CASE m.nSglPosn = 0
                m.cQuoteChar = [']        && Single quote
                m.cRetLine = m.cRetLine + m.cQuoteChar + m.cStrIn + m.cQuoteChar
                m.cStrIn = ''            && We're done

            * No double quote in string
            CASE m.nDblPosn = 0
                m.cQuoteChar = ["]        && Double quote
                m.cRetLine = m.cRetLine + m.cQuoteChar + m.cStrIn + m.cQuoteChar
                m.cStrIn = ''            && We're done

            * We have both characters in the string - the first is "
            CASE m.nSglPosn > m.nDblPosn    && have both in string, 1st is "
                m.cQuoteChar = [']

                * Extract the fragment but add the + sign to the string
                *   definition
                m.cRetLine = m.cRetLine + m.cQuoteChar + LEFT(m.cStrIn, m.nSglPosn-1) ;
                  + m.cQuoteChar + ' + '
                m.cStrIn = SUBSTR(m.cStrIn, m.nSglPosn)

            * We have both characters in the string - the first is '
            OTHERWISE                   && nSglPosn < nDblPosn
                m.cQuoteChar = ["]        && double quote

                * Extract the fragment but add the + sign to the string
                *   definition
                m.cRetLine = m.cRetLine + m.cQuoteChar + substr(m.cStrIn,1,m.nDblPosn-1) + ;
                  m.cQuoteChar + ' + '
                m.cStrIn = SUBSTR(m.cStrIn,m.nDblPosn)
            ENDCASE
        ENDDO   && WHILE NOT EMPTY(cStrIn)

        * Done
        RETURN m.cRetLine
    ENDFUNC

    *- CleanMemo() - Remove a memo's leading lines and trailing white space
    *     Input: cMemoIn - Memo string to be cleaned up
    *            cLeadOpt - (optional) Char. that defines what to cleanup:
    *                   'B' - (default) Cleanup both the start and the end
    *                   'L' - Only remove completely blank beginning lines
    *                       (but no other whitespace on a line with real
    *                       characters)
    *                   'N' - Don't remove anything from the start; only at
    *                       the end
    *      Retn: Cleaned up memo string
    FUNCTION CleanMemo(cMemoIn, cLeadOpt)
        LOCAL cLeadOpt, cWhiteSpace, cMemo, cLine, cThisChar

        * Our default mode is that we clean all white space from the start and
        *   end of the memo.  The optional parameter, cLeadOpt, can overwride
        *   that as follows:
        *       'B' - (default) Cleanup both the start and the end
        *       'L' - Only remove completely blank beginning lines (but no
        *           other whitespace on a line with real characters)
        *       'N' - Don't remove anything from the start; only at the end
        IF TYPE('cLeadOpt') = 'C' AND m.cLeadOpt $ 'BLN' AND LEN(m.cLeadOpt) = 1
            m.cLeadOpt = m.cLeadOpt
        ELSE
            m.cLeadOpt = 'B'
        ENDIF

        * Whitespace is: CR, LF, TAB and space
        m.cWhiteSpace = CR_LF + ' ' + TAB

        * Get the string we're to play with
        IF m.cLeadOpt = 'B'
            m.cMemo = ALLTRIM(m.cMemoIn)
        ELSE
            m.cMemo = TRIM(m.cMemoIn)
        ENDIF

        * Clean the starting part of the memo as appropriate
        DO CASE
        CASE m.cLeadOpt = 'B'
            DO WHILE (NOT EMPTY(m.cMemo)) AND LEFT(m.cMemo, 1) $ m.cWhiteSpace
                IF LEN(m.cMemo) > 1
                    m.cMemo = SUBSTR(m.cMemo, 2)
                ELSE
                    m.cMemo = ''
                ENDIF
            ENDDO
        CASE m.cLeadOpt = 'L'

            * Get rid of all leading blank lines - including those with only
            *   whitespace.  This means we have to look at all characters in
            *   the line.  If they're all all white space, we'll strip the
            *   line.  If we find a real character, we'll exit.
            m.cLine = ''
            DO WHILE (NOT EMPTY(m.cMemo)) AND LEFT(m.cMemo, 1) $ m.cWhiteSpace

                * Extract this character from the memo
                m.cThisChar = LEFT(m.cMemo,1)
                IF LEN(m.cMemo) > 1
                    m.cMemo = SUBSTR(m.cMemo, 2)
                ELSE
                    m.cMemo = ''
                ENDIF

                * If this is a LF, we know all the stuff in cLine is whitespace
                *   (otherwise our DO LOOP wouldn't be here).  So, this first
                *   chunk is a blank line.  So, throw away that stuff.
                IF m.cThisChar = LF
                    m.cLine = ''          && No need to add the character

                * This is a whitespace character, so add it to the line
                ELSE
                    m.cLine = m.cLine + m.cThisChar
                ENDIF
            ENDDO
            IF LEN(m.cLine) > 0
                m.cMemo = m.cLine + m.cMemo
            ENDIF
        ENDCASE

        * Eliminate all trailing white space
        DO WHILE (NOT EMPTY(m.cMemo)) AND RIGHT(m.cMemo,1) $ m.cWhiteSpace
            IF LEN(m.cMemo) > 1
                m.cMemo = LEFT(m.cMemo,LEN(m.cMemo)-1)
            ELSE
                m.cMemo = ''
            ENDIF
        ENDDO
        RETURN m.cMemo
    ENDFUNC

    *- FormatPhone() - Apply the correct formatting to the passed phone
    *     Input: cPhoneIn - 9999999 or 9999999999 or empty string
    *      Retn: 999-9999 or (999) 999-9999 or ''
    FUNCTION FormatPhone(cPhoneIn)
        LOCAL cRetPhone

        * Toss any existing formatting
        m.cRetPhone = m.cPhoneIn
        DO WHILE '-' $ m.cRetPhone
            m.cRetPhone = STRTRAN(m.cRetPhone, '-', '')
        ENDDO
        DO WHILE '(' $ m.cRetPhone
            m.cRetPhone = STRTRAN(m.cRetPhone, '(', '')
        ENDDO
        DO WHILE ')' $ m.cRetPhone
            m.cRetPhone = STRTRAN(m.cRetPhone, ')', '')
        ENDDO
        m.cRetPhone = ALLTRIM(m.cPhoneIn)

        * Apply formatting where appropriate
        DO CASE
        CASE LEN(m.cRetPhone) = 7
            m.cRetPhone = TRANSFORM(m.cRetPhone, "@R 999-9999")
        CASE LEN(m.cRetPhone) = 10
            m.cRetPhone = TRANSFORM(m.cRetPhone, "@R (999) 999-9999")
        ENDCASE
        RETURN m.cRetPhone
    ENDFUNC

    *- FlushLeft() - Return a string with characters moved flush left
    *     Input: cStrIn - String that may not be flush left
    *      Retn: cStrIn guaranteed to be flush left
    FUNCTION FlushLeft(cStrVar)
        RETURN PADR(LTRIM(m.cStrVar), LEN(m.cStrVar))
    ENDFUNC

    *- FlushRight() - Return a string with characters moved flush right
    *     Input: cStrIn - String that may not be flush right
    *      Retn: cStrIn guaranteed to be flush right
    FUNCTION FlushRight(cStrVar)
        RETURN PADL(TRIM(m.cStrVar), LEN(m.cStrVar))
    ENDFUNC

    *- FlushRZero() - Return a string with characters flush right, 0-filled
    *     Input: cStrIn - String that may not be flush right or 0-filled
    *      Retn: cStrIn guaranteed to be flush right and 0-filled if needed
    FUNCTION FlushRZero(cStrVar)
        RETURN PADL(ALLTRIM(m.cStrVar), LEN(m.cStrVar), '0')
    ENDFUNC

    *- ListMemo() - Return a memo converted to CR_LF terminated lines
    FUNCTION ListMemo(cMemo, nMaxLen, cIndentStr, bIsDisplay)
        LOCAL nOldMemo, cRetStr, nNumLns, nL

        * Parameters:
        *   cMemo - Memo field or string
        *   nMaxLen - Maximum desired line length
        *   cIndentStr - Preface to 2nd and remaining lines
        *   bIsDisplay - If .T. and EMPTY(cMemo), "(none>" is returned, else
        *                   a single space is returned
        * Returns:
        *   str1 + CR_LF
        *   cIndentStr + str2 + CR_LF
        *   cIndentStr + str3 + CR_LF...
        *   cIndentStr + strX

        * Do the trivial situation quickly
        IF EMPTY(m.cMemo)
            IF m.bIsDisplay
                RETURN '(none)'
            ELSE
                RETURN ' '
            ENDIF
        ENDIF

        * Save our current MEMOWIDTH setting
        m.nOldMemo = SET('MEMOWIDTH')
        SET MEMOWIDTH TO (m.nMaxLen)

        * Get the first line; it's the only one without the indent
        m.cRetStr = MLINE(m.cMemo, 1)

        * Extract that from the memo
        m.cMemo = SUBSTR(m.cMemo, LEN(m.cRetStr)+1)
        IF LEFT(m.cMemo,2) = CR_LF
            m.cMemo = SUBSTR(m.cMemo, 3)
        ENDIF

        * Add boldfacing only if bIsDisplay
        IF m.bIsDisplay
            m.cRetStr = '<B>' + m.cRetStr
        ENDIF

        * How many lines do we have left to print?
        SET MEMOWIDTH TO (m.nMaxLen - LEN(m.cIndentStr))
        m.nNumLns = MEMLINES(m.cMemo)

        * Go to it.
        FOR m.nL = 1 TO m.nNumLns
            m.cRetStr = m.cRetStr + CR_LF + m.cIndentStr + ;
            LTRIM(MLINE(m.cMemo, m.nL))
        ENDFOR

        * Done, clean up and return
        SET MEMOWIDTH TO (m.nOldMemo)
        IF m.bIsDisplay
            m.cRetStr = m.cRetStr + '</B>'
        ENDIF
        RETURN m.cRetStr
    ENDFUNC

    *- MakeLen() - Return a string at the desired length (chop or space fill)
    *     Input: cStrIn - String to have length changed
    *            nDesLen - New desired length
    *            bAddMT - .T. if "<empty>" should be put in empty strings that
    *                       are long enough
    *      Retn: cStrIn at the new length
    FUNCTION MakeLen(cStrIn, nDesLen, bAddMT)
        LOCAL cRetStr

        * If this is a memo field, pick only the stuff to the left of CR's.
        DO CASE
        CASE CR_LF $ m.cStrIn
            m.cRetStr = LEFT(m.cStrIn, AT(CR,m.cStrIn) - 1)

        * If it's empty, say so if they asked for it
        CASE EMPTY(m.cStrIn)
            m.cRetStr = IIF(m.nDesLen >= 7 AND m.bAddMT, '<empty>', ;
              SPACE(m.nDesLen))
        OTHERWISE
            m.cRetStr = m.cStrIn
        ENDCASE

        * Now, adjust the length
        DO CASE
        CASE LEN(m.cRetStr) > m.nDesLen
            m.cRetStr = LEFT(m.cRetStr, m.nDesLen)
        CASE LEN(m.cRetStr) < m.nDesLen
            m.cRetStr = m.cRetStr + SPACE(m.nDesLen - LEN(m.cRetStr))
        ENDCASE
        RETURN m.cRetStr
    ENDFUNC

    *- MakeProper() - PROPERly capitalize a string IF it's all UC or all LC
    *     Input: cStrIn - String to be checked
    *      Retn: String with proper capitalization
    FUNCTION MakeProper(cStrIn)
        LOCAL nLengthIn, cConvStr, bMixed, nPos, bLower, nStart, cTestStr, ;
          bOpposite

        * Get the passed string's length
        m.nLengthIn = LEN(m.cStrIn)
        m.cConvStr = TRIM(m.cStrIn)

        * Our objective is to automatically capitalize the first letters of
        *   each word.  But, some capitalizations shouldn't be changed:
        *       "McMinn", "IBM, Inc.", etc.
        * A "word" starts with the first alpha character that follows a
        *   non-alpha, non-numeric character.

        * First, define if we have a mixed case entry.  First, find the
        *   first character and see if it's upper- or lower-case
        m.bMixed = .F.
        FOR m.nPos = 1 TO LEN(m.cConvStr)
            IF ISALPHA(SUBSTR(m.cConvStr, m.nPos))
                m.bLower = ISLOWER(SUBSTR(m.cConvStr, m.nPos, 1))
                EXIT
            ENDIF
        ENDFOR

        * We may not have found any characters
        IF m.nPos = LEN(m.cConvStr)
            RETURN m.cStrIn
        ENDIF

        * Here, nPos has the position of the character we found.  Go thru the
        *   rest to see if we have mixed characters
        m.nStart = m.nPos + 1
        FOR m.nPos = m.nStart TO LEN(m.cConvStr)
            IF m.bLower
                m.bMixed = ISUPPER(SUBSTR(m.cConvStr, m.nPos, 1))
            ELSE
                m.bMixed = ISLOWER(SUBSTR(m.cConvStr, m.nPos, 1))
            ENDIF
            IF m.bMixed = .T.
                EXIT
            ENDIF
        ENDFOR

        * If we have a mixed case entry, we still want to capitalize if they
        *   had CAPS LOCK on and still hit the shift key, (we could have "sAN
        *   bERNARDINO")
        IF m.bMixed

            * Did they have CAPS LOCK on?  The only way to know is to convert
            *   the string to proper capitalization and look for opposites.
            m.cTestStr = THIS.ForceProper(m.cConvStr)

            * Now, is this the exact opposite of the entry string?  Assume so
            m.bOpposite = .T.
            FOR m.nPos = 1 to LEN(m.cConvStr)
                IF ISLOWER(SUBSTR(m.cConvStr, m.nPos, 1)) <> ;
                  ISUPPER(SUBSTR(m.cTestStr, m.nPos, 1))
                    m.bOpposite = .F.
                    EXIT
                ENDIF
            ENDFOR

            * If they were opposites, return our converted string, else return
            *   the input string
            IF m.bOpposite

                * Add spaces to get the right string length
                IF LEN(m.cTestStr) < m.nLengthIn
                    m.cTestStr = m.cTestStr + SPACE(m.nLengthIn - LEN(m.cTestStr))
                ENDIF
                RETURN m.cTestStr
            ELSE
                RETURN m.cStrIn
            ENDIF
        ENDIF

        * Case is not mixed, so we do a conversion
        m.cConvStr = THIS.ForceProper(m.cConvStr)

        * Add spaces to get the right string length
        IF LEN(m.cConvStr) < m.nLengthIn
            m.cConvStr = m.cConvStr + SPACE(m.nLengthIn - LEN(m.cConvStr))
        ENDIF
        RETURN m.cConvStr
    ENDFUNC

    *- ForceProper() - Convert string to lower, then proper capitalization
    *     Input: cStrIn - String to be checked
    *      Retn: String with proper capitalization
    FUNCTION ForceProper(cStrIn)
        LOCAL cOutStr, bMakeUpc, nCharPos, cThisChar

        * Make the entire string lowercase
        m.cOutStr = ALLTRIM(LOWER(m.cStrIn))

        * Now, the first alpha character must be uppercase.
        m.bMakeUpc = .T.

        * From then on, making it uppercase is determined by the existence of
        *   non-alpha characters.
        FOR m.nCharPos = 1 to LEN(m.cOutStr)
            m.cThisChar = SUBSTR(m.cOutStr, m.nCharPos, 1)
            DO CASE
            CASE ISALPHA(m.cThisChar)
                IF ISLOWER(m.cThisChar) AND m.bMakeUpc
                    m.cThisChar = UPPER(m.cThisChar)
                    m.cOutStr = STUFF(m.cOutStr, m.nCharPos, 1, m.cThisChar)
                ENDIF
                m.bMakeUpc = .F.

            * Any char following a number should not be capitalized: e.g. 1st
            CASE ISDIGIT(m.cThisChar)
                m.bMakeUpc = .F.

            * Any character following an apostrophe should not be capitalized:
            *   e.g. Proprieter's
            CASE m.cThisChar = "'"
                m.bMakeUpc = .F.

            * Anything else is a non-alpha, non-numeric character, so the next
            *   one should be capitalized
            OTHERWISE
                m.bMakeUpc = .T.
            ENDCASE
        ENDFOR
        RETURN m.cOutStr
    ENDFUNC

    *- ExtrQuotes() - Return an array object with quoted and non-quoted parts
    *     Input: cLineIn - String line to be split
    *      Retn: Array Object with rows for quoted and unquoted lines as:
    *               oObj.aRA[x,1] = Text part of line
    *               oObj.aRA[x,2] = .T. if text is quoted
    FUNCTION ExtrQuotes(cLineIn)
        LOCAL cQuotMarks, oObj, cLine2Do, nQuotePosn, cText2Add, cLeftQuote, ;
          cRightQuote

        * We're passed a line made up of quoted and non-quoted text.  We're to
        *   return an array object with the quoted and non-quoted stuff as follows:
        *       oObj.aRA[x,1] = Text part
        *       oObj.aRA[x,2] = .T. if text is quoted
        m.cQuotMarks = [",']

        * Create our string part object
        m.oObj = CREATEOBJECT('ArrayObj', 2)

        * Go thru the string chopping it up
        m.cLine2Do = m.cLineIn
        DO WHILE NOT EMPTY(m.cLine2Do)
            m.nQuotePosn = THIS.FirstAt(m.cQuotMarks, m.cLine2Do)

            * If we have none left, this is just text
            IF m.nQuotePosn = 0
                m.cText2Add = m.cLine2Do
                m.cLine2Do = ''
                m.oObj.AddRow(m.cText2Add, .F.)
                EXIT
            ENDIF

            * Extract any text before the quote
            IF m.nQuotePosn > 1
                m.cText2Add = LEFT(m.cLine2Do, m.nQuotePosn-1)
                m.cLine2Do = SUBSTR(m.cLine2Do, m.nQuotePosn)
                m.oObj.AddRow(m.cText2Add, .F.)
            ENDIF

            * Extract the quote character
            m.cLeftQuote = LEFT(m.cLine2Do, 1)
            m.cLine2Do = SUBSTR(m.cLine2Do, 2)
            IF m.cLeftQuote = '['
                m.cRightQuote = ']'
            ELSE
                m.cRightQuote = m.cLeftQuote
            ENDIF

            * Find the rightmost quote
            m.nQuotePosn = AT(m.cRightQuote, m.cLine2Do)

            * If we didn't get anything, this first quote was spurious
            *   so, just add the quote as text
            IF m.nQuotePosn = 0
                IF m.oObj.nRows > 0 AND NOT m.oObj.aRA[m.oObj.nRows,2]
                    m.oObj.aRA[m.oObj.nRows,1] = m.oObj.aRA[m.oObj.nRows,1] + m.cLeftQuote
                ELSE
                    m.oObj.AddRow(m.cLeftQuote, .F.)
                ENDIF
                LOOP
            ENDIF

            * Extract the quoted text and put it in our array
            m.cText2Add = m.cLeftQuote + LEFT(m.cLine2Do, m.nQuotePosn)
            IF m.nQuotePosn = LEN(m.cLine2Do)
                m.cLine2Do = ''
            ELSE
                m.cLine2Do = SUBSTR(m.cLine2Do, m.nQuotePosn+1)
            ENDIF
            m.oObj.AddRow(m.cText2Add, .T.)
        ENDDO WHILE NOT EMPTY(m.cLine2Do)

        * Return our array object
        RETURN m.oObj
    ENDFUNC

    *- Plural() - Return the plural form of the passed noun
    *     Input: cNoun - The singular noun to "pluralize"
    *            nNumber - The number in question
    *            cPluralExt - (optional) The string to add to the noun if the
    *                    number is a plural (default = 's')
    *      Retn: If nNumber = 1: only the cNoun is returned
    *            Else: the cNoun + cPluralExt are returned
    FUNCTION Plural(cNoun, nNumber, cPluralExt)

        * Make sure nNumber is a number
        IF VARTYPE(m.nNumber) <> 'N'
            m.nNumber = VAL(m.nNumber)
        ENDIF

        * Handle the only non-plural first
        IF m.nNumber == 1.0000000000
            RETURN m.cNoun
        ENDIF
        IF EMPTY(m.cPluralExt) OR VARTYPE(m.cPluralExt) <> 'C'
            m.cPluralExt = 's'
        ENDIF
        RETURN m.cNoun + m.cPluralExt
    ENDFUNC

    *- CountPlural() - Return the count and plural form of the passed noun
    *     Input: cNoun - The singular noun to "pluralize"
    *            nNumber - The number in question
    *            cPluralExt - (optional) The string to add to the noun if the
    *                    number is a plural (default = 's')
    *            bFirstCap - .T. if the first return letter is to be capitalized
    *      Retn: If nNumber = 0: "no " + cNoun + cPluralExt is returned
    *            If nNumber = 1: "one " and the cNoun is returned
    *            Else: the number + cNoun + cPluralExt are returned
    FUNCTION CountPlural(cNoun, nNumber, cPluralExt, bFirstCap)
        LOCAL cFirstLtrs

        * Check our parameters
        IF VARTYPE(m.nNumber) <> 'N'
            m.nNumber = VAL(m.nNumber)
        ENDIF
        IF EMPTY(m.cPluralExt) OR VARTYPE(m.cPluralExt) <> 'C'
            m.cPluralExt = 's'
        ENDIF

        * Define our first letters
        IF m.bFirstCap
            m.cFirstLtrs = 'NO'
        ELSE
            m.cFirstLtrs = 'no'
        ENDIF

        * Handle the possibilities
        DO CASE
        CASE m.nNumber = 0
            RETURN LEFT(m.cFirstLtrs,1) + 'o ' + m.cNoun + m.cPluralExt
        CASE m.nNumber = 1
            RETURN RIGHT(m.cFirstLtrs,1) + 'ne ' + m.cNoun
        ENDCASE

        * Here we're neither 0 nor 1
        IF RIGHT(m.cNoun, 1) = 'y' AND m.cPluralExt = 'ies'
            m.cNoun = LEFT(m.cNoun, LEN(m.cNoun)-1)
        ENDIF
        RETURN ALLTRIM(TRANSFORM(m.nNumber)) + [ ] + m.cNoun + m.cPluralExt
    ENDFUNC

     *- ExtrPlural() - Return the singular form of the passed plural
     *     Input: cPlural - The plural noun
     *      Retn: The singular form of that plural
     FUNCTION ExtrPlural(cStrIn)
         LOCAL cStrOut

         * For now, we'll do the obvious; as we learn more, we'll add heuristics
         m.cStrOut = m.cStrIn
         IF RIGHT(m.cStrIn, 2) <> [SS]                             && Compass
             m.cStrIn = UPPER(m.cStrIn)
             DO CASE
             CASE RIGHT(m.cStrIn, 3) = [IES] && Boundaries
                 m.cStrOut = LEFT(m.cStrOut, LEN(m.cStrOut)-3) + 'y'
             CASE RIGHT(m.cStrIn, 2) = [ES] && Purposes
                 m.cStrOut = LEFT(m.cStrOut, LEN(m.cStrOut)-2)
             CASE RIGHT(m.cStrIn, 1) = [S] && Tattoos
                 m.cStrOut = LEFT(m.cStrOut, LEN(m.cStrOut)-1)
             ENDCASE
         ENDIF
         RETURN m.cStrOut
    ENDFUNC

    *- StrToHTML() - Convert &, <, > chars for HTML output
    *     Input: cStrIn - Incoming string
    *     Output: TRIMmed cStrIn where &, < and >s are converted to escaped
    *             equivalents. If cStrIn is empty, it becomes "&nbsp;".
    *     CAUTION: Not to be used for INPUT values
    FUNCTION StrToHTML(cStrIn)
        LOCAL cRetVal, cLeft, nPosn

        * If it's empty, handle that
        IF EMPTY(m.cStrIn)
            RETURN '&nbsp;'
        ENDIF

        * Trim the string
        m.cRetVal = ALLTRIM(m.cStrIn)

        * Convert any special characters
        m.cRetVal = THIS.CharsToHTML(m.cRetVal)

        * Done
        RETURN m.cRetVal
    ENDFUNC

    * CharsToHTML() - Convert special characters into HTML equivalents
    *     Input: cStrIn - Incoming string
    *     Output: cStrIn where &, < and >s are converted to escaped HTML
    *             equivalents.
    *     CAUTION: Not to be used for INPUT values
    FUNCTION CharsToHTML(cStr)
        LOCAL cStrOut, cLeft, nPosn

        * Define the return string (there may be NO special characters)
        m.cStrOut = m.cStr

        * Convert any &, < and >s
        IF [&] $ m.cStrOut        && Might already be &amp; or &nbsp; so there
            m.cLeft = ''
            m.nPosn = AT([&], m.cStrOut)
            DO WHILE m.nPosn > 0
                m.cLeft = m.cLeft + LEFT(m.cStrOut, m.nPosn-1)
                m.cStrOut = SUBSTR(m.cStrOut, m.nPosn)
                DO CASE
                CASE m.cStrOut = '&amp;'
                    m.cLeft = m.cLeft + [&amp;]
                    m.cStrOut = SUBSTR(m.cStrOut, 6)
                CASE m.cStrOut = '&nbsp;'
                    m.cLeft = m.cLeft + [&nbsp;]
                    m.cStrOut = SUBSTR(m.cStrOut, 7)
                OTHERWISE
                    m.cLeft = m.cLeft + [&amp;]
                    m.cStrOut = SUBSTR(m.cStrOut, 2)
                ENDCASE
                m.nPosn = AT([&], m.cStrOut)
            ENDDO
            m.cStrOut = m.cLeft + m.cStrOut
        ENDIF
        IF [<] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [<], [&lt;])
        ENDIF
        IF [>] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [>], [&gt;])
        ENDIF
        IF [CHR(145)] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [CHR(145)], ['])
        ENDIF
        IF [CHR(146)] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [CHR(146)], ['])
        ENDIF
        IF [CHR(147)] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [CHR(147)], ["])
        ENDIF
        IF [CHR(148)] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [CHR(148)], ["])
        ENDIF

        * Done
        RETURN m.cStrOut
    ENDFUNC

    *- WebTrim() - Trim a string variable for HTML output
    *     Input: cStrIn - String to be trimmed
    *      Retn: Trimmed cStrIn, or non-breaking space if cStrIn is empty
    FUNCTION WebTrim(cStrIn)

        * If empty, make it a non-break space, otherwise just trim it
        IF EMPTY(m.cStrIn)
            RETURN '&nbsp;'
        ELSE
            RETURN ALLTRIM(m.cStrIn)
        ENDIF
    ENDFUNC

    *- PostTrim() - Trim a string variable and remove artifacts
    *     Input: cStrIn - String to be checked
    *      Retn: Trimmed cStrIn with Non-breaking spaces and 0FFhs removed
    FUNCTION PostTrim(cStrIn)
        LOCAL cStrOut

        * First, trim it
        m.cStrOut = ALLTRIM(m.cStrIn)

        * Now, remove any non-breaking spaces and Hex FFs
        IF CHR(160) $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, CHR(160), '')
        ENDIF
        IF '&nbsp;' $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, '&nbsp;', '')
        ENDIF
        IF HEX_FF $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, HEX_FF, '')
        ENDIF
        RETURN m.cStrOut
    ENDFUNC

    *- PostVal() - Return a numeric after removing artifacts
    *     Input: cStrIn - String to be checked
    *      Retn: VAL() of cStrIn after non-breaking spaces and 0FFhs removed
    FUNCTION PostVal(cStrIn )
        LOCAL nNumbOut

        * First, POST trim it and kill the artifacts
        m.cStrOut = THIS.PostTRIM(m.cStrIn)

        * Now, remove any internal commas...
        IF ',' $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, ',', '')
        ENDIF

        * ...and return the numeric equivalent
        RETURN VAL(m.cStrOut)
    ENDFUNC

    *- StripChrs() - Remove one or more characters from a passed string
    *     Input: cStrIn - String to be checked
    *            cDelChars - String of characters to be removed
    *      Retn: String with cDelChars characters removed
    FUNCTION StripChrs(cStrIn, cDelChars)
        LOCAL cRetVal, nDelLen, nZ, cChar

        * Note that we could, more easily, use CHRTRAN().  But, it's known for
        *   sometimes throwing bugs if the return string is shorter than the
        *   starting string.  This was especially true in VFP 5, but also true
        *   in VFP 6 though Microsoft claimed it was fixed.  Hence the need to
        *   roll our own.

        * Two possible versions were tested:
        *   a. A function that added good characters to the return string but
        *       then required testing for each input string character.  Test
        *       time for 100,000 function calls: 30 seconds.
        *   b. This function that tests each bad character and uses STRTRAN()
        *       to remove them all.  Test time for 100,000 function calls: 12
        *       seconds.

        * Initialize our return value
        m.cRetVal = m.cStrIn

        * Pull out the desired characters
        m.nDelLen = LEN(m.cDelChars)
        FOR m.nZ = 1 TO m.nDelLen
            m.cChar = SUBSTR(m.cDelChars, m.nZ, 1)
            IF m.cChar $ m.cRetVal
                m.cRetVal = STRTRAN(m.cRetVal, m.cChar, '')
            ENDIF
        ENDFOR
        RETURN m.cRetVal
    ENDFUNC

    *- WordWrapString() - Reformat a string with CR_LF lines
    *     Input: cStrIn - String to be word-wrapped
    *            nMaxLinLen - Max. length of a line
    *            nIndentSpcs - Prepend this from 2nd line on
    *            bKillIntEnds - (Optional) .T. if internal blank lines are to
    *                       be removed (default = .F.)
    *      Retn: Word-wrapped string
    FUNCTION WordWrapString(cStrIn, nMaxLinLen, nIndentSpcs, bKillIntEnds)
        LOCAL nIndent, cRawMemo, cStrOut, cIndent, cFrag

        * Handle the trivial case quickly
        IF EMPTY(m.cStrIn)
            RETURN ''
        ENDIF

        * We have 2 tasks to do:
        *   1. Make sure no individual line is longer than nMaxLinLen
        *   2. Indent the 2nd line on by nIndentSpcs
        * Define our indent count
        m.nIndent = 0
        IF TYPE('nIndentSpcs') = 'N' AND m.nIndentSpcs > 0
            m.nIndent = m.nIndentSpcs
        ENDIF

        * To make this easy, we'll change all CR_LFs into 0FFh
        m.cRawMemo = STRTRAN(m.cStrIn, CR_LF, HEX_FF)

        * Do the conversion for the 1st line
        m.cStrOut = THIS.ExtrLine(@m.cRawMemo, m.nMaxLinLen, m.bKillIntEnds)
        IF NOT EMPTY(m.cStrOut)
            m.cStrOut = m.cStrOut + CR_LF
        ENDIF

        * Now handle the rest of the lines indenting them as appropriate
        m.cIndent = SPACE(m.nIndent)
        DO WHILE NOT EMPTY(m.cRawMemo)

            * If this begins with spaces and we have an indent, trim it, we
            *   don't want do add yet more spaces.
            IF m.cRawMemo = ' ' AND m.nIndent > 0
                m.cRawMemo = LTRIM(m.cRawMemo)
            ENDIF
            m.cFrag = THIS.ExtrLine(@m.cRawMemo, m.nMaxLinLen - m.nIndent, m.bKillIntEnds)
            IF NOT EMPTY(m.cFrag)
                m.cStrOut = m.cStrOut + m.cIndent + m.cFrag + CR_LF
            ENDIF
        ENDDO
        RETURN m.cStrOut
    ENDFUNC

    *- SwapPhrase() - Substitute all instances of a word/phrase with a 2nd word/phrase
    *     Input: cStrIn - String to be changed
    *            cPhraseIn - Phrase to be changed
    *            cNewPhrase - Phrase to be put in plase of cPhraseIn
    *      Retn: Changed string
    *     Notes: 1. This is a case-insensitive swap.
    *            2. cPhraseIn must be within word boundaries at each end
    FUNCTION SwapPhrase(cStrIn, cPhraseIn, cNewPhrase)
        LOCAL cStr2Do, cWordChars, cRetStr, nPhraseLen, nPosn, cCapPhase

        * Is the word in here at all?
        IF NOT UPPER(m.cPhraseIn) $ UPPER(m.cStrIn)
            RETURN m.cStrIn
        ENDIF

        * Setup for processing
        m.cStr2Do = m.cStrIn
        m.cWordChars = THIS.cWordChars
        m.cRetStr = ''
        m.nPhraseLen = LEN(m.cPhraseIn)

        * Find all instances of cPhraseIn
        m.nPosn = AT(UPPER(m.cPhraseIn), UPPER(m.cStr2Do))
        DO WHILE m.nPosn > 0

            * The prior character can't be a word character
            IF SUBSTR(m.cStr2Do, m.nPosn-1, 1) $ m.cWordChars
                m.cRetStr = m.cRetStr + LEFT(m.cStr2Do, m.nPosn + 1)
                m.cStr2Do = SUBSTR(m.cStr2Do, m.nPosn + 1)
                LOOP
            ENDIF

            * Extract all before the phrase
            m.cRetStr = m.cRetStr + LEFT(m.cStr2Do, m.nPosn-1)
            m.cStr2Do = SUBSTR(m.cStr2Do, m.nPosn)

            * The following character can't be a word character
            IF SUBSTR(m.cStr2Do, m.nPhraseLen + 1, 1) $ m.cWordChars
                m.cRetStr = m.cRetStr + LEFT(m.cStr2Do, m.nPhraseLen)
                m.cStr2Do = SUBSTR(m.cStr2Do, m.nPhraseLen + 1)
                LOOP
            ENDIF

            * Here we have our phrase; substitute it
            m.cRetStr = m.cRetStr + m.cNewPhrase
            m.cStr2Do = SUBSTR(m.cStr2Do, m.nPhraseLen + 1)

            * Find the next instance of the phrase
            m.nPosn = AT(UPPER(m.cPhraseIn), UPPER(m.cStr2Do))
        ENDDO

        * Add anything left in cStr2Do and we're done
        m.cRetStr = m.cRetStr + m.cStr2Do
        RETURN m.cRetStr
    ENDFUNC

    *- CreateSpecialKey() - Return a key with 1 of 71 possible characters
    *     Input: nStrLen - Desired length of string
    *      Retn: New string containing a random selection of these characters:
    *             0-9, A-Z, a-z and !@#$%*()+
    FUNCTION CreateSpecialKey(nStrLen)
        LOCAL cCharList, nListLen, nRetStr, nX

        * Get our list of complex characters
        m.cCharList = THIS.cComplexChars
        m.nListLen = LEN(m.cCharList)

        * Now, populate our return string with random selections
        m.nRetStr = ''
        FOR m.nX = 1 TO m.nStrLen
            m.nPosn = (RAND() * m.nListLen) + 1
            m.cChar = SUBSTR(m.cCharList, INT(m.nPosn), 1)
            m.nRetStr = m.nRetStr + m.cChar
        ENDFOR
        RETURN m.nRetStr
    ENDFUNC


        ***** Output Formatting *****

    *- Format() - Return the passed string with variable values inserted
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
    FUNCTION Format(cString, vPara0, vPara1, vPara2, vPara3, vPara4, vPara5, vPara6, vPara7, vPara8, vPara9)
        LOCAL nOldDec, cRet, nCount, cCount, cArg, cFormat

        * This method mostly mimics the String.Format() C# or C++ methods in
        *   .NET.

        * Acknowledgement: This, and related mothods, are based on code in
        *   article by Jrgen Wondzinski (aka wOOdy) in the MSDN Code Gallery
        *   (see http://code.msdn.microsoft.com/FoxPro/Release/ProjectReleases.aspx?ReleaseId=442)
        * It was adjusted by Eric Selje (http://saltydogllc.com/) as part of an
        *   article, "String.Format for VFP," in the FoxRockX magazine, dated
        *   Jan. 2010.
        * While I've (KAG) modified this somewhat - especially the
        *   NumericFormat(), its lower methods and the LogicalFormat() method -
        *   it's those others that deserve the credit for good ideas and
        *   realistic implementation.

        * Save the current DECIMALS setting and change to 18
        m.nOldDec = SET('DECIMALS')
        SET DECIMALS TO 18          && Maximum for VFP

        * Get the string we'll return
        m.cRet = m.cString

        * Extract all parameters within {}s and convert them
        FOR m.nCount = 1 TO OCCURS("{", m.cString)

            * Extract the parameter and its count (if any)
            m.cArg = STREXTRACT(m.cString, "{", "}", m.nCount, 4)
            m.cFormat = STREXTRACT(m.cArg, ":", "}")
            m.cCount = CHRTRAN(STRTRAN(m.cArg, m.cFormat,""), "{:}","")

            * If there is no format letter, just do a direct TRANSFORM()
            IF EMPTY(m.cFormat)
                m.cRet = STRTRAN(m.cRet, m.cArg, ;
                  TRANSFORM(EVALUATE("vPara"+m.cCount)))
            ELSE

                * Handle formatting based on the variable's type
                m.xParam = EVALUATE("vPara"+m.cCount)
                DO CASE

                * Dates and DateTimes
                CASE INLIST(VARTYPE(m.xParam),'D','T')
                    m.cRet = STRTRAN(m.cRet, m.cArg, THIS.DateFormat(m.xParam, m.cFormat))

                * Numbers and Currencies
                CASE INLIST(VARTYPE(m.xParam),'N','Y')
                    m.cRet = STRTRAN(m.cRet, m.cArg, ;
                      THIS.NumericFormat(m.xParam, m.cFormat))

                * Logicals
                CASE VARTYPE(m.xParam) = 'L'
                    m.cRet = STRTRAN(m.cRet, m.cArg, ;
                      THIS.LogicalFormat(m.xParam, m.cFormat))

                * All others just get a direct TRANSFORM()
                OTHERWISE
                    m.cRet = STRTRAN(m.cRet, m.cArg, TRANSFORM(m.xParam, m.cFormat))
                ENDCASE
            ENDIF
        ENDFOR
        SET DECIMALS TO (m.nOldDec)
        RETURN m.cRet
    ENDFUNC

    *- DateFormat() - Format a Date or DateTime into a string
    *     Input: dtConvert - Date or DateTime variable to be converted
    *            cFormat - Formatting codes
    *      Retn: String of Date or DateTime converted according to the format
    FUNCTION DateFormat(dtConvert, cFormat)
        LOCAL cResult, dConvert, cTimeZone, iBiasSeconds, cPattern

        * Define our return value
        m.cResult = ""

        * For consistency's sake, get both a date and datetime variable
        IF VARTYPE(m.dtConvert)="D"
            m.dConvert = m.dtConvert
            m.dtConvert = DTOT(m.dConvert)  && Defaults time to midnight (00:00:00)
        ELSE
            m.dConvert = TTOD(m.dtConvert)
        ENDIF

        * We only have 1-character formats here
        IF LEN(m.cFormat) = 1
            IF INLIST(m.cFormat, 'r', 'u', 'U')

                * Adjust time to GMT
                DECLARE INTEGER GetTimeZoneInformation IN kernel32 ;
                  STRING @lpTimeZoneInformation
                m.cTimeZone = REPLICATE(Chr(0), 172)
                GetTimeZoneInformation(@m.cTimeZone)
                m.iBiasSeconds = 60 * INT(ASC(SUBSTR(m.cTimeZone, 1,1)) + ;
                  BITLSHIFT(ASC(SUBSTR(m.cTimeZone,2,1)), 8)+;
                  BITLSHIFT(ASC(SUBSTR(m.cTimeZone,3,1)),16)+;
                  BITLSHIFT(ASC(SUBSTR(m.cTimeZone,4,1)),24))
                m.dtConvert = m.dtConvert - m.iBiasSeconds
                m.dConvert = TTOD(m.dtConvert)
            ENDIF
            DO CASE

            * Short date eg 10/12/2002
            CASE m.cFormat = 'd'
                m.cPattern = 'MM/dd/yyyy'

            * Long date, short month eg. Dec. 10, 2002
            CASE m.cFormat = 'D'
                m.cPattern = 'MMM. dd, yyyy'

            * Long date eg. December 10, 2002.
            CASE m.cFormat = 'L'
                m.cPattern = 'MMMM dd, yyyy'

            * Full date & time eg December 10, 2002 10:11 PM
            CASE m.cFormat = 'f'
                m.cPattern = 'MMMM dd, yyyy hh:mm tt'

            * Full date & time (long) eg December 10, 2002 10:11:29 PM
            CASE m.cFormat = 'F'
                m.cPattern = 'MMMM dd, yyyy hh:mm:ss tt'

            * Default date & time eg 10/12/2002 10:11 PM
            CASE m.cFormat = 'g'
                m.cPattern = 'MM/dd/yyyy hh:mm tt'

            * Default date & time (long) eg 10/12/2002 10:11:29 PM
            CASE m.cFormat = 'G'
                m.cPattern = 'MM/dd/yyyy hh:mm:ss tt'

            * Month day pattern eg December 10
            CASE m.cFormat = 'M'
                m.cPattern = 'MMMM dd'

            * RFC1123 date string Tue, 10 Dec 2002 22:11:29 GMT
            CASE m.cFormat = 'r'
                m.cPattern = 'ddd, dd MMM yyyy hh:mm:ss GMT'

            * Sortable date string eg 2002-12-10T22:11:29
            CASE m.cFormat = 's'
                m.cPattern = TTOC(m.dtConvert,3)

            * Short time eg 10:11 PM
            CASE m.cFormat = 't'
                m.cPattern = 'hh:mm tt'

            * Long time eg 10:11:29 PM
            CASE m.cFormat = 'T'
                m.cPattern = 'hh:mm:ss tt'

            * Universal sortable, local time eg 2002-12-10 22:13:50Z
            CASE m.cFormat = 'u'
                m.cPattern = 'yyyy-MM-dd hh:mm:ddZ'

            * Universal sortable, GMT eg December 11, 2002 3:13:50 AM
            CASE m.cFormat = 'U'
                m.cPattern = "MMMM dd, yyyy hh:mm:ss tt"

            * Year month pattern eg December, 2002
            CASE m.cFormat = 'Y'
                m.cPattern = "MMMM, yyyy"
            ENDCASE
            m.cResult = THIS.ParseDateFormat(m.cPattern, m.dtConvert)
        ENDIF
        RETURN m.cResult
    ENDFUNC

    *- PROT ParseDateFormat() - Parse a format to return a Date/Time string
    PROTECTED FUNCTION ParseDateFormat(cFrmt, dtVar)
        LOCAL cRetStr, bChgTo12Hr, nHrs, cHrs
        m.cRetStr = m.cFrmt

        * Check the hours; they can be funny
        m.nHrs = HOUR(m.dtVar)
        m.bChgTo12Hr = ('tt' $ m.cRetStr)
        IF m.bChgTo12Hr AND m.nHrs > 12
            m.nHrs = m.nHrs - 12
        ENDIF
        IF m.bChgTo12Hr
            m.cHrs = TRANSFORM(m.nHrs)
        ELSE
            m.cHrs = PADL(m.nHrs,2,'0')
        ENDIF

        * Just do what needs doing; insert the values into the passed string
        m.cRetStr= STRTRAN(m.cRetStr,"hh", m.cHrs)
        m.cRetStr= STRTRAN(m.cRetStr,"mm", PADL(MINUTE(m.dtVar),2,'0'))
        m.cRetStr= STRTRAN(m.cRetStr,"ss", PADL(SEC(m.dtVar),2,'0'))
        m.cRetStr= STRTRAN(m.cRetStr,"MMMM", CMONTH(m.dtVar))
        m.cRetStr= STRTRAN(m.cRetStr,"MMM.", LEFT(CMONTH(m.dtVar),3) + '.')
        m.cRetStr= STRTRAN(m.cRetStr,"MMM", LEFT(CMONTH(m.dtVar),3))
        m.cRetStr= STRTRAN(m.cRetStr,"MM", PADL(MONTH(m.dtVar),2,'0'))
        m.cRetStr= STRTRAN(m.cRetStr,"ddd", LEFT(CDOW(m.dtVar),3))
        m.cRetStr= STRTRAN(m.cRetStr,"dd", PADL(DAY(m.dtVar),2,'0'))
        m.cRetStr= STRTRAN(m.cRetStr,"yyyy", TRANSFORM(YEAR(m.dtVar)))
        m.cRetStr= STRTRAN(m.cRetStr,"yy", RIGHT(TRANSFORM(YEAR(m.dtVar)),2))
        m.cRetStr= STRTRAN(m.cRetStr,"tt", IIF(HOUR(m.dtVar) < 12, "AM", "PM"))
        RETURN m.cRetStr
    ENDFUNC

    *- NumericFormat() - Format a Number or Currency value into a string
    *     Input: nConvert - Number or Currency variable to be converted
    *            cFormat - Formatting codes
    *      Retn: String of Number or Currency converted according to the format
    FUNCTION NumericFormat(nNumbIn, cFormat)
        LOCAL cFrmtLtr, nPrec, cClass, oNumb, cResult

        * All formats start with a single letter
        m.cFrmtLtr = LEFT(m.cFormat, 1)

        * They may have a precision; if not, we'll have to setup our defaults
        IF LEN(m.cFormat) > 1
            m.nPrec = VAL(SUBSTR(m.cFormat, 2))
        ENDIF

        * Define our number object class
        IF UPPER(m.cFrmtLtr) = 'D'
            m.cClass = [I] + [TypeNumber]
        ELSE
            m.cClass = UPPER(m.cFrmtLtr) + [TypeNumber]
        ENDIF

        * Create the number object
        IF VARTYPE(m.nPrec) = 'N'
            m.oNumb = CREATEOBJECT(m.cClass, m.cFrmtLtr, m.nNumbIn, m.nPrec)
        ELSE
            m.oNumb = CREATEOBJECT(m.cClass, m.cFrmtLtr, m.nNumbIn)
        ENDIF

        * Get the conversion
        m.cResult = m.oNumb.ToString()
        RETURN m.cResult
    ENDFUNC

    *- LogicalFormat() - Format a Logical value into a string
    *     Input: bValue - Logical value to be converted
    *            cFormat - Formatting codes (see above)
    *      Retn: String of Logical converted according to the format
    FUNCTION LogicalFormat(bValue, cFormat)
        LOCAL cFrmtLtr, nChars, cResult

        * All formats start with a single letter
        m.cFrmtLtr = LEFT(m.cFormat, 1)

        * How many characters do they want?
        IF LEN(m.cFormat) > 1
            m.nChars = VAL(SUBSTR(m.cFormat, 2))
        ELSE
            m.nChars = 0
        ENDIF

        * Handle each type of formatting
        DO CASE

        * True/False: "Tz" or "tz"
        CASE LOWER(m.cFrmtLtr) = 't'
            m.cResult = IIF(m.bValue, 'true', 'false')

        * Yes/No: "Yz" or "yz"
        CASE LOWER(m.cFrmtLtr) = 'y'
            m.cResult = IIF(m.bValue, 'yes', 'no')

        * Don' know what to do here, boss.
        OTHERWISE
            ERROR [Invalid Format: ] + m.cFormat
        ENDCASE

        * Should that first letter be uppercase?
        IF m.cFrmtLtr $ 'TY'
            m.cResult = UPPER(LEFT(m.cResult,1)) + SUBSTR(m.cResult,2)
        ENDIF

        * Chop the result as desired
        IF m.nChars > 0 AND m.nChars < LEN(m.cResult)
            m.cResult = LEFT(m.cResult, m.nChars)
        ENDIF
        RETURN m.cResult
    ENDFUNC


        ***** VFP Code Formatting *****

    *- Comm2Code() - Format one comment line to fit within a specified length
    *     Input: cLineIn - Comment line to be formatted
    *            nMaxLen - Max. length of output string
    *      Retn: Formatted line with any necessary " ;" line continuations.
    FUNCTION Comm2Code(cLineIn, nMaxLen)

        * Trivial situation first
        IF LEN(m.cLineIn) <= m.nMaxLen
            RETURN m.cLineIn + CR_LF
        ENDIF

        * What's our current left margin?
        m.cLineOut = LTRIM(m.cLineIn)
        m.cLftMarg = SPACE(LEN(m.cLineIn) - LEN(m.cLineOut))

        * Go to it; comments are much simpler than other lines because we
        * don't have to worry about quotes.  But, we do have to:
        *   1. Start each additional line with a properly indented *
        *   2. Add 2 more spaces to the text within the comment
        m.cLineOut = ''
        m.cWkgText = m.cLineIn
        DO WHILE NOT EMPTY(m.cWkgText)
            m.cLine = goStr.ExtrLine(@m.cWkgText, m.nMaxLen)
            m.cLineOut = m.cLineOut + m.cLine + CR_LF
            IF NOT EMPTY(m.cWkgText)
                m.cWkgText = m.cLftMarg + [*   ] + m.cWkgText
            ENDIF
        ENDDO

        * Done
        RETURN m.cLineOut
    ENDFUNC

    *- Line2Code() - Format one line of code to fit within a specified length
    *     Input: cLineIn - String line to be formatted
    *            nMaxLen - Max. length of output string
    *      Retn: Formatted line with any necessary " ;" line continuations.
    *               Quoted strings will be split properly (with quotes at split)
    FUNCTION Line2Code(cLineIn, nMaxLen)
        LOCAL cLineOut, cLftMarg, cQuotMarks, nChopLen, cLine2Do, oQuoteObj, ;
          cLinePart, nX, cThisLine, bIsQuoted, cLeftQuote, cRightQuote, cLeft, ;
          bHandleLine

        * Trivial situation first
        IF LEN(m.cLineIn) <= m.nMaxLen
            RETURN m.cLineIn
        ENDIF

        * What's our current left margin?
        m.cLineOut = LTRIM(m.cLineIn)
        m.cLftMarg = SPACE(LEN(m.cLineIn) - LEN(m.cLineOut))

        * Define quote characters and our chopping length (to allow for " ;")
        *   (We won't use [] as they're also used for array notation and it
        *   wouldn't do to split "oObj.aRA[100,45]" as oObj.aRA[10] + [0,45]
        m.cQuotMarks = [",']
        m.nChopLen = m.nMaxLen - 2

        * If the line is longer than nMaxLen we want to split it as follows:
        *   1. Split it at the closest whitespace to nMaxLen (chop it if we
        *       have to).  But, manage quotation marks so if the line is split
        *       within quotes, the strings are properly terminated.
        *   2. Add a line continuation character (;) to the first line after it's
        *       split and indent the next line 2 spaces.
        m.cLineOut = ''
        m.cLine2Do = m.cLineIn

        * Do we have any quotes?  If so, we have a different process
        IF THIS.FirstAt(m.cQuotMarks, m.cLine2Do) > 0

            * Get an array object of the line split at quotes
            m.oQuoteObj = THIS.ExtrQuotes(m.cLineIn)

            * Now, go thru the array adding line parts
            m.cLinePart = ''
            FOR m.nX = 1 TO m.oQuoteObj.nRows
                m.cThisLine = m.oQuoteObj.aRA[m.nX,1]
                m.bIsQuoted = m.oQuoteObj.aRA[m.nX,2]

                * Will this cause our line part to be too long?
                DO CASE

                * Don't try to stuff the new line onto this
                CASE LEN(m.cLinePart) + 6 > m.nMaxLen

                    * Process the partial line
                    m.bHandleLine = .T.

                * Do we have to split this line?
                CASE LEN(m.cLinePart + m.cThisLine) > m.nMaxLen
                    IF m.bIsQuoted
                        m.cLeftQuote = LEFT(m.cThisLine,1)
                        m.cRightQuote = RIGHT(m.cThisLine,1)
                        m.nChopLen = m.nMaxLen - 1 - LEN(m.cLinePart)
                    ELSE
                        m.nChopLen = m.nMaxLen - LEN(m.cLinePart)
                    ENDIF
                    m.cLeft = THIS.ExtrLine(@m.cThisLine, m.nChopLen)
                    IF m.bIsQuoted
                        m.cLeft = m.cLeft + m.cRightQuote
                        m.cThisLine = "+ " + m.cLeftQuote + m.cThisLine
                    ENDIF
                    m.cLinePart = m.cLinePart + m.cLeft
                    m.bHandleLine = .T.
                OTHERWISE       && Nope
                    m.cLinePart = m.cLinePart + m.cThisLine
                    m.cThisLine = ''
                    m.bHandleLine = (m.nX = m.oQuoteObj.nRows)
                ENDCASE

                * If this partial line is done, process it
                IF m.bHandleLine
                    m.cLineOut = m.cLineOut + m.cLinePart
                    IF m.nX < m.oQuoteObj.nRows
                        m.cLineOut = m.cLineOut + ' ;' + CR_LF
                        m.cLinePart = m.cLftMarg + '  ' + m.cThisLine
                    ELSE
                        m.cLinePart = ''
                        IF NOT EMPTY(m.cThisLine)
                            m.cLineOut = m.cLineOut + ' ;' + CR_LF + m.cLftMarg + ;
                              '  ' + m.cThisLine
                        ENDIF
                    ENDIF
                ENDIF
            ENDFOR
        ELSE

            * No quotes, so we just split the line as needed
            DO WHILE NOT EMPTY(m.cLine2Do)

                * Get the part of the line
                IF LEN(m.cLine2Do) <= m.nMaxLen
                    m.cLinePart = m.cLine2Do
                    m.cLine2Do = ''
                ELSE
                    m.cLinePart = THIS.ExtrLine(@m.cLine2Do, m.nChopLen) + ' ;'
                ENDIF   && LEN(cLine2Do) <= nMaxLen

                * Add this to our output text
                m.cLineOut = m.cLineOut + m.cLinePart + CR_LF

                * "Indent" cLine2Do
                m.cLine2Do = m.cLftMarg + '  ' + m.cLine2Do
            ENDDO
        ENDIF
        RETURN m.cLineOut
    ENDFUNC

    *- FormatCode() - Format a block of text as VFP Code with ; carry-overs
    *     Input: cTextIn - String to be formatted (can be multiple lines)
    *            nRightMargin - (optional) desired right margin (e.g. max.
    *                   length of output string - default = 80)
    *      Retn: Formatted string with any necessary " ;" line continuations.
    *               Quoted strings will be split properly (with quotes at split)
    FUNCTION FormatCode(cTextIn, nRightMargin)
        LOCAL nRtMarg, cText2Do, cTextOut, cLine

        * Set the number of characters we want (default = 80)
        m.nRtMarg = 80
        IF VARTYPE(m.nRightMargin) = 'N' AND m.nRightMargin > 0
            m.nRtMarg = m.nRightMargin
        ENDIF

        * Convert all CR_LFs to HEX_FFs
        m.cText2Do = STRTRAN(m.cTextIn, CR_LF, HEX_FF)

        * Go thru the entire input string creating our output string
        m.cTextOut = ''
        DO WHILE NOT EMPTY(m.cText2Do)

            * Get this line
            m.cLine = THIS.ExtrToken(@m.cText2Do, HEX_FF)

            * We want to split this line but every line after the 1st should be
            *   indented 2 chars.  Further, we want to add the line continuation
            *   character
            IF LEN(m.cLine) > m.nRtMarg
                m.cLine = THIS.Line2Code(m.cLine, m.nRtMarg)
            ENDIF
            IF RIGHT(m.cLine, 2) == CR_LF
                m.cTextOut = m.cTextOut + m.cLine
            ELSE
                m.cTextOut = m.cTextOut + m.cLine + HEX_FF
            ENDIF
        ENDDO
        m.cTextOut = STRTRAN(m.cTextOut, HEX_FF, CR_LF)
        RETURN m.cTextOut
    ENDFUNC


        ***** Encoding/Encrypting Functions *****

    *- EncryptIt() - Return an encrypted string
    *     Input: cStrIn - URL String to be encrypted
    *      Retn: Encrypted string
    FUNCTION EncryptIt(cPlainIn)
        LOCAL cPlainIn, cStr2Do, cSwapped, cEncrypt, nW, ;
          nChar, nXform, nStrLen

        * Make the string an even length, after trimming
        m.cStr2Do = TRIM(m.cPlainIn)
        IF MOD(LEN(m.cStr2Do),2) = 1
            m.cStr2Do = TRIM(m.cStr2Do) + ' '
        ENDIF

        * Add a leading and trailing space
        m.cStr2Do = ' ' + m.cStr2Do + ' '
        m.nStrLen = LEN(m.cStr2Do)

        * Swap characters as follows:
        *       1 --> 10
        *       2 --> 8
        *       3 --> 6
        *       4 --> 4
        *       5 --> 2
        *       6 --> 9
        *       7 --> 7
        *       8 --> 5
        *       9 --> 3
        *      10 --> 1
        * Do the EVEN chars first
        m.cEven = ''
        FOR m.x = m.nStrLen TO 2 STEP -2
            m.cEven = m.cEven + SUBSTR(m.cStr2Do, m.x, 1)
        ENDFOR

        * Do the ODD chars next
        m.cOdd = ''
        FOR m.x = m.nStrLen-1 TO 1 STEP -2
            m.cOdd = m.cOdd + SUBSTR(m.cStr2Do, m.x, 1)
        ENDFOR
        m.cSwapped = m.cEven + m.cOdd

        * Now, XOR each character with 0FFh
        m.cEncrypt = ''
        FOR m.nW = 1 TO LEN(m.cStr2Do)
            m.nChar = ASC(SUBSTR(m.cSwapped, m.nW, 1))
            m.nXform = BITXOR(m.nChar, 255)
            m.cEncrypt = m.cEncrypt + CHR(m.nXForm)
        ENDFOR

        * Done
        RETURN m.cEncrypt
    ENDFUNC

    *- DecryptIt() - Decrypt a string that was encrypted with EncryptIt()
    *     Input: cStrIn - URL String to be decrypted
    *      Retn: Decrypted string
    FUNCTION DecryptIt(cCoded)
        LOCAL cDecrypt, nW, nChar, nXform, cUnSwapped

        * Each character was XORed.  XOR again to get the original
        m.cDecrypt = ''
        FOR m.nW = 1 TO LEN(m.cCoded)
            m.nChar = ASC(SUBSTR(m.cCoded, m.nW, 1))
            m.nXform = BITXOR(m.nChar, 255)
            m.cDecrypt = m.cDecrypt + CHR(m.nXForm)
        ENDFOR

        * Swap characters as follows:
        *  RAND 1 --> 10
        *       2 --> 8
        *       3 --> 6
        *       4 --> 4
        *       5 --> 2
        *       6 --> 9
        *       7 --> 7
        *       8 --> 5
        *       9 --> 3
        *      10 --> 1
        m.cUnSwapped = ''
        DO WHILE NOT EMPTY(m.cDecrypt)

            * Get the first and middle characters
            m.nLen = LEN(m.cDecrypt)
            m.cEvenChar = LEFT(m.cDecrypt, 1)
            m.nAdjLen = LEN(m.cDecrypt) / 2
            m.cOddChar = SUBSTR(m.cDecrypt, m.nAdjLen+1, 1)

            * Now loose them
            m.cDecrypt = LEFT(m.cDecrypt, m.nAdjLen) + SUBSTR(m.cDecrypt,m.nAdjLen+2)
            m.cDecrypt = SUBSTR(m.cDecrypt,2)

            * Add to the string
            m.cUnSwapped = m.cOddChar + m.cEvenChar + m.cUnSwapped
        ENDDO
        m.cUnSwapped = SUBSTR(m.cUnSwapped, 2, LEN(m.cUnSwapped)-2)

        * Done
        RETURN ALLTRIM(m.cUnSwapped)
    ENDFUNC

    *- EncodeURL() - Encode a string in an HTML FORM's GET METHOD format
    *     Input: cStrIn - String to be URL encoded
    *      Retn: Encoded string
    FUNCTION EncodeURL(cLonger)
        LOCAL cEncoded, nChkLen, nX, cChar

        * Simple HTML forms usually pass their entry variables in one line
        * appended to the URL.  Example:
        *   http://www.adssoftware.com?User=Ken+Green&Addr=123+Elm+St.%0A%0DChino+Hills
        * This is called URL encoding.  This must be on one line without
        *   spaces, the spaces must be converted to the "+" character.  Other
        *   characters that aren't digits or alphabetic characters are
        *   converted into their hexadecimal equivalent with a format of: %hh,
        *   where h=hex char.
        * By definition, the string cannot already contain "+" or "%"

        * Check each character
        m.cEncoded = ''
        m.nChkLen = LEN(m.cLonger)
        FOR m.nX = 1 TO m.nChkLen
            m.cChar = SUBSTR(m.cLonger, m.nX, 1)
            DO CASE
            CASE m.cChar = ' '
                m.cEncoded = m.cEncoded + '+'
            CASE UPPER(m.cChar) $ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                m.cEncoded = m.cEncoded + m.cChar
            OTHERWISE

                * Convert this to its hex equivalent using TRANSFORM(@0).  But,
                *   that gets us something like: 0x000000hh, so we'll just use
                *   the last 2 digits
                m.cChar = RIGHT(TRANSFORM(ASC(m.cChar), "@0"), 2)
                m.cEncoded = m.cEncoded + '%' + m.cChar
            ENDCASE
        ENDFOR

        * Done
        RETURN m.cEncoded
    ENDFUNC

    *- DecodeURL() - Decode a string in an HTML FORM's GET METHOD format
    *     Input: cStrIn - URL String to be decoded
    *      Retn: Decoded string
    FUNCTION DecodeURL(cLonger)
        LOCAL cStr2Do, cDecoded, nX, cChar1, cChar2

        * Simple HTML forms usually pass their entry variables in one line
        *   appended to the URL.  Example:
        *       http://www.adssoftware.com?User=Ken+Green&Address=15171+Rolling+Ridge+Dr.%0A%0DChino+Hills
        * This is called URL encoding.  This is on one line; any spaces have
        *   been converted to the "+" character.  Other characters that aren't
        *   digits or alphabetic characters were converted into their
        *   hexadecimal equivalent with a format of: %hh, where h=hex char.
        * By definition, the string could not have contained "+" or "%"

        * So, first we'll convert the + signs into spaces
        m.cStr2Do = STRTRAN(m.cLonger, "+", " ")

        * Now, we have to convert all hex encoded characters formatted as %hh
        m.cDecoded = ''
        DO WHILE NOT EMPTY(m.cStr2Do)

            * Look for the next %
            m.nX = AT('%', m.cStr2Do)

            * We're done if there aren't any
            IF m.nX = 0 OR m.nX + 2 > LEN(m.cStr2Do) OR ' ' $ SUBSTR(m.cStr2Do, m.nX, 3)
                m.cDecoded = m.cDecoded + m.cStr2Do
                m.cStr2Do = ''
                EXIT
            ENDIF

            * Put everything up to % into our output
            IF m.nX > 1
                m.cDecoded = m.cDecoded + LEFT(m.cStr2Do, m.nX-1)
                m.cStr2Do = SUBSTR(m.cStr2Do, m.nX)
            ENDIF

            * The next 2 characters must be hex digits
            m.cChar1 = SUBSTR(m.cStr2Do, 2, 1)
            m.cChar2 = SUBSTR(m.cStr2Do, 3, 1)

            * If this is a hex character, do the conversion
            IF m.cChar1 $ '0123456789ABCDEF' AND m.cChar2 $ '0123456789ABCDEF'

                * VFP's format for hex numbers is: 0x000000hh
                m.cChar = SUBSTR(m.cStr2Do, 2, 2)
                m.cChar = CHR(EVALUATE("0x" + m.cChar))
                m.cDecoded = m.cDecoded + m.cChar

                * Extract these characters from cStr2Do
                IF LEN(m.cStr2Do) = 3
                    m.cStr2Do = ''
                ELSE
                    m.cStr2Do = SUBSTR(m.cStr2Do, 4)
                ENDIF
            ELSE

                * Just move the % sign to the output string
                m.cDecoded = m.cDecoded + '%'
                m.cStr2Do = SUBSTR(m.cStr2Do, 2)
            ENDIF
        ENDDO

        * Done
        RETURN m.cDecoded
    ENDFUNC

    *- Base64Encode() - Convert the passed string by BASE64 encoding
    *     Input: cStr - String to be BASE64 encoded
    *      Retn: Encoded string
    FUNCTION Base64Encode(cStr as String)
        LOCAL i, j, k, q, ch, s2, buf, basechars

        * Define the index character set
        m.basechars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' + ;
          '0123456789+/'
        m.buf = 0
        m.s2 = ''
        m.j = 0
        m.k = LEN(m.cStr)
        FOR m.i = 1 TO m.k
            m.ch = ASC(SUBSTR(m.cStr,m.i,1))
            m.q = (BITAND(BITRSHIFT(m.ch,6),3)) + ;
              BITLSHIFT(BITAND(BITRSHIFT(m.ch,4),3),2) + ;
               BITLSHIFT(BITAND(BITRSHIFT(m.ch,2),3),4) + ;
               BITLSHIFT(BITAND(m.ch,3),6)
            m.buf = BITOR(BITLSHIFT(m.q,m.j),m.buf)
            m.j = m.j + 8
            DO WHILE (m.j >= 6) OR ((m.i = m.k) AND (m.j > 0))
                m.q = 1 + BITLSHIFT(BITAND(m.buf,3),4) + ;
                  BITLSHIFT(BITAND(BITRSHIFT(m.buf,2),3),2) + ;
                  (BITAND(BITRSHIFT(m.buf,4),3))
                m.ch = SUBSTR(m.basechars,m.q,1)
                m.s2 = m.s2 + m.ch
                m.buf = BITRSHIFT(m.buf,6)
                m.j = m.j - 6
            ENDDO
        ENDFOR
        m.s2 = m.s2 + IIF(LEN(m.s2) % 4 > 0, REPLICATE('=', 4 - (LEN(m.s2) % 4)), '')
        RETURN m.s2
    ENDFUNC

    *- Base64Decode() - Decode the passed BASE64 string
    *     Input: cStr - String to be BASE64 decoded
    *      Retn: Decoded string
    FUNCTION Base64Decode(cStr as String)
        LOCAL i, j, j, k, q, ch, s2, buf, tmpc
        m.tmpc = 0
        m.j = 0
        m.buf = 0
        m.s2 = ''
        m.k = LEN(m.cStr)
        FOR m.i = 1 TO m.k
            m.ch = ASC(SUBSTR(m.cStr,m.i,1))
            m.q = IIF((m.ch >= 97 AND m.ch <=122),25+m.ch-96,IIF((m.ch >= 65 AND m.ch <=90),m.ch-65,;
                IIF((m.ch >= 48 AND m.ch <=57),m.ch+4,IIF(m.ch = 47,63,IIF(m.ch = 43,62,-1)))))
            IF m.q < 0 THEN
                RETURN IIF(m.ch = 61,m.s2,'')
            ENDIF
            m.buf = BITOR(BITLSHIFT(m.buf,6),m.q)
            m.j = m.j + 6
            IF m.j >= 8 THEN
                m.j = m.j - 8
                m.tmpc = CHR(BITAND(BITRSHIFT(m.buf,m.j),255))
                m.buf = BITAND(m.buf,BITLSHIFT(1,m.j) -1)
                m.s2 = m.s2 + m.tmpc
            ENDIF
        ENDFOR
        RETURN m.s2
    ENDFUNC


        ***** PICTURE Methods *****

    *- ClearPict() - Remove all except characters and digits from passed string
    *     Input: cTheVar - Passed PICTURE string
    *            bKeepSpcs - (optional) .T. if you want to keep spaces
    *      Retn: String with non-formatting chars removed
    FUNCTION ClearPict(cStrIn, bKeepSpcs)
        LOCAL cGoodChars, cStrIn, nLenIn, cRetStr, nX, cThisChar

        * Define the allowable characters
        m.cGoodChars = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ' + ;
          IIF(m.bKeepSpcs, ' ', '')

        * Copy only characters, digits, and (optionally) spaces into our return
        *   string
        m.cStrIn = m.cStrIn
        m.nLenIn = LEN(m.cStrIn)
        m.cRetStr = ''
        FOR m.nX = 1 TO m.nLenIn
            m.cThisChr = SUBSTR(m.cStrIn, m.nX, 1)

            * Skip the characters we want to remove
            IF UPPER(m.cThisCHR) $ m.cGoodChars
                m.cRetStr = m.cRetStr + m.cThisChr
            ENDIF
        ENDFOR
        RETURN m.cRetStr
    ENDFUNC

    *- GetPicChrs() - Return the text substitute chars in a "PICTURE" string
    *     Input: cPictStr - Passed PICTURE string
    *      Retn: String with non-formatting chars removed
    FUNCTION GetPicChrs(cPictStr)
        LOCAL cPicFmtChrs, cRetStr, nStrLen, nI, cChar

        * We want to return a string of the non-formatting picture characters
        m.cPicFmtChrs = THIS.cPictFormatChrs
        m.cRetStr = ''
        m.nStrLen = LEN(m.cPictStr)
        FOR m.nI = 1 TO m.nStrLen
            m.cChar = SUBSTR(m.cPictStr, m.nI, 1)

            * Picture characters come in 2 flavors:
            *   -,.       = textual substitutions
            *   @ANXY9#!$ = format directive characters
            * Non-formatting picture characters are the textual substitution
            *   characters and any other non format directive characters.  Of
            *   course, we don't want to return spaces either
            IF NOT m.cChar $ m.cPicFmtChrs
                m.cRetStr = m.cRetStr + m.cChar
            ENDIF
        ENDFOR
        RETURN m.cRetStr
    ENDFUNC

    *- TrimPict() - Remove trailing picture characters from the passed string
    *     Input: cTheVar - Passed string
    *      Retn: String with trailing -,./\s removed
    *     Note: Commonly used to clean up HTML GET field responses
    FUNCTION TrimPict(cTheVar)
        LOCAL cPicChrs, cRetVar, nX

        * Define the picture characters we want to remove.  Picture characters
        *   come as either format directives (@R, etc.) or:
        *       -,./\     = textual substitutions
        * We want to remove the textual substitution characters
        m.cPicChrs = THIS.cPictTextChrs
        m.cRetVar = m.cTheVar
        IF RIGHT(TRIM(m.cRetVar), 1) $ m.cPicChrs
            DO WHILE RIGHT(TRIM(m.cRetVar), 1) $ m.cPicChrs
                m.nX = LEN(TRIM(m.cRetVar))        && Point to the character
                m.cRetVar = STUFF(m.cRetVar, m.nX, 1, ' ')
            ENDDO
        ENDIF

        * Done
        RETURN m.cRetVar
    ENDFUNC

    * RemoveOddHexChars() - Remove hex characters 0h-31h, 255h except LF, CR, FF
    *     Input: cMemoIn - Memo string to be cleaned up
    *            bKillFF - Also remove the Form-Feed character (12h)
    FUNCTION RemoveOddHexChars(cMemoIn, bKillFF)
        LOCAL cMemo, nX

        * Take out the special chars (DEC 1-31). VFP can't find 0h
        m.cMemo = m.cMemoIn
        FOR m.nX = 0 TO 31

            * Leave 10 (LF), 13 (CR) and 12 (FF) there
            IF m.nX = 10 OR m.nX = 13 OR (m.nX = 12 AND NOT m.bKillFF)
                LOOP
            ENDIF

            * Do the comparing first
            IF CHR(m.nX) $ m.cMemo
                m.cMemo = STRTRAN(m.cMemo, CHR(m.nX), '')
            ENDIF
        ENDFOR

        * Also toss FFh character
        IF HEX_FF $ m.cMemo
            m.cMemo = STRTRAN(m.cMemo, HEX_FF, '')
        ENDIF

        * Done
        RETURN m.cMemo
    ENDFUNC

    * RemoveSpecChar() - Remove all hex characters 0h-31h but 10h, 12h and 13h
    FUNCTION RemoveSpecChar(cMemoIn)
        RETURN THIS.RemoveOddHexChars(m.cMemoIn)
    ENDFUNC


        ***** Type Conversions *****

    *- CharToX() - Convert a string to a variable of the passed type
    *     Input: cStrIn - String that may have embedded quotes
    *            cType - Type of conversion desired
    *      Retn: Desired value
    FUNCTION CharToX(cStrIn, cType)
        LOCAL xRetVal, cSep, nMon, nDay, nYear, nPosn

        * Did we goof?
        IF NOT (PCOUNT() = 2 AND TYPE('cStrIn') = 'C' AND ;
          TYPE('cType') = 'C' AND LEN(m.cType) = 1)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Assume this is Character, Memo, or General (no conversion)
        m.xRetVal = m.cStrIn

        * Handle special conversions based on type
        DO CASE

        * Numeric, Currency
        CASE m.cType $ 'NY'
            RETURN THIS.PostVal(m.cStrIn)

        * Logical
        CASE m.cType = 'L'
            RETURN (m.cStrIn = 'Y' OR m.cStrIn = '.T.')

        * Date
        CASE m.cType = 'D'
            DO CASE
            CASE '-' $ m.cStrIn OR '/' $ m.cStrIn

                * This could be formatted as: YYYY/MM/DD or YYYY-MM-DD
                *   or MM/DD/YYYY or MM-DD-YYYY
                m.cSep = IIF('-' $ m.cStrIn, '-', '/')
                IF AT(m.cSep, m.cStrIn) = 3     && MM.DD.YYYY form
                    m.nMon = INT(VAL( LEFT(m.cStrIn, 2)))
                    m.nDay = INT(VAL( SUBSTR(m.cStrIn, 4, 2)))
                    m.nYear = INT(VAL( RIGHT(m.cStrIn, 4)))
                ELSE    && YYYY.MM.DD form
                    m.nYear = INT(VAL( LEFT(m.cStrIn, 4)))
                    m.nDay = INT(VAL( RIGHT(m.cStrIn, 2)))
                    m.nMon = INT(VAL( SUBSTR(m.cStrIn, 6, 2)))
                ENDIF
                RETURN DATE(m.nYear, m.nMon, m.nDay)
            CASE ' ' $ m.cStrIn AND NOT ' ' $ LEFT(m.cStrIn,4)  && YYYY Mon DD
                m.nYear = INT(VAL( LEFT(m.cStrIn, 4)))
                m.nDay = INT(VAL( SUBSTR(m.cStrIn, 10, 2)))
                m.nPosn = AT(SUBSTR(m.cStrIn, 6, 3), ;
                  'JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC')
                m.nMon = INT((m.nPosn / 4)) + 1
                RETURN DATE(m.nYear, m.nMon, m.nDay)
            OTHERWISE       && [YY]YYMMDD
                IF LEN(m.cStrIn) = 6
                    m.nYear = INT(VAL( LEFT(m.cStrIn, 2)))
                    IF m.nYear > 30
                        m.nYear = 2000 + m.nYear
                    ELSE
                        m.nYear = 1900 + m.nYear
                    ENDIF
                ELSE
                    m.nYear = INT(VAL( LEFT(m.cStrIn, 4)))
                ENDIF
                m.cStrIn = RIGHT(m.cStrIn, 4)
                m.nMon = INT(VAL( LEFT(m.cStrIn, 2)))
                m.nDay = INT(VAL( RIGHT(m.cStrIn, 2)))
                RETURN DATE(m.nYear, m.nMon, m.nDay)
            ENDCASE

        * DateTime
        CASE m.cType = 'T'
            RETURN goDates.C1ToT(m.cStrIn)
        ENDCASE

        * Return our value if we haven't done so already
        RETURN m.xRetVal
    ENDFUNC

    *- XToChar() - Convert any value into a string
    *     Input: xValue - Value to be converted
    *      Retn: String after conversion
    FUNCTION XToChar(xValue)
        LOCAL cOldSet, cRetVal

        * Did we goof?
        IF NOT PCOUNT() = 1
            ERROR 'Invalid parameters were passed'
        ENDIF

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
            m.cRetVal = ALLTRIM(TRANSFORM(m.xValue, ""))

            * Strip any trailing 0s and .s from fractions
            DO WHILE '.' $ m.cRetVal AND RIGHT(m.cRetVal, 1) $ '0.'
                m.cRetVal = LEFT(m.cRetVal, LEN(m.cRetVal)-1)
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
            RETURN ALLTRIM(TRANSFORM(m.xValue, ""))
        ENDCASE
    ENDFUNC

    *- EscapeXML() - Escape special XML characters
    *     Input: cStrIn - String for XML to be checked
    *      Retn: String with special XML characters escaped
    FUNCTION EscapeXML(cStrIn)
        LOCAL cStrOut

        * XML escape characters; there are only five:
        *     "   &quot;
        *     '   &apos;
        *     <   &lt;
        *     >   &gt;
        *     &   &amp; don't let this end with ";" or cStrOut won't exist
        m.cStrOut = m.cStrIn

        * & must go first else it will change all others
        IF [&] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [&], [&amp;])
        ENDIF
        IF ["] $ cStrOut
            cStrOut = STRTRAN(cStrOut, ["], [&quot;])
        ENDIF
        IF ['] $ cStrOut
            cStrOut = STRTRAN(cStrOut, ['], [&apos;])
        ENDIF
        IF [<] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [<], [&lt;])
        ENDIF
        IF [>] $ m.cStrOut
            m.cStrOut = STRTRAN(m.cStrOut, [>], [&gt;])
        ENDIF

        * Done
        RETURN m.cStrOut
    ENDFUNC

    *- GetDurationStr() - Return a human readable time string
    *     Input: xSeconds - Number of elapsed seconds
    *      Retn: ww days, xx hrs, yy mins and zz secs
    *      Note: The leading items won't be shown if they're 0
    FUNCTION GetDurationStr(nNumSecs)
        LOCAL cTimeStr, nDays, nHrs, nMins, nSecs, cNewStr

        * Convert the seconds to days, hours, minutes and seconds
        IF m.nNumSecs < 120
            m.cSecs = TRANSFORM(m.nNumSecs)
            DO WHILE RIGHT(m.cSecs, 1) = '0'
                m.cSecs = LEFT(m.cSecs, LEN(m.cSecs)-1)
            ENDDO
            IF RIGHT(m.cSecs, 1) = '.'
                m.cSecs = LEFT(m.cSecs, LEN(m.cSecs)-1)
            ENDIF
            m.cTimeStr = LTRIM(STR(m.nNumSecs)) + ' ' + ;
              THIS.Plural('sec', m.nNumSecs)
        ELSE
            m.nSecs = ROUNDOFF(m.nNumSecs, 0)
            m.nSecs = INT(m.nSecs)
            STORE 0 TO m.nDays, m.nHrs, m.nMins
            m.nHrs = INT(m.nSecs/3600)
            m.nSecs = m.nSecs - (m.nHrs * 3600)
            IF m.nHrs > 47
                m.nDays = INT(m.nHrs / 24)
                m.nHrs = m.nHrs - (m.nDays * 24)
            ENDIF
            m.nMins = INT(m.nSecs/60)
            m.nSecs = m.nSecs - (m.nMins * 60)
            m.cTimeStr = ''
            IF m.nDays > 0
                m.cTimeStr = LTRIM(STR(m.nDays)) + ' ' + THIS.Plural('day', m.nDays)
            ENDIF
            IF m.nHrs > 0 OR NOT EMPTY(m.cTimeStr)
                m.cNewStr = LTRIM(STR(m.nHrs)) + ' ' +  THIS.Plural('hr', m.nHrs)
                m.cTimeStr = THIS.AddToString(m.cTimeStr, m.cNewStr, ',')
            ENDIF
            IF m.nMins > 0 OR NOT EMPTY(m.cTimeStr)
                m.cNewStr = LTRIM(STR(m.nMins)) + ' ' + THIS.Plural('min', m.nMins)
                m.cTimeStr = THIS.AddToString(m.cTimeStr, m.cNewStr, ',')
            ENDIF
            m.cNewStr = LTRIM(STR(m.nSecs)) + ' ' + THIS.Plural('sec', m.nSecs)
            IF EMPTY(m.cTimeStr)
                m.cTimeStr = m.cNewStr
            ELSE
                m.cTimeStr = THIS.AddToString(m.cTimeStr, m.cNewStr, ' and')
            ENDIF
            m.cTimeStr = m.cTimeStr
        ENDIF
        RETURN m.cTimeStr
    ENDFUNC

    *- RoundOff() - Round off a number to x decimal places
    FUNCTION RoundOff(nNumVar, nDecPlcs)
        LOCAL nPower, nNumb, nDelta

        * Inputs:
        *   nNumVar  - The number to be rounded off
        *   nDecPlcs - The decimal places desired for the rounding. This
        *                   CANNOT BE NEGATIVE
        IF m.nDecPlcs < 0
            ERROR 'KStrings::RoundOff() cannot handle negative numbers'
        ENDIF

        * Note: This correctly handles negative numbers and halves (if previous
        *   digit is even, rounds up, else truncates).
        m.nPower = 10 ^ m.nDecPlcs
        m.nNumb = m.nNumVar * m.nPower

        * Delta is what we add to nNumb before taking the integer.  However, the
        *   special case of exactly half must be dealt with (round up if the next
        *   highest integer is even; round down if odd).  Then we have to make
        *   delta negative if we're dealing with a negative number.
        m.nDelta = IIF(MOD(m.nNumb,1) = 0.500000 AND ;
          MOD(INT(m.nNumb),2)=1, 0, 0.5) * IIF(m.nNumVar < 0, -1, 1)

        * Add the delta based on whether this is a negative number or not, take the
        *   integer, divide by the power, and return.
        RETURN INT(m.nNumb + m.nDelta) / m.nPower
    ENDFUNC

    *- RoundUp() - Round up a number it's hightest possible integer: 2.003 --> 3
    FUNCTION RoundUp(nNumVar)
        LOCAL nRet

        * Inputs:
        *   nNumVar  - The number to be rounded up, e.g. if anything's in the
        *       fraction, the integer is incremented.
        m.nRet = INT(m.nNumVar)
        IF m.nNumVar - m.nRet > 0
            m.nRet = m.nRet + 1
        ENDIF
        RETURN m.nRet
    ENDFUNC


        ***** String Incrementing *****

    *- IncrNumbPart() - Increment numbers within a string keeping any chars
    *       Base 10; no length change, will use spaces on right if needed.
    *     Input: cStrIn - String to be incremented
    *      Retn: Incremented String
    FUNCTION IncrNumbPart(cStrIn)
        LOCAL bFlushRt, nVarLen, cVarIn, cDigitStr, cCharStr, nX, cChar, ;
          nDigLen, nNewNumb, cRetStr, cTrailingChar

        * cStrIn has a character string composed of letters and digits; for
        *   example: "A2B109".  We have to increment the numeric part ("109)
        *   and return the result.
        * Have had a case where the number is "WFL7111RL"

        * The passed variable could be flush-right or flush-left.
        m.bFlushRt = (LEFT(m.cStrIn,1) = ' ')

        * And, we can't change the overall length
        m.nVarLen = LEN(m.cStrIn)

        * Check for a trailing alpha
        m.cVarIn = ALLTRIM(m.cStrIn)
        STORE '' TO m.cDigitStr, m.cCharStr, m.cTrailingChar
        FOR m.nX = LEN(m.cVarIn) TO 1 STEP -1
            m.cChar = SUBSTR(m.cVarIn, m.nX, 1)
            IF ISALPHA(m.cChar)
                m.cTrailingChar = m.cChar + m.cTrailingChar
            ELSE
                IF NOT EMPTY(m.cTrailingChar)
                    m.cVarIn = LEFT(m.cVarIn, m.nVarLen - LEN(m.cTrailingChar))
                ENDIF
                EXIT
            ENDIF
        ENDFOR

        * Trim the passed variable and put the trailing digits into cDigitStr
        *   and any alpha characters into cChars
        FOR m.nX = LEN(m.cVarIn) TO 1 STEP -1
            m.cChar = SUBSTR(m.cVarIn, m.nX, 1)
            IF m.cChar $ '1234567890'
                m.cDigitStr = m.cChar + m.cDigitStr
            ELSE
                m.cCharStr = LEFT(m.cVarIn, m.nX)
                EXIT
            ENDIF
        ENDFOR

        * Increment the digits part
        m.nDigLen = LEN(m.cDigitStr)
        m.nNewNumb = INT(VAL(m.cDigitStr)) + 1

        * Put 'em back in a string - but don't let it be shorter than the
        *   original string (longer is OK).
        m.cDigitStr = LTRIM(STR(m.nNewNumb))
        IF LEN(m.cDigitStr) < m.nDigLen
            m.cDigitStr = PADL(m.cDigitStr, m.nDigLen, '0')
        ENDIF

        * Add any characters from the original
        m.cRetStr = m.cCharStr + m.cDigitStr

        * Add back in the trailing alpha's
        IF NOT EMPTY(m.cTrailingChar)
            m.cRetStr = m.cRetStr + m.cTrailingChar
        ENDIF

        * Make the variable the correct length; but throw a bug if we can't
        *   make it longer
        DO CASE
        CASE LEN(m.cRetStr) < m.nVarLen
            IF m.bFlushRt
                m.cRetStr = PADL(m.cRetStr, m.nVarLen, ' ')
            ELSE
                m.cRetStr = PADR(m.cRetStr, m.nVarLen, ' ')
            ENDIF
        CASE LEN(m.cRetStr) <> m.nVarLen
            ERROR 'Variable too long in THIS.IncrNumbPart(' + m.cStrIn + ')'
        ENDCASE
        RETURN m.cRetStr
    ENDFUNC

    *- IncrNumeric() - Numerically increment a string and 0-fill on left
    *       Base 10; no length change, will 0-fill from left if needed.
    *     Input: cStrIn - String to be incremented
    *            nIncrAmt - (optional) desired incrementing amount (default = 1)
    *            cLeftFill - (optional) Other left filling character (default = '0')
    *      Retn: Incremented String
    FUNCTION IncrNumeric(cStrIn, nIncrAmt, cLeftFill)
        LOCAL nStrLen, cRetStr

        * Get the length
        m.nStrLen = LEN(m.cStrIn)

        * Check the parameters
        IF TYPE('nIncrAmt') <> 'N'
            m.nIncrAmt = 1
        ENDIF
        IF TYPE('cLeftFill') <> 'C'
            m.cLeftFill = [0]
        ENDIF

        * Get the value and increment it
        m.nNewVal = THIS.PostVal(m.cStrIn) + m.nIncrAmt

        * Note that if we overflow, we'll get a bug for the STR() conversion
        m.cRetStr = LTRIM(STR(m.nNewVal, m.nStrLen))
        RETURN PADL(m.cRetStr, m.nStrLen, m.cLeftFill)
    ENDFUNC

    *- IncrAlpha() - Alpha- or Alphanum- increment a string and zero-fill on left
    *       Base 26 (alpha) or 36 (alphanum); no length change, will 0 fill
    *       (alphanum) or space fill (alpha) from left if needed; ignores
    *       trailing spaces.
    *     Input: cStrIn - String to be incremented
    *            bAlphaOnly - (optional) .T. if base 26 incrementing is wanted
    *                           default = .F.
    *      Retn: Incremented String
    FUNCTION IncrAlpha(cStrIn, bAlphaOnly)
        LOCAL cIncrOrder, cRetStr, nX, cThisChar, nY

        * If the string is empty, return something like '00001'
        IF EMPTY(m.cStrIn)
            IF LEN(m.cStrIn) < 2
                IF m.bAlphaOnly
                    RETURN 'A'
                ELSE
                    RETURN '1'
                ENDIF
            ENDIF
            IF m.bAlphaOnly
                RETURN REPLICATE(' ', LEN(m.cStrIn) - 1) + 'A'
            ELSE
                RETURN REPLICATE('0', LEN(m.cStrIn) - 1) + '1'
            ENDIF
        ENDIF

        * Here, we want to alpha-numerically increment the passed string.
        *   Increment is based on the following letter order:
        IF m.bAlphaOnly           && Used to increment Revision letters, etc.
            m.cIncrOrder = " ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        ELSE
            m.cIncrOrder = " 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        ENDIF

        * Setup our return string
        m.cRetStr = m.cStrIn

        * We won't touch trailing spaces
        m.nX = LEN(TRIM(m.cRetStr))

        * As the string is not empty, increment the characters
        DO WHILE m.nX > 0
            m.cThisChar = SUBSTR(m.cRetStr, m.nX, 1)
            m.nY = AT(m.cThisChar, m.cIncrOrder)

            * Handle all possible conditions
            DO CASE

            * Unknown character - leave it alone
            CASE m.nY = 0
                m.nX = m.nX - 1     && Go increment the previous character

            * If it's at the end, substitute the first character, but keep going
            *   to handle a "carry"
            CASE m.cThisChar = RIGHT(m.cIncrOrder, 1)

                * Our increment string has the first character as a space, but
                *   that's only for incrementing spaces; skip that and use the
                *   next character
                m.cRetStr = STUFF(m.cRetStr, m.nX, 1, SUBSTR(m.cIncrOrder, 2, 1))
                m.nX = m.nX - 1     && Go increment the previous character

            * Otherwise, the character is in our string and incrementable
            OTHERWISE
                m.cRetStr = STUFF(m.cRetStr, m.nX, 1, SUBSTR(m.cIncrOrder, m.nY+1, 1))
                EXIT
            ENDCASE
        ENDDO
        RETURN m.cRetStr
    ENDFUNC

    *- IncrFLStr() - Alphanum- or numerically-increment a flush left string
    *       Base 36 (alphanum) or 10 (numeric); no length change but spaces on
    *       the right may be used if needed, no other fills.
    *     Input: cStrIn - String to be incremented
    *            cIncrType - (optional) Increment type:
    *                           'A' - alphanumeric incrementing (base 36)
    *                           '1' - numeric incrementing (base 10)
    *                       default is to do an alphanumeric increment if the
    *                       passed string has any characters, else to do a
    *                       numeric increment.
    *      Retn: Incremented Trimmed String
    FUNCTION IncrFLStr(cStrIn, cIncrType)
        LOCAL nStrLen, cTrimStr, nTrimLen, bAlpha, nY

        * Our incoming string is flush left (e.g. "11   ") it is to be
        *   incremented and, new digits added to the RIGHT(.

        * We have 2 modes of incrementing:
        *   Numerically (e.g. add 1 to the VALue of the string)
        *   Alphabetically (e.g. add 1 to a base-36 number consisting of:
        *       01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ)
        * The default behavior is to look in the passed string for an
        *   alphabetic character; if found we do an alpha increment, otherwise
        *   we do a decimal increment.
        * But, cIncrType is for overriding that default behavior.  If
        *   cIncrType is passed, we'll look thru that string to decide how to
        *   increment.  For example:
        *       If cIncrType = 'A', we'll increment alphabetically
        *       If cIncrType = '1', we'll increment numerically

        * If the string is empty, return '1'
        IF EMPTY(m.cStrIn)
            IF LEN(m.cStrIn) < 2
                RETURN '1'
            ENDIF
        ENDIF

        * Define the length of the string and the length of the trimmed string
        m.nStrLen = LEN(m.cStrIn)
        m.cTrimStr = TRIM(m.cStrIn)
        m.nTrimLen = MIN(m.nStrLen, LEN(TRIM(m.cTrimStr)))

        * Do we have any alphabetic characters in the string?
        m.bAlpha = .F.
        IF TYPE('cIncrType') = 'C' AND NOT EMPTY(m.cIncrType)
            m.bAlpha = ISALPHA(LEFT(m.cIncrType, 1))
        ELSE
            FOR m.nY = 1 TO m.nTrimLen
                IF ISALPHA(SUBSTR(m.cTrimStr,m.nY,1))
                    m.bAlpha = .T.
                    EXIT
                ENDIF
            ENDFOR
        ENDIF

        * Now, we'll call the appropriate INCR function with the TRIMMED string
        *   after testing for overflow
        IF m.bAlpha
            IF m.cTrimStr = REPLICATE('Z', m.nTrimLen)
                m.cTrimStr = ' ' + m.cTrimStr
                m.nTrimLen = m.nTrimLen + 1
                IF m.nTrimLen > m.nStrLen
                    m.nStrLen = m.nTrimLen
                ENDIF
            ENDIF
            m.cTrimStr = THIS.IncrAlpha(m.cTrimStr)
        ELSE
            IF m.cTrimStr = REPLICATE('9', m.nTrimLen)
                m.cTrimStr = ' ' + m.cTrimStr
                m.nTrimLen = m.nTrimLen + 1
                IF m.nTrimLen > m.nStrLen
                    m.nStrLen = m.nTrimLen
                ENDIF
            ENDIF
            m.cTrimStr = THIS.IncrNumeric(m.cTrimStr)
        ENDIF

        * Now, make sure the string is the correct length
        RETURN m.cTrimStr + SPACE(m.nStrLen - m.nTrimLen)
    ENDFUNC

    *- IncrFRStr() - Alphanum- or numerically-increment a flush right string
    *       Base 36 (alphanum) or 10 (numeric); no length change but spaces on
    *       the left may be used if needed, no other fills.
    *     Input: cStrIn - String to be incremented
    *            cIncrType - (optional) Increment type:
    *                           'A' - alphanumeric incrementing (base 36)
    *                           '1' - numeric incrementing (base 10)
    *                       default is to do an alphanumeric increment if the
    *                       passed string has any characters, else to do a
    *                       numeric increment.
    *      Retn: Incremented Trimmed String
    FUNCTION IncrFRStr(cStrIn, cIncrType)
        LOCAL nStrLen, cRetStr

        * Our incoming string is flush right (e.g. "   11") it is to be
        *   incremented and, new digits added to the LEFT(.
        m.nStrLen = LEN(m.cStrIn)

        * We're going to call THIS.IncrFLStr but that expects a flush-left
        *   string; so give it that plus a space
        IF LEFT(m.cStrIn, 1) = ' '
            m.cRetStr = THIS.IncrFLStr(' ' + THIS.FlushLeft(m.cStrIn), m.cIncrType)
        ELSE
            m.cRetStr = THIS.IncrFLStr(m.cStrIn, m.cIncrType)
        ENDIF

        * Now, make it the right length
        IF LEN(m.cRetStr) <> m.nStrLen
            m.cRetStr = THIS.MakeLen(m.cRetStr, m.nStrLen)
        ENDIF

        * Return the string flush right
        RETURN THIS.FlushRight(m.cRetStr)
    ENDFUNC


        ***** Multiple Option Strings *****

    *- GetNextOption() - Extract the next Name:Value pair from an option string
    *     Input: cOptStr - String of options containing Name=Value pairs like:
    *                       "Name1=Value1^Name2=Value2^Name3=Value3^..."
    *            cValue - The option's value (passed as @cValue; default = '')
    *            cNameSep - (optional) char separating Name and Value (default = ':')
    *            cOptionSep - (optional) char separating Options (default = '~')
    *      Retn: The Name of the option; cValue is filled in
    FUNCTION GetNextOption(cOptStr, cValue, cNameSep, cOptionSep)
        LOCAL cNameSep, cOptionSep, cThisOpt, cOptName

        * Define our separator characters and override them as needed
        m.cNameSep = EVL(m.cNameSep, ':')
        m.cOptionSep = EVL(m.cOptionSep, '~')

        * Get the next option
        m.cThisOpt = THIS.ExtrToken(@m.cOptStr, m.cOptionSep)

        * Separate the option's Name and Value
        m.cOptName = ALLTRIM(THIS.ExtrToken(@m.cThisOpt, m.cNameSep))

        * Set the return value
        m.cValue = ALLTRIM(m.cThisOpt)

        * Done, return the name
        RETURN m.cOptName
    ENDFUNC


        ***** Combining Strings *****

    *- SetCityStateZip() - Return City, State, Zip combined
    *     Input: cCity - The city in question
    *            cState - The state
    *            cZip - The Zip code
    * Retn: [City, State  Zip]
    FUNCTION SetCityStateZip(cCity, cState, cZip)
        LOCAL cRetStr

        * Define our default
        m.cRetStr = ''

        * Put in the City (if we have it)
        IF VARTYPE(m.cCity) = 'C' AND NOT EMPTY(m.cCity)
            m.cRetStr = ALLTRIM(m.cCity)
        ENDIF

        * Add the state and a comma
        IF VARTYPE(m.cState) = 'C' AND NOT EMPTY(m.cState)
            m.cRetStr = IIF(EMPTY(m.cRetStr), '', m.cRetStr + [, ]) + ALLTRIM(m.cState)
        ENDIF

        * Finally, the Zip Code prefaced by 2 spaces
        IF VARTYPE(m.cZip) = 'C' AND NOT EMPTY(m.cZip)
            m.cOurZip = THIS.TrimPict(ALLTRIM(m.cZip))
            IF LEN(m.cOurZip) > 5
                m.cOurZip = TRANSFORM(m.cOurZip, '@R 99999-9999')
            ENDIF
            m.cRetStr = IIF(EMPTY(m.cRetStr), '', m.cRetStr + [  ]) + m.cOurZip
        ENDIF

        * Done, return the string
        RETURN m.cRetStr
    ENDFUNC

    *- AddToString() - Add string to another with separator if neither is empty
    *     Input: cStr1 - The starting string
    *            cStr2 - The string to be added
    *            cSep - The separator (, ; and so forth)
    *     Retn: If neither string is empty: cStr1 + cSep + ' ' + cStr2
    *           If either string is empty, it's just the non-empty string
    FUNCTION AddToString(cStr1, cStr2, cSep)
        LOCAL cRetStr

        * There are only 3 possibilities
        DO CASE
        CASE EMPTY(m.cStr2)
            m.cRetStr = m.cStr1
        CASE EMPTY(m.cStr1)
            m.cRetStr = m.cStr2
        OTHERWISE
            m.cRetStr = m.cStr1 + m.cSep + ' ' + m.cStr2
        ENDCASE
        RETURN m.cRetStr
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
        CASE NOT EMPTY(ON('ERROR'))
            m.cHndlCmd = UPPER(ON('ERROR'))
            m.cHndlCmd = STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(m.cHndlCmd, ;
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

    *- Release() - Releases a FormSet or Form from memory.
    PROCEDURE Release
        RELEASE THIS
    ENDPROC
ENDDEFINE

* CTypeNumber Class Definition for Currency numbers
DEFINE CLASS CTypeNumber AS KNumbers

    * Standard Properties
    Name = 'CTypeNumber'

    * Special Properties
    cFormatLtr = 'C'        && Our format letter
    nPrecision = 2          && Default precision
    nRounded = 0            && RoundOff(.nAbsNumb) (CFGN, non bIsExp only)

    * Method List
    *- Init() - Set ourselves up
    *- ToString() - Convert our number to a string and return it

    * Method Code

    *- Init() - Set ourselves up
    FUNCTION Init(cFormatLtr, nNumber, nPrec)
        LOCAL cSimple, nPosn
        IF PCOUNT() = 3
            THIS.nPrecision = nPrec
        ENDIF
        IF NOT DODEFAULT(cFormatLtr, nNumber)
            RETURN .F.
        ENDIF
        THIS.nRounded = THIS.Roundoff(THIS.nAbsNumb, THIS.nPrecision)

        * Our "simple" TRANSFORM() can look "$     235.11"
        cSimple = ALLTRIM( STRTRAN(THIS.cSimple, '$', '') )

        * Now, this can look like "235.110000000"
        nPosn = AT('.', cSimple)
        THIS.cSimple = LEFT(cSimple, nPosn + THIS.nPrecision)
        THIS.ParseDigits()
        RETURN .T.
    ENDFUNC

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()
        LOCAL cFormatStr, cStr

        * Currency: "Cx" or "cx"; Precision = decimals, Examples:
        *   123.456 ("C") --> $123.46
        *   -123.456 ("C3") --> ($123.456)

        * Here, negative numbers use parentheses - not minus signs
        cFormatStr = [@( $] + THIS.GetNumbFmtwCommas(.F., .F., .T.)
        IF THIS.bIsNeg
            THIS.nRounded = THIS.nRounded * (-1)
        ENDIF
        cStr = TRANSFORM(THIS.nRounded, cFormatStr)
        RETURN LTRIM(cStr)
    ENDFUNC
ENDDEFINE

* ITypeNumber Class Definition for Integer numbers
DEFINE CLASS ITypeNumber AS KNumbers

    * Standard Properties
    Name = 'ITypeNumber'

    * Special Properties
    cFormatLtr = 'I'        && Our format letter
    nPrecision = 0          && Default precision
    nRounded = 0            && RoundOff(.nAbsNumb) (CFGN, non bIsExp only)

    * Method List
    *- Init() - Set ourselves up
    *- ToString() - Convert our number to a string and return it

    * Method Code

    *- Init() - Set ourselves up
    FUNCTION Init(cFormatLtr, nNumber, nPrec)
        IF PCOUNT() = 3
            THIS.nPrecision = nPrec
        ENDIF
        IF NOT DODEFAULT(cFormatLtr, nNumber)
            RETURN .F.
        ENDIF

        * Make sure this is an integer
        THIS.nRounded = INT( THIS.Roundoff(THIS.nAbsNumb, 0) )
        THIS.cSimple  = ALLTRIM( TRANSFORM(THIS.nRounded) )
        THIS.ParseDigits()

        * Done
        RETURN .T.
    ENDFUNC

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()
        LOCAL cStr

        * Integer: "Ix" or "ix"; Precision = digits
        *   1234 ("I") -> 1234
        *   -1234 ("I6") -> -001234         mostly dumb
        cStr = THIS.cSimple
        IF THIS.nPrecision > 0 AND THIS.nPrecision > LEN(cStr)
            cStr = PADL(cStr, THIS.nPrecision, '0')
        ENDIF
        IF THIS.bIsNeg
            cStr = '-' + cStr
        ENDIF
        RETURN cStr
    ENDFUNC
ENDDEFINE

* ETypeNumber Class Definition for Exponential numbers
DEFINE CLASS ETypeNumber AS KNumbers

    * Standard Properties
    Name = 'ETypeNumber'

    * Special Properties
    cFormatLtr = 'E'        && Our format letter
    nPrecision = 6          && Default precision

    * Method List
    *- Init() - Set ourselves up
    *- ToString() - Convert our number to a string and return it

    * Method Code

    *- Init() - Set ourselves up
    FUNCTION Init(cFormatLtr, nNumber, nPrec)
        IF PCOUNT() = 3
            THIS.nPrecision = nPrec
        ENDIF
        IF NOT DODEFAULT(cFormatLtr, nNumber)
            RETURN .F.
        ENDIF

        * If thOURormat is 'E', but it's not in scientific notation, force it
        IF NOT THIS.bIsExp
            THIS.cSimple = ALLTRIM( TRANSFORM(THIS.nAbsNumb, '@^') )
            THIS.bIsExp = .T.
            THIS.LoadExponProps()
        ENDIF

        * Done
        RETURN .T.
    ENDFUNC

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()
        LOCAL nMantissa, cFormatStr, cStr

        * Exponential: "Ex" or "ex"; Precision = decimals, Examples:
        *   1052.0329112756 ("E") --> 1.052033E+003
        *   -1052.0329112756 ("e2") --> -1.05e+003

        * Make sure the mantissa is the right length
        nMantissa = VAL(THIS.cMant)
        nMantissa = THIS.RoundOff(nMantissa, THIS.nPrecision)
        cFormatStr = THIS.GetNumbFmtwCommas(nMantissa, .F., .F.)
        cStr = TRANSFORM(nMantissa, cFormatStr)
        cStr = cStr + 'E' + TRANSFORM( INT(THIS.nPower) )
        IF THIS.cFormatLtr = 'e'
            cStr = LOWER(cStr)
        ENDIF
        IF THIS.bIsNeg
            cStr = '-' + cStr
        ENDIF
        RETURN cStr
    ENDFUNC
ENDDEFINE

* FTypeNumber Class Definition for Fixed-point numbers
DEFINE CLASS FTypeNumber AS KNumbers

    * Standard Properties
    Name = 'FTypeNumber'

    * Special Properties
    cFormatLtr = 'F'        && Our format letter
    nPrecision = 6          && Default precision
    nRounded = 0            && RoundOff(.nAbsNumb) (CFGN, non bIsExp only)

    * Method List
    *- Init() - Set ourselves up
    *- ToString() - Convert our number to a string and return it

    * Method Code

    *- Init() - Set ourselves up
    FUNCTION Init(cFormatLtr, nNumber, nPrec)
        IF PCOUNT() = 3
            THIS.nPrecision = nPrec
        ENDIF
        IF NOT DODEFAULT(cFormatLtr, nNumber)
            RETURN .F.
        ENDIF
        THIS.nRounded = THIS.Roundoff(THIS.nAbsNumb, THIS.nPrecision)
        RETURN .T.
    ENDFUNC

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()
        LOCAL cFormatStr, cStr

        * Fixed-point: "Fx" or "fx"; Precision = decimals, Examples:
        *   1234.567 ("F") --> 1234.57
        *   1234 ("F1") --> 1234.0
        *   -1234.56 ("F4") --> -1234.5600
        cFormatStr = THIS.GetNumbFmtwCommas(.F., .F., .F.)
        cStr = TRANSFORM(THIS.nRounded, cFormatStr)
        IF THIS.bIsNeg
            cStr = '-' + cStr
        ENDIF
        RETURN cStr
    ENDFUNC
ENDDEFINE

* GTypeNumber Class Definition for General numbers
DEFINE CLASS GTypeNumber AS KNumbers

    * Standard Properties
    Name = 'GTypeNumber'

    * Special Properties
    cFormatLtr = 'G'        && Our format letter
    nPrecision = 9          && Default; here it's maximum significant digits
    nRounded = 0            && RoundOff(.nAbsNumb) (CFGN, non bIsExp only)

    * Method List
    *- Init() - Set ourselves up
    *- ToString() - Convert our number to a string and return it
    *- ConvertExpon() - Convert an exponential number to a string
    *- ConvertReal() - Convert a real number to a string

    * Method Code

    *- Init() - Set ourselves up
    FUNCTION Init(cFormatLtr, nNumber, nPrec)
        IF PCOUNT() = 3 AND BETWEEN(nPrec, 1, 9)
            THIS.nPrecision = nPrec
        ENDIF
        IF NOT DODEFAULT(cFormatLtr, nNumber)
            RETURN .F.
        ENDIF
        THIS.nRounded = THIS.Roundoff(THIS.nAbsNumb, THIS.nPrecision)
        RETURN .T.
    ENDFUNC

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()
        LOCAL cStr

        * General: "Gx" or "gx"; Precision = significant digits, Examples:
        *   -123.456 ("G") --> -123.456
        *   123.4546 ("G4") --> 123.5
        *   -1.234567890e-25 ("G") --> -1.23456789E-25
        DO CASE

        * This could be an exponential: -1.234567890e-25
        CASE 'E' $ UPPER(THIS.cSimple)
            cStr = THIS.ConvertExpon()

        * Or, it could be a real number: 123.4546
        CASE '.' $ UPPER(THIS.cSimple)
            cStr = THIS.ConvertReal()

        * But leave integers alone
        OTHERWISE
            cStr = THIS.cSimple
            IF THIS.bIsNeg
                cStr = '-' + cStr
            ENDIF
        ENDCASE
        RETURN cStr
    ENDFUNC

    *- ConvertExpon() - Convert an exponential number to a string
    FUNCTION ConvertExpon()
        LOCAL nPrec, nMultBy, nRounded, cMant, cRetStr

        *   -1.234567890e-25 ("G") --> -1.23456789E-25

        * Our precision is a maximum; meaning the number of significant digits
        *   That means the number of digits we show in the mantissa. To get
        *   that, we'll multiply the matissa by the precision -1 (only 1 number
        *   is whole in the mantissa), take the integer, make that a string and
        *   stuff the decimal point back in position 2.
        nPrec = THIS.nPrecision
        nMultBy = 10^(nPrec-1)
        nRounded = INT( THIS.Roundoff(VAL(THIS.cMant) * nMultBy, 0) )
        cMant = TRANSFORM(nRounded)
        cMant = STUFF(cMant, 2, 0, '.')

        * Now, construct our return string
        cRetStr = cMant + 'E' + TRANSFORM( INT(THIS.nPower) )
        IF THIS.cFormatLtr = 'g'
            cRetStr = LOWER(cRetStr)
        ENDIF
        IF THIS.bIsNeg
            cRetStr = '-' + cRetStr
        ENDIF
        RETURN cRetStr
    ENDFUNC

    *- ConvertReal() - Convert a real number to a string
    FUNCTION ConvertReal()
        LOCAL cConv, nPosn, cRetStr, nDec, nNumb2Do, cFormatStr

        *   -123.456 ("G") --> -123.456
        *   123.4546 ("G4") --> 123.5

        * Our precision is a maximum; meaning the number of significant digits

        * Where's the decimal point?
        cConv = THIS.cSimple
        nPosn = AT('.', cConv)

        * There are 3 possibilities:
        DO CASE

        *   Significant digits include all the integers
        CASE THIS.nPrecision = THIS.nWholes
            nNumb2Do = INT( THIS.Roundoff(THIS.nAbsNumb, 0) )
            cRetStr = TRANSFORM(nNumb2Do)

        *   Significant digits are within the integer zone
        CASE THIS.nPrecision < THIS.nWholes
            nDec = THIS.nPrecision - THIS.nWholes
            nNumb2Do = THIS.nAbsNumb * 10^(nDec)
            nNumb2Do = INT( THIS.Roundoff(nNumb2Do, 0) / 10^(nDec) )
            cFormatStr = REPLICATE('9', THIS.nWholes)
            cRetStr = TRANSFORM(nNumb2Do, cFormatStr)

        *   Sig. digits are within the decimal zone
        OTHERWISE
            nDec = THIS.nPrecision - nPosn + 1
            nNumb2Do = THIS.Roundoff(THIS.nAbsNumb, nDec)
            cFormatStr = THIS.GetNumbFmtwCommas(THIS.nWholes, nDec, .F.)
            cRetStr = TRANSFORM(nNumb2Do, cFormatStr)
        ENDCASE
        cRetStr = ALLTRIM(cRetStr)
        IF THIS.bIsNeg
            cRetStr = '-' + cRetStr
        ENDIF
        RETURN cRetStr
    ENDFUNC
ENDDEFINE

* NTypeNumber Class Definition for Plain ol' numbers (integer or decimal)
DEFINE CLASS NTypeNumber AS KNumbers

    * Standard Properties
    Name = 'NTypeNumber'

    * Special Properties
    cFormatLtr = 'N'        && Our format letter
    nPrecision = 2          && Default precision
    nRounded = 0            && RoundOff(.nAbsNumb) (CFGN, non bIsExp only)

    * Method List
    *- Init() - Set ourselves up
    *- ToString() - Convert our number to a string and return it

    * Method Code

    *- Init() - Set ourselves up
    FUNCTION Init(cFormatLtr, nNumber, nPrec)
        IF PCOUNT() = 3
            THIS.nPrecision = nPrec
        ENDIF
        IF NOT DODEFAULT(cFormatLtr, nNumber)
            RETURN .F.
        ENDIF
        THIS.nRounded = THIS.Roundoff(THIS.nAbsNumb, THIS.nPrecision)
        RETURN .T.
    ENDFUNC

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()
        LOCAL cFormatStr, cStr

        * Number: "Nx" or "nx"; Precision = decimal places, Examples:
        *   1234.567 ("N") --> 1,234.57
        *   1234 ("N1") --> 1,234.0
        *   -1234.56 ("N3") --> -1,234.560
        cFormatStr = THIS.GetNumbFmtwCommas(THIS.nWholes, THIS.nPrecision, .T.)
        cStr = TRANSFORM(THIS.nRounded, cFormatStr)
        IF THIS.bIsNeg
            cStr = '-' + cStr
        ENDIF
        RETURN cStr
    ENDFUNC
ENDDEFINE

* PTypeNumber Class Definition for Percentage numbers
DEFINE CLASS PTypeNumber AS KNumbers

    * Standard Properties
    Name = 'PTypeNumber'

    * Special Properties
    cFormatLtr = 'P'        && Our format letter
    nPrecision = 2          && Default precision

    * Method List
    *- Init() - Set ourselves up
    *- ToString() - Convert our number to a string and return it

    * Method Code

    *- Init() - Set ourselves up
    FUNCTION Init(cFormatLtr, nNumber, nPrec)
        IF PCOUNT() = 3
            THIS.nPrecision = nPrec
        ENDIF
        IF NOT DODEFAULT(cFormatLtr, nNumber)
            RETURN .F.
        ENDIF
        RETURN .T.
    ENDFUNC

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()
        LOCAL nNumb2Do, nWholes, cFormatStr, cStr

        * Percent: Px or px; Precision = decimal places, Examples:
        *   1 ("P") --> 100.00%
        *   -0.39678 ("P1") --> -39.7%

        * Notice that we have to multiply by 100 first
        nNumb2Do = THIS.Roundoff(THIS.nAbsNumb * 100, THIS.nPrecision)
        nWholes = THIS.nWholes + 2
        cFormatStr = THIS.GetNumbFmtwCommas(nWholes, THIS.nPrecision, .T.)
        cStr = ALLTRIM( TRANSFORM(nNumb2Do, cFormatStr)) + '%'
        IF THIS.bIsNeg
            cStr = '-' + cStr
        ENDIF
        RETURN cStr
    ENDFUNC
ENDDEFINE

* XTypeNumber Class Definition for Hexadecimal numbers
DEFINE CLASS XTypeNumber AS KNumbers

    * Standard Properties
    Name = 'XTypeNumber'

    * Special Properties
    cFormatLtr = 'X'        && Our format letter
    nPrecision = 0         && Default precision

    * Method List
    *- ToString() - Convert our number to a string and return it

    * Method Code

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()
        LOCAL cStr

        * Hexadecimal: Xy or xy; Precision = whole digits, Examples:
        *   255 ("X") -> FF
        *   255 ("x4") -> 00ff
        *   -1 ("X4") -> 00FF
        cStr = TRANSFORM( INT(THIS.nNumber), '@0')      && = 10 char string
        IF cStr = '0x'                                  && Toss for now
            cStr = SUBSTR(cStr,3)
        ENDIF

        * Toss leading 0s
        DO WHILE LEFT(cStr,1) = '0' AND LEN(cStr) > 1
            cStr = SUBSTR(cStr, 2)
        ENDDO

        * If our format letter is lowercase, make the result that also
        IF THIS.cFormatLtr = 'x'
            cStr = LOWER(cStr)
        ENDIF

        * Now, make it the right length
        DO CASE
        CASE LEN(cStr) < THIS.nPrecision
            cStr = PADL(cStr, THIS.nPrecision, '0')
        CASE LEN(cStr) > THIS.nPrecision AND THIS.nPrecision > 0
            cStr = RIGHT(cStr, THIS.nPrecision)
        ENDCASE
        cStr = '0x' + cStr
        RETURN cStr
    ENDFUNC
ENDDEFINE

* KNumbers Base Class Definition for numbers
DEFINE CLASS KNumbers AS Relation

    * Standard Properties
    Name = 'KNumbers'

    * Properties used for conversions
    cFormatLtr = ''         && Our format letter
    nNumber  = 0            && The number to be converted
    bIsNeg   = .F.          && .T. if the number is negative
    nAbsNumb = 0            && ABS(nNumber)
    nRounded = 0            && RoundOff(.nAbsNumb) (CFGN, non bIsExp only)
    cSimple  = ''           && TRANSFORM(.nAbsNumb)
    nWholes  = 0            && Number of whole digits
    nDecPlcs = 0            && Number of decimal digits
    bIsExp   = .F.          && .T. if the number is an exponential
    cMant    = ''           && Mantissa for Exponentials
    nPower   = 0            && Power of 10 for Exponentials
    nPrecision = 0          && Desired precision (defaults loaded if not passed)

    * Block the Properties not relevant here
    PROTECTED ChildAlias, ChildOrder, Comment, OntToMany, ParentAlias, ;
      RelationalExpr, Tag

    * Block the Methods not relevant here
    PROTECTED ReadExpression, ReadMethod, ResetToDefault, WriteExpression

    * Method List
    *- Init() - Set ourselves up
    *- ParseDigits() - Define our whole numbers and decimal places
    *- LoadExponProps() - Load our exponential properties
    *- ToString() - Convert our number to a string and return it
    *- GetNumbFmtwCommas() - Return a format string for the passed specs
    *- RoundOff() - Round off a number to x decimal places.  If x is negative,

    * Method Code

    *- Init() - Set ourselves up
    FUNCTION Init(cFormat, nTheNumber, nPrecision)
        LOCAL nAbsNumb, cSimple, bIsNeg, bIsExp
        IF NOT DODEFAULT()
            RETURN .F.
        ENDIF

        * Get the absolute number and its immediate string
        THIS.cFormatLtr = cFormat
        THIS.nNumber = nTheNumber

        * Do this with variables first
        nAbsNumb = ABS(nTheNumber)
        cSimple  = ALLTRIM( TRANSFORM(nAbsNumb) )
        bIsNeg   = (nTheNumber < 0)
        bIsExp   = 'E' $ UPPER(cSimple)

        * Load these properties
        WITH THIS
            IF VARTYPE(nPrecision) = 'N'
                .nPrecision = nPrecision
            ENDIF
            .nAbsNumb = nAbsNumb
            .cSimple  = cSimple
            .bIsNeg   = bIsNeg
            .bIsExp   = bIsExp
        ENDWITH

        * How many whole numbers and decimal places do we have?
        THIS.ParseDigits()

        * Get the special properties if we have an exponential
        IF bIsExp
            THIS.LoadExponProps()
        ENDIF

        * Done
        RETURN .T.
    ENDFUNC

    *- ParseDigits() - Define our whole numbers and decimal places
    FUNCTION ParseDigits()
        LOCAL cSimple, nWholes, nDecPlcs
        WITH THIS
            cSimple = .cSimple
            IF '.' $ cSimple
                nWholes = AT('.', cSimple) - 1
                nDecPlcs = LEN(cSimple) - 1 - nWholes
            ELSE
                nWholes = LEN(cSimple)
                nDecPlcs = LEN(cSimple) - nWholes
            ENDIF
            .nWholes  = nWholes
            .nDecPlcs = nDecPlcs
        ENDWITH
        RETURN nDecPlcs
    ENDFUNC

    *- LoadExponProps() - Load our exponential properties
    FUNCTION LoadExponProps()
        LOCAL cSimple, cMant, nPower, nPosn
        WITH THIS
            cSimple = .cSimple
            STORE '' TO cMant, nPower
            IF .bIsExp
                nPosn = AT('E', cSimple)
                cMant = LEFT(cSimple, nPosn-1)
                nPower = VAL( SUBSTR(cSimple, nPosn+1) )
                nDecPlcs = LEN(cMant) - 1 - .nWholes
            ENDIF
            .cMant  = cMant
            .nPower = nPower
        ENDWITH
        RETURN nPower
    ENDFUNC

    *- ToString() - Convert our number to a string and return it
    FUNCTION ToString()

        * Abstract method; must be subclassed

    ENDFUNC

    *- GetNumbFmtwCommas() - Return a format string for the passed specs
    *     Input: nInts - Number or whole digits (default = THIS.nWholes)
    *            nDecimal - Number or decimal digits (default = THIS.nPrecision)
    *            bAddCommas - .T. if we're to insert commas in the whole digits
    *                   part
    *      Retn: String of 9s for VFP formatting; Examples:
    *               (5, 2, .F.) --> "99999.99"
    *               (8, 2, .T.) --> "99,999,999.99"
    FUNCTION GetNumbFmtwCommas(nInts, nDecimals, bAddCommas)
        LOCAL cRetStr, cInts, nLen, nPosn

        * Check our parameters
        IF VARTYPE(nInts) <> 'N'
            nInts = THIS.nWholes
        ENDIF
        IF VARTYPE(nDecimals) <> 'N'
            nDecimals= THIS.nPrecision
        ENDIF

        * Do the decimal part first
        IF nDecimals > 0
            cRetStr = '.' + REPLICATE('9', nDecimals)
        ELSE
            cRetStr = ''
        ENDIF

        * Now, handle the integer part; insert commas if we're supposed to
        cInts = REPLICATE('9', nInts)
        nLen = LEN(cInts)
        IF bAddCommas AND nLen > 3

            * Do this from right to left; 3 at a time
            nPosn = nLen - 2
            DO WHILE nPosn > 1
                cInts = STUFF(cInts, nPosn, 0, ',')
                nPosn = nPosn - 3
            ENDDO
        ENDIF
        RETURN cInts + cRetStr
    ENDFUNC

    *- RoundOff() - Round off a number to x decimal places.  If x is negative,
    *   round to whole numbers (i.e. round -2 set hundreds to 0's).  Correctly
    *   handles negative numbers and halves (if previous digit is even, rounds
    *   up, else truncates).
    FUNCTION RoundOff(nNumVar, nDecPlcs)
        LOCAL nPower, nNumb, bRoundDown, nDelta

        * Convert the number to an integer first
        nPower = 10 ^ nDecPlcs
        nNumb = nNumVar * nPower

        * Delta is what we add to nNumb before taking the integer.  However,
        *   the special case of exactly half must be dealt with (round up if
        *   the next highest integer is even; round down if odd).  Then we have
        *   to make delta negative if we're dealing with a negative number.
        bRoundDown = (MOD(nNumb,1) = 0.500000 AND MOD( INT(nNumb), 2) = 1)
        nDelta = IIF(bRoundDown, 0, 0.5 ) * IIF(nNumVar < 0, -1, 1)

        * Add the delta based on whether this is a negative number or not, take
        *   the integer, divide by the power, and return.
        RETURN INT(nNumb + nDelta) / nPower
    ENDFUNC
ENDDEFINE
