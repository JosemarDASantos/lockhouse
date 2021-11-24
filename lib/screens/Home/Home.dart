import 'package:flutter/material.dart';
import 'package:lockhouse/util/Navigator.dart';
import 'package:flutter/widgets.dart';
import 'package:lockhouse/mqtt/hivemqtt.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var cadeado = "images/aberto.png";
  var value = true;
  var texto = 'Fechar';

  outroFuncao() {
    print('Altera a mensagem do broker');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Lockhouse", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.exit_to_app),
            tooltip: 'Sair',
            onPressed: () {
              FirebaseAuthAppNavigator.goToLogin(context);
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                value ? 'images/aberto.png' : 'images/fechado.png',
                height: 300,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey,
                      fixedSize: const Size(200, 50),
                    ),
                    onPressed: () async {
                      getMqtt();
                    },
                    child: Text(
                      value ? 'Fechar' : 'Abrir',
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
