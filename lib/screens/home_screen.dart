part of screens;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTorchSwitchedOn = false;
  static const platform = MethodChannel('example.com/channel');

  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void setTorchStatus(bool value) {
    setState(() {
      isTorchSwitchedOn = value;
    });
  }

  Future<void> _handelTorchOperation() {
    if (isTorchSwitchedOn) {
      return _switchOffTorch();
    } else {
      return _switchOnTorch();
    }
  }

  Future<void> _switchOnTorch() async {
    try {
      await platform.invokeMethod('switchOnTorch');
      setTorchStatus(true);
    } on PlatformException catch (_) {
      _showSnackbar("Flash Light is not available on this device");
    }
  }

  Future<void> _switchOffTorch() async {
    try {
      await platform.invokeMethod('switchOffTorch');
      setTorchStatus(false);
    } on PlatformException catch (e) {
      _showSnackbar(e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _handelTorchOperation,
              child: Text(
                "Switch ${isTorchSwitchedOn == true ? 'Off' : 'On'} Torch",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
