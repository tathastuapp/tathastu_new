String convertUnit(int weight) {
  int kilogram = 0, gram = 0;
  if (weight > 1000) {
    kilogram = int.parse((weight / 1000).toString());
    gram = weight % 1000;
  }
  kilogram = 0;
  gram = weight;
  if (kilogram == 0) {
    return '{$gram}gm';
  }
  return '{$kilogram}kg {$gram}gm';
}

String convertUnit2(num weight, String unit) {
  // print('Initialized kilogram = 0 and gram = 0');
  int kilogram, gram;

  if (unit == 'gm') {
    // print('if (unit == gm)');
    if (weight <= 1000) {
      // print('if (weight <= 1000)');
      if (weight == 1000){
        kilogram = 1;
        gram = 0;
      } else{
        kilogram = 0;
      gram = weight;
      }
      
      // print('kilogram = $kilogram kg and gram = $gram gm');
    }else{
      // print('if (weight > 1000)');
      kilogram = weight ~/ 1000;
      gram = (weight % 1000);
      // print('kilogram = $kilogram kg and gram = $gram gm');
    }
  }else{
    // print('if (unit == kg)');
    kilogram = weight;
    gram = 0;
    // print('kilogram = $kilogram kg and gram = $gram gm');
  }

  if (kilogram == 0) {
    // print('${gram}gm');
    return '${gram}gm';
  }
  if(gram == 0){
    // print('${kilogram}kg');
    return '${kilogram}kg';
  }
  // print('${kilogram}kg ${gram}gm');
  return '${kilogram}kg ${gram}gm';
}