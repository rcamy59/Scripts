##########################################################
#
# Get-ProductKey.ps1
#     Description  r�cup�re la cl� produit de Windows
#
#    httpwww.powershell-scripting.com
#    La communaut� PowerShell francophone
#
# Usage  PS  .Get-ProductKey.ps1
##########################################################

# Cr�ation de la table de conversion base 24 
$map=BCDFGHJKMPQRTVWXY2346789 

# Lecture de la cl� de registre 
$value = (get-itemproperty HKLMSOFTWAREMicrosoftWindows NTCurrentVersion).digitalproductid[0x34..0x42] 

# Conversion des valeurs en Hexa pour afficher le Raw Key $hexa = 
$value  foreach {
  $hexa = $_.ToString(X2) + $hexa
}
Write-Output Raw Key Big Endian $hexa 

# Calcul du Product Key 
$ProductKey = 
for ($i = 24; $i -ge 0; $i--) {
  $r = 0
  for ($j = 14; $j -ge 0; $j--) {
    $r = ($r  256) -bxor $value[$j]
    $value[$j] = [math]Floor([double]($r24))
    $r = $r % 24
  }
  $ProductKey = $map[$r] + $ProductKey 
  if (($i % 5) -eq 0 -and $i -ne 0) {
    $ProductKey = - + $ProductKey
  }
}
Write-Output Product Key $ProductKey