# <center>KStrings.js - String Library for Javascript</center>

1. [Introduction](#introduction)
2. [Methods](#methods)
3. [Functions](#functions)
4. [Test Program](#test-program)

## Introduction

FoxPro strings are 1-based; that is, the first character in a string is accessed as: 
```foxpro
cChar = SUBSTR(cMyString, 1, 1)
```
. However, Javascript strings are 0-based, so its first character  is accessed as: 
```javascript
cChar = string.substring(0, 1)
```

(Both VFP's and JavaScript's second argument define how many characters to retrieve.)

When developing web sites, I often stumble by using FoxPro syntax. Later on, while coding data retrieval in VFP, I find myself making mistakes by using JavaScript syntax. Consequently, I wrote this Javascript library that uses (mostly) VFP function names but allows me to write Javascript using FoxPro syntax. So, getting the first character now becomes:
```javascript
cChar = string.Substr(1, 1)
```

I've found this capability lets me code JS faster and more reliably :grin:. Of course, the purists among us will frown on that practice :unamused:.

## Methods
```javascript
// String.IsWhite(nPosn) - Return true if character at nPosn is whitespace
// String.RTrim() - Remove trailing spaces in a string
// String.LTrim() - Remove leading spaces in a string
// String.AllTrim() - Remove leading and trailing spaces in a string
// String.Substr(nStart, nLength) - Return a part of a string
// String.Left(nLen) - Return the leftmost part of a string
// String.Right(nLen) - Return the rightmost part of a string
// String.Has(sFindStr, bIgnoreCase) - Return true if the passed string is within our string
// String.StrAtsFindStr) - Return the position of a string within a string
// String.RtStrAt(sFindStr) - Return the rightmost position of a string within a string
// String.StrTran(sStr1, sStr2) - Replace all instances of sStr1 with sStr2 in this string
// String.Upper() - Convert a string to UPPERCASE
// String.Lower() - Convert a string to lowercase
// String.PadLeft(desLen, padChar) - Pad a string on the left to the desired length
// String.makeLen(desLen) - Make a string the desired length
// String.deCode() - Decode the contents of a string
```

## Functions
```javascript
// Empty(strIn) - Return true if the passed string is empty
// EmptyN(strNumIn) - Return true if the passed string varible = "0"
// TrimAtSpace(strVar) - Return a string variable up to the first space
// extrToken(strIn, token) - Extract and return parts of a string around a token
```

## Test Program
The test program is at: [TestJSStrings.htm](file:///StringTests/TestJSStrings.htm) starting at line 155.

<br>

<font size="2"><center>
by Ken Green - [AdvanceDataSystems.biz](http://AdvanceDataSystems.biz)
</center></font>