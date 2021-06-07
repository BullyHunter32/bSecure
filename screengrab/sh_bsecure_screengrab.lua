if not file.Exists("bsecure/screengrabs", "DATA") then
    file.CreateDir("bsecure/screengrabs")
end

if not file.Exists("bsecure/screengrabs/"..(CLIENT and "client" or "server"), "DATA") then
    file.CreateDir("bsecure/screengrabs/"..(CLIENT and "client" or "server"))
end

