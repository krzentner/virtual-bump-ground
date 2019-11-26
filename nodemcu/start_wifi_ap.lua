AP_SSID = "virtual-bump-ground"
AP_PASS = "supersecret5432"

print("Setting up WiFI access point.")
print("SSID = " .. AP_SSID)
print("PASSWORD = " .. AP_PASS)

wifi.setcountry({country="US", start_ch=1, end_ch=13, policy=wifi.COUNTRY_AUTO})
wifi.setmode(wifi.SOFTAP)
wifi.ap.config{
  ssid=AP_SSID,
  pwd=AP_PASS,
  hidden=true,
  save=false,
}

wifi.eventmon.register(wifi.eventmon.AP_STACONNECTED, function(T) 
  print("New client with MAC address " .. T.MAC) 
end)
