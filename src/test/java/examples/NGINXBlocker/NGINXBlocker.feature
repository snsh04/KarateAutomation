Feature: This feature validates that the NGINX is blocking /services and /carbon URLs
#-------------------------------------------------------------------------------

@NGINXBlocker @parallel=false @All
Scenario Outline: Call  random url with /carbon endpoint and validate the response 
Given url <carbonUrl>
When method get
Then status 404
* print 'Response : ' , response
* match response contains 'API not found /carbon'

Examples:
|carbonUrl             |
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=c%3A%2FWindows%2Fsystem.ini'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%2Fetc%2Fpasswd'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=c%3A%2F'|		
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%2F'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=c%3A%5C'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=WEB-INF%2Fweb.xml'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=WEB-INF%5Cweb.xml'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%2FWEB-INF%2Fweb.xml'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%5CWEB-INF%5Cweb.xml'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=thishouldnotexistandhopefullyitwillnot'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com%2F'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com%3A80%2F'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com%2Fsearch%3Fq%3DOWASP%2520ZAP'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com%3A80%2Fsearch%3Fq%3DOWASP%2520ZAP'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=www.google.com%2F'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=www.google.com%3A80%2F'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=www.google.com'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=www.google.com%2Fsearch%3Fq%3DOWASP%2520ZAP'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=www.google.com%3A80%2Fsearch%3Fq%3DOWASP%2520ZAP'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%3C%21--%23EXEC+cmd%3D%22ls+%2F%22--%3E'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%22%3E%3C%21--%23EXEC+cmd%3D%22ls+%2F%22--%3E%3C'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%3C%21--%23EXEC+cmd%3D%22dir+%5C%22--%3E'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%22%3E%3C%21--%23EXEC+cmd%3D%22dir+%5C%22--%3E%3C'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=0W45pz4p'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query0W45pz4p'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=zApPX16sS'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%27'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%3B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%3B'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%29'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%29'|   	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query+AND+1%3D1+--+'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query+AND+1%3D2+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query+OR+1%3D1+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query+AND+1%3D2+--+'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query+OR+1%3D1+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27+AND+%271%27%3D%271%27+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27+AND+%271%27%3D%272%27+--+'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27+OR+%271%27%3D%271%27+--+'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27+AND+%271%27%3D%272%27+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27+OR+%271%27%3D%271%27+--+'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query+UNION+ALL+select+NULL+--+'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27+UNION+ALL+select+NULL+--+'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22+UNION+ALL+select+NULL+--+'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%29+UNION+ALL+select+NULL+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27%29+UNION+ALL+select+NULL+--+'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%22%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B%24var%3D%22'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%27%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B%24var%3D%27'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%24%7B%40print%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%7D'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%24%7B%40print%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%7D%5C'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%22%2Bresponse.write%28%5B100%2C000*100%2C000%29%2B%22'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%2Bresponse.write%28%7B0%7D*%7B1%7D%29%2B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=response.write%28100%2C000*100%2C000%29'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%26cat+%2Fetc%2Fpasswd%26'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%3Bcat+%2Fetc%2Fpasswd%3B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%26cat+%2Fetc%2Fpasswd%26%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%3Bcat+%2Fetc%2Fpasswd%3B%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27%26cat+%2Fetc%2Fpasswd%26%27'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27%3Bcat+%2Fetc%2Fpasswd%3B%27'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%26sleep+15%26'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%3Bsleep+15%3B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%26sleep+15%26%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%3Bsleep+15%3B%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%26sleep+%7B0%7D%26'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%3Bsleep+%7B0%7D%3B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%26type+%25SYSTEMROOT%25%5Cwin.ini'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%26type+%25SYSTEMROOT%25%5Cwin.ini%26%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27%26type+%25SYSTEMROOT%25%5Cwin.ini%26%27'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%26timeout+%2FT+15'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%7Ctimeout+%2FT+15'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%26timeout+%2FT+15%26%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%7Ctimeout+%2FT+15'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%26timeout+%2FT+%7B0%7D%26'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%7Ctimeout+%2FT+%7B0%7D'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%3Bget-help'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%27%3Bget-help'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%3Bget-help+%23'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%3Bstart-sleep+-s+15'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%22%3Bstart-sleep+-s+15'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%3Bstart-sleep+-s+%7B0%7D'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=query%3Bstart-sleep+-s+15+%23'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=7081561206634333779.owasp.org'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2F7081561206634333779.owasp.org'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=https%3A%2F%2F7081561206634333779.owasp.org'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=http%3A%5C%5C7081561206634333779.owasp.org'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=https%3A%5C%5C7081561206634333779.owasp.org'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%2F%2F7081561206634333779.owasp.org'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=%5C%5C7081561206634333779.owasp.org'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=HtTp%3A%2F%2F7081561206634333779.owasp.org'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=HtTpS%3A%2F%2F7081561206634333779.owasp.org'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=EMaVomjWMiOWIQEoKpSrxTSrYnDsqjDLTuwVyvwnuubGUHsGdqsXoRfrmigXiYdkTqYYqwZWbswxxmKHGldTSyiLQnmvncgBuuiHYpyDTTDcxvUXBgJjtEqkHTenPbLAyeGyfJygbSQTWoRJUsitgQjsKXCUTPDLYctPJOeISsdTXMZgPGNtNSOKjprqlKqoBJkWJsuhWSxLfOkXaOIwSkuhhMEMonZdXkBglBytHlNmQvWRBGBqHHlNwbnUMoqEdisUVaBGKMlkFaITAsQcEYWJjRximRFCjyGLqSCoBadHvFdOVFdwoyUrILJbrrqMigwIeLJKFxIQBKCxmnUpFLvdmcmPkQndlqgwyODAiGQARBHhecJjWNBxJXhJRRiyoAKITlNwWwYLJYRiqXoQCqdSuswmxKYpuMZsLcDTubrCLroRDNUUZXPYNApGGAEUYCYuQqudGwNBqKswJlfYlXVnBnVkxJjqtGeRwgThIOggMfJYuwPKCoqVDvvKXNgdsVPWvwvNyiUdyYyQwPvFejeZdpcvdPQiRIURJqDFfgOCnuBIPDDDUvLfqTAhUIpqkIPZwfvwOHCWuMWAXRijPssHQhDGhiWylJkdiGYZVhEsGjlpUiingFPfovskLyyfpyxCWIXIrtDEacgafkaeCgAuYUaINPuJdrjFUaCJnSOQiaDBaxhSmOMEgBdUFMlovkccdKULJQerCPKcfueXaOZIOUjBcArEuDLENUweTQvkmcTXNiRYCgDeDfxKxtoMyPrjdKlEHGhQclqypCwaGaLvJIwmOTqplAPVVDnChiOCsHaMyqpuUIMOtWdPTHUHhWbwlhNIpvDVMsIQUgOSdKWnsRGUAXSqqVFbhoDuxmetwDSeHenULhdBRALZEHGeuSxfUiZRgqbwpvtrRcEnoDwhmvTdtoHsQeVOLHtgbOwRSHiLpNUWWapwPWYLlCKPXMHDCpfByCSxQZZuPucOugUYbkXojcRPWpvwUjbpxELIpxLHxAMsQtxeppxJugTZmxDyCkmbKGdACBTkNNsfOZkUsuCKvAwragOARAutbganBAaqsJRvABIbXfaqLMbhZkyKeRmcnPoAcShudPIaxNrTsKoJwMfttyuFlIYnTwQKHcQSBJWhYIaWaccqfqKWySCoJiRwpDecQEKpBiJBJprrUZFlynbxPfaLUcapyYemRKUmLwNsEgkSobeADegTOLiBfitMFhMXqDBSYnKEdEZUxhqwqJgaBhHiqhrcdNlmryPLYoUvmJbFZJBsvciQTWdomtFqQWgCyOyNbNNslOjNYSPaxhJxQyaiUnOHnpVgHlxdNMOSthOdVNUrjGfoRlRtPnJcRAbYZbvtbwVbuhEEaqtTHEuStFtuGeUundVfkdOagBtXansRikwPRVJotNmajmtygterGiZZssUVEdgmixxQeYIuTRffnOnMQRgUkqanJbQYDlsokPBXDZaXgCJHsssqmEeCCMLsOwsEgWNXlYXgtEvbsHxLJKPTjHtGfQMoMSagProdZBrSkUgXTvIgvPQmvqouADVIovhtueZOvnwLSDDLXYaFXnRnAruFJQNwKKWWSLItoSmCkIqGFeLErwJtlaCYyFdMYPpeHOBXUeYZUrTFNXbLZhfwUwBHnVWLrcqwZSZmEmdKRBsgpyPuAOYInXmFMpcvWHIJChifCZAqLpyECNKmprvktkZtruBWnkQudKjvCBVPGeXanxpMYQirbbWxdHLguVKBBekbCnJGpdpawnufhxfbMjreNLjoIBWUkTFIipVLuMvKtpClCVeCkwOtOqaMObMXCBVruRaLeHHdxftLuWhTvfxnrenvPYbTWrNKZolEaTUeRnJFIiZsqaMAZdYNhXofpUNqLQuhpMqddCevckbwmvQPlsFNgexFHUnXjWZtQldamfknhrTNoCvUVwypJPGKUEZZMTdgDKokpEcfSyMvgRaxBUmEavowOcjCjRaKmqZjlNxuHJogcIiDeQKUeAawPVyhpAySsAUdrBaZakCwXTxygZRNruBWpZhwrsMTZLXwAJwbsISdRpTtUkBliVrjVxjmJKprmIqvaKInNUSRUrYPOsTPJTtP'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=ZA'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=ZAP%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%0A'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=ZAP+%251%21s%252%21s%253%21s%254%21s%255%21s%256%21s%257%21s%258%21s%259%21s%2510%21s%2511%21s%2512%21s%2513%21s%2514%21s%2515%21s%2516%21s%2517%21s%2518%21s%2519%21s%2520%21s%2521%21n%2522%21n%2523%21n%2524%21n%2525%21n%2526%21n%2527%21n%2528%21n%2529%21n%2530%21n%2531%21n%2532%21n%2533%21n%2534%21n%2535%21n%2536%21n%2537%21n%2538%21n%2539%21n%2540%21n%0A'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=Set-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=any%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=any%3F%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=any%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=any%3F%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=any%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb%0D%0A'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/carbon/?query=any%3F%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb%0D%0A'|  	


