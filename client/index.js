// The Adventurer's Chronicle journal: a window of the plugin's own (api.ui.window)
// that shows every chapter, what you did (finished quests) and what to do now
// (the ongoing quest). The story text is in data.js (generated from
// tools/story.ps1); the server only says where you are, answering
// "@chronicle <n> state" from npc/chronicle.txt with
//   <step>|<base level>|<places found>|<chapters skipped>|<hunt state>|<items in bag>|<watched monsters>
// (places found: npc-plus's Warper record, NPCP_WM$; 0 without that mod)
// Open with Alt+B, the Journal button, the Chronicle book, or @chronicle.

import DATA from './data.js';

const TYPE = { talk: 'Talk', hunt: 'Hunt', deliver: 'Deliver', boss: 'Showdown', report: 'Report' };

const STYLE = `
.chr { font: 12px Tahoma, Arial, sans-serif; color: #273256; display: flex; flex-direction: column; height: 100%; }
.head { padding: 8px 10px; background: #f3f5fb; border-bottom: 1px solid #c9d1e6; }
.head h2 { margin: 0 0 2px; font-size: 13px; }
.head .meta { color: #667; display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
.head button, .now button { font: inherit; padding: 1px 8px; border: 1px solid #6b7a99; border-radius: 3px;
  background: linear-gradient(#f3f6fd, #d3dbef); color: #273256; cursor: pointer; margin-left: auto; }
.now { margin: 8px 10px 4px; padding: 8px 10px; border: 1px solid #e3c766; border-radius: 4px; background: #fffbea; }
.now h3 { margin: 0 0 4px; font-size: 12px; }
.now .tag { display: inline-block; font-size: 10px; padding: 0 5px; border-radius: 8px; background: #e3c766; color: #4a3a00; margin-right: 4px; }
.now p { margin: 4px 0; line-height: 1.4; }
.obj { margin: 4px 0 0; padding: 0; list-style: none; }
.obj li { padding: 1px 0; line-height: 1.5; }
.obj img { width: 24px; height: 24px; image-rendering: pixelated; vertical-align: middle; margin-right: 6px; }
.ok { color: #2d7a2d; font-weight: bold; }
.warn { color: #a5541a; }
.now .hint { color: #667; font-size: 11px; }
.how { margin: 6px 0 2px; background: #fff; }
.how summary { padding: 3px 8px; }
.how ol { margin: 0; padding: 0 10px 6px 28px; }
.how li { margin: 3px 0; line-height: 1.4; }
.here { margin: 6px 0 2px; }
.here ul { margin: 2px 0; padding-left: 18px; }
.here li { margin: 2px 0; }
.route { color: #c00000; cursor: pointer; text-decoration: underline; font-weight: bold; }
.route:hover { color: #ff0000; }
.list { overflow: auto; flex: 1; padding: 2px 10px 10px; }
details { border: 1px solid #dfe4f1; border-radius: 4px; margin: 6px 0; background: #fff; }
summary { padding: 5px 8px; cursor: pointer; font-weight: bold; display: flex; gap: 6px; align-items: center; }
summary small { font-weight: normal; color: #889; margin-left: auto; }
.body { padding: 0 10px 8px; }
.intro { color: #556; font-style: italic; margin: 2px 0 6px; line-height: 1.4; }
.q { margin: 5px 0; line-height: 1.4; }
.q b { color: #273256; }
.q .st { font-size: 10px; padding: 0 5px; border-radius: 8px; margin-right: 4px; }
.st.done { background: #d9f0d9; color: #2d6a2d; }
.st.going { background: #fff0b8; color: #7a5a00; }
.st.brief { background: #e6e9f2; color: #556; }
.q.locked { color: #99a; }
.badge { font-size: 10px; padding: 0 6px; border-radius: 8px; background: #d9f0d9; color: #2d6a2d; font-weight: normal; }
.badge.cur { background: #fff0b8; color: #7a5a00; }
.badge.lock { background: #eceef3; color: #889; }
.launcher { position: fixed; right: 145px; top: 92px; width: 43px; height: 22px; z-index: 8999; font: bold 10px Tahoma, sans-serif; padding: 0;
  border: 1px solid #6b7a99; border-radius: 4px; background: linear-gradient(#fff6d8, #ecd48a); color: #4a3a00; cursor: pointer; display: none; }
.launcher.ingame { display: block; }
`;

