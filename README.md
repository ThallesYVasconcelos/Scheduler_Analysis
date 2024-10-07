
# Scheduler_Analysis

Este projeto consiste em três scripts, o script process_monitor   monitora os processos em execução no Linux e o script metricsScheduler calcula métricas de escalonamento, como **Turnaround Time**, **Waiting Time** e **Response Time** e gera gráficos que demonstram análise sobre as métricas calculadas. Ademais, existe o script executeproject para executar os dois anteriores juntos, automatizando tudo. O monitoramento é feito por um script Bash que registra os processos em um arquivo CSV, e as métricas são calculadas posteriormente por um script R e o de execução do projeto é feito em bash.
# RELATÓRIO DO PROJETO
O link abaixo é referente ao relatório do projeto.Nele, está presente todas as informações necessárias para o entendimento dos scripts e informações necessárias sobre o escalonamento no linux e suas políticas.
https://docs.google.com/document/d/1VUU0rsRlCObf_49-SWYiwqg2_8n2_8AZDJz1eE7IY_U/edit#heading=h.v2grw6o9c2zp
## Requisitos

### Para rodar o script Bash:

- **Linux/Unix**: O script foi projetado para ser executado em sistemas operacionais baseados em Linux.
- **Ferramentas padrão do sistema**: O script utiliza comandos padrão como `ps`, `awk`, `sed`, `grep`, `sleep`, entre outros.
- **Permissão de execução**: Verifique se o script tem permissão de execução. Caso não tenha, execute o comando:
  ```bash
  chmod +x process_monitor.sh
  chmod +x executeProject.sh
  ```

### Para rodar o script R:

- **R**: Instale o R no seu sistema.
- **Pacotes R necessários**:
  - `dplyr`: Para manipulação de dados.
  - `lubridate`: Para manipulação de datas e horas.
  - `ggplot2`: Para criação de gráficos.
  - `tidyr`: Para a organização e limpeza dos dados, permitindo transformar dados em formatos mais adequados para análise.

Para instalar esses pacotes, execute o seguinte código no R:

```R
install.packages(c("ggplot2", "dplyr", "lubridate", "tidyr"))
```
## Como usar

### 1. Executar o script Bash `executeProject` para executar os arquivos de monitoramento e de cálculo das métricas após o monitoramento.

```bash
bash executeProject.sh
```

O script Bash (`process_monitor.sh`) monitorará os processos em execução no sistema, capturando dados sobre:
- ID do processo
- Nome do processo
- Hora de início do processo
- Hora da primeira ativação do processo
- Hora de término do processo
- Prioridade (`nice value`)
- Política de escalonamento

Os dados são salvos em um arquivo CSV chamado `process_log.csv`.

A execução irá monitorar os processos em execução por 600 segundos (10 min), com uma pausa de 2 segundos entre cada verificação. O script verifica se novos processos começaram ou se processos existentes foram finalizados e atualiza as informações no arquivo `process_log.csv`.

Uma vez que você tenha o arquivo `process_log.csv` gerado pelo script Bash, o script executará o script R (`metricsScheduler.R`) para calcular as métricas de **Turnaround Time**, **Waiting Time** e **Response Time**, além de gerar gráficos de cada métrica e política de escalonamento.

O script irá:

- Ler o arquivo `process_log.csv`.
- Converter os tempos para o formato adequado.
- Calcular as métricas para cada processo.
- Gerar gráficos para métricas e políticas de escalonamento.
- Gerar um PDF com os gráficos mencionados.

### 2. Visualizar o PDF com os gráficos e métricas geradas pelo R

- **Turnaround Time**: Diferença entre o horário de término do processo e o horário de início.
- **Waiting Time**: O tempo total que o processo passou esperando para ser executado (tempo em que esteve na fila).
- **Response Time**: Diferença entre o horário de primeira ativação do processo e o horário de início.