@NGINXBlocker @parallel=false @All
Scenario Outline: Call  random url with /services endpoint and validate the response 
Given url <carbonUrl>
When method get
Then status 404
* print 'Response : ' , response
* match response contains 'API not found /services'

Examples:
|carbonUrl             |
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=c%3A%2FWindows%2Fsystem.ini'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%2Fetc%2Fpasswd'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=c%3A%2F'|		
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%2F'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=c%3A%5C'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=WEB-INF%2Fweb.xml'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=WEB-INF%5Cweb.xml'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%2FWEB-INF%2Fweb.xml'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%5CWEB-INF%5Cweb.xml'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=thishouldnotexistandhopefullyitwillnot'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com%2F'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com%3A80%2F'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com%2Fsearch%3Fq%3DOWASP%2520ZAP'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com%3A80%2Fsearch%3Fq%3DOWASP%2520ZAP'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=www.google.com%2F'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=www.google.com%3A80%2F'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=www.google.com'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=www.google.com%2Fsearch%3Fq%3DOWASP%2520ZAP'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=www.google.com%3A80%2Fsearch%3Fq%3DOWASP%2520ZAP'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%3C%21--%23EXEC+cmd%3D%22ls+%2F%22--%3E'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%22%3E%3C%21--%23EXEC+cmd%3D%22ls+%2F%22--%3E%3C'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%3C%21--%23EXEC+cmd%3D%22dir+%5C%22--%3E'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%22%3E%3C%21--%23EXEC+cmd%3D%22dir+%5C%22--%3E%3C'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=0W45pz4p'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query0W45pz4p'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=zApPX16sS'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%27'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%3B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%3B'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%29'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%29'|   	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query+AND+1%3D1+--+'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query+AND+1%3D2+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query+OR+1%3D1+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query+AND+1%3D2+--+'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query+OR+1%3D1+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27+AND+%271%27%3D%271%27+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27+AND+%271%27%3D%272%27+--+'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27+OR+%271%27%3D%271%27+--+'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27+AND+%271%27%3D%272%27+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27+OR+%271%27%3D%271%27+--+'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query+UNION+ALL+select+NULL+--+'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27+UNION+ALL+select+NULL+--+'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22+UNION+ALL+select+NULL+--+'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%29+UNION+ALL+select+NULL+--+'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27%29+UNION+ALL+select+NULL+--+'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%22%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B%24var%3D%22'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%27%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B%24var%3D%27'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%24%7B%40print%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%7D'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%24%7B%40print%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%7D%5C'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%22%2Bresponse.write%28%5B100%2C000*100%2C000%29%2B%22'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%2Bresponse.write%28%7B0%7D*%7B1%7D%29%2B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=response.write%28100%2C000*100%2C000%29'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%26cat+%2Fetc%2Fpasswd%26'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%3Bcat+%2Fetc%2Fpasswd%3B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%26cat+%2Fetc%2Fpasswd%26%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%3Bcat+%2Fetc%2Fpasswd%3B%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27%26cat+%2Fetc%2Fpasswd%26%27'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27%3Bcat+%2Fetc%2Fpasswd%3B%27'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%26sleep+15%26'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%3Bsleep+15%3B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%26sleep+15%26%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%3Bsleep+15%3B%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%26sleep+%7B0%7D%26'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%3Bsleep+%7B0%7D%3B'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%26type+%25SYSTEMROOT%25%5Cwin.ini'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%26type+%25SYSTEMROOT%25%5Cwin.ini%26%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27%26type+%25SYSTEMROOT%25%5Cwin.ini%26%27'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%26timeout+%2FT+15'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%7Ctimeout+%2FT+15'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%26timeout+%2FT+15%26%22'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%7Ctimeout+%2FT+15'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%26timeout+%2FT+%7B0%7D%26'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%7Ctimeout+%2FT+%7B0%7D'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%3Bget-help'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%27%3Bget-help'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%3Bget-help+%23'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%3Bstart-sleep+-s+15'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%22%3Bstart-sleep+-s+15'| 
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%3Bstart-sleep+-s+%7B0%7D'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=query%3Bstart-sleep+-s+15+%23'|	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=7081561206634333779.owasp.org'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2F7081561206634333779.owasp.org'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=https%3A%2F%2F7081561206634333779.owasp.org'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=http%3A%5C%5C7081561206634333779.owasp.org'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=https%3A%5C%5C7081561206634333779.owasp.org'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%2F%2F7081561206634333779.owasp.org'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=%5C%5C7081561206634333779.owasp.org'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=HtTp%3A%2F%2F7081561206634333779.owasp.org'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=HtTpS%3A%2F%2F7081561206634333779.owasp.org'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=EMaVomjWMiOWIQEoKpSrxTSrYnDsqjDLTuwVyvwnuubGUHsGdqsXoRfrmigXiYdkTqYYqwZWbswxxmKHGldTSyiLQnmvncgBuuiHYpyDTTDcxvUXBgJjtEqkHTenPbLAyeGyfJygbSQTWoRJUsitgQjsKXCUTPDLYctPJOeISsdTXMZgPGNtNSOKjprqlKqoBJkWJsuhWSxLfOkXaOIwSkuhhMEMonZdXkBglBytHlNmQvWRBGBqHHlNwbnUMoqEdisUVaBGKMlkFaITAsQcEYWJjRximRFCjyGLqSCoBadHvFdOVFdwoyUrILJbrrqMigwIeLJKFxIQBKCxmnUpFLvdmcmPkQndlqgwyODAiGQARBHhecJjWNBxJXhJRRiyoAKITlNwWwYLJYRiqXoQCqdSuswmxKYpuMZsLcDTubrCLroRDNUUZXPYNApGGAEUYCYuQqudGwNBqKswJlfYlXVnBnVkxJjqtGeRwgThIOggMfJYuwPKCoqVDvvKXNgdsVPWvwvNyiUdyYyQwPvFejeZdpcvdPQiRIURJqDFfgOCnuBIPDDDUvLfqTAhUIpqkIPZwfvwOHCWuMWAXRijPssHQhDGhiWylJkdiGYZVhEsGjlpUiingFPfovskLyyfpyxCWIXIrtDEacgafkaeCgAuYUaINPuJdrjFUaCJnSOQiaDBaxhSmOMEgBdUFMlovkccdKULJQerCPKcfueXaOZIOUjBcArEuDLENUweTQvkmcTXNiRYCgDeDfxKxtoMyPrjdKlEHGhQclqypCwaGaLvJIwmOTqplAPVVDnChiOCsHaMyqpuUIMOtWdPTHUHhWbwlhNIpvDVMsIQUgOSdKWnsRGUAXSqqVFbhoDuxmetwDSeHenULhdBRALZEHGeuSxfUiZRgqbwpvtrRcEnoDwhmvTdtoHsQeVOLHtgbOwRSHiLpNUWWapwPWYLlCKPXMHDCpfByCSxQZZuPucOugUYbkXojcRPWpvwUjbpxELIpxLHxAMsQtxeppxJugTZmxDyCkmbKGdACBTkNNsfOZkUsuCKvAwragOARAutbganBAaqsJRvABIbXfaqLMbhZkyKeRmcnPoAcShudPIaxNrTsKoJwMfttyuFlIYnTwQKHcQSBJWhYIaWaccqfqKWySCoJiRwpDecQEKpBiJBJprrUZFlynbxPfaLUcapyYemRKUmLwNsEgkSobeADegTOLiBfitMFhMXqDBSYnKEdEZUxhqwqJgaBhHiqhrcdNlmryPLYoUvmJbFZJBsvciQTWdomtFqQWgCyOyNbNNslOjNYSPaxhJxQyaiUnOHnpVgHlxdNMOSthOdVNUrjGfoRlRtPnJcRAbYZbvtbwVbuhEEaqtTHEuStFtuGeUundVfkdOagBtXansRikwPRVJotNmajmtygterGiZZssUVEdgmixxQeYIuTRffnOnMQRgUkqanJbQYDlsokPBXDZaXgCJHsssqmEeCCMLsOwsEgWNXlYXgtEvbsHxLJKPTjHtGfQMoMSagProdZBrSkUgXTvIgvPQmvqouADVIovhtueZOvnwLSDDLXYaFXnRnAruFJQNwKKWWSLItoSmCkIqGFeLErwJtlaCYyFdMYPpeHOBXUeYZUrTFNXbLZhfwUwBHnVWLrcqwZSZmEmdKRBsgpyPuAOYInXmFMpcvWHIJChifCZAqLpyECNKmprvktkZtruBWnkQudKjvCBVPGeXanxpMYQirbbWxdHLguVKBBekbCnJGpdpawnufhxfbMjreNLjoIBWUkTFIipVLuMvKtpClCVeCkwOtOqaMObMXCBVruRaLeHHdxftLuWhTvfxnrenvPYbTWrNKZolEaTUeRnJFIiZsqaMAZdYNhXofpUNqLQuhpMqddCevckbwmvQPlsFNgexFHUnXjWZtQldamfknhrTNoCvUVwypJPGKUEZZMTdgDKokpEcfSyMvgRaxBUmEavowOcjCjRaKmqZjlNxuHJogcIiDeQKUeAawPVyhpAySsAUdrBaZakCwXTxygZRNruBWpZhwrsMTZLXwAJwbsISdRpTtUkBliVrjVxjmJKprmIqvaKInNUSRUrYPOsTPJTtP'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=ZA'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=ZAP%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%0A'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=ZAP+%251%21s%252%21s%253%21s%254%21s%255%21s%256%21s%257%21s%258%21s%259%21s%2510%21s%2511%21s%2512%21s%2513%21s%2514%21s%2515%21s%2516%21s%2517%21s%2518%21s%2519%21s%2520%21s%2521%21n%2522%21n%2523%21n%2524%21n%2525%21n%2526%21n%2527%21n%2528%21n%2529%21n%2530%21n%2531%21n%2532%21n%2533%21n%2534%21n%2535%21n%2536%21n%2537%21n%2538%21n%2539%21n%2540%21n%0A'|
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=Set-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=any%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=any%3F%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'|  	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=any%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=any%3F%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=any%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb%0D%0A'|  
|'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/services/?query=any%3F%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb%0D%0A'|  	