const escape = text => String(text ?? '').replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));

/** "3,10" -> [3, 10]: how many of a deliver step's items are in the bag. */
export function parseHave(text) {
    const have = String(text || '').trim().split(',').filter(Boolean).map(Number);
    return have.length && have.every(Number.isFinite) ? have : null;
}

/** The server's state line, or null when it is malformed. */
export function parseState(text) {
    const raw = String(text || '').trim().split('|');
    const f = raw.map(Number);
    if (f.length < 5 || !Number.isFinite(f[0])) return null;
    return { step: Math.max(1, f[0]), level: f[1], waypoints: f[2], skip: f[3] || 0, hunt: f[4], have: parseHave(raw[5]), watch: parseWatch(raw[6]) };
}

/** "juperos_02 1,3" -> { map, alive: [1, 3] }: watched monsters still standing ("0": none). */
export function parseWatch(text) {
    const m = /^(\S+) ([\d,]+)$/.exec(String(text || '').trim());
    return m ? { map: m[1], alive: m[2].split(',').map(Number).filter(n => n > 0) } : null;
}

const mapName = name => String(name || '').replace(/\.(gat|rsw)$/i, '');

const STEPS = DATA.chapters.flatMap(c => c.steps.map((s, i) => ({ ...s, ch: c.n, k: i + 1, chapter: c })));
const LAST = STEPS.length;

/**
 * Open the client's Navigation window with the route to map,x,y drawn.
 * Plugins have no call for it, so this types the client's own "/navi map x/y"
 * into the chat box and presses its chat-mode button, which submits the line
 * (ChatBox.toggleChat -> submit -> /navi). Whatever was typed is put back.
 * Returns false when the chat box isn't there (or an NPC dialog is open).
 */
export function openRoute(route, doc = document) {
    const root = doc.getElementById('ChatBox')?.shadowRoot;
    const box = root?.querySelector('.input-chatbox');
    const button = root?.querySelector('.chat-function .chatmode');
    if (!box || !button || doc.querySelector('#NpcMenu, #NpcBox')) return false;
    const typed = box.innerHTML;
    box.textContent = `/navi ${route.map} ${route.x}/${route.y}`;
    button.click();
    box.innerHTML = typed;
    box.blur();	// toggleChat focused it; keys should go back to the game
    return true;
}

