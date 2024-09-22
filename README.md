# Scheduler_Analysis

Este projeto consiste em dois scripts que monitoram os processos em execução no Linux e calculam métricas de escalonamento, como **Turnaround Time**, **Waiting Time** e **Response Time**. O monitoramento é feito por um script Bash que registra os processos em um arquivo CSV, e as métricas são calculadas posteriormente por um script R.

## Requisitos

### Para rodar o script Bash:

- **Linux/Unix**: O script foi projetado para ser executado em sistemas operacionais baseados em Linux.
- **Ferramentas padrão do sistema**: O script utiliza comandos padrão como `ps`, `awk`, `sed`, `grep`, `sleep`, entre outros.
- **Permissão de execução**: Verifique se o script tem permissão de execução. Caso não tenha, execute o comando:
  ```bash
  chmod +x process_monitor.sh

### Para rodar o script R:

- **R**: Instale o R no seu sistema.
- **Pacotes R necessários**:
  - `dplyr`: Para manipulação de dados.
  - `lubridate`: Para manipulação de datas e horas.

  Para instalar esses pacotes, execute o seguinte código no R:

  ```R
  install.packages("dplyr")
  install.packages("lubridate")
  ```

## Como usar

### 1. Executar o script Bash para monitorar processos

O script Bash (`process_monitor.sh`) monitorará os processos em execução no sistema, capturando dados sobre:

- ID do processo
- Nome do processo
- Hora de início do processo
- Hora da primeira ativação do processo
- Hora de término do processo
- Prioridade (`nice value`)
- Política de escalonamento

Os dados são salvos em um arquivo CSV chamado `process_log.csv`.

#### Para iniciar o monitoramento:

```bash
./process_monitor.sh
```

O monitoramento continuará em execução indefinidamente, com uma pausa de 5 segundos entre cada verificação. O script verifica se novos processos começaram ou se processos existentes foram finalizados.

### 2. Executar o script R para calcular métricas

Uma vez que você tenha o arquivo `process_log.csv` gerado pelo script Bash, use o script R (`process_metrics.R`) para calcular as métricas de **Turnaround Time**, **Waiting Time** e **Response Time**.

#### Para rodar o script R:

1. Abra o R ou RStudio.
2. Execute o script `process_metrics.R`:

```R
source("process_metrics.R")
```

O script irá:

- Ler o arquivo `process_log.csv`.
- Converter os tempos para o formato adequado.
- Calcular as métricas para cada processo.
- Salvar os resultados em um novo arquivo CSV chamado `process_metrics.csv`.

### 3. Métricas Calculadas

- **Turnaround Time**: Diferença entre o horário de término do processo e o horário de início.
- **Waiting Time**: O tempo total que o processo passou esperando para ser executado (tempo em que esteve na fila).
- **Response Time**: Diferença entre o horário de primeira ativação do processo e o horário de início.

## Exemplo de uso

Para execuções que exijam monitorar processos por um período de tempo. Execute o script Bash para iniciar o monitoramento:

```bash
./process_monitor.sh
```

Após algum tempo, pare o script (Ctrl+C) e execute o script R para calcular as métricas dos processos registrados:

```R
source("process_metrics.R")
```

Você encontrará um novo arquivo `process_metrics.csv` contendo as métricas calculadas para cada processo monitorado.

## Observações

- O script Bash verifica os processos a cada 5 segundos. Se você quiser mudar esse intervalo, ajuste a linha `sleep 5` para o intervalo desejado.
- O script Bash foi projetado para rodar em um sistema Linux com a ferramenta `ps`. Ele pode não funcionar em outros sistemas operacionais ou distribuições sem modificações.
- O cálculo de `Waiting Time` assume que não há preempção (sistemas sem preempção). Ajuste esse cálculo conforme as particularidades do seu sistema.
