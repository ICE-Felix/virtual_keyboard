import 'package:flutter/material.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return KeyboardViewInsets(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),

        body: Builder(builder: (contextBuilder) {
          return VirtualKeyboardFocusManager(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SafeArea(
                    child: SizedBox(
                      width: 300,
                      child: VirtualKeyboardFocusable(
                        textEditingController: _textEditingController,
                        scrollController: _scrollController,
                        builder: (focusNode) {
                          return TextFormField(
                              focusNode: focusNode,
                              scrollController: _scrollController,
                              controller: _textEditingController,
                              keyboardType: TextInputType.none);
                        },
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SizedBox(
                      width: 300,
                      child: VirtualKeyboardFocusable(
                        textEditingController: _textEditingController2,
                        scrollController: _scrollController2,
                        builder: (focusNode) {
                          return TextFormField(
                              focusNode: focusNode,
                              scrollController: _scrollController2,
                              controller: _textEditingController2,
                              keyboardType: TextInputType.none);
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    // onTap: () {
                    //   Scaffold.of(context).showBottomSheet(
                    //     (context) {
                    //       return TextFieldTapRegion(
                    //         child: VirtualKeyboard(
                    //           textEditingController: _textEditingController,
                    //           scrollController: _scrollController,
                    //         ),
                    //       );
                    //     },
                    //   );
                    // },
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.red,
                    ),
                  ),
                  // TextFieldTapRegion(
                  //   child: VirtualKeyboard(
                  //     textEditingController: _textEditingController,
                  //     scrollController: _scrollController,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
