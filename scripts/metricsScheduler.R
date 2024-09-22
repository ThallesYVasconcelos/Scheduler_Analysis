# Pacotes necessários
library(dplyr)
library(lubridate)

# Arquivo CSV gerado pelo script Bash
input_file <- "process_log.csv"

# Leitura do CSV em um data frame
process_log <- read.csv(input_file, stringsAsFactors = FALSE)

# Converte as colunas Start_Time e End_Time para tipo datetime
process_log$Start_Time <- ymd_hms(process_log$Start_Time)
process_log$End_Time <- ymd_hms(process_log$End_Time)

# Remove linhas que ainda não têm End_Time (processos em execução)
process_log <- process_log %>% filter(!is.na(End_Time))

# Cálculo das métricas
process_log <- process_log %>%
  mutate(
    # Turnaround Time: Diferença entre o End_Time e Start_Time
    Turnaround_Time = as.numeric(difftime(End_Time, Start_Time, units = "secs")),
    
    # Waiting Time: Diferença entre o horário de início do processo e o tempo de execução real (Turnaround Time)
    # Supondo que o processo começou a rodar assim que foi adicionado
    Waiting_Time = 0,  # Em sistemas sem preempção, o waiting time pode ser zero, ajuste se necessário
    
    # Response Time: Diferença entre o Start_Time e o horário de início (neste caso, Start_Time também, pois não há preempção)
    Response_Time = 0  # Supondo que o processo responde assim que começa, ajuste se necessário
  )

# Exibe o dataframe com as novas colunas calculadas
print(process_log)

# Caso queira salvar os resultados em um novo CSV
write.csv(process_log, "process_metrics.csv", row.names = FALSE)


