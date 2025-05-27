/*                              Strings.js                          2/28/2014 */

//      String Methods
// String.IsWhite() - Return true if character at nPosn is whitespace
// String.RTrim() - Remove trailing spaces in a string
// String.LTrim() - Remove leading spaces in a string
// String.AllTrim() - Remove leading and trailing spaces in a string
// String.Substr() - Return a part of a string using VFP's normal notation
// String.Left() - Return the leftmost part of a string
// String.Right() - Return the rightmost part of a string
// String.Has() - Return true if the passed string is within our string
// String.StrAt() - Return the position of a string within a string
// String.RtStrAt() - Return the rightmost position of a string within a string
// String.StrTran() - Replace all instances of sStr1 with sStr2 in this string
// String.Upper() - Convert a string to UPPERCASE
// String.Lower() - Convert a string to lowercase
// String.PadLeft() - Pad a string on the left to the desired length
// String.makeLen() - Make a string the desired length
// String.deCode() - Decode the contents of a string
//      Gemeral Functions
// Empty() - Return true if the passed string is empty
// EmptyN() - Return true if the passed string varible = "0"
// TrimAtSpace() - Return a string variable up to the first space
// extrToken() - Extract and return parts of a string around a token

// -------------------------------------------------------------------------- //

// String.IsWhite() - Return true if character at nPosn is whitespace
function strIsWhite(nPosn) {
    var cChar, strWhite, nSpcPosn;

    // Returns: true if the character at the passed position is whitespace.
    // CAUTION: This function assumes 1-based string positions
    cChar = this.charAt(nPosn-1);

    // Whitespace is: "\t\n\r ", e.g. tag, newline, carriage return
    strWhite = "\t\n\r ";
    nSpcPosn = strWhite.indexOf(cChar);
    return (nSpcPosn > -1);
}
String.prototype.IsWhite = strIsWhite;

// String.RTrim() - Remove trailing spaces in a string
function strRTrim() {
    var nPosn, brkPosn;

    // Returns: A new string with all trailing whitespace removed.
    //           (Whitespace is: "\t\n\r ")
    if (this.length === 0)  {
        return "";
    }
    nPosn = this.length;
    if (!this.IsWhite(nPosn))   {
        return this;
    }
    brkPosn = -1;
    for (nPosn = this.length; nPosn > 0; nPosn--)  {
        if (!this.IsWhite(nPosn)) {
            brkPosn = nPosn;
            break;
        }
    }
    if (brkPosn == -1)  {
        return "";
    }
    return this.substring(0, nPosn);
}
String.prototype.RTrim = strRTrim;

// String.LTrim() - Remove leading spaces in a string
function strLTrim() {
    var brkPosn, nPosn;

    // Returns: A new string with all leading whitespace removed.
    //           (Whitespace is: "\t\n\r ")
    if (this.length === 0)  {
        return "";
    }
    if (!this.IsWhite(1))   {
        return this;
    }
    brkPosn = -1;
    for (nPosn = 1; nPosn <= this.length; nPosn++)  {
        if (!this.IsWhite(nPosn)) {
            brkPosn = nPosn;
            break;
        }
    }
    if (brkPosn == -1)  {
        return "";
    }
    return this.substring(brkPosn-1);
}
String.prototype.LTrim = strLTrim;

// String.AllTrim() - Remove leading and trailing spaces in a string
function strAllTrim() {
    var Str;

    // Returns: A new string with leading AND trailing whitespace removed.
    //           (Whitespace is: "\t\n\r ")
    if (this.length === 0)   {
        return "";
    }
    Str = this.LTrim();
    return Str.RTrim();
}
String.prototype.AllTrim = strAllTrim;

