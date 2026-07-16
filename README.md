# MusicJourney 🎵

O **MusicJourney** é um aplicativo iOS inovador desenvolvido em SwiftUI, criado para auxiliar músicos de todos os níveis a organizar, acompanhar e aprimorar sua rotina de estudos. Com recursos avançados que vão desde a inteligência artificial para criação de metas até ferramentas práticas para o dia a dia, o app é o companheiro ideal para a sua jornada musical.

## 🚀 Funcionalidades Principais

- **Metas Inteligentes com IA (Gemini)**: Crie objetivos de prática personalizados e categorizados (Técnica, Repertório, Teoria) com a ajuda da inteligência artificial do Google Gemini.
- **Ferramentas de Prática Integradas**:
  - **Metrônomo**: Mantenha o tempo perfeito durante seus estudos.
  - **Reprodutor do YouTube**: Assista a videoaulas e tutoriais diretamente no aplicativo (suporte a player flutuante).
  - **Gravador de Áudio**: Grave suas sessões de prática para autoavaliação e acompanhamento de progresso.
- **Gerenciamento de Sessões e Objetivos**: Acompanhe o histórico de suas sessões de estudo, faça anotações (Annotations) e avalie seu desempenho.
- **Lembretes e Notificações**: Configure notificações para manter sua rotina de prática consistente.
- **Persistência de Dados (Core Data)**: Todo o seu progresso, gravações, histórico, metas e perfil de usuário são salvos localmente e de forma segura no dispositivo.

## 🛠 Tech Stack & Arquitetura

- **Linguagem**: Swift
- **Framework de UI**: SwiftUI
- **Banco de Dados Local**: Core Data
- **Integração de IA**: API do Google Gemini (para análise e sugestões)
- **Recursos e Frameworks Nativos**:
  - `AVFoundation` para o metrônomo e gravação/reprodução de áudio
  - `UserNotifications` para os lembretes de prática

## 📂 Estrutura do Projeto

A arquitetura do projeto foi estruturada para manter o código limpo, escalável e de fácil manutenção:

- **Model**: Estruturas de dados (DTOs) e definições do Core Data.
- **View**: Telas organizadas por contexto e funcionalidade (`Home`, `Goal`, `Metronome`, `Practice`, `Profile`, `History`, `Onboarding`).
- **Repositories**: Abstração de acesso a dados persistidos no Core Data (`UserRepository`, `ObjectiveRepository`, `SessionRepository`, `RecordingRepository`, etc.).
- **Services**: Lógica de negócios especializada (`GeminiService`, `MetroronomeService`, `PracticeNotificationService`).
- **App**: Ponto de entrada do aplicativo (`MusicJourneyApp.swift`).

## ⚙️ Como Começar

### Pré-requisitos

- **Xcode**: Versão 15.0 ou superior.
- **iOS**: iOS 17.0 ou superior.
- **Chave de API do Gemini**: Necessária para o funcionamento do recurso de geração de metas por IA.

### Instalação

1. **Clone o repositório** (ou baixe os arquivos do projeto):
   ```bash
   git clone https://github.com/seu-usuario/MusicJourney.git
   ```
2. **Abra o projeto** no Xcode:
   ```bash
   cd MusicJourney
   open MusicJourney.xcodeproj
   ```
3. **Configure as Chaves de API**:
   - Localize o arquivo `Secrets.swift` no projeto.
   - Insira sua chave da API do Gemini.
   *(Atenção: Certifique-se de nunca commitar suas chaves de API em um controle de versão público!)*

4. **Compile e Execute**:
   - Selecione seu dispositivo de destino (ou simulador) no Xcode.
   - Pressione `Cmd + R` para compilar e executar o aplicativo.

## 🔒 Privacidade & Permissões

O MusicJourney solicita algumas permissões para oferecer uma experiência completa:
- **Microfone**: Necessário para a funcionalidade de gravação de áudio das sessões de prática.
- **Notificações**: Necessário para enviar lembretes programados de estudo.
