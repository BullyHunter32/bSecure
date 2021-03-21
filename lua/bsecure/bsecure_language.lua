bSecure.Languages = {}

local tLanguageFiles,_ = file.Find("bsecure/languages/*.json", "LUA")
for _,strLanguageFile in ipairs(tLanguageFiles) do
    local strLanguage = string.Split(strLanguageFile,".json")[1]
    bSecure.Languages[strLanguage] = util.JSONToTable(file.Read("bsecure/languages/"..strLanguageFile,"LUA"))
end

bSecure.Language = "english"

function bSecure:GetLanguage()
    return bSecure.Languages[bSecure.Language]
end

function bSecure:GetPhrase(strPhrase, tReplace)
    local sPhrase = self:GetLanguage()[strPhrase]
    if !tReplace or !sPhrase then return sPhrase end

    for k,v in pairs(tReplace) do
        sPhrase = string.Replace(sPhrase, "{{ ".. k .. " }}", v)
    end
    return sPhrase
end 