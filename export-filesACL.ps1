$Path = "D:\"
$exportCSV="get-acl.csv"

$Folders = Get-ChildItem $Path -Directory -Recurse
Foreach ($Folder in $Folders) {
    $FolderPath = $Folder.FullName
    $Arr = @()
    $Files = Get-ChildItem $FolderPath -File
    Foreach ($File in $Files) {
        $Acl = Get-Acl $File.FullName
        Foreach ($Access in $Acl.Access) {
            $Properties = [ordered]@{
                Path          = $File.FullName
                IdentityReference = $Access.IdentityReference
                AccessControlType = $Access.AccessControlType
                FileSystemRights  = $Access.FileSystemRights
                IsInherited       = $Access.IsInherited
            }
            $Obj = New-Object -TypeName PSObject -Property $Properties
            $Arr += $Obj
        }
    }
    $Acl = Get-Acl $FolderPath
    Foreach ($Access in $Acl.Access) {
        $Properties = [ordered]@{
            Path          = $FolderPath
            IdentityReference = $Access.IdentityReference
            AccessControlType = $Access.AccessControlType
            FileSystemRights  = $Access.FileSystemRights
            IsInherited       = $Access.IsInherited
        }
        $Obj = New-Object -TypeName PSObject -Property $Properties
        $Arr += $Obj
    }
    $Arr | Select-Object Path,IdentityReference,AccessControlType,FileSystemRights,IsInherited |
           Export-Csv -Path "$FolderPath\$exportCSV" -NoTypeInformation -Append:$False
}
