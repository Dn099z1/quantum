config = {}

config.general = {
    _defaultPhoto = 'https://host-two-ochre.vercel.app/files/valley_sem_fundo.png',
    staffPermission = 'staff.permissao',
    perms = { 'policia.permissao', 'staff.permissao' }
}

Proxy = module('quantum','lib/Proxy')
Tunnel = module('quantum', 'lib/Tunnel')
quantum = Proxy.getInterface('quantum')

if IsDuplicityVersion() then
    quantumClient = Tunnel.getInterface('quantum')
end