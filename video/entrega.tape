# Vídeo da entrega — Atividade Serverless (Rota Vital)
# Gerado com VHS (charmbracelet): executa os comandos REAIS do projeto, nada é simulado.
#
# Como gerar (na raiz do repositório, com o Docker aberto e Timeout: 3 no template.yaml + sam build):
#   vhs video/entrega.tape
#
# Obs.: usa a porta 3001 porque a 3000 estava ocupada por outro programa na máquina.

Output video/entrega-serverless.mp4

Set Shell "bash"
Set FontSize 18
Set Width 1400
Set Height 850
Set Padding 24
Set Theme "Dracula"
Set TypingSpeed 20ms
Set WaitTimeout 120s
Set WaitPattern /\$\s*$/

# --- preparação (fora do vídeo) ---
Hide
Type "cd rota-vital-guia && export SAM_CLI_TELEMETRY=0 PS1='$ ' && clear" Enter
Sleep 1s
Show

# --- Parte 0: título ---
Type 'echo "### Atividade Individual 1 — Serverless | Rota Vital | Gabriel Brito Ferreira Dias"' Enter
Wait
Type "sam --version" Enter
Wait
Sleep 3s

# --- Parte 1: invocação com evento ---
Hide
Type "clear" Enter
Show
Type 'echo "### 1. Invocação com evento (cold start x segunda invocação)"' Enter
Wait
Type "head -6 events/pedido.json" Enter
Wait
Sleep 2s
Type "time sam local invoke -e events/pedido.json" Enter
Wait
Sleep 3s
Type "time sam local invoke -e events/pedido.json" Enter
Wait
Sleep 4s

# --- Parte 2a: HTTP sem warm containers ---
Hide
Type "clear" Enter
Show
Type 'echo "### 2a. HTTP sem warm containers (um container novo por chamada)"' Enter
Wait
Type "sam local start-api --port 3001 > /tmp/api.log 2>&1 &" Enter
Wait
Type 'until curl -s -o /dev/null http://127.0.0.1:3001/; do sleep 1; done; echo "API pronta"' Enter
Wait
Type `curl -s -X POST http://127.0.0.1:3001/guias -H "Content-Type: application/json" -d '{"requisicaoId":"R-002","hospital":"H-Caruaru"}'; echo` Enter
Wait
Sleep 1s
Type `curl -s -X POST http://127.0.0.1:3001/guias -H "Content-Type: application/json" -d '{"requisicaoId":"R-002","hospital":"H-Caruaru"}'; echo` Enter
Wait
Sleep 1s
Type `curl -s -X POST http://127.0.0.1:3001/guias -H "Content-Type: application/json" -d '{"requisicaoId":"R-002","hospital":"H-Caruaru"}'; echo` Enter
Wait
Sleep 3s
Type "kill -INT %1; wait" Enter
Wait
Sleep 1s

# --- Parte 2b: HTTP com warm containers LAZY ---
Hide
Type "clear" Enter
Show
Type 'echo "### 2b. HTTP com --warm-containers LAZY (container reaproveitado)"' Enter
Wait
Type "sam local start-api --port 3001 --warm-containers LAZY > /tmp/api.log 2>&1 &" Enter
Wait
Type 'until curl -s -o /dev/null http://127.0.0.1:3001/; do sleep 1; done; echo "API pronta"' Enter
Wait
Type `curl -s -X POST http://127.0.0.1:3001/guias -H "Content-Type: application/json" -d '{"requisicaoId":"R-002","hospital":"H-Caruaru"}'; echo` Enter
Wait
Sleep 1s
Type `curl -s -X POST http://127.0.0.1:3001/guias -H "Content-Type: application/json" -d '{"requisicaoId":"R-002","hospital":"H-Caruaru"}'; echo` Enter
Wait
Sleep 1s
Type `curl -s -X POST http://127.0.0.1:3001/guias -H "Content-Type: application/json" -d '{"requisicaoId":"R-002","hospital":"H-Caruaru"}'; echo` Enter
Wait
Sleep 4s

# --- Parte 3: limite de tempo (Timeout 3) ---
Hide
Type "clear" Enter
Show
Type 'echo "### 3. Timeout de 3s com demorar=true"' Enter
Wait
Type "grep -n Timeout template.yaml" Enter
Wait
Sleep 1s
Type `curl -s -X POST http://127.0.0.1:3001/guias -H "Content-Type: application/json" -d '{"requisicaoId":"R-003","demorar":true}'; echo` Enter
Wait
Sleep 1s
Type 'grep -i -A2 "timed out" /tmp/api.log' Enter
Wait
Sleep 4s
Type "kill -INT %1; wait" Enter
Wait
Sleep 1s

# --- Parte 3b: ajuste do Timeout 3 -> 10 ---
Hide
Type "clear" Enter
Show
Type 'echo "### 3b. Ajuste: Timeout 3 -> 10"' Enter
Wait
Type "sed -i '' 's/Timeout: 3$/Timeout: 10/' template.yaml && grep -n Timeout template.yaml" Enter
Wait
Sleep 1s
Type "sam build" Enter
Wait
Sleep 1s
Type "sam local start-api --port 3001 --warm-containers LAZY > /tmp/api.log 2>&1 &" Enter
Wait
Type 'until curl -s -o /dev/null http://127.0.0.1:3001/; do sleep 1; done; echo "API pronta"' Enter
Wait
Type `time curl -s -X POST http://127.0.0.1:3001/guias -H "Content-Type: application/json" -d '{"requisicaoId":"R-003","demorar":true}'; echo` Enter
Wait
Sleep 4s
Type "kill -INT %1; wait" Enter
Wait

# --- Encerramento ---
Type 'echo "### Fim — código e evidências no repositório"' Enter
Wait
Sleep 3s
