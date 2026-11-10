import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = (origin: string) => ({
  'Access-Control-Allow-Origin': origin,
  'Access-Control-Allow-Headers': 'authorization, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Vary': 'Origin',
});

Deno.serve(async (req: Request) => {
  const origin = req.headers.get('origin') || '';
  const allowedOrigin = Deno.env.get('CANCHA_SITE_URL') || '';
  if (req.method === 'OPTIONS') {
    if (!allowedOrigin || origin !== allowedOrigin) return new Response('Forbidden origin', { status: 403 });
    return new Response('ok', { headers: corsHeaders(origin) });
  }
  if (req.method !== 'POST') return new Response('Method not allowed', { status: 405 });
  if (!allowedOrigin || origin !== allowedOrigin) return new Response('Forbidden origin', { status: 403 });
  const authorization = req.headers.get('authorization') || '';
  const token = authorization.match(/^Bearer (.+)$/i)?.[1];
  if (!token) return new Response('Authentication required', { status: 401, headers: corsHeaders(origin) });

  const url = Deno.env.get('SUPABASE_URL');
  const publishableKey = Deno.env.get('SUPABASE_PUBLISHABLE_KEY');
  const secretKey = Deno.env.get('SUPABASE_SECRET_KEY');
  if (!url || !publishableKey || !secretKey) return new Response('Server not configured', { status: 500, headers: corsHeaders(origin) });

  const userClient = createClient(url, publishableKey, {
    auth: { autoRefreshToken: false, persistSession: false },
    global: { headers: { Authorization: 'Bearer ' + token } },
  });
  const { data: { user }, error: userError } = await userClient.auth.getUser(token);
  if (userError || !user) return new Response('Invalid session', { status: 401, headers: corsHeaders(origin) });

  const admin = createClient(url, secretKey, { auth: { autoRefreshToken: false, persistSession: false } });
  const { error: deleteError } = await admin.auth.admin.deleteUser(user.id);
  if (deleteError) return new Response('Could not delete account', { status: 500, headers: corsHeaders(origin) });
  return new Response(null, { status: 204, headers: corsHeaders(origin) });
});
