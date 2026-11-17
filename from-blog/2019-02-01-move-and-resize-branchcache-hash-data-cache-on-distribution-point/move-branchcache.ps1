<#
Source: Move and Resize BranchCache Hash/Data Cache on Distribution Point
Blog: https://hiway65nblog.blogspot.com/2019/02/move-and-resize-branchcache-hashdata.html
Published: February 1, 2019
Labels: BranchCache, DP Share, Powershell, SCCM, SCCM Current Branch, System Center Configuration Manager
#>

#Check if cache already moved
$CacheStatus = Get-BCStatus
If(($CacheStatus.HashCache.CacheFileDirectoryPath -like 'E:\')-or($CacheStatus.DataCache.CacheFileDirectoryPath -like 'E:\'))
{
    Set-BCDataCacheEntryMaxAge -TimeDays 10
    Return "Already Moved"
}
elseif ((Get-Volume -DriveLetter E).FileSystem -ne "NTFS")
{
    # Set Cache Sizes
    get-bchashcache | set-bccache -Percentage 2 -Force -Confirm:$false
    get-bcdatacache | set-bccache -Percentage 1 -Force -Confirm:$false
    Set-BCDataCacheEntryMaxAge -TimeDays 10
    Return "Destination Not NTFS"
}
else
{
    #Create New Directories
    $rootPath = "E:\data\BranchCache"
    New-Item -Path $rootPath -ItemType Directory
    "This is used to hold the caches for branchcache." | Out-File $rootPath\Readme.txt

    $NewHashDirectory = $rootPath + "\Hash"
    New-Item -Path $NewHashDirectory -ItemType Directory
    $NewDataDirectory = $rootPath + "\Data"
    New-Item -Path $NewDataDirectory -ItemType Directory

    #Clear Caches
    Clear-BCCache -Force -Confirm:$false

    #Move Hash Cache
    Set-BCCache -Path $CacheStatus.HashCache.CacheFileDirectoryPath -MoveTo $NewHashDirectory
    #Data Cache
    Set-BCCache -Path $CacheStatus.DataCache.CacheFileDirectoryPath -MoveTo $NewDataDirectory

    # Set Cache Sizes
    get-bchashcache | set-bccache -Percentage 20 -Force -Confirm:$false
    get-bcdatacache | set-bccache -Percentage 2 -Force -Confirm:$false
    Set-BCDataCacheEntryMaxAge -TimeDays 10

    Return "Move Complete"
}
