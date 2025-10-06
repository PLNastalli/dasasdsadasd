--[[
HOOK SIMPLES PARA VER CONTEÚDO REAL
Execute este script ANTES do Alchemy Hub
]]--

-- Hook no loadstring
local originalLoadstring = loadstring
loadstring = function(code)
    print("🔍 SCRIPT CARREGADO:")
    print("=" .. string.rep("=", 50))
    print(code)
    print("=" .. string.rep("=", 50))
    
    -- Salvar em arquivo
    if writefile then
        local filename = "script_" .. tostring(tick()) .. ".lua"
        writefile(filename, code)
        print("💾 Salvo em: " .. filename)
    end
    
    return originalLoadstring(code)
end

print("🚀 HOOK SIMPLES ATIVADO!")
print("📋 Execute o Alchemy Hub agora para ver o conteúdo real")
