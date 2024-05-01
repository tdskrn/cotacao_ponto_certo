String removeSpecialCharacters(String str) {
  Map<String, String> mapaAcentos = {
    "á": "a", "à": "a", "ã": "a", "â": "a",
    "é": "e", "è": "e", "ê": "e",
    "í": "i", "ì": "i", "î": "i",
    "ó": "o", "ò": "o", "õ": "o", "ô": "o",
    "ú": "u", "ù": "u", "û": "u",
    "ç": "c"
    // Adicione outros caracteres conforme necessário
  };

  // Substituir caracteres acentuados pelo seu equivalente não acentuado
  mapaAcentos.forEach((key, value) {
    str = str.replaceAll(key, value);
    str = str.replaceAll(key.toUpperCase(), value.toUpperCase());
  });

  return str;
}
