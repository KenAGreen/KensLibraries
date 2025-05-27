#IF 0                          KOSFiles.prg

  Purpose:  General purpose OS Drive, Directory and File handling.

Revisions:  March 20, 1999 - Ken Green - Original to 10/14/24
             5/23/2025 - Special VFPX Edition

 Requires:  zArrays.prg - ArrayObj classes used for DirInfo()

******************************* Program Notes *******************************

    KOSFILES is just a front-end object for a function collection.  The
oOSFiles object was initialized earlier.  So, calls to this are really just
method invocations.  For example, to open a low-level file for read-write
operations, you'd call this like:
        nHandle = goFiles.LL_Open(cFileName)

****************************** Classes Defined ******************************

* KOSFiles Class Definition for this function class

***************************** Available Methods *****************************

Drives:

 IsDrive() - Return .T. if passed drive letter is a valid drive
    Input: cDrvLtr - Drive letter in question
     Retn: .T. if cDirName is a valid drive, else .F.

 GetDriveFreeSpace() - Return a drive's free space in bytes
   Input: cDrvLtr - Drive letter in question (can have trailing colon)
    Retn: Free space on drive in bytes

 JustDrive() - Return only the drive and colon from the passed path/filespec
    Input: cFileSpec - Path/File string to test
     Retn: Only the Drive and : part of cFileSpec