export default function init(parameters, api) {
    if (api?.version !== 1) throw new Error('adventurers-chronicle requires client API 1');
    const win = api.ui.window({ id: 'chronicle', title: "Adventurer's Chronicle", width: 460, height: 540, resizable: true });
    win.body.innerHTML = `<style>${STYLE}</style><div class="chr"><div class="head"></div><div class="now"></div><div class="list"></div></div>`;
    const head = win.body.querySelector('.head');
    const now = win.body.querySelector('.now');
    const list = win.body.querySelector('.list');
    let state = null;
    let asking = false;
    let have = null;	// { g, counts }: a deliver step's items in the bag, from the server
    let watch = null;	// { map, alive }: watched monsters still standing (the Juperos Gate Switches)
    let curMap = '';
    let tracker = null;	// the side quest tracker's list, and the observer on it

    // The side quest tracker (the client's QuestWindow) lists kill counts under
    // hunt quests. A deliver step gets the same kind of lines for its items,
    // in yellow. The client rebuilds the list on every quest update, so an
    // observer puts them back.
    function paintTracker() {
        const ul = tracker?.ul;
        if (!ul) return;
        ul.querySelectorAll('.chr-have').forEach(el => el.remove());
        const s = have && STEPS[have.g - 1];
        if (!s?.items?.length) return;
        const prefix = `Chronicle ${s.ch}-${s.k}:`;
        for (const li of ul.querySelectorAll('.quest-window-li')) {
            if (!li.querySelector('.quest-window-li-title')?.textContent.trim().startsWith(prefix)) continue;
            li.querySelector('.quest-window-li-monster ul')?.insertAdjacentHTML('beforeend', s.items.map((it, i) =>
                `<li class="chr-have" style="color: yellow">${escape(it.name)} ( ${have.counts[i] ?? 0} / ${it.count} )</li>`).join(''));
        }
    }
    function watchTracker(root) {
        tracker?.observer.disconnect();
        tracker = null;
        const ul = root?.querySelector('.quest-window-ul');
        if (!ul) return;
        const observer = new MutationObserver(paintTracker);
        observer.observe(ul, { childList: true });
        tracker = { ul, observer };
        paintTracker();
    }
    function setHave(g, counts) {
        have = counts ? { g, counts } : null;
        paintTracker();
        if (win.isOpen()) render();
    }
    api.on('ui:append', c => { if (c.name === 'QuestWindow') watchTracker(c.root); }, { replay: true });
    api.on('ui:remove', c => { if (c.name === 'QuestWindow') watchTracker(null); });
    api.cleanup(() => { tracker?.observer.disconnect(); tracker?.ul.querySelectorAll('.chr-have').forEach(el => el.remove()); });

    const icon = async (img, id) => { try { const url = await api.items.icon(id); if (url) img.src = url; } catch { /* no icon */ } };

    function objective(s) {
        const c = s.chapter;
        // Directions where Navigation alone can't get you there (the Culvert
        // Recruiter, the Kafra to Morroc, the Juperos elevator, the Hugel Boatman).
        const hint = s.hint?.length
            ? `<details class="how"><summary>${s.type === 'boss' ? `How to reach ${escape(s.map)}` : 'How to get there'}</summary><ol>${s.hint.map(h => `<li>${escape(h)}</li>`).join('')}</ol></details>` : '';
        if (s.type === 'hunt') {
            const done = state?.hunt === 2;
            return `<ul class="obj">${s.mobs.map(m => `<li>Defeat <b>${m.count} ${escape(m.name)}</b></li>`).join('')}
                <li>Where: <b>${escape(s.map)}</b></li>
                <li class="${done ? 'ok' : ''}">${done ? 'All defeated! The Chronicle will update in a moment.' : 'Live count: quest window (Alt+U). Companion kills count too.'}</li></ul>${hint}`;
        }
        const counts = have?.g === s.g ? have.counts : null;
        const count = (it, i) => counts ? ` <span class="${counts[i] >= it.count ? 'ok' : 'hint'}">(${counts[i] ?? 0} / ${it.count})</span>` : '';
        const items = verb => s.items.map((it, i) => `<li><img data-icon="${it.id}" alt="">${verb} <b>${it.count} ${escape(it.name)}</b>${count(it, i)}</li>`).join('');
        if (s.type === 'deliver') {
            return `<ul class="obj">${items('Bring')}
                <li>To: <b>${escape(c.npc)}</b>, ${escape(c.townName)} (${c.x}, ${c.y})</li></ul>${hint}`;
        }
        if (s.type === 'boss') {
            // A boss behind a puzzle (the Juperos elevator) has its items to
            // bring along (not taken by the Chronicle).
            return `<ul class="obj">${s.items?.length ? items('Bring along') : ''}
                <li>Reach <b>${escape(s.map)}</b>. <b>${escape(s.boss)}</b> will appear a few seconds after you arrive.</li></ul>${hint}`;
        }
        return `<ul class="obj"><li>Talk to <b>${escape(c.npc)}</b> in ${escape(c.townName)} (${c.x}, ${c.y}). They are marked on your minimap when you arrive.</li></ul>${hint}`;
    }

    // A step's clickable spots on the map you are on. Navigation draws a path
    // inside your own map even where it can't route between maps. Gate
    // Switches leave the list as they fall; then the centre portal is next.
    function here(s) {
        const spots = (s.spots || []).map((p, i) => ({ ...p, i })).filter(p => p.map === curMap);
        if (!spots.length) return '';
        let list = spots;
        let note = '';
        const switches = spots.filter(p => p.sw > 0);
        if (switches.length) {
            const w = watch?.map === curMap ? watch : null;
            const portal = spots.find(p => p.sw === 0);
            const other = spots.filter(p => p.sw == null);
            const at = portal ? ` (${portal.x}, ${portal.y})` : '';
            if (w && !w.alive.length) {
                list = [...(portal ? [portal] : []), ...other];
                note = `<span class="ok">All Gate Switches are down!</span> The centre portal${at} stays open for about 10 minutes. Not there? The switches come back within 20 minutes.`;
            } else {
                list = [...(w ? switches.filter(p => w.alive.includes(p.sw)) : switches), ...other];
                note = w ? `${w.alive.length} of ${switches.length} Gate Switches still standing. When the last one falls, the centre portal${at} opens.`
                    : `Destroy the Gate Switches, then take the centre portal${at}.`;
            }
        }
        return `<div class="here"><b>Here on ${escape(curMap)}:</b><ul>${list.map(p =>
            `<li><span class="route" data-spot="${p.i}" title="Open Navigation with the way there">${escape(p.name)} (${p.x}, ${p.y})</span></li>`).join('')}</ul>
            ${note ? `<p class="hint">${note}</p>` : ''}</div>`;
    }

    function render() {
        const step = state ? state.step : 1;
        const finished = step > LAST;
        const cur = finished ? null : STEPS[step - 1];
        const chNow = cur ? cur.ch : DATA.chapters.length;

        head.innerHTML = `<h2>${finished ? 'Your Chronicle is complete' : `Chapter ${cur.ch}: ${escape(cur.chapter.title)}`}</h2>
            <div class="meta">${state ? `<span>Level ${state.level}</span>${state.waypoints > 0 ? `<span>Places found: ${state.waypoints}</span>` : ''}` : '<span>Asking the server...</span>'}
            <button type="button" class="qwin" title="The game's quest window, with live kill counts">Quest window</button></div>`;

        if (finished) {
            now.innerHTML = `<h3>Champion of Rune-Midgard</h3><p>Every chapter is told. Legends still wait: The Sign and Geffenia, Thanatos Tower, the Abyss Lakes and the Endless Tower.</p>`;
        } else {
            const low = state && state.level < cur.lv;
            const howOpen = now.querySelector('.how')?.open;	// stays open across count updates
            const spots = here(cur);
            const there = cur.type === 'boss' && curMap === cur.map;
            now.innerHTML = `<h3><span class="tag">${TYPE[cur.type]}</span>Quest ${cur.k}: ${escape(cur.title)}</h3>
                <p>${escape(cur.now)}</p>${objective(cur)}
                ${there ? `<p class="ok">You made it to ${escape(cur.map)}. Get ready!</p>`
                    : spots || (cur.route ? `<p>Route: <span class="route" title="Open Navigation with the way there">${escape(cur.route.name)} (${escape(cur.route.map)} ${cur.route.x}, ${cur.route.y})</span></p>`
                    : '<p class="hint">Navigation has no route to this map. Follow the directions above.</p>')}
                <p class="hint route-note"></p>
                ${low ? `<p class="warn">Needs level ${cur.lv}. You are level ${state.level}.</p>` : ''}`;
            const how = now.querySelector('.how');
            if (how && howOpen) how.open = true;
        }

        list.innerHTML = DATA.chapters.map(c => {
            const first = (c.n - 1) * 5 + 1;
            const last = first + 4;
            const done = step > last;
            const brief = done && c.n <= (state?.skip || 0);
            const current = !done && step >= first;
            const locked = step < first;
            const badge = locked ? `<span class="badge lock">Locked, Lv ${c.steps[0].lv}+</span>`
                : current ? '<span class="badge cur">Ongoing</span>'
                : brief ? '<span class="badge">Told in brief</span>' : '<span class="badge">Finished</span>';
            const body = locked ? '<div class="body"><p class="intro">This chapter has not begun.</p></div>'
                : `<div class="body"><p class="intro">${escape(c.intro)}</p>${c.steps.map((s, i) => {
                    const g = first + i;
                    if (g < step) {
                        return `<div class="q"><span class="st ${brief ? 'brief' : 'done'}">${brief ? 'In brief' : 'Finished'}</span><b>Quest ${i + 1}: ${escape(s.title)}.</b> ${escape(s.done)}</div>`;
                    }
                    if (g === step) {
                        return `<div class="q"><span class="st going">Ongoing</span><b>Quest ${i + 1}: ${escape(s.title)}.</b> ${escape(s.now)}</div>`;
                    }
                    return `<div class="q locked"><b>Quest ${i + 1}:</b> ???</div>`;
                }).join('')}</div>`;
            return `<details${current ? ' open' : ''}><summary>Chapter ${c.n}: ${escape(c.title)} <small>Lv ${escape(c.range)}</small>${badge}</summary>${body}</details>`;
        }).join('');

        win.body.querySelectorAll('img[data-icon]').forEach(img => icon(img, Number(img.dataset.icon)));
    }

    async function refresh() {
        if (asking) return;
        asking = true;
        try {
            const next = parseState(await api.server.request('chronicle', 'state'));
            if (next) {
                state = next;
                have = next.have ? { g: next.step, counts: next.have } : null;
                watch = next.watch;
                paintTracker();
            }
        } catch {
            /* no answer: keep what we had */
        } finally {
            asking = false;
        }
        render();
    }

    const open = () => { win.show(); render(); refresh(); };
    const toggle = () => { if (win.isOpen()) win.hide(); else open(); };

    win.body.addEventListener('click', event => {
        if (event.target.closest('.qwin')) api.actions.perform('window', { name: 'Quest', open: true });
        const link = event.target.closest('.route');
        if (link) {
            const cur = state && state.step <= LAST ? STEPS[state.step - 1] : STEPS[0];
            const route = link.dataset.spot != null ? cur.spots?.[Number(link.dataset.spot)] : cur.route;
            const note = now.querySelector('.route-note');
            if (route && !openRoute(route) && note) {
                note.textContent = `Close the NPC dialog first, or type: /navi ${route.map} ${route.x}/${route.y}`;
            }
        }
    });

    api.on('server:event', ({ command, text }) => {
        if (command !== 'chronicle') return;
        const items = /^items (\d+) ?(.*)$/.exec(text);
        const seen = /^watch ?(.*)$/.exec(text);
        if (items) setHave(Number(items[1]), parseHave(items[2]));
        else if (seen) { watch = parseWatch(seen[1]); if (win.isOpen()) render(); }
        else if (text === 'open') open();
        else if (text === 'refresh' && win.isOpen()) refresh();
    });

    // Only in game, like the in-game database's button.
    let inGame = false;
    let launcher = null;
    const setInGame = value => {
        inGame = value;
        launcher?.classList.toggle('ingame', value);
        if (!value && win.isOpen()) win.hide();
    };
    // The first map asks the server once, so the tracker has item counts right
    // away (the server only sends them again when they change).
    let primed = false;
    api.on('map:enter', ({ name }) => {
        curMap = mapName(name);
        setInGame(true);
        if (win.isOpen() || !primed) refresh();
        primed = true;
    }, { replay: true });
    api.on('map:leave', () => setInGame(false));

    const onKey = event => { if (inGame && event.altKey && event.code === 'KeyB') { event.preventDefault(); toggle(); } };
    addEventListener('keydown', onKey, true);
    api.cleanup(() => removeEventListener('keydown', onKey, true));

    if (parameters?.show_button !== false) {
        const host = document.createElement('div');
        const root = host.attachShadow({ mode: 'open' });
        root.innerHTML = `<style>${STYLE}</style><button class="launcher${inGame ? ' ingame' : ''}" title="Adventurer's Chronicle (Alt+B)">Journal</button>`;
        launcher = root.querySelector('button');
        launcher.addEventListener('mousedown', event => event.stopImmediatePropagation());
        launcher.addEventListener('click', toggle);
        document.body.appendChild(host);
        api.cleanup(() => host.remove());
    }

    render();
}
