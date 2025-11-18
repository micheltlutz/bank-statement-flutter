# Templates GitHub

Esta pasta contém templates para Pull Requests do projeto.

## 📝 Templates Disponíveis

### `pull_request_template.md` (Completo)
Template detalhado e abrangente com todas as seções necessárias para uma revisão completa do PR.

**Use quando:**
- PRs complexos com múltiplas mudanças
- Features significativas
- Breaking changes
- Mudanças que afetam múltiplos packages

### `pull_request_template_simple.md` (Simplificado)
Template conciso e direto ao ponto para PRs menores.

**Use quando:**
- Correções simples de bugs
- Pequenas melhorias
- Atualizações de documentação
- Refatorações menores

## 🚀 Como Usar

### Usar o Template Padrão (Completo)
O GitHub automaticamente usa o arquivo `pull_request_template.md` quando você cria um novo PR.

### Usar o Template Simplificado
1. Ao criar o PR, copie o conteúdo de `pull_request_template_simple.md`
2. Cole no campo de descrição do PR
3. Preencha as informações necessárias

### Personalizar um Template
1. Copie o template desejado
2. Modifique conforme necessário
3. Cole na descrição do PR

## 📋 Guia de Preenchimento

### Tipo de Mudança
- **🐛 Bug fix**: Correção de erros sem quebrar funcionalidades existentes
- **✨ Nova feature**: Adição de novas funcionalidades
- **💥 Breaking change**: Mudanças que quebram compatibilidade
- **📚 Documentação**: Apenas mudanças em documentação
- **♻️ Refatoração**: Reorganização de código sem mudança de comportamento
- **⚡ Performance**: Otimizações de performance
- **✅ Testes**: Adição ou correção de testes

### Packages Afetados
Marque todos os packages que foram modificados:
- `core`: Package base com interfaces e utilitários
- `network`: Package de rede HTTP
- `auth`: Package de autenticação
- `balance`: Package de saldo
- `statement`: Package de extratos
- `app`: Aplicativo principal

### Checklist
Certifique-se de marcar todos os itens relevantes antes de solicitar revisão.

## 💡 Dicas

1. **Seja específico**: Descreva claramente o que foi feito e por quê
2. **Inclua contexto**: Explique o problema que está sendo resolvido
3. **Adicione screenshots**: Para mudanças visuais, sempre inclua antes/depois
4. **Teste localmente**: Certifique-se de que tudo funciona antes de abrir o PR
5. **Atualize documentação**: Se necessário, atualize a documentação relacionada

## 🔗 Links Úteis

- [Documentação de Arquitetura](../docs/ARCHITECTURE.md)
- [Guia de Setup do Projeto](../docs/PROJECT_SETUP.md)
- [Troubleshooting](../docs/TROUBLESHOOTING.md)

