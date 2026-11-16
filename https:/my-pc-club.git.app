<!DOCTYPE html>
<html lang="ru">
<head>
<!--
  PC CLUB · СБОР НА КАТКУ — Telegram Mini App (локальный, без сервера)
  ─ Как подключить к чату:
    1) Залей этот файл на любой https-хостинг (GitHub Pages / Netlify / свой сервер).
    2) BotFather → /newbot → /newapp (или Menu Button) → укажи URL файла.
    3) В настройках приложения (шестерёнка) вставь ссылку вида https://t.me/твой_бот/app
       и отправь сбор в нужный чат — код чата изолирует данные этого чата.
    4) Данные хранятся локально на устройстве; «Экспорт/Импорт» в настройках
       синхронизирует сквад через сообщение в чате. Вне Telegram работает
       в локальном режиме (открой файл напрямую) — всё полностью функционально.
-->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#05070D">
<meta name="description" content="Сбор сквада в PC-клуб: отметь удобные даты месяца, найди лучший день, зафиксируй катку.">
<title>PC CLUB · Сбор на катку</title>
<script src="https://telegram.org/js/telegram-web-app.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Russo+One&family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600;700&display=swap" rel="stylesheet">
<style>
:root{
  --bg0:#05070D; --bg1:#0B1226; --surface:#0E1630; --surface2:#152045;
  --line:rgba(122,150,255,.16); --line2:rgba(122,150,255,.30);
  --cyan:#00E5FF; --magenta:#FF2E7E; --violet:#7B5CFF; --acid:#9CFF2E;
  --amber:#FFB020; --red:#FF4D5E; --blue:#3D8BFF;
  --text:#EAF2FF; --muted:#95A2C8; --dim:#5C6890;
  --grad:linear-gradient(100deg,var(--cyan),var(--violet) 52%,var(--magenta));
  --grad-hot:linear-gradient(100deg,var(--magenta),var(--amber));
  --fd:'Russo One','Arial Black',system-ui,sans-serif;
  --fb:'Manrope',system-ui,-apple-system,'Segoe UI',sans-serif;
  --fm:'JetBrains Mono',ui-monospace,'SF Mono',Consolas,monospace;
  --rad:14px; --headH:62px; --footH:118px; --tg-vh:100dvh;
  color-scheme:dark;
}
*{box-sizing:border-box;margin:0;padding:0}
html{scrollbar-color:#2A3A78 var(--bg0);scrollbar-width:thin}
html.locked{overflow:hidden}
body{
  background:var(--bg0);color:var(--text);font-family:var(--fb);
  font-size:15px;line-height:1.45;min-height:100dvh;overflow-x:hidden;
  -webkit-font-smoothing:antialiased;
}
::selection{background:var(--cyan);color:#041018}
::-webkit-scrollbar{width:10px;height:8px}
::-webkit-scrollbar-track{background:var(--bg0)}
::-webkit-scrollbar-thumb{background:linear-gradient(180deg,#2A3A78,#4A2F8F);border-radius:8px;border:2px solid var(--bg0)}
::-webkit-scrollbar-thumb:hover{background:linear-gradient(180deg,var(--cyan),var(--magenta))}
button{font-family:inherit;color:inherit;background:none;border:0;cursor:pointer;touch-action:manipulation}
button:disabled{cursor:not-allowed}
input,textarea{font-family:inherit;color:var(--text);color-scheme:dark}
:focus-visible{outline:2px solid var(--cyan);outline-offset:2px;border-radius:6px}
.ic{flex:none;vertical-align:-3px}

/* ═══ ФОН: неон клуба ═══ */
.bg{position:fixed;inset:0;z-index:0;pointer-events:none;overflow:hidden}
.bg .base{position:absolute;inset:0;background:
  radial-gradient(1100px 600px at 15% -10%,#101B3E 0%,transparent 60%),
  radial-gradient(900px 700px at 110% 15%,#1B0F35 0%,transparent 55%),
  linear-gradient(180deg,var(--bg1),var(--bg0) 45%)}
.blob{position:absolute;border-radius:50%;filter:blur(70px);opacity:.32;will-change:transform}
.b1{width:46vw;height:46vw;min-width:340px;min-height:340px;left:-12%;top:-14%;background:radial-gradient(circle,#00E5FF,transparent 65%);animation:drift1 26s ease-in-out infinite alternate}
.b2{width:40vw;height:40vw;min-width:300px;min-height:300px;right:-10%;top:6%;background:radial-gradient(circle,#FF2E7E,transparent 65%);animation:drift2 34s ease-in-out infinite alternate}
.b3{width:36vw;height:36vw;min-width:280px;min-height:280px;left:28%;bottom:-18%;background:radial-gradient(circle,#7B5CFF,transparent 65%);animation:drift3 40s ease-in-out infinite alternate}
@keyframes drift1{to{transform:translate(9vw,7vh) scale(1.15)}}
@keyframes drift2{to{transform:translate(-8vw,10vh) scale(.9)}}
@keyframes drift3{to{transform:translate(-6vw,-8vh) scale(1.2)}}
.floor{position:absolute;left:-25%;right:-25%;bottom:-14%;height:52vh;opacity:.17;
  background-image:
    repeating-linear-gradient(90deg,rgba(0,229,255,.55) 0 1.5px,transparent 1.5px 46px),
    repeating-linear-gradient(0deg,rgba(255,46,126,.5) 0 1.5px,transparent 1.5px 46px);
  transform:perspective(620px) rotateX(63deg);transform-origin:top center;
  -webkit-mask-image:linear-gradient(180deg,transparent,#000 32%);mask-image:linear-gradient(180deg,transparent,#000 32%);
  animation:floorMove 8s linear infinite}
@keyframes floorMove{to{background-position:0 46px,0 46px}}
.horizon{position:absolute;left:0;right:0;bottom:37vh;height:2px;background:var(--grad);opacity:.35;filter:blur(2px)}
.scan{position:absolute;inset:0;background:repeating-linear-gradient(0deg,rgba(255,255,255,.016) 0 1px,transparent 1px 3px)}
.grain{position:absolute;inset:0;opacity:.05;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='140'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2'/%3E%3C/filter%3E%3Crect width='140' height='140' filter='url(%23n)' opacity='0.6'/%3E%3C/svg%3E")}
.vig{position:absolute;inset:0;background:radial-gradient(120% 90% at 50% 40%,transparent 55%,rgba(0,0,0,.55))}
#fx{position:fixed;inset:0;z-index:60;pointer-events:none}

/* ═══ ШАПКА ═══ */
header{position:fixed;top:0;left:0;right:0;z-index:40;height:var(--headH);
  background:rgba(6,9,18,.82);backdrop-filter:blur(14px);-webkit-backdrop-filter:blur(14px);
  border-bottom:1px solid var(--line)}
.hwrap{max-width:1140px;margin:0 auto;height:100%;display:flex;align-items:center;gap:10px;padding:0 14px}
.logo{display:flex;align-items:center;gap:10px;min-width:0}
.logo .cube{width:36px;height:36px;flex:none;display:grid;place-items:center;border-radius:10px;color:var(--cyan);
  background:linear-gradient(140deg,#0E1B3E,#1A0F38);border:1px solid var(--line2);
  box-shadow:0 0 18px rgba(0,229,255,.28),inset 0 0 12px rgba(0,229,255,.12)}
.logo b{font-family:var(--fd);font-weight:400;font-size:17px;letter-spacing:.06em;white-space:nowrap}
.logo b i{font-style:normal;background:var(--grad);-webkit-background-clip:text;background-clip:text;color:transparent;animation:flick 7s steps(1) infinite}
@keyframes flick{0%,93%,96%,100%{opacity:1}94%,97%{opacity:.35}}
.logo small{display:block;font-family:var(--fm);font-size:9.5px;color:var(--dim);letter-spacing:.22em;text-transform:uppercase;margin-top:1px}
.hspace{flex:1}
.chatchip{display:flex;align-items:center;gap:7px;max-width:200px;padding:7px 11px;border-radius:99px;
  border:1px solid var(--line);background:rgba(14,22,48,.7);font-family:var(--fm);font-size:11px;color:var(--muted);transition:.2s}
.chatchip:hover{border-color:var(--cyan);color:var(--cyan);box-shadow:0 0 12px rgba(0,229,255,.2)}
.chatchip span{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.chatchip .dot{width:6px;height:6px;flex:none;border-radius:50%;background:var(--acid);box-shadow:0 0 8px var(--acid);animation:pulse 2.2s infinite}
@keyframes pulse{50%{opacity:.4}}
.hbtn{width:38px;height:38px;flex:none;display:grid;place-items:center;border-radius:10px;border:1px solid var(--line);
  background:rgba(14,22,48,.7);color:var(--muted);transition:.2s}
.hbtn:hover{color:var(--cyan);border-color:var(--cyan);box-shadow:0 0 12px rgba(0,229,255,.25)}
.hbtn:active{transform:scale(.93)}
.hbtn[aria-pressed="false"]{color:var(--dim)}
@media(max-width:430px){.chatchip span{max-width:74px}.logo small{display:none}}

/* ═══ КАРКАС ═══ */
main{position:relative;z-index:1;max-width:1140px;margin:0 auto;
  padding:calc(var(--headH) + 16px) 14px calc(var(--footH) + 26px)}
.cols{display:grid;gap:16px;margin-top:16px}
@media(min-width:960px){
  main{display:grid;grid-template-columns:minmax(0,1.12fr) minmax(0,.88fr);gap:20px;align-items:start}
  .colL,.colR{display:flex;flex-direction:column;gap:16px}
  .cols{margin-top:0}
}
.card{background:linear-gradient(160deg,rgba(17,26,58,.92),rgba(10,15,34,.92));
  border:1px solid var(--line);border-radius:18px;padding:16px;
  box-shadow:0 14px 40px rgba(0,0,0,.4)}
.card h2{font-family:var(--fd);font-weight:400;font-size:15px;letter-spacing:.1em;display:flex;align-items:center;gap:8px}
.card h2 .ic{color:var(--cyan)}
.card .sub{font-size:12px;color:var(--dim);margin-top:2px}
body.loaded .rise{animation:rise .55s cubic-bezier(.2,.9,.25,1) both}
@keyframes rise{from{opacity:0;transform:translateY(14px)}}

/* ═══ ЗАФИКСИРОВАННАЯ КАТКА ═══ */
.lockbanner{position:relative;border-radius:18px;padding:2px;background:linear-gradient(110deg,var(--magenta),var(--amber),var(--magenta));
  background-size:220% 100%;animation:borderFlow 4s linear infinite;margin-bottom:16px}
@keyframes borderFlow{to{background-position:220% 0}}
.lockbanner .in{background:linear-gradient(160deg,#1A0F2E,#0D1330);border-radius:16px;padding:16px}
.lb-tag{font-family:var(--fm);font-size:10px;letter-spacing:.28em;color:var(--amber);display:flex;align-items:center;gap:7px}
.lb-date{font-family:var(--fd);font-size:clamp(22px,5.4vw,30px);margin:6px 0 2px;
  background:var(--grad-hot);-webkit-background-clip:text;background-clip:text;color:transparent}
.lb-meta{font-size:13px;color:var(--muted);display:flex;flex-wrap:wrap;gap:6px 14px}
.lb-meta b{color:var(--text)}
.lb-cd{font-family:var(--fm);font-size:clamp(18px,4.6vw,24px);font-weight:700;color:var(--acid);
  text-shadow:0 0 16px rgba(156,255,46,.5);margin-top:10px}
.lb-cd small{display:block;font-size:9.5px;letter-spacing:.3em;color:var(--dim);font-weight:400;margin-bottom:2px}
.lb-cd.live{color:var(--magenta);text-shadow:0 0 16px rgba(255,46,126,.6);animation:pulse 1.4s infinite}
.lb-cd.done{color:var(--dim);text-shadow:none}
.lb-crew{display:flex;flex-wrap:wrap;gap:6px;margin-top:12px}
.lb-actions{display:flex;gap:8px;margin-top:14px;flex-wrap:wrap}

/* ═══ МЕСЯЦ ═══ */
.monthbar{display:flex;align-items:center;gap:10px;margin-bottom:12px}
.mnav{width:42px;height:42px;flex:none;display:grid;place-items:center;border-radius:12px;
  border:1px solid var(--line2);background:var(--surface);color:var(--cyan);transition:.2s}
.mnav:hover:not(:disabled){box-shadow:0 0 14px rgba(0,229,255,.3);border-color:var(--cyan)}
.mnav:active:not(:disabled){transform:scale(.92)}
.mnav:disabled{opacity:.25}
.mnav.attn{animation:attn 1.6s infinite}
@keyframes attn{50%{box-shadow:0 0 18px rgba(0,229,255,.55);border-color:var(--cyan)}}
.mtitle{flex:1;text-align:center;min-width:0}
.mtitle h1{font-family:var(--fd);font-weight:400;font-size:clamp(24px,6vw,32px);letter-spacing:.05em;
  background:var(--grad);-webkit-background-clip:text;background-clip:text;color:transparent}
.mtitle h1 span{font-family:var(--fm);font-size:.5em;color:var(--dim);-webkit-text-fill-color:var(--dim);margin-left:8px;letter-spacing:.1em}
.mstats{font-family:var(--fm);font-size:11px;color:var(--muted);margin-top:3px;display:flex;justify-content:center;gap:6px;flex-wrap:wrap}
.mstats b{color:var(--acid);font-weight:600}
.mstats button{color:var(--cyan);font-family:var(--fm);font-size:11px;text-decoration:underline dotted;text-underline-offset:3px}
.todaychip{display:block;margin:0 auto 10px;font-family:var(--fm);font-size:11px;color:var(--amber);
  border:1px dashed rgba(255,176,32,.5);border-radius:99px;padding:5px 14px;transition:.2s}
.todaychip:hover{background:rgba(255,176,32,.1)}
.hintbar{display:flex;align-items:center;gap:9px;margin-bottom:12px;padding:10px 12px;border-radius:12px;
  background:linear-gradient(100deg,rgba(0,229,255,.1),rgba(123,92,255,.1));border:1px solid rgba(0,229,255,.35);
  font-size:12.5px;color:var(--text);animation:rise .5s .3s both}
.hintbar .ic{color:var(--acid)}
.hintbar span{flex:1}
.hintbar button{color:var(--dim);width:26px;height:26px;display:grid;place-items:center;border-radius:7px}
.hintbar button:hover{color:var(--text);background:rgba(255,255,255,.06)}

/* ═══ КАЛЕНДАРЬ ═══ */
.weekrow{display:grid;grid-template-columns:repeat(7,1fr);gap:6px;margin-bottom:6px}
.weekrow span{font-family:var(--fm);font-size:10.5px;letter-spacing:.14em;color:var(--dim);text-align:center;padding:4px 0}
.weekrow span.we{color:var(--magenta)}
.grid{display:grid;grid-template-columns:repeat(7,1fr);gap:6px;user-select:none;-webkit-user-select:none}
@media(min-width:960px){.grid,.weekrow{gap:8px}}
.cell{position:relative;aspect-ratio:.94;min-height:52px;border-radius:12px;
  border:1px solid var(--line);background:var(--surface);transition:border-color .2s,box-shadow .2s,transform .15s}
.cell::before{content:"";position:absolute;inset:0;border-radius:11px;background:rgba(0,229,255,calc(var(--heat,0)*.30));transition:background .3s}
.cell:hover:not(.past):not(.other){transform:translateY(-2px);border-color:var(--line2);box-shadow:0 6px 18px rgba(0,0,0,.4)}
.cell.anim{animation:cellIn .4s cubic-bezier(.2,.9,.3,1.2) both}
@keyframes cellIn{from{opacity:0;transform:translateY(10px) scale(.92)}}
.cell .hit{position:absolute;inset:0;border-radius:12px;z-index:1}
.cell .hit:active:not(:disabled){transform:scale(.95)}
.cell .face{position:absolute;inset:0;padding:7px 8px;pointer-events:none;z-index:2;display:flex;flex-direction:column}
.cell .num{font-family:var(--fm);font-weight:700;font-size:15px;display:flex;align-items:center;gap:3px}
.cell .num .ic{color:var(--acid);fill:var(--acid)}
.cell .tr{position:absolute;top:7px;right:7px;display:grid;place-items:center}
.cell .tr .ic{width:13px;height:13px}
.cell .dots{position:absolute;left:8px;bottom:8px;display:flex;gap:3px}
.cell .dots i{width:6px;height:6px;border-radius:50%;box-shadow:0 0 6px currentColor}
.cell .meta{position:absolute;right:5px;bottom:5px;z-index:3;display:flex;align-items:center;gap:3px;
  font-family:var(--fm);font-size:11px;font-weight:700;color:var(--cyan);padding:3px 6px;border-radius:8px;
  background:rgba(5,8,16,.65);border:1px solid transparent;transition:.15s}
.cell .meta .ic{width:10px;height:10px}
.cell .meta:hover{border-color:var(--cyan);box-shadow:0 0 10px rgba(0,229,255,.35)}
.cell .meta.zero{color:var(--dim);font-weight:400}
.cell .meta.bump{animation:bump .35s cubic-bezier(.2,.9,.3,1.4)}
@keyframes bump{40%{transform:scale(1.35)}}
.cell .face.pop{animation:pop .3s cubic-bezier(.2,.9,.3,1.4)}
@keyframes pop{40%{transform:scale(1.06)}}
.cell.today{border-color:rgba(0,229,255,.55)}
.cell.today .num{color:var(--cyan)}
.cell.today .tr::after{content:"";width:6px;height:6px;border-radius:50%;background:var(--cyan);box-shadow:0 0 8px var(--cyan);animation:pulse 2s infinite}
.cell.mine{border-color:var(--cyan);box-shadow:0 0 14px rgba(0,229,255,.35),inset 0 0 14px rgba(0,229,255,.12)}
.cell.mine .tr{color:var(--acid)}
.cell.mine.today .tr::after{display:none}
.cell.topd{border-color:rgba(156,255,46,.6)}
.cell.locked{border-color:var(--magenta);box-shadow:0 0 16px rgba(255,46,126,.45);animation:lockGlow 2.4s infinite}
@keyframes lockGlow{50%{box-shadow:0 0 26px rgba(255,46,126,.7)}}
.cell.locked .tr{color:var(--magenta)}
.cell.past{opacity:.34}
.cell.past .meta{pointer-events:none}
.cell.other{opacity:.16;background:transparent;border-style:dashed}
.cell.other .meta,.cell.other .dots{display:none}
.legend{display:flex;flex-wrap:wrap;gap:6px 16px;margin-top:12px;font-family:var(--fm);font-size:10px;color:var(--dim);align-items:center}
.legend span{display:flex;align-items:center;gap:5px}
.lg{width:11px;height:11px;border-radius:4px;border:1px solid var(--cyan);box-shadow:0 0 6px rgba(0,229,255,.4)}
.lg.heat{border:0;background:linear-gradient(90deg,rgba(0,229,255,.08),rgba(0,229,255,.55));width:26px}
.legend .ic{width:11px;height:11px}
.legend .st{color:var(--acid);fill:var(--acid)}
.legend .lk{color:var(--magenta)}

/* ═══ ТОП ДАТ ═══ */
.bcontrols{display:flex;flex-wrap:wrap;gap:8px;align-items:center;margin:12px 0}
.seg{display:flex;background:var(--bg1);border:1px solid var(--line);border-radius:10px;padding:3px;gap:2px}
.seg button{font-family:var(--fm);font-size:11px;padding:6px 11px;border-radius:8px;color:var(--muted);transition:.15s}
.seg button.on{background:var(--grad);color:#041018;font-weight:700}
.seg button:not(.on):hover{color:var(--text)}
.sortbtn{display:flex;align-items:center;gap:6px;font-family:var(--fm);font-size:11px;color:var(--violet);
  border:1px solid rgba(123,92,255,.45);border-radius:10px;padding:8px 11px;transition:.2s}
.sortbtn:hover{box-shadow:0 0 12px rgba(123,92,255,.35);color:#B9A6FF}
.minstep{display:flex;align-items:center;gap:2px;margin-left:auto;font-family:var(--fm);font-size:11px;color:var(--muted);
  border:1px solid var(--line);border-radius:10px;padding:3px}
.minstep b{color:var(--amber);min-width:34px;text-align:center;font-weight:600}
.minstep button{width:26px;height:26px;display:grid;place-items:center;border-radius:7px;color:var(--cyan)}
.minstep button:hover:not(:disabled){background:rgba(0,229,255,.12)}
.minstep button:disabled{opacity:.25}
.blist{display:flex;flex-direction:column;gap:7px}
.lrow{display:grid;grid-template-columns:26px 92px 1fr auto;align-items:center;gap:10px;width:100%;text-align:left;
  padding:10px 12px;border-radius:12px;border:1px solid var(--line);background:rgba(10,16,36,.6);transition:.18s}
.lrow:hover{border-color:var(--line2);background:var(--surface2);transform:translateX(3px)}
.lrow .rank{font-family:var(--fm);font-weight:700;font-size:13px;color:var(--dim);display:flex;align-items:center;gap:2px}
.lrow.r1 .rank{color:var(--acid)}
.lrow.r1 .rank .ic{fill:var(--acid);width:12px;height:12px}
.lrow .ld{font-size:13px;min-width:0}
.lrow .ld b{font-family:var(--fm);font-size:11px;color:var(--cyan);margin-right:5px}
.lrow .ld.we b{color:var(--magenta)}
.lrow .ld .ic{width:11px;height:11px;color:var(--magenta);margin-left:4px}
.lrow .lbar{height:9px;border-radius:6px;background:var(--bg1);overflow:hidden;border:1px solid rgba(122,150,255,.12)}
.lrow .lbar i{display:block;height:100%;border-radius:6px;background:var(--grad);box-shadow:0 0 10px rgba(0,229,255,.5);transition:width .5s cubic-bezier(.2,.9,.3,1)}
.lrow.r1 .lbar i{background:linear-gradient(90deg,var(--acid),var(--cyan));box-shadow:0 0 10px rgba(156,255,46,.5)}
.lrow .lc{font-family:var(--fm);font-size:12px;font-weight:700;color:var(--text)}
.lrow .lc small{color:var(--dim);font-weight:400}
.empty{padding:26px 12px;text-align:center;color:var(--dim)}
.empty .ic{width:30px;height:30px;color:var(--violet);opacity:.7}
.empty p{font-size:13px;margin:8px 0 12px}
.empty button{font-family:var(--fm);font-size:12px;color:var(--cyan);border:1px dashed rgba(0,229,255,.5);padding:8px 16px;border-radius:10px}
.empty button:hover{background:rgba(0,229,255,.08)}

/* ═══ СКВАД ═══ */
.sqhead{display:flex;align-items:center;gap:8px}
.sqhead .cnt{font-family:var(--fm);font-size:12px;color:var(--acid);border:1px solid rgba(156,255,46,.4);border-radius:99px;padding:2px 9px}
.namehint{margin-left:auto;display:flex;align-items:center;gap:5px;font-family:var(--fm);font-size:10.5px;color:var(--amber);
  border:1px dashed rgba(255,176,32,.55);border-radius:99px;padding:5px 10px;animation:attnA 2s infinite}
@keyframes attnA{50%{box-shadow:0 0 12px rgba(255,176,32,.4)}}
.sqstrip{display:flex;gap:8px;overflow-x:auto;padding:12px 2px 6px;scrollbar-width:thin}
.sqchip{flex:none;display:flex;align-items:center;gap:8px;padding:6px 11px 6px 6px;border-radius:99px;
  border:1px solid var(--line);background:rgba(10,16,36,.7);transition:.18s}
.sqchip:hover{border-color:var(--line2);transform:translateY(-2px)}
.sqchip.me{border-color:rgba(0,229,255,.55);box-shadow:0 0 10px rgba(0,229,255,.2)}
.sqchip .nm{font-size:12.5px;font-weight:600;max-width:96px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.sqchip .vc{font-family:var(--fm);font-size:10.5px;color:var(--acid)}
.sqchip .ic{width:11px;height:11px;color:var(--amber)}
.av{position:relative;width:30px;height:30px;flex:none;border-radius:50%;display:grid;place-items:center;overflow:hidden;
  font-family:var(--fm);font-weight:700;font-size:11px;
  background:hsl(var(--h) 70% 16%);color:hsl(var(--h) 100% 72%);
  border:1.5px solid hsl(var(--h) 90% 55% / .75);box-shadow:0 0 9px hsl(var(--h) 90% 55% / .35)}
.av img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover}
.av.big{width:56px;height:56px;font-size:19px}
.clubcard{margin-top:14px;border-top:1px dashed var(--line);padding-top:14px}
.clubcard .cname{font-family:var(--fd);font-size:19px;letter-spacing:.05em;background:var(--grad);-webkit-background-clip:text;background-clip:text;color:transparent}
.clubcard .rows{display:flex;flex-direction:column;gap:7px;margin-top:10px}
.clubcard .rw{display:flex;align-items:center;gap:9px;font-size:13px;color:var(--muted)}
.clubcard .rw .ic{color:var(--violet);width:15px;height:15px}
.clubcard .rw b{color:var(--text);font-weight:600}
.clubcard .rw .rub{color:var(--amber);font-family:var(--fm);font-size:11.5px;margin-left:auto}
.sqbtns{display:flex;gap:8px;margin-top:14px}

/* ═══ КНОПКИ ═══ */
.btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;font-weight:700;font-size:13.5px;
  padding:11px 18px;border-radius:12px;transition:.18s;border:1px solid transparent}
.btn:active:not(:disabled){transform:scale(.96)}
.btn.pri{background:var(--grad);background-size:180% 100%;color:#041018;letter-spacing:.03em;
  box-shadow:0 6px 22px rgba(0,229,255,.3),0 6px 22px rgba(255,46,126,.2)}
.btn.pri:hover{background-position:90% 0;box-shadow:0 8px 28px rgba(0,229,255,.45),0 8px 28px rgba(255,46,126,.35)}
.btn.ghost{border-color:var(--line2);color:var(--muted);background:rgba(14,22,48,.6)}
.btn.ghost:hover{color:var(--cyan);border-color:var(--cyan)}
.btn.danger{border-color:rgba(255,77,94,.5);color:var(--red)}
.btn.danger:hover{background:rgba(255,77,94,.12);box-shadow:0 0 12px rgba(255,77,94,.25)}
.btn.acid{border-color:rgba(156,255,46,.55);color:var(--acid);background:rgba(156,255,46,.07)}
.btn.acid:hover{background:rgba(156,255,46,.16);box-shadow:0 0 14px rgba(156,255,46,.3)}
.btn.hot{background:var(--grad-hot);color:#1A0510;box-shadow:0 6px 20px rgba(255,46,126,.35)}
.btn.sm{padding:8px 13px;font-size:12px;border-radius:10px}
.btn:disabled{opacity:.35;box-shadow:none}
.btn.wide{width:100%}

/* ═══ НИЖНЯЯ ПАНЕЛЬ ═══ */
footer{position:fixed;left:0;right:0;bottom:0;z-index:35;
  background:rgba(6,9,18,.88);backdrop-filter:blur(14px);-webkit-backdrop-filter:blur(14px);
  border-top:1px solid var(--line);padding:10px 14px calc(10px + env(safe-area-inset-bottom))}
.fwrap{max-width:1140px;margin:0 auto}
.myrow{display:flex;align-items:center;gap:9px;margin-bottom:9px;min-height:30px}
.myrow .lbl{font-family:var(--fm);font-size:9.5px;letter-spacing:.24em;color:var(--dim);flex:none}
.mychips{display:flex;gap:6px;overflow-x:auto;scrollbar-width:none;padding:2px}
.mychips::-webkit-scrollbar{display:none}
.mychip{flex:none;font-family:var(--fm);font-size:11.5px;font-weight:600;color:var(--cyan);
  border:1px solid rgba(0,229,255,.5);background:rgba(0,229,255,.08);border-radius:99px;padding:5px 11px;transition:.15s;animation:chipIn .3s cubic-bezier(.2,.9,.3,1.3) both}
@keyframes chipIn{from{opacity:0;transform:scale(.6)}}
.mychip:hover{background:rgba(0,229,255,.2);box-shadow:0 0 10px rgba(0,229,255,.3)}
.myrow .none{font-size:12.5px;color:var(--dim);font-style:italic}
.btnrow{display:flex;gap:9px}
.btnrow .pri{flex:1;font-family:var(--fd);font-weight:400;letter-spacing:.06em;font-size:14px}

/* ═══ ШТОРКА ═══ */
#scrim{position:fixed;inset:0;z-index:45;background:rgba(3,5,10,.72);backdrop-filter:blur(5px);-webkit-backdrop-filter:blur(5px);
  opacity:0;transition:opacity .25s}
#scrim.show{opacity:1}
#drawer{position:fixed;left:50%;bottom:0;z-index:50;width:min(560px,100%);max-height:min(84dvh,calc(var(--tg-vh) - 20px));
  transform:translate(-50%,105%);transition:transform .32s cubic-bezier(.2,.9,.25,1);
  background:linear-gradient(170deg,#131D3E,#0A1128);border:1px solid var(--line2);border-bottom:0;
  border-radius:22px 22px 0 0;box-shadow:0 -18px 60px rgba(0,0,0,.6),0 0 40px rgba(0,229,255,.08);
  display:flex;flex-direction:column}
#drawer.show{transform:translate(-50%,0)}
.grab{flex:none;padding:10px 0 4px;display:grid;place-items:center;cursor:grab;touch-action:none}
.grab i{width:44px;height:4.5px;border-radius:4px;background:var(--line2)}
.dhead{flex:none;display:flex;align-items:center;gap:10px;padding:4px 18px 12px;border-bottom:1px solid var(--line)}
.dhead h3{font-family:var(--fd);font-weight:400;font-size:17px;letter-spacing:.05em;flex:1;min-width:0}
.dhead .x{width:34px;height:34px;flex:none;display:grid;place-items:center;border-radius:10px;border:1px solid var(--line);color:var(--muted)}
.dhead .x:hover{color:var(--red);border-color:rgba(255,77,94,.5)}
.dbody{overflow-y:auto;padding:16px 18px calc(20px + env(safe-area-inset-bottom));overscroll-behavior:contain}
.dbody::-webkit-scrollbar{width:8px}
.dbody::-webkit-scrollbar-thumb{border-width:1px}

/* содержимое шторок */
.dd-date{font-family:var(--fd);font-size:clamp(22px,6vw,27px);background:var(--grad);-webkit-background-clip:text;background-clip:text;color:transparent}
.dd-date.hot{background:var(--grad-hot);-webkit-background-clip:text;background-clip:text}
.dd-ratio{font-family:var(--fm);font-size:12px;color:var(--muted);margin:4px 0 14px}
.dd-ratio b{color:var(--acid)}
.dd-toggle{width:100%;margin-bottom:16px}
.dd-toggle.on{background:rgba(0,229,255,.1);border-color:var(--cyan);color:var(--cyan);box-shadow:0 0 14px rgba(0,229,255,.25)}
.dd-sec{font-family:var(--fm);font-size:10px;letter-spacing:.26em;color:var(--dim);margin:14px 0 8px;display:flex;align-items:center;gap:7px}
.dd-sec b{color:var(--cyan);letter-spacing:0;font-size:11px}
.crew{display:flex;flex-wrap:wrap;gap:7px}
.crewchip{display:flex;align-items:center;gap:7px;padding:5px 12px 5px 5px;border-radius:99px;border:1px solid var(--line);background:rgba(10,16,36,.7);font-size:12.5px;font-weight:600}
.crewchip .av{width:24px;height:24px;font-size:9px}
.crewchip.mute{opacity:.5;font-weight:400}
.crewchip.me{border-color:rgba(0,229,255,.5)}
.dd-actions{display:flex;flex-direction:column;gap:9px;margin-top:18px}
.frow{margin-bottom:14px}
.frow label{display:block;font-family:var(--fm);font-size:10px;letter-spacing:.22em;color:var(--dim);margin-bottom:6px;text-transform:uppercase}
.frow input[type=text],.frow input[type=url],.frow input[type=time],.frow textarea{
  width:100%;background:var(--bg1);border:1px solid var(--line2);border-radius:11px;padding:11px 13px;font-size:14px;transition:.15s}
.frow input:focus,.frow textarea:focus{outline:none;border-color:var(--cyan);box-shadow:0 0 12px rgba(0,229,255,.2)}
.frow textarea{min-height:96px;font-family:var(--fm);font-size:11px;resize:vertical}
.frow .hint{font-size:11px;color:var(--dim);margin-top:5px}
.steprow{display:flex;align-items:center;justify-content:space-between;gap:10px;background:var(--bg1);border:1px solid var(--line);border-radius:11px;padding:8px 10px;margin-bottom:10px}
.steprow .sl{font-size:13px;color:var(--muted);display:flex;align-items:center;gap:8px}
.steprow .sl .ic{color:var(--violet);width:15px;height:15px}
.steprow .sc{display:flex;align-items:center;gap:4px}
.steprow .sc b{font-family:var(--fm);font-size:15px;min-width:52px;text-align:center;color:var(--text)}
.steprow .sc button{width:32px;height:32px;display:grid;place-items:center;border-radius:9px;border:1px solid var(--line2);color:var(--cyan);transition:.15s}
.steprow .sc button:hover:not(:disabled){background:rgba(0,229,255,.12);box-shadow:0 0 8px rgba(0,229,255,.3)}
.steprow .sc button:disabled{opacity:.25}
.inline2{display:flex;gap:8px}
.inline2 .frow{flex:1}
.linkline{display:flex;gap:8px;align-items:center}
.linkline input{flex:1}
.dsect{font-family:var(--fm);font-size:10px;letter-spacing:.26em;color:var(--violet);margin:20px 0 10px;display:flex;align-items:center;gap:8px}
.dsect::after{content:"";flex:1;height:1px;background:var(--line)}
.micro{font-size:11px;color:var(--dim);line-height:1.55;margin-top:14px;border-left:2px solid var(--line2);padding-left:10px}
.searchbox{position:relative;margin-bottom:12px}
.searchbox .ic{position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--dim);width:15px;height:15px}
.searchbox input{width:100%;background:var(--bg1);border:1px solid var(--line2);border-radius:11px;padding:11px 13px 11px 36px;font-size:14px}
.searchbox input:focus{outline:none;border-color:var(--cyan)}
.rlist{display:flex;flex-direction:column;gap:7px}
.rrow{display:flex;align-items:center;gap:10px;padding:8px 10px;border-radius:12px;border:1px solid var(--line);background:rgba(10,16,36,.6)}
.rrow .nm{flex:1;min-width:0;font-size:13.5px;font-weight:600;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.rrow .nm em{font-style:normal;font-family:var(--fm);font-size:9px;color:#041018;background:var(--cyan);border-radius:5px;padding:2px 6px;margin-left:7px;vertical-align:2px}
.rrow .vc{font-family:var(--fm);font-size:11px;color:var(--acid);flex:none}
.rrow .act{width:32px;height:32px;flex:none;display:grid;place-items:center;border-radius:9px;color:var(--dim);transition:.15s}
.rrow .act:hover{color:var(--red);background:rgba(255,77,94,.12)}
.rrow .act.pen:hover{color:var(--amber);background:rgba(255,176,32,.12)}
.addrow{display:flex;gap:8px;margin-top:12px}
.addrow input{flex:1;background:var(--bg1);border:1px solid var(--line2);border-radius:11px;padding:10px 13px;font-size:13.5px}
.addrow input:focus{outline:none;border-color:var(--acid)}
.addrow input.shake{animation:shake .35s}
@keyframes shake{20%,60%{transform:translateX(-5px)}40%,80%{transform:translateX(5px)}}
.hues{display:flex;gap:9px;flex-wrap:wrap}
.hue{width:38px;height:38px;border-radius:50%;border:2px solid transparent;transition:.15s;position:relative;
  background:hsl(var(--h) 70% 16%);box-shadow:inset 0 0 0 2px hsl(var(--h) 90% 55% / .8),0 0 10px hsl(var(--h) 90% 55% / .3)}
.hue::after{content:"";position:absolute;inset:9px;border-radius:50%;background:hsl(var(--h) 100% 65%)}
.hue:hover{transform:scale(1.12)}
.hue.on{border-color:var(--text);transform:scale(1.12)}
.pf-preview{display:flex;align-items:center;gap:14px;margin-bottom:16px}
.pf-preview .pfn{font-family:var(--fd);font-size:18px;letter-spacing:.04em}
.pf-preview .pfs{font-family:var(--fm);font-size:11px;color:var(--dim)}

/* ═══ ТОСТЫ ═══ */
#toasts{position:fixed;left:50%;transform:translateX(-50%);bottom:calc(var(--footH) + 12px);z-index:70;
  width:min(480px,calc(100% - 24px));display:flex;flex-direction:column;gap:8px;pointer-events:none}
.toast{pointer-events:auto;position:relative;overflow:hidden;display:flex;align-items:center;gap:10px;
  background:linear-gradient(120deg,#16224A,#1B1240);border:1px solid var(--line2);border-radius:13px;
  padding:12px 14px;font-size:13px;font-weight:600;box-shadow:0 10px 30px rgba(0,0,0,.5);
  animation:toastIn .3s cubic-bezier(.2,.9,.3,1.2) both}
@keyframes toastIn{from{opacity:0;transform:translateY(14px) scale(.95)}}
.toast.out{animation:toastOut .25s both}
@keyframes toastOut{to{opacity:0;transform:translateY(10px) scale(.95)}}
.toast span{flex:1}
.toast .ic{color:var(--acid);width:16px;height:16px}
.toast.warn .ic{color:var(--amber)}
.toast button{flex:none;font-family:var(--fm);font-size:11.5px;font-weight:700;color:var(--acid);
  border:1px solid rgba(156,255,46,.55);border-radius:9px;padding:6px 12px;transition:.15s}
.toast button:hover{background:rgba(156,255,46,.15);box-shadow:0 0 10px rgba(156,255,46,.3)}
.tprog{position:absolute;left:0;bottom:0;height:2.5px;background:var(--grad);width:100%;animation:tprog linear both;animation-duration:var(--dur)}
@keyframes tprog{to{width:0}}

@media(max-width:370px){
  .cell{min-height:46px}.cell .num{font-size:13px}.cell .meta{font-size:10px;padding:2px 5px}
  .lrow{grid-template-columns:20px 80px 1fr auto;gap:7px}
}
@media(prefers-reduced-motion:reduce){
  *,*::before,*::after{animation-duration:.001s !important;animation-iteration-count:1 !important;transition-duration:.001s !important}
}
</style>
</head>
<body>

<div class="bg" aria-hidden="true">
  <div class="base"></div>
  <div class="blob b1"></div><div class="blob b2"></div><div class="blob b3"></div>
  <div class="floor"></div><div class="horizon"></div>
  <div class="scan"></div><div class="grain"></div><div class="vig"></div>
</div>
<canvas id="fx" aria-hidden="true"></canvas>

<header>
  <div class="hwrap">
    <div class="logo">
      <span class="cube" id="logoIc"></span>
      <div><b>PC <i>CLUB</i></b><small>сбор на катку</small></div>
    </div>
    <div class="hspace"></div>
    <button class="chatchip" id="chatChip" data-action="open-settings" title="Данные привязаны к этому чату"></button>
    <button class="hbtn" id="sndBtn" data-action="sound-toggle" aria-pressed="true" aria-label="Звук"></button>
    <button class="hbtn" data-action="open-settings" aria-label="Настройки сбора" id="gearBtn"></button>
  </div>
</header>

<main>
  <div class="colL">
    <section id="lockSlot" class="rise"></section>

    <section class="card rise" style="animation-delay:.06s">
      <div class="monthbar">
        <button class="mnav" id="btnPrev" data-action="prev-month" aria-label="Предыдущий месяц"></button>
        <div class="mtitle">
          <h1 id="monthTitle"></h1>
          <div class="mstats" id="monthStats"></div>
        </div>
        <button class="mnav" id="btnNext" data-action="next-month" aria-label="Следующий месяц"></button>
      </div>
      <div id="todaySlot"></div>
      <div id="hintSlot"></div>
      <div class="weekrow" aria-hidden="true">
        <span>ПН</span><span>ВТ</span><span>СР</span><span>ЧТ</span><span>ПТ</span><span class="we">СБ</span><span class="we">ВС</span>
      </div>
      <div class="grid" id="grid" role="grid" aria-label="Календарь месяца"></div>
      <div class="legend">
        <span><i class="lg"></i>ты можешь</span>
        <span id="lgStar"></span>
        <span id="lgLock"></span>
        <span><i class="lg heat"></i>больше народа</span>
        <span style="margin-left:auto">тап — голос · счётчик / долгий тап — детали</span>
      </div>
    </section>
  </div>

  <div class="colR">
    <section class="card rise" style="animation-delay:.12s">
      <h2 id="boardTitle"></h2>
      <div class="sub">куда сходится сквад в этом месяце</div>
      <div class="bcontrols">
        <div class="seg" id="fchips" role="group" aria-label="Фильтр дней">
          <button data-action="filter" data-f="all">ВСЕ</button>
          <button data-action="filter" data-f="we">ВЫХОДНЫЕ</button>
          <button data-action="filter" data-f="wd">БУДНИ</button>
        </div>
        <button class="sortbtn" data-action="sort-toggle" id="sortBtn"></button>
        <div class="minstep" aria-label="Минимум игроков">
          <button data-action="min-step" data-d="-1" id="minMinus" aria-label="Меньше"></button>
          <b id="minVal"></b>
          <button data-action="min-step" data-d="1" id="minPlus" aria-label="Больше"></button>
        </div>
      </div>
      <div class="blist" id="boardList"></div>
    </section>

    <section class="card rise" style="animation-delay:.18s">
      <div class="sqhead">
        <h2 id="squadTitle"></h2>
        <span class="cnt" id="squadCount"></span>
        <span id="nameHintSlot"></span>
      </div>
      <div class="sqstrip" id="squadStrip"></div>
      <div class="clubcard" id="clubCard"></div>
      <div class="sqbtns">
        <button class="btn ghost sm" data-action="open-roster" id="rosterBtn" style="flex:1"></button>
        <button class="btn ghost sm" data-action="open-settings" style="flex:1" id="settBtn"></button>
      </div>
    </section>
  </div>
</main>

<footer>
  <div class="fwrap">
    <div class="myrow">
      <span class="lbl" id="myLabel">ТВОИ ДАТЫ</span>
      <div class="mychips" id="myChips"></div>
    </div>
    <div class="btnrow">
      <button class="btn danger" data-action="clear-mine" id="clearBtn"></button>
      <button class="btn pri" data-action="share" id="shareBtn"></button>
    </div>
  </div>
</footer>

<div id="scrim" hidden data-action="close-drawer"></div>
<section id="drawer" role="dialog" aria-modal="true" aria-label="Панель деталей" hidden>
  <div class="grab" id="grab"><i></i></div>
  <div class="dhead"><h3 id="drawerTitle"></h3><button class="x" data-action="close-drawer" aria-label="Закрыть" id="drawerX"></button></div>
  <div class="dbody" id="drawerBody"></div>
</section>
<div id="toasts" aria-live="polite"></div>
<noscript><p style="padding:100px 20px;text-align:center">Для сбора на катку нужен включённый JavaScript.</p></noscript>

<script>
'use strict';
/* ═════════ УТИЛИТЫ ═════════ */
const $=s=>document.querySelector(s);
const esc=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const pad=n=>String(n).padStart(2,'0');
const dkey=(y,m,d)=>`${y}-${pad(m+1)}-${pad(d)}`;
const pkey=k=>{const[a,b,c]=k.split('-').map(Number);return{y:a,m:b-1,d:c}};
const now0=()=>new Date();
const todayKey=()=>{const n=now0();return dkey(n.getFullYear(),n.getMonth(),n.getDate())};
const MONTHS=['Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'];
const MGEN=['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря'];
const MSHORT=['янв','фев','мар','апр','мая','июн','июл','авг','сен','окт','ноя','дек'];
const WD=['ПН','ВТ','СР','ЧТ','ПТ','СБ','ВС'];
const wdi=k=>{const{y,m,d}=pkey(k);return(new Date(y,m,d).getDay()+6)%7};
const isWE=k=>wdi(k)>=5;
const plural=(n,a,b,c)=>{const m=n%100;if(m>10&&m<20)return c;const l=n%10;return l===1?a:l>1&&l<5?b:c};
const fmtShort=k=>{const{m,d}=pkey(k);return`${d} ${MSHORT[m]}`};
const fmtFull=k=>{const{m,d}=pkey(k);return`${WD[wdi(k)]}, ${d} ${MGEN[m]}`};
function hash(s){let h=2166136261;for(let i=0;i<s.length;i++){h^=s.charCodeAt(i);h=Math.imul(h,16777619)}return h>>>0}
function mulberry32(a){return()=>{a|=0;a=a+0x6D2B79F5|0;let t=Math.imul(a^a>>>15,1|a);t=t+Math.imul(t^t>>>7,61|t)^t;return((t^t>>>14)>>>0)/4294967296}}

/* ═════════ ИКОНКИ ═════════ */
const I={
gamepad:'<path d="M6.5 9.5h4M8.5 7.5v4M15 8.6h.01M17.8 10.6h.01M17.2 5.5H6.8a4.6 4.6 0 0 0-4.5 3.8L1.2 15.5a2.5 2.5 0 0 0 4.4 2L7.6 15h8.8l2 2.5a2.5 2.5 0 0 0 4.4-2l-1.1-6.2a4.6 4.6 0 0 0-4.5-3.8Z"/>',
chevL:'<path d="m14 6-6 6 6 6"/>',chevR:'<path d="m10 6 6 6-6 6"/>',
x:'<path d="M6 6l12 12M18 6 6 18"/>',
sliders:'<path d="M4 7h9M17 7h3M4 17h3M11 17h9M13 4v6M7 14v6"/>',
users:'<circle cx="9" cy="8.5" r="3.4"/><path d="M2.6 20a6.4 6.4 0 0 1 12.8 0M15.8 5.7a3.4 3.4 0 0 1 0 5.6M21.4 20a6.4 6.4 0 0 0-4.3-6"/>',
user:'<circle cx="12" cy="8" r="3.5"/><path d="M5 20a7 7 0 0 1 14 0"/>',
share:'<path d="M12 3v12M7.5 7.5 12 3l4.5 4.5M5 13v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-6"/>',
sndOn:'<path d="M4 9.5v5h3.5l5 4v-13l-5 4H4Z"/><path d="M16.3 8.7a4.6 4.6 0 0 1 0 6.6M19 6.2a8.2 8.2 0 0 1 0 11.6"/>',
sndOff:'<path d="M4 9.5v5h3.5l5 4v-13l-5 4H4Z"/><path d="m16.5 9.5 5 5M21.5 9.5l-5 5"/>',
lock:'<rect x="5" y="10.5" width="14" height="9.5" rx="2.5"/><path d="M8 10.5V7.5a4 4 0 0 1 8 0v3"/>',
unlock:'<rect x="5" y="10.5" width="14" height="9.5" rx="2.5"/><path d="M8 10.5V7.5a4 4 0 0 1 7.7-1.4"/>',
star:'<path d="m12 3 2.6 5.5 6 .8-4.4 4.1 1.1 5.9L12 16.4l-5.3 2.9 1.1-5.9L3.4 9.3l6-.8L12 3Z"/>',
check:'<path d="m5 12.5 4.5 4.5L19 7"/>',
plus:'<path d="M12 5v14M5 12h14"/>',minus:'<path d="M5 12h14"/>',
trash:'<path d="M4 7h16M9.5 7V4.5h5V7M6.5 7l1 13.5h9l1-13.5M10 11v6M14 11v6"/>',
copy:'<rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>',
search:'<circle cx="11" cy="11" r="6.5"/><path d="m20 20-3.8-3.8"/>',
zap:'<path d="M13 2 4.5 13.5H11L10 22l8.5-11.5H12L13 2Z"/>',
pen:'<path d="m4 20 1-4L16.5 4.5a2.12 2.12 0 0 1 3 3L8 19l-4 1Z"/>',
clock:'<circle cx="12" cy="12" r="8.5"/><path d="M12 7v5l3.5 2"/>',
monitor:'<rect x="3" y="4.5" width="18" height="12" rx="2"/><path d="M9 20.5h6M12 16.5v4"/>',
card:'<rect x="3" y="6" width="18" height="13" rx="2.5"/><path d="M3 10h18M7 15h4"/>',
sort:'<path d="M8 5v14m0 0-3.5-3.5M8 19l3.5-3.5M16 19V5m0 0-3.5 3.5M16 5l3.5 3.5"/>',
down:'<path d="M12 4v11m0 0 4.5-4.5M12 15l-4.5-4.5M4 19h16"/>',
up:'<path d="M12 19V8m0 0 4.5 4.5M12 8 7.5 12.5M4 4h16"/>',
cal:'<rect x="3.5" y="5" width="17" height="16" rx="2.5"/><path d="M3.5 10h17M8 2.8V7M16 2.8V7"/>',
link:'<path d="M10 14a5 5 0 0 0 7.1 0l2.4-2.4a5 5 0 0 0-7.1-7.1L11 5.9M14 10a5 5 0 0 0-7.1 0l-2.4 2.4a5 5 0 0 0 7.1 7.1L13 14.1"/>'
};
const ic=(n,s=18)=>`<svg class="ic" width="${s}" height="${s}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${I[n]||''}</svg>`;

/* ═════════ TELEGRAM / ЧАТ ═════════ */
const tg=window.Telegram&&window.Telegram.WebApp?window.Telegram.WebApp:null;
const isTG=!!(tg&&tg.initData&&tg.initData.length>0);
const tgu=isTG&&tg.initDataUnsafe&&tg.initDataUnsafe.user?tg.initDataUnsafe.user:null;
const sanitizeCode=s=>{const c=String(s||'').toLowerCase().replace(/[^a-z0-9_-]/g,'').slice(0,32);return c||'local'};
let chatKey=sanitizeCode((isTG&&tg.initDataUnsafe.start_param)||(isTG&&tg.initDataUnsafe.chat_instance?'ci'+tg.initDataUnsafe.chat_instance:'local'));
const chatTitle=isTG&&tg.initDataUnsafe.chat&&tg.initDataUnsafe.chat.title?tg.initDataUnsafe.chat.title:null;
let storeKey='pcc.v1:'+chatKey;
const myId=tgu?'tg'+tgu.id:'me_local';

/* ═════════ ХРАНИЛИЩЕ ═════════ */
let memWarned=false;
function load(){try{const raw=localStorage.getItem(storeKey);if(!raw)return null;const s=JSON.parse(raw);return s&&s.v===1&&Array.isArray(s.members)?s:null}catch(e){return null}}
function save(){state.rev=Date.now();try{localStorage.setItem(storeKey,JSON.stringify(state))}catch(e){if(!memWarned){memWarned=true;toast('Хранилище недоступно — данные живут до закрытия вкладки','warn')}}}
let saveT=null;const saveSoon=()=>{clearTimeout(saveT);saveT=setTimeout(save,220)};

/* ═════════ СИД ═════════ */
function seed(key){
  const rng=mulberry32(hash(key));
  const defs=[['KiberKot',190,.95],['Nova',320,.8],['TimurLAG',45,.7],['Gleb360',130,.85],['Sanek_Tank',265,.6],['Masha_MVP',15,.75]];
  const members=defs.map(([name,hue,act],i)=>({id:'s'+i,name,hue,votes:{}}));
  const tk=todayKey(),n=now0();
  for(let off=0;off<2;off++){
    const b=new Date(n.getFullYear(),n.getMonth()+off,1),y=b.getFullYear(),m=b.getMonth(),dim=new Date(y,m+1,0).getDate();
    for(let d=1;d<=dim;d++){
      const k=dkey(y,m,d);if(k<tk)continue;
      const wd=new Date(y,m,d).getDay(),p=wd===6?.82:wd===5?.74:wd===0?.55:.26;
      members.forEach(mm=>{if(rng()<p*(.55+rng()*.45))mm.votes[k]=1});
    }
  }
  let y=n.getFullYear(),m=n.getMonth(),dim=new Date(y,m+1,0).getDate();
  let sat=1+((6-new Date(y,m,1).getDay())+7)%7+7;
  while(sat<=dim&&dkey(y,m,sat)<tk)sat+=7;
  if(sat>dim){const b=new Date(y,m+1,1);y=b.getFullYear();m=b.getMonth();dim=new Date(y,m+1,0).getDate();sat=1+((6-new Date(y,m,1).getDay())+7)%7;if(dkey(y,m,sat)<tk)sat+=7}
  const topK=dkey(y,m,Math.min(sat,dim));
  members.slice(0,5).forEach(mm=>mm.votes[topK]=1);
  const counts={};members.forEach(mm=>Object.keys(mm.votes).forEach(k=>counts[k]=(counts[k]||0)+1));
  Object.keys(counts).forEach(k=>{if(k!==topK&&counts[k]>4){for(let i=members.length-1;i>=0&&counts[k]>4;i--){if(members[i].votes[k]){delete members[i].votes[k];counts[k]--}}}});
  return{v:1,key,settings:{club:'NEON ARENA',time:'19:00',hours:3,pcs:10,price:150,appLink:''},members,locked:null,meId:null,meName:null,flags:{hinted:false}};
}
let state=load()||seed(chatKey);
function ensureMe(){
  let m=state.members.find(x=>x.id===myId);
  if(!m){m={id:myId,name:tgu?([tgu.first_name,tgu.last_name].filter(Boolean).join(' ')||tgu.username||'Игрок'):(state.meName||'Игрок'),hue:205,votes:{},photo:tgu&&tgu.photo_url||null,tg:!!tgu};state.members.push(m)}
  else if(tgu){m.photo=tgu.photo_url||m.photo;m.tg=true}
  state.meId=myId;save();
}
ensureMe();
const me=()=>state.members.find(x=>x.id===state.meId)||state.members[0];
const total=()=>state.members.length;
const votersOn=k=>state.members.filter(m=>m.votes[k]);
const countOn=k=>votersOn(k).length;
const mprefix=(y,m)=>`${y}-${pad(m+1)}`;
function monthStats(y,m){
  const pref=mprefix(y,m),map={},tk=todayKey();let all=0;
  state.members.forEach(mm=>Object.keys(mm.votes).forEach(k=>{if(k.startsWith(pref)){map[k]=(map[k]||0)+1;all++}}));
  const future=Object.keys(map).filter(k=>k>=tk).sort();
  let top=null,best=0;future.forEach(k=>{if(map[k]>best){best=map[k];top=k}});
  return{map,future,top,best,all};
}
const myMonthKeys=(y,m)=>{const p=mprefix(y,m),tk=todayKey();return Object.keys(me().votes).filter(k=>k.startsWith(p)&&k>=tk).sort()};

/* ═════════ RUNTIME ═════════ */
const n0=now0();
const rt={y:n0.getFullYear(),m:n0.getMonth(),filter:'all',sort:'votes',min:1,q:'',drawer:null,pendingCode:'',lp:false,prevBars:{},lastFocus:null,drag:null};
const undoMap=new Map();let toastSeq=0;

/* ═════════ ЗВУК ═════════ */
const SFX={ctx:null,master:null,on:(()=>{try{return localStorage.getItem('pcc.snd')!=='0'}catch(e){return true}})(),
  ensure(){if(!this.ctx){const AC=window.AudioContext||window.webkitAudioContext;if(!AC)return false;this.ctx=new AC();this.master=this.ctx.createGain();this.master.gain.value=.9;this.master.connect(this.ctx.destination)}if(this.ctx.state==='suspended')this.ctx.resume();return true},
  tone(f,d,type,g,t,f2){const c=this.ctx,o=c.createOscillator(),v=c.createGain(),t0=c.currentTime+(t||0);o.type=type;o.frequency.setValueAtTime(f,t0);if(f2)o.frequency.exponentialRampToValueAtTime(f2,t0+d);v.gain.setValueAtTime(.0001,t0);v.gain.linearRampToValueAtTime(g,t0+.01);v.gain.exponentialRampToValueAtTime(.0001,t0+d);o.connect(v);v.connect(this.master);o.start(t0);o.stop(t0+d+.03)},
  play(name,arg){if(!this.on)return;try{if(!this.ensure())return;
    switch(name){
      case'on':this.tone(480+(arg||0)*55,.1,'square',.055,0,860+(arg||0)*55);break;
      case'off':this.tone(430,.1,'square',.045,0,240);break;
      case'open':this.tone(290,.13,'sine',.05,0,540);break;
      case'close':this.tone(520,.11,'sine',.04,0,280);break;
      case'lock':[523,659,784,1046].forEach((f,i)=>this.tone(f,.14,'triangle',.06,i*.07));break;
      case'unlock':this.tone(784,.12,'triangle',.05);this.tone(523,.14,'triangle',.05,.09);break;
      case'error':this.tone(140,.2,'sawtooth',.06);break;
      case'share':this.tone(660,.1,'triangle',.055);this.tone(990,.14,'triangle',.055,.09);break;
      case'add':this.tone(700,.09,'triangle',.05);this.tone(1050,.12,'triangle',.05,.07);break;
    }}catch(e){}}
};
function haptic(k){try{if(!tg||!tg.HapticFeedback)return;if(k==='ok'||k==='err'||k==='warn')tg.HapticFeedback.notificationOccurred(k==='ok'?'success':k==='err'?'error':'warning');else tg.HapticFeedback.impactOccurred(k||'light')}catch(e){}}

/* ═════════ КОНФЕТТИ ═════════ */
const FX={cv:$('#fx'),ctx:null,parts:[],running:false,raf:0,
  resize(){const dpr=Math.min(2,window.devicePixelRatio||1);this.cv.width=innerWidth*dpr;this.cv.height=innerHeight*dpr;this.cv.style.width=innerWidth+'px';this.cv.style.height=innerHeight+'px';this.ctx=this.cv.getContext('2d');this.ctx.setTransform(dpr,0,0,dpr,0,0)},
  burst(x,y){const cols=['#00E5FF','#FF2E7E','#9CFF2E','#FFB020','#7B5CFF','#EAF2FF'];
    for(let i=0;i<90;i++){const a=Math.random()*Math.PI*2,sp=2+Math.random()*6;this.parts.push({x,y,vx:Math.cos(a)*sp,vy:Math.sin(a)*sp-5,g:.22,r:Math.random()*Math.PI,vr:(Math.random()-.5)*.3,s:3.5+Math.random()*5,c:cols[i%cols.length],life:60+Math.random()*45})}
    if(!this.running){this.running=true;this.raf=requestAnimationFrame(()=>this.tick())}},
  tick(){const c=this.ctx;if(!c){this.running=false;return}c.clearRect(0,0,innerWidth,innerHeight);
    this.parts=this.parts.filter(p=>p.life>0&&p.y<innerHeight+30);
    this.parts.forEach(p=>{p.x+=p.vx;p.y+=p.vy;p.vy+=p.g;p.vx*=.985;p.r+=p.vr;p.life--;c.save();c.translate(p.x,p.y);c.rotate(p.r);c.globalAlpha=Math.min(1,p.life/28);c.fillStyle=p.c;c.fillRect(-p.s/2,-p.s/2,p.s,p.s*.62);c.restore()});
    if(this.parts.length){this.raf=requestAnimationFrame(()=>this.tick())}else{this.running=false;c.clearRect(0,0,innerWidth,innerHeight)}}
};
FX.resize();

/* ═════════ ТОСТЫ / UNDO ═════════ */
function toast(msg,kind,undoSnap){
  const box=$('#toasts');while(box.children.length>=3)box.firstChild.remove();
  const id='u'+(++toastSeq),ms=undoSnap?6000:3200;
  if(undoSnap)undoMap.set(id,undoSnap);
  const el=document.createElement('div');el.className='toast'+(kind==='warn'?' warn':'');el.style.setProperty('--dur',ms+'ms');
  el.innerHTML=`${ic(kind==='warn'?'zap':'check',16)}<span>${esc(msg)}</span>${undoSnap?`<button data-action="undo" data-uid="${id}">Отменить</button>`:''}<i class="tprog"></i>`;
  box.appendChild(el);
  const kill=()=>{if(!el.isConnected)return;el.classList.add('out');setTimeout(()=>el.remove(),240);undoMap.delete(id)};
  el._kill=kill;el._t=setTimeout(kill,ms);
}
const snap=()=>JSON.parse(JSON.stringify(state));
function doUndo(uid){const s=undoMap.get(uid);if(!s)return;state=s;save();renderAll();toast('Действие отменено');haptic('light')}

/* ═════════ БУФЕР / ССЫЛКИ ═════════ */
async function copyText(t){try{await navigator.clipboard.writeText(t);return true}catch(e){try{const ta=document.createElement('textarea');ta.value=t;ta.style.cssText='position:fixed;opacity:0';document.body.appendChild(ta);ta.select();const ok=document.execCommand('copy');ta.remove();return ok}catch(e2){return false}}}
function buildLink(){
  let u=(state.settings.appLink||'').trim();if(!u)return'';
  if(/^t\.me\//i.test(u))u='https://'+u;else if(!/^https?:\/\//i.test(u))u='https://'+u;
  try{new URL(u)}catch(e){return''}
  return u+(u.includes('?')?'&':'?')+'startapp='+encodeURIComponent(chatKey);
}
function shareText(){
  const s=state.settings,st=monthStats(rt.y,rt.m),tk=todayKey();
  const my=Object.keys(me().votes).filter(k=>k>=tk).sort();
  const lines=['🎮 СБОР НА КАТКУ — '+s.club];
  if(state.locked){const L=state.locked;lines.push(`🔒 Зафиксировано: ${fmtFull(L.date)} · ${s.time} · ${countOn(L.date)}/${total()} идут`)}
  else if(st.top)lines.push(`🏆 Топ-дата: ${fmtFull(st.top)} — могут ${st.best}/${total()}`);
  lines.push(`🕖 ${s.time} · ${s.hours} ч · ${s.pcs} ПК · ${s.club}`);
  if(my.length)lines.push('✅ Я могу: '+my.slice(0,8).map(fmtShort).join(', ')+(my.length>8?` и ещё ${my.length-8}`:''));
  lines.push(`👥 Сквад: ${total()} ${plural(total(),'игрок','игрока','игроков')}`);
  const link=buildLink();if(link)lines.push('👉 Открыть сбор: '+link);
  return lines.join('\n');
}
async function doShare(){
  SFX.play('share');haptic('ok');
  const text=shareText(),link=buildLink();
  if(isTG){try{tg.openTelegramLink('https://t.me/share/url?url='+encodeURIComponent(link||'https://t.me')+'&text='+encodeURIComponent(text));toast('Открываю отправку в чат…');return}catch(e){}}
  const ok=await copyText(text);
  toast(ok?'Сводка скопирована — кинь её в чат':'Не удалось скопировать',ok?null:'warn');
}

/* ═════════ АВАТАРЫ ═════════ */
function initials(name){const p=String(name||'?').trim().split(/[\s_]+/);return((p[0]?.[0]||'?')+(p[1]?.[0]||'')).toUpperCase()}
const avatar=(m,cls='')=>`<span class="av ${cls}" style="--h:${m.hue}">${esc(initials(m.name))}${m.photo?`<img src="${esc(m.photo)}" alt="" onerror="this.remove()">`:''}</span>`;
const dot=m=>`<i style="background:hsl(${m.hue} 95% 62%);color:hsl(${m.hue} 95% 62%)"></i>`;

/* ═════════ РЕНДЕР ═════════ */
function renderHeader(){
  $('#logoIc').innerHTML=ic('gamepad',20);
  $('#gearBtn').innerHTML=ic('sliders',18);
  $('#sndBtn').innerHTML=ic(SFX.on?'sndOn':'sndOff',18);
  $('#sndBtn').setAttribute('aria-pressed',String(SFX.on));
  $('#sndBtn').setAttribute('aria-label',SFX.on?'Выключить звук':'Включить звук');
  $('#chatChip').innerHTML=`<i class="dot"></i>${ic('users',13)}<span>${esc(chatTitle||(isTG?'ЧАТ #'+chatKey:'ЛОКАЛЬНО · '+chatKey))}</span>`;
}
function renderLock(){
  const slot=$('#lockSlot');
  if(!state.locked){slot.innerHTML='';return}
  const L=state.locked,s=state.settings,crew=votersOn(L.date),{y,m}=pkey(L.date);
  const jump=(y!==rt.y||m!==rt.m)?`<button class="btn ghost sm" data-action="jump-locked">${ic('cal',14)} Показать в календаре</button>`:'';
  slot.innerHTML=`<div class="lockbanner"><div class="in">
    <div class="lb-tag">${ic('lock',13)} КАТКА ЗАФИКСИРОВАНА · ${esc(L.byName)}</div>
    <div class="lb-date">${fmtFull(L.date).toUpperCase()}</div>
    <div class="lb-meta"><span>${ic('monitor',13)} <b>${esc(s.club)}</b></span><span>${ic('clock',13)} ${esc(s.time)} · ${s.hours} ч</span><span>${s.pcs} ПК</span></div>
    <div class="lb-cd" id="cd"><small>ДО СТАРТА</small><span id="cdVal">…</span></div>
    <div class="lb-crew">${crew.map(mm=>`<span class="crewchip${mm.id===state.meId?' me':''}">${avatar(mm)}${esc(mm.name)}</span>`).join('')||'<span style="font-size:12px;color:var(--dim)">пока никто не отметился</span>'}</div>
    <div class="lb-actions">
      <button class="btn hot sm" data-action="day-details" data-date="${L.date}">${ic('users',14)} Детали дня</button>
      ${jump}
      <button class="btn ghost sm" data-action="unlock">${ic('unlock',14)} Снять фиксацию</button>
    </div>
  </div></div>`;
  tickCd();
}
function renderMonth(animate){
  const st=monthStats(rt.y,rt.m),now=now0();
  $('#monthTitle').innerHTML=`${MONTHS[rt.m].toUpperCase()}<span>${rt.y}</span>`;
  $('#monthStats').innerHTML=`<span><b>${total()}</b> ${plural(total(),'игрок','игрока','игроков')}</span>·<span><b>${st.all}</b> ${plural(st.all,'голос','голоса','голосов')}</span>${st.top?`·<button data-action="day-details" data-date="${st.top}">топ: ${fmtShort(st.top)} — ${st.best}/${total()}</button>`:''}`;
  const atCur=rt.y===now.getFullYear()&&rt.m===now.getMonth();
  const max=new Date(now.getFullYear(),now.getMonth()+3,1);
  $('#btnPrev').innerHTML=ic('chevL',20);$('#btnNext').innerHTML=ic('chevR',20);
  $('#btnPrev').disabled=atCur;
  $('#btnNext').disabled=(rt.y>max.getFullYear()||(rt.y===max.getFullYear()&&rt.m>=max.getMonth()));
  $('#btnNext').classList.toggle('attn',!st.future.length&&!$('#btnNext').disabled);
  $('#todaySlot').innerHTML=atCur?'':`<button class="todaychip" data-action="go-today">↩ вернуться к текущему месяцу</button>`;
  $('#hintSlot').innerHTML=(!state.flags.hinted&&!Object.keys(me().votes).length)?`<div class="hintbar">${ic('zap',16)}<span><b>Тапай дни</b>, когда можешь катнуть — сквад увидит и выберет лучшую дату.</span><button data-action="hint-dismiss" aria-label="Скрыть подсказку">${ic('x',14)}</button></div>`:'';
  renderGrid(animate,st);
}
function renderGrid(animate,st){
  st=st||monthStats(rt.y,rt.m);
  const y=rt.y,m=rt.m,tk=todayKey(),lk=state.locked&&state.locked.date;
  const first=(new Date(y,m,1).getDay()+6)%7,dim=new Date(y,m+1,0).getDate(),prevDim=new Date(y,m,0).getDate();
  const weeks=Math.ceil((first+dim)/7),cells=[];
  for(let i=0;i<first;i++)cells.push({other:true,d:prevDim-first+1+i});
  for(let d=1;d<=dim;d++){const k=dkey(y,m,d);cells.push({k,d,past:k<tk,today:k===tk})}
  while(cells.length<weeks*7)cells.push({other:true,d:cells.length-first-dim+1});
  const tot=Math.max(1,total()),mid=state.meId;
  $('#grid').innerHTML=cells.map((c,i)=>{
    if(c.other)return`<div class="cell other${animate?' anim':''}" style="animation-delay:${i*10}ms" aria-hidden="true"><div class="face"><span class="num" style="color:var(--dim)">${c.d}</span></div></div>`;
    const cnt=st.map[c.k]||0,vs=votersOn(c.k),mine=!!me().votes[c.k],top=c.k===st.top&&cnt>0,locked=c.k===lk;
    const cls=['cell',c.past?'past':'',c.today?'today':'',mine?'mine':'',top?'topd':'',locked?'locked':'',animate?'anim':''].filter(Boolean).join(' ');
    const badge=locked?ic('lock',13):mine?ic('check',13):'';
    const aria=`${c.d} ${MGEN[m]}, ${WD[wdi(c.k)]}. Могут ${cnt} из ${total()}${mine?'. Ты отметил':''}${top?'. Лучшая дата':''}${locked?'. Зафиксировано':''}${c.past?'. Прошедший день':''}`;
    return`<div class="${cls}" style="--heat:${(cnt/tot).toFixed(3)};animation-delay:${i*10}ms" data-celldate="${c.k}">
      <button class="hit" data-action="vote" data-date="${c.k}" ${c.past?'disabled':''} aria-pressed="${mine}" aria-label="${esc(aria)}"></button>
      <div class="face"><span class="num">${top?ic('star',10):''}${c.d}</span><span class="tr">${badge}</span>
      <span class="dots">${vs.slice(0,3).map(dot).join('')}</span></div>
      <button class="meta${cnt?'':' zero'}" data-action="day-details" data-date="${c.k}" aria-label="Детали: ${esc(aria)}">${cnt}${ic('user',10)}</button>
    </div>`;
  }).join('');
}
function renderBoard(){
  const st=monthStats(rt.y,rt.m),tot=Math.max(1,total());
  rt.min=Math.min(rt.min,Math.max(1,total()));
  $('#boardTitle').innerHTML=`${ic('zap',16)} ТОП ДАТ`;
  $('#lgStar').innerHTML=`${ic('star',11).replace('class="ic"','class="ic st"')} топ-дата`;
  $('#lgLock').innerHTML=`${ic('lock',11).replace('class="ic"','class="ic lk"')} зафиксировано`;
  document.querySelectorAll('#fchips button').forEach(b=>b.classList.toggle('on',b.dataset.f===rt.filter));
  $('#sortBtn').innerHTML=`${ic('sort',14)} ${rt.sort==='votes'?'ПО ГОЛОСАМ':'ПО ДАТЕ'}`;
  $('#minVal').textContent='≥'+rt.min;
  $('#minMinus').innerHTML=ic('minus',13);$('#minPlus').innerHTML=ic('plus',13);
  $('#minMinus').disabled=rt.min<=1;$('#minPlus').disabled=rt.min>=total();
  let list=st.future.filter(k=>{const c=st.map[k];if(c<rt.min)return false;if(rt.filter==='we'&&!isWE(k))return false;if(rt.filter==='wd'&&isWE(k))return false;return true});
  list.sort(rt.sort==='votes'?(a,b)=>st.map[b]-st.map[a]||a.localeCompare(b):(a,b)=>a.localeCompare(b));
  list=list.slice(0,6);
  const lk=state.locked&&state.locked.date;
  if(!list.length){
    const noData=!st.future.length;
    $('#boardList').innerHTML=`<div class="empty">${ic('zap',30)}<p>${noData?'В этом месяце больше нет голосов — время планировать следующий.':'Под фильтры ничего не попало. Ослабь условия или отметь дни сам.'}</p>${noData?`<button data-action="next-month">Следующий месяц ${ic('chevR',12)}</button>`:`<button data-action="reset-filters">Сбросить фильтры</button>`}</div>`;
    rt.prevBars={};return;
  }
  const bars={};
  $('#boardList').innerHTML=list.map((k,i)=>{
    const c=st.map[k],pct=Math.round(c/tot*100),old=rt.prevBars[k]||0;bars[k]=pct;
    const{d,m}=pkey(k),we=isWE(k);
    return`<button class="lrow${i===0&&rt.sort==='votes'?' r1':''}" data-action="day-details" data-date="${k}">
      <span class="rank">${i===0&&rt.sort==='votes'?ic('star',12):''}${i+1}</span>
      <span class="ld${we?' we':''}"><b>${WD[wdi(k)]}</b>${d} ${MSHORT[m]}${k===lk?ic('lock',11):''}</span>
      <span class="lbar"><i data-bar="${k}" data-w="${pct}" style="width:${old}%"></i></span>
      <span class="lc">${c}<small>/${total()}</small></span>
    </button>`;
  }).join('');
  requestAnimationFrame(()=>requestAnimationFrame(()=>{document.querySelectorAll('#boardList [data-bar]').forEach(b=>b.style.width=b.dataset.w+'%')}));
  rt.prevBars=bars;
}
function renderSquad(){
  const pref=mprefix(rt.y,rt.m);
  const vc=m=>Object.keys(m.votes).filter(k=>k.startsWith(pref)).length;
  const sorted=[...state.members].sort((a,b)=>(a.id===state.meId?-1:b.id===state.meId?1:vc(b)-vc(a)));
  $('#squadTitle').innerHTML=`${ic('users',16)} СКВАД`;
  $('#squadCount').textContent=total();
  $('#nameHintSlot').innerHTML=(!tgu&&me().name==='Игрок')?`<button class="namehint" data-action="open-profile">${ic('pen',11)} представься</button>`:'';
  $('#squadStrip').innerHTML=sorted.map(m=>`<button class="sqchip${m.id===state.meId?' me':''}" data-action="${m.id===state.meId?'open-profile':'open-roster'}">${avatar(m)}<span class="nm">${esc(m.name)}</span><span class="vc">${vc(m)}</span>${m.id===state.meId?ic('pen',11):''}</button>`).join('');
  const s=state.settings;
  $('#clubCard').innerHTML=`<div class="cname">${esc(s.club)}</div>
    <div class="rows">
      <div class="rw">${ic('clock',15)} старт <b>${esc(s.time)}</b> · ${s.hours} ${plural(s.hours,'час','часа','часов')}</div>
      <div class="rw">${ic('monitor',15)} бронируем <b>${s.pcs} ПК</b></div>
      <div class="rw">${ic('card',15)} <b>${s.price} ₽/час</b> с человека <span class="rub">≈ ${s.price*s.hours} ₽ за катку</span></div>
    </div>`;
  $('#rosterBtn').innerHTML=`${ic('users',14)} Состав`;
  $('#settBtn').innerHTML=`${ic('sliders',14)} Настройки`;
}
function renderFooter(){
  const keys=myMonthKeys(rt.y,rt.m);
  $('#myLabel').textContent='ТВОИ ДАТЫ · '+MSHORT[rt.m].toUpperCase();
  $('#myChips').innerHTML=keys.length?keys.map(k=>`<button class="mychip" data-action="day-details" data-date="${k}">${fmtShort(k)} · ${WD[wdi(k)]}</button>`).join(''):`<span class="none">отметь дни в календаре ↑</span>`;
  $('#clearBtn').innerHTML=`${ic('trash',15)} Сброс`;
  $('#clearBtn').disabled=!keys.length;
  $('#shareBtn').innerHTML=`${ic('share',17)} ПОЗВАТЬ СКВАД`;
  requestAnimationFrame(()=>{document.documentElement.style.setProperty('--footH',$('footer').offsetHeight+'px')});
}
function renderMain(animate){renderHeader();renderLock();renderMonth(animate);renderBoard();renderSquad();renderFooter();updateMainBtn()}
function renderAll(animate){renderMain(animate);if(rt.drawer)renderDrawer()}
function updateMainBtn(){if(!isTG||!tg.MainButton)return;try{tg.MainButton.setParams({color:'#00E5FF',text_color:'#041018',is_active:true,is_visible:true});tg.MainButton.setText(state.locked?'СВОДКА КАТКИ ⚡':'ПОЗВАТЬ СКВАД')}catch(e){}}

/* ═════════ ШТОРКИ ═════════ */
function openDrawer(type,date){
  rt.lastFocus=document.activeElement;rt.drawer={type,date};rt.q='';rt.pendingCode=chatKey;
  renderDrawer();
  const sc=$('#scrim'),dr=$('#drawer');sc.hidden=false;dr.hidden=false;
  requestAnimationFrame(()=>{sc.classList.add('show');dr.classList.add('show')});
  document.documentElement.classList.add('locked');
  SFX.play('open');haptic('light');
  try{if(isTG&&tg.BackButton){tg.BackButton.show();tg.BackButton.onClick(closeDrawer)}}catch(e){}
  setTimeout(()=>$('#drawerX').focus(),80);
}
function closeDrawer(){
  if(!rt.drawer)return;rt.drawer=null;
  const sc=$('#scrim'),dr=$('#drawer');sc.classList.remove('show');dr.classList.remove('show');dr.style.transform='';dr.style.transition='';
  document.documentElement.classList.remove('locked');
  setTimeout(()=>{sc.hidden=true;dr.hidden=true},320);
  SFX.play('close');
  try{if(isTG&&tg.BackButton){tg.BackButton.hide();tg.BackButton.offClick(closeDrawer)}}catch(e){}
  if(rt.lastFocus&&rt.lastFocus.isConnected)rt.lastFocus.focus();
}
function renderDrawer(){
  if(!rt.drawer)return;
  const{type,date}=rt.drawer;let title='',html='';
  if(type==='day'){title='ДЕНЬ КАТКИ';html=drawerDay(date)}
  else if(type==='settings'){title='НАСТРОЙКИ СБОРА';html=drawerSettings()}
  else if(type==='roster'){title='СОСТАВ СКВАДА';html=drawerRoster()}
  else if(type==='profile'){title='ТВОЙ ПРОФИЛЬ';html=drawerProfile()}
  $('#drawerTitle').textContent=title;$('#drawerX').innerHTML=ic('x',16);
  $('#drawerBody').innerHTML=html;
}
function drawerDay(k){
  const vs=votersOn(k),cant=state.members.filter(m=>!m.votes[k]),mine=!!me().votes[k];
  const past=k<todayKey(),locked=state.locked&&state.locked.date===k,st=monthStats(rt.y,rt.m),top=k===st.top;
  const lockBtn=locked
    ?`<button class="btn danger wide" data-action="unlock">${ic('unlock',16)} Снять фиксацию</button>`
    :`<button class="btn hot wide" data-action="lock-day" data-date="${k}" ${(!vs.length||past)?'disabled':''}>${ic('lock',16)} Зафиксировать катку на этот день</button>`;
  return`<div class="dd-date${locked?' hot':''}">${fmtFull(k).toUpperCase()} ${top?ic('star',18).replace('class="ic"','class="ic" style="color:var(--acid);fill:var(--acid)"'):''}</div>
  <div class="dd-ratio">${locked?'🔒 зафиксировано · ':''}могут <b>${vs.length}</b> из ${total()} · ${esc(state.settings.time)} · ${esc(state.settings.club)}${past?' · <span style="color:var(--amber)">день прошёл</span>':''}</div>
  <button class="btn dd-toggle ${mine?'on':'ghost'}" data-action="vote" data-date="${k}" ${past?'disabled':''}>${ic(mine?'check':'plus',16)} ${mine?'Ты в деле — тап, чтобы убрать':'Я могу в этот день'}</button>
  <div class="dd-sec">МОГУТ <b>${vs.length}</b></div>
  <div class="crew">${vs.map(m=>`<span class="crewchip${m.id===state.meId?' me':''}">${avatar(m)}${esc(m.name)}</span>`).join('')||'<span style="font-size:12.5px;color:var(--dim)">пока никто — будь первым</span>'}</div>
  <div class="dd-sec">МОЛЧАТ <b style="color:var(--dim)">${cant.length}</b></div>
  <div class="crew">${cant.map(m=>`<span class="crewchip mute">${avatar(m)}${esc(m.name)}</span>`).join('')||'<span style="font-size:12.5px;color:var(--acid)">весь сквад в сборе!</span>'}</div>
  <div class="dd-actions">${lockBtn}
    <button class="btn ghost wide" data-action="copy-day" data-date="${k}">${ic('copy',15)} Скопировать сводку дня</button>
  </div>`;
}
function stepRow(label,icon,field,val,min,max,suffix){
  return`<div class="steprow"><span class="sl">${ic(icon,15)} ${label}</span><span class="sc">
    <button data-action="step" data-field="${field}" data-d="-1" ${val<=min?'disabled':''} aria-label="Уменьшить">${ic('minus',14)}</button>
    <b>${val}${suffix||''}</b>
    <button data-action="step" data-field="${field}" data-d="1" ${val>=max?'disabled':''} aria-label="Увеличить">${ic('plus',14)}</button>
  </span></div>`;
}
function drawerSettings(){
  const s=state.settings,link=buildLink();
  return`
  <div class="frow"><label>Название клуба</label><input type="text" data-field="club" value="${esc(s.club)}" maxlength="32"></div>
  <div class="inline2">
    <div class="frow"><label>Время старта</label><input type="time" data-field="time" value="${esc(s.time)}"></div>
    <div class="frow"><label>₽ / час с человека</label><input type="text" inputmode="numeric" data-field="price" value="${s.price}"></div>
  </div>
  ${stepRow('Длительность','clock','hours',s.hours,1,12,' ч')}
  ${stepRow('ПК в брони','monitor','pcs',s.pcs,2,40,'')}
  <div class="dsect">ПРИВЯЗКА К ЧАТУ</div>
  <div class="frow"><label>Ссылка Mini App</label><input type="url" data-field="appLink" value="${esc(s.appLink)}" placeholder="https://t.me/твой_бот/app"><div class="hint">Ссылка приложения из BotFather. Каждый чат получает свой код — данные чатов не смешиваются.</div></div>
  <div class="frow"><label>Код чата</label>
    <div class="linkline"><input type="text" data-field="code" value="${esc(rt.pendingCode)}" maxlength="32">
    <button class="btn ghost sm" data-action="apply-code">Применить</button></div>
    <div class="hint">Отправь в нужный чат ссылку ниже — сбор откроется только с данными этого чата.</div></div>
  <button class="btn acid wide" data-action="copy-link">${ic('link',15)} ${link?'Скопировать ссылку для чата':'Скопировать код чата'}</button>
  ${link?`<div class="micro" style="word-break:break-all">${esc(link)}</div>`:''}
  <div class="dsect">СИНХРОНИЗАЦИЯ СКВАДА</div>
  <div class="inline2">
    <button class="btn ghost sm" style="flex:1" data-action="export-state">${ic('down',14)} Экспорт</button>
    <button class="btn ghost sm" style="flex:1" data-action="import-toggle">${ic('up',14)} Импорт</button>
  </div>
  <div id="impBlock" hidden style="margin-top:10px">
    <div class="frow"><textarea id="impTa" placeholder="Вставь сюда экспортированный JSON от другого игрока…"></textarea></div>
    <button class="btn acid wide" data-action="apply-import">${ic('check',15)} Применить импорт</button>
  </div>
  <div class="micro">Приложение локальное: данные живут на устройстве. Экспортируй состояние в чат — тиммейты импортируют его и увидят общий календарь. Две вкладки на одном устройстве синхронизируются сами.</div>
  <div class="dsect" style="color:var(--red)">ОПАСНАЯ ЗОНА</div>
  <button class="btn danger wide" data-action="reset-all">${ic('trash',15)} Сбросить сбор полностью</button>`;
}
function rosterRows(){
  const pref=mprefix(rt.y,rt.m),q=rt.q.trim().toLowerCase();
  const vc=m=>Object.keys(m.votes).filter(k=>k.startsWith(pref)).length;
  let list=[...state.members].sort((a,b)=>(a.id===state.meId?-1:b.id===state.meId?1:vc(b)-vc(a)));
  if(q)list=list.filter(m=>m.name.toLowerCase().includes(q));
  if(!list.length)return`<div class="empty">${ic('search',26)}<p>Никого с таким ником</p></div>`;
  return list.map(m=>{
    const isMe=m.id===state.meId,n=vc(m);
    const act=isMe?`<button class="act pen" data-action="open-profile" aria-label="Редактировать профиль">${ic('pen',15)}</button>`
      :(!isTG?`<button class="act" data-action="remove-member" data-id="${esc(m.id)}" aria-label="Удалить ${esc(m.name)}">${ic('trash',15)}</button>`:'');
    return`<div class="rrow">${avatar(m)}<span class="nm">${esc(m.name)}${isMe?'<em>ТЫ</em>':''}</span><span class="vc">${n} ${plural(n,'дата','даты','дат')}</span>${act}</div>`;
  }).join('');
}
function drawerRoster(){
  return`<div class="searchbox">${ic('search',15)}<input type="text" data-field="rosterQ" placeholder="Найти игрока…" value="${esc(rt.q)}"></div>
  <div class="rlist" id="rosterList">${rosterRows()}</div>
  ${!isTG?`<div class="addrow"><input type="text" id="addName" placeholder="Ник нового игрока" maxlength="24"><button class="btn acid sm" data-action="add-member">${ic('plus',14)} Добавить</button></div>
  <div class="micro">Локальный режим: добавляй тиммейтов вручную. В Telegram игроки появляются сами, когда открывают сбор в чате.</div>`
  :`<div class="micro">Игроки добавляются, когда открывают сбор в этом чате. Чтобы объединить календари с разных устройств — используй Экспорт/Импорт в настройках.</div>`}`;
}
const HUES=[190,320,95,40,265,355,215,160];
function drawerProfile(){
  const m=me();
  return`<div class="pf-preview"><span id="pfAv">${avatar(m,'big')}</span><div><div class="pfn" id="pfN">${esc(m.name)}</div><div class="pfs">${tgu?'аккаунт Telegram':'локальный игрок'} · ${Object.keys(m.votes).length} ${plural(Object.keys(m.votes).length,'голос','голоса','голосов')}</div></div></div>
  <div class="frow"><label>Ник в скваде</label><input type="text" data-field="meName" id="pfName" value="${esc(m.name)}" maxlength="24">${tgu?'<div class="hint">Имя подтянулось из Telegram — можешь поставить игровой ник.</div>':''}</div>
  <div class="frow"><label>Цвет аватара</label><div class="hues">${HUES.map(h=>`<button class="hue${m.hue===h?' on':''}" style="--h:${h}" data-action="set-hue" data-h="${h}" aria-label="Цвет ${h}"></button>`).join('')}</div></div>
  <button class="btn pri wide" data-action="save-profile">${ic('check',16)} Сохранить профиль</button>`;
}

/* ═════════ ДЕЙСТВИЯ ═════════ */
function bumpCell(k){const c=document.querySelector(`[data-celldate="${k}"]`);if(!c)return;const m=c.querySelector('.meta'),f=c.querySelector('.face');if(m){m.classList.remove('bump');void m.offsetWidth;m.classList.add('bump')}if(f){f.classList.remove('pop');void f.offsetWidth;f.classList.add('pop')}}
function actVote(k){
  if(k<todayKey()){SFX.play('error');haptic('err');toast('Прошедший день — выбери будущий','warn');return}
  const m=me(),on=!m.votes[k];
  if(on)m.votes[k]=1;else delete m.votes[k];
  if(on&&!state.flags.hinted){state.flags.hinted=true;toast('Голос учтён — сквад тебя видит ⚡')}
  save();renderMain(false);bumpCell(k);
  if(rt.drawer&&rt.drawer.type==='day'&&rt.drawer.date===k)renderDrawer();
  SFX.play(on?'on':'off',countOn(k));haptic(on?'light':'medium');
}
function actLock(k,srcEl){
  const r=srcEl?srcEl.getBoundingClientRect():null,x=r?r.left+r.width/2:innerWidth/2,y=r?r.top+r.height/2:innerHeight/2;
  const s=snap();
  state.locked={date:k,byName:me().name,at:Date.now()};save();renderAll(false);
  const{y:ly,m:lm}=pkey(k);
  FX.burst(x,y);SFX.play('lock');haptic('ok');
  toast('Катка зафиксирована: '+fmtFull(k),null,s);
}
function actUnlock(){const s=snap();state.locked=null;save();renderAll(false);SFX.play('unlock');haptic('warn');toast('Фиксация снята',null,s)}
function setMonth(y,m){rt.y=y;rt.m=m;rt.prevBars={};renderMain(true);window.scrollTo({top:0,behavior:'smooth'});haptic('light')}
function switchCode(code){
  code=sanitizeCode(code);if(code===chatKey){toast('Этот код уже активен','warn');return}
  save();chatKey=code;storeKey='pcc.v1:'+chatKey;
  state=load()||seed(chatKey);ensureMe();
  rt.prevBars={};closeDrawer();renderAll(true);
  toast('Чат-код применён: '+code);haptic('ok');
}
const ACTIONS={
  'vote':el=>actVote(el.dataset.date),
  'day-details':el=>openDrawer('day',el.dataset.date),
  'open-settings':()=>openDrawer('settings'),
  'open-roster':()=>openDrawer('roster'),
  'open-profile':()=>{if(rt.drawer)closeDrawer();setTimeout(()=>openDrawer('profile'),rt.drawer?0:0);if(!rt.drawer)openDrawer('profile')},
  'close-drawer':()=>closeDrawer(),
  'prev-month':()=>{const d=new Date(rt.y,rt.m-1,1);setMonth(d.getFullYear(),d.getMonth())},
  'next-month':()=>{const d=new Date(rt.y,rt.m+1,1);setMonth(d.getFullYear(),d.getMonth())},
  'go-today':()=>{const n=now0();setMonth(n.getFullYear(),n.getMonth())},
  'jump-locked':()=>{const{y,m}=pkey(state.locked.date);setMonth(y,m)},
  'hint-dismiss':()=>{state.flags.hinted=true;save();renderMonth(false)},
  'filter':el=>{rt.filter=el.dataset.f;renderBoard();haptic('light')},
  'sort-toggle':()=>{rt.sort=rt.sort==='votes'?'date':'votes';rt.prevBars={};renderBoard();haptic('light')},
  'min-step':el=>{rt.min=Math.max(1,Math.min(total(),rt.min+Number(el.dataset.d)));renderBoard();haptic('light')},
  'reset-filters':()=>{rt.filter='all';rt.min=1;renderBoard()},
  'clear-mine':()=>{const s=snap(),p=mprefix(rt.y,rt.m),m=me();let n=0;Object.keys(m.votes).forEach(k=>{if(k.startsWith(p)){delete m.votes[k];n++}});if(!n)return;save();renderAll(false);SFX.play('off');haptic('warn');toast(`Сброшено ${n} ${plural(n,'дата','даты','дат')}`,null,s)},
  'share':()=>doShare(),
  'lock-day':el=>actLock(el.dataset.date,el),
  'unlock':()=>actUnlock(),
  'copy-day':async el=>{const k=el.dataset.date,vs=votersOn(k),s=state.settings;
    const t=`🎮 ${s.club} — ${fmtFull(k)}\n🕖 ${s.time} · ${s.hours} ч · ${s.pcs} ПК\n✅ Могут (${vs.length}/${total()}): ${vs.map(m=>m.name).join(', ')||'пока никто'}${state.locked&&state.locked.date===k?'\n🔒 ДЕНЬ ЗАФИКСИРОВАН':''}`;
    const ok=await copyText(t);SFX.play('share');toast(ok?'Сводка дня скопирована':'Не удалось скопировать',ok?null:'warn')},
  'sound-toggle':()=>{SFX.on=!SFX.on;try{localStorage.setItem('pcc.snd',SFX.on?'1':'0')}catch(e){}renderHeader();if(SFX.on)SFX.play('on',2);haptic('light')},
  'step':el=>{const f=el.dataset.field,d=Number(el.dataset.d),s=state.settings;
    const lim={hours:[1,12],pcs:[2,40],price:[0,2000]}[f];const step=f==='price'?10:1;
    s[f]=Math.max(lim[0],Math.min(lim[1],s[f]+d*step));save();renderMain(false);renderDrawer();haptic('light')},
  'apply-code':()=>switchCode(rt.pendingCode),
  'copy-link':async()=>{const link=buildLink();const ok=await copyText(link||('Код чата: '+chatKey));SFX.play('share');toast(ok?(link?'Ссылка скопирована — отправь в чат':'Код скопирован. Добавь ссылку Mini App в настройках'):'Не удалось скопировать',ok?null:'warn')},
  'export-state':async()=>{const ok=await copyText(JSON.stringify(state));SFX.play('share');toast(ok?'Состояние скопировано — кинь JSON в чат':'Не удалось скопировать',ok?null:'warn')},
  'import-toggle':()=>{const b=$('#impBlock');if(b){b.hidden=!b.hidden;if(!b.hidden)$('#impTa').focus()}},
  'apply-import':()=>{try{const s=JSON.parse($('#impTa').value);if(!s||s.v!==1||!Array.isArray(s.members)||!s.settings)throw 0;
    const old=snap();state=s;ensureMe();save();rt.prevBars={};renderAll(true);SFX.play('add');haptic('ok');toast('Импорт применён — календарь обновлён',null,old)}
    catch(e){SFX.play('error');haptic('err');toast('Не похоже на экспорт сбора — проверь JSON','warn')}},
  'reset-all':()=>{const s=snap();try{localStorage.removeItem(storeKey)}catch(e){}state=seed(chatKey);ensureMe();rt.prevBars={};closeDrawer();renderAll(true);SFX.play('off');haptic('warn');toast('Сбор сброшен к начальному',null,s)},
  'add-member':()=>{const inp=$('#addName');const name=(inp?.value||'').trim();
    if(!name){inp.classList.remove('shake');void inp.offsetWidth;inp.classList.add('shake');SFX.play('error');haptic('err');return}
    state.members.push({id:'m'+Date.now().toString(36),name:name.slice(0,24),hue:HUES[Math.floor(Math.random()*HUES.length)],votes:{}});
    save();renderMain(false);renderDrawer();SFX.play('add');haptic('ok');toast(name+'加入 сквада'.replace('加入','в'))},
  'remove-member':el=>{const id=el.dataset.id,m=state.members.find(x=>x.id===id);if(!m||id===state.meId)return;
    const s=snap();state.members=state.members.filter(x=>x.id!==id);save();renderMain(false);renderDrawer();SFX.play('off');haptic('warn');toast(m.name+' удалён из сквада',null,s)},
  'set-hue':el=>{const h=Number(el.dataset.h);me().hue=h;if(!tgu)state.meName=me().name;save();renderMain(false);
    document.querySelectorAll('.hue').forEach(b=>b.classList.toggle('on',Number(b.dataset.h)===h));
    const pv=$('#pfAv');if(pv)pv.innerHTML=avatar(me(),'big');haptic('light')},
  'save-profile':()=>{const m=me();if(!m.name.trim())m.name='Игрок';if(!tgu)state.meName=m.name;save();renderMain(false);closeDrawer();SFX.play('add');haptic('ok');toast('Профиль сохранён')},
  'undo':el=>{const t=el.closest('.toast');if(t){clearTimeout(t._t);t._kill()}doUndo(el.dataset.uid)},
};

/* ═════════ ДЕЛЕГИРОВАНИЕ ═════════ */
document.addEventListener('click',e=>{
  const el=e.target.closest('[data-action]');if(!el||el.disabled)return;
  if(rt.lp&&el.dataset.action==='vote'){rt.lp=false;return}
  const fn=ACTIONS[el.dataset.action];if(fn)fn(el);
});
document.addEventListener('input',e=>{
  const el=e.target,f=el.dataset.field;if(!f)return;
  if(f==='rosterQ'){rt.q=el.value;const l=$('#rosterList');if(l)l.innerHTML=rosterRows();return}
  if(f==='code'){rt.pendingCode=el.value;return}
  if(f==='meName'){const m=me();m.name=el.value.slice(0,24);if(!tgu)state.meName=m.name;saveSoon();renderMain(false);
    const n=$('#pfN');if(n)n.textContent=m.name||'Игрок';const a=$('#pfAv');if(a)a.innerHTML=avatar(m,'big');return}
  if(f==='club'){state.settings.club=el.value.slice(0,32)||'PC CLUB';saveSoon();renderMain(false);return}
  if(f==='time'){if(el.value)state.settings.time=el.value;saveSoon();renderMain(false);return}
  if(f==='price'){const v=parseInt(el.value.replace(/\D/g,''),10);state.settings.price=isNaN(v)?0:Math.min(2000,v);saveSoon();renderMain(false);return}
  if(f==='appLink'){state.settings.appLink=el.value.trim();saveSoon();return}
});
document.addEventListener('keydown',e=>{
  if(e.key==='Escape'&&rt.drawer){closeDrawer();return}
  if(e.key==='Tab'&&rt.drawer){
    const f=[...$('#drawer').querySelectorAll('button:not(:disabled),input,textarea,[tabindex]')].filter(x=>x.offsetParent!==null);
    if(!f.length)return;const first=f[0],last=f[f.length-1];
    if(e.shiftKey&&document.activeElement===first){e.preventDefault();last.focus()}
    else if(!e.shiftKey&&document.activeElement===last){e.preventDefault();first.focus()}
  }
  if(e.key==='Enter'&&e.target.id==='addName'){e.preventDefault();ACTIONS['add-member']()}
});
/* долгий тап по дню → детали */
let lpTimer=null,lpStart=null;
const grid=$('#grid');
grid.addEventListener('pointerdown',e=>{
  const hit=e.target.closest('.hit');if(!hit||hit.disabled)return;
  lpStart={x:e.clientX,y:e.clientY};
  lpTimer=setTimeout(()=>{rt.lp=true;haptic('medium');openDrawer('day',hit.dataset.date);setTimeout(()=>rt.lp=false,450)},480);
});
['pointerup','pointercancel','pointerleave'].forEach(ev=>grid.addEventListener(ev,()=>{clearTimeout(lpTimer)}));
grid.addEventListener('pointermove',e=>{if(lpStart&&(Math.abs(e.clientX-lpStart.x)>10||Math.abs(e.clientY-lpStart.y)>10))clearTimeout(lpTimer)});
grid.addEventListener('contextmenu',e=>e.preventDefault());
/* перетаскивание шторки вниз */
const grab=$('#grab');
grab.addEventListener('pointerdown',e=>{
  if(!rt.drawer)return;grab.setPointerCapture(e.pointerId);
  rt.drag={y:e.clientY,dy:0};$('#drawer').style.transition='none';
});
grab.addEventListener('pointermove',e=>{
  if(!rt.drag)return;rt.drag.dy=Math.max(0,e.clientY-rt.drag.y);
  $('#drawer').style.transform=`translate(-50%,${rt.drag.dy}px)`;
});
['pointerup','pointercancel'].forEach(ev=>grab.addEventListener(ev,()=>{
  if(!rt.drag)return;const dy=rt.drag.dy;rt.drag=null;const dr=$('#drawer');
  dr.style.transition='';dr.style.transform='';
  if(dy>110)closeDrawer();
}));

/* ═════════ ОБРАТНЫЙ ОТСЧЁТ ═════════ */
let lastToday=todayKey();
function tickCd(){
  if(!state.locked)return;const el=$('#cdVal'),wrap=$('#cd');if(!el||!wrap)return;
  const{y,m,d}=pkey(state.locked.date),[hh,mm]=state.settings.time.split(':').map(Number);
  const target=new Date(y,m,d,hh||19,mm||0),end=target.getTime()+state.settings.hours*3600e3,now=Date.now();
  wrap.classList.remove('live','done');
  if(now>=end){wrap.classList.add('done');wrap.querySelector('small').textContent='СТАТУС';el.textContent='КАТКА ЗАВЕРШЕНА';return}
  if(now>=target.getTime()){wrap.classList.add('live');wrap.querySelector('small').textContent='ПРЯМО СЕЙЧАС';el.textContent='КАТКА ИДЁТ — ГГ ВП!';return}
  wrap.querySelector('small').textContent='ДО СТАРТА';
  let s=Math.floor((target.getTime()-now)/1000);const dd=Math.floor(s/86400);s%=86400;const h=Math.floor(s/3600);s%=3600;const mi=Math.floor(s/60);s%=60;
  el.textContent=(dd?dd+'д ':'')+pad(h)+'ч '+pad(mi)+'м '+pad(s)+'с';
}
setInterval(()=>{tickCd();const tk=todayKey();if(tk!==lastToday){lastToday=tk;renderMain(false)}},1000);

/* ═════════ СИНХРОН МЕЖДУ ВКЛАДКАМИ ═════════ */
let syncToastT=0;
window.addEventListener('storage',e=>{
  if(e.key!==storeKey||!e.newValue)return;
  try{const s=JSON.parse(e.newValue);if(!s||s.v!==1)return;state=s;renderAll(false);
    if(Date.now()-syncToastT>4000){syncToastT=Date.now();toast('Обновлено из другой вкладки')}}catch(err){}
});
window.addEventListener('resize',()=>{FX.resize();document.documentElement.style.setProperty('--footH',$('footer').offsetHeight+'px')});
document.addEventListener('pointerdown',()=>{if(SFX.on)try{SFX.ensure()}catch(e){}},{once:true});

/* ═════════ СТАРТ ═════════ */
(function init(){
  if(isTG){try{
    tg.ready();tg.expand();
    tg.setHeaderColor('#05070D');tg.setBackgroundColor('#05070D');
    if(tg.disableVerticalSwipes)tg.disableVerticalSwipes();
    const setVh=()=>{if(tg.viewportStableHeight)document.documentElement.style.setProperty('--tg-vh',tg.viewportStableHeight+'px')};
    setVh();tg.onEvent('viewportChanged',setVh);
    tg.MainButton.onClick(doShare);
  }catch(e){}}
  renderAll(true);
  requestAnimationFrame(()=>document.body.classList.add('loaded'));
})();
</script>
</body>
</html>
