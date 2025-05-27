package osfiles

// Original:  1/22/2014 - Ken Green

// This package is a collection of file, directory and path utilities:
//  IsFile(fileName string) returns true if the file exists, else false.
//  DirInfo(dirNm, spec, inclDirs) returns a slice of matching folder entries.
//  FileToString(cFullNm) - Return a file's content as a string
//  StringToFile(content []byte, cFullNm string) - Write a string to a file
//  DeleteFile(cFullNm string) - Delete a file

//  type FileInfo interface:
//      Name() string       // base name of the file
//      Size() int64        // length in bytes for regular files; system-dependent for others
//      Mode() FileMode     // file mode bits
//      ModTime() time.Time // modification time
//      IsDir() bool        // abbreviation for Mode().IsDir()
//      Sys() interface{}   // underlying data source (can return nil)

import (
    "io/ioutil"
    "os"
    "path/filepath"
)

// IsFile(fileName string) returns true if the file exists, else false.
func IsFile(fileName string) bool {
    src, err := os.Open(fileName)
    defer src.Close()
    if err != nil {
        return false
    }
    return true
}

// DirInfo(dirNm, spec, inclDirs) returns a slice of matching directory
//  entries. fileSpec may include wild cards (optional, default="*.*"),
//  inclDirs if true will include subdir entries (optional, default="false").
func DirInfo(dirNm string, fileSpec string, inclDirs bool) ([]os.FileInfo, error) {
    spec := "*.*"
    getSubs := false
    if len(fileSpec) > 0 {
        spec = fileSpec
    }
    if (inclDirs) {
        getSubs = true
    }

	dirList, err := ioutil.ReadDir(dirNm)
	if err != nil {
		return nil, err
	}

    retList, err := cleanList(dirList, spec, getSubs)
    return retList, err
}

// cleanList() - Returns a slice containing only matching directory entries
func cleanList(oList []os.FileInfo, fileSpec string, inclDirs bool) ([]os.FileInfo, error) {
    var nextPosn int = 0
    for i, oFile := range oList {
        if oFile.IsDir() && !inclDirs {     // skip subdirs unless wanted
            continue
        }
        if !!oFile.IsDir() {    // not a file so ignore
            continue
        }

        // Name must match our fileSpec
        matched, err := filepath.Match(fileSpec, oFile.Name())
        if err != nil {     // malformed pattern
            return nil, err
        }
        if matched {
            if i != nextPosn {
                oList[nextPosn] = oFile
            }
            nextPosn += 1
        }
    }

    // Create a slice containing only our matches
    var listSlice []os.FileInfo = oList[0:nextPosn]
    return listSlice, nil
}

// FileToString(cFullNm) - Return a file's content as a string
func FileToString(cFullNm string) (content string, err error) {
    text, err := ioutil.ReadFile(cFullNm)
    content = string(text)
    return content, err
}

// StringToFile(content string, cFullNm string) - Write a string to a file
func StringToFile(content string, cFullNm string) (err error) {

    // 0 = no special permissions (see os.FileMode)
    err = ioutil.WriteFile(cFullNm, []byte(content), 0)
    return err
}

// DeleteFile(cFullNm string) - Delete a file
func DeleteFile(cFullNm string) (err error) {

    // If the file doesn't exist, we're done
    if !IsFile(cFullNm) {
        return nil
    }
    err = os.Remove(cFullNm)
    return err
}
