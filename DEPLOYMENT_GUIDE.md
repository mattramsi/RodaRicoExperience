# 🚀 Guia de Deploy - Roda Rico Experience

Este guia explica como configurar e usar o Fastlane para fazer deploy do aplicativo Roda Rico Experience na Apple Store.

## 📋 Pré-requisitos

### 1. Conta de Desenvolvedor Apple
- [ ] Conta de desenvolvedor Apple ativa
- [ ] App registrado no App Store Connect
- [ ] Bundle ID configurado corretamente

### 2. Ferramentas Necessárias
- [ ] Xcode instalado (versão mais recente)
- [ ] Ruby instalado (versão 2.7+)
- [ ] Git configurado
- [ ] Apple ID configurado no Xcode

## 🛠️ Configuração Inicial

### 1. Configurar Bundle ID
**IMPORTANTE**: O bundle ID atual está incorreto (`com.app..RodaRicoExperience`). Corrija para `com.rodarico.RodaRicoExperience`:

1. Abra o projeto no Xcode
2. Selecione o target `RodaRicoExperience`
3. Na aba `Signing & Capabilities`
4. Altere o Bundle Identifier para `com.rodarico.RodaRicoExperience`

### 2. Configurar Apple ID
Edite o arquivo `fastlane/Appfile` e substitua:
```ruby
apple_id("seu_email@exemplo.com") # Substitua pelo seu Apple ID
```

### 3. Configurar Team ID
O Team ID já está configurado como `BKK27272P7`. Se for diferente, atualize em:
- `fastlane/Appfile`
- `fastlane/Fastfile`

## 🚀 Instalação e Configuração

### 1. Executar Setup
```bash
./scripts/setup.sh
```

Este script irá:
- Instalar dependências do Ruby
- Verificar se o Xcode está instalado
- Instalar o Fastlane

### 2. Configurar Certificados
```bash
bundle exec fastlane certificates
```

Este comando irá:
- Gerar certificados de desenvolvimento e distribuição
- Gerar provisioning profiles
- Salvar os arquivos na pasta `fastlane/certificates/` e `fastlane/profiles/`

## 📱 Deploy para TestFlight

### 1. Deploy Automático
```bash
./scripts/deploy.sh beta
```

### 2. Deploy Manual
```bash
bundle exec fastlane beta
```

### 3. O que acontece:
- Incrementa o build number automaticamente
- Compila o app para distribuição
- Faz upload para TestFlight
- Adiciona ao grupo "Internal Testing"

## 🏪 Deploy para App Store

### 1. Deploy Automático
```bash
./scripts/deploy.sh release
```

### 2. Deploy Manual
```bash
bundle exec fastlane release
```

### 3. O que acontece:
- Incrementa o build number automaticamente
- Compila o app para distribuição
- Faz upload para App Store
- **NÃO** submete para revisão automaticamente

## 🔧 Comandos Úteis

### Build Local
```bash
bundle exec fastlane dev          # Build para desenvolvimento
bundle exec fastlane adhoc        # Build para distribuição ad-hoc
bundle exec fastlane enterprise   # Build para distribuição enterprise
```

### Gerenciar Versões
```bash
bundle exec fastlane increment_build    # Incrementar build number
bundle exec fastlane increment_version  # Incrementar version number
```

### Verificar Configuração
```bash
bundle exec fastlane lanes  # Listar todas as lanes disponíveis
```

## 📁 Estrutura de Arquivos

```
RodaRicoExperience/
├── fastlane/
│   ├── Appfile          # Configurações do app
│   ├── Fastfile         # Lanes do Fastlane
│   └── Matchfile        # Configuração do Match (opcional)
├── scripts/
│   ├── setup.sh         # Script de configuração inicial
│   └── deploy.sh        # Script de deploy
├── Gemfile              # Dependências Ruby
└── .gitignore           # Arquivos ignorados pelo Git
```

## ⚠️ Troubleshooting

### Erro de Bundle ID
Se aparecer erro sobre bundle ID:
1. Verifique se o bundle ID está correto no Xcode
2. Verifique se o app está registrado no App Store Connect
3. Verifique se o Team ID está correto

### Erro de Certificados
Se aparecer erro de certificados:
1. Execute `bundle exec fastlane certificates`
2. Verifique se o Apple ID está correto
3. Verifique se a conta tem permissões de desenvolvedor

### Erro de Provisioning Profile
Se aparecer erro de provisioning profile:
1. Verifique se o bundle ID está registrado no Apple Developer Portal
2. Execute `bundle exec fastlane certificates` novamente
3. Verifique se o Team ID está correto

### Erro de Upload
Se o upload falhar:
1. Verifique sua conexão com a internet
2. Verifique se o app está compilando corretamente
3. Verifique se os certificados não expiraram

## 🔐 Segurança

### Arquivos Sensíveis
Nunca commite estes arquivos:
- `*.p12` (certificados)
- `*.cer` (certificados)
- `*.mobileprovision` (provisioning profiles)
- `fastlane/certificates/`
- `fastlane/profiles/`

### Variáveis de Ambiente
Para maior segurança, use variáveis de ambiente:
```bash
export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="sua_senha"
export FASTLANE_SESSION="sua_sessao"
```

## 📊 Monitoramento

### Logs
Os logs do Fastlane ficam em:
- `fastlane/logs/`

### Relatórios
Os relatórios ficam em:
- `fastlane/report.xml`
- `fastlane/Preview.html`

## 🆘 Suporte

### Comandos de Debug
```bash
bundle exec fastlane --verbose    # Modo verboso
bundle exec fastlane --trace      # Modo trace
```

### Limpar Cache
```bash
bundle exec fastlane clean        # Limpar cache do Fastlane
```

## 📝 Checklist de Deploy

### Antes do Deploy
- [ ] Bundle ID configurado corretamente
- [ ] Apple ID configurado no Appfile
- [ ] Team ID configurado corretamente
- [ ] App registrado no App Store Connect
- [ ] Certificados válidos
- [ ] Provisioning profiles válidos
- [ ] App compila sem erros
- [ ] Testes passando

### Durante o Deploy
- [ ] Build number incrementado
- [ ] App compilado com sucesso
- [ ] Upload realizado com sucesso
- [ ] Verificar logs para erros

### Após o Deploy
- [ ] Verificar no App Store Connect
- [ ] Testar no TestFlight (se aplicável)
- [ ] Submeter para revisão (se necessário)
- [ ] Configurar metadados do app

## 🎯 Próximos Passos

1. **Configure o Bundle ID** no Xcode
2. **Execute o setup**: `./scripts/setup.sh`
3. **Configure certificados**: `bundle exec fastlane certificates`
4. **Teste o build**: `bundle exec fastlane dev`
5. **Deploy para TestFlight**: `./scripts/deploy.sh beta`
6. **Deploy para App Store**: `./scripts/deploy.sh release`

---

**Boa sorte com seu deploy! 🚀**