@NGINXBlocker @parallel=false @All 
Scenario Outline: Call  jetStar url with /carbon endpoint and validate the response 
Given url <carbonUrl>
When method get
Then status 404
* print 'Response : '
* match response contains 'API not found /carbon'

Examples:
|carbonUrl             |
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=c%3A%2FWindows%2Fsystem.ini'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%2Fetc%2Fpasswd'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=c%3A%2F'|		
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%2F'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=c%3A%5C'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=WEB-INF%2Fweb.xml'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=WEB-INF%5Cweb.xml'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%2FWEB-INF%2Fweb.xml'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%5CWEB-INF%5Cweb.xml'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=thishouldnotexistandhopefullyitwillnot'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com%2F'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com%3A80%2F'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com%2Fsearch%3Fq%3DOWASP%2520ZAP'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2Fwww.google.com%3A80%2Fsearch%3Fq%3DOWASP%2520ZAP'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=www.google.com%2F'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=www.google.com%3A80%2F'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=www.google.com'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=www.google.com%2Fsearch%3Fq%3DOWASP%2520ZAP'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=www.google.com%3A80%2Fsearch%3Fq%3DOWASP%2520ZAP'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%3C%21--%23EXEC+cmd%3D%22ls+%2F%22--%3E'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%22%3E%3C%21--%23EXEC+cmd%3D%22ls+%2F%22--%3E%3C'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%3C%21--%23EXEC+cmd%3D%22dir+%5C%22--%3E'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%22%3E%3C%21--%23EXEC+cmd%3D%22dir+%5C%22--%3E%3C'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=0W45pz4p'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query0W45pz4p'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=zApPX16sS'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%27'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%3B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%3B'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%29'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%29'|   	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query+AND+1%3D1+--+'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query+AND+1%3D2+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query+OR+1%3D1+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query+AND+1%3D2+--+'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query+OR+1%3D1+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27+AND+%271%27%3D%271%27+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27+AND+%271%27%3D%272%27+--+'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27+OR+%271%27%3D%271%27+--+'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27+AND+%271%27%3D%272%27+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27+OR+%271%27%3D%271%27+--+'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query+UNION+ALL+select+NULL+--+'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27+UNION+ALL+select+NULL+--+'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22+UNION+ALL+select+NULL+--+'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%29+UNION+ALL+select+NULL+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27%29+UNION+ALL+select+NULL+--+'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%22%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B%24var%3D%22'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%27%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B%24var%3D%27'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%24%7B%40print%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%7D'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%24%7B%40print%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%7D%5C'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%22%2Bresponse.write%28%5B100%2C000*100%2C000%29%2B%22'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%2Bresponse.write%28%7B0%7D*%7B1%7D%29%2B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=response.write%28100%2C000*100%2C000%29'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%26cat+%2Fetc%2Fpasswd%26'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%3Bcat+%2Fetc%2Fpasswd%3B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%26cat+%2Fetc%2Fpasswd%26%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%3Bcat+%2Fetc%2Fpasswd%3B%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27%26cat+%2Fetc%2Fpasswd%26%27'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27%3Bcat+%2Fetc%2Fpasswd%3B%27'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%26sleep+15%26'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%3Bsleep+15%3B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%26sleep+15%26%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%3Bsleep+15%3B%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%26sleep+%7B0%7D%26'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%3Bsleep+%7B0%7D%3B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%26type+%25SYSTEMROOT%25%5Cwin.ini'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%26type+%25SYSTEMROOT%25%5Cwin.ini%26%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27%26type+%25SYSTEMROOT%25%5Cwin.ini%26%27'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%26timeout+%2FT+15'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%7Ctimeout+%2FT+15'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%26timeout+%2FT+15%26%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%7Ctimeout+%2FT+15'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%26timeout+%2FT+%7B0%7D%26'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%7Ctimeout+%2FT+%7B0%7D'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%3Bget-help'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%27%3Bget-help'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%3Bget-help+%23'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%3Bstart-sleep+-s+15'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%22%3Bstart-sleep+-s+15'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%3Bstart-sleep+-s+%7B0%7D'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=query%3Bstart-sleep+-s+15+%23'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=7081561206634333779.owasp.org'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=http%3A%2F%2F7081561206634333779.owasp.org'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=https%3A%2F%2F7081561206634333779.owasp.org'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=http%3A%5C%5C7081561206634333779.owasp.org'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=https%3A%5C%5C7081561206634333779.owasp.org'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%2F%2F7081561206634333779.owasp.org'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=%5C%5C7081561206634333779.owasp.org'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=HtTp%3A%2F%2F7081561206634333779.owasp.org'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=HtTpS%3A%2F%2F7081561206634333779.owasp.org'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=EMaVomjWMiOWIQEoKpSrxTSrYnDsqjDLTuwVyvwnuubGUHsGdqsXoRfrmigXiYdkTqYYqwZWbswxxmKHGldTSyiLQnmvncgBuuiHYpyDTTDcxvUXBgJjtEqkHTenPbLAyeGyfJygbSQTWoRJUsitgQjsKXCUTPDLYctPJOeISsdTXMZgPGNtNSOKjprqlKqoBJkWJsuhWSxLfOkXaOIwSkuhhMEMonZdXkBglBytHlNmQvWRBGBqHHlNwbnUMoqEdisUVaBGKMlkFaITAsQcEYWJjRximRFCjyGLqSCoBadHvFdOVFdwoyUrILJbrrqMigwIeLJKFxIQBKCxmnUpFLvdmcmPkQndlqgwyODAiGQARBHhecJjWNBxJXhJRRiyoAKITlNwWwYLJYRiqXoQCqdSuswmxKYpuMZsLcDTubrCLroRDNUUZXPYNApGGAEUYCYuQqudGwNBqKswJlfYlXVnBnVkxJjqtGeRwgThIOggMfJYuwPKCoqVDvvKXNgdsVPWvwvNyiUdyYyQwPvFejeZdpcvdPQiRIURJqDFfgOCnuBIPDDDUvLfqTAhUIpqkIPZwfvwOHCWuMWAXRijPssHQhDGhiWylJkdiGYZVhEsGjlpUiingFPfovskLyyfpyxCWIXIrtDEacgafkaeCgAuYUaINPuJdrjFUaCJnSOQiaDBaxhSmOMEgBdUFMlovkccdKULJQerCPKcfueXaOZIOUjBcArEuDLENUweTQvkmcTXNiRYCgDeDfxKxtoMyPrjdKlEHGhQclqypCwaGaLvJIwmOTqplAPVVDnChiOCsHaMyqpuUIMOtWdPTHUHhWbwlhNIpvDVMsIQUgOSdKWnsRGUAXSqqVFbhoDuxmetwDSeHenULhdBRALZEHGeuSxfUiZRgqbwpvtrRcEnoDwhmvTdtoHsQeVOLHtgbOwRSHiLpNUWWapwPWYLlCKPXMHDCpfByCSxQZZuPucOugUYbkXojcRPWpvwUjbpxELIpxLHxAMsQtxeppxJugTZmxDyCkmbKGdACBTkNNsfOZkUsuCKvAwragOARAutbganBAaqsJRvABIbXfaqLMbhZkyKeRmcnPoAcShudPIaxNrTsKoJwMfttyuFlIYnTwQKHcQSBJWhYIaWaccqfqKWySCoJiRwpDecQEKpBiJBJprrUZFlynbxPfaLUcapyYemRKUmLwNsEgkSobeADegTOLiBfitMFhMXqDBSYnKEdEZUxhqwqJgaBhHiqhrcdNlmryPLYoUvmJbFZJBsvciQTWdomtFqQWgCyOyNbNNslOjNYSPaxhJxQyaiUnOHnpVgHlxdNMOSthOdVNUrjGfoRlRtPnJcRAbYZbvtbwVbuhEEaqtTHEuStFtuGeUundVfkdOagBtXansRikwPRVJotNmajmtygterGiZZssUVEdgmixxQeYIuTRffnOnMQRgUkqanJbQYDlsokPBXDZaXgCJHsssqmEeCCMLsOwsEgWNXlYXgtEvbsHxLJKPTjHtGfQMoMSagProdZBrSkUgXTvIgvPQmvqouADVIovhtueZOvnwLSDDLXYaFXnRnAruFJQNwKKWWSLItoSmCkIqGFeLErwJtlaCYyFdMYPpeHOBXUeYZUrTFNXbLZhfwUwBHnVWLrcqwZSZmEmdKRBsgpyPuAOYInXmFMpcvWHIJChifCZAqLpyECNKmprvktkZtruBWnkQudKjvCBVPGeXanxpMYQirbbWxdHLguVKBBekbCnJGpdpawnufhxfbMjreNLjoIBWUkTFIipVLuMvKtpClCVeCkwOtOqaMObMXCBVruRaLeHHdxftLuWhTvfxnrenvPYbTWrNKZolEaTUeRnJFIiZsqaMAZdYNhXofpUNqLQuhpMqddCevckbwmvQPlsFNgexFHUnXjWZtQldamfknhrTNoCvUVwypJPGKUEZZMTdgDKokpEcfSyMvgRaxBUmEavowOcjCjRaKmqZjlNxuHJogcIiDeQKUeAawPVyhpAySsAUdrBaZakCwXTxygZRNruBWpZhwrsMTZLXwAJwbsISdRpTtUkBliVrjVxjmJKprmIqvaKInNUSRUrYPOsTPJTtP'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=ZA'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=ZAP%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%0A'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=ZAP+%251%21s%252%21s%253%21s%254%21s%255%21s%256%21s%257%21s%258%21s%259%21s%2510%21s%2511%21s%2512%21s%2513%21s%2514%21s%2515%21s%2516%21s%2517%21s%2518%21s%2519%21s%2520%21s%2521%21n%2522%21n%2523%21n%2524%21n%2525%21n%2526%21n%2527%21n%2528%21n%2529%21n%2530%21n%2531%21n%2532%21n%2533%21n%2534%21n%2535%21n%2536%21n%2537%21n%2538%21n%2539%21n%2540%21n%0A'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=Set-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=any%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=any%3F%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=any%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=any%3F%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=any%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb%0D%0A'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/carbon/?query=any%3F%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb%0D%0A'|  	