Directories:

 DirInfo() - Return an array object of file/dir information for a directory
    Input: cDirSpec - Path for files (can be empty)
           cFileSpec - File Spec (default = '*.*')
           bSubdirs - .T. if you want subdirectories also
     Retn: DirArray object for passed directory with the following format:
                .aRA[x,1] - File name (C) (includes extension)
                .aRA[x,2] - File size (N):
                .aRA[x,3] - File date (D)
                .aRA[x,4] - File Time (C)
                .aRA[x,5] - File Attributes (C):
                      Letter        Attribute
                      컴컴컴        컴컴컴컴�
                        A            Archive (Read and Write)
                        H            Hidden
                        R            Read only
                        S            System
                        D            Directory

 DirListOnly() - Return an array object of dir information for a passed spec
    Input: cDirSpec - Path for directories (can be empty for current dir)
           bNoSort - Pass .T. if you don't want the list sorted by name
     Retn: DirArray object for passed directory with the following format:
                .aRA[x,1] - File name (C) (includes extension)
                .aRA[x,2] - File size (N):
                .aRA[x,3] - File date (D)
                .aRA[x,4] - File Time (C)
                .aRA[x,5] - File Attributes (C):
                      Letter        Attribute
                      컴컴컴        컴컴컴컴�
                        A            Archive (Read and Write)
                        H            Hidden
                        R            Read only
                        S            System
                        D            Directory

 AnyFiles() - Return .T. if any files exist matching the passed filespec
    Input: cFileSpec - File Specification (e.g. "*.TXT" OR "JUNK??.TXT")
     Retn: .T. If any files exist that match the spec

 FileList() - Return a list of files matching passed specs as file1,file2...
    Input: cDirSpec - Path string to get files from (can be empty)
           cFileSpec - File Specification (e.g. *.TXT)
           bKillExt - (optional) .T. if ext is to be removed from filename
     Retn: List of files as file1,file2,...

 CheckLastSep() - Make sure the passed path has a trailing \, or remove it
    Input: cPath - Path string to test
           bKillSep - If .T. last \ is removed if it's there
     Retn: cPath with (or without) a trailing \

 CheckDirSep() - Return the passed path with all directory separators as \
    Input: cPath - Path string to test
     Retn: cPath with all directory separators as \

 LastDirPosn() - Return the last drive or directory separator position
    Input: cPath - Path string to test
     Retn: Position of last directory separator: \ or :

 GetLatestFile() - Return the latest file name for a file spec
   Input: cDirSpec - Path and file spec, such as: E:\XFER\Ken*.zip
          pcSortType - Date (default) or Name
    Retn: The latest file based on the passed file spec
   Notes: This is only used when multiple files with similar names exist.
          Examples: Stuff-2024-2-13.txt, Stuff-2024-18-13.txt, or:
                    Nonsense1.txt, Nonsense2.txt
          Sorting by Date would correctly resolve the 1st example
          regardless of the file system's written order.
          Sorting by Name, again, would put the files in the correct
          order.

 GetPath() - Return the full path for a passed filename
    Input: cFileSpec - File name to check
     Retn: The path from the filename (e.g. "\ALI\Abc.fxp" --> '\ALI')

 FullPath() - Return the full path from a partial directory (e.g. "..\..")
    Input: cPathSpec - Path string to test
     Retn: The fully qualified directory name (e.g. "E:\ALI\DATA")

 MinPath() - Return the minimum path from current or passed directory
   Input: cFullSpec - Full path or file string to check
          cCompareTo - (optional) Directory to compare it to (default =
                          current directory
    Retn: The mimimallyy qualified directory name
      Example: MinPath([E:\ALI\DATA\SAVE], [E:\ALI]) = [DATA\SAVE]

 IsADir() - Determine whether the passed spec is a directory
    Input: cDirName - Directory Name in question
     Retn: .T. if cDirName is a directory, else .F.

 MakeDir() - Create the passed directory name
    Input: cDirName - Directory Name to create
     Retn: .T. if cDirName exists, else .F.

 MakeAllDirs() - Create the passed directory and, if needed, its parents
   Input: cDirName - Directory Name to create
    Retn: .T. if cDirName exists, else .F.
 CAUTION: This must have the full path desired (drive + ':' is OK)

 RemDir() - Remove the passed directory (must be empty)
    Input: cDirName - Directory Name to remove
     Retn: .T. if cDirName is removed, else .F.

 ZapDir() - Remove an entire directory tree
    Input: cDirName - Directory Name to remove
           nTrySecs - Secs to keep trying (0 = one try only)
     Retn: .T. if cDirName removed, else .F.

 IncrDirName() - Return a directory name based on incrementing trailing digits
    Input: cPref - Directory name's preface text
           nFileLen - Desired length of filename
     Retn: Non-existing directory name as Preface + Number

 UniqueDirName() - Return a temporary directory name that doesn't exist
    Input: cDir - Parent directory name (default = '.\')
     Retn: A unique 8-character folder  name not on cDir


FileNames:

 UniqueTempName() - Return a temporary filename that doesn't exist
    Input: cExt - The file extension that will be used
           cDir - The directory for the file (default = '.\')
     Retn: A unique 8-character filename not on cDir with cExt

 JustPath() - Return only the path from the passed spec
    Input: cPathSpec - Path/file string to test
     Retn: Only the drive and directory part of cPathSpec

 JustFile() - Return only the file name/extension from the passed filespec
    Input: cFileSpec - File string to test
     Retn: Only the file name/ext part of cFileSpec

 JustFName() - Return only the file name (no ext) from the passed filespec
    Input: cFileSpec - File string to test
     Retn: Only the file name (no ext) part of cFileSpec

 JustFExt() - Return only the extension from the passed filespec
    Input: cFileSpec - File string to test
     Retn: Only the file ext part of cFileSpec

 IncrFName() - Return a filename setting the filename based on the next number
    Input: cPref - Filename preface text
           cExt - File's extension
           cDir - Destination directory for file
     Retn: Non-existing filename as Preface + Number + .Ext

 IncrFName0() - Return a filename defined based on 0s + the next number
    Input: cPref - Filename preface text
           cExt - File's extension
           cDir - Destination directory for file
           nMaxDigits - (optional) Max digits to use (def: name = 8)
     Retn: Non-existing filename as Preface + Number + .Ext

 IncrFExt() - Return a filename setting the extension based on the next number
    Input: cFileSpec - File Specification including directory (no extension)
     Retn: Non-existing filename as cFileSpec + .NewExt


File Manipulations:

 GetFileDescription() - Return a file's information in an object
    Input: cDirName - Directory Name (can also have file name)
           cFileName - (optional) File name (without path)
     Retn: File description object; properties:
            .cFileName (no path but with extension)
            .cExt - file extension
            .dDate - file date
            .cTime - file time
            .nSize - file size (bytes)
            .cAttrib - file attributes in RHSDA format
            .cPath - directory for file (with trailing backslash)
            .bFound - .T. if file found

 FindFirstFile() - Return an object containing the FIRST file's info in a dir
    Input: cPathSpec - Path/file spec string
     Retn: File description object, see GetFileDescription()

 FindNextFile() - Return an object containing the NEXT file's info in a dir
    Input: cPathSpec - Path/file spec string - same as FindFirstFile()
     Retn: File description object, see GetFileDescription()

 WaitForFile() - Return when a file has finished being created
    Input: cPathSpec - Path/file spec string
           nLimitSecs - Max. seconds to wait
     Retn: .T. if file found, else .F.

 IsAFile() - Return .T. if the passed file spec exists (wild cards OK)
    Input: cFileName - File Name in question
     Retn: .T. if cFileName is a file, else .F.

 FileSize() - Return the size of a file
    Input: cFileNm - File name in question
     Retn: File Size (N)

 FileDate() - Return a file's date
    Input: cFileNm - File name in question
     Retn: File Date (D)

 FileTime() - Return a file's time
    Input: cFileNm - File name in question
     Retn: File Time (C>

 FileAttr() - Return a file's attributes
    Input: cFileNm - File name in question
     Retn: Attributes (C)

 SetFileAttrs() - Change a file's attributes
    Input: cFileNm - File name in question
           Desired new Attributes (C): A, R, H, S - singly or mixed together
     Retn: .T. if set properly

 CopyFile() - Copy a file from one directory to another
    Input: cSrcFile - Source file spec (name and dir as needed)
           cDstDir - Destination file spec (can include filename)
           bUseTemp - .T. if copy is to be done to a temp file, then renamed
           bNoBugFileWanted - if a error will return .F. (not bug file created)
     Retn: .T. if copy succeeded, else .F.

 CopyAllFiles() - Copy file matching a passed spec from one directory to another
    Input: cFileSpec - File spec including path and wildcards (can be *.*)
           cDstDir - Destination file spec (can include filename)
     Retn: Number of files copied (0 if none)

 MoveFile() - Move a file from one drive/directory to another
    Input: cSrcFile - Source file spec (name and dir as needed)
           cDstDir - Destination file spec (can include filename)
           bUseTemp - .T. if copy is to be done to a temp file, then renamed
           bNoBugFileWanted - if a error will return .F. (not bug file created)
     Retn: .T. if move succeeded, else .F.

 RenameFile() - Rename a passed filename
    Input: cFileName - File to rename (can include path)
           cNewName - New name for the file
     Retn: .T. if file renamed (.F. if not)

 DeleteFile() - Delete a passed filename
    Input: cDelFile - File to delete (can include path)
     Retn: .T. if file deleted (.F. if not)

 DeleteAllFiles() - Delete all files matching a passed file spec
    Input: cDelSpec - File spec including path and wildcards (can be *.*)
     Retn: Number of files deleted (0 if none)


Low-level file functions:

 LL_Open() - Return "handle" after create/open a "low-level" read/write file
    Input: cFileName - File name to open
           cAction - (optional) 'W' (default) = Read/Write, 'R' = Read Only,
                        'P' = Purge the file's contents (implies R/W)
     Retn: The file "handle" needed for future references to this file
           The error handler is called if open fails

 LL_Read() - Read a line from a low-level file
    Input: nLLHndl - Previously opened file handle
           bStripCRLF - (optional) If .T., strip CR, LF from end of line
           nBytes2Read - (optional) No. of bytes desired (default = 254)
     Retn: One line read from the file (if FEOF(), returns null string)
           The error handler is called if handle is invalid

 LL_Write() - Write a string to a low-level file
    Input: nLLHndl - Previously opened file handle
           cWriteStr - String to be written
           bNoCrLf - (optional) If .T., no CR, LF's are added
     Retn: .T.; string written adding CR, LF if desired.
           Error handler called if incorrect number of bytes written or
             handle is invalid.

 LL_Flush() - Flush a low-level file
   Input: nLLHndl - Previously opened file handle
          bForceIt - .T. = Force Windows to flush now, .F. = let VFP do
                      it at its convenience
    Retn: .T. and file Flushed.

 LL_Close() - Close a low-level file
    Input: nLLHndl - Previously opened file handle
     Retn: .T.; file closed.
           Error handler called if close fails.

 LL_ToBOF() - Position a low-level file to FBOF()
    Input: nLLHndl - Previously opened file handle
     Retn: Number of bytes moved; file is at beginning.
           The error handler is called if handle is invalid

 LL_ToEOF() - Position a low-level file to FEOF()
    Input: nLLHndl - Previously opened file handle
     Retn: Number of bytes moved; file is at FEOF().
           The error handler is called if handle is invalid

 LL_IsLock() - Return .T. if the file is locked
    Input: cFileName - File name to locked
     Retn: .T. is return is the file is locked

 Release() - Removes this object from memory
    Input: none
     Retn: object gone, memory released

*****************************************************************************
#ENDIF

* Defines
#DEFINE CR           CHR(13)
#DEFINE LF           CHR(10)
#DEFINE CR_LF       CHR(13) + CHR(10)
#DEFINE OS_ADDCRLF  .F.
#DEFINE OS_NOCRLF   .T.

* FormatMessage() parameters (WinAPI)
#DEFINE FORMAT_MESSAGE_ALLOCATE_BUFFER 0x100
#DEFINE FORMAT_MESSAGE_ARGUMENT_ARRAY 0x2000
#DEFINE FORMAT_MESSAGE_FROM_STRING 0x400
#DEFINE FORMAT_MESSAGE_FROM_SYSTEM 0x1000
#DEFINE FORMAT_MESSAGE_IGNORE_INSERTS 0x200
#DEFINE FORMAT_MESSAGE_MAX_WIDTH_MASK 0xFF

* File Attributes (WinAPI)
#DEFINE FILE_ATTRIBUTE_READONLY       1
#DEFINE FILE_ATTRIBUTE_HIDDEN         2
#DEFINE FILE_ATTRIBUTE_SYSTEM         4
#DEFINE FILE_ATTRIBUTE_DIRECTORY     16
#DEFINE FILE_ATTRIBUTE_ARCHIVE       32
#DEFINE FILE_ATTRIBUTE_NORMAL       128
#DEFINE FILE_ATTRIBUTE_TEMPORARY    512
#DEFINE FILE_ATTRIBUTE_COMPRESSED  2048

* KOSFiles Class Definition for this function class
DEFINE CLASS KOSFiles AS Custom

    * Custom Properties
    Name = 'KOSFiles'
    bHandle1705 = .F.       && .T. if we're to handle 1705 - Access Denied errors
    nLastErrorNumb = 0          && API Error Code
    cLastErrorMsg = ''          && API Error Message

    * Block the Properties not relevant here
    PROTECTED Application, ClassLibrary, Comment, ControlCount, Controls, ;
      Height, HelpContextID, Left, Object, Picture, Tag, Top, WhatsThisHelpID, ;
      Width

    * Block the Methods not relevant here
    PROTECTED AddObject, AddProperty, NewObject, ReadExpression, ReadMethod, ;
      RemoveObject, ResetToDefault, SaveAsClass, ShowWhatsThis, ;
      WriteExpression, WriteMethod

    * Custom Methods (see list above).

    * Init() - Set ourselves up
    FUNCTION Init()
        LOCAL bRetVal
        m.bRetVal = DODEFAULT()
        NODEFAULT

        * Add our WinAPI Declarations
        DECLARE INTEGER CopyFile IN kernel32 ;
          STRING lpExistingFileName, STRING lpNewFileName, INTEGER bFailIfExists
        DECLARE INTEGER DeleteFile IN kernel32 STRING lpFileName

        DECLARE INTEGER FormatMessage IN kernel32 INTEGER dwFlags, ;
          INTEGER lpSource, INTEGER dwMessageId, INTEGER dwLanguageId, ;
          INTEGER @lpBuffer, INTEGER nSize, INTEGER Arguments
        DECLARE RtlMoveMemory IN kernel32 As CopyMemory ;
          STRING @Destination, INTEGER Source, INTEGER nLength
        DECLARE INTEGER LocalFree IN kernel32 INTEGER hMem

        DECLARE INTEGER GetFileAttributes IN kernel32 STRING lpFileName
        DECLARE SHORT SetFileAttributes IN kernel32 STRING lpFileName, ;
          INTEGER dwFileAttributes

        DECLARE INTEGER GetLastError IN kernel32

        * Done
        RETURN m.bRetVal
    ENDFUNC

    * IsDrive() - Return .T. if passed drive letter is a valid drive
    *    Input: cDrvLtr - Drive letter in question
    *     Retn: .T. if cDirName is a valid drive, else .F.
    FUNCTION IsDrive(cDrvLtr)
        LOCAL nGoodDrives, bIsOK

        * Toss a trailing : if it's there
        IF ':' $ m.cDrvLtr
            m.cDrvLtr = STRTRAN(m.cDrvLtr, ':', '')
        ENDIF

        * Check for valid parameters
        cDrvLtr = EVL(cDrvLtr, '')
        IF LEN(m.cDrvLtr) > 1
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Get a list of the valid drive letters
        DECLARE INTEGER GetLogicalDrives IN Win32API
        m.nGoodDrives = GetLogicalDrives()

        * Is the passed drive in that list?
        m.bIsOK = BITTEST(m.nGoodDrives, ASC(UPPER(m.cDrvLtr)) - 65)
        RETURN m.bIsOK
    ENDFUNC

    *- GetDriveFreeSpace() - Return a drive's free space in bytes
    *    Input: cDrvLtr - Drive letter in question (can have trailing colon)
    *     Retn: Free space on drive in bytes
    FUNCTION GetDriveFreeSpace(cDrive)
        LOCAL nSpace
        m.nSpace = DISKSPACE(m.cDrive)
        RETURN m.nSpace
    ENDFUNC

    *- JustDrive() - Return only the drive and colon from the passed path/filespec
    *    Input: cFileSpec - Path/File string to test
    *     Retn: Only the Drive and : part of cFileSpec
    FUNCTION JustDrive(cFileSpec)
        LOCAL cRetDrv

        * Check for valid parameters
        m.cFileSpec = EVL(m.cFileSpec, '')
        IF EMPTY(m.cFileSpec)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Check directory separators
        m.cRetDrv = THIS.CheckDirSep(m.cFileSpec)

        * Look for the colon
        IF ':' $ m.cRetDrv
            m.cRetDrv = LEFT(m.cRetDrv, 2)
        ELSE
            m.cRetDrv = SET('DEFAULT')
        ENDIF
        RETURN m.cRetDrv
    ENDFUNC

    *- DirInfo() - Return an array object of file/dir information for a directory
    *     Input: cDirSpec - Path for files (can be empty)
    *            cFileSpec - File Spec (default = '*.*')
    *            xSubdirs - .T. if you want subdirectories also, OR
    *                        your own attribute list (e.g. "AR")
    *      Retn: DirArray object for passed directory with the following format:
    *                 .aRA[x,1] - File name (C) (includes extension)
    *                 .aRA[x,2] - File size (N):
    *                 .aRA[x,3] - File date (D)
    *                 .aRA[x,4] - File Time (C)
    *                 .aRA[x,5] - File Attributes (C):
    *                       Letter        Attribute
    *                       컴컴컴        컴컴컴컴�
    *                         A            Archive (Read and Write)
    *                         H            Hidden
    *                         R            Read only
    *                         S            System
    *                         D            Directory
    FUNCTION DirInfo(cDirSpec, cFileSpec, xSubdirs)
        LOCAL cDirSpec, cAttribs, oDirObj, nRARow

        * Define the directory desired
        IF NOT EMPTY(m.cDirSpec)
            m.cDirSpec = THIS.CheckLastSep(m.cDirSpec)
        ELSE
            m.cDirSpec = '.\'
        ENDIF

        * Define the file spec desired
        IF VARTYPE(m.cFileSpec) = 'C' AND NOT EMPTY(m.cFileSpec)
            m.cDirSpec = m.cDirSpec + m.cFileSpec
        ELSE
            m.cDirSpec = m.cDirSpec + '*.*'
        ENDIF

        * Define the attributes we want
        IF VARTYPE(m.xSubdirs) = 'C' AND NOT EMPTY(m.xSubdirs)
            m.cAttribs = m.xSubdirs
        ELSE
            m.cAttribs = 'AHRS' + IIF(m.xSubdirs, 'D', '')
        ENDIF

        * Get the directory array object
        m.oDirObj = CREATEOBJECT('DirArray', m.cDirSpec, m.cAttribs)

        * If we're getting subdirectories, toss the "." and ".." directories
        IF 'D' $ m.cAttribs
            m.nRARow = m.oDirObj.Locate('.', 1)
            IF m.nRARow > 0
                m.oDirObj.DeleteRow(m.nRARow)
            ENDIF
            m.nRARow = m.oDirObj.Locate('..', 1)
            IF m.nRARow > 0
                m.oDirObj.DeleteRow(m.nRARow)
            ENDIF
        ENDIF

        * Return the object
        RETURN m.oDirObj
    ENDFUNC

    *- DirListOnly() - Return an array object of dir information for a passed spec
    *     Input: cDirSpec - Path for directories (can be empty for current dir)
    *            bNoSort - Pass .T. if you don't want the list sorted by name
    *      Retn: DirArray object for passed directory with the following format:
    *                 .aRA[x,1] - File name (C) (includes extension)
    *                 .aRA[x,2] - File size (N):
    *                 .aRA[x,3] - File date (D)
    *                 .aRA[x,4] - File Time (C)
    *                 .aRA[x,5] - File Attributes (C):
    *                       Letter        Attribute
    *                       컴컴컴        컴컴컴컴�
    *                         A            Archive (Read and Write)
    *                         H            Hidden
    *                         R            Read only
    *                         S            System
    *                         D            Directory
    FUNCTION DirListOnly(cDirSpec, bNoSort)
        LOCAL cDirSpec, cAttribs, oDirObj, nRARow

        * Define the directory desired
        m.cDirSpec = EVL(m.cDirSpec, '')
        IF NOT EMPTY(m.cDirSpec)
            m.cDirSpec = THIS.CheckLastSep(m.cDirSpec, .T.)
        ENDIF

        * Define the attributes we want
        m.cAttribs = 'DR'

        * If a spec was passed, we must change to that directory (VFP will only
        *   give us a directory list if we pass an empty spec)
        m.cCurrDrvDir = ''
        IF NOT EMPTY(m.cDirSpec)
            m.cCurrDrvDir = SET('DEFAULT') + CURDIR()
            SET DEFAULT TO (m.cDirSpec)
        ENDIF

        * Get the directory array object
        m.oDirObj = CREATEOBJECT('DirArray', '', m.cAttribs)

        * Change our directory back
        IF NOT EMPTY(m.cCurrDrvDir)
            SET DEFAULT TO (m.cCurrDrvDir)
        ENDIF

        * As we're getting subdirectories, toss the "." and ".." directories
        m.nRARow = m.oDirObj.Locate('.', 1)
        IF m.nRARow > 0
            m.oDirObj.DeleteRow(m.nRARow)
        ENDIF
        m.nRARow = m.oDirObj.Locate('..', 1)
        IF m.nRARow > 0
            m.oDirObj.DeleteRow(m.nRARow)
        ENDIF

        * Sort the list unless they object
        IF NOT m.bNoSort
            m.oDirObj.Sort(1)
        ENDIF

        * Return the object
        RETURN m.oDirObj
    ENDFUNC

    *- AnyFiles() - Return .T. if any files matching passed specs exist
    *     Input: cFileSpec - File Spec (e.g. junk\*.TXT) can include path
    *      Retn: .T. if any matching files exist
    FUNCTION AnyFiles(cFileSpec)
        LOCAL oFiles, bGotSome

        * Create an array object for the full file spec.
        m.oFiles = CREATEOBJECT("DirArray", m.cFileSpec)
        m.bGotSome = m.oFiles.nRows > 0
        m.oFiles.Release()

        * Done
        RETURN m.bGotSome
    ENDFUNC

    *- FileList() - Return a list of files matching passed specs as file1,file2...
    *    Input: cDirSpec - Path string to get files from (can be empty)
    *           cFileSpec - File Specification (e.g. *.TXT)
    *           bKillExt - (optional) .T. if ext is to be removed from filename
    *     Retn: List of files as file1,file2,...
    FUNCTION FileList (cDirSpec, cFileSpec, bKillExt)
        LOCAL bNoExt, oFiles, cFilesOut, nX, cThisFile

        * Check for valid parameters
        m.cDirSpec = EVL(m.cDirSpec, '')
        m.cFileSpec = EVL(m.cFileSpec, '')
        IF EMPTY(m.cDirSpec + m.cFileSpec)
            ERROR 'Invalid parameters were passed'
        ENDIF
        m.cDirSpec = THIS.CheckLastSep(m.cDirSpec)

        * Are we to kill the extension?
        m.bNoExt = EVL(bKillExt, .F.)

        * Create an array object for the spec.  But, don't check for a
        *   trailing directory separator as this could be "D:*.*" where D:
        *   is a different drive
        m.oFiles = CREATEOBJECT("DirArray", m.cDirSpec + m.cFileSpec)

        * Make a list of all files we found
        m.cFilesOut = ""
        FOR m.nX = 1 TO m.oFiles.nRows
            m.cThisFile = m.oFiles.aRA[m.nX,1]
            IF m.bNoExt
                m.cThisFile = LEFT(m.cThisFile, AT('.', m.cThisFile) - 1)
            ENDIF
            IF NOT EMPTY(m.cThisFile)
                m.cFilesOut = m.cFilesOut + m.cThisFile + ","
            ENDIF
        ENDFOR

        * Done
        m.oFiles.Release()
        IF NOT EMPTY(m.cFilesOut)
            RETURN LEFT(m.cFilesOut, LEN(m.cFilesOut)-1)
        ENDIF
        RETURN m.cFilesOut
    ENDFUNC

    *- CheckLastSep() - Make sure the passed path has a trailing \, or remove it
    *    Input: cPath - Path string to test
    *           bKillSep - If .T. last \ is removed if it's there
    *     Retn: cPath with (or without) a trailing \
    FUNCTION CheckLastSep(cPath, bKillSep)
        LOCAL cRetSpec

        * Check for valid parameters
        m.cPath = EVL(m.cPath, '')
        IF EMPTY(m.cPath)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Handle variants in directory separators
        m.cRetSpec = THIS.CheckDirSep(m.cPath)

        * Check for the last separator
        IF LEN(m.cRetSpec) > 0
            DO CASE
            CASE m.bKillSep AND RIGHT(m.cRetSpec, 1) = '\'
                m.cRetSpec = LEFT(m.cRetSpec, LEN(m.cRetSpec)-1)
            CASE RIGHT(m.cRetSpec, 1) <> '\' AND NOT m.bKillSep
                m.cRetSpec = m.cRetSpec + '\'
            ENDCASE
        ENDIF
        RETURN m.cRetSpec
    ENDFUNC

    *- CheckDirSep() - Return the passed path with all directory separators as \
    *    Input: cPath - Path string to test
    *     Retn: cPath with all directory separators as \
    FUNCTION CheckDirSep(cPath)
        LOCAL cRetSpec

        * Check for valid parameters
        m.cPath = EVL(m.cPath, '')
        IF EMPTY(m.cPath)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Handle variants in directory separators
        m.cRetSpec = STRTRAN(m.cPath, '/', '\')

        * Handle network paths as well
        IF '\\' $ m.cRetSpec
            m.cRetSpec = STRTRAN(m.cRetSpec, '\\', '\')
        ENDIF
        RETURN m.cRetSpec
    ENDFUNC

    *- LastDirPosn() - Return the last drive or directory separator position
    *    Input: cPath - Path string to test
    *     Retn: Position of last directory separator: \ or :
    FUNCTION LastDirPosn(cPath)
        LOCAL nLastSep

        * Check for valid parameters
        m.cPath = EVL(m.cPath, '')
        IF EMPTY(m.cPath)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Find the last directory separator
        m.nLastSep = RAT('\', m.cPath)
        IF m.nLastSep = 0       && No separator, how about a drive?
            m.nLastSep = AT(':', m.cPath)
        ENDIF
        RETURN m.nLastSep
    ENDFUNC

    *- GetLatestFile() - Return the latest file name for a file spec
    *    Input: cDirSpec - Path and file spec, such as: E:\XFER\Ken*.zip
    *           pcSortType - Date (default) or Name
    *     Retn: The latest file based on the passed file spec
    *    Notes: This is only used when multiple files with similar names exist.
    *           Examples: Stuff-2024-2-13.txt, Stuff-2024-18-13.txt, or:
    *                     Nonsense1.txt, Nonsense2.txt
    *           Sorting by Date would correctly resolve the 1st example
    *           regardless of the file system's written order.
    *           Sorting by Name, again, would put the files in the correct
    *           order.
    FUNCTION GetLatestFile(cFileSpec, pcSortType)
        LOCAL cTypeOfSort, oFiles, cRetName

        * Define the sort type
        m.cTypeOfSort = 'Date'
        IF PCOUNT() = 2 AND VARTYPE(m.cSortType) = 'C' AND NOT EMPTY(m.cSortType)
            m.cTypeOfSort = m.pcSortType
        ENDIF

        * Create an array object for the spec.  But, don't check for a
        *   trailing directory separator as this could be "D:*.*" where D:
        *   is a different drive
        m.oFiles = CREATEOBJECT("DirArray", m.cFileSpec)

        * Sort by date
        IF m.oFiles.nRows > 1
            IF UPPER(LEFT(m.cTypeOfSort, 1)) = 'D'
                m.oFiles.Sort(4)      && Time
                m.oFiles.Sort(3)      && Date
            ELSE    && Sort by name: .F. = Ascending, .T. = Case Insensitive
                m.oFiles.Sort(1, .F., .T.)
            ENDIF
        ENDIF

        * Get the latest file name
        WITH m.oFiles
            IF .nRows = 0
                m.cRetName = ''
            ELSE
                m.cRetName = JUSTPATH(m.cFileSpec) + '\' + .aRA[.nRows,1]
            ENDIF
        ENDWITH

        * Done
        RETURN m.cRetName
    ENDFUNC

    *- GetPath() - Return the full path for a passed filename
    *     Input: cFileSpec - File name to check
    *      Retn: The path from the filename (e.g. "\ALI\Abc.fxp" --> '\ALI')
    FUNCTION GetPath(cFileSpec)
        LOCAL cPath

        * Check for valid parameters
        m.cPath = EVL(m.cFileSpec, '')
        IF EMPTY(m.cFileSpec)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Normally, we'd just use JUSTPATH() but, if the path is \, VFP returns
        *   nothing.
        m.cPath = JUSTPATH(m.cFileSpec)
        IF EMPTY(m.cPath) AND m.cFileSpec = '\'
            m.cPath = '\'
        ENDIF
        RETURN m.cPath
    ENDFUNC

    *- FullPath() - Return the full path from a partial directory (e.g. "..\..")
    *    Input: cPathSpec - Path string to test
    *     Retn: The fully qualified directory name (e.g. "E:\ALI\DATA")
    FUNCTION FullPath(cPathSpec)
        LOCAL cOrigDir, cFullDir

        * The passed spec must be a valid directory
        IF NOT THIS.IsADir(m.cPathSpec)
            RETURN ''
        ENDIF

        * Change to that directory
        m.cOrigDir = SET('DEFAULT') + CURDIR()
        SET DEFAULT TO (m.cPathSpec)
        m.cFullDir = SET('DEFAULT') + CURDIR()
        SET DEFAULT TO (m.cOrigDir)
        RETURN m.cFullDir
    ENDFUNC

    *- MinPath() - Return the minimum path from current or passed directory
    *    Input: cFullSpec - Full path or file string to check
    *           cCompareTo - (optional) Directory to compare it to (default =
    *                           current directory
    *     Retn: The mimimallyy qualified directory name
    *       Example: MinPath([E:\ALI\DATA\SAVE], [E:\ALI]) = [DATA\SAVE]
    FUNCTION MinPath(cFullSpec, cCompareTo)
        LOCAL cRetDir

        * VFP's SYS(2014) handles this one
        m.cFullSpec = THIS.CheckLastSep(m.cFullSpec)
        IF PCOUNT() = 2
            m.cCompareTo = THIS.CheckLastSep(m.cCompareTo)
            m.cRetDir = SYS(2014, m.cFullSpec, m.cCompareTo)
        ELSE
            m.cRetDir = SYS(2014, m.cFullSpec)
        ENDIF
        RETURN m.cRetDir
    ENDFUNC

    *- IsADir() - Determine whether the passed spec is a directory
    *    Input: cDirName - Directory Name in question
    *     Retn: .T. if cDirName is a directory, else .F.
    FUNCTION IsADir(cDirName)
        LOCAL cCkDir, aTemp[1], nFileCnt, bGotIt, nX

        * Remove the last directory separator
        m.cCkDir = THIS.CheckLastSep(m.cDirName, .T.)

        * If this is a root directory (\ or E:\), it's OK (VFP won't give us
        *   anything).
        IF EMPTY(m.cCkDir) OR (LEN(m.cCkDir) = 2 AND RIGHT(m.cCkDir,1) = ':')
            RETURN .T.
        ENDIF

        * Create a temporary array for ADIR()
        m.nFileCnt = ADIR(aTemp, m.cCkDir, "D")
        m.bGotIt = .F.
        FOR m.nX = 1 TO m.nFileCnt
            IF 'D' $ m.aTemp[m.nX,5]
                m.bGotIt = .T.
                EXIT
            ENDIF
        ENDFOR
        RETURN m.bGotIt
    ENDFUNC

    *- MakeDir() - Create the passed directory name
    *    Input: cDirName - Directory Name to create
    *     Retn: .T. if cDirName exists, else .F.
    FUNCTION MakeDir(cDirName)
        LOCAL cDirName

        * Kill any trailing backslash
        m.cDirName = THIS.CheckLastSep(m.cDirName, .T.)

        * If it's already a directory, we don't need to create it
        IF THIS.IsADir(m.cDirName)
            RETURN .T.
        ENDIF

        * Go make it and verify that it's made
        MD (m.cDirName)
        RETURN THIS.IsADir(m.cDirName)
    ENDFUNC

    *- MakeAllDirs() - Create the passed directory and, if needed, its parents
    *    Input: cDirName - Directory Name to create
    *     Retn: .T. if cDirName exists, else .F.
    *  CAUTION: This must have the full path desired (drive + ':' is OK)
    FUNCTION MakeAllDirs(cDirName)
        LOCAL cDirName, cDrv, cBegDir, oDirs, cPath, nX, cDir

        * Kill any trailing backslash
        m.cDirName = THIS.CheckLastSep(m.cDirName, .T.)

        * Define the drive first
        IF ':' $ m.cDirName
            m.cDrv = LEFT(m.cDirName, 2)
            m.cDirName = SUBSTR(m.cDirName, 3)
        ELSE
            m.cDrv = SET('DEFAULT')
        ENDIF

        * Now, if the passed dir starts with \ we have the full directory
        IF LEFT(m.cDirName, 1) = '\'
            m.cDirName = SUBSTR(m.cDirName, 2)
        ELSE
            m.cBegDir = FULLPATH(m.cDrv) + '*.*'
            m.cBegDir = SUBSTR(STRTRAN(m.cBegDir, '*.*', ''), 3)
            m.cDirName = ADDBS(m.cBegDir) + m.cDirName
        ENDIF

        * Now put these dirs into an array
        m.oDirs = CREATEOBJECT('StringArray', m.cDirName, '\')

        * Go thru and check each directory
        m.cPath = m.cDrv
        FOR m.nX = 1 TO m.oDirs.nRows
            m.cDir = m.oDirs.aRA[m.nX]
            IF EMPTY(m.cDir)
                LOOP
            ENDIF
            m.cPath = m.cPath + '\' + m.cDir

            * If it's already a directory, we don't need to create it
            IF NOT THIS.IsADir(m.cPath)
                THIS.MakeDir(m.cPath)
            ENDIF
        ENDFOR


        * Done
        RETURN m.cPath
    ENDFUNC

    *- RemDir() - Remove the passed directory (must be empty)
    *    Input: cDirName - Directory Name to remove
    *     Retn: .T. if cDirName is removed, else .F.
    FUNCTION RemDir(cDirName)
        LOCAL cDirName, oDir, nFileCnt, bRetVal

        * If this isn't a directory, we're done
        IF NOT THIS.IsADir(m.cDirName)
            RETURN .T.
        ENDIF

        * Kill any trailing backslash
        m.cDirName = THIS.CheckLastSep(m.cDirName, .T.)

        * Make sure there's nothing in the directory
        m.oDir = THIS.DirInfo(m.cDirName, '*.*', .T.)
        m.nFileCnt = m.oDir.nRows
        IF m.nFileCnt = 0

            * Remove the directory
            RD (m.cDirName)
            m.bRetVal = (NOT THIS.IsADir(m.cDirName))
        ELSE
            m.bRetVal = .F.
        ENDIF

        * Return the result
        RETURN m.bRetVal
    ENDFUNC

    *- ZapDir() - Remove an entire directory tree
    *    Input: cDirName - Directory Name to remove
    *           nTrySecs - Secs to keep trying (default = 5)
    *     Retn: .T. if cDirName removed, else .F.
    FUNCTION ZapDir(cDirName, nTrySecs)
        LOCAL cDir2Del, oDir, nFileCnt, nEndAt, bOld1705, bDidIt, bFirstPass, ;
          nLoopCntr, nX, cFName

        * If this isn't a directory, we're done
        IF NOT THIS.IsADir(m.cDirName)
            RETURN .T.
        ENDIF

        * Make sure we have a trailing backslash
        m.cDir2Del = THIS.CheckLastSep(m.cDirName)

        * Define our waiting seconds if we don't have any
        IF TYPE('nTrySecs') <> 'N'
            m.nTrySecs = 5
        ENDIF

        * Get an array object of all files and subdirectories
        m.oDir = THIS.DirInfo(m.cDir2Del, '*.*', .T.)
        m.nFileCnt = m.oDir.nRows

        * Define our ending time
        m.nEndAt = INT(SECONDS() + m.nTrySecs)

        * NT's cache doesn't always let us delete files right away.  So,
        *   we'll need to trap for Access Denied errors (#1705) and we'll
        *   need to keep trying up to our time limit
        m.bOld1705 = THIS.bHandle1705
        THIS.bHandle1705 = .T.
        m.bDidIt = (m.nFileCnt = 0)
        m.bFirstPass = (NOT m.bDidIt)
        m.nLoopCntr = 0               && For debugging purposes only
        DO WHILE m.bFirstPass OR (SECONDS() <= m.nEndAt AND NOT m.bDidIt)
            m.nLoopCntr = m.nLoopCntr + 1

            * Remove all of the files in oDir
            FOR m.nX = 1 TO m.nFileCnt

                * Define the file name
                *     .aRA[x,1] - File name (C) (includes extension)
                *     .aRA[x,2] - File size (N):
                *     .aRA[x,3] - File date (D)
                *     .aRA[x,4] - File Time (C)
                *     .aRA[x,5] - File Attributes (C):
                m.cFName = m.cDir2Del + m.oDir.aRA[m.nX,1]

                * For directories, call ourselves recursively to delete it
                IF 'D' $ m.oDir.aRA[m.nX,5]
                    THIS.ZapDir(m.cFName, m.nTrySecs)
                    m.nEndAt = INT(SECONDS() + m.nTrySecs)

                * For files, just delete them
                ELSE

                    * Sometimes we've seen that the file has already been
                    *   deleted - so just double-check
                    THIS.DeleteFile(m.cFName)
                    m.nEndAt = INT(SECONDS() + m.nTrySecs)
                ENDIF

                * Go handle the next one
            ENDFOR

            * Double-check that we got all of the files.  (It could be that
            *   we got an Access Denied and went on to the next file.)
            IF SECONDS() < m.nEndAt
                m.oDir = THIS.DirInfo(m.cDir2Del, '*.*', .T.)
                m.nFileCnt = m.oDir.nRows
                m.nEndAt = INT(SECONDS() + m.nTrySecs)
            ENDIF
            m.bDidIt = (m.nFileCnt = 0)
            m.bFirstPass = .F.
        ENDDO

        * Now, we can remove our directory
        m.bDidIt = .F.
        m.bFirstPass = .T.
        m.nLoopCntr = 0
        DO WHILE m.bFirstPass OR (SECONDS() <= m.nEndAt AND NOT m.bDidIt)
            m.nLoopCntr = m.nLoopCntr + 1

            * Try to remove the directory
            m.bDidIt = THIS.RemDir(m.cDir2Del)

            * If that didn't work, wait 1/4 second
            IF NOT m.bDidIt
                = PAUSEFR(0.25)
            ENDIF
            m.bFirstPass = .F.
        ENDDO
        THIS.bHandle1705 = m.bOld1705
        RETURN m.bDidIt
    ENDFUNC

    *- IncrDirName() - Return a directory name based on incrementing trailing digits
    *     Input: cPref - Directory name's preface text
    *            nFileLen - Desired length of filename
    *      Retn: Non-existing directory name as Preface + Number
    *      Note: Passed spaces are converted to underscores (_)
    FUNCTION IncrDirName(cPref, nFileLen)
        LOCAL cPrefix, cPath, cFileSpec, oDirObj, nDigitsNeeded, nLastNumb
        LOCAL bIsThere, cAddOn, nZ, nMaxLoops, nLoopCnt

        * Convert any spaces to underscores
        m.cPrefix = UPPER(STRTRAN(m.cPref, ' ', '_'))

        * Separate the directory and filespec info
        m.cPath = THIS.JustPath(m.cPrefix)
        m.cFileSpec = THIS.JustFile(m.cPrefix)

        * Get a list of directories and filenames all matching the prefix
        m.oDirObj = THIS.DirInfo(m.cPath, m.cFileSpec + '*.*', .T.)

        * How many digits will we add?
        m.nDigitsNeeded = m.nFileLen - LEN(m.cFileSpec)

        * Start a testing Loop
        m.nLastNumb = -1
        m.bIsThere = .T.
        m.nMaxLoops = 10 ^ m.nDigitsNeeded
        m.nLoopCnt = 0
        DO WHILE m.bIsThere

            * Increment the last number and make a string out of the result
            m.nLastNumb = m.nLastNumb + 1
            m.cAddOn = PADL(m.nLastNumb, m.nDigitsNeeded, '0')

            * See if this exists in oDirObj
            m.bIsThere = .F.
            FOR m.nZ = 1 TO m.oDirObj.nRows
                IF UPPER(m.oDirObj.aRA[m.nZ,1]) == m.cPrefix + m.cAddOn
                    m.bIsThere = .T.
                    EXIT
                ENDIF
            ENDFOR

            * If it's not there, double-check
            *   Does a file exist?
            IF NOT m.bIsThere
                m.bIsThere = (FILE(m.cPrefix + m.cAddOn))

                *   Does a directory exist?
                IF NOT m.bIsThere
                    m.bIsThere = THIS.IsADir(m.cPrefix + m.cAddOn)
                ENDIF
            ENDIF

            * Try again if bIsThere
            IF m.bIsThere
                m.nLoopCnt = m.nLoopCnt + 1
                IF m.nLoopCnt >= m.nMaxLoops
                    ERROR [Loop maximum exceeded]
                ENDIF
            ENDIF
        ENDDO

        * That's it; return the result
        RETURN m.cPrefix + m.cAddOn
    ENDFUNC

    *- UniqueDirName() - Return a temporary directory name that doesn't exist
    *     Input: cDir - Parent directory name (default = '.\')
    *      Retn: A unique 8-character folder  name not on cDir
    FUNCTION UniqueDirName(cDir)
        LOCAL cDirName

        * We may not be passed cDir
        IF TYPE('cDir') <> 'C'
            m.cDir = '.\'
        ELSE
            m.cDir = ADDBS(m.cDir)        && Make sure about this
        ENDIF

        * We used to use SYS(3) for this but VFP says, "SYS(3) may return a
        *   non-unique name when issued successionally on a fast computer.
        *   Use SUBSTR(SYS(2015), 3, 10) to create unique, legal 8 character
        *   name.  So, we will.
        m.cDirName = SUBSTR(SYS(2015), 3, 8)

        * VFP squawks if we use a name beginning with a number
        IF LEFT(m.cDirName,1) $ '1234567890'
            m.cDirName = 'X' + SUBSTR(m.cDirName, 2)
        ENDIF

        * But, double-check to make sure it doesn't exist
        DO WHILE THIS.IsADir(m.cDir + m.cDirName)
            m.cDirName = SUBSTR(SYS(2015), 3, 8)
            IF LEFT(m.cDirName,1) $ '1234567890'
                m.cDirName = 'X' + SUBSTR(m.cDirName, 2)
            ENDIF
        ENDDO
        RETURN m.cDirName
    ENDFUNC

    *- UniqueTempName() - Return a temporary filename that doesn't exist
    *    Input: cExt - The file extension that will be used
    *           cDir - The directory for the file (default = '.\')
    *     Retn: A unique 8-character filename not on cDir with cExt
    FUNCTION UniqueTempName(cExt, cDir)
        LOCAL cFName

        * We may not be passed cDir
        IF TYPE('cDir') <> 'C'
            m.cDir = '.\'
        ENDIF

        * We used to use SYS(3) for this but VFP says, "SYS(3) may return a
        *   non-unique name when issued successionally on a fast computer.
        *   Use SUBSTR(SYS(2015), 3, 10) to create unique, legal 8 character
        *   file name.  So, we will.
        m.cFName = SUBSTR(SYS(2015), 3, 8)

        * VFP squawks if we use a name beginning with a number
        IF LEFT(m.cFName,1) $ '1234567890'
            m.cFName = 'X' + SUBSTR(m.cFName, 2)
        ENDIF

        * But, double-check to make sure it doesn't exist
        DO WHILE FILE(m.cDir + m.cFName + '.' + m.cExt)
            m.cFName = SUBSTR(SYS(2015), 3, 8)
            IF LEFT(m.cFName,1) $ '1234567890'
                m.cFName = 'X' + SUBSTR(m.cFName, 2)
            ENDIF
        ENDDO
        RETURN m.cFName
    ENDFUNC

    *- JustPath() - Return only the path from the passed spec
    *    Input: cPathSpec - Path/file string to test
    *     Retn: Only the drive and directory part of cPathSpec
    FUNCTION JustPath(cPathSpec)
        LOCAL cRetPath, nLastSlash

        * Check for valid parameters
        m.cPathSpec = EVL(m.cPathSpec, '')
        IF EMPTY(m.cPathSpec)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Check directory separators
        m.cRetPath = THIS.CheckDirSep(m.cPathSpec)

        * Find the last directory separator
        m.nLastSlash = THIS.LastDirPosn(m.cPathSpec)

        * Handle our variations
        DO CASE

        * There may be no path at all
        CASE m.nLastSlash = 0
            RETURN ''

        * There may be no filename if the last character is '\' or ':'
        CASE RIGHT(m.cRetPath,1) $ '\:'
            RETURN m.cRetPath

        * Otherwise, do the expected thing
        OTHERWISE
            RETURN LEFT(m.cRetPath, m.nLastSlash)
        ENDCASE
    ENDFUNC

    *- JustFile() - Return only the file name/extension from the passed filespec
    *    Input: cFileSpec - File string to test
    *     Retn: Only the file name/ext part of cFileSpec
    FUNCTION JustFile(cFileSpec)
        LOCAL cRetFName, nLastSlash

        * Check for valid parameters
        m.cFileSpec = EVL(m.cFileSpec, '')
        IF EMPTY(m.cFileSpec)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Check directory separators
        m.cRetFName = THIS.CheckDirSep(m.cFileSpec)

        * Find the last directory separator
        m.nLastSlash = THIS.LastDirPosn(m.cRetFName)

        * Handle our variations
        DO CASE

        * There may be no path at all
        CASE m.nLastSlash = 0
            RETURN m.cRetFName

        * There may be no filename at all
        CASE m.nLastSlash = LEN(m.cRetFName)
            RETURN ''

        * Otherwise, do the expected thing
        OTHERWISE
            RETURN SUBSTR(m.cRetFName, m.nLastSlash + 1)
        ENDCASE
    ENDFUNC

    *- JustFName() - Return only the file name (no ext) from the passed filespec
    *    Input: cFileSpec - File string to test
    *     Retn: Only the file name (no ext) part of cFileSpec
    FUNCTION JustFName(cFileSpec)
        LOCAL cRetFName, nPeriod

        * Check for valid parameters
        m.cFileSpec = EVL(m.cFileSpec, '')
        IF EMPTY(m.cFileSpec)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Remove the directory info
        m.cRetFName = THIS.JustFile(m.cFileSpec)

        * Find the extension separator
        m.nPeriod = AT('.', m.cRetFName)

        * Remove the extension
        IF m.nPeriod > 0
            m.cRetFName = LEFT(m.cRetFName, m.nPeriod-1)
        ENDIF

        * Done
        RETURN m.cRetFName
    ENDFUNC

    *- JustFExt() - Return only the extension from the passed filespec
    *    Input: cFileSpec - File string to test
    *     Retn: Only the file ext part of cFileSpec
    FUNCTION JustFExt(cFileSpec)
        LOCAL cRetExt, nPeriod

        * Check for valid parameters
        m.cFileSpec = EVL(m.cFileSpec, '')
        IF EMPTY(m.cFileSpec)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Find the extension separator
        m.cRetExt = ''
        m.nPeriod = RAT('.', m.cFileSpec)
        IF m.nPeriod > 0 AND m.nPeriod < LEN(m.cFileSpec)
            m.cRetExt = ALLTRIM(SUBSTR(m.cFileSpec, m.nPeriod+1))
        ENDIF

        * Done
        RETURN m.cRetExt
    ENDFUNC

    *- IncrFName() - Return a filename setting the filename based on the next number
    *    Input: cPref - Filename preface text
    *           cExt - File's extension
    *           cDir - Destination directory for file
    *     Retn: Non-existing filename as Preface + Number + .Ext
    FUNCTION IncrFName(cPref, cExt, cDir)
        LOCAL cNextNum, nNextNum

        * Make sure we have a valid directory
        m.cDir = EVL(m.cDir, '')

        * The returned filename has the format:
        *       cBaseName cNewNumber . cExt
        * where cNewNumber is assigned such that the file currently does not
        * exist
        m.cExt = '.' + m.cExt
        m.cNextNum = '1'
        DO WHILE FILE(m.cDir + m.cPref + m.cNextNum + m.cExt)
            m.nNextNum = VAL(m.cNextNum) + 1
            m.cNextNum = LTRIM(STR(m.nNextNum))
        ENDDO
        RETURN m.cPref + m.cNextNum + m.cExt
    ENDFUNC

    *- IncrFName0() - Return a filename defined based on 0s + the next number
    *    Input: cPref - Filename preface text
    *           cExt - File's extension
    *           cDir - Destination directory for file
    *           nMaxDigits - (optional) Max digits to use (def: name = 8)
    *     Retn: Non-existing filename as Preface + Number + .Ext
    FUNCTION IncrFName0(cPref, cExt, cDir, nMaxDigits)
        LOCAL nNumbLen, cExt, nNextNum, cNextNum

        * Make sure we have valid parameters
        m.cDir = EVL(m.cDir, '')
        IF VARTYPE(m.nMaxDigits) <> 'N' OR m.nMaxDigits  < 1
            m.nNumbLen = MAX(1, 8 - LEN(m.cPref))
        ELSE
            m.nNumbLen = m.nMaxDigits
        ENDIF

        * The returned filename has the format:
        *       cBaseName cNewNumber . cExt
        * where cNewNumber is assigned such that the file currently does not
        * exist.  Set our extension and define the length of the numbers
        m.cExt = '.' + m.cExt
        m.nNextNum = 1
        m.cNextNum = PADL(m.nNextNum, m.nNumbLen, '0')
        DO WHILE FILE(m.cDir + m.cPref + m.cNextNum + m.cExt)
            m.nNextNum = m.nNextNum + 1
            m.cNextNum = PADL(m.nNextNum, m.nNumbLen, '0')
        ENDDO
        RETURN m.cPref + m.cNextNum + m.cExt
    ENDFUNC

    *- IncrFExt() - Return a filename setting the extension based on the next number
    *    Input: cFileSpec - File Specification including directory (no extension)
    *     Retn: Non-existing filename as cFileSpec + .NewExt
    FUNCTION IncrFExt(cFileSpec)
        LOCAL cSpecOut, cNextNum, nNextNum

        * Make sure our filespec ends in a period
        m.cSpecOut = goStr.ExtrToken(m.cFileSpec, '.') + '.'

        * We'll start with extension: "000"
        m.cNextNum = '000'
        DO WHILE FILE(m.cSpecOut + m.cNextNum)
            m.cNextNum = goStr.IncrAlpha(m.cNextNum)
        ENDDO

        * Done
        RETURN m.cSpecOut + m.cNextNum
    ENDFUNC

    *- GetFileDescription() - Return a file's information in an object
    *     Input: cDirName - Directory Name (can also have file name)
    *            cFileName - (optional) File name can have *s or ?s
    *      Retn: File description object; properties:
    *             .cFileName (no path but with extension)
    *             .cExt - file extension
    *             .dDate - file date
    *             .cTime - file time
    *             .nSize - file size (bytes)
    *             .cAttrib - file attributes in RHSDA format
    *             .cPath - directory for file (with trailing backslash)
    *             .bFound - .T. if file found
    FUNCTION GetFileDescription(cPath, cFile)
        LOCAL oFD, oDirObj

        * Make sure we separate the file and path
        IF PCOUNT() = 1
            m.cFile = JUSTFNAME(m.cPath)
            m.cPath = JUSTPATH(m.cPath)
        ENDIF

        * Create our description object
        m.cPath = ADDBS(m.cPath)
        m.oFD = CREATEOBJECT('Empty')
        ADDPROPERTY(m.oFD, 'cFileName', m.cFile)
        ADDPROPERTY(m.oFD, 'cExt', '')
        ADDPROPERTY(m.oFD, 'dDate', {})
        ADDPROPERTY(m.oFD, 'cTime', '')
        ADDPROPERTY(m.oFD, 'nSize', 0)
        ADDPROPERTY(m.oFD, 'cAttrib', '')
        ADDPROPERTY(m.oFD, 'cPath', m.cPath)
        ADDPROPERTY(m.oFD, 'bFound', .F.)

        * If the passed filename is empty, we're done
        IF NOT EMPTY(m.cFile)

            * Get the directory array object for this file using attributes:
            *   Archive, Hidden ReadOnly or System files
            m.oDirObj = CREATEOBJECT('DirArray', m.cPath + m.cFile, 'AHRS')

            * Load up our description object
            IF m.oDirObj.nRows > 0
                WITH m.oFD
                    .cFileName = m.oDirObj.aRA[1,1]
                    .cExt    = JUSTEXT(m.cFile)
                    .dDate   = m.oDirObj.aRA[1,3]
                    .cTime   = m.oDirObj.aRA[1,4]
                    .nSize   = m.oDirObj.aRA[1,2]
                    .cAttrib = m.oDirObj.aRA[1,5]
                    .bFound = .T.
                ENDWITH
            ELSE
                m.oFD.bFound = .F.
            ENDIF
        ENDIF
        RETURN m.oFD
    ENDFUNC

    *- FindFirstFile() - Return an object containing the FIRST file's info in a dir
    *     Input: cPathSpec - Path/file spec string
    *      Retn: File description object; properties:
    *             .cFileName (no path but with extension)
    *             .cExt - file extension
    *             .dDate - file date
    *             .cTime - file time
    *             .nSize - file size (bytes)
    *             .cAttrib - file attributes in RHSDA format
    *             .cPath - directory for file
    *             .bFound - .T. if file found
    FUNCTION FindFirstFile(cPathSpec)
        LOCAL cFileName, oFile

        * Get the first file name for the spec
        m.cFileName = SYS(2000, m.cPathSpec)

        * Get the rest of its info and put it in a file description object
        m.oFile = THIS.GetFileDescription(JUSTPATH(m.cPathSpec), m.cFileName)
        RETURN m.oFile
    ENDFUNC

    *- FindNextFile() - Return an object containing the NEXT file's info in a dir
    *     Input: cPathSpec - Path/file spec string - same as FindFirstFile()
    *      Retn: File description object; same as FindFirstFile()
    FUNCTION FindNextFile(cPathSpec)
        LOCAL cFileName, oFile

        * Get the next file name for the spec
        m.cFileName = SYS(2000, m.cPathSpec, 1)

        * Get the rest of its info and put it in a file description object
        m.oFile = THIS.GetFileDescription(JUSTPATH(m.cPathSpec), m.cFileName)
        RETURN m.oFile
    ENDFUNC

    *- WaitForFile() - Return when a file has finished being created
    *     Input: cPathSpec - Path/file spec string
    *            nLimitSecs - Max. seconds to wait
    *      Retn: .T. if file found, else .F.
    FUNCTION WaitForFile(cPathSpec, nLimitSecs)
        LOCAL nEndSecs, nSize, bGotIt, oFile

        * Setup for our Wait loop
        m.nEndSecs = -1
        IF PCOUNT() > 1 AND NOT EMPTY(m.nLimitSecs)
            m.nEndSecs = SECONDS() + m.nLimitSecs
        ENDIF
        m.nSize = -1
        m.bGotIt = .F.
        DO WHILE .T.
            m.oFile = THIS.GetFileDescription(m.cPathSpec)

            * Our rules for waiting are:
            DO CASE

            *   1. Keep waiting if the file doesn't exist
            CASE m.oFile.nSize = 0 OR NOT m.oFile.bFound
                PAUSEFR(0.1)         && Wait for 1/10th of a second

            *   2. Keep waiting if the file size changes
            CASE m.oFile.bFound AND m.oFile.nSize > m.nSize
                m.nSize = m.oFile.nSize
                PAUSEFR(0.1)

            *   3. If we've timed out, just exit
            CASE m.nEndSecs > 0 AND SECONDS() > m.nEndSecs
                EXIT

            *   4. When the file size is stable and the file exists, wait
            *       another 1/2 second anyway.
            OTHERWISE
                m.bGotIt = .T.
                PAUSEFR(0.5)
                EXIT
            ENDCASE
        ENDDO
        RETURN m.bGotIt
    ENDFUNC

    *- IsAFile() - Return .T. if the passed file spec exists (wild cards OK)
    *     Input: cFileName - File Name in question
    *      Retn: .T. if cFileName is a file, else .F.
    FUNCTION IsAFile(cFileSpec)
        LOCAL oFiles, bGotSome

        * Create an array object for the full file spec.
        m.oFiles = CREATEOBJECT("DirArray", m.cFileSpec, 'ARHS')
        m.bGotSome = m.oFiles.nRows > 0
        m.oFiles.Release()

        * Done
        RETURN m.bGotSome
    ENDFUNC

    *- FileSize() - Return the size of a file
    *    Input: cFileNm - File name in question
    *     Retn: File Size (N)
    FUNCTION FileSize(cFileNm)
        LOCAL oDirObj, nSize

        * Get the directory array object for this file using attributes:
        *   Archive, Hidden ReadOnly or System files
        m.oDirObj = CREATEOBJECT('DirArray', m.cFileNm, 'AHRS')

        * The Size is in the 2nd column
        m.nSize = 0
        IF m.oDirObj.nRows > 0
            m.nSize = m.oDirObj.aRA[1,2]
        ENDIF
        RETURN m.nSize
    ENDFUNC

    *- FileDate() - Return a file's date
    *    Input: cFileNm - File name in question
    *     Retn: File Date (D)
    FUNCTION FileDate(cFileNm)
        LOCAL oDirObj, dDate

        * Get the directory array object for this file using attributes:
        *   Archive, Hidden ReadOnly or System files
*       oDirObj = CREATEOBJECT('DirArray', cFileNm, 'AHRS')
*
*       * The Time is the 3rd column
*       dDate = {}
*       IF oDirObj.nRows > 0
*           dDate = oDirObj.aRA[1,3]
*       ENDIF

        * There's a better way
        m.dDate = FDATE(m.cFileNm)
        RETURN m.dDate
    ENDFUNC

    *- FileTime() - Return a file's time
    *    Input: cFileNm - File name in question
    *     Retn: File Time (C>
    FUNCTION FileTime(cFileNm)
        LOCAL oDirObj, cTime

        * Get the directory array object for this file using attributes:
        *   Archive, Hidden ReadOnly or System files
*       oDirObj = CREATEOBJECT('DirArray', cFileNm, 'AHRS')
*
*       * The Time is the 4th column
*       cTime = ''
*       IF oDirObj.nRows > 0
*           cTime = oDirObj.aRA[1,4]
*       ENDIF

        * There's a better way...
        m.cTime = FTIME(m.cFileNm)

        * ...but we have to convert "01:29:12 PM" to "13:29:12"
        IF RIGHT(m.cTime,2) = 'PM'
            m.cTime = PADL(VAL(m.cTime)+12, 2, '0') + SUBSTR(m.cTime, 3, 6)
        ELSE
            m.cTime = LEFT(m.cTime, 8)
        ENDIF
        RETURN m.cTime
    ENDFUNC

    *- FileAttr() - Return a file's attributes
    *    Input: cFileNm - File name in question
    *     Retn: Attributes (C)
    FUNCTION FileAttr(cFileNm)
        LOCAL dwAttribs, cReturn

        * Get the file's attributes as a double-word
        m.dwAttribs = GetFileAttributes(m.cFileNm)

        * Convert these into characters
        m.cReturn = ''
        IF m.dwAttribs > 0
            m.cReturn = THIS.AttrDW2Chars(m.dwAttribs)
        ENDIF
        RETURN m.cReturn
    ENDFUNC

    *- SetFileAttrs() - Change a file's attributes
    *     Input: cFileNm - File name in question
    *-           Desired new Attributes (C): A, R, H, S - singly or mixed together
    *      Retn: .T. if set properly                                        s
    FUNCTION SetFileAttrs(cFileNm, cAttribs)
        LOCAL dwAttribs, nNewAttribs, nResult, cMsg

        * Input Notes:
        *   cFileNm - The file whose attributes are to be changed
        *   cAttribs - The desired attributes. BUT, there are 2 ways to set:
        *       Absolute: Pass only the desired characters (e.g. "RA" or "RSH")
        *       Relative: Pass the changes - space separated (e.g. "-R +A")
        *       Note: If one attribute is relative, they all must be

        * Get the file's attributes as a double-word
        m.dwAttribs = GetFileAttributes(m.cFileNm)

        * What are we supposed to do to the file
        m.nNewAttribs = THIS.GetAttribNumb(m.cAttribs, m.dwAttribs)

        * Now, set the attributes
        m.nResult = SetFileAttributes(m.cFileNm, m.nNewAttribs)
        IF m.nResult = 0
            m.cMsg = 'Setting attributes failed for ' + m.cFileNm
            m.cMsg = THIS.GetLastAPIError(m.cMsg)
            ERROR m.cMsg
        ENDIF
        RETURN (m.nResult <> 0)
    ENDFUNC

    *- CopyFile() - Copy a file from one directory to another
    *    Input: cSrcFile - Source file spec (name and dir as needed)
    *           cDstDir - Destination file spec (can include filename)
    *           bUseTemp - .T. if copy is to be done to a temp file, then renamed
    *           bNoBugFileWanted - if a error will return .F. (not bug file created)
    *     Retn: .T. if copy succeeded, else .F.
    FUNCTION CopyFile(cSrcFile, cDstDir, bUseTemp, bNoBugFileWanted)
        LOCAL cDstSpec, cTempFile, cDstFile, nResult, cMsg

        * Make sure the destination spec includes a filename
        m.cDstSpec = ALLTRIM(m.cDstDir)
        IF THIS.IsADir(m.cDstSpec)
            m.cDstSpec = THIS.CheckLastSep(m.cDstSpec) + THIS.JustFile(m.cSrcFile)
        ENDIF

        * Copy the file using a temp file name if requested.  We'll get a bug
        *   box if the passed spec is invalid.
        IF m.bUseTemp
            m.cTempFile = SYS(3) + [.TMP]
            m.cDstFile = ADDBS(JUSTPATH(m.cDstSpec)) + m.cTempFile

            * The trailing .F. means if the dest file exists, overwrite it
            m.nResult = CopyFile(m.cSrcFile, m.cDstFile, .F.)

            * If the destination file exists, delete it
            IF m.nResult <> 0
                IF FILE(m.cDstSpec)
                    ERASE (m.cDstSpec)
                ENDIF
                THIS.RenameFile(m.cDstFile, m.cDstSpec)
            ENDIF
        ELSE
            m.nResult = CopyFile(m.cSrcFile, m.cDstSpec, .F.)
        ENDIF

        * Check our results
        IF m.nResult = 0 AND NOT m.bNoBugFileWanted
            m.cMsg = 'File copy failed for ' + m.cSrcFile + CR_LF + ;
              THIS.GetLastAPIError(m.cMsg)
            ERROR m.cMsg
        ENDIF
        RETURN (m.nResult > 0)
    ENDFUNC

    *- CopyAllFiles() - Copy file matching a passed spec from one directory to another
    *     Input: cFileSpec - File spec including path and wildcards (can be *.*)
    *            cDstDir - Destination file spec (can include filename)
    *      Retn: Number of files copied (0 if none)
    FUNCTION CopyAllFiles(cFileSpec, cDstDir)
        LOCAL oDirObj, cFileDir, nFileCnt, nX, cThisFile

        * Create an array object
        m.oDirObj = CREATEOBJECT("DirArray", m.cFileSpec)

        * Define the directory
        m.cFileDir = THIS.JustPath(m.cFileSpec)

        * Go through copying each file
        m.nFileCnt = 0
        FOR m.nX = 1 TO m.oDirObj.nRows
            m.cThisFile = m.oDirObj.aRA[m.nX,1]
            IF m.cThisFile == '.' OR m.cThisFile == '..'
                LOOP
            ENDIF

            * Copy the file
            IF THIS.CopyFile(m.cFileDir + m.cThisFile, m.cDstDir)
                m.nFileCnt = m.nFileCnt + 1
            ENDIF
        ENDFOR
        RETURN m.nFileCnt
    ENDFUNC

    *- MoveFile() - Move a file from one drive/directory to another
    *    Input: cSrcFile - Source file spec (name and dir as needed)
    *           cDstDir - Destination file spec (can include filename)
    *           bUseTemp - .T. if copy is to be done to a temp file, then renamed
    *           bNoBugFileWanted - if a error will return .F. (not bug file created)
    *     Retn: .T. if move succeeded, else .F.
    FUNCTION MoveFile(cSrcFil, cDstDr, bUseTemp, bNoBugFileWanted)
        LOCAL bIsOk

        * Copy the file
        m.bIsOk = THIS.CopyFile(m.cSrcFil, m.cDstDr, m.bUseTemp, m.bNoBugFileWanted)

        * And delete it if the move was successful
        IF m.bIsOk
            m.bIsOk = THIS.DeleteFile(m.cSrcFil)
        ENDIF
        RETURN m.bIsOk
    ENDFUNC

    *- RenameFile() - Rename a passed filename
    *     Input: cFileName - File to rename (can include path)
    *            cNewName - New name for the file
    *      Retn: .T. if file renamed (.F. if not)
    FUNCTION RenameFile(cFileName, cNewName)
        LOCAL cAttrs, cPath, cNewName, cPath2, bRetVal

        * Rename won't work for System/Hidden files utes
        m.cAttrs = THIS.FileAttr(cFileName)
        IF 'H' $ m.cAttrs OR 'S' $ m.cAttrs
            THIS.SetFileAttrs(cFileName, '-H -S')
        ENDIF

        * If we have a path for the old name but none for the new, add it to
        *   the new name
        m.cPath  = THIS.GetPath(cFileName)
        m.cNewName = m.cNewName
        m.cPath2 = THIS.GetPath(m.cNewName)
        IF EMPTY(m.cPath2) AND NOT EMPTY(m.cPath)
            m.cNewName = ADDBS(m.cPath) + m.cNewName
        ENDIF

        * Rename the file
        m.bRetVal = .F.
        RENAME (m.cFileName) TO (m.cNewName)
        IF THIS.IsAFile(m.cNewName)
            m.bRetVal = .T.

            * Reset the attributes if needed
            IF 'H' $ m.cAttrs OR 'S' $ m.cAttrs
                THIS.SetFileAttrs(m.cNewName, m.cAttrs)
            ENDIF
        ENDIF
        RETURN m.bRetVal
    ENDFUNC

    *- DeleteFile() - Delete a passed filename
    *    Input: cDelFile - File to delete (can include path)
    *     Retn: .T. if file deleted (.F. if not)
    FUNCTION DeleteFile(cDelFile)
        LOCAL cAttrs, nResult, nX, cMsg

        * Don't bother if the file doesn't exist
        IF NOT THIS.IsAFile(m.cDelFile)
            RETURN .T.
        ENDIF

        * Before we can delete the file, we must clear any Readonly attribute
        m.cAttrs = THIS.FileAttr(m.cDelFile)
        IF 'R' $ m.cAttrs
            THIS.SetFileAttrs(m.cDelFile, '-R')
        ENDIF
        m.nResult = DeleteFile(m.cDelFile)
        IF m.nResult = 0
            FOR m.nX = 1 TO 100       && Try for a bunch of times
                INKEY(0.10)         && Wait 1/10th of a second
                m.nResult = DeleteFile(m.cDelFile)
                IF m.nResult = 1
                    EXIT
                ENDIF
            ENDFOR
        ENDIF
        RETURN (NOT THIS.IsAFile(m.cDelFile))
    ENDFUNC

    *- DeleteAllFiles() - Delete all files matching a passed file spec
    *    Input: cDelSpec - File spec including path and wildcards (can be *.*)
    *     Retn: Number of files deleted (0 if none)
    FUNCTION DeleteAllFiles(cDelSpec)
        LOCAL oDirObj, cFileDir, nFileCnt, nX, cThisFile

        * Create an array object
        m.oDirObj = CREATEOBJECT("DirArray", m.cDelSpec)

        * Define the directory
        m.cFileDir = THIS.JustPath(m.cDelSpec)

        * Go through deleting all files
        m.nFileCnt = 0
        FOR m.nX = 1 TO m.oDirObj.nRows
            m.cThisFile = m.oDirObj.aRA[m.nX,1]
            IF m.cThisFile == '.' OR m.cThisFile == '..'
                LOOP
            ENDIF

            * Delete the file
            THIS.DeleteFile(m.cFileDir + m.cThisFile)
            IF NOT FILE(m.cFileDir + m.cThisFile)
                m.nFileCnt = m.nFileCnt + 1
            ENDIF
        ENDFOR
        RETURN m.nFileCnt
    ENDFUNC

    *- LL_Open() - Return "handle" after create/open a "low-level" read/write file
    *    Input: cFileName - File name to open
    *           cAction - (optional) 'W' (default) = Read/Write, 'R' = Read
    *                       Only, 'P' = Purge the file's contents (implies R/W)
    *     Retn: The file "handle" needed for future references to this file
    *           The error handler is called if open fails
    FUNCTION LL_Open(cFileName, cAction)
        LOCAL nOpenCode, bPurgeIt, bGotFile, nLLHndl, cActVerb, cDirName, bGotDir

        * Check for valid parameters
        m.cFileName = EVL(m.cFileName, '')
        IF EMPTY(m.cFileName)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * VFP has different codes for file processing operations.
        *   Unfortunately, those codes aren't the same for file opening using
        *   FOPEN() and file creation using FCREATE().  The codes are:
        *           FOPEN()                            FCREATE()
        *    0 (Default) Read Only Buffered     0 (Default) Read-Write
        *    1 Write-Only Buffered              1 Read-Only
        *    2 Read and Write Buffered          2 Hidden
        *   10 Read-Only Unbuffered             3 Read-Only/Hidden
        *   11 Write-Only Unbuffered            4 System
        *   12 Read and Write Unbuffered        5 Read-Only/System
        *                                       6 System/Hidden
        *                                       7 Read-Only/Hidden/System
        * For FOPEN(), we don't need unbuffered access and I can't think of an
        *   instance where Write-only is preferrable to Read/Write so we'll
        *   ignore Write-only and just deal with Read-Only and Read/Write.
        * For FCREATE() we'll only use 0 for simplicity's sake, we don't need
        *   Read-Only, Hidden, or System files (or, if we have the one odd
        *   occasion where we do need that, we can call FCREATE directly).

        * Are we to purge the file?  Define the file open codes
        m.nOpenCode = 2               && Buffered Read/Write
        m.bPurgeIt = .F.
        IF VARTYPE(m.cAction) = 'C' AND (NOT EMPTY(m.cAction)) AND ;
          m.cAction $ 'RP'
            IF m.cAction = 'R'
                m.nOpenCode = 0       && Buffered Read-Only
            ELSE
                m.bPurgeIt = .T.
            ENDIF
        ENDIF

        * If we're to "purge" or overwrite the file, erase it first
        m.bGotFile = FILE(m.cFileName)
        DO CASE
        CASE m.bPurgeIt AND m.bGotFile
            ERASE (m.cFileName)
            m.nLLHndl = FCREATE(m.cFileName)
            m.cActVerb = 'open/purge'
        CASE m.bGotFile
            m.nLLHndl = FOPEN(m.cFileName, m.nOpenCode)
            m.cActVerb = 'open' + IIF(m.nOpenCode = 0, ' r/o', '')
        OTHERWISE
            m.nLLHndl = FCREATE(m.cFileName)
            m.cActVerb = 'create'
        ENDCASE

        * Call the Error Handler if that failed
        IF m.nLLHndl < 1
            m.X_ERRMSG = 'Could not ' + m.cActVerb + ' the File: ' + m.cFileName
            m.X_ERRCMD = 'F' + UPPER(m.cActVerb) + '("' + m.cFileName + '"' + ;
              IIF(m.cActVerb = 'open', ', ' + STR(m.nOpenCode,1,0), '') + ')'

            * Why couldn't we create/open the file?  Check for directory
            *   and file existence
            m.bGotFile = FILE(m.cFileName)
            m.cDirName = THIS.JustPath(m.cFileName)
            m.bGotDir = THIS.IsADir(m.cDirName)
            m.X_ERRMSG = m.x_errmsg + '; (file ' + ;
              IIF(m.bGotFile, 'exists', 'does not exist') + ', dir ' + ;
              IIF(m.bGotDir, 'exists', 'does not exist') + ')'
            ERROR m.X_ERRMSG
        ENDIF
        RETURN m.nLLHndl
    ENDFUNC

    *- LL_Read() - Read a line from a low-level file
    *    Input: nLLHndl - Previously opened file handle
    *           bStripCRLF - (optional) If .T., strip CR, LF from end of line
    *           nBytes2Read - (optional) No. of bytes desired (default = 254)
    *     Retn: One line read from the file (if FEOF(), returns null string)
    *           The error handler is called if handle is invalid
    FUNCTION LL_Read(nLLHndl, pbStripCRLF, pnBytes2Read)
        LOCAL cLineRD

        * Check for valid parameters
        m.nLLHndl = EVL(m.nLLHndl, 1)

        * If we're at FEOF(), return a null string
        IF FEOF(m.nLLHndl)
            RETURN ''
        ENDIF

        * Define our default bytes to read
        IF PCOUNT() < 3 OR TYPE('pnBytes2Read') <> 'N'
            m.pnBytes2Read = 254
        ENDIF

        * Fox has 2 functions for this:
        IF m.pbStripCRLF

            * FGETS(nHndl, [nBytes]) - Returns up to nBytes (default = 254) or up
            *     to a CR, whichever comes first.  It strips any CR, LFs.
            m.cLineRD = FGETS(m.nLLHndl, m.pnBytes2Read)
        ELSE

            * FREAD(nHndl, nBytes) - Returns up to nBytes or until it hits FEOF(),
            *     whichever comes first.  It includes any CR, LFs.
            m.cLineRD = FREAD(m.nLLHndl, m.pnBytes2Read)
        ENDIF
        RETURN m.cLineRD
    ENDFUNC

    *- LL_Write() - Write a string to a low-level file
    *    Input: nLLHndl - Previously opened file handle
    *           cWriteStr - String to be written
    *           bNoCrLf - (optional) If .T., no CR, LF's are added
    *     Retn: .T.; string written adding CR, LF if desired.
    *           Error handler called if incorrect number of bytes written or
    *             handle is invalid.
    FUNCTION LL_Write(nLLHndl, cWriteStr, bNoCrLf)
        LOCAL nChkLen, nWrtLen, cAction

        * Check for valid parameters
        m.nLLHndl = EVL(m.nLLHndl, 1)
        m.cWriteStr = EVL(m.cWriteStr, '')

        * Write the string adding a CR,LF
        m.nChkLen = LEN(m.cWriteStr)
        IF m.bNoCrLf

            * FWRITE() just does what you tell it to
            m.nWrtLen = FWRITE(m.nLLHndl,m.cWriteStr)
            m.cAction = 'FWRITE'
        ELSE

            * FPUTS() adds a CR, LF
            m.nWrtLen = FPUTS(m.nLLHndl,m.cWriteStr)
            m.nChkLen = m.nChkLen + 2
            m.cAction = 'FPUTS'
        ENDIF

        * Call the error handler if an incorrect number of bytes are written
        IF m.nWrtLen <> m.nChkLen
            FCLOSE(m.nLLHndl)            && Try to close the file first
            m.X_ERRMSG = 'Incorrect number of bytes written to File.'
            m.X_ERRCMD = m.cAction + '(' + LTRIM(STR(m.nLLHndl)) + ',"' + ;
              m.cWriteStr + '")'
            ERROR m.X_ERRMSG
        ENDIF
        RETURN .T.
    ENDFUNC

    *- LL_Flush() - Flush a low-level file
    *    Input: nLLHndl - Previously opened file handle
    *           bForceIt - .T. = Force Windows to flush now, .F. = let VFP do
    *                       it at its convenience
    *     Retn: .T. and file Flushed.
    FUNCTION LL_Flush(nLLHndl, bForceIt)

        * Check for valid parameters
        m.nLLHndl = EVL(m.nLLHndl, 1)

        * Flush the file
        FFLUSH(m.nLLHndl, m.bForceIt)
        RETURN .T.
    ENDFUNC

    *- LL_Close() - Close a low-level file
    *    Input: nLLHndl - Previously opened file handle
    *     Retn: .T.; file closed.
    *           Error handler called if close fails.
    FUNCTION LL_Close(nLLHndl)

        * Check for valid parameters
        m.nLLHndl = EVL(m.nLLHndl, 1)

        * Close the file
        FFLUSH(m.nLLHndl)
        IF NOT FCLOSE(m.nLLHndl)

            * Call the Error Handler if that failed
            m.X_ERRMSG = 'Could not close Text File.'
            m.X_ERRCMD = 'FCLOSE(' + LTRIM(STR(m.nLLHndl)) + ')'
            ERROR [Could not close Text File]
        ENDIF
        RETURN .T.
    ENDFUNC

    *- LL_ToBOF() - Position a low-level file to FBOF()
    *    Input: nLLHndl - Previously opened file handle
    *     Retn: Number of bytes moved; file is at beginning.
    *           The error handler is called if handle is invalid
    FUNCTION LL_ToBOF(nLLHndl)

        * Check for valid parameters
        m.nLLHndl = EVL(m.nLLHndl, 1)

        * Re-position the file - move to offset 0 relative to End of File (2)
        RETURN FSEEK(m.nLLHndl, 0, 0)
    ENDFUNC

    *- LL_ToEOF() - Position a low-level file to FEOF()
    *    Input: nLLHndl - Previously opened file handle
    *     Retn: Number of bytes moved; file is at FEOF().
    *           The error handler is called if handle is invalid
    FUNCTION LL_ToEOF(nLLHndl)

        * Check for valid parameters
        m.nLLHndl = EVL(m.nLLHndl, 1)

        * Re-position the file - move to offset 0 relative to End of File (2)
        RETURN FSEEK(m.nLLHndl, 0, 2)
    ENDFUNC

    *- LL_IsLock() - Return .T. if the file is locked
    *    Input: cFileName - File name to locked
    *     Retn: .T. is return is the file is locked
    FUNCTION LL_IsLock(cFileName)
        LOCAL nLLHndl, bGotError

        * Check for valid parameters
        m.cFileName = EVL(m.cFileName, '')
        IF EMPTY(m.cFileName)
            ERROR 'Invalid parameters were passed'
        ENDIF

        * Try to open the file.  If FOPEN errors a value less than 1 then
        *  the file musted be locked
        m.bGotError = .F.
        IF FILE(m.cFileName)
            m.nLLHndl = FOPEN(m.cFileName, 2)
            IF m.nLLHndl < 1
                m.bGotError = .T.
            ELSE
                FCLOSE(m.nLLHndl)
            ENDIF
        ENDIF

        * Done
        RETURN m.bGotError
    ENDFUNC

    *- Error() - Error handlerr
    FUNCTION Error(nErrorNum, cMethod, nLine)
        LOCAL aErrInfo[7], cMethName, cSys16, cCmd, oParent, bGotGlobal, ;
          cAction, cHndlCmd, nChoice

        * We're going to handle only 1705 - Access Denied errors, but them only
        *   if THIS.bHandle1705 is .T.
        IF m.nErrorNum = 1705 AND THIS.bHandle1705

            * Ignore this; just return to the next line
            RETURN
        ENDIF

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
            goError.RegisterError(m.nErrorNum, m.cMethName, m.nLine, @m.aErrInfo, ;
              m.cSys16, THIS)
            m.bGotGlobal = .T.
        ENDIF

        * Handle this error as best we can after assuming our return action
        m.cAction = 'RETURN'
        DO CASE

        * First, try the parent
        CASE NOT ISNULL(m.oParent)
            m.cAction = m.oParent.Error(m.nErrorNum, m.cMethName, m.nLine)

        * Next, the global error handling object
        CASE m.bGotGlobal
            m.cAction = goError.HandleError(m.nErrorNum, m.cMethName, m.nLine, @m.aErrInfo, ;
              m.cSys16, THIS)

        * There may be some other global error handler.  So give it what it
        *   wants.  Caution: It may be called as a function or with a DO
        CASE NOT EMPTY(ON('ERROR'))
            m.cHndlCmd = UPPER(ON('ERROR'))
            m.cHndlCmd = STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(m.cHndlCmd, ;
              'PROGRAM()', '"' + m.cMethName + '"'), ;
              'ERROR()',   'nErrorNum'), ;
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
            m.nChoice = MESSAGEBOX('Error #: ' + LTRIM(STR(m.nErrorNum)) + ;
              CHR(13) + ;
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
    ENDFUNC

    *- PROT GetAttribNumb() - Convert attribute chars into numbers (rel or abs)
    PROTECTED FUNCTION GetAttribNumb(m.cAttribs, m.dwAttr)
        LOCAL cDesAttribs, cNewAttr, c2Do, nPosn, cThisAttr, bAdd, cLtr, ;
          nRetAttr

        * Attribute numbers are additive as follows:
        *                Numb   Ret. Char.  Bit Posn.
        *   ReadOnly   -    1       R           0
        *   Hidden     -    2       H           1
        *   System     -    4       S           2
        *   Directory  -   16       D           4
        *   Archive    -   32       A           5
        *   Normal     -  128       N           7
        *   Temporary  -  512       T           9
        *   Compressed - 2048       C          11

        * The passed cAttribs string can be either:
        *   Absolute characters like "RA" or "RSH"
        *   Relative space-separated characters like "-R +A"

        * We're to return dwAttr to reflect the desired result
        m.cDesAttribs = UPPER(m.cAttribs)
        IF [+] $ m.cDesAttribs OR [-] $ m.cDesAttribs

            * Convert the current attributes into letters
            m.cNewAttr = THIS.AttrDW2Chars(m.dwAttr)

            * Now, doctor that string to end up with the characters we want
            m.c2Do = ALLTRIM(m.cDesAttribs)
            DO WHILE NOT EMPTY(m.c2Do)

                * Extract one relative attribute change
                m.nPosn = AT(' ', m.c2Do)
                IF m.nPosn = 0
                    m.cThisAttr = m.c2Do
                    m.c2Do = 0
                ELSE
                    m.cThisAttr = LEFT(m.c2Do, m.nPosn-1)
                    m.c2Do = LTRIM(SUBSTR(m.c2Do, m.nPosn+1))
                ENDIF
                m.bAdd = (m.cThisAttr = [+])
                m.cLtr = SUBSTR(m.cThisAttr, 2, 1)

                * Add or subtract that letter
                DO CASE

                * Don't add if it's already there
                CASE m.bAdd AND NOT m.cLtr $ m.cNewAttr
                    m.cNewAttr = m.cNewAttr + m.cLtr

                * Don't subtract unless it's there
                CASE m.cLtr $ m.cNewAttr AND NOT m.bAdd
                    m.cNewAttr = STRTRAN(m.cNewAttr, m.cLtr, '')
                ENDCASE
            ENDDO

            * These are the new absolute attributes we want
            m.cDesAttribs = m.cNewAttr
        ENDIF

        * Convert the absolute attributes into a number
        m.nRetAttr = 0
        IF 'R' $ m.cDesAttribs
            m.nRetAttr = 1
        ENDIF
        IF 'H' $ m.cDesAttribs
            m.nRetAttr = m.nRetAttr + 2
        ENDIF
        IF 'S' $ m.cDesAttribs
            m.nRetAttr = m.nRetAttr + 4
        ENDIF
        IF 'D' $ m.cDesAttribs
            m.nRetAttr = m.nRetAttr + 16
        ENDIF
        IF 'A' $ m.cDesAttribs
            m.nRetAttr = m.nRetAttr + 32
        ENDIF
        IF 'N' $ m.cDesAttribs
            m.nRetAttr = m.nRetAttr + 128
        ENDIF
        IF 'T' $ m.cDesAttribs
            m.nRetAttr = m.nRetAttr + 512
        ENDIF
        IF 'C' $ m.cDesAttribs
            m.nRetAttr = m.nRetAttr + 2048
        ENDIF
        RETURN m.nRetAttr
    ENDFUNC

    *- PROT AttrDW2Chars() - Convert an attribute double-word into characters
    PROTECTED FUNCTION AttrDW2Chars(m.dwAttrsIn)
        LOCAL cRetChars

        * Attribute numbers are additive as follows:
        *                Numb   Ret. Char.  Bit Posn.
        *   ReadOnly   -    1       R           0
        *   Hidden     -    2       H           1
        *   System     -    4       S           2
        *   Directory  -   16       D           4
        *   Archive    -   32       A           5
        *   Normal     -  128       N           7
        *   Temporary  -  512       T           9
        *   Compressed - 2048       C          11
        m.cRetChars = ''
        IF BITTEST(m.dwAttrsIn, 11)               && Compressed
            m.cRetChars = 'C'
        ENDIF
        IF BITTEST(m.dwAttrsIn, 9)                && Temporary
            m.cRetChars = 'T' + m.cRetChars
        ENDIF
        IF BITTEST(m.dwAttrsIn, 7)                && Normal
            m.cRetChars = 'N' + m.cRetChars
        ENDIF
        IF BITTEST(m.dwAttrsIn, 5)                && Archive
            m.cRetChars = 'A' + m.cRetChars
        ENDIF
        IF BITTEST(m.dwAttrsIn, 4)                && Directory
            m.cRetChars = 'D' + m.cRetChars
        ENDIF
        IF BITTEST(m.dwAttrsIn, 2)                && System
            m.cRetChars = 'S' + m.cRetChars
        ENDIF
        IF BITTEST(m.dwAttrsIn, 1)                && Hidden
            m.cRetChars = 'H' + m.cRetChars
        ENDIF
        IF BITTEST(m.dwAttrsIn, 0)                && ReadOnly
            m.cRetChars = 'R' + m.cRetChars
        ENDIF
        RETURN m.cRetChars
    ENDFUNC

    *- PROT GetLastAPIError() - Return the last error message
    PROTECTED FUNCTION GetLastAPIError(m.cMsgIn, m.nForceNum)
        LOCAL nDOSErrNum, cDosErrMsg, nFlags, cDOSBuffer, nLen, cBuffer, cRetMsg

        * Input Notes:
        *   cMsgIn - User-defined message preface (optional)

        * Get the last error from window
        IF VARTYPE(m.nForceNum) = 'N'
            m.nDOSErrNum = m.nForceNum
        ELSE
            m.nDOSErrNum = GetLastError()
        ENDIF
        m.cDosErrMsg = ''

        * Now, get the error message (if we can)
        m.nFlags = FORMAT_MESSAGE_ALLOCATE_BUFFER + FORMAT_MESSAGE_FROM_SYSTEM + ;
          FORMAT_MESSAGE_IGNORE_INSERTS
        m.cDOSBuffer = ''
        TRY
            m.nLen = FormatMessage(m.nFlags, 0, m.nDOSErrNum, 0, @m.cDOSBuffer, 0, 0)
        CATCH
            m.nLen = 0
            m.cDOSBuffer = ''
        ENDTRY
        IF m.nLen <> 0
            m.cBuffer = REPLICATE(Chr(0), 500)
            = CopyMemory(@m.cBuffer, m.cDOSBuffer, m.nLen)
            = LocalFree(m.cDOSBuffer)
            m.cDosErrMsg = STRTRAN(LEFT(m.cBuffer, m.nLen), Chr(13)+Chr(10), " ")
        ENDIF

        * Add this to our passed message as appropriate
        m.cRetMsg = 'API Error ' + TRANSFORM(m.nDOSErrNum)
        IF NOT EMPTY(m.cDosErrMsg)
            m.cRetMsg = m.cRetMsg + ' - ' +  ALLTRIM(m.cDosErrMsg)
        ENDIF
        IF VARTYPE(m.cMsgIn) = 'C' AND NOT EMPTY(m.cMsgIn)
            m.cRetMsg = m.cMsgIn + [ (] + m.cRetMsg + [)]
        ENDIF

        * Set our last error properties
        THIS.nLastErrorNumb = m.nDOSErrNum
        THIS.cLastErrorMsg = m.cRetMsg

        * Done
        RETURN m.cRetMsg
    ENDFUNC

    *- ClearError() - Clear our error properties
    FUNCTION ClearError()

        * Clear our error settings
        THIS.nLastErrorNumb = 0
        THIS.cLastErrorMsg = ''
    ENDFUNC

    *- Release() - Removes this object from memory
    *    Input: none
    *     Retn: object gone, memory released
    FUNCTION Release
        RELEASE THIS
    ENDFUNC
ENDDEFINE
