--[[
INTERCEPTOR COMPLETO
Intercepta loadstring, HttpGet, e todas as formas de carregar scripts
]]--

local interceptedScripts = {}
local interceptedUrls = {}

-- Função para salvar conteúdo
local function saveContent(content, type, url)
    if not writefile then return end
    
    local timestamp = tostring(tick()):gsub("%.", "_")
    local filename = string.format("%s_%s_%s.lua", type, timestamp, #interceptedScripts + 1)
    
    writefile(filename, content)
    print("💾 Salvo em: " .. filename)
    
    table.insert(interceptedScripts, {
        filename = filename,
        content = content,
        url = url or "N/A",
        timestamp = timestamp
    })
end

-- Interceptar loadstring
local originalLoadstring = loadstring or load
loadstring = function(code)
    print("🔍 LOADSTRING INTERCEPTADO:")
    print("=" .. string.rep("=", 50))
    print(code)
    print("=" .. string.rep("=", 50))
    
    saveContent(code, "loadstring")
    
    return originalLoadstring(code)
end

-- Interceptar load também
if load then
    local originalLoad = load
    load = function(code, chunkname, mode, env)
        print("🔍 LOAD INTERCEPTADO:")
        print("Chunkname: " .. tostring(chunkname))
        print("=" .. string.rep("=", 50))
        print(code)
        print("=" .. string.rep("=", 50))
        
        saveContent(code, "load")
        
        return originalLoad(code, chunkname, mode, env)
    end
end

-- Interceptar HttpGet
local originalHttpGet = game.HttpGet
game.HttpGet = function(url)
    print("🌐 HTTP GET INTERCEPTADO:")
    print("URL: " .. url)
    
    local success, result = pcall(originalHttpGet, url)
    
    if success then
        print("✅ CONTEÚDO HTTP:")
        print("=" .. string.rep("=", 50))
        print(result)
        print("=" .. string.rep("=", 50))
        
        saveContent(result, "http_get", url)
        table.insert(interceptedUrls, {url = url, content = result})
    else
        print("❌ ERRO HTTP: " .. tostring(result))
    end
    
    return result
end

-- Interceptar HttpService
if game:GetService("HttpService") then
    local httpService = game:GetService("HttpService")
    local originalGetAsync = httpService.GetAsync
    
    httpService.GetAsync = function(self, url)
        print("🌐 HTTP SERVICE INTERCEPTADO:")
        print("URL: " .. url)
        
        local success, result = pcall(originalGetAsync, self, url)
        
        if success then
            print("✅ CONTEÚDO HTTP SERVICE:")
            print("=" .. string.rep("=", 50))
            print(result)
            print("=" .. string.rep("=", 50))
            
            saveContent(result, "http_service", url)
        else
            print("❌ ERRO HTTP SERVICE: " .. tostring(result))
        end
        
        return result
    end
end

-- Interceptar request/http_request se existir
if request then
    local originalRequest = request
    request = function(options)
        print("🌐 REQUEST INTERCEPTADO:")
        print("URL: " .. tostring(options.Url))
        
        local result = originalRequest(options)
        
        if result and result.Body then
            print("✅ CONTEÚDO REQUEST:")
            print("=" .. string.rep("=", 50))
            print(result.Body)
            print("=" .. string.rep("=", 50))
            
            saveContent(result.Body, "request", options.Url)
        end
        
        return result
    end
end

-- Função para listar scripts interceptados
local function listIntercepted()
    print("📋 SCRIPTS INTERCEPTADOS:")
    for i, script in ipairs(interceptedScripts) do
        print(string.format("%d. %s (URL: %s)", i, script.filename, script.url))
    end
end

-- Função para mostrar estatísticas
local function showStats()
    print("📊 ESTATÍSTICAS:")
    print("Scripts interceptados: " .. #interceptedScripts)
    print("URLs interceptadas: " .. #interceptedUrls)
end

-- Comandos úteis
_G.interceptor = {
    list = listIntercepted,
    stats = showStats,
    scripts = interceptedScripts,
    urls = interceptedUrls
}

print("🚀 INTERCEPTOR COMPLETO ATIVADO!")
print("📋 Use interceptor.list() para ver scripts interceptados")
print("📊 Use interceptor.stats() para ver estatísticas")
print("💾 Todos os scripts serão salvos automaticamente")
