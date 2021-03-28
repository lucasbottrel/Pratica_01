import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Racha Conta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // VARIAVEIS
  final _valorConta = TextEditingController();
  final _quantPessoasBebem = TextEditingController();
  final _quantPessoasNaoBebem = TextEditingController();
  double _currentSliderValue = 0;
  var _infoText = "";
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RACHA CONTA"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
              onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields(){
    _valorConta.text = "";
    _quantPessoasBebem.text="";
    _quantPessoasNaoBebem.text="";
    setState(() {
      _infoText = "";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _editText("Digite o valor da conta: ", _valorConta),
              _editText("Digite o número de pessoas que bebem: ", _quantPessoasBebem),
              _editText("Digite o número de pessoas que não bebem: ", _quantPessoasNaoBebem),
              Text("\nPorcentagem do garçon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
              Slider(value: _currentSliderValue,
                     min: 0,
                     max: 40,
                     divisions: 8,
                     label: _currentSliderValue.round().toString(),
                     onChanged: (double value){
                      setState(() {
                        _currentSliderValue=value.roundToDouble();
                      });
                  }
              ),
              _buttonCalcular(),
              _textInfo(),
            ],
          ),
        ));
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 18,
        color: Colors.indigo,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
      ),
    );
  }

  // PROCEDIMENTO PARA VALIDAR OS CAMPOS
  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "$field";
    }
    return null;
  }

  // Widget button
  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.indigo,
        child:
        Text(
          "CALCULAR TOTAL A PAGAR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()){
            _calculate();
          }
        },
      ),
    );
  }

  // PROCEDIMENTO PARA CALCULAR O IMC
  void _calculate(){
    setState(() {
      double _valorGarcom = ( _currentSliderValue / 100) * double.parse( _valorConta.text);
      double _valorTotal = double.parse( _valorConta.text) + _valorGarcom;

      double bebem = double.parse( _quantPessoasBebem.text);
      double naobebem = double.parse( _quantPessoasNaoBebem.text);

      double _valorIndividualBebem = 0;
      double _valorIndividualNaoBebem = 0;

      if (bebem == 0 && naobebem > 0){
        _valorIndividualNaoBebem = _valorTotal / naobebem;
      } else if (naobebem == 0 && bebem>0){
        _valorIndividualBebem = _valorTotal / bebem;
      } else {
        _valorIndividualBebem = (_valorTotal * 0.6) / bebem;
        _valorIndividualNaoBebem = (_valorTotal * 0.4) / naobebem;
      }

      String res = "Valor Garçom :                                             R\$ " + _valorGarcom.toStringAsPrecision(4) +
                   "\n\nValor Total:                                                   R\$ " + _valorTotal.toStringAsPrecision(4) +
                   "\n\nValor Individual (bebem):                          R\$ " + _valorIndividualBebem.toStringAsPrecision(4) +
                   "\n\nValor Individual (não bebem):                  R\$ " + _valorIndividualNaoBebem.toStringAsPrecision(4);

      _infoText = res;
    });
  }

  // // Widget text
  _textInfo() {
    return Text(
      _infoText,
      textAlign: TextAlign.justify,
      style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
    );
  }
}
