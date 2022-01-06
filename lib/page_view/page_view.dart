import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PageViewHelper<P extends ProviderHelper> extends StatelessWidget {

  Widget _view;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<P>(context);
    provider.getData();
    _view = provider.value;
    return _view;
  }

}

abstract class ProviderHelper extends ChangeNotifier {

  Widget value;

  void getData();

}