// String.Substr() - Return a part of a string using VFP's normal notation
function strSubstr(nStart, nLength) {
    var nLen, nBegPosn, nEndPosn, sStr;

    /*   Inputs: nStart = starting position (1-based)
                 nLen (optional) = number of characters desired (0 = none)
       Examples: 1: c123 = "OneTwoThree";
                    cTwo = c123.Substr(4, 3)        // = "Two"
                 2: cFour = c123.Substr(12, 4)      // = ""
    */

    // We may not have the 2nd argument
    nLen = this.length;
    if (arguments.length == 2)
        nLen = nLength;

    // Handle trivial stuff first
    if (nStart < 1 || nLen < 1 || nStart > this.length) {
        return "";
    }

    /* Here we know that:
        nStart >= 1
        nStart <= this.length
        nLen >= 1
    */

    // substring() is a built-in string method.  However, it wants a beginning
    //  position (0-based)
    nBegPosn = nStart - 1;          // 0 <= nBegPosn < this.length

    /* substring() also wants an ending position (0-based) that is or position
        after the last character to be included.  For example:
                       Posn:  0123456789
                        Str: "1234567890"
            substring(0,9) = "123456789"
        posn 9 points to "0" which is AFTER the last character.
        If nBegPosn = 0 (nStart = 1) and nLen = 9,
           nEndPosn = 9 = nBegPosn + nLen
    */
    nEndPosn = nBegPosn + nLen;
    if (nEndPosn > this.length) {
        nEndPosn = this.length;
    }
    sStr = this.substring(nBegPosn, nEndPosn);
    return sStr;
}
String.prototype.Substr = strSubstr;

// String.Left() - Return the leftmost part of a string
function strLeft(nLen) {

    /*   Inputs: nLen = number of characters desired (0 = none)
        Example: var s123 = "OneTwoThree";
                 var sOne = c123.Left(3)            // = "One"
    */
    return this.substring(0, nLen);
}
String.prototype.Left = strLeft;

// String.Right() - Return the rightmost part of a string
function strRight(nLen) {

    /*   Inputs: nLen = number of characters desired (0 = none)
        Example: var s123 = "OneTwoThree";
                 var sOne = c123.Right(5)            // = "Three"
    */
    var nPos = this.length - nLen;
    return this.substr(nPos, nLen);
}
String.prototype.Right = strRight;

// String.Has() - Return true if the passed string is within our string
function strHas(sFindStr, bIgnoreCase) {
    var nPosn;

    /*   Inputs: sFindStr = the string to be found
                 bIgnoreCase - true for case-insensitive check
        Returns: true if sFindStr is within our string
        Example: var sStr = "ABCDABCD";
                 bIsThere = sStr.Has("DA");
    */
    if (this.length === 0 || sFindStr.length === 0)  {
        return false;
    }
    if (bIgnoreCase) {
        nPosn = this.toLowerCase().indexOf(sFindStr.toLowerCase());
    } else {
        nPosn = this.indexOf(sFindStr);
    }
    return nPosn > -1;
}
String.prototype.Has = strHas;

// String.StrAt() - Return the position of a string within a string
function strStrAt(sFindStr) {

    /*   Inputs: sFindStr = the string to be found
        Returns: The string position where sFindStr is found (0 if not there)
        Example: var sStr = "ABCDABCD";
                 nPosnD = sStr.StrAt("D");          // 4
           Note: Returns only the first instance of sFindStr in sStr
    */
    if (this.length === 0)  {
        return -1;
    }
    var nPosn = this.indexOf(sFindStr);
    return nPosn + 1;
}
String.prototype.StrAt = strStrAt;

// String.RtStrAt() - Return the rightmost position of a string within a string
function strRtStrAt(sFindStr) {

    /*   Inputs: sFindStr = the string to be found
        Returns: The rightmost string position where sFindStr is found (-1 if
                    not there)
        Example: var sStr = "ABCDABCD";
                 nPosnD = sStr.RtStrAt("C");          // 7
           Note: Returns the rightmost instance of sFindStr in sStr
    */
    if (this.length === 0)  {
        return 0;
    }
    var nPosn = this.lastIndexOf(sFindStr);
    nPosn = nPosn + 1;
    return nPosn;
}
String.prototype.RtStrAt = strRtStrAt;

// String.StrTran() - Replace all instances of sStr1 with sStr2 in this string
function strStrTran(sStr1, sStr2) {
    var sLeft, sRight, nStrPosn, sStrOut;

    /*   Inputs: sStr1 = the string to be replaced
                 sStr2 = the string to be substituted (may be empty)
        Returns: number of substitutions
        Example: newStr = oldStr.StrTran(tossThis, forThis);
    */

    // Handle all instances
    sLeft = "";
    sRight = this.Left(this.length);
    nStrPosn = sRight.StrAt(sStr1);
    while (nStrPosn > 0)    {

        // Extract the leftmost part and add sStr2 to it
        if (nStrPosn == 1)
            sLeft = sLeft + sStr2;
        else
            sLeft = sLeft + sRight.Left(nStrPosn-1) + sStr2;

        // Extract the rightmost part
        nStrPosn = nStrPosn + sStr1.length;
        if (nStrPosn > sRight.length)  {
            sRight = "";
        } else {
            sRight = sRight.Substr(nStrPosn);
        }

        // Any more instances?
        nStrPosn = sRight.StrAt(sStr1);
    }

    // Put them together
    sStrOut = sLeft + sRight;
    return sStrOut;
}
String.prototype.StrTran = strStrTran;

