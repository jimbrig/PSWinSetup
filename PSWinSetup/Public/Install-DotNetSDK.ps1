Function Install-DotNetSDK {
    $uri = "https://download.visualstudio.microsoft.com/download/pr/c1bfbb13-ad09-459c-99aa-8971582af86e/61553270dd9348d7ba29bacfbb4da7bd/dotnet-sdk-5.0.400-win-x64.exe"
    Invoke-RestMethod -Uri $uri -OutFile "$HOME\Downloads\dotnet-sdk-5.0.400.exe"
    Set-Location "$HOME\Downloads"
    .\dotnet-sdk-5.0.400.exe /install
}
