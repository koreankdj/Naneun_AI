import 'package:flutter/material.dart';
import 'package:nanen_stot/widgets/text_widget.dart';

// origin color
// Color scaffoldBackgroundColor = const Color(0xFF343541);
Color scaffoldBackgroundColor = const Color.fromARGB(255, 169, 155, 181);
Color cardColor = const Color.fromARGB(255, 90, 78, 100);

// List<String> models = [
//   'Model1',
//   'Model2',
//   'Model3',
//   'Model4',
//   'Model5',
//   'Model6',
// ];

// List<DropdownMenuItem<String>>? get getModelsItem {
//   List<DropdownMenuItem<String>>? modelsItems =
//       List<DropdownMenuItem<String>>.generate(
//           models.length,
//           (index) => DropdownMenuItem(
//               value: models[index],
//               child: TextWidget(
//                 label: models[index],
//                 fontSize: 15,
//               )));
//   return modelsItems;
// }

final chatMessages = [
  {
    "msg": "나는 오늘 기분이 너무 좋아.",
    "chatIndex": 0,
  },
  {
    "msg": "그 말을 들으니 저도 너무 기뻐요! 오늘 하루 무슨 일 있으셨나요 ?",
    "chatIndex": 1,
  },
  {
    "msg": "친구랑 오랜만에 만나서 맛있는 것도 먹고, 영화도 보고, 산책도 했어!",
    "chatIndex": 0,
  },
  {
    "msg": "너무 좋았겠는걸요! 오늘 미션은 수행하셨나요?",
    "chatIndex": 1,
  },
  {
    "msg": "응응! 오늘 퇴근길에 지하철 한 정거장 일찍 내려서, 집까지 걸어오는 미션이었어.",
    "chatIndex": 0,
  },
  {
    "msg": "집까지 오는 길에 무엇을 하면서 걸으셨나요? 밤공기는 어땠나요?",
    "chatIndex": 1,
  }
];
