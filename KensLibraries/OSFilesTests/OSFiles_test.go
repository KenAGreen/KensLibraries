package osfiles

import (
    "testing"
    "fmt"
)


func TestIsFile(t *testing.T) {
	fileNm := "OSFiles.go"
	if !IsFile(fileNm) {
		t.Errorf("IsFile failed, file does exist")
	}
	fileNm = "Junk.txt"
	if IsFile(fileNm) {
		t.Errorf("IsFile failed, file does not exist")
	}
}

func TestDirInfo(t *testing.T) {
    oList, err := DirInfo(".\\", "*.go", false)
    if err != nil {
		t.Errorf("DirInfo failed: ", err)
    }
    nLen := len(oList)
    if nLen != 2 {
        msg := fmt.Sprintf("DirInfo failed for *.go, got %d entries (should be 2)", nLen)
		t.Errorf(msg)
    }

    oList, err = DirInfo(".\\", "*.xyz", false)
    if err != nil {
		t.Errorf("DirInfo failed: ", err)
    }
    nLen = len(oList)
    if nLen != 0 {
        msg := fmt.Sprintf("DirInfo failed for *.xyz, got %d entries (should be 0)", nLen)
		t.Errorf(msg)
    }
}

func TestFileToString(t *testing.T) {
    fileNm := "\\EMAIL\\PROJ\\SRC\\OSFILES\\Test.txt"
    content, err := FileToString(fileNm)
    if err != nil {
		t.Errorf("FileToString failed: ", err)
    }
    flen := len(content)
    if flen < 80 {
		t.Errorf("FileToString failed: only read %d bytes.", flen)
    }
}

func TestStringToFile(t *testing.T) {
    fileNm := "\\EMAIL\\PROJ\\SRC\\OSFILES\\Test2.txt"
    text, err := FileToString(fileNm)
    if err != nil {
		t.Errorf("FileToString failed: ", err)
    }

    newFile := "\\EMAIL\\PROJ\\SRC\\OSFILES\\TestOut.txt"
    err = StringToFile(text, newFile)
    if err != nil {
		t.Errorf("StringToFile failed: ", err)
    }
}

func TestDeleteFile(t *testing.T) {
    fileNm := "\\EMAIL\\PROJ\\SRC\\OSFILES\\Junk.txt"
    textOut := "Now is the time for all good men...well, you know!\n"
    err := StringToFile(textOut, fileNm)
    if err != nil {
		t.Errorf("StringToFile failed: ", err)
    }

    err = DeleteFile(fileNm)
    if err != nil {
		t.Errorf("DeleteFile failed: ", err)
    }
}
