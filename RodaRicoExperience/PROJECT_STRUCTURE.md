# Estrutura do Projeto RodaRicoExperience

## Visão Geral
Este projeto foi reorganizado seguindo as melhores práticas de arquitetura iOS/Swift, com uma estrutura modular e organizada por funcionalidades.

## Estrutura de Pastas

### 📱 App/
Contém os arquivos principais da aplicação:
- `RodaRicoExperienceApp.swift` - Ponto de entrada da aplicação
- `ContentView.swift` - View principal da aplicação

### 🏗️ Core/
Contém os componentes fundamentais do projeto:
- **Models/** - Modelos de dados e estruturas
- **Protocols/** - Protocolos e interfaces
- **Constants/** - Constantes e configurações
- **Extensions/** - Extensões de classes existentes

### 🎯 Features/
Organizado por funcionalidades principais:

#### StartGame/
- **Views/** - Views principais do jogo
- **ViewModels/** - ViewModels para gerenciamento de estado
- **Coordinators/** - Coordenadores para navegação
- **ARViews/** - Views relacionadas à realidade aumentada
- **OverlayViews/** - Views de sobreposição
- **SuccessViews/** - Views de sucesso/conclusão
- **StartGameModule.swift** - Módulo principal do jogo
- **StartGameIndex.swift** - Índice de funcionalidades
- **README.md** - Documentação específica do módulo
- **TROUBLESHOOTING.md** - Guia de resolução de problemas

#### AR/
- **Views/** - Views relacionadas à realidade aumentada
- **Coordinators/** - Coordenadores para funcionalidades AR

### 🔧 Shared/
Componentes e utilitários compartilhados:
- **Components/** - Componentes reutilizáveis
- **Utilities/** - Funções utilitárias

### 📦 Resources/
Recursos da aplicação:
- **Assets.xcassets/** - Imagens e recursos visuais
- **Localization/** - Arquivos de localização (futuro)

### 🧪 Tests/
Testes automatizados:
- **UnitTests/** - Testes unitários
- **Teste2/** - Testes adicionais

## Benefícios da Nova Estrutura

1. **Modularidade**: Cada funcionalidade está isolada em sua própria pasta
2. **Manutenibilidade**: Fácil localização de arquivos relacionados
3. **Escalabilidade**: Estrutura preparada para crescimento do projeto
4. **Separação de Responsabilidades**: Core, Features e Shared bem definidos
5. **Padrão da Indústria**: Segue convenções estabelecidas na comunidade iOS

## Convenções de Nomenclatura

- **PascalCase** para nomes de arquivos e pastas
- **camelCase** para nomes de variáveis e funções
- Prefixos descritivos para evitar conflitos
- Sufixos consistentes (View, ViewModel, Coordinator, etc.)

## Próximos Passos

1. Atualizar imports nos arquivos movidos
2. Verificar referências quebradas
3. Executar testes para validar a reorganização
4. Atualizar documentação conforme necessário


