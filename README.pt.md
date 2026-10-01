# Aplicativo de Tradução e Quiz com IA 🌍📱

[English](https://www.google.com/search?q=./README.md) | [Português](https://www.google.com/search?q=./README.pt.md)

Um aplicativo full-stack de aprendizado de idiomas e tradução que fornece traduções em tempo real, alinhamento granular de palavras, áudio de conversão de texto em fala natural e quizzes de compreensão gerados por IA.

## 👨‍💻 Stack de Desenvolvimento

### 📱 Frontend

* **Framework:** Flutter (Aplicativo móvel multiplataforma)
* **Gerenciamento de Estado:** Flutter Riverpod (Notifiers)
* **Rede:** Dio (Cliente HTTP)
* **Armazenamento:** Flutter Secure Storage (Persistência local criptografada)

### ☁️ Backend & IA

* **Servidor:** Node.js, Express.js (TypeScript)
* **Banco de Dados:** MongoDB (ORM Mongoose)
* **Autenticação:** Tokens de autenticação baseados em JWT
* **Serviços em Nuvem:** Microsoft Azure AI Speech (TTS) & Translation Services; APIs do Google AI

## 💬 Funcionalidades

* **Tradução Neural:** Traduz textos entre vários idiomas com mapeamento de alinhamento de palavras.
* **Consulta de Palavras Interativa:** Toque em qualquer palavra no texto traduzido para ver sua definição no dicionário, classe gramatical e exemplos contextuais.
* **Pronúncia Text-to-Speech:** Reprodução de áudio com som natural impulsionada por vozes neurais da Azure.
* **Quizzes de Compreensão por IA:** Gera automaticamente quizzes interativos de múltipla escolha baseados na sessão traduzida para testar a retenção.
* **Histórico de Traduções:** Salve, gerencie e navegue perfeitamente por sessões de tradução anteriores através de um menu lateral deslizante.

## 🛠️ Instalação e Primeiros Passos

Para executar este projeto localmente, consulte os guias de configuração específicos em cada diretório:

* 🖥️ **Configuração do Backend:** Verifique [`server/README.md`](https://www.google.com/search?q=./backend/README.md)
* 📱 **Configuração do Frontend:** Verifique [`client/README.md`](https://www.google.com/search?q=./frontend/README.md)