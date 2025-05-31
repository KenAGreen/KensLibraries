# <center>KStrings.prg - String Library Object for VFP</center>

1. [Introduction](#introduction)
2. [Categories](#categories)
3. [Methods For Each Category](#methods-for-each-category)
4. [Test Program](#test-program)

## Introduction

FoxPro is unmatched for string handling speed and versatility. However, often there are more fussy programmers (like me) that want more. KStrings.prg is essentially a library of specialized string functions/methods.

Assumming that KStrings.prg is within SET('PROCEDURE'), create the object with:
```foxpro
goStr = CREATEOBJECT('KStrings')
```

There are 93 methods so they've been categorized and the top of KStrings.prg has a list of their categorizations and under that is a list of methods, and their syntax,
for that category.

Note: Sometimes we use the HEX_FF character, aka CHR(255), as a single character replacement for the normal CR and LF characters in large texts.

## Categories
Here are the categories:
+--------------------------------------------------+----------------------------------------------------+
|[Get Information](#get-information)               |[PICTURE Methods](#picture-methods)                 |
+--------------------------------------------------+----------------------------------------------------+
|[Extract String Parts](#extract-string-parts)     |[Type Conversions](#type-conversions)               |
+--------------------------------------------------+----------------------------------------------------+
|[Modify the String](#modify-the-string)           |[String Incrementing](#string-incrementing)         |
+--------------------------------------------------+----------------------------------------------------+
|[Output Formatting](#output-formatting)           |[Multiple Option Strings](#multiple-option-strings) |
+--------------------------------------------------+----------------------------------------------------+
|[VFP Code Formatting](#vfp-code-formatting)       |[Combining Strings](#combining-strings)             |
+--------------------------------------------------+----------------------------------------------------+
|[Encoding Or Encrypting](#encoding-or-encrypting) |                                                    |
+--------------------------------------------------+----------------------------------------------------+


## Methods For Each Category

Below are the methods for each category; see KStrings.prg for the syntax details:

### Get Information
```foxpro
*- AllDigits() - Return .T. if the passed string contains only digits
*- AnyDigits() - Return .T. if the passed string contains ANY digits
*- AllCAPS() - Return .T. if a string contains only digits and CAPITAL letters
*- IsNumber() - Return .T. if the passed string is a number
*- AtNotInDelim() - Return the pos'n of a char NOT within delimeters
*- AtNotInParen() - Return the position of a char in a string outside of any ()
*- FldsInExpr() - Returns a list of field names within an index expression
*- FirstAt() - Find the first position of some strings in some text
*- FirstCap() - Return the first number or capital letter of a string
*- Get1stPosn() - Get the 1st position (R or L) of any of some chars
*- GetArg - Return the contents within parentheses for a passed name
*- GetArgValue() - Return the Value from a Name=Value clause
*- GetArticle() - Return the appropriate article for the passed noun
*- GetInitials() - Return the initials for the passed name
*- GetEndingDigits() - Return the trailing digits (if any) in a passed string
*- HasLowerCase() - Return .T. if the passed string has any lowercase letters
*- HasUpperCase() - Return .T. if the passed string has any uppercase letters
```

### Extract Parts (of a string)
```foxpro
*- GetEmailDomain() - Return the domain from an email address
*- ExtrNumber() - Extract a number from the beginning of a string
*- EvalLogicExpr() - Evaluate "Arg" in a Name(Arg) str as .T. (default) or .F.
*- ExtrClauseArg() - Extract a clause argument: (IN clause AS clause)
*- ExtrFldName() - Extract the first field name from an expression
*- ExtrLine() - Extract a max length line from a large string
*- ExtrLineWithText() - Extract entire line containing some text
*- IsQuoted() - Return .T. if the string is surrounded by quotes
*- ExtrQuoted() - Extract the contents, within quotes, from a string
*- ExtrToken() - Extract and return the text before a passed token (char)
*- ExtrVarValue() - Return "Val" from many "VarName=Val^" entries in text
*- GetVarValue - Return the value in a "VarName=Val[CR_LF]" line
*- SplitPosition() - Cut a string at the passed position number and return the left side
*- SplitString() - Split a string to whole words at the desired length
*- CleanString() - Remove non-alpha, non-digit, non-space characters
*- GetNextWord() - Extract the next word from a string
*- GetLastWord() - Extract the last word from a string
*- ExtractWords() - Extract only whole words up to a maximum length
```

### Modify the String
```foxpro
*- CheckStrValues() - Separate a string of entries into good and bad strings
*- SetTextLeftMargin() - Change the left margin of the passed text block
*- NormalizeNumber() - Return a number string in normal d.ddEee format
*- ClearPunct() - Remove all except characters and digits from passed string
*- ClearEndPunct() - Remove ending punctuation characters
*- AddQuotes2Text() - Add appropriate quote characters to the passed text
*- CleanMemo() - Remove a memo's leading lines and trailing white space
*- FormatPhone() - Apply the correct formatting to the passed phone
*- FlushLeft() - Return a string with characters moved flush left
*- FlushRight() - Return a string with characters moved flush right
*- FlushRZero() - Return a string with characters flush right, 0-filled
*- ListMemo() - Return a memo converted to CR_LF terminated lines
*- MakeLen() - Return a string at the desired length (chop or space fill)
*- MakeProper() - PROPERly capitalize a string IF it's all UC or all LC
*- ForceProper() - Convert string to lower, then proper capitalization
*- ExtrQuotes() - Return an array object with quoted and non-quoted parts
*- Plural() - Return the plural form of the passed noun
*- CountPlural() - Return the count and plural form of the passed noun
*- ExtrPlural() - Return the singular form of the passed plural
*- StrToHTML() - Convert &, <, > chars for HTML output
*- CharsToHTML() - Convert special characters into HTML equivalents
*- WebTrim() - Trim a string variable for HTML output
*- PostTrim() - Trim a string variable and remove artifacts
*- PostVal() - Return a numeric after removing artifacts
*- StripChrs() - Remove one or more characters from a passed string
*- WordWrapString() - Reformat a string with CR_LF lines
*- SwapPhrase() - Substitute all instances of a word/phrase with a 2nd word/phrase
*- CreateSpecialKey() - Return a key with 1 of 72 possible characters
```

### Output Formatting
```foxpro
*- Format() - Return the passed string with variable values inserted
*- DateFormat() - Format a Date or DateTime into a string
*- NumericFormat() - Format a Number or Currency value into a string
*- LogicalFormat() - Format a Logical value into a string
```

### VFP Code Formatting
```foxpro
*- Line2Code() - Format one line of code to fit within a specified length
*- FormatCode() - Format a block of text as VFP Code with ; carry-overs
```

### Encoding Or Encrypting
```foxpro
*- EncryptIt() - Return an encrypted string
*- DecryptIt() - Decrypt a string that was encrypted with EncryptIt()
*- EncodeURL() - Encode a string in an HTML FORM's GET METHOD format
*- DecodeURL() - Decode a string in an HTML FORM's GET METHOD format
*- Base64Encode() - Convert the passed string by BASE64 encoding
*- Base64Decode() - Decode the passed BASE64 string
```

### PICTURE Methods
```foxpro
*- ClearPict() - Remove all except characters and digits from passed string
*- GetPicChrs() - Return the text substitute chars in a "PICTURE" string
*- TrimPict() - Remove trailing picture characters from the passed string
*- RemoveOddHexChars() - Remove hex characters 0h-31h, 255h except LF, CR, FF
```

### Type Conversions
```foxpro
*- CharToX() - Convert a string to a variable of the passed type
*- XToChar() - Convert any value into a string
*- EscapeXML() - Escape special XML characters
*- GetDurationStr() - Return a human readable time string
*- RoundOff() - Round off a number to x decimal places
*- RoundUp() - Round up a number it's hightest possible integer
```

### String Incrementing
There are 5 incrementing methods.  They all take an input string as the starting point and that string length is never increased.  But, some functions will fill in spaces within the string if they need to.
```foxpro
*- IncrNumbPart() - Increment numbers within a string keeping any chars; Base 10
*- IncrNumeric() - Numerically increment a string and 0-fill on left; Base 10
*- IncrAlpha() - Alpha- or Alphanum- increment a string and zero-fill on left; Base 36
*- IncrFLStr() - Alphanum- or numerically-increment a flush left string; Base 36
*- IncrFRStr() - Alphanum- or numerically-increment a flush right string; Base 36
```

### Multiple Option Strings
```foxpro
*- GetNextOption() - Extract the next Name:Value pair from an option string
```

### Combining Strings
```foxpro
*- SetCityStateZip() - Return City, State, Zip combined
*- AddToString() - Add string to another with separator if neither is empty
```

### Test Program
The test program is at: [TestStrings.prg](./StringTests/TestStrings.prg).
<br>

See also the notes on [Hungarian Notation](./HungarianNotation.md).
<br>

<font size="2"><center>
by Ken Green - [AdvanceDataSystems.biz](http://AdvanceDataSystems.biz)
</center></font>