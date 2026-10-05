[English](./README.md) | [Português](./README.pt.md)

### Pré-requisitos

* Node.js & npm instalados localmente
* Uma instância do MongoDB em execução (Local ou URI do MongoDB Atlas)
* Chaves de assinatura e regiões dos serviços Microsoft Azure Speech e Translator
* Chave de API do Google AI Studio

### 1. Instalar as Dependências
Navegue até o diretório do servidor e instale os pacotes necessários:

```bash
npm install
```

### 2. Configurar as Variáveis de Ambiente
Crie um arquivo `.env` (utilize o `.env.example` como modelo).

### 3. Iniciar o Servidor

Execute o seguinte comando no diretório do servidor:

```bash
npm run dev
```