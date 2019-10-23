import 'package:flutter/cupertino.dart';

enum ViewState { Idle, Busy }

class BaseModel extends ChangeNotifier {
  static const String success = "Success";

  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  bool _shouldShowMessage = false;
  bool _isError = false;
  String _message;

  bool disposed = false;

  get message => _message;

  get isError => _isError;

  get shouldShowMessage => _shouldShowMessage;

  BuildContext context;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  void setState(ViewState viewState) {
    _state = viewState;
    if (disposed) return;
    notifyListeners();
  }

  void messageIsShown() {
    _shouldShowMessage = false;
  }

  void showError(ViewState viewState) {
    _state = viewState;
    if (disposed) return;
    notifyListeners();
  }

  void showMessage(String message, bool isError) {
    _shouldShowMessage = true;
    _isError = isError;
    _message = message;
    if (disposed) return;
    notifyListeners();
  }
}
