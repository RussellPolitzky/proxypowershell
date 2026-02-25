<#
.SYNOPSIS
    Sets the HTTP_PROXY and HTTPS_PROXY environment variables for the current PowerShell session.

.DESCRIPTION
    The Set-SessionProxy function prompts the user securely for a proxy username and password.
    It URL-encodes these credentials to handle any special characters and constructs the
    full proxy URLs. These URLs are then assigned to the process-level environment variables
    `HTTP_PROXY` and `HTTPS_PROXY`.

    These environment variables will be available to the current PowerShell session and any 
    child processes, such as `uv`, `git`, or `curl`, that expect these standard variables.
    
    The username and password are not saved to disk or persistent environment variables
    to maintain security.

.PARAMETER ProxyServer
    The hostname or IP address of the proxy server. Defaults to 'proxy.abc.co.za'.

.PARAMETER ProxyPort
    The port number of the proxy server. Defaults to 8080.

.EXAMPLE
    Set-SessionProxy

    Prompts for credentials and sets proxy to http://username:password@proxy.abc.co.za:8080

.EXAMPLE
    Set-SessionProxy -ProxyServer "my-custom-proxy.com" -ProxyPort 3128

    Prompts for credentials and sets proxy to the specified custom server and port.

.NOTES
    Author: Russell Politzky, Gemini
#>
function Set-SessionProxy {
    [CmdletBinding()]
    param (
        [string]$ProxyServer = 'proxy.abc.co.za',
        [int]$ProxyPort = 8080
    )

    Write-Host "Please enter your proxy credentials." -ForegroundColor Cyan

    $username = Read-Host "Enter Proxy Username"
    if ([string]::IsNullOrWhiteSpace($username)) {
        Write-Error "Username is required."
        return
    }

    $securePassword = Read-Host "Enter Proxy Password" -AsSecureString
    if ($null -eq $securePassword) {
        Write-Error "Password is required."
        return
    }

    $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))


    # URL encode the credentials
    # Use [uri]::EscapeDataString to safely encode special characters like @, #, $, etc.
    $encodedUsername = [uri]::EscapeDataString($username)
    $encodedPassword = [uri]::EscapeDataString($password)

    # Construct the proxy string
    $proxyUrl = "http://${encodedUsername}:${encodedPassword}@${ProxyServer}:${ProxyPort}"

    # Set the environment variables for the current process
    [Environment]::SetEnvironmentVariable("HTTP_PROXY", $proxyUrl, "Process")
    [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $proxyUrl, "Process")

    Write-Host "Proxy environment variables (HTTP_PROXY, HTTPS_PROXY) have been set successfully for this session." -ForegroundColor Green
}
