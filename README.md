# ResumeAnalyzer

O **ResumeAnalyzer** é um aplicativo iOS inteligente construído com SwiftUI que utiliza o poder da Inteligência Artificial para ajudar os usuários a otimizar seus currículos e se preparar para entrevistas de emprego. O aplicativo oferece uma experiência fluida para avaliar um currículo de acordo com uma descrição de vaga específica e realizar simulações de entrevistas guiadas por IA.

## 🚀 Funcionalidades

- **Análise de Currículo com IA**: Compare o seu currículo com qualquer descrição de vaga. O aplicativo avalia a compatibilidade e retorna uma nota geral, pontos fortes e sugestões de melhoria acionáveis adaptadas ao seu nível de senioridade.
- **Simulação de Entrevistas**: Prepare-se para sua próxima grande oportunidade com entrevistas simuladas, utilizando os recursos nativos de Reconhecimento de Fala (Speech Recognition) do iOS.
- **Geração e Leitura de PDF**: Importe seus currículos em PDF existentes para extrair o texto (usando o Vision) e gere novos currículos em PDF formatados de forma elegante diretamente do aplicativo.
- **Onboarding & Gerenciamento de Perfil**: Configure seu perfil profissional (cargo atual, senioridade e objetivos principais) para que a IA possa fornecer um feedback mais personalizado.
- **Persistência de Dados**: Utiliza o moderno framework **SwiftData** da Apple para armazenar seu perfil, análises de currículos salvas e o histórico de entrevistas localmente e de forma segura no seu dispositivo.

## 🛠 Tech Stack & Arquitetura

- **Linguagem**: Swift
- **Framework de UI**: SwiftUI
- **Banco de Dados Local**: SwiftData (ModelContainer & @Query)
- **Integração de IA**: API da OpenAI (utilizando o modelo `gpt-4o-mini` com suporte ao Strict Structured Outputs)
- **Frameworks Nativos**: 
  - `Vision` & `PDFKit` para leitura e geração de PDFs
  - `Speech` & `AVFoundation` para reconhecimento de fala durante as entrevistas simuladas

## 📂 Estrutura do Projeto

- **Model**: Contém todas as definições de dados, incluindo os modelos de esquema do SwiftData (`UserProfile`, `SavedAnalysis`, `SavedInterview`, `Curriculum`, etc.).
- **View**: Telas em SwiftUI organizadas por funcionalidade (`Home`, `Resume`, `Interview`, `OnBoarding`, `Job`, etc.).
- **Services**: Lógica de negócios e gerenciadores (`AiManager`, `InterviewManager`, `PDFGeneratorService`, `SpeechRecognizerManager`, `VisionService`, etc.).
- **Extensions**: Extensões úteis para Swift e SwiftUI (ex: extensões de manipulação de strings em `CleanForAi`).
- **Templates**: Contém modelos (templates) utilizados na geração de PDFs e análise de dados.

## ⚙️ Como Começar

### Pré-requisitos

- **Xcode**: Versão 15.0 ou superior (necessário para suportar o SwiftData).
- **iOS**: iOS 17.0 ou superior.
- **Chave de API da OpenAI**: Necessária para que os recursos de inteligência artificial funcionem.

### Instalação

1. **Clone o repositório** (ou baixe os arquivos do projeto):
   ```bash
   git clone https://github.com/seu-usuario/ResumeAnalyzer.git
   ```
2. **Abra o projeto** no Xcode:
   ```bash
   cd ResumeAnalyzer
   open ResumeAnalyzer.xcodeproj
   ```
3. **Configure as Chaves de API**:
   - Localize o arquivo `Secrets.swift` no projeto.
   - Insira sua chave da API da OpenAI na variável `apiKey`.
   *(Atenção: Certifique-se de nunca commitar suas chaves de API em um controle de versão público!)*

4. **Compile e Execute**:
   - Selecione seu dispositivo de destino (ou simulador) no Xcode.
   - Pressione `Cmd + R` para compilar e executar o aplicativo.

## 🔒 Privacidade & Permissões

O ResumeAnalyzer requer acesso a alguns recursos do dispositivo para fornecer todas as suas funcionalidades. O aplicativo solicita as seguintes permissões (já configuradas no `Info.plist`):
- **Microfone & Reconhecimento de Fala**: Necessários para a funcionalidade interativa de simulação de entrevista.
- **Arquivos/Fotos**: Necessários para a importação de currículos em formato PDF.
