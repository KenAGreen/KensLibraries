<<<<<<< HEAD
# <center>Projects</center>

## Ken's Libraries:

Going way back to the early 80s, I created special application functions that I tended to use over and over again. When I started doing some web sites the file containing those got so large I had to figure out a better organization. So, I created classes with a bunch of related methods.

There are three VFP classes with selective samples:
#### KArrays.prg (20 array functions, 4 subclasses):
* AddRow(col1Data, col2Data, ...) - One line that fills all columns in a multi-dimensional array
* MultiColSort() - Sort on col 2, then col 3

#### KStrings.prg (93 string handling functions):
* FirstAt() - Like AT() but allows for multiple search strings and returns the position of the first one found and which search string it was.
* ExtrToken() - Returns the text from a string up to the passed token and makes the remainder available for processing a string like AAA,BBB,CCC
* Encoding and Encrypting methods

#### KOSFiles.prg (51 file handling functions):
* DirInfo() - All files in a passed folder w/Name, size, date, time, attrs
* ZapDir() - Blow away it and its components
* SetAttrs() - Changes a file's attributes
* LL_Open() - Handles low-level file opening with 6 other LL_* functions

#### KStrings.js (16 string methods, 4 functions):
Creating websites required extensive Javascript. I soon needed another library as VFP's 1-based strings got confused with Javascript's 0-based strings. Some samples:
* String.AllTrim() - Remove leading and trailing spaces in a string
* String.Substr() - Return a part of a string using VFP's normal notation
* String.StrTran() - Replace all instances of sStr1 with sStr2 in this string

#### OSFiles.go (5 functions):
A client wanted a very fast app for sending emails. The Go language seemed best, so I created this library with a few file functions similar to KOSFiles.prg.

I have found these so continuously useful, I thought others might find some things of use in these collections.

The Test* subfolders have programs that test each of their libraries; they also illustrate their use.

=======
# <center>VFP Method Libraries</center>

by Ken Green at [Advance Data Systems](http://www.AdvanceDataSystems.biz)

Beginning with my first dBaseIII app, I've started collection useful functions. Further on, with FoxBase2 thru FoxPro 2.6 and VFP 9, that collection grew into a very large file. With new web apps the need for more special functions grew tremendously, begging for a better organization. Thus then need for object collections.

Hopefully, you may find some methods/functions useful to you in these collections:

1. [Array Methods](#array-methods)
2. [String Methods](#string-methods)
3. [File System Methods](#file-system-methods)
4. [Other Languages](#other-languages)

### Array Methods

Arrays can be very handy at times; indeed VFP has a sub-language dedicated to them. However I found it can be somewhat tedious. In vanilla VFP, to add a new row to a 4-column array requires:
```foxpro
nRows = ALEN(aMyArray,1) + 1
DIMENSION aMyArray[nRows, 4]
aMyArray[nRows,1] = 'A'
aMyArray[nRows,2] = 456
aMyArray[nRows,3] = .F.
aMyArray[nRows,4] = 8.500
```
With **KArrays.prg**, you can do that with one line:
```foxpro
oMyArray.AddRow('A', 456, .F., 8.500)
```

Adding a column on the fly can cause a great mess with VFP; Karrays.prg handles that properly.

See the full list in [KArrays.prg](file:///KArrays.prg.md).

### String Methods

The **KStrings** class is just another function collection object. If a goStr object was created on startup, calls to this are really just method invocations. For example, to force a string to a certain length, you'd call this like:
```foxpro
cNewStr = goStr.MakeLen(cOldStr, 25)
```

This is a very large collection of string manipulations. Create incrementing ID values using base 36 characters (A-Z,0-9); 4 characters yields 17 million possibilities.
You can easily extract parts of a string, do type conversions, or format code blocks. There are encryption/decryption functions. FirstAt() gets the first instance of multiple strings, and there are many HTML manipulations to boot. Yet this is only scratching the surface.

There are so many methods that they've been categorized in [KStrings.prg](file:///KStrings.prg.md).

### File System Methods

Like the KStrings class, the **KOSFiles** class is yet another function collection. If a goFiles object was created on startup, calls to this are just method invocations. For example, to see if there are any files on a particular folcer you'd write:
```foxpro
cNewStr = goFiles.AnyFiles(cDir)
```

This has a bunch of operating system file manipulations. And, while VFP has a mini-language for low-level file handling, the bottom of the class has obvious names and sometimes simpler ways of doing things with low-level files.

These methods are also categorized in [KOSFiles.prg](file:///KOSFiles.prg.md).

### Other Languages

If function objects are useful in FoxPro, wouldn't they also be useful in other languages? Here are two other libraries that will illustrate the point:

## Javascript
Web site development requires, for me, heavy FoxPro use (1-based strings) and heavy **Javascript** use (0-based strings). Having inherited addling genes, bouncing back and forth between the two gets confusing. And, unlike FoxPro, Javascript has string objects. So, this library, [KStrings.js](file:///KStrings.js.md) has many string methods that use similar FoxPro names but converts strings using 1-based addressing. There are also some other functions that are used for anything else.

## Go Language

In 2014 a client wanted to send emails very quickly (for business use; not a spammer). This seemed appropriate for a low-level language. I'd been interested in Google's **Go** language and learned that it was very fast, much safer than **C** or **C++**, and had some unique capabilities such as functions can return **two** values.  Go also encourages Test-Driven Development (TDD): it makes it easy to write unit tests as you're creating a library.

Needing file management for attachment handling, I adopted some of the KOSFiles methods in my Go program. See [OSFiles.go](file:///OSFiles.go) for that abbreviated library.

Test Program: [OSFiles_test.go](file:///OSFilesTests/OSFiles_test.go).

Here are its methods:
```go
//  IsFile(fileName string) returns true if the file exists, else false.
//  DirInfo(dirNm, spec, inclDirs) returns a slice of matching folder entries.
//  cleanList() - Returns a slice containing only matching directory entries
//  FileToString(cFullNm) - Return a file's content as a string
//  StringToFile(content []byte, cFullNm string) - Write a string to a file
//  DeleteFile(cFullNm string) - Delete a file
```

See also the notes on [Hungarian Notation](file:///HungarianNotation.md).
>>>>>>> 9e302ebed602fa60be4f664dfbd22875300118cb
<br>

<font size="2"><center>
by Ken Green - [AdvanceDataSystems.biz](http://AdvanceDataSystems.biz)
</center></font>