# Sobre

Uma aplicação CLI desenvolvida em Ruby que consulta APIs públicas do IBGE e exibe dados estatísticos sobre os nomes da população brasileira.

#### Status: Em desenvolvimento

 Acesse o [Trello](https://trello.com/b/EhVqO3St/ibge) desta aplicação para obter mais detalhes sobre o andamento do projeto.

### Requisitos

Algumas tecnologias foram utilizadas no desenvolvimento da aplicacação. Sendo elas:

- [Ruby](https://www.ruby-lang.org/pt/documentation/installation/) versão: 2.7.0
- [Git](https://git-scm.com) 
- [SQLite](https://www.sqlite.org/index.html)

### Começando

Após clonar o repositório, execute dentro do diretório criado o comando abaixo para instalar todas as dependencias e criar o banco de dados:
```bash
$ bin/setup
```

Inicie a aplicação executando o comando abaixo:
```bash
$ ruby app.rb
```

### Manipulando Banco de Dados

Para a criação e manipulação do banco de dados, foi utilizada a gem [Sinatra-activerecord](https://github.com/sinatra-activerecord/sinatra-activerecord), que permite utilizar as propriedades e metodos do ActiveRecord sem o Rails.

Com a gem [Activerecord-import](https://github.com/zdennis/activerecord-import) que permite popular bancos de dados por 'bulk insertion', as tabelas de estados e cidades foi populada com as consultas da API de localidades.


### APIs de consulta


##### APIs públicas IBGE e CSV população
- API de Localidades: https://servicodados.ibge.gov.br/api/docs/localidades?versao=1
- API de Nomes: https://servicodados.ibge.gov.br/api/docs/nomes?versao=2
- CSV com dados da população: https://campus-code.s3-sa-east-1.amazonaws.com/treinadev/populacao_2019.csv