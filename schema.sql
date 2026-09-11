-- SCHEMA: Jogo de Competição da Turma
-- Rode isso no SQL Editor do seu projeto Supabase.

create extension if not exists "pgcrypto";

create table rooms (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  host_name text,
  status text not null default 'config', -- config | lobby | active | finished
  current_challenge_id uuid,
  current_challenge_ends_at timestamptz,
  created_at timestamptz not null default now()
);

create table challenges (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references rooms(id) on delete cascade,
  order_index int not null,
  type text not null check (type in ('multipla','aberta','velocidade')),
  pergunta text not null,
  opcoes jsonb,             -- ["Opção A","Opção B",...] só para 'multipla'
  resposta_correta text,    -- texto exato de uma das opções, só para 'multipla'
  pontos int not null default 10,
  tempo_segundos int not null default 30,
  status text not null default 'pendente' -- pendente | ativo | encerrado
);

create table players (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references rooms(id) on delete cascade,
  nome text not null,
  pontuacao int not null default 0,
  created_at timestamptz not null default now()
);

create table answers (
  id uuid primary key default gen_random_uuid(),
  challenge_id uuid not null references challenges(id) on delete cascade,
  player_id uuid not null references players(id) on delete cascade,
  resposta text,
  respondido_em timestamptz not null default now(),
  pontos_ganhos int not null default 0,
  avaliado boolean not null default false,
  unique (challenge_id, player_id)
);

-- Auto-pontua desafios de múltipla escolha na hora da resposta.
-- 'aberta' e 'velocidade' ficam com pontos_ganhos = 0 até o host avaliar manualmente.
create or replace function handle_answer_insert()
returns trigger as $$
declare
  c challenges%rowtype;
begin
  select * into c from challenges where id = new.challenge_id;

  if c.type = 'multipla' then
    if trim(lower(new.resposta)) = trim(lower(coalesce(c.resposta_correta, ''))) then
      new.pontos_ganhos := c.pontos;
    else
      new.pontos_ganhos := 0;
    end if;
    new.avaliado := true;
  else
    new.pontos_ganhos := 0;
    new.avaliado := false;
  end if;

  return new;
end;
$$ language plpgsql;

create trigger trg_handle_answer_insert
before insert on answers
for each row execute function handle_answer_insert();

-- Recalcula a pontuação total do jogador sempre que uma resposta é
-- inserida ou reavaliada pelo host (aberta/velocidade).
create or replace function recompute_player_score()
returns trigger as $$
begin
  update players
  set pontuacao = (
    select coalesce(sum(pontos_ganhos), 0)
    from answers
    where player_id = coalesce(new.player_id, old.player_id)
  )
  where id = coalesce(new.player_id, old.player_id);
  return new;
end;
$$ language plpgsql;

create trigger trg_recompute_score_ins
after insert on answers
for each row execute function recompute_player_score();

create trigger trg_recompute_score_upd
after update of pontos_ganhos on answers
for each row execute function recompute_player_score();

-- Realtime: liga as tabelas que a sala e os jogadores escutam ao vivo.
alter publication supabase_realtime add table rooms;
alter publication supabase_realtime add table challenges;
alter publication supabase_realtime add table players;
alter publication supabase_realtime add table answers;

-- RLS: ligado, mas com política aberta para chave anônima.
-- AVISO: isso é aceitável só para um jogo de sala de aula de curta duração,
-- sem dados sensíveis. Não use esse padrão de política num app com dados reais.
alter table rooms enable row level security;
alter table challenges enable row level security;
alter table players enable row level security;
alter table answers enable row level security;

create policy "acesso livre anon" on rooms for all using (true) with check (true);
create policy "acesso livre anon" on challenges for all using (true) with check (true);
create policy "acesso livre anon" on players for all using (true) with check (true);
create policy "acesso livre anon" on answers for all using (true) with check (true);