@NGINXBlocker @parallel=false @All
Scenario Outline: Call  jetStar url with /services endpoint and validate the response 
Given url <carbonUrl>
When method get
Then status 404
* print 'Response : ' , response
* match response contains 'API not found /services'

Examples:
|carbonUrl             |
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=c%3A%2FWindows%2Fsystem.ini'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%2Fetc%2Fpasswd'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=c%3A%2F'|		
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%2F'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=c%3A%5C'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=WEB-INF%2Fweb.xml'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=WEB-INF%5Cweb.xml'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%2FWEB-INF%2Fweb.xml'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%5CWEB-INF%5Cweb.xml'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=thishouldnotexistandhopefullyitwillnot'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com%2F'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com%3A80%2F'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com%2Fsearch%3Fq%3DOWASP%2520ZAP'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2Fwww.google.com%3A80%2Fsearch%3Fq%3DOWASP%2520ZAP'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=www.google.com%2F'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=www.google.com%3A80%2F'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=www.google.com'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=www.google.com%2Fsearch%3Fq%3DOWASP%2520ZAP'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=www.google.com%3A80%2Fsearch%3Fq%3DOWASP%2520ZAP'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%3C%21--%23EXEC+cmd%3D%22ls+%2F%22--%3E'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%22%3E%3C%21--%23EXEC+cmd%3D%22ls+%2F%22--%3E%3C'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%3C%21--%23EXEC+cmd%3D%22dir+%5C%22--%3E'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%22%3E%3C%21--%23EXEC+cmd%3D%22dir+%5C%22--%3E%3C'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=0W45pz4p'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query0W45pz4p'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=zApPX16sS'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%27'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%3B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%3B'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%29'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%29'|   	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query+AND+1%3D1+--+'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query+AND+1%3D2+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query+OR+1%3D1+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query+AND+1%3D2+--+'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query+OR+1%3D1+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27+AND+%271%27%3D%271%27+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27+AND+%271%27%3D%272%27+--+'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27+OR+%271%27%3D%271%27+--+'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27+AND+%271%27%3D%272%27+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27+OR+%271%27%3D%271%27+--+'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query+UNION+ALL+select+NULL+--+'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27+UNION+ALL+select+NULL+--+'|	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22+UNION+ALL+select+NULL+--+'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%29+UNION+ALL+select+NULL+--+'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27%29+UNION+ALL+select+NULL+--+'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%22%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B%24var%3D%22'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%27%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B%24var%3D%27'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%24%7B%40print%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%7D'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%24%7B%40print%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%7D%5C'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%3Bprint%28chr%28122%29.chr%2897%29.chr%28112%29.chr%2895%29.chr%28116%29.chr%28111%29.chr%28107%29.chr%28101%29.chr%28110%29%29%3B'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%22%2Bresponse.write%28%5B100%2C000*100%2C000%29%2B%22'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%2Bresponse.write%28%7B0%7D*%7B1%7D%29%2B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=response.write%28100%2C000*100%2C000%29'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%26cat+%2Fetc%2Fpasswd%26'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%3Bcat+%2Fetc%2Fpasswd%3B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%26cat+%2Fetc%2Fpasswd%26%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%3Bcat+%2Fetc%2Fpasswd%3B%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27%26cat+%2Fetc%2Fpasswd%26%27'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27%3Bcat+%2Fetc%2Fpasswd%3B%27'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%26sleep+15%26'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%3Bsleep+15%3B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%26sleep+15%26%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%3Bsleep+15%3B%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%26sleep+%7B0%7D%26'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%3Bsleep+%7B0%7D%3B'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%26type+%25SYSTEMROOT%25%5Cwin.ini'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%26type+%25SYSTEMROOT%25%5Cwin.ini%26%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27%26type+%25SYSTEMROOT%25%5Cwin.ini%26%27'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27%7Ctype+%25SYSTEMROOT%25%5Cwin.ini'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%26timeout+%2FT+15'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%7Ctimeout+%2FT+15'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%26timeout+%2FT+15%26%22'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%7Ctimeout+%2FT+15'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%26timeout+%2FT+%7B0%7D%26'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%7Ctimeout+%2FT+%7B0%7D'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%3Bget-help'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%27%3Bget-help'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%3Bget-help+%23'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%3Bstart-sleep+-s+15'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%22%3Bstart-sleep+-s+15'| 
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%3Bstart-sleep+-s+%7B0%7D'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=query%3Bstart-sleep+-s+15+%23'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=7081561206634333779.owasp.org'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=http%3A%2F%2F7081561206634333779.owasp.org'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=https%3A%2F%2F7081561206634333779.owasp.org'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=http%3A%5C%5C7081561206634333779.owasp.org'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=https%3A%5C%5C7081561206634333779.owasp.org'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%2F%2F7081561206634333779.owasp.org'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=%5C%5C7081561206634333779.owasp.org'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=HtTp%3A%2F%2F7081561206634333779.owasp.org'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=HtTpS%3A%2F%2F7081561206634333779.owasp.org'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=EMaVomjWMiOWIQEoKpSrxTSrYnDsqjDLTuwVyvwnuubGUHsGdqsXoRfrmigXiYdkTqYYqwZWbswxxmKHGldTSyiLQnmvncgBuuiHYpyDTTDcxvUXBgJjtEqkHTenPbLAyeGyfJygbSQTWoRJUsitgQjsKXCUTPDLYctPJOeISsdTXMZgPGNtNSOKjprqlKqoBJkWJsuhWSxLfOkXaOIwSkuhhMEMonZdXkBglBytHlNmQvWRBGBqHHlNwbnUMoqEdisUVaBGKMlkFaITAsQcEYWJjRximRFCjyGLqSCoBadHvFdOVFdwoyUrILJbrrqMigwIeLJKFxIQBKCxmnUpFLvdmcmPkQndlqgwyODAiGQARBHhecJjWNBxJXhJRRiyoAKITlNwWwYLJYRiqXoQCqdSuswmxKYpuMZsLcDTubrCLroRDNUUZXPYNApGGAEUYCYuQqudGwNBqKswJlfYlXVnBnVkxJjqtGeRwgThIOggMfJYuwPKCoqVDvvKXNgdsVPWvwvNyiUdyYyQwPvFejeZdpcvdPQiRIURJqDFfgOCnuBIPDDDUvLfqTAhUIpqkIPZwfvwOHCWuMWAXRijPssHQhDGhiWylJkdiGYZVhEsGjlpUiingFPfovskLyyfpyxCWIXIrtDEacgafkaeCgAuYUaINPuJdrjFUaCJnSOQiaDBaxhSmOMEgBdUFMlovkccdKULJQerCPKcfueXaOZIOUjBcArEuDLENUweTQvkmcTXNiRYCgDeDfxKxtoMyPrjdKlEHGhQclqypCwaGaLvJIwmOTqplAPVVDnChiOCsHaMyqpuUIMOtWdPTHUHhWbwlhNIpvDVMsIQUgOSdKWnsRGUAXSqqVFbhoDuxmetwDSeHenULhdBRALZEHGeuSxfUiZRgqbwpvtrRcEnoDwhmvTdtoHsQeVOLHtgbOwRSHiLpNUWWapwPWYLlCKPXMHDCpfByCSxQZZuPucOugUYbkXojcRPWpvwUjbpxELIpxLHxAMsQtxeppxJugTZmxDyCkmbKGdACBTkNNsfOZkUsuCKvAwragOARAutbganBAaqsJRvABIbXfaqLMbhZkyKeRmcnPoAcShudPIaxNrTsKoJwMfttyuFlIYnTwQKHcQSBJWhYIaWaccqfqKWySCoJiRwpDecQEKpBiJBJprrUZFlynbxPfaLUcapyYemRKUmLwNsEgkSobeADegTOLiBfitMFhMXqDBSYnKEdEZUxhqwqJgaBhHiqhrcdNlmryPLYoUvmJbFZJBsvciQTWdomtFqQWgCyOyNbNNslOjNYSPaxhJxQyaiUnOHnpVgHlxdNMOSthOdVNUrjGfoRlRtPnJcRAbYZbvtbwVbuhEEaqtTHEuStFtuGeUundVfkdOagBtXansRikwPRVJotNmajmtygterGiZZssUVEdgmixxQeYIuTRffnOnMQRgUkqanJbQYDlsokPBXDZaXgCJHsssqmEeCCMLsOwsEgWNXlYXgtEvbsHxLJKPTjHtGfQMoMSagProdZBrSkUgXTvIgvPQmvqouADVIovhtueZOvnwLSDDLXYaFXnRnAruFJQNwKKWWSLItoSmCkIqGFeLErwJtlaCYyFdMYPpeHOBXUeYZUrTFNXbLZhfwUwBHnVWLrcqwZSZmEmdKRBsgpyPuAOYInXmFMpcvWHIJChifCZAqLpyECNKmprvktkZtruBWnkQudKjvCBVPGeXanxpMYQirbbWxdHLguVKBBekbCnJGpdpawnufhxfbMjreNLjoIBWUkTFIipVLuMvKtpClCVeCkwOtOqaMObMXCBVruRaLeHHdxftLuWhTvfxnrenvPYbTWrNKZolEaTUeRnJFIiZsqaMAZdYNhXofpUNqLQuhpMqddCevckbwmvQPlsFNgexFHUnXjWZtQldamfknhrTNoCvUVwypJPGKUEZZMTdgDKokpEcfSyMvgRaxBUmEavowOcjCjRaKmqZjlNxuHJogcIiDeQKUeAawPVyhpAySsAUdrBaZakCwXTxygZRNruBWpZhwrsMTZLXwAJwbsISdRpTtUkBliVrjVxjmJKprmIqvaKInNUSRUrYPOsTPJTtP'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=ZA'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=ZAP%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%25n%25s%0A'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=ZAP+%251%21s%252%21s%253%21s%254%21s%255%21s%256%21s%257%21s%258%21s%259%21s%2510%21s%2511%21s%2512%21s%2513%21s%2514%21s%2515%21s%2516%21s%2517%21s%2518%21s%2519%21s%2520%21s%2521%21n%2522%21n%2523%21n%2524%21n%2525%21n%2526%21n%2527%21n%2528%21n%2529%21n%2530%21n%2531%21n%2532%21n%2533%21n%2534%21n%2535%21n%2536%21n%2537%21n%2538%21n%2539%21n%2540%21n%0A'|
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=Set-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=any%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=any%3F%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'|  	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=any%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=any%3F%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb'| 	
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=any%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb%0D%0A'|  
|'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/services/?query=any%3F%0D%0ASet-cookie%3A+Tamper%3D8186796e-0403-49d8-a1fc-f09b664056cb%0D%0A'|  	

