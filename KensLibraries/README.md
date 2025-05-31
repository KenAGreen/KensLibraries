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

See the more info in [KArrays.prg.md](./KArrays.prg.md).

### String Methods

The **KStrings** class is just another function collection object. If a goStr object was created on startup, calls to this are really just method invocations. For example, to force a string to a certain length, you'd call this like:
```foxpro
cNewStr = goStr.MakeLen(cOldStr, 25)
```

This is a very large collection of string manipulations. Create incrementing ID values using base 36 characters (A-Z,0-9); 4 characters yields 17 million possibilities.
You can easily extract parts of a string, do type conversions, or format code blocks. There are encryption/decryption functions. FirstAt() gets the first instance of multiple strings, and there are many HTML manipulations to boot. Yet this is only scratching the surface.

There are so many methods that they've been categorized in [KStrings.prg.md](./KStrings.prg.md).

### File System Methods

Like the KStrings class, the **KOSFiles** class is yet another function collection. If a goFiles object was created on startup, calls to this are just method invocations. For example, to see if there are any files on a particular folcer you'd write:
```foxpro
cNewStr = goFiles.AnyFiles(cDir)
```

This has a bunch of operating system file manipulations. And, while VFP has a mini-language for low-level file handling, the bottom of the class has obvious names and sometimes simpler ways of doing things with low-level files.

These methods are also categorized in [KOSFiles.prg.md](./KOSFiles.prg.md).

### Other Languages

If function objects are useful in FoxPro, wouldn't they also be useful in other languages? Here are two other libraries that will illustrate the point:

## Javascript
Web site development requires, for me, heavy FoxPro use (1-based strings) and heavy **Javascript** use (0-based strings). Having inherited addling genes, bouncing back and forth between the two gets confusing. And, unlike FoxPro, Javascript has string objects. So, this library, shown in [KStrings.js.md](./KStrings.js.md) has many string methods that use familiar FoxPro names but converts strings using 1-based addressing. There are also some other functions that are used for anything else.

## Go Language

In 2014 a client wanted to send emails very quickly (for business use; not a spammer). This seemed appropriate for a low-level language. I'd been interested in Google's **Go** language and learned that it was very fast, much safer than **C** or **C++**, and had some unique capabilities such as functions can return **two** values.  Go also encourages Test-Driven Development (TDD): it makes it easy to write unit tests as you're creating a library.

Needing file management for attachment handling, I adopted some of the KOSFiles methods in my Go program. See [OSFiles.go](./OSFiles.go) for that abbreviated library.

Test Program: [OSFiles_test.go](./OSFilesTests/OSFiles_test.go).

Here are its methods:
```go
//  IsFile(fileName string) returns true if the file exists, else false.
//  DirInfo(dirNm, spec, inclDirs) returns a slice of matching folder entries.
//  cleanList() - Returns a slice containing only matching directory entries
//  FileToString(cFullNm) - Return a file's content as a string
//  StringToFile(content []byte, cFullNm string) - Write a string to a file
//  DeleteFile(cFullNm string) - Delete a file
```

See also the notes on [Hungarian Notation](./HungarianNotation.md).
<br>

<font size="2"><center>
by Ken Green - [AdvanceDataSystems.biz](http://AdvanceDataSystems.biz)
</center></font>