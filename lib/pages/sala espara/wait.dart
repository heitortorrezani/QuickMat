import 'dart:async';
import 'dart:math';
import 'package:embrasa2/glabal/global.dart';
import 'package:embrasa2/pages/homePage.dart';
import 'package:embrasa2/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wait extends StatefulWidget {
  const Wait({Key? key}) : super(key: key);

  @override
  _WaitState createState() => _WaitState();
}

class _WaitState extends State<Wait> {
  late Timer _timer;
  bool _timerAtivo = true;
  String statusParametros = '';

  @override
  void initState() {
    super.initState();
    gerarNumero();
    radonF();
    _timerAtivo = true;

    // Inicia o temporizador de dois minutos
    // Atualiza o campo "status" no Firestore para "jogar"
    iniciarTemporizador();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerAtivo) {
        iniciarTemporizadorPegarStatus();
      }
    });
  }

  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Set<int> numerosSorteados = Set();
  int randonInt = 10;

  void gerarNumero() {
    do {
      randonInt = Random().nextInt(12);
      print(randonInt);
    } while (numerosSorteados.contains(randonInt));
    numerosSorteados.add(randonInt);
  }

  Future<void> radonF() async {
    await FirebaseFirestore.instance
        .collection('parametros')
        .doc('perguntas')
        .update({
      'perg': randonInt,
    });
  }

  Future<void> deleteNome() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firestore.collection('nomes').get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('deletado com sucesso'),
    ));
  }

  Future<void> iniciarTemporizador() async {
    await Future.delayed(const Duration(seconds: 30), () {
      if (_timerAtivo) {
        try {
          FirebaseFirestore.instance
              .collection('parametros')
              .doc('fkm2xe8krQ5F0Qsy5OIV')
              .update({
            'status': 'jogar',
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('voce foi enviado para o jogo'),
          ));
        } catch (e) {
          print("Erro ao atualizar no Firestore: $e");
        }
      }
    });
  }

  Future<void> iniciarTemporizadorPegarStatus() async {
    try {
      // Busca o documento com o nome "Status" na coleção "parametros"
      DocumentSnapshot statusDoc = await FirebaseFirestore.instance
          .collection('parametros')
          .doc('fkm2xe8krQ5F0Qsy5OIV')
          .get();

      statusParametros = statusDoc.data().toString();

      print(statusParametros);

      if (statusParametros == '{status: jogar}') {
        _timerAtivo = false;
        //!
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      print("Erro ao buscar no Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (VariaveisGlobais.listaDeAdms.contains(VariaveisGlobais.nomeUsuario)) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'A Paciência é uma Virtude',
            softWrap: true,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 130,
              left: 30,
              child: Container(
                color: Colors.purple[900],
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('nomes')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                          'Erro ao carregar os nomes: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    // Exibir os nomes salvos
                    final List<QueryDocumentSnapshot> documents =
                        snapshot.data!.docs;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: documents
                          .map((QueryDocumentSnapshot document) => Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        deleteNome();
                                      },
                                      icon: Icon(Icons.close)),
                                  Text(
                                    document['nome'],
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'A Paciência é uma Virtude',
            softWrap: true,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 130,
              left: 30,
              child: Container(
                  color: Colors.black,
                  child: Row(children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('nomes')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Erro ao carregar os nomes: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        // Exibir os nomes salvos
                        final List<QueryDocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: documents
                              .map((QueryDocumentSnapshot document) => Text(
                                    document['nome'],
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ])),
            )
          ],
        ),
      );
    }
  }
}
