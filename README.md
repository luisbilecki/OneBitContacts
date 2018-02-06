# Criando uma API Completa com Rails

Esse repositório apresenta o código fonte do minicurso do Onebitcode.

[Criando uma API completa com Rails](https://onebitcode.com/api-completa-rails/)

Ao final do minicurso foram propostos alguns desafios:

* Paginar os retornos do endpoint /contacts
* Criar a estrutura para permitir a inclusão de multiplos endereços nos Contatos

O projeto disponível neste repositório inclui o código destes desafios e também acrescenta
os testes automatizados, feitos usando RSpec e FactoryBot.

--------------

## Dependências do projeto

* Ruby 2.3
* Rails 5.1.4
* SQLite

--------------
## Como rodar?

1.Faça o clone desse projeto para sua máquina
```bash
git clone https://github.com/luisbilecki/OneBitContacts.git
```
2.Vá até o diretório do projeto
```bash
cd OneBitContacts
```
3.Utilizando o bundle instale as *gems* necessárias
```
bundle
```
ou
```
bundle install
```
4.Crie o banco de dados
```bash
rails db:drop db:create
```
5.Faça as migrações no banco de dados
```
rails db:migrate
```
6.Acesse o rails console
```bash
rails c
```
7.Crie um usuário para acessar a API
```ruby
User.create(email:'bob@bob.com',password:'foofoo')
```
8.Armazene o token de autenticação. Esse token será usado para consumir os serviços da API
```ruby
[...]
 => #<User id: 1, email: "bob@bob.com", created_at: "2018-02-06 19:24:35", updated_at: "2018-02-06 19:24:35", name: nil, authentication_token: "dmrxxyxNsh2NSuqyQ_hR">
```
Token:
**dmrxxyxNsh2NSuqyQ_hR**

9.Suba o servidor
```bash
rails s -b 0.0.0.0 -p 3000
```
10.Pronto! Agora você já pode utilizar a API.
```bash
curl -i -H "Accept: application/json" -H "x-user-email: bob@bob.com" -H "x-user-token: dmrxxyxNsh2NSuqyQ_hR" "http://localhost:3000/api/v1/contacts"
```
11.Os testes podem ser rodados usando os comandos:
```bash
bin/rspec spec/
```
ou
```bash
rspec spec/
```
--------------

## *Endpoints* da API

 Os *endpoints* desta API estão documentados abaixo.

---------------
#### Listar todos os contatos

**URL**

* /contacts

**Método HTTP:**

* GET

**Parâmetros de URL:**

* Nenhum

**Parâmetros no cabeçalho**

* **x-user-email** = e-mail do usuário cadastrado via *devise*;
* **x-user-token** = *token* (chave) de autenticação.

**Respostas**

Código: 200
Conteúdo de retorno: JSON com elementos de contato.

Código: 401 Não autorizado
Motivo: Usuário não está logado.

---------------
#### Listar um contato específico

**URL**

* /contacts/:id

**Método HTTP:**

* GET

**Parâmetros de URL:**

* **id(inteiro)**: código do contato a ser exibido.

**Parâmetros no cabeçalho**

* **x-user-email** = e-mail do usuário cadastrado via *devise*;
* **x-user-token** = *token* (chave) de autenticação.

**Respostas**

Código: 200
Conteúdo de retorno: JSON com os dados do contato.

Código: 401 Não autorizado
Motivo: Usuário não está logado.

Código: 404 Não encontrado
Motivo: Não existe tal código.
---------------
#### Armazenar um contato
**URL**

* /contacts

**Método HTTP:**

* POST

**Parâmetros**

* Dados do **Contato**:
```json
  {
    "name": "Luís",
    "email": "luis@luis.com",
    "phone": "+55 47 99999-1234",
    "description": "Um cara legal!",
    "addresses_attributes": [
        {"name" : "Rua da Independência"},
        {"name" : "Rua do Modelo Relacional"}
    ]
  }
```

**Parâmetros no cabeçalho**

* **x-user-email** = e-mail do usuário cadastrado via *devise*;
* **x-user-token** = *token* (chave) de autenticação.

**Respostas**

Código: 200
Conteúdo de retorno: JSON com o contato salvo.

Código: 401 Não autorizado
Motivo: Usuário não está logado.

Código: 403 Não permitido
Motivo: A operação não é permitida, ou seja, somente o próprio usuário pode excluir os seus contatos.
---------------
#### Atualizar um contato

**URL**

* /contacts/:id

**Método HTTP:**

* PUT

**Parâmetros da URL**

* **id(inteiro)**: código do contato a ser alterado/atualizado.
*
**Parâmetros no *body* da requisição**

* Dados alterados/atualizados do  **Contato**:
```json
  {
    "name": "Luís Felipe",
    "email": "novoemaildoluis@luis.com",
  }
```

**Parâmetros no cabeçalho**

* **x-user-email** = e-mail do usuário cadastrado via *devise*;
* **x-user-token** = *token* (chave) de autenticação.

**Respostas**

Código: 200
Conteúdo de retorno: JSON com o contato salvo.

Código: 401 Não autorizado
Motivo: Usuário não está logado.

Código: 403 Não permitido
Motivo: A operação não é permitida, ou seja, somente o próprio usuário pode excluir os seus contatos.

---------------
#### Remover um contato

**URL**

* /contacts/:id

**Método HTTP:**

* DELETE

**Parâmetros de URL:**

* **id(inteiro)**: código do contato a ser excluído.

**Parâmetros no cabeçalho**

* **x-user-email** = e-mail do usuário cadastrado via *devise*;
* **x-user-token** = *token* (chave) de autenticação.

**Respostas**

Código: 204
Conteúdo de retorno: Nenhum. A operação ocorreu com sucesso.

Código: 401 Não autorizado
Motivo: Usuário não está logado.

Código: 403 Não permitido
Motivo: O usuário não atual não pode excluir o contato de outro usuário.

Código: 404 Não encontrado
Motivo: Não existe tal código.
---------------
## Detalhamento dos *models*

```ruby
Contact{
    id  string
        example: 1
        readOnly: true
    name* string
            example: 'Alice'
    email string
            example: 'alice@alice.com'
    phone string
            example: '+55 11 87578-3421'
    description string
        example: 'This contact is awesome'
    address Address[]
}
```

```ruby
User{
    id* string
            example: 1
            readOnly: true
    email*  string
            example: 'example@example.com'
    name* string
            example: 'Josep Maia'
    password string
            example: '123456'
    password_confirmation string
            example: '123456'
}
```
