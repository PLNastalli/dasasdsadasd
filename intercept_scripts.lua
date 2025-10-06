--[[
INTERCEPTOR DE SCRIPTS PREMIUM
Este script intercepta e mostra o conteúdo real dos scripts carregados
]]--

-- Salvar o loadstring original
local originalLoadstring = loadstring or load

-- Interceptar loadstring
loadstring = function(code)
    print("🔍 SCRIPT INTERCEPTADO:")
    print("=" .. string.rep("=", 50))
    print(code)
    print("=" .. string.rep("=", 50))
    
    -- Salvar em arquivo
    if writefile then
        local filename = "intercepted_script_" .. tostring(tick()) .. ".lua"
        writefile(filename, code)
        print("💾 Script salvo em: " .. filename)
    end
    
    -- Executar o script original
    return originalLoadstring(code)
end

-- Interceptar game:HttpGet também
local originalHttpGet = game.HttpService.GetAsync or game.HttpGet
if game.HttpService.GetAsync then
    game.HttpService.GetAsync = function(self, url)
        print("🌐 HTTP REQUEST INTERCEPTADO:")
        print("URL: " .. url)
        
        local result = originalHttpGet(self, url)
        
        print("📄 CONTEÚDO RECEBIDO:")
        print("=" .. string.rep("=", 50))
        print(result)
        print("=" .. string.rep("=", 50))
        
        -- Salvar em arquivo
        if writefile then
            local filename = "http_content_" .. tostring(tick()) .. ".lua"
            writefile(filename, result)
            print("💾 Conteúdo salvo em: " .. filename)
        end
        
        return result
    end
end

print("🚀 INTERCEPTOR ATIVADO!")
print("📋 Todos os scripts carregados serão mostrados no console")
print("💾 Scripts serão salvos automaticamente em arquivos")
