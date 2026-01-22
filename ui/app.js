const app = document.getElementById('app')
const elTitle = document.getElementById('title')
const elRule = document.getElementById('rule')
const elFirst = document.getElementById('firstName')
const elLast = document.getElementById('lastName')
const elErr = document.getElementById('alertErr')
const elOk = document.getElementById('alertOk')

const postNui = async (evt, data = {}) => {
  const res = await fetch(`https://${GetParentResourceName()}/${evt}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data)
  })
  try { return await res.json() } catch { return null }
}

const onlyLetters = (v) => v.replace(/[^a-zA-Z]/g, '')
const cap = (s) => (s ? s.charAt(0).toUpperCase() + s.slice(1).toLowerCase() : s)
const validate = (s) => s.length >= 2 && s.length <= 20 && /^[a-zA-Z]+$/.test(s)

const show = () => { app.classList.remove('hidden') }
const hide = () => { app.classList.add('hidden') }

const setErr = (msg) => { elErr.textContent = msg || ''; elErr.classList.toggle('hidden', !msg); elOk.classList.add('hidden') }
const setOk = (msg) => { elOk.textContent = msg || ''; elOk.classList.toggle('hidden', !msg); elErr.classList.add('hidden') }

const reset = () => { elFirst.value = ''; elLast.value = ''; setErr(''); setOk('') }

const close = async () => { hide(); reset(); await postNui('close', {}) }

const submit = async () => {
  const f = onlyLetters(elFirst.value)
  const l = onlyLetters(elLast.value)
  elFirst.value = f
  elLast.value = l
  if (!validate(f)) return setErr('Vorname muss 2-20 Buchstaben enthalten (nur Buchstaben)')
  if (!validate(l)) return setErr('Nachname muss 2-20 Buchstaben enthalten (nur Buchstaben)')
  await postNui('submit', { firstName: cap(f), lastName: cap(l) })
}

const bindFilter = (el) => {
  el.addEventListener('input', () => { el.value = onlyLetters(el.value) })
  el.addEventListener('paste', (e) => { e.preventDefault(); const t = (e.clipboardData || window.clipboardData).getData('text'); el.value = onlyLetters(t) })
}

bindFilter(elFirst)
bindFilter(elLast)

document.getElementById('close').addEventListener('click', close)
document.getElementById('cancel').addEventListener('click', close)
document.getElementById('submit').addEventListener('click', submit)

window.addEventListener('keydown', (e) => { if (e.key === 'Escape' && !app.classList.contains('hidden')) close() })

window.addEventListener('message', (e) => {
  const d = e.data || {}
  if (d.title) elTitle.textContent = d.title
  if (d.rule) elRule.textContent = d.rule
  if (d.action === 'open') return show()
  if (d.action === 'close') return close()
  if (d.action === 'error') return setErr(d.msg || 'Fehler')
  if (d.action === 'success') return setOk(d.msg || 'OK')
})