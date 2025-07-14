# Infraestrutura "Always Free" na OCI com Terraform

Este repositório contém o código Terraform para provisionar uma infraestrutura de servidor completa na Oracle Cloud Infrastructure (OCI), utilizando exclusivamente os recursos do **Nível Gratuito (Always Free)**.

A solução é ideal para desenvolvedores, startups e para qualquer pessoa que queira hospedar aplicações web de forma robusta e sem incorrer em custos de infraestrutura.

## Visão Geral da Arquitetura

A infraestrutura provisionada por este projeto consiste em:

-   **Busca Automática de Imagem:** O script **encontra automaticamente a imagem mais recente do Ubuntu** compatível, eliminando a necessidade de procurar e atualizar o OCID da imagem manualmente.
-   **Rede Segura:** Uma Virtual Cloud Network (VCN) com sub-redes públicas, gateways e regras de segurança para garantir um ambiente de rede isolado e seguro.
-   **Computação Poderosa e Gratuita:** Uma instância de VM **VM.Standard.A1.Flex** (arquitetura Arm) configurada com **4 OCPUs e 24 GB de RAM**, oferecendo um desempenho excelente para uma variedade de cargas de trabalho, tudo dentro do nível gratuito.
-   **Provisionamento Automatizado:** Um script de inicialização (`cloud-init.sh`) é executado automaticamente na VM para configurar um ambiente de servidor completo com:
    -   **Node.js e Yarn:** Para executar suas aplicações backend.
    -   **PM2:** Um gerenciador de processos para manter suas aplicações Node.js em execução contínua.
    -   **Nginx:** Atuando como um proxy reverso para as aplicações Node.js.
    -   **Certbot:** Para a geração e renovação automática de certificados SSL/TLS da Let's Encrypt.

## Pré-requisitos

Antes de iniciar, garanta que você possui:

1.  **Uma Conta na OCI:** Se ainda não tiver uma, pode criar uma conta gratuita [aqui](https://www.oracle.com/br/cloud/free/).
2.  **Terraform:** Instalado na sua máquina local. Instruções de instalação podem ser encontradas [aqui](https://learn.hashicorp.com/tutorials/terraform/install-cli).
3.  **Credenciais da API da OCI:** Configure as suas credenciais de API. Siga o guia oficial da OCI para [gerar suas chaves de API](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm) e anote os OCIDs da sua tenancy e usuário, e o fingerprint da chave.
4.  **Um Par de Chaves SSH:** Necessário para o acesso seguro às instâncias de VM.

## Como Utilizar

1.  **Clone este repositório:**
    ```bash
    git clone https://github.com/nettaskjr/oci-ubuntu-single-instance.git
    cd oci-ubuntu-single-instance
    ```

2.  **Configure suas variáveis:**
    Crie um arquivo chamado `terraform.tfvars` e preencha-o com as suas informações da OCI e caminhos para as suas chaves. Utilize o arquivo `variables.tf` como referência.

    **Exemplo de `terraform.tfvars`:**
    ```hcl
    tenancy_ocid     = "ocid1.tenancy.oc1..xxxxxxxxxxxx"
    user_ocid        = "ocid1.user.oc1..xxxxxxxxxxxx"
    fingerprint      = "ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff"
    api_private_key_path = "/caminho/para/sua/chave_api.pem"
    region           = "us-ashburn-1"
    compartment_id   = "ocid1.compartment.oc1..xxxxxxxxxxxx"
    ssh_public_key_path = "/caminho/para/sua/chave_publica.pub"
    ```
    *Nota: Não é mais necessário especificar o `instance_image_ocid`!*

3.  **Inicialize o Terraform:**
    Este comando irá baixar os plugins necessários para o provedor OCI.
    ```bash
    terraform init
    ```

4.  **Planeje a Implantação:**
    Revise os recursos que o Terraform irá criar.
    ```bash
    terraform plan
    ```

5.  **Aplique a Configuração:**
    Este comando irá provisionar toda a infraestrutura na sua conta OCI.
    ```bash
    terraform apply
    ```
    Confirme a ação digitando `yes` quando solicitado.

Ao final do processo, o Terraform exibirá o endereço IP público da sua instância e os detalhes da imagem do Ubuntu que foi utilizada.

## Acesso às Instâncias

Para acessar suas instâncias via SSH, utilize a sua chave privada:

```bash
ssh -i /caminho/para/sua/chave_privada ubuntu@<IP_PUBLICO_DA_INSTANCIA>