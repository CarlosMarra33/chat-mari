$events = @(
    @{ name = 'read dentro';   e = @{ tool_name = 'read';   tool_input = @{ file_path = 'C:\Users\carlos\Documents\chat-mari\normas\NORMAS.md' } } },
    @{ name = 'read fora';     e = @{ tool_name = 'read';   tool_input = @{ file_path = 'C:\Users\carlos\Documents\outro\segredo.txt' } } },
    @{ name = 'prefixo irma';  e = @{ tool_name = 'read';   tool_input = @{ file_path = 'C:\Users\carlos\Documents\chat-mari-evil\x.txt' } } },
    @{ name = 'dotdot';        e = @{ tool_name = 'read';   tool_input = @{ file_path = '..\..\Windows\win.ini' } } },
    @{ name = 'relativo';      e = @{ tool_name = 'read';   tool_input = @{ file_path = 'normas/NORMAS.md' } } },
    @{ name = 'barras /';      e = @{ tool_name = 'read';   tool_input = @{ file_path = 'C:/Users/carlos/Documents/chat-mari/AGENTS.md' } } },
    @{ name = 'exec';          e = @{ tool_name = 'exec';   tool_input = @{ command = 'dir' } } },
    @{ name = 'mcp';           e = @{ tool_name = 'mcp_call_tool'; tool_input = @{ server_name = 'agentmemory' } } },
    @{ name = 'edit';          e = @{ tool_name = 'edit';   tool_input = @{ file_path = 'C:\Users\carlos\Documents\chat-mari\AGENTS.md'; old_string = 'x'; new_string = 'y' } } },
    @{ name = 'grep sem path'; e = @{ tool_name = 'grep';   tool_input = @{ pattern = 'norma' } } }
)

$env:DEVIN_PROJECT_DIR = 'C:\Users\carlos\Documents\chat-mari'
$script = Join-Path $env:DEVIN_PROJECT_DIR '.devin\hooks\check-scope.ps1'

foreach ($t in $events) {
    $json = $t.e | ConvertTo-Json -Compress -Depth 5
    Write-Output "=== $($t.name)"
    $out = $json | & powershell -NoProfile -ExecutionPolicy Bypass -File $script
    if ($out) { Write-Output "   $out" } else { Write-Output "   (passou, sem saida)" }
}
