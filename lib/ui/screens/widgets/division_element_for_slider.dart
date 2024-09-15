import 'package:flutter/material.dart';

/// Виджет, представляющий собой элемент деления на ползунке (Slider).
///
/// Это простой контейнер, который отображается в виде маленькой линии (разделителя)
/// с закругленными углами. Он используется как визуальный элемент на шкале ползунка.
class DivisionElementForSlider extends StatelessWidget {
  const DivisionElementForSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      /// Ширина элемента деления.
      width: 2,

      /// Высота элемента деления.
      height: 8,

      /// Оформление контейнера с цветом и закругленными углами.
      decoration: ShapeDecoration(
        color: Color(0xFFE1DCD7), // Цвет разделителя
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Закругление углов
        ),
      ),
    );
  }
}
