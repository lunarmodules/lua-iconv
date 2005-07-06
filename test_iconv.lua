
cd = iconv.new("utf-8", "iso-8859-1")
-- cd = iconv.new("utf-8//IGNORE", "iso-8859-1")
-- cd = iconv.new("utf-8//TRANSLIT", "iso-8859-1")

assert(cd, 'Invalid conversion')

ret, err = cd:iconv('Isso é um teste com acentuação')

if err == iconv.ERROR_INCOMPLETE then
  print('Error: Incomplete input.')
elseif err == iconv.ERROR_INVALID then
  print('Error: Invalid input.')
elseif err == nil then
  print('Result: ', ret)
end