// String.Upper() - Convert a string to UPPERCASE
function strUpper() {
    return this.toUpperCase();
}
String.prototype.Upper = strUpper;

// String.Lower() - Convert a string to lowercase
function strLower() {
    return this.toLowerCase();
}
String.prototype.Lower = strLower;

// String.PadLeft() - Pad a string on the left to the desired length
function strPadLeft(desLen, padChar) {
    var cStrOut;

    // The default pad character is a space
    if (!padChar)   {
        padChar = " ";
    }
    cStrOut = this;
    while(cStrOut.length < desLen)  {
        cStrOut = padChar + cStrOut;
    }
    return cStrOut;
}
String.prototype.PadLeft = strPadLeft;

// String.makeLen() - Make a string the desired length
function strMakeLen(desLen) {
    var sStr = this;
    while (sStr.length < desLen)  {
        sStr = sStr + "          ";
    }
    if (sStr.length > desLen)  {
        sStr = sStr.Left(desLen);
    }
    return sStr;
}
String.prototype.makeLen = strMakeLen;

// String.deCode() - Decode the contents of a string
function strDeCode() {
    var sStr = this;

    // First we'll convert the + signs into spaces
    sStr = sStr.StrTran("+", " ");

    // Convert "&amp;" into "&"
    sStr = sStr.StrTran("&amp;", "&");

    // Convert "&apos;" into "'"
    sStr = sStr.StrTran("&apos;", "'");
    return sStr;
}
String.prototype.deCode = strDeCode;

//      Gemeral Functions

// Empty() - Return true if the passed string is empty
function Empty(strIn) {
    var nPosn;

    // If it's length = 0 we can return quickly
    if (typeof strIn === "undefined" || strIn === null) {
        return true;
    }
    if (strIn.length === 0)  {
        return true;
    }

    // Otherwise, check all characters until we get the first non-space one
    for (nPosn = 0; nPosn < strIn.length; nPosn++)  {
        if (strIn[nPosn] != ' ') {
            return false;
        }
    }

    // Here it must be empty
    return true;
}

// EmptyN() - Return true if the passed string varible = "0"
function EmptyN(strNumIn) {

    // If the string is empty, the number must also be empty
    if (Empty(strNumIn)) {
        return true;
    }

    // Convert the string to a number
    var numIn = makeFNumb(strNumIn);
    return (numIn === 0);
}

// TrimAtSpace() - Return a string variable up to the first space
function TrimAtSpace(strVar)  {
    var nSpPosn, retStr;

    // Find the first space
    nSpPosn = strVar.StrAt(" ");
    if (nSpPosn)    {
        retStr = strVar.Left(nSpPosn);
    } else  {
        retStr = strVar;
    }
    return retStr;
}

// extrToken() - Extract and return parts of a string around a token
function extrToken(strIn, token) {
    var str2Chk, tokenPosn, cFrag, retObj;

    // Split strIn at the 1st instance of a token into an object containing:
    //  .fragment - a string fragment UP TO but not including the token
    //  .remainder - the remainder of the string past the token
    // Example:
    //      obj = extrToken(cList, ',');
    //      c1stItem = obj.fragment;
    //      cRest = obj.remainder
    str2Chk = strIn;
    tokenPosn = str2Chk.StrAt(token);
    if (tokenPosn === 0)   {
        cFrag = strIn;
        str2Chk = "";
    } else {
        cFrag = str2Chk.Left(tokenPosn-1);
        if (tokenPosn+1 > str2Chk.length)  {
            str2Chk = "";
        } else {
            str2Chk = str2Chk.Substr(tokenPosn+1);
        }
    }
    retObj = {};
    retObj.fragment = cFrag;
    retObj.remainder = str2Chk;
    return retObj;
}
