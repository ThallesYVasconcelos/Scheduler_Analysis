#!/bin/bash

# Executa o script de monitoramento
echo "Iniciando o monitoramento..."
bash processMonitor.sh

# Verifica se o monitoramento foi concluído com sucesso
if [ $? -eq 0 ]; then
    echo "Monitoramento concluído. Iniciando o script R..."
    Rscript metricsScheduler.R
else
    echo "Ocorreu um erro durante o monitoramento."
fi

