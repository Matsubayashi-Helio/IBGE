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

Após iniciar a aplicação, digite o comando para visualizar todas as opções oferecidas:
```bash
$ app --help
```

O seguinte guia será exibido:
```bash
Usage: app [options]

Utilização da aplicação:
    -u, --uf [UF]                    Nomes mais comuns de UF em três tabelas.
                                     (Tabela de ranking geral e um de cada gênero)
    -c, --cidade=CIDADE              Nomes mais comuns de CIDADE em três tabelas.
                                     (Tabela de ranking geral e um de cada gênero)
    -f, --frequencia=NOMES           Frequência de NOMES ao longo das decadas

Opções extras:
    -h, --help                       Exibe todos os comandos
    -d, --dicas                      Dicas e informações extras
    -x, --sair                       Sair da aplicação
```


### Manipulando Banco de Dados

Para a criação e manipulação do banco de dados, foi utilizada a gem [Sinatra-activerecord](https://github.com/sinatra-activerecord/sinatra-activerecord), que permite utilizar as propriedades e metodos do ActiveRecord sem o Rails.

Com a gem [Activerecord-import](https://github.com/zdennis/activerecord-import) que permite popular bancos de dados por 'bulk insertion', as tabelas de estados e cidades foi populada com as consultas da API de localidades.


### Executando Testes

Os testes da aplicação foram realizados utilizando a gem [RSpec](https://rspec.info/).

Todos os testes se encontram na pasta **spec**, onde cada model possui o seu próprio arquivo de teste na pasta **/model**.

Para executar os testes digite o comando abaixo no terminal:

```bash
# Todos os testes são executados
$ rspec

# Executa apenas um arquivo de teste
$ rspec ./spec/model/parser_spec.rb

# O número ao final indica a linha em que o teste se encontra
$ rspec ./spec/model/parser_spec.rb:14
```


### APIs de consulta


##### APIs públicas IBGE e CSV população
- API de Localidades: https://servicodados.ibge.gov.br/api/docs/localidades?versao=1
- API de Nomes: https://servicodados.ibge.gov.br/api/docs/nomes?versao=2
- CSV com dados da população: https://campus-code.s3-sa-east-1.amazonaws.com/treinadev/populacao_2019.csv