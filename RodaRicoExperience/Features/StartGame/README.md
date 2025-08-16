# StartGame - Estrutura do Projeto

## Visão Geral
Este módulo implementa a experiência de jogo RodaRico usando AR (Realidade Aumentada) com detecção de stickers e sistema de perguntas em fases.

## Arquitetura

### Estrutura de Pastas
```
StartGame/
├── Models/                    # Modelos de dados
│   ├── Question.swift         # Modelo de pergunta
│   ├── GamePhase.swift        # Enum de fases do jogo
│   └── StartGameViewState.swift # Enum de estados da view
├── ViewModels/                # ViewModels
│   └── StartGameViewModel.swift # ViewModel principal
├── Views/                     # Views principais
│   ├── StartGameView.swift    # View principal com switch de estados
│   ├── LuzStickerScannerView.swift # Scanner do sticker Luz
│   ├── MaquiagemStickerScannerView.swift # Scanner do sticker Maquiagem
│   ├── QuestionsPhase1View.swift # Perguntas da Fase 1
│   ├── QuestionsPhase2View.swift # Perguntas da Fase 2
│   └── GameCompleteView.swift # Tela de conclusão
├── ARViews/                   # Views AR
│   ├── LuzStickerARContainerView.swift # Container AR para Luz
│   └── MaquiagemStickerARContainerView.swift # Container AR para Maquiagem
├── Coordinators/              # Coordenadores AR
│   ├── LuzStickerCoordinator.swift # Coordinator para Luz
│   └── MaquiagemStickerCoordinator.swift # Coordinator para Maquiagem
├── OverlayViews/              # Views de overlay
│   ├── LuzStickerOverlayView.swift # Overlay para Luz
│   └── MaquiagemStickerOverlayView.swift # Overlay para Maquiagem
├── SuccessViews/              # Views de sucesso
│   ├── LuzStickerSuccessView.swift # Modal de sucesso Luz
│   └── MaquiagemStickerSuccessView.swift # Modal de sucesso Maquiagem
└── Protocols/                 # Protocolos
    └── StartGameProtocols.swift # Protocolos do sistema
```

## Fluxo de Navegação

### Estados da View (StartGameViewState)
1. **arView** - View principal AR com foguete
2. **luzScanner** - Scanner do sticker "Luz"
3. **phase1Questions** - Perguntas da Fase 1
4. **maquiagemScanner** - Scanner do sticker "Maquiagem"
5. **phase2Questions** - Perguntas da Fase 2
6. **gameComplete** - Tela de conclusão

### Transições
- **arView** → **luzScanner**: Após detectar foguete e instruções
- **luzScanner** → **phase1Questions**: Após detectar sticker Luz
- **phase1Questions** → **maquiagemScanner**: Após responder 3 perguntas corretamente
- **maquiagemScanner** → **phase2Questions**: Após detectar sticker Maquiagem
- **phase2Questions** → **gameComplete**: Após responder 3 perguntas corretamente

## Componentes Principais

### StartGameViewModel
- Gerencia todos os estados da aplicação
- Controla navegação entre views
- Mantém estado das fases e respostas
- Centraliza toda a lógica de negócio

### Coordinators
- **LuzStickerCoordinator**: Gerencia sessão AR para sticker Luz
- **MaquiagemStickerCoordinator**: Gerencia sessão AR para sticker Maquiagem
- Implementam `ARSessionDelegate` para detecção de imagens

### AR Container Views
- **LuzStickerARContainerView**: Configura sessão AR para sticker Luz
- **MaquiagemStickerARContainerView**: Configura sessão AR para sticker Maquiagem
- Implementam `UIViewRepresentable` para integração SwiftUI-ARKit

## Funcionalidades

### Detecção AR
- Tracking de imagens de referência
- Feedback visual em tempo real
- Tratamento de interrupções e falhas
- Reset automático de sessões

### Sistema de Perguntas
- 3 perguntas por fase
- Progresso visual
- Validação de respostas
- Navegação automática após conclusão

### UI/UX
- Overlays informativos
- Modais de sucesso
- Indicadores de status
- Navegação intuitiva

## Boas Práticas Implementadas

1. **Separação de Responsabilidades**: Cada arquivo tem uma responsabilidade específica
2. **Arquitetura MVVM**: ViewModel centralizado com estado observável
3. **Coordinator Pattern**: Para gerenciamento de sessões AR
4. **Protocol-Oriented Programming**: Uso de protocolos para contratos
5. **Modularização**: Componentes reutilizáveis e independentes
6. **Navegação Centralizada**: Todas as mudanças de tela via StartGameViewState

## Performance

- **Lazy Loading**: Views são carregadas apenas quando necessário
- **Memory Management**: Coordinators são desalocados automaticamente
- **AR Session Optimization**: Configurações específicas para cada sticker
- **State Management**: Estado centralizado evita recriação desnecessária de views

## Manutenibilidade

- **Código Limpo**: Cada arquivo tem uma responsabilidade única
- **Documentação**: Comentários explicativos em métodos complexos
- **Estrutura Clara**: Organização lógica de pastas e arquivos
- **Reutilização**: Componentes podem ser facilmente reutilizados

