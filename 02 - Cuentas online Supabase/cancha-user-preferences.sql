-- Cancha.fut account preferences. Run this in Supabase SQL Editor.
create table if not exists public.cancha_user_preferences (
  user_id uuid primary key references auth.users(id) on delete cascade,
  saved_leagues jsonb not null default '[]'::jsonb check (jsonb_typeof(saved_leagues) = 'array'),
  favorite_teams jsonb not null default '[]'::jsonb check (jsonb_typeof(favorite_teams) = 'array'),
  team_data jsonb not null default '{}'::jsonb check (jsonb_typeof(team_data) = 'object'),
  favorite_matches jsonb not null default '[]'::jsonb check (jsonb_typeof(favorite_matches) = 'array'),
  terms_version text not null,
  terms_accepted_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.cancha_user_preferences enable row level security;
revoke all on table public.cancha_user_preferences from anon;
grant select, insert, update, delete on table public.cancha_user_preferences to authenticated;
drop policy if exists "Users can read own Cancha preferences" on public.cancha_user_preferences;
drop policy if exists "Users can create own Cancha preferences" on public.cancha_user_preferences;
drop policy if exists "Users can update own Cancha preferences" on public.cancha_user_preferences;
drop policy if exists "Users can delete own Cancha preferences" on public.cancha_user_preferences;
create policy "Users can read own Cancha preferences" on public.cancha_user_preferences for select to authenticated using (auth.uid() = user_id);
create policy "Users can create own Cancha preferences" on public.cancha_user_preferences for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can update own Cancha preferences" on public.cancha_user_preferences for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete own Cancha preferences" on public.cancha_user_preferences for delete to authenticated using (auth.uid() = user_id);
create or replace function public.set_cancha_user_preferences_updated_at() returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
drop trigger if exists set_cancha_user_preferences_updated_at on public.cancha_user_preferences;
create trigger set_cancha_user_preferences_updated_at before update on public.cancha_user_preferences for each row execute procedure public.set_cancha_user_preferences_updated_at();
