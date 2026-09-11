// ⚠️ Troque pelos dados do SEU projeto Supabase (Project Settings > API).
const SUPABASE_URL = "sb_publishable_wX7n8Xsf-yVNV6FLbhMpHA_fzWaFVqx";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InByb3FjaXpjZ3d4dmpta2VhcXdoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkxNDg1NzksImV4cCI6MjEwNDcyNDU3OX0.Vpln_iU4XNX7Q3zPUnhzziNpMgzN366g1ToEdOE0aL4";

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
