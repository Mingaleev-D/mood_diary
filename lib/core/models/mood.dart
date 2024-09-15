class Mood {
  final String assetPath;
  final String label;
  final List<String> subMoods;

  Mood({required this.assetPath, required this.label, required this.subMoods});
}

// Список чувств с путями к изображениям
final List<Mood> moods = [
  Mood(
      assetPath: 'assets/icons/joy.png',
      label: 'Радость',
      subMoods: ['Возбуждение', 'Восторг', 'Игривость', 'Наслаждение']),
  Mood(
      assetPath: 'assets/icons/fear.png',
      label: 'Страх',
      subMoods: ['Тревога', 'Паника', 'Беспокойство']),
  Mood(assetPath: 'assets/icons/rabies.png', label: 'Бешенство', subMoods: ['Гнев', 'Раздражение']),
  Mood(assetPath: 'assets/icons/sadness.png', label: 'Грусть', subMoods: ['Печаль', 'Одиночество']),
  Mood(
      assetPath: 'assets/icons/calmness.png',
      label: 'Спокойствие',
      subMoods: ['Мир', 'Удовлетворение']),
  Mood(assetPath: 'assets/icons/power.png', label: 'Сила', subMoods: ['Уверенность', 'Смелость']),
];
