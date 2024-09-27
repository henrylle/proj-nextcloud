## Desafio de Projetos: Formação AWS com Henrylle Maia

- Lance a máquina de trabalho (bia-dev)
- Baixe o projeto na máquina de trabalho
- Entre na pasta do projeto
- Rode ele:

```
docker compose up -d
```

Obs: O projeto está configurado por padrão para rodar na porta 80.


### Obs para o processo de backup restore do banco.

- Você pode usar a rotina `backup_restore_exemplo.sh` como apoio.
    - Na fase de restore tem uma etapa importante para ignorar a role e usar o próprio usuário passado na connection string. Se não fizer isso, o restore vai quebrar.
- Para mudar o endereço do banco, você precisa alterar diretamente no config.php após o projeto já estar rodando.
    - Entre no container nextcloud e edite o arquivo abaixo, que fica na pasta /var/www/html:
        `config/config.php`

    - Altere todos os dados referentes à connection string.
    - Após isso, pare o postgres no docker e confirme que o apontamento já está para o seu banco no RDS.