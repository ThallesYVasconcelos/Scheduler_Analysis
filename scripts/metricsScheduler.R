library(dplyr)
library(lubridate)

# Arquivo CSV gerado pelo script Bash
input_file <- "process_log.csv"

# Leitura do CSV em um data frame
process_log <- read.csv(input_file, stringsAsFactors = FALSE)

# Converte as colunas Start_Time, First_Activation e End_Time para tipo datetime
process_log$Start_Time <- ymd_hms(process_log$Start_Time)
process_log$First_Activation <- ymd_hms(process_log$First_Activation)
process_log$End_Time <- ymd_hms(process_log$End_Time)

# Remove linhas que ainda não têm End_Time (processos em execução)
process_log <- process_log %>% filter(!is.na(End_Time))

# Cálculo das métricas
process_log <- process_log %>%
  mutate(
    # Turnaround Time: Diferença entre End_Time e Start_Time
    Turnaround_Time = as.numeric(difftime(End_Time, Start_Time, units = "secs")),
    
    # Response Time: Diferença entre First_Activation e Start_Time
    Response_Time = as.numeric(difftime(First_Activation, Start_Time, units = "secs")),
    
    # Waiting Time: Turnaround Time menos Response Time
    Waiting_Time = Turnaround_Time - Response_Time
  )

# Exibe o dataframe com as novas colunas calculadas
print(process_log)

# Salva os resultados em um novo CSV
write.csv(process_log, "process_metrics.csv", row.names = FALSE)

