#IF 0                         TestOSFiles.prg

  Purpose:  Test ..\KOSFiles.prg

Revisions:  May 20, 2025 - Ken Green - Original

*****************************************************************************
#ENDIF

#DEFINE CR           CHR(13)
#DEFINE LF           CHR(10)
#DEFINE CR_LF        CHR(13) + CHR(10)

CLOSE ALL
CLEAR ALL
SET CENTURY ON
SET PROCEDURE TO ..\KStrings, ..\Karrays, ..\KOSFiles

goStr = CREATEOBJECT('KStrings')
goFiles = CREATEOBJECT('KOSFiles')

* Setup for printing to KOSFilesResults.txt
SET PRINTER TO
IF FILE('KOSFilesResults.txt')
    ERASE KOSFilesResults.txt
ENDIF

SET DEVICE TO PRINT
SET PRINTER TO KOSFilesResults.txt
SET PRINTER ON
SET CONSOLE ON
CLEAR

?? SPACE(26) + 'Testing KOSFiles.prg Library'
gnCnt = 1
gcMainDir = ADDBS( FULLPATH('..\'))
gcTestDir = ADDBS( FULLPATH('.\'))

?
? 'Drives:'
? '-------'

* IsDrive() - Return .T. if passed drive letter is a valid drive
*    Input: cDrvLtr - Drive letter in question
*     Retn: .T. if cDirName is a valid drive, else .F.
cFunc = 'IsDrive()'
bIsGood = .F.
bValue1 = goFiles.IsDrive('D:')     && I do have a D: drive
bValue2 = goFiles.IsDrive('W:')     && I do NOT have a W: drive
DO CASE
CASE NOT (bValue1 AND NOT bValue2)
    ? cFunc + ' said Drive D: was ' + TRANSFORM(bValue1) + ;
      ' and Drive W: was ' + TRANSFORM(bValue2)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetDriveFreeSpace(cDrvLtr) - Return a drive's free space in bytes
*   Input: cDrvLtr - Drive letter in question (can have trailing colon)
*    Retn: Free space on drive in bytes
cFunc = 'GetDriveFreeSpace()'
bIsGood = .F.
nValue = goFiles.GetDriveFreeSpace('D:')
*   DO CASE             && This tested OK but it keeps changing
*   CASE nValue <> 65453174874
*       ? cFunc + ' said Drive D: had ' + TRANSFORM(nValue) + ' free space'
*   OTHERWISE
        bIsGood = .T.
*   ENDCASE
ShowResult(cFunc, bIsGood)

* JustDrive(cFileSpec) - Return only the drive and colon from the passed path/filespec
*    Input: cFileSpec - Path/File string to test
*     Retn: Only the Drive and : part of cFileSpec
cFunc = 'JustDrive()'
bIsGood = .F.
cStr = [F:\XFRX\OSFiles\]
cValue = goFiles.JustDrive(cStr)
DO CASE
CASE NOT cValue == [F:]
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Directories:'
? '------------'

* DirInfo(cDirSpec, [cFileSpec, [bSubdirs]]) - Return an array object of file/dir information for a directory
*    Input: cDirSpec - Path for files (can be empty)
*           cFileSpec - File Spec (default = '*.*')
*           bSubdirs - .T. if you want subdirectories also
*     Retn: DirArray object for passed directory with the following format:
*                .aRA[x,1] - File name (C) (includes extension)
*                .aRA[x,2] - File size (N):
*                .aRA[x,3] - File date (D)
*                .aRA[x,4] - File Time (C)
*                .aRA[x,5] - File Attributes (C):
*                      Letter        Attribute
*                      컴컴컴        컴컴컴컴�
*                        A            Archive (Read and Write)
*                        H            Hidden
*                        R            Read only
*                        S            System
*                        D            Directory
cFunc = 'DirInfo()'
bIsGood = .F.
oValue = goFiles.DirInfo('.\Notes')
DO CASE
CASE NOT (oValue.nRows = 2 AND oValue.aRA[1,1] = 'CATEGORIES.TXT')
    ? cFunc + ' oValue.nRows were ' + TRANSFORM(oValue.nRows) + ;
      ' and oValue.aRA[1,1] = ' + oValue.aRA[1,1]
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* DirListOnly(cDirSpec, [bNoSort]) - Return an array object of dir information for a passed spec
*    Input: cDirSpec - Path for directories (can be empty for current dir)
*           bNoSort - Pass .T. if you don't want the list sorted by name
*     Retn: DirArray object for passed directory with the following format:
*                .aRA[x,1] - File name (C) (includes extension)
*                .aRA[x,2] - File size (N):
*                .aRA[x,3] - File date (D)
*                .aRA[x,4] - File Time (C)
*                .aRA[x,5] - File Attributes (C):
*                      Letter        Attribute
*                      컴컴컴        컴컴컴컴�
*                        A            Archive (Read and Write)
*                        H            Hidden
*                        R            Read only
*                        S            System
*                        D            Directory
cFunc = 'DirListOnly()'
bIsGood = .F.
oValue = goFiles.DirListOnly(gcMainDir, .T.)
DO CASE
CASE NOT (oValue.nRows = 4 AND oValue.aRA[1,1] = 'ARRAYTESTS')
    ? cFunc + ' oValue.nRows were ' + TRANSFORM(oValue.nRows) + ;
      ' and oValue.aRA[1,1] = ' + oValue.aRA[1,1]
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* AnyFiles(cFileSpec) - Return .T. if any files exist matching the passed filespec
*    Input: cFileSpec - File Specification (e.g. "*.TXT" OR "JUNK??.TXT")
*     Retn: .T. If any files exist that match the spec
cFunc = 'AnyFiles()'
bIsGood = .F.
bValue = goFiles.AnyFiles('Notes\*.*')
DO CASE
CASE NOT bValue
    ? cFunc + ' bValue = .F. (e.g. No Files)'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FileList(cDirSpec, cFileSpec, [bKillExt]) - Return a list of files matching passed specs as file1,file2...
*    Input: cDirSpec - Path string to get files from (can be empty)
*           cFileSpec - File Specification (e.g. *.TXT)
*           bKillExt - (optional) .T. if ext is to be removed from filename
*     Retn: List of files as file1,file2,...
cFunc = 'FileList()'
bIsGood = .F.
cValue = goFiles.FileList('Notes', '*.*')
DO CASE
CASE NOT cValue == 'CATEGORIES.TXT,KOSFILES.TXT'
    ? cFunc + ' cValue has these files: |' + cValue + '|'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* CheckLastSep(cPath, [bKillSep]) - Make sure the passed path has a trailing \, or remove it
*    Input: cPath - Path string to test
*           bKillSep - If .T. last \ is removed if it's there
*     Retn: cPath with (or without) a trailing \
ShowResult('CheckLastSep()', .T.)     && Already tested above

* CheckDirSep(cPath) - Return the passed path with all directory separators as \
*    Input: cPath - Path string to test
*     Retn: cPath with all directory separators as \
ShowResult('CheckDirSep()', .T.)     && Already tested above

* LastDirPosn(cPath) - Return the last drive or directory separator position
*    Input: cPath - Path string to test
*     Retn: Position of last directory separator: \ or :
cFunc = 'LastDirPosn()'
bIsGood = .F.
*                 1  v
*        123456789012345678
*        OSFILESTESTS\Notes
cStr = STRTRAN(gcTestDir + 'Notes', gcMainDir, '')
nValue = goFiles.LastDirPosn(cStr)
DO CASE
CASE NOT nValue == 13
    ? cFunc + ' nValue was ' + TRANSFORM(nValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetLatestFile() - Return the latest file name for a file spec
*   Input: cDirSpec - Path and file spec, such as: E:\XFER\Ken*.zip
*          pcSortType - Date (default) or Name
*    Retn: The latest file based on the passed file spec
*   Notes: This is only used when multiple files with similar names exist.
*          Examples: Stuff-2024-2-13.txt, Stuff-2024-18-13.txt, or:
*                    Nonsense1.txt, Nonsense2.txt
*          Sorting by Date would correctly resolve the 1st example
*          regardless of the file system's written order.
*          Sorting by Name, again, would put the files in the correct
*          order.
cFunc = 'GetLatestFile()'
bIsGood = .F.
cStr = gcTestDir + 'Notes\*.txt'
cValue = goFiles.GetLatestFile(cStr)
DO CASE
CASE NOT cValue == gcTestDir + 'Notes\KOSFILES.TXT'
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* GetPath(cFileSpec) - Return the full path for a passed filename
*    Input: cFileSpec - File name to check
*     Retn: The path from the filename (e.g. "\ALI\Abc.fxp" --> '\ALI')
cFunc = 'GetPath()'
bIsGood = .F.
cStr = gcTestDir + 'Notes\KOSFiles.txt'
cValue = goFiles.GetPath(cStr)
DO CASE
CASE NOT cValue == gcTestDir + 'Notes'
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FullPath(cPathSpec) - Return the full path from a partial directory (e.g. "..\..")
*    Input: cPathSpec - Path string to test
*     Retn: The fully qualified directory name (e.g. "E:\ALI\DATA")
cFunc = 'FullPath()'
bIsGood = .F.
cStr = gcTestDir
cValue = goFiles.FullPath(cStr)
DO CASE
CASE NOT cValue == gcTestDir
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* MinPath(cFullSpec, [pcCompareTo]) - Return the minimum path from current or passed directory
*   Input: cFullSpec - Full path or file string to check
*          pcCompareTo - (optional) Directory to compare it to (default =
*                          current directory
*    Retn: The mimimallyy qualified directory name
*      Example: MinPath([E:\ALI\DATA\SAVE], [E:\ALI]) = [DATA\SAVE]
cFunc = 'MinPath()'
bIsGood = .F.
cStr1 = [E:\ALI\Data\Save]
cStr2 = [E:\ALI]
cValue = goFiles.MinPath(cStr1, cStr2)
DO CASE
CASE NOT cValue == [DATA\SAVE\]
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IsADir(cDirName) - Determine whether the passed spec is a directory
*    Input: cDirName - Directory Name in question
*     Retn: .T. if cDirName is a directory, else .F.
cFunc = 'IsADir()'
bIsGood = .F.
cStr1 = [E:\ALI\Data\Save]
cStr2 = [E:\ALI\Junk]
bValue1 = goFiles.IsADir(cStr1)
bValue2 = goFiles.IsADir(cStr2)
DO CASE
CASE NOT (bValue1 AND NOT bValue2)
    ? cFunc + ' bValue was ' + TRANSFORM(bValue, 'Y')
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* MakeDir(cDirName) - Create the passed directory name
*    Input: cDirName - Directory Name to create
*     Retn: .T. if cDirName exists, else .F.
cFunc = 'MakeDir()'
bIsGood = .F.
cStr = gcTestDir + 'TestDir'    && A new directory
bValue = goFiles.MakeDir(cStr)
DO CASE
CASE NOT bValue1
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* MakeAllDirs() - Create the passed directory and, if needed, its parents
*   Input: cDirName - Directory Name to create
*    Retn: .T. if cDirName exists, else .F.
* CAUTION: This must have the full path desired (drive + ':' is OK)
cFunc = 'MakeAllDirs()'
bIsGood = .F.
cStr = gcMainDir + 'JustTryMe\PutItHere\JustSo'
bValue = goFiles.MakeAllDirs(cStr)
DO CASE
CASE NOT (bValue1 OR NOT goFiles.IsADir(cStr))
    ? cFunc + ' bValue was ' + TRANSFORM(bValue) + ;
      ' and goFiles.IsADir() was ' + TRANSFORM(goFiles.IsADir(cStr))
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* RemDir(cDirName) - Remove the passed directory (must be empty)
*    Input: cDirName - Directory Name to remove
*     Retn: .T. if cDirName is removed, else .F.
cFunc = 'RemDir()'
bIsGood = .F.
bValue = goFiles.RemDir(cStr)
DO CASE
CASE NOT bValue1
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* ZapDir(cDirName) - Remove an entire directory tree
*    Input: cDirName - Directory Name to remove
*           nTrySecs - Secs to keep trying (0 = one try only)
*     Retn: .T. if cDirName removed, else .F.
cFunc = 'ZapDir()'
bIsGood = .F.
goFiles.MakeDir(gcTestDir + [TestDir])
goFiles.MakeDir([TestDir\Save])
STRTOFILE('ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'TestDir\Save\Junk.txt')
cStr = 'TestDir'
bValue = goFiles.ZapDir(cStr)
DO CASE
CASE NOT bValue1
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

goFiles.ZapDir(gcMainDir + 'JustTryMe')     && Clean up from MakeAllDirs()

* IncrDirName(cPref, nFileLen) - Return a directory name based on incrementing
*    trailing digits
*    Input: cPref - Directory name's preface text
*           nFileLen - Desired length of filename
*     Retn: Non-existing directory name as Preface + Number
cFunc = 'IncrDirName()'
bIsGood = .F.
cStr = 'IncrDir'
cNewDir = goFiles.IncrDirName('IncrDir', 9)      && Starts at TestDir00
goFiles.MakeDir(cNewDir)
cValue = goFiles.IncrDirName('IncrDir', 9)
goFiles.RemDir(cNewDir)
DO CASE
CASE NOT cValue == 'INCRDIR01'
    ? cFunc + ' cValue was ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* UniqueDirName(cDir) - Return a temporary directory name that doesn't exist
*    Input: cDir - Parent directory name (default = '.\')
*     Retn: A unique 8-character folder  name not on cDir
cFunc = 'UniqueDirName()'
bIsGood = .F.
cStr = 'IncrDir'
cNewDir = goFiles.UniqueDirName()
bIsDir = goFiles.IsADir(cNewDir)
DO CASE
CASE bIsDir
    ? cFunc + ' Dir: ' + cNewDir + ' exists'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'FileNames:'
? '----------'

* UniqueTempName(cExt, [cDir]) - Return a temporary filename that doesn't exist
*    Input: cExt - The file extension that will be used
*           cDir - The directory for the file (default = '.\')
*     Retn: A unique 8-character filename not on cDir with cExt
cFunc = 'UniqueTempName()'
bIsGood = .F.
cNewFile = goFiles.UniqueTempName('txt') + '.txt'
DO CASE
CASE FILE(cNewFile)
    ? cFunc + ' File: ' + cNewFile + ' exists'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* JustPath(cPathSpec) - Return only the path from the passed spec
*    Input: cPathSpec - Path/file string to test
*     Retn: Only the drive and directory part of cPathSpec
cFunc = 'JustPath()'
bIsGood = .F.
cFile = gcTestDir + 'Notes\KOSFiles.txt'
cPath = goFiles.JustPath(cFile)
DO CASE
CASE NOT cPath = gcTestDir + 'Notes'
    ? cFunc + ' Path was ' + cPath
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* JustFile(cFileSpec) - Return only the file name/extension from the passed filespec
*    Input: cFileSpec - File string to test
*     Retn: Only the file name/ext part of cFileSpec
cFunc = 'JustFile()'
bIsGood = .F.
cFileName = goFiles.JustFile(cFile)
DO CASE
CASE NOT cFileName = 'KOSFiles.txt'
    ? cFunc + ' File Name was ' + cFileName
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* JustFName(cFileSpec) - Return only the file name (no ext) from the passed filespec
*    Input: cFileSpec - File string to test
*     Retn: Only the file name (no ext) part of cFileSpec
cFunc = 'JustFName()'
bIsGood = .F.
cFileName = goFiles.JustFName(cFile)
DO CASE
CASE NOT cFileName = 'KOSFiles'
    ? cFunc + ' File Stem was ' + cFileName
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* JustFExt(cFileSpec) - Return only the extension from the passed filespec
*    Input: cFileSpec - File string to test
*     Retn: Only the file ext part of cFileSpec
cFunc = 'JustFExt()'
bIsGood = .F.
cFileName = goFiles.JustFExt(cFile)
DO CASE
CASE NOT cFileName = 'txt'
    ? cFunc + ' File Ext was ' + cFileName
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IncrFName(cPref, cExt, cDir) - Return a filename setting the filename based on the next number
*     Input: cPref - Filename preface text
*           cExt - File's extension
*           cDir - Destination directory for file
*     Retn: Non-existing filename as Preface + Number + .Ext
cFunc = 'IncrFName()'
bIsGood = .F.
cStr = 'File'
cFileName = goFiles.IncrFName(cStr, 'txt', '.\')
DO CASE
CASE NOT cFileName = 'File1.txt'
    ? cFunc + ' New file name was ' + cFileName
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IncrFName0(cPref, cExt, cDir) - Return a filename defined based on 0s + the next number
*    Input: cPref - Filename preface text
*           cExt - File's extension
*           cDir - Destination directory for file
*           nMaxDigits - (optional) Max digits to use (def: name = 8)
*     Retn: Non-existing filename as Preface + Number + .Ext
cFunc = 'IncrFName0()'
bIsGood = .F.
cStr = 'File'
cFileName = goFiles.IncrFName0(cStr, 'txt', '.\', 3)
DO CASE
CASE NOT cFileName = 'File001.txt'
    ? cFunc + ' New file name was ' + cFileName
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* IncrFExt(cFileSpec) - Return a filename setting the extension based on the
*       next number based on existing files
*    Input: cFileSpec - File Specification including directory (no extension)
*     Retn: Non-existing filename as cFileSpec + .NewExt
cFunc = 'IncrFExt()'
bIsGood = .F.
STRTOFILE('abcdefg', 'File.000')
cStr = 'File.000'
cFileName = goFiles.IncrFExt(cStr)
DO CASE
CASE NOT cFileName = 'File.001'
    ? cFunc + ' New file name was ' + cFileName
OTHERWISE
    bIsGood = .T.
    ERASE FILE.000
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'File Manipulations:'
? '-------------------'

* GetFileDescription(cDirName, [cFileName]) - Return a file's information in an object
*    Input: cDirName - Directory Name (can also have file name)
*           cFileName - (optional) File name (without path)
*     Retn: File description object; properties:
*            .cFileName (no path but with extension)
*            .cExt - file extension
*            .dDate - file date
*            .cTime - file time
*            .nSize - file size (bytes)
*            .cAttrib - file attributes in RHSDA format
*            .cPath - directory for file (with trailing backslash)
*            .bFound - .T. if file found
cFunc = 'GetFileDescription()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
oFile = goFiles.GetFileDescription(cStr)
DO CASE
CASE NOT (oFile.cFileName = 'CATEGORIES.TXT' AND oFile.nSize = 661 ;
  AND oFile.bFound)
    ? cFunc + ' File name was ' + oFile.cFileName + ;
      ', Size was ' + TRANSFORM(oFile.nSize) + ;
      ', bFound was ' + TRANSFORM(oFile.bFound, 'Y')
OTHERWISE
    bIsGood = .T.
    ERASE FILE.000
ENDCASE
ShowResult(cFunc, bIsGood)

* FindFirstFile(cPathSpec) - Return an object containing the FIRST file's info
*       in a dir
*    Input: cPathSpec - Path/file spec string
*     Retn: File description object, see GetFileDescription()
cFunc = 'FindFirstFile()'
bIsGood = .F.
cStr = 'Notes\*.txt'
oFile = goFiles.FindFirstFile(cStr)
DO CASE
CASE NOT oFile.cFileName == 'CATEGORIES.TXT'
    ? cFunc + ' File name was ' + oFile.cFileName
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FindNextFile(cPathSpec) - Return an object containing the NEXT file's info in a dir
*    Input: cPathSpec - Path/file spec string - same as FindFirstFile()
*     Retn: File description object, see GetFileDescription()
cFunc = 'FindNextFile()'
bIsGood = .F.
cStr = 'Notes\*.txt'
oFile = goFiles.FindNextFile(cStr)
DO CASE
CASE NOT oFile.cFileName == 'KOSFILES.TXT'
    ? cFunc + ' File name was ' + oFile.cFileName
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* WaitForFile(cPathSpec) - Return when a file has finished being created
*    Input: cPathSpec - Path/file spec string
*           nLimitSecs - Max. seconds to wait
*     Retn: .T. if file found, else .F.
* Unfortunately, this requires an external process to create the file, so we
*   can't test this here.

* IsAFile(cFileName) - Return .T. if the passed file spec exists (wild cards OK)
*    Input: cFileName - File Name in question
*     Retn: .T. if cFileName is a file, else .F.
cFunc = 'IsAFile()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
bValue = goFiles.IsAFile(cStr)
DO CASE
CASE NOT bValue
    ? cFunc + ' File was not found'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FileSize(cFileNm) - Return the size of a file
*    Input: cFileNm - File name in question
*     Retn: File Size (N)
cFunc = 'FileSize()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
nValue = goFiles.FileSize(cStr)
DO CASE
CASE NOT nValue == 661
    ? cFunc + ' File size was: ' + TRANSFORM(nValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FileDate(cFileNm) - Return a file's date
*    Input: cFileNm - File name in question
*     Retn: File Date (D)
cFunc = 'FileDate()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
dValue = goFiles.FileDate(cStr)
DO CASE
CASE NOT dValue == {5/20/2025}
    ? cFunc + ' File date was: ' + DTOC(dValue)
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FileTime(cFileNm) - Return a file's time
*    Input: cFileNm - File name in question
*     Retn: File Time (C>
cFunc = 'FileTime()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
cValue = goFiles.FileTime(cStr)
DO CASE
CASE NOT cValue == '10:25:24'
    ? cFunc + ' File time was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* FileAttr(cFileNm) - Return a file's attributes
*    Input: cFileNm - File name in question
*     Retn: Attributes (C)
cFunc = 'FileAttr()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
cValue = goFiles.FileAttr(cStr)
DO CASE
CASE NOT cValue == 'A'
    ? cFunc + ' File attribute was: ' + cValue
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* SetFileAttrs(cFileNm) - Change a file's attributes
*    Input: cFileNm - File name in question
*           Desired new Attributes (C): A, R, H, S - singly or mixed together
*     Retn: .T. if set properly
cFunc = 'SetFileAttrs()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
cValue = goFiles.SetFileAttrs(cStr, 'RA')
cValue = goFiles.FileAttr(cStr)
DO CASE
CASE NOT cValue == 'RA'
    ? cFunc + ' File attribute was: ' + cValue
OTHERWISE
    bIsGood = .T.
    cValue = goFiles.SetFileAttrs(cStr, 'A')
ENDCASE
ShowResult(cFunc, bIsGood)

* CopyFile(cSrcFile, [cDstDir, [bUseTemp, [bNoBugFileWanted]]]) - Copy a file from one directory to another
*    Input: cSrcFile - Source file spec (name and dir as needed)
*           cDstDir - Destination file spec (can include filename)
*           bUseTemp - .T. if copy is to be done to a temp file, then renamed
*           bNoBugFileWanted - if a error will return .F. (not bug file created)
*     Retn: .T. if copy succeeded, else .F.
cFunc = 'CopyFile()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
cDest = 'Notes\CrappyCopy.txt'
bValue = goFiles.CopyFile(cStr, cDest, .F., .T.)
DO CASE
CASE NOT (bValue AND FILE(cDest))
    ? cFunc + ' File copy NOT successful.'
OTHERWISE
    bIsGood = .T.
    ERASE Notes\CrappyCopy.txt
ENDCASE
ShowResult(cFunc, bIsGood)

* CopyAllFiles(cFilSpec, cDstDir) - Copy file matching a passed spec from one directory to another
*    Input: cFilSpec - File spec including path and wildcards (can be *.*)
*           cDstDir - Destination file spec (can include filename)
*     Retn: Number of files copied (0 if none)
cFunc = 'CopyAllFiles()'
bIsGood = .F.
cStr = 'Notes\*.txt'
MD Junk
cDest = 'Junk'
nValue = goFiles.CopyAllFiles(cStr, cDest)
cValue = goFiles.FileList('Junk', '*.*')
DO CASE
CASE NOT (nValue = 2 AND cValue == 'CATEGORIES.TXT,KOSFILES.TXT')
    ? cFunc + ' nValue was ' + TRANSFORM(nValue) + ;
      ' and file list was: ' + cValue
OTHERWISE
    bIsGood = .T.
    goFiles.ZapDir(cDest)
ENDCASE
ShowResult(cFunc, bIsGood)

* MoveFile(cSrcFile, [cDstDir, [bUseTemp, [bNoBugFileWanted]]]) - Move a file from one drive/directory to another
*    Input: cSrcFile - Source file spec (name and dir as needed)
*           cDstDir - Destination file spec (can include filename)
*           bUseTemp - .T. if copy is to be done to a temp file, then renamed
*           bNoBugFileWanted - if a error will return .F. (not bug file created)
*     Retn: .T. if move succeeded, else .F.
cFunc = 'MoveFile()'
bIsGood = .F.
cStr = gcMainDir + 'README.md'
cDest = gcTestDir + 'Notes'
bValue = goFiles.MoveFile(cStr, cDest)
bGotFile = FILE(cDest + '\README.md')
DO CASE
CASE NOT (bValue AND bGotFile)
    ? cFunc + ' bValue was ' + TRANSFORM(bValue, 'Y') + ;
      ' and ..\README.md ' + TRANSFORM(bGotFile, 'Y')
OTHERWISE
    bIsGood = .T.
    bValue = goFiles.MoveFile(cDest + '\README.md', '..\')
ENDCASE
ShowResult(cFunc, bIsGood)

* RenameFile(cFileName, cNewName) - Rename a passed filename
*    Input: cFileName - File to rename (can include path)
*           cNewName - New name for the file
*     Retn: .T. if file renamed (.F. if not)
cFunc = 'RenameFile()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
cDest = 'Notes\CrappyCopy.txt'
goFiles.CopyFile('Notes\Categories.txt', cDest, .F., .T.)
bValue = goFiles.RenameFile(cDest, 'GreatCopy.txt')
bGotFile = FILE('Notes\GreatCopy.txt')
DO CASE
CASE NOT bGotFile
    ? cFunc + ' GreatCopy.txt was not found'
OTHERWISE
    bIsGood = .T.
    ERASE Notes\GreatCopy.txt
ENDCASE
ShowResult(cFunc, bIsGood)

* DeleteFile(cDelFile) - Delete a passed filename
*    Input: cDelFile - File to delete (can include path)
*     Retn: .T. if file deleted (.F. if not)
cFunc = 'DeleteFile()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
cDest = 'Notes\CrappyCopy.txt'
goFiles.CopyFile('Notes\Categories.txt', cDest, .F., .T.)
bValue = goFiles.DeleteFile(cDest)
bGotFile = FILE(cDest)
DO CASE
CASE NOT (bValue AND NOT bGotFile)
    ? cFunc + ' ' + cDest + ' was deleeed'
OTHERWISE
    bIsGood = .T.
ENDCASE
ShowResult(cFunc, bIsGood)

* DeleteAllFiles(cDelSpec) - Delete all files matching a passed file spec
*    Input: cDelSpec - File spec including path and wildcards (can be *.*)
*     Retn: Number of files deleted (0 if none)
cFunc = 'DeleteAllFiles()'
bIsGood = .F.
cStr = 'Notes\*.txt'
MD Junk
cDest = 'Junk'
goFiles.CopyAllFiles(cStr, cDest)
nValue = goFiles.DeleteAllFiles(cDest + '\*.*')
cValue = goFiles.FileList('Junk', '*.*')
DO CASE
CASE NOT (nValue = 2 AND cValue == '')
    ? cFunc + ' Files found: ' + cValue
OTHERWISE
    bIsGood = .T.
    RD JUNK
ENDCASE
ShowResult(cFunc, bIsGood)

?
? 'Low-level file functions:'
? '-------------------------'
* LL_Open(cFileName, [cAction]) - Return "handle" after create/open a "low-level" read/write file
*    Input: cFileName - File name to open
*           cAction - (optional) 'W' (default) = Read/Write, 'R' = Read Only,
*                        'P' = Purge the file's contents (implies R/W)
*     Retn: The file "handle" needed for future references to this file
*           The error handler is called if open fails
cFunc = 'LL_Open()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
nHandle = goFiles.LL_Open(cStr, 'W')
DO CASE
CASE nHandle = -1
    ? cFunc + ' File: ' + cStr + ' could not be opened'
OTHERWISE
    bIsGood = .T.
    FCLOSE(nHandle)
ENDCASE
ShowResult(cFunc, bIsGood)

* LL_Read(nLLHndl, [bStripCRLF [,nBytes2Read]]) - Read a line from a low-level file
*    Input: nLLHndl - Previously opened file handle
*           bStripCRLF - (optional) If .T., strip CR, LF from end of line
*           nBytes2Read - (optional) No. of bytes desired (default = 254)
*     Retn: One line read from the file (if FEOF(), returns null string)
*           The error handler is called if handle is invalid
cFunc = 'LL_Read()'
bIsGood = .F.
cStr = 'Notes\Categories.txt'
nHandle = goFiles.LL_Open(cStr, 'W')
cText = goFiles.LL_Read(nHandle, .T.)
DO CASE
CASE NOT cText == 'Category Table:'
    ? cFunc + ' cText was ' + cText
OTHERWISE
    bIsGood = .T.
    FCLOSE(nHandle)
ENDCASE
ShowResult(cFunc, bIsGood)

* LL_Write(nLLHndl, cWriteStr  [,bNoCrLf]) - Write a string to a low-level file
*    Input: nLLHndl - Previously opened file handle
*           cWriteStr - String to be written
*           bNoCrLf - (optional) If .T., no CR, LF's are added
*     Retn: .T.; string written adding CR, LF if desired.
*           Error handler called if incorrect number of bytes written or
*             handle is invalid.
cFunc = 'LL_Write()'
bIsGood = .F.
cStr = 'Notes\Junk.txt'
nHandle = goFiles.LL_Open(cStr, 'W')
cText = 'This is just junk.'
bValue = goFiles.LL_Write(nHandle, cText)
DO CASE
CASE NOT bValue
    ? cFunc + ' No text was written.'
OTHERWISE
    bIsGood = .T.
    FCLOSE(nHandle)
    ERASE &cStr
ENDCASE
ShowResult(cFunc, bIsGood)

* LL_Flush(nLLHndl, [bForceIt]) - Flush a low-level file
*   Input: nLLHndl - Previously opened file handle
*          bForceIt - .T. = Force Windows to flush now, .F. = let VFP do
*                      it at its convenience
*    Retn: .T. and file Flushed.
cFunc = 'LL_Flush()'
bIsGood = .F.
cStr = 'Notes\Junk.txt'
nHandle = goFiles.LL_Open(cStr, 'W')
cText = 'This is just junk.'
goFiles.LL_Write(nHandle, cText)
bValue = goFiles.LL_Flush(nHandle, .T.)
DO CASE
CASE NOT bValue
    ? cFunc + ' Text was not flushed.'
OTHERWISE
    bIsGood = .T.
    FCLOSE(nHandle)
    ERASE &cStr
ENDCASE
ShowResult(cFunc, bIsGood)

* LL_Close(nLLHndl) - Close a low-level file
*    Input: nLLHndl - Previously opened file handle
*     Retn: .T.; file closed.
*           Error handler called if close fails.
cFunc = 'LL_Close()'
bIsGood = .F.
cStr = 'Notes\Junk.txt'
nHandle = goFiles.LL_Open(cStr, 'W')
cText = 'This is just junk.'
goFiles.LL_Write(nHandle, cText)
bValue = goFiles.LL_Close(nHandle)
DO CASE
CASE NOT bValue
    ? cFunc + ' File was not closed.'
OTHERWISE
    bIsGood = .T.
    ERASE &cStr
ENDCASE
ShowResult(cFunc, bIsGood)

* LL_ToBOF(nLLHndl) - Position a low-level file to FBOF()
*    Input: nLLHndl - Previously opened file handle
*     Retn: Number of bytes moved; file is at beginning.
*           The error handler is called if handle is invalid
cFunc = 'LL_ToBOF()'
bIsGood = .F.
cStr = 'Notes\Junk.txt'
nHandle = goFiles.LL_Open(cStr, 'W')
cText = 'This is just junk.'
goFiles.LL_Write(nHandle, cText)
goFiles.LL_ToBOF(nHandle)
cTextIn = goFiles.LL_Read(nHandle, .T.)
bValue = goFiles.LL_Close(nHandle)
DO CASE
CASE NOT cText == cTextIn
    ? cFunc + ' cText was ' + cTextIn
OTHERWISE
    bIsGood = .T.
    ERASE &cStr
ENDCASE
ShowResult(cFunc, bIsGood)

* LL_ToEOF(nLLHndl) - Position a low-level file to FEOF()
*    Input: nLLHndl - Previously opened file handle
*     Retn: Number of bytes moved; file is at FEOF().
*           The error handler is called if handle is invalid
cFunc = 'LL_ToEOF()'
bIsGood = .F.
cStr = 'Notes\Junk.txt'
nHandle = goFiles.LL_Open(cStr, 'W')
cText = 'This is just junk.'
goFiles.LL_Write(nHandle, cText)
goFiles.LL_ToEOF(nHandle)
cTextIn = goFiles.LL_Read(nHandle, .T.)
bValue = goFiles.LL_Close(nHandle)
DO CASE
CASE NOT EMPTY(cTextIn)
    ? cFunc + ' cText was ' + cTextIn
OTHERWISE
    bIsGood = .T.
    ERASE &cStr
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
