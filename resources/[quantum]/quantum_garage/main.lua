Proxy = module('quantum', 'lib/Proxy')
Tunnel = module('quantum', 'lib/Tunnel')

config = {}

if (IsDuplicityVersion()) then
    quantum = Proxy.getInterface('quantum')
    quantumClient = Tunnel.getInterface('quantum')
else
    quantum = Proxy.getInterface('quantum')
    quantumServer = Tunnel.getInterface('quantum')

    Text2D = function(font, x, y, text, scale)
        SetTextFont(font)
        SetTextProportional(7)
        SetTextScale(scale, scale)
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0,255)
        SetTextEdge(4, 0, 0, 0, 255)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x, y)
    end
end
