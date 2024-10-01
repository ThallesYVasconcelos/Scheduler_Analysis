# Carregar bibliotecas
library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr) # Para a função gather()

# Ler o arquivo CSV
process_data <- read.csv("./process_log.csv")

# Converter colunas de tempo para formato datetime
process_data$Start_Time <- as.POSIXct(process_data$Start_Time, format="%Y-%m-%d %H:%M:%S")
process_data$First_Activation <- as.POSIXct(process_data$First_Activation, format="%Y-%m-%d %H:%M:%S")
process_data$End_Time <- as.POSIXct(process_data$End_Time, format="%Y-%m-%d %H:%M:%S")

# Calcular as métricas
process_data <- process_data %>%
  mutate(Turnaround_Time = difftime(End_Time, Start_Time, units = "secs"),
         Response_Time = difftime(First_Activation, Start_Time, units = "secs"),
         Waiting_Time = Turnaround_Time - difftime(End_Time, First_Activation, units = "secs"))

# Remover linhas com valores NA
process_data <- na.omit(process_data)

# Adicionar contagem de processos por política de escalonamento
process_data <- process_data %>%
  group_by(Scheduling_Policy) %>%
  mutate(Process_Count = n())

# 1. Histogramas para cada métrica agrupados por política

# Turnaround Time por política com cores
ggplot(process_data, aes(x=Turnaround_Time, fill=Scheduling_Policy)) +
  geom_histogram(binwidth=10, position="dodge", color="black") +
  scale_fill_brewer(palette="Set3") +
  labs(title=paste0("Histograma de Turnaround Time por Política (", unique(process_data$Process_Count), " processos)"),
       x="Turnaround Time (s)", y="Frequência") +
  theme_minimal() +
  theme(legend.position = "top")

# Response Time por política com cores
ggplot(process_data, aes(x=Response_Time, fill=Scheduling_Policy)) +
  geom_histogram(binwidth=10, position="dodge", color="black") +
  scale_fill_brewer(palette="Set2") +
  labs(title=paste0("Histograma de Response Time por Política (", unique(process_data$Process_Count), " processos)"),
       x="Response Time (s)", y="Frequência") +
  theme_minimal() +
  theme(legend.position = "top")

# Waiting Time por política com cores
ggplot(process_data, aes(x=Waiting_Time, fill=Scheduling_Policy)) +
  geom_histogram(binwidth=10, position="dodge", color="black") +
  scale_fill_brewer(palette="Set1") +
  labs(title=paste0("Histograma de Waiting Time por Política (", unique(process_data$Process_Count), " processos)"),
       x="Waiting Time (s)", y="Frequência") +
  theme_minimal() +
  theme(legend.position = "top")

# 2. Distribuição do tempo de cada métrica e política

# Turnaround Time por política - boxplot com cores
ggplot(process_data, aes(x=Scheduling_Policy, y=Turnaround_Time, fill=Scheduling_Policy)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Set3") +
  labs(title=paste0("Distribuição de Turnaround Time por Política (", unique(process_data$Process_Count), " processos)"),
       x="Política", y="Turnaround Time (s)") +
  theme_minimal()

# Response Time por política - boxplot com cores
ggplot(process_data, aes(x=Scheduling_Policy, y=Response_Time, fill=Scheduling_Policy)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Set2") +
  labs(title=paste0("Distribuição de Response Time por Política (", unique(process_data$Process_Count), " processos)"),
       x="Política", y="Response Time (s)") +
  theme_minimal()

# Waiting Time por política - boxplot com cores
ggplot(process_data, aes(x=Scheduling_Policy, y=Waiting_Time, fill=Scheduling_Policy)) +
  geom_boxplot() +
  scale_fill_brewer(palette="Set1") +
  labs(title=paste0("Distribuição de Waiting Time por Política (", unique(process_data$Process_Count), " processos)"),
       x="Política", y="Waiting Time (s)") +
  theme_minimal()

# 3. Distribuição temporal dos eventos de execução

# Criação da coluna de eventos (Start, First Activation, End)
events_data <- process_data %>%
  gather(key = "Event", value = "Timestamp", Start_Time, First_Activation, End_Time)

# Distribuição temporal dos eventos para cada política com cores
ggplot(events_data, aes(x=Timestamp, fill=Event)) +
  geom_histogram(binwidth=60, position="dodge", color="black") +
  scale_fill_brewer(palette="Paired") +
  facet_wrap(~ Scheduling_Policy) +
  labs(title="Distribuição Temporal dos Eventos por Política",
       x="Tempo", y="Frequência") +
  theme_minimal() +
  theme(legend.position = "top")

