# Proxy PowerShell

This repository contains a simple, secure PowerShell script to set up `HTTP_PROXY` and `HTTPS_PROXY` environment variables for your current session.

## Why use this?
Applications like `uv`, `git`, Python packages, and others often rely on standard `HTTP_PROXY` and `HTTPS_PROXY` environment variables. When operating in an enterprise environment that requires authentication to pass through the proxy, handling special characters in the username or password (like `@` or `!`) can be problematic.

This script will:
1. Securely prompt you for your credentials.
2. Properly URL-encode your username and password.
3. Automatically set the environment variables for the current PowerShell session.
4. Not save your password anywhere.

## How to Use

1. **Load the script into your current session**:
    Dot-source the file so the function becomes available in your terminal.
    ```powershell
    . .\Set-SessionProxy.ps1
    ```

2. **Run the function with default settings**:
    By default, it uses `proxy.abc.co.za` on port `8080`.
    ```powershell
    Set-SessionProxy
    ```
    A secure Windows credential prompt will appear asking for your username and password.

3. **Override the defaults**:
    You can easily specify a different proxy server or port.
    ```powershell
    Set-SessionProxy -ProxyServer "my-custom-proxy.com" -ProxyPort 3128
    ```

4. **Verify it worked**:
    ```powershell
    $env:HTTP_PROXY
    $env:HTTPS_PROXY
    ```

## Notes
These variables are only set at the **Process** level. This means when you close the PowerShell window, the proxy credentials are gone, assuring that your plaintext encoded password does not linger on your machine.
