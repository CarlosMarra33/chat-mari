# Guarda de escopo do chat-mari.
# Permite APENAS ferramentas de leitura, e somente em caminhos dentro de
# $DEVIN_PROJECT_DIR. Qualquer outra ferramenta ou caminho externo = block.

function Block([string]$reason) {
    [Console]::WriteLine((@{ decision = "block"; reason = $reason } | ConvertTo-Json -Compress))
    exit 0
}

$raw = [Console]::In.ReadToEnd()
try {
    $event = $raw | ConvertFrom-Json
} catch {
    Block "Evento de hook invalido; chamada bloqueada por seguranca."
}

$allowedTools = @('read','edit', 'write', 'grep', 'find_file_by_name', 'notebook_read')
if ($allowedTools -notcontains $event.tool_name) {
    Block "Ferramenta '$($event.tool_name)' desativada neste projeto. Ele serve apenas para redigir respostas de atendimento com base nos arquivos locais."
}

$project = [IO.Path]::GetFullPath($env:DEVIN_PROJECT_DIR).TrimEnd('\')
$projectPrefix = $project + '\'

foreach ($prop in 'file_path', 'path', 'notebook_path', 'workdir') {
    $value = $event.tool_input.$prop
    if (-not $value) { continue }

    if ($value -match '\.\.') {
        Block "Caminho com '..' bloqueado: $value"
    }

    $full = if ([IO.Path]::IsPathRooted($value)) {
        [IO.Path]::GetFullPath($value)
    } else {
        [IO.Path]::GetFullPath((Join-Path $project $value))
    }

    if ($full -ne $project -and -not $full.StartsWith($projectPrefix, 'OrdinalIgnoreCase')) {
        Block "Acesso fora da pasta do projeto bloqueado: $value"
    }
}

exit 0
