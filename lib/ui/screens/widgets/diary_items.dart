import 'package:flutter/material.dart';
import 'package:mood_diary/core/models/mood.dart';
import 'package:mood_diary/ui/screens/widgets/division_element_for_slider.dart';

/// Виджет для отображения и управления дневником настроения.
///
/// Пользователь может:
/// - Выбрать одно или несколько чувств.
/// - Выбрать подкатегории чувств.
/// - Настроить уровень стресса и самооценки с помощью ползунков.
/// - Добавить текстовые заметки.
/// - Сохранить данные, если все поля заполнены.
class DiaryItems extends StatefulWidget {
  const DiaryItems({super.key});

  @override
  State<DiaryItems> createState() => _DiaryItemsState();
}

class _DiaryItemsState extends State<DiaryItems> {
  /// Список выбранных индексов чувств.
  List<int> _selectedMoodIndexes = [];

  /// Карта для хранения выбранных подкатегорий чувств по индексам.
  Map<int, String> _selectedSubMoods = {};

  /// Начальное значение для уровня стресса.
  double _stressLevel = 0;

  /// Начальное значение для самооценки.
  double _selfEsteemLevel = 0;

  /// Проверка, было ли изменено значение ползунка стресса.
  bool get _isStressActive => _stressLevel > 0;

  /// Проверка, было ли изменено значение ползунка самооценки.
  bool get _isSelfEsteemActive => _selfEsteemLevel > 0;

  /// Контроллер для поля заметок.
  final TextEditingController _notesController = TextEditingController();

  /// Проверка, активна ли кнопка "Сохранить".
  /// Кнопка активна, если выбрано хотя бы одно чувство, уровень стресса
  /// и самооценки больше 0, и добавлена заметка.
  bool get _isSaveButtonActive {
    return _selectedMoodIndexes.isNotEmpty &&
        _stressLevel > 0 &&
        _selfEsteemLevel > 0 &&
        _notesController.text.isNotEmpty;
  }

  /// Метод для показа SnackBar с текстом "Ок" при успешном сохранении.
  void _showSaveMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ок'),
        duration: Duration(seconds: 2), // Длительность показа сообщения
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose(); // Освобождаем ресурсы контроллера при удалении виджета.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Что чувствуешь?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: moods.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected =
                      _selectedMoodIndexes.contains(index); // Проверка, выбрано ли чувство
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          // Если чувство уже выбрано, убираем его из списка
                          _selectedMoodIndexes.remove(index);
                          _selectedSubMoods.remove(index); // Удаляем выбранное подчувствие
                        } else {
                          // Если чувство не выбрано, добавляем его в список
                          _selectedMoodIndexes.add(index);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 83,
                        height: 118,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                          border: isSelected ? Border.all(color: Colors.orange, width: 2) : null,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                mood.assetPath,
                                fit: BoxFit.cover,
                                height: 50,
                                width: 53,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  mood.label,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            // Отображаем подкатегории для всех выбранных чувств
            if (_selectedMoodIndexes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _selectedMoodIndexes.map((index) {
                  final mood = moods[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: mood.subMoods.map((subMood) {
                          final isSelected = _selectedSubMoods[index] ==
                              subMood; // Проверка, выбрано ли это подчувствие
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSubMoods[index] =
                                    subMood; // Устанавливаем выбранное подчувствие
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.grey[200], // Оранжевый фон для выбранного подчувствия
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                subMood,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black, // Белый текст для выбранного подчувствия
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 6.0),
                    ],
                  );
                }).toList(),
              ),
            SizedBox(height: 16.0),
            Text(
              'Уровень стресса',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DivisionElementForSlider(),
                DivisionElementForSlider(),
                DivisionElementForSlider(),
                DivisionElementForSlider(),
                DivisionElementForSlider(),
                DivisionElementForSlider(),
              ],
            ),
            Slider(
              value: _stressLevel,
              min: 0,
              max: 5,
              // divisions: 5,
              activeColor: _isStressActive
                  ? Colors.orange
                  : Colors.grey, // Активный цвет: оранжевый или серый
              inactiveColor: Colors.grey[300],
              onChanged: (double value) {
                setState(() {
                  _stressLevel = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Низкий'),
                Text('Высокий'),
              ],
            ),
            SizedBox(height: 16.0),
            // Ползунок "Самооценка"
            Text(
              'Самооценка',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DivisionElementForSlider(),
                DivisionElementForSlider(),
                DivisionElementForSlider(),
                DivisionElementForSlider(),
                DivisionElementForSlider(),
                DivisionElementForSlider(),
              ],
            ),
            Slider(
              value: _selfEsteemLevel,
              min: 0,
              max: 5,
              //divisions: 5,
              activeColor: _isSelfEsteemActive
                  ? Colors.orange
                  : Colors.grey, // Активный цвет: оранжевый или серый
              inactiveColor: Colors.grey[300],
              onChanged: (double value) {
                setState(() {
                  _selfEsteemLevel = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Неуверенность'),
                Text('Уверенность'),
              ],
            ),
            SizedBox(height: 16.0),
            // Поле для ввода заметок
            Text(
              'Заметки',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),

            TextField(
              controller: _notesController,
              onChanged: (text) {
                setState(() {}); // Обновляем интерфейс при изменении текста
              },
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Введите заметку',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Кнопка "Сохранить"
            ElevatedButton(
              onPressed: _isSaveButtonActive
                  ? () {
                      // Показать сообщение при сохранении
                      _showSaveMessage(context);
                    }
                  : null, // Неактивная кнопка, если данные не заполнены
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Кнопка на всю ширину
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: _isSaveButtonActive
                    ? Colors.orange
                    : Colors.grey, // Цвет кнопки в зависимости от активности
              ),
              child: Text(
                'Сохранить',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
