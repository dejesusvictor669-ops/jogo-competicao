# Jogo da Turma — Competição ao vivo

Site estático (HTML/CSS/JS puro) + Supabase (banco + tempo real). Sem build step — dá pra rodar local abrindo os arquivos ou publicar direto no Vercel.

## Arquivos
- `index.html` — escolher host ou jogador
- `host.html` — montar desafios e controlar a partida
- `player.html` — entrar na sala e responder
- `app.js` — configuração do Supabase (**você precisa editar**)
- `style.css` — visual
- `schema.sql` — script para rodar no Supabase

## Passo 1 — Supabase
1. Crie um projeto em https://supabase.com (grátis).
2. No painel do projeto, vá em **SQL Editor** → **New query**, cole o conteúdo de `schema.sql` e rode.
3. Vá em **Project Settings → API**. Copie a **Project URL** e a chave **anon public**.
4. Abra `app.js` e substitua:
   ```js
   const SUPABASE_URL = "COLOQUE_SUA_SUPABASE_URL_AQUI";
   const SUPABASE_ANON_KEY = "COLOQUE_SUA_SUPABASE_ANON_KEY_AQUI";
   ```
   pelos valores copiados.

## Passo 2 — GitHub
```bash
cd jogo-competicao
git init
git add .
git commit -m "primeira versão do jogo"
```
Crie um repositório vazio no GitHub (github.com/new, sem README), depois:
```bash
git remote add origin https://github.com/SEU_USUARIO/NOME_DO_REPO.git
git branch -M main
git push -u origin main
```

## Passo 3 — Vercel
1. Entre em https://vercel.com com sua conta GitHub.
2. **Add New → Project** → selecione o repositório que você acabou de subir.
3. Framework preset: deixe **"Other"** (é site estático, não precisa de build command).
4. Deploy. Em ~1 minuto você tem uma URL tipo `seu-jogo.vercel.app`.

## Passo 4 — Testar ANTES da aula
Isso ainda não foi testado num navegador real com um projeto Supabase de verdade — teste com pelo menos 2 abas (uma como host, outra como jogador) antes de usar com a turma:
1. Abra `/host.html`, crie a sala, adicione 1-2 desafios de cada tipo.
2. Abra `/player.html` numa aba anônima (ou pelo celular), entre com o código.
3. Rode um desafio de múltipla escolha inteiro e confira se o ponto foi contado certo.
4. Rode um de resposta aberta e confirme que o botão "Dar pontos" no host funciona e atualiza o placar do jogador em tempo real.
5. Confirme que a sala aceita várias pessoas entrando ao mesmo tempo (peça pra 2-3 colegas testarem com você).

## Limitações conhecidas (aceitas pelo prazo de hoje)
- Sem autenticação — qualquer um com o código entra na sala. Ok para uma dinâmica de sala de aula, não use para nada sensível.
- Política do banco (RLS) está aberta para simplificar — não é um padrão de segurança para produção.
- Tipo de desafio é fixo em 3 opções (múltipla, aberta, velocidade) — "regra livre" do host é sobre pontos/tempo, não sobre inventar um novo tipo de mecânica na hora.
