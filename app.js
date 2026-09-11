// ⚠️ Troque pelos dados do SEU projeto Supabase (Project Settings > API).
const SUPABASE_URL = "https://proqcizcgwxvjmkeaqwh.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_wX7n8Xsf-yVNV6FLbhMpHA_fzWaFVqx";
const supa = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

function generateRoomCode() {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // sem chars ambíguos
  let code = "";
  for (let i = 0; i < 5; i++) code += chars[Math.floor(Math.random() * chars.length)];
  return code;
}

function fmtSeconds(s) {
  if (s < 0) s = 0;
  const m = Math.floor(s / 60);
  const sec = s % 60;
  return m > 0 ? `${m}:${String(sec).padStart(2, "0")}` : `${sec}`;
}
