#!/bin/bash

# Arquivo CSV onde os dados serão armazenados
output_file="process_log.csv"

# Verifica se o arquivo CSV já existe, se não, cria o cabeçalho
if [ ! -f "$output_file" ]; then
    echo "Process_ID,Process_Name,Start_Time,End_Time,Priority,Scheduling_Policy" >> "$output_file"
fi

# Função para capturar o tempo atual
get_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Função para capturar a política de escalonamento e prioridade de um processo
get_process_info() {
    pid=$1
    # Captura a prioridade do processo (nice value) e a política de escalonamento
    priority=$(ps -o ni -p "$pid" --no-headers 2>/dev/null)  # Captura a prioridade
    policy=$(ps -o policy -p "$pid" --no-headers 2>/dev/null)  # Captura a política de escalonamento
    
    # Caso algum campo seja vazio, preenche com "Unknown"
    if [ -z "$priority" ]; then
        priority="Unknown"
    fi
    if [ -z "$policy" ]; then
        policy="Unknown"
    fi

    echo "$priority,$policy"
}

# Função para monitorar os processos em execução
monitor_processes() {
    while true; do
        # Captura a lista de processos ativos (exceto processos de cabeçalhos)
        ps -eo pid,comm,lstart --no-headers > current_processes.txt

        # Loop para verificar se algum processo novo começou
        while read -r pid name start_time; do
            # Se o processo já não estiver no log, considera como novo
            if ! grep -q "^$pid," "$output_file"; then
                # Captura o início do processo
                start_timestamp=$(get_timestamp)

                # Captura a prioridade e a política de escalonamento do processo
                process_info=$(get_process_info "$pid")

                # Armazena as informações no CSV
                echo "$pid,\"$name\",$start_timestamp,,$process_info" >> "$output_file"
            fi
        done < current_processes.txt

        # Verifica se algum processo terminou
        awk -F ',' 'NR>1 {print $1}' "$output_file" | while read -r logged_pid; do
            # Se o processo não estiver mais em execução, captura o fim
            if ! ps -p "$logged_pid" > /dev/null; then
                end_timestamp=$(get_timestamp)
                # Substitui a linha com o processo encerrado e adiciona o horário de término
                sed -i "/^$logged_pid,/ s/,,/,$end_timestamp,/" "$output_file"
            fi
        done

        # Limpa o arquivo temporário
        rm -f current_processes.txt

        # Pausa de 5 segundos antes de verificar novamente
        sleep 5
    done
}

# Inicia o monitoramento
monitor_processes
