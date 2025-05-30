# <center>KOSFiles.prg - File System's Library for VFP</center>

1. [Introduction](#introduction)
2. [Categories](#categories)
3. [Methods For Each Category](#methods-for-each-category)
4. [Test Program](#test-program)

## Introduction

We can't do very much programming without having to deal with Windows' file system. nd, we sometimes need to deal with low-level file functions using VFP's special little language for that. The **KOSFiles.prg** library makes much of that easier.

Assumming that KOSFiles.prg is within SET('PROCEDURE'), create the object with:
```foxpro
goFiles = CREATEOBJECT('KOSFiles')
```

## Categories
Here are the categories:
+----------------------------+--------------------------------------------+
|[Drives](#drives)           |[File Manipulations](#file-manipulations)   |
+----------------------------+--------------------------------------------+
|[Directories](#directories) |[Low Level Functions](#low-level-functions) |
+----------------------------+--------------------------------------------+
|[FileNames](#filenames)     |                                            |
+----------------------------+--------------------------------------------+

## Methods For Each Category

Below are the methods for each category; see KOSFiles.prg for the syntax details:

### Drives
```foxpro
*- IsDrive(cDrvLtr) - Return .T. if passed drive letter is a valid drive
*- GetDriveFreeSpace(cDrvLtr) - Return a drive's free space in bytes
*- JustDrive(cFileSpec) - Return only the drive and colon from the passed path/filespec
```

### Directories
```foxpro
*- DirInfo(cDirSpec, [cFileSpec, [bSubdirs]]) - Return an array object of file/dir information for a directory
*- DirListOnly(cDirSpec, [bNoSort]) - Return an array object of dir information for a passed spec
*- AnyFiles(cFileSpec) - Return .T. if any files exist matching the passed filespec
*- FileList(cDirSpec, cFileSpec, [bKillExt]) - Return a list of files matching passed specs as file1,file2...
*- CheckLastSep(cPath, [bKillSep]) - Make sure the passed path has a trailing \, or remove it
*- CheckDirSep(cPath) - Return the passed path with all directory separators as \
*- LastDirPosn(cPath) - Return the last drive or directory separator position
*- GetLatestFile() - Return the latest file name for a file spec
*- GetPath(cFileSpec) - Return the full path for a passed filename
*- FullPath(cPathSpec) - Return the full path from a partial directory (e.g. "..\..")
*- MinPath(cFullSpec, [pcCompareTo]) - Return the minimum path from current or passed directory
*- IsADir(cDirName) - Determine whether the passed spec is a directory
*- MakeDir(cDirName) - Create the passed directory name
*- MakeAllDirs() - Create the passed directory and, if needed, its parents
*- RemDir(cDirName) - Remove the passed directory (must be empty)
*- ZapDir(cDirName) - Remove an entire directory tree
*- IncrDirName(cPref, nFileLen) - Return a directory name based on incrementing trailing digits
*- UniqueDirName(cDir) - Return a temporary directory name that doesn't exist
```

### Filenames
```foxpro
*- UniqueTempName(cExt, [cDir]) - Return a temporary filename that doesn't exist
*- JustPath(cPathSpec) - Return only the path from the passed spec
*- JustFile(cFileSpec) - Return only the file name/extension from the passed filespec
*- JustFName(cFileSpec) - Return only the file name (no ext) from the passed filespec
*- JustFExt(cFileSpec) - Return only the extension from the passed filespec
*- IncrFName(cPref, cExt, cDir) - Return a filename setting the filename based on the next number
*- IncrFName0(cPref, cExt, cDir) - Return a filename defined based on 0s + the next number
*- IncrFExt(cFileSpec) - Return a filename setting the extension based on the next number
```

### File Manipulations
```foxpro
*- GetFileDescription(cDirName, [cFileName]) - Return a file's information in an object
*- FindFirstFile(cPathSpec) - Return an object containing the FIRST file's info in a dir
*- FindNextFile(cPathSpec) - Return an object containing the NEXT file's info in a dir
*- WaitForFile(cPathSpec) - Return when a file has finished being created
*- IsAFile(cFileName) - Return .T. if the passed file spec exists (wild cards OK)
*- FileSize(cFileNm) - Return the size of a file
*- FileDate(cFileNm) - Return a file's date
*- FileTime(cFileNm) - Return a file's time
*- FileAttr(cFileNm) - Return a file's attributes
*- SetFileAttrs(cFileNm) - Change a file's attributes
*- CopyFile(cSrcFile, [cDstDir, [bUseTemp, [bNoBugFileWanted]]]) - Copy a file from one directory to another
*- CopyAllFiles(cFilSpec, cDstDir) - Copy file matching a passed spec from one directory to another
*- MoveFile(cSrcFile, [cDstDir, [bUseTemp, [bNoBugFileWanted]]]) - Move a file from one drive/directory to another
*- RenameFile(cFileName, cNewName) - Rename a passed filename
*- DeleteFile(cDelFile) - Delete a passed filename
*- DeleteAllFiles(cDelSpec) - Delete all files matching a passed file spec
```

### Low Level Functions
```foxpro
*- LL_Open(cFileName, [cAction]) - Return "handle" after create/open a "low-level" read/write file
*- LL_Read(nLLHndl, [bStripCRLF [,nBytes2Read]]) - Read a line from a low-level file
*- LL_Write(nLLHndl, cWriteStr  [,bNoCrLf]) - Write a string to a low-level file
*- LL_Flush(nLLHndl, [bForceIt]) - Flush a low-level file
*- LL_Close(nLLHndl) - Close a low-level file
*- LL_ToBOF(nLLHndl) - Position a low-level file to FBOF()
*- LL_ToEOF(nLLHndl) - Position a low-level file to FEOF()
*- LL_IsLockcFileName() - Return .T. if the file is locked
```

### Test Program:
The test Program is at: [TestOSFiles.prg](file:///OSFilesTests/TestOSFiles.prg).

See also the notes on [Hungarian Notation](file:///./HungarianNotation.md).
<br>

<font size="2"><center>
by Ken Green - [AdvanceDataSystems.biz](http://AdvanceDataSystems.biz)
</center></font>