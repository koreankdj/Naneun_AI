import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nanen_stot/constants/colors.dart';
import 'package:nanen_stot/constants/constants.dart';
import 'package:nanen_stot/models/chat_model.dart';
import 'package:nanen_stot/providers/chats_provider.dart';
import 'package:nanen_stot/providers/models_provider.dart';
import 'package:nanen_stot/services/api_services.dart';
import 'package:nanen_stot/services/assets_manager.dart';
import 'package:nanen_stot/services/services.dart';
import 'package:nanen_stot/widgets/chat_widget.dart';
import 'package:nanen_stot/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SpeechToText speechToText = SpeechToText();
  var text = "버튼을 누르고 말씀하세요";
  bool _isTyping = false;
  var isListening = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          //child: Image.asset(AssetsManager.openaiLogo),
          //child: Image.asset(timage),
          //child: AssetImage(timage),
        ),
        title: const Text("<나는_> '나'와 대화하기"),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
        //backgroundColor: Colors.deepPurple.shade200,
        backgroundColor: cardColor,
      ),
      // Logo 수정
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length, //chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider
                        .getChatList[index].msg, //chatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                  ); //chatList[index].chatIndex);
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.black,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              //color: Colors.deepPurple.shade200,
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                          );
                        },
                        decoration: InputDecoration.collapsed(
                            hintText: text,
                            hintStyle: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    AvatarGlow(
                      endRadius: 25.0,
                      animate: isListening,
                      duration: const Duration(microseconds: 2000),
                      glowColor: bgColor,
                      repeat: true,
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      showTwoGlows: true,
                      child: GestureDetector(
                        onTapDown: (details) async {
                          if (!isListening) {
                            var available = await speechToText.initialize();
                            if (available) {
                              setState(() {
                                isListening = true;
                                speechToText.listen(
                                  onResult: (result) {
                                    setState(() {
                                      text = result.recognizedWords;
                                    });
                                  },
                                );
                              });
                            }
                          }
                        },
                        onTapUp: (details) {
                          setState(() {
                            isListening = false;
                          });
                          speechToText.stop();
                          textEditingController.text = text;
                          log(text);
                        },
                        child: CircleAvatar(
                          backgroundColor: bgColor,
                          radius: 35,
                          child: Icon(isListening ? Icons.mic : Icons.mic_none,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () async {
                        sendMessageFCT(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        //chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //     message: textEditingController.text,
      //     modelId: modelsProvider.getCurrentModel));
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
