import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewTEst extends StatefulWidget {
  const NewTEst({Key? key}) : super(key: key);

  @override
  State<NewTEst> createState() => _NewTEstState();
}

class _NewTEstState extends State<NewTEst> {
  final IFrameElement _iframeElement = IFrameElement();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iframeElement.style.height = '100%';
    _iframeElement.style.width = '100%';
    _iframeElement.src =
        // incase of next time if A' keep on showing beside an embedded link....open the file from your local host on chrome..if the A doesn't show..redownload it from chrome itself ..then open the file on vscode remove all the links to personal computer..then upload this new file to firebase
        'https://firebasestorage.googleapis.com/v0/b/bowandbeautiful-3372d.appspot.com/o/policy.html?alt=media&token=2611ff19-a470-4ec7-97a7-2219607f6e70';
    _iframeElement.style.border = 'none';
    _iframeElement.style.border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
  }

  final Widget _iframeWidget = HtmlElementView(
    key: UniqueKey(),
    viewType: 'iframeElement',
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: _iframeWidget,
    );
  }
}
