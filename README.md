# <center>Projects</center>

## Ken's Libraries:

Going way back to the early 80s, I created special application functions that I tended to use over and over again. When I started doing some web sites the file containing those got so large I had to figure out a better organization. So, I created classes with a bunch of related methods.

There are three VFP classes with selective samples:
#### [KArrays.prg](./KensLibraries/KArrays.prg.md) (20 array functions, 4 subclasses):
* AddRow(col1Data, col2Data, ...) - One line that fills all columns in a multi-dimensional array
* MultiColSort() - Sort on col 2, then col 3

#### [KStrings.prg](./KensLibraries/KStrings.prg.md) (93 string handling functions):
* FirstAt() - Like AT() but allows for multiple search strings and returns the position of the first one found and which search string it was.
* ExtrToken() - Returns the text from a string up to the passed token and makes the remainder available for processing a string like AAA,BBB,CCC
* Encoding and Encrypting methods

#### [KOSFiles.prg](./KensLibraries/KOSFiles.prg.md) (51 file handling functions):
* DirInfo() - All files in a passed folder w/Name, size, date, time, attrs
* ZapDir() - Blow away it and its components
* SetAttrs() - Changes a file's attributes
* LL_Open() - Handles low-level file opening with 6 other LL_* functions

#### [KStrings.js](./KensLibraries/KStrings.js.md) (16 string methods, 4 functions):
Creating websites required extensive Javascript. I soon needed another library as VFP's 1-based strings got confused with Javascript's 0-based strings. Some samples:
* String.AllTrim() - Remove leading and trailing spaces in a string
* String.Substr() - Return a part of a string using VFP's normal notation
* String.StrTran() - Replace all instances of sStr1 with sStr2 in this string

#### [OSFiles.go](./KensLibraries/OSFiles.go) (5 functions):
A client wanted a very fast app for sending emails. The Go language seemed best, so I created this library with a few file functions similar to KOSFiles.prg.

I have found these so continuously useful, I thought others might find some things of use in these collections.

The Test* subfolders have programs that illustrate their use and also test each library.

<font size="2"><center>
by Ken Green - [AdvanceDataSystems.biz](http://AdvanceDataSystems.biz)
</center></font>