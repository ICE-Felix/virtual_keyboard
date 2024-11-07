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
  ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return KeyboardViewInsets(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        // bottomSheet: TextFieldTapRegion(
        //   child: VirtualKeyboard(
        //     textEditingController: _textEditingController,
        //     scrollController: _scrollController,
        //   ),
        // ),
        body: Builder(builder: (contextBuilder) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SafeArea(
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      scrollController: _scrollController,
                      controller: _textEditingController,
                      keyboardType: TextInputType.none,
                      onTap: () {
                        _overlayEntry?.remove();
                        _overlayEntry = OverlayEntry(
                          builder: (context) {
                            return Localizations.override(
                              // Make sure to inject the same locale the math field uses in order
                              // to match the decimal separators.
                              context: context,
                              locale: Localizations.localeOf(contextBuilder),
                              child: VirtualKeyboard(
                                scrollController: _scrollController,
                                textEditingController: _textEditingController,
                                // Note that we need to pass the insets state like this because the
                                // overlay context does not have the ancestor state.
                                insetsState:
                                    KeyboardViewInsetsState.of(contextBuilder),
                              ),
                            );
                          },
                        );

                        Overlay.of(context).insert(_overlayEntry!);
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
          );
        }),
      ),
    );
  }
}
