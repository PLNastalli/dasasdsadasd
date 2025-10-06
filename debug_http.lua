--[[
DEBUG HTTP REQUESTS
Intercepta todas as requisições HTTP para ver o conteúdo real
]]--

-- Hook no HttpGet
local originalHttpGet = game.HttpGet
game.HttpGet = function(url)
    print("🔍 HTTP REQUEST DETECTADO:")
    print("URL: " .. url)
    
    local success, result = pcall(originalHttpGet, url)
    
    if success then
        print("✅ SUCESSO - Conteúdo recebido:")
        print("=" .. string.rep("=", 60))
        print(result)
        print("=" .. string.rep("=", 60))
        
        -- Salvar em arquivo
        if writefile then
            local filename = "debug_" .. string.gsub(url, "[^%w]", "_") .. "_" .. tostring(tick()) .. ".lua"
            writefile(filename, result)
            print("💾 Salvo em: " .. filename)
        end
    else
        print("❌ ERRO: " .. tostring(result))
    end
    
    return result
end

-- Hook no HttpService também
if game:GetService("HttpService") then
    local httpService = game:GetService("HttpService")
    local originalGetAsync = httpService.GetAsync
    
    httpService.GetAsync = function(self, url)
        print("🔍 HTTP SERVICE REQUEST:")
        print("URL: " .. url)
        
        local success, result = pcall(originalGetAsync, self, url)
        
        if success then
            print("✅ CONTEÚDO HTTP SERVICE:")
            print("=" .. string.rep("=", 60))
            print(result)
            print("=" .. string.rep("=", 60))
            
            if writefile then
                local filename = "http_service_" .. string.gsub(url, "[^%w]", "_") .. "_" .. tostring(tick()) .. ".lua"
                writefile(filename, result)
                print("💾 Salvo em: " .. filename)
            end
        else
            print("❌ ERRO HTTP SERVICE: " .. tostring(result))
        end
        
        return result
    end
end

print("🚀 DEBUG HTTP ATIVADO!")
print("📋 Todas as requisições HTTP serão interceptadas")
