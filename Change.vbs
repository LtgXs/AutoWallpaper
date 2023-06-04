Set sh = CreateObject("Shell.Application")
Set FSO = CreateObject("Scripting.FileSystemObject")
Set f = FSO.GetFile("wallpaper.jpg")
Set vs = sh.NameSpace(f.ParentFolder.Path).ParseName(f.Name).Verbs
For Each v In vs
  If v.Name = "…Ë÷√Œ™◊¿√Ê±≥æ∞(&B)" Then v.DoIt
Next
WScript.Sleep 5000