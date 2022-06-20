import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

mixin PageViewHelper<P extends ProviderHelper> on StatelessWidget {

  late Widget _view;

  Widget getView(BuildContext context) {
    var provider = Provider.of<P>(context);
    provider.getData();
    _view = provider.value;
    return _view;
  }

}

abstract class ProviderHelper extends ChangeNotifier {

  late Widget value;

  void getData();

}