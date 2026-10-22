// The Adventurer's Chronicle journal: a window of the plugin's own (api.ui.window)
// that shows every chapter, what you did (finished quests) and what to do now
// (the ongoing quest). The story text is in data.js (generated from
// tools/story.ps1); the server only says where you are, answering
// "@chronicle <n> state" from npc/chronicle.txt with
//   <step>|<base level>|<places found>|<chapters skipped>|<hunt state>|<items in bag>|<watched monsters>|<capped>|<side quests>|<MVPs defeated>
// (places found: the Waykeepers' record, NPCP_WM$; side quests: one
// "step:hunt:items:ro" per Side Quest, ';' between; MVPs: a bit mask)
// Open with Alt+B, the Journal button, the Chronicle book, or @chronicle.

import DATA from './data.js';

const TYPE = { talk: 'Talk', hunt: 'Hunt', deliver: 'Deliver', boss: 'Showdown', report: 'Report', reach: 'Travel', ro: 'RO quest' };

const STYLE = `
* { cursor: inherit !important; }  /* the game draws its own cursor; never show the system one beside it */
.chr { font: 12px Tahoma, Arial, sans-serif; color: #273256; display: flex; flex-direction: column; height: 100%; }
.head { padding: 8px 10px; background: #f3f5fb; border-bottom: 1px solid #c9d1e6; }
.head h2 { margin: 0 0 2px; font-size: 13px; }
.head .meta { color: #667; display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
.head button, .now button { font: inherit; padding: 1px 8px; border: 1px solid #6b7a99; border-radius: 3px;
  background: linear-gradient(#f3f6fd, #d3dbef); color: #273256; cursor: pointer; margin-left: auto; }
.now { margin: 6px 0; padding: 8px 10px; border: 1px solid #e3c766; border-radius: 4px; background: #fffbea; }
.now h3 { margin: 0 0 4px; font-size: 12px; }
/* The ongoing quest: one line in its chapter, the whole card when clicked open. */
details.qnow { border-color: #e3c766; background: #fffbea; margin: 5px 0; }
details.qnow > summary { font-weight: normal; display: block; line-height: 1.4; padding: 4px 8px 4px 22px; position: relative; }
details.qnow > summary::before { position: absolute; left: 6px; top: 7px; }
details.qnow > summary:hover { background: #fff3c4; }
details.qnow > summary b { color: #273256; }
details.qnow:not([open]) > summary::after { content: ' (click for details)'; font-size: 10px; color: #998; }
details.qnow[open] > summary .gist { display: none; }
.qcard { padding: 0 10px 8px; }
.now .tag, .qnow .tag, .side-now .tag { display: inline-block; font-size: 10px; padding: 0 5px; border-radius: 8px; background: #e3c766; color: #4a3a00; margin-right: 4px; }
.now p { margin: 4px 0; line-height: 1.4; }
.obj { margin: 4px 0 0; padding: 0; list-style: none; }
.obj li { padding: 1px 0; line-height: 1.5; }
.obj img { width: 24px; height: 24px; image-rendering: pixelated; vertical-align: middle; margin-right: 6px; }
.ok { color: #2d7a2d; font-weight: bold; }
.warn { color: #a5541a; }
.now .hint { color: #667; font-size: 11px; }
.how { margin: 6px 0 2px; background: #fff; }
.how summary { padding: 3px 8px; }
.how:not([open]) > summary::after { content: 'click to open'; margin-left: auto; font-weight: normal; font-size: 10px; color: #889; }
.how ol { margin: 0; padding: 0 10px 6px 28px; }
.how li { margin: 3px 0; line-height: 1.4; }
.here { margin: 6px 0 2px; }
.here ul { margin: 2px 0; padding-left: 18px; }
.here li { margin: 2px 0; }
.route { color: #c00000; cursor: pointer; text-decoration: underline; font-weight: bold; }
.route:hover { color: #ff0000; }
.follow { margin: 6px 10px 0; padding: 4px 8px; border: 1px solid #9fc49f; border-radius: 4px; background: #eef8ee; color: #2d5a2d;
  display: flex; flex-wrap: wrap; gap: 4px 6px; align-items: center; line-height: 1.4; }
.follow[hidden] { display: none; }
.follow span { flex: 1 1 200px; }
.follow button { font: inherit; padding: 1px 8px; border: 1px solid #6b7a99; border-radius: 3px;
  background: linear-gradient(#f3f6fd, #d3dbef); color: #273256; cursor: pointer; }
.list { overflow: auto; flex: 1; padding: 2px 10px 10px; }
details { border: 1px solid #dfe4f1; border-radius: 4px; margin: 6px 0; background: #fff; }
summary { padding: 5px 8px; cursor: pointer; font-weight: bold; display: flex; gap: 6px; align-items: center; list-style: none; border-radius: 4px; }
/* display: flex drops the browser's own open/close arrow, so draw one: it turns
   down when the fold-out is open. */
summary::-webkit-details-marker { display: none; }
summary::before { content: '\\25B6'; color: #6b7a99; font-size: 9px; width: 10px; text-align: center; flex: none; transition: transform .15s; }
details[open] > summary::before { transform: rotate(90deg); }
summary:hover { background: #eef2fb; }
summary:hover::before { color: #273256; }
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
.tabs { display: flex; gap: 4px; margin-top: 6px; }
.tabs button { font: inherit; padding: 2px 10px; border: 1px solid #b8c2dc; border-bottom: 0; border-radius: 4px 4px 0 0;
  background: #e6eaf4; color: #556; cursor: pointer; margin: 0; }
.tabs button.on { background: #fff; color: #273256; font-weight: bold; }
.side-now { margin: 6px 0; padding: 7px 9px; border: 1px solid #e5a15e; border-radius: 4px; background: #fff7ee; }
.side-now h4 { margin: 0 0 3px; font-size: 12px; }
.st.opt { background: #f6e6d3; color: #8a4b12; }
.badge.side { background: #f6e6d3; color: #8a4b12; }
.quote { color: #556; font-style: italic; margin: 2px 0 6px; line-height: 1.4; }
.pass { margin: 6px 0; padding: 6px 9px; border: 1px solid #c9d1e6; border-radius: 4px; background: #f3f5fb; line-height: 1.5; }
.mvp { display: flex; gap: 8px; align-items: center; padding: 5px 8px; border-bottom: 1px solid #eef0f6; }
.mvp .box { width: 14px; height: 14px; border: 2px solid #c9d1e6; border-radius: 3px; flex: none; text-align: center; line-height: 12px; font-size: 11px; color: #2d7a2d; }
.mvp.got .box { border-color: #2d7a2d; background: #d9f0d9; }
.mvp .nm { flex: 1; }
.mvp .wh { display: block; color: #889; font-size: 11px; }
.mvp .lv { color: #a32f3c; font-weight: bold; white-space: nowrap; }
.mvp.unknown { color: #99a; font-style: italic; }
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
    return { step: Math.max(1, f[0]), level: f[1], waypoints: f[2], skip: f[3] || 0, hunt: f[4], have: parseHave(raw[5]), watch: parseWatch(raw[6]), capped: f[7] === 1,
        sides: parseSides(raw[8]), mvpk: Number(raw[9]) || 0 };
}

/** "1:-1::-1:0;3:1:0,1:-1:0" -> [{ step, hunt, have, ro, fail }]: where each Side Quest stands (step 100: done). */
export function parseSides(text) {
    return String(text || '').split(';').filter(Boolean).map(part => {
        const [step, hunt, have, ro, fail] = part.split(':');
        return { step: Number(step) || 0, hunt: Number(hunt), have: parseHave(have), ro: Number(ro), fail: fail === '1' };
    });
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
    win.body.innerHTML = `<style>${STYLE}</style><div class="chr"><div class="head"></div><div class="follow" hidden></div><div class="list"></div></div>`;
    // 1.4.5: the game's resize grip is an invisible 12 px corner (and its
    // resize cursor never shows under the game's own cursor). Draw it as the
    // usual corner stripes, a little bigger, like the Companions window.
    const frame = win.body.getRootNode();
    if (frame instanceof ShadowRoot) {
        const grip = document.createElement('style');
        grip.textContent = `.grip { width: 16px; height: 16px; z-index: 2; opacity: .75;
  background: linear-gradient(135deg, transparent 0 50%, #6b7a99 50% 57%, transparent 57% 66%, #6b7a99 66% 73%, transparent 73% 82%, #6b7a99 82% 89%, transparent 89%); }
.grip:hover { opacity: 1; }`;
        frame.appendChild(grip);
    }
    const head = win.body.querySelector('.head');
    const list = win.body.querySelector('.list');
    let state = null;
    let asking = false;
    let have = null;	// { g, counts }: a deliver step's items in the bag, from the server
    let watch = null;	// { map, alive }: watched monsters still standing (the Juperos Gate Switches)
    let curMap = '';
    let tracker = null;	// the side quest tracker's list, and the observer on it

    // 1.4.5: every fold-out remembers whether you opened or closed it, across
    // count updates, tab switches and restarts. The keys carry the chapter's or
    // Side Quest's state and the step, so something new starts with its default
    // (a new quest closed, a chapter that just began open).
    const FOLDS = 'adventurers-chronicle:folds';
    let folds = {};
    try { folds = JSON.parse(localStorage.getItem(FOLDS)) || {}; } catch { folds = {}; }
    const opened = (k, def) => (k in folds ? folds[k] : def);
    list.addEventListener('toggle', event => {	// toggle doesn't bubble: catch it on the way down
        const k = event.target.dataset?.k;
        if (!k || folds[k] === event.target.open) return;
        folds[k] = event.target.open;
        try { localStorage.setItem(FOLDS, JSON.stringify(folds)); } catch { /* kept for this session only */ }
        if (/^(ch\d+-cur|sq\d+-on)$/.test(k)) { syncTicks(); paintTracker(); }
    }, true);

    // 1.4.5: a quest folded in the Journal (its chapter, or its Side Quest)
    // leaves the yellow tracker, and comes back when unfolded. The Quest
    // window's own tick does that: the client keeps the unticked quests in
    // memory and the tracker shows the first 4 others, so we click the tick.
    // Until that window is built, the tracker's lines are hidden instead.
    let questRoot = null;	// the Quest window, and the observer on it
    let questObs = null;
    const unticked = new Set();	// quests the client has unticked now, as far as we saw
    const ours = new Set();	// the ones we unticked: we only tick back these
    let clicking = false;
    function trackerOff() {
        const off = [];
        if (!state) return off;
        if (state.step <= LAST) {
            const s = STEPS[state.step - 1];
            if (folds[`ch${s.ch}-cur`] === false) off.push({ id: 77000 + state.step, title: `Chronicle ${s.ch}-${s.k}:` });
        }
        for (const sd of DATA.sides) {
            const k = state.sides?.[sd.n - 1]?.step || 0;
            if (k >= 1 && k < 100 && folds[`sq${sd.n}-on`] === false) off.push({ id: 77100 + sd.n * 10 + k, title: `Side Quest ${sd.n}-${k}:` });
        }
        return off;
    }
    function syncTicks() {
        if (!questRoot || !state) return;
        const off = new Set(trackerOff().map(q => q.id));
        const ids = [77000 + state.step, ...DATA.sides.map(sd => [sd.n, state.sides?.[sd.n - 1]?.step || 0])
            .filter(([, k]) => k >= 1 && k < 100).map(([n, k]) => 77100 + n * 10 + k)];
        for (const id of ids) {
            const box = questRoot.querySelector(`#sid${id}`);
            const hide = off.has(id);
            if (!box || hide === unticked.has(id) || (!hide && !ours.has(id))) continue;
            clicking = true;
            box.click();
            clicking = false;
            if (hide) ours.add(id); else ours.delete(id);
        }
    }
    function watchQuestRoot(root) {
        if (questRoot === root) return;
        questObs?.disconnect();
        questRoot = root;
        questObs = null;
        if (!root) return;
        root.addEventListener('click', event => {
            const box = event.target.closest?.('[id^="sid"]');
            if (!box) return;
            const id = Number(box.id.slice(3));
            if (unticked.has(id)) unticked.delete(id); else unticked.add(id);
            if (!clicking) ours.delete(id);	// a tick you set yourself stays yours
        }, true);
        questObs = new MutationObserver(syncTicks);	// the list is rebuilt on every quest update
        questObs.observe(root, { childList: true, subtree: true });
        syncTicks();
    }

    // The side quest tracker (the client's QuestWindow) lists kill counts under
    // hunt quests. A deliver step gets the same kind of lines for its items,
    // in yellow. The client rebuilds the list on every quest update, so an
    // observer puts them back.
    function paintTracker() {
        const ul = tracker?.ul;
        if (!ul) return;
        const off = trackerOff();
        for (const li of ul.querySelectorAll('.quest-window-li')) {
            const title = li.querySelector('.quest-window-li-title')?.textContent.trim() || '';
            li.style.display = off.some(q => title.startsWith(q.title)) ? 'none' : '';
        }
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
    api.on('ui:append', c => {
        if (c.name === 'QuestWindow') watchTracker(c.root);
        else if (c.root?.querySelector?.('#active-quest-list')) watchQuestRoot(c.root);
    }, { replay: true });
    api.on('ui:remove', c => {
        if (c.name === 'QuestWindow') watchTracker(null);
        else if (c.root && c.root === questRoot) watchQuestRoot(null);
    });
    api.cleanup(() => {
        tracker?.observer.disconnect();
        tracker?.ul.querySelectorAll('.chr-have').forEach(el => el.remove());
        tracker?.ul.querySelectorAll('.quest-window-li').forEach(li => { li.style.display = ''; });
        questObs?.disconnect();
    });

    const icon = async (img, id) => { try { const url = await api.items.icon(id); if (url) img.src = url; } catch { /* no icon */ } };

    function objective(s) {
        const c = s.chapter;
        // Directions where Navigation alone can't get you there (the Culvert
        // Recruiter, the Kafra to Morroc, the Juperos elevator, the Hugel Boatman).
        const hint = s.hint?.length
            ? `<details class="how" data-k="how-${s.ch}-${s.k}"${opened(`how-${s.ch}-${s.k}`, false) ? ' open' : ''}><summary>${s.type === 'boss' ? `How to reach ${escape(s.map)}` : 'How to get there'}</summary><ol>${s.hint.map(h => `<li>${escape(h)}</li>`).join('')}</ol></details>` : '';
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

    // ---- Side Quests, the Passport and the MVP Ledger ----
    const TABS = [['story', 'Story'], ['side', 'Side Quests'], ['mvp', 'MVP Ledger']];
    let tab = 'story';
    const sideState = n => state?.sides?.[n - 1] || { step: 0, hunt: -1, have: null, ro: -1 };
    const sidesOpen = () => DATA.sides.filter(sd => { const k = sideState(sd.n).step; return k >= 1 && k < 100; }).length;
    const routeLink = r => r ? `<span class="route" data-r="${escape(r.map)},${r.x},${r.y}" title="Open Navigation with the way there">${escape(r.name)} (${escape(r.map)} ${r.x}, ${r.y})</span>` : '';

    function sideObjective(sd, s, st) {
        const hk = `howq-${sd.n}-${s.k}`;
        const hint = s.hint?.length ? `<details class="how" data-k="${hk}"${opened(hk, false) ? ' open' : ''}><summary>How to get there</summary><ol>${s.hint.map(h => `<li>${escape(h)}</li>`).join('')}</ol></details>` : '';
        const items = s.items?.length ? s.items.map((it, i) => {
            const n = st.have?.[i];
            return `<li><img data-icon="${it.id}" alt="">${s.any ? 'Carry' : 'Bring'} <b>${it.count} ${escape(it.name)}</b>${n != null ? ` <span class="${n >= it.count ? 'ok' : 'hint'}">(${n} / ${it.count})</span>` : ''}</li>`;
        }).join('') : '';
        const anyNote = s.any ? `<li class="hint">Any ONE of these is enough, and none is used up.</li>` : '';
        let what = '';
        if (s.type === 'hunt') {
            what = `${s.mobs.map(m => `<li>Defeat <b>${m.count} ${escape(m.name)}</b></li>`).join('')}<li>Where: <b>${escape(s.map)}</b></li>
                <li class="${st.hunt === 2 ? 'ok' : ''}">${st.hunt === 2 ? 'All defeated! The Journal will update in a moment.' : 'Live count: quest window (Alt+U). Companion kills count too.'}</li>`;
        } else if (s.type === 'boss') {
            what = `<li>Reach <b>${escape(s.map)}</b>. <b>${escape(s.boss)}</b> will appear a few seconds after you arrive.</li>`;
        } else if (s.type === 'reach') {
            what = `<li>Set foot on <b>${escape(s.map)}</b>.</li>`;
        } else if (s.type === 'ro' && s.label) {
            what = `${items}<li class="hint">Keep it in your bag: the Journal moves on as soon as you have it.</li>`;
        } else if (s.type === 'ro') {
            what = `${items}${anyNote}${s.items?.length && !s.any ? '<li class="hint">The Journal only counts these items; the quest takes them.</li>' : ''}`;
        } else {
            what = `<li>Talk to <b>${escape(sd.npc)}</b> in ${escape(sd.town)} (${sd.x}, ${sd.y}).</li>`;
        }
        // A step made of several talks: tick each one as RO's quest moves on,
        // and route to the first one still to do.
        const parts = s.parts || [];
        const next = parts.find(p => !(st.ro >= p.at));
        if (parts.length) {
            what = parts.map(p => st.ro >= p.at
                ? `<li><span class="ok">&#10003; ${escape(p.name)}</span></li>`
                : `<li>${p === next ? '<b>' : ''}${escape(p.name)}${p === next ? '</b>' : ''}</li>`).join('') + what;
        }
        // Level limits of RO's own part of the step (Orc's Memory: Lv 30-80).
        const lv = state?.level;
        const over = s.maxLv && lv > s.maxLv;
        const lvWarn = over
            ? `<p class="warn">You are level ${lv}: RO only lets in level ${s.minLv || 1} to ${s.maxLv} here.${s.alt ? ` Talk to ${escape(sd.npc)} in ${escape(sd.town)} (${sd.x}, ${sd.y}) instead: this step counts as done after.` : ''}</p>`
            : s.minLv && lv < s.minLv ? `<p class="warn">Needs level ${s.minLv}. You are level ${lv}.</p>` : '';
        const route = over && s.alt ? { map: sd.townMap, x: sd.x, y: sd.y, name: sd.npc } : (next?.route || s.route);
        const spots = (s.spots || []).filter(p => p.map === curMap && (p.ro == null || p.ro === st.ro));
        const here = spots.length ? `<div class="here"><b>Here on ${escape(curMap)}:</b><ul>${spots.map(p => `<li>${routeLink(p)}</li>`).join('')}</ul></div>` : '';
        return `${lvWarn}${what ? `<ul class="obj">${what}</ul>` : ''}${hint}${here || (route ? `<p>Route: ${routeLink(route)}</p>` : '')}`;
    }

    function sidesHtml() {
        const stamps = DATA.sides.filter(sd => sideState(sd.n).step === 100).length;
        const ranks = DATA.ranks.map(r => stamps >= r.need
            ? `<div><span class="ok">&#10003; ${escape(r.name)}</span>: ${escape(r.hat)} (${escape(r.stat)}), yours.</div>`
            : `<div>${escape(r.name)} at ${r.need} stamps: ${escape(r.hat)} (${escape(r.stat)}). ${r.need - stamps} to go.</div>`).join('');
        const pass = `<div class="pass"><b>Adventurer's Passport:</b> ${stamps} stamp${stamps === 1 ? '' : 's'}. Each finished Side Quest stamps it.${ranks}</div>`;
        const body = DATA.sides.map(sd => {
            const st = sideState(sd.n);
            const k = st.step;
            const chapter = DATA.chapters[sd.ch - 1];
            if (k < 1) {
                return `<details data-k="sq${sd.n}-lock"${opened(`sq${sd.n}-lock`, false) ? ' open' : ''}><summary>??? <small>Chapter ${sd.ch}</small><span class="badge lock">Not yet</span></summary>
                    <div class="body"><p class="intro">${escape(chapter.npc)} in ${escape(chapter.townName)} will mention it on the way.</p></div></details>`;
            }
            const done = k === 100;
            const past = sd.steps.filter(s => done || s.k < k).map(s => `<div class="q"><span class="st done">Done</span><b>${escape(s.title)}.</b> ${escape(s.done)}</div>`).join('');
            const cur = done ? null : sd.steps[k - 1];
            const fail = cur && st.fail && sd.failText ? `<p class="warn">${escape(sd.failText)}</p>` : '';
            const now = cur ? `<div class="side-now"><h4><span class="tag">${escape(cur.label || TYPE[cur.type] || 'RO quest')}</span>Step ${cur.k}: ${escape(cur.title)}</h4>
                ${fail}<p>${escape(cur.now)}</p>${sideObjective(sd, cur, st)}</div>` : '';
            const badge = done ? '<span class="badge">Done, stamped</span>' : `<span class="badge side">Optional, Lv ${escape(sd.range)}</span>`;
            const fk = `sq${sd.n}-${done ? 'done' : 'on'}`;
            return `<details data-k="${fk}"${opened(fk, !done) ? ' open' : ''}><summary>${escape(sd.title)} <small>Chapter ${sd.ch}</small>${badge}</summary>
                <div class="body"><p class="quote">${escape(sd.intro)}</p>${past}${now}</div></details>`;
        }).join('');
        return pass + '<p class="hint route-note"></p>' + body + '<p class="hint">Side Quests are optional: the next chapter opens either way. Each gives a costume tied to its place, a small reward and a Passport stamp.</p>';
    }

    function ledgerHtml() {
        const step = state ? state.step : 1;
        const known = m => {
            if (m.g) return step > m.g;
            const k = sideState(m.side).step;
            return k === 100 || (k >= 1 && k > m.k);
        };
        const got = DATA.mvps.filter((m, i) => state && (state.mvpk & (1 << i))).length;
        const rows = DATA.mvps.map((m, i) => {
            if (!known(m)) return `<div class="mvp unknown"><span class="box"></span><span class="nm">???<span class="wh">Someone on your road will mention it.</span></span><span class="lv">Lv ??</span></div>`;
            const dead = state && (state.mvpk & (1 << i));
            const from = m.g ? `Chapter ${Math.floor((m.g - 1) / 5) + 1}` : `Side Quest: ${DATA.sides[m.side - 1].title}`;
            return `<div class="mvp${dead ? ' got' : ''}"><span class="box">${dead ? '&#10003;' : ''}</span><span class="nm"><b>${escape(m.name)}</b>
                <span class="wh">${escape(m.where)} &middot; ${escape(m.map)} &middot; ${escape(from)}${dead ? '' : '. Bring companions.'}</span></span><span class="lv">Lv ${m.lv}</span></div>`;
        }).join('');
        return `<div class="pass"><b>MVP Ledger:</b> ${got} of ${DATA.mvps.length} defeated. Nothing here is required: it is a list of reasons to come back stronger. An MVP is written in when someone mentions it, and ticks itself when you or your party defeat it.</div>${rows}`;
    }

    function render() {
        const step = state ? state.step : 1;
        const finished = step > LAST;
        const cur = finished ? null : STEPS[step - 1];
        const chNow = cur ? cur.ch : DATA.chapters.length;

        head.innerHTML = `<h2>${finished ? 'Your Chronicle is complete' : `Chapter ${cur.ch}: ${escape(cur.chapter.title)}`}</h2>
            <div class="meta">${state ? `<span>Level ${state.level}</span>${state.waypoints > 0 ? `<span>Places found: ${state.waypoints}</span>` : ''}` : '<span>Asking the server...</span>'}
            <button type="button" class="qwin" title="The game's quest window, with live kill counts">Quest window</button></div>
            <div class="tabs">${TABS.map(([id, label]) => `<button type="button" data-tab="${id}" class="${tab === id ? 'on' : ''}">${label}${id === 'side' && sidesOpen() ? ` (${sidesOpen()})` : ''}</button>`).join('')}</div>`;
        if (tab !== 'story') {
            list.innerHTML = tab === 'side' ? sidesHtml() : ledgerHtml();
            win.body.querySelectorAll('img[data-icon]').forEach(img => icon(img, Number(img.dataset.icon)));
            return;
        }

        // 1.4.5: the ongoing quest lives in its chapter, as a line you click
        // open for the whole card (it used to sit above the list, saying it twice).
        let card = '';
        if (cur) {
            const low = state && !state.capped && state.level < cur.lv;
            const spots = here(cur);
            const there = cur.type === 'boss' && curMap === cur.map;
            card = `<p>${escape(cur.now)}</p>${objective(cur)}
                ${there ? `<p class="ok">You made it to ${escape(cur.map)}. Get ready!</p>`
                    : spots || (cur.route ? `<p>Route: <span class="route" title="Open Navigation with the way there">${escape(cur.route.name)} (${escape(cur.route.map)} ${cur.route.x}, ${cur.route.y})</span></p>`
                    : '<p class="hint">Navigation has no route to this map. Follow the directions above.</p>')}
                <p class="hint route-note"></p>
                ${low ? `<p class="warn">Needs level ${cur.lv}. You are level ${state.level}.</p>` : ''}`;
        }

        list.innerHTML = (finished ? `<div class="now"><h3>Champion of Rune-Midgard</h3><p>Every chapter is told. Legends still wait: The Sign and Geffenia, Thanatos Tower, the Abyss Lakes and the Endless Tower.</p></div>` : '')
            + DATA.chapters.map(c => {
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
                        const k = `q${g}`;
                        return `<details class="qnow" data-k="${k}"${opened(k, false) ? ' open' : ''}><summary><span class="st going">Ongoing</span><span class="tag">${TYPE[s.type]}</span><b>Quest ${i + 1}: ${escape(s.title)}.</b><span class="gist"> ${escape(s.now)}</span></summary>
                            <div class="qcard">${card}</div></details>`;
                    }
                    return `<div class="q locked"><b>Quest ${i + 1}:</b> ???</div>`;
                }).join('')}</div>`;
            const k = `ch${c.n}-${locked ? 'lock' : current ? 'cur' : 'done'}`;
            return `<details data-k="${k}"${opened(k, current) ? ' open' : ''}><summary>Chapter ${c.n}: ${escape(c.title)} <small>Lv ${escape(c.range)}</small>${badge}</summary>${body}</details>`;
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
                syncTicks();
            }
        } catch {
            /* no answer: keep what we had */
        } finally {
            asking = false;
        }
        render();
    }

    // Route links (1.4.3): the way is drawn on the ground while the Navigation
    // window stays out of sight. Hidden with visibility, not display: the client
    // stops updating the path once its window is display: none, and its close
    // button and Escape do exactly that (and clear the route). The window comes
    // back when you arrive (within 5 cells, the client's own rule), press Stop or
    // Show map, or the client closes it. A Navigation you opened yourself is left alone.
    const followBar = win.body.querySelector('.follow');
    let follow = null;	// { route, host, obs, timer }
    const navRoot = host => host.shadowRoot || host;
    const showFollow = () => {
        followBar.hidden = !follow;
        if (!follow) return;
        const r = follow.route;
        followBar.innerHTML = `<span>&#10148; Following: <b>${escape(r.name || r.map)}</b> (${escape(r.map)} ${r.x}, ${r.y}). The way is drawn on the ground.</span>
            <button data-follow="map">Show map</button><button data-follow="stop">Stop</button>`;
    };
    function unfollow(close) {
        if (!follow) return;
        const { host, obs, timer } = follow;
        follow = null;
        obs.disconnect();
        clearInterval(timer);
        if (close) navRoot(host).querySelector('.close')?.click();
        host.style.visibility = '';
        host.style.pointerEvents = '';
        showFollow();
    }
    function goRoute(route) {
        const before = document.getElementById('Navigation');
        const mine = !before || getComputedStyle(before).display === 'none' || before === follow?.host;
        if (!openRoute(route)) return false;
        const host = document.getElementById('Navigation');
        if (!host || !mine) return true;
        if (follow) { follow.route = route; showFollow(); return true; }
        host.style.visibility = 'hidden';
        host.style.pointerEvents = 'none';
        const obs = new MutationObserver(() => { if (getComputedStyle(host).display === 'none') unfollow(false); });
        obs.observe(host, { attributes: true, attributeFilter: ['style', 'class'] });
        const timer = setInterval(() => {
            const pos = api.snapshot()?.player?.position;
            const r = follow?.route;
            if (r && pos && curMap === r.map && Math.hypot(pos[0] - r.x, pos[1] - r.y) <= 5) unfollow(true);
        }, 500);
        follow = { route, host, obs, timer };
        showFollow();
        return true;
    }
    api.cleanup(() => unfollow(true));

    const open = () => { win.show(); render(); refresh(); };
    const toggle = () => { if (win.isOpen()) win.hide(); else open(); };

    win.body.addEventListener('click', event => {
        if (event.target.closest('.qwin')) api.actions.perform('window', { name: 'Quest', open: true });
        const tabButton = event.target.closest('[data-tab]');
        if (tabButton) { tab = tabButton.dataset.tab; render(); return; }
        const followButton = event.target.closest('[data-follow]');
        if (followButton) { unfollow(followButton.dataset.follow === 'stop'); return; }
        const link = event.target.closest('.route');
        if (link?.dataset.r) {
            const [map, x, y] = link.dataset.r.split(',');
            const name = link.textContent.replace(/\s*\([^()]*\)\s*$/, '');
            const note = list.querySelector('.route-note');
            if (!goRoute({ map, x: Number(x), y: Number(y), name }) && note) note.textContent = `Close the NPC dialog first, or type: /navi ${map} ${x}/${y}`;
            return;
        }
        if (link) {
            const cur = state && state.step <= LAST ? STEPS[state.step - 1] : STEPS[0];
            const route = link.dataset.spot != null ? cur.spots?.[Number(link.dataset.spot)] : cur.route;
            const note = list.querySelector('.route-note');
            if (route && !goRoute(route) && note) {
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
        // Right after login the server may not answer yet, and the quest list
        // comes in after the map: ask twice more so folded quests leave the
        // tracker without opening the Journal.
        if (!primed) for (const ms of [3000, 8000]) { const t = setTimeout(refresh, ms); api.cleanup(() => clearTimeout(t)); }
        primed = true;
    }, { replay: true });
    api.on('map:leave', ({ reason } = {}) => { if (reason === 'disconnected') unfollow(true); setInGame(false); });

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