@NGINXBlocker @parallel=false @All
Scenario Outline: Ensure /carbon and /services are not blocked by Admin
Given url Admin
* json myReq = read('<Swagger>.json')
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
* def domain = <domain>
* def basepath = <basepath>
* def path = <path>
* def title = <title>
And request myReq
When method post
Then status <responseCode>   
#* call read('classpath:examples/Polling/Polling.feature') {'Service': 'GetAPIIDFromPublisher.feature'  }
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher: ' , APPIDFromPublisher.APIIDPub
#* def responseFromExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)'  }
#* def responseFromExternalWSO2Gateway = responseFromExternalWSO2Gateway.responseStatus 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }


Examples:
|Swagger                      |title                      |domain      |basepath   |responseCode|path               |
|Swaggerlambda_NGINXBlocker   |'Regtest_lambdacarbon'     |'flight'    |'carbon'   |200         |'quote'            |
|Swaggerlambda_NGINXBlocker   |'Regtest_lambdaservices'   |'customer'  |'services' |200         |'quote'            |
|SwaggerCountries_NGINXBlocker|'Regtest_Countriesservices'|'event'     |'services' |200         |'country/countries'|
|SwaggerCountries_NGINXBlocker|'Regtest_Countriescarbon'  |'partner'   |'carbon'   |200         |'country/countries'|
