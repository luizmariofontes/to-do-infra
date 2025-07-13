# Infraestrutura de provisionamento - To-do List

Este repositório contém a infraestrutura e configuração para implantar uma aplicação de lista de tarefas (to-do) completa, utilizando Terraform na AWS e Docker Compose para orquestração dos serviços.


## Repositórios da Aplicação

•
Backend: https://github.com/luizmariofontes/to-do-backend

•
Frontend: https://github.com/luizmariofontes/to-do-frontend

## Como Rodar o Projeto

Siga os passos abaixo para implantar e executar a aplicação:

### 1. Pré-requisitos

Certifique-se de ter instalado:

- **Terraform**: [Instalação do Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- **AWS CLI**: E suas credenciais AWS configuradas (`aws configure`).
- **Chave SSH**: Um par de chaves SSH configurado em `~/.ssh/`.

### Geração e Configuração da Chave SSH

O Terraform utiliza uma chave SSH para acessar a instância EC2. Se você não possui um par de chaves SSH, siga os passos abaixo para gerar um:

1. Abra seu terminal.
2. Execute o comando:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "seu-email@exemplo.com"
   ```
   Pressione Enter para aceitar o local padrão.
3. Certifique-se de que os arquivos `id_<id-da-chave>.pub` (chave pública) e `id_<id-da-chave>` (chave privada) estejam no diretório `~/.ssh/`.

O arquivo `main.tf` já está configurado para usar a chave pública `~/.ssh/id_<id-da-chave>.pub` para provisionar a chave na AWS e a chave privada `~/.ssh/id_<id-da-chave>` para a conexão SSH via provisioner. Não é necessário anexar a chave em nenhum outro lugar dentro do repositório, apenas garantir que ela esteja no local correto em sua máquina local.

### 2. Configuração das Variáveis de Ambiente

Preencha os arquivos `.env` com as informações necessárias:

- `backend.env`:
  ```
  DATABASE_URL=postgres://<usuario-do-banco>:<senha>@<nome-do-servico-do-banco-no-compose>:<porta>/<nome-do-banco>
  ALLOWED_HOSTS=localhost,127.0.0.1,<IP-da-instância-EC2>
  ```
- `db.env`:
  ```
  POSTGRES_DB=
  POSTGRES_USER=
  POSTGRES_PASSWORD=
  ```
- `frontend.env`:
  ```
  VUE_APP_API_URL=http://<IP_DA_INSTANCIA>:8000
  ```
- `pgadmin.env`:
  ```
  PGADMIN_DEFAULT_EMAIL=admin@example.com (padrão)
  PGADMIN_DEFAULT_PASSWORD=admin (padrão)
### 3. Implantação com Terraform

Navegue até o diretório `to-do-infra` e execute os comandos:

```bash
terraform init
terraform plan
terraform apply
```

Confirme a aplicação digitando `yes` quando solicitado.

### 4. Acesso à Aplicação

Após a conclusão do `terraform apply` (pode levar alguns minutos para os serviços Docker iniciarem na instância EC2), você poderá acessar:

- **Aplicação Frontend**: `http://<IP_PÚBLICO_DA_INSTANCIA>:8083`
- **pgAdmin**: `http://<IP_PÚBLICO_DA_INSTANCIA>:8085`

Substitua `<IP_PÚBLICO_DA_INSTANCIA>` pelo IP público da sua instância EC2.

### 5. Limpeza

Para remover todos os recursos provisionados na AWS:

```bash
terraform destroy
```

Confirme a destruição digitando `yes`.