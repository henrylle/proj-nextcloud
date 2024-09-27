#!/bin/bash

# Configurações do PostgreSQL local
PGHOST_LOCAL="IP_LOCAL"
PGPORT_LOCAL="5432"
PGUSER_LOCAL="nextcloud"
PGDATABASE_LOCAL="nextcloud"

# Configurações do PostgreSQL no RDS da AWS
PGHOST_RDS="RDS_REMOTO"
PGPORT_RDS="5432"
PGUSER_RDS="postgres"
PGDATABASE_RDS="nextcloud"

# Caminho para o arquivo de dump
DUMP_FILE="nextcloud_dump.sql"

#rm $DUMP_FILE

# Fazendo o dump do banco de dados local
echo "Fazendo dump do banco de dados local..."
pg_dump -h $PGHOST_LOCAL -p $PGPORT_LOCAL -U $PGUSER_LOCAL -d $PGDATABASE_LOCAL -F c -b -v -f $DUMP_FILE

# Verificando se o dump foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "Dump do banco de dados local concluído com sucesso!"
else
    echo "Erro ao fazer o dump do banco de dados local."
    exit 1
fi

#dropando banco antes do restore
psql -h $PGHOST_RDS -U $PGUSER_RDS <<EOF
DROP DATABASE IF EXISTS $PGDATABASE_RDS;
CREATE DATABASE $PGDATABASE_RDS;
EOF

# Restaurando o dump no RDS
echo "Restaurando dump no RDS..."
pg_restore --no-owner --no-acl  -h $PGHOST_RDS -p $PGPORT_RDS -U $PGUSER_RDS -d $PGDATABASE_RDS -v $DUMP_FILE

# Verificando se a restauração foi bem-sucedida
if [ $? -eq 0 ]; then
    echo "Restauração no RDS concluída com sucesso!"
else
    echo "Erro ao restaurar o dump no RDS."
    exit 1
fi
