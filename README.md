# 🧠 MentorAI: Recomendação de Cursos & Reskilling API

Uma API RESTful desenvolvida em .NET 8, conteinerizada e estruturada para implantação automatizada na nuvem via Azure DevOps.

## 📘 Contexto do Negócio
Projeto desenvolvido para a Global Solution (FIAP 2025) sob o tema "O Futuro do Trabalho". O MentorAI atua como um motor de recomendação inteligente, mapeando o perfil e as habilidades do usuário para sugerir trilhas de capacitação (upskilling e reskilling), conectando profissionais às demandas reais do mercado.

## ⚙️ Arquitetura e Fluxo de CI/CD
Este projeto vai além do código, englobando a esteira completa de entrega contínua (DevOps Culture):
1. **Push & Build:** O código gerado é versionado e testado.
2. **Containerization:** A aplicação .NET é empacotada em uma imagem Docker.
3. **Registry:** A imagem é enviada para o Azure Container Registry (ACR).
4. **Deploy Automático:** O Web App for Containers (Azure) consome a imagem mais recente e expõe os endpoints atualizados.

## 🚀 Tecnologias e Ecossistema

| Camada | Tecnologia |
| :--- | :--- |
| **Backend / API** | C# (.NET 8), ASP.NET Core Web API |
| **Banco de Dados** | Oracle DB |
| **ORM** | Entity Framework Core |
| **Infra & Containers** | Docker |
| **Cloud Computing** | Azure (Container Registry + Web App for Containers) |
| **Automação / Esteira** | Azure DevOps Pipelines |
| **IaC (Provisionamento)** | Azure CLI |

## 👥 Equipe de Engenharia
* **Victor Egídio Lira** (RM 556653) - *Desenvolvimento Cloud Infra*
* **Caetano Matos Penafiel** (RM 557984)
* **Kauã Fermino Zipf** (RM 558957)
