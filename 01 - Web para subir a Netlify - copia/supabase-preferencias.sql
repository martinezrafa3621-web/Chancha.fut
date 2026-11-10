-- Cancha.fut · tabla de preferencias (favoritos, ligas) por usuario
-- Pégalo en Supabase > SQL Editor > New query > Run. Es seguro ejecutarlo más de una vez.

create table if not exists public.cancha_user_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade
);

alter table public.cancha_user_preferences add column if not exists saved_leagues jsonb not null default '[]'::jsonb;
alter table public.cancha_user_preferences add column if not exists favorite_teams jsonb not null default '[]'::jsonb;
alter table public.cancha_user_preferences add column if not exists team_data jsonb not null default '{}'::jsonb;
alter table public.cancha_user_preferences add column if not exists favorite_matches jsonb not null default '[]'::jsonb;
alter table public.cancha_user_preferences add column if not exists terms_version text;
alter table public.cancha_user_preferences add column if not exists terms_accepted_at timestamptz;
alter table public.cancha_user_preferences add column if not exists updated_at timestamptz not null default now();

alter table public.cancha_user_preferences enable row level security;

drop policy if exists "cancha_prefs_select_own" on public.cancha_user_preferences;
drop policy if exists "cancha_prefs_insert_own" on public.cancha_user_preferences;
drop policy if exists "cancha_prefs_update_own" on public.cancha_user_preferences;
drop policy if exists "cancha_prefs_delete_own" on public.cancha_user_preferences;

create policy "cancha_prefs_select_own" on public.cancha_user_preferences
  for select to authenticated using (auth.uid() = user_id);
create policy "cancha_prefs_insert_own" on public.cancha_user_preferences
  for insert to authenticated with check (auth.uid() = user_id);
create policy "cancha_prefs_update_own" on public.cancha_user_preferences
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "cancha_prefs_delete_own" on public.cancha_user_preferences
  for delete to authenticated using (auth.uid() = user_id);

grant select, insert, update, delete on public.cancha_user_preferences to authenticated;
