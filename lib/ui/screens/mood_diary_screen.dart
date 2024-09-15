import 'package:flutter/material.dart';
import 'package:mood_diary/ui/screens/calendar_screen.dart';
import 'package:mood_diary/ui/screens/widgets/diary_items.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

/// Основной экран дневника настроения, который включает две вкладки:
/// 1. Дневник настроения — возможность отслеживать настроение.
/// 2. Статистика — отображение статистики (пока заглушка).
///
/// Также содержит кнопку для перехода на экран с календарем.
class MoodDiaryScreen extends StatefulWidget {
  const MoodDiaryScreen({super.key});

  @override
  State<MoodDiaryScreen> createState() => _MoodDiaryScreenState();
}

class _MoodDiaryScreenState extends State<MoodDiaryScreen> {
  /// Текущая дата, которая используется для отображения заголовка.
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      /// Количество вкладок в приложении — 2 (Дневник настроения и Статистика).
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          /// Заголовок приложения, который обновляется в зависимости от текущей даты.
          centerTitle: true,
          title: Text(DateFormat('d MMMM yyyy').format(_focusedDay)),
          actions: [
            /// Кнопка для перехода на экран календаря.
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarScreen()),
                );
              },
              icon: Icon(Icons.calendar_month),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 30,
                child: TabBar(
                  /// Убираем разделитель между вкладками.
                  dividerColor: Colors.transparent,

                  /// Настройка индикатора активной вкладки — закругленный блок с оранжевой заливкой.
                  indicator: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelColor: Colors.white,

                  /// Определяем две вкладки: "Дневник настроения" и "Статистика".
                  tabs: const [
                    /// Первая вкладка — "Дневник настроения"
                    Expanded(
                      child: Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Иконка для вкладки
                            Icon(
                              Icons.message,
                              size: 12,
                            ),
                            SizedBox(width: 8.0),

                            /// Текст заголовка вкладки
                            Text(
                              'Дневник настроения',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Вторая вкладка — "Статистика"
                    Expanded(
                      child: Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.stacked_bar_chart,
                              size: 12,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Статистика',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Основное содержимое экранов под вкладками.
            const Expanded(
              child: TabBarView(
                children: [
                  /// Экран "Дневник настроения" — содержит виджет `DiaryItems`.
                  DiaryItems(),

                  /// Экран "Статистика" — временно заглушка с текстом.
                  Center(
                    child: Text("Statistic Page"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//todo: приходится поззже
/*
  /// Выбранная дата в календаре. По умолчанию не задана.
  DateTime? _selectedDay;

  /// Формат календаря (месяц или год). Используется для изменения представления календаря.
  CalendarFormat _calendarFormat = CalendarFormat.month;

  /// Флаг, определяющий, находится ли пользователь в представлении календаря года.
  bool _isYearView = false;
 */
