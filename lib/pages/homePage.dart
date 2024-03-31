import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:embrasa2/pages/sala%20espara/wait_votos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'perguntas/question.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _timerAtivo = true;
  final firebase = FirebaseFirestore.instance.collection('parametros');

  void initState() {
    super.initState();
    _timerAtivo = true;
    fimPergunta();
  }

  //responsavel pelo voto
  Future<void> setVoto(bool voto, String name) async {
    try {
      await FirebaseFirestore.instance.collection('votos').add(
        {'voto': voto, 'nome': name},
      );
      print('Nome salvo com sucesso no Firestore!');
    } catch (e) {
      print('Erro ao salvar nome no Firestore: $e');
    }
  }

  Future<void> fimPergunta() async {
    await Future.delayed(const Duration(seconds: 30));
    if (_timerAtivo) {
      //!
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const WaitVotos()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //String perguntas = Question().perguntas[pergunta];
    var mediaquery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Quem é mais provável')),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: const DecorationImage(
                image: NetworkImage(
                    'https://ichef.bbci.co.uk/ace/ws/640/cpsprodpb/164EE/production/_109347319_gettyimages-611195980.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Card(
              child: Container(
                width: 250,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    StreamBuilder(
                      stream: firebase.doc('perguntas').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('error: ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!snapshot.hasData ||
                            snapshot.data!.data() == null) {
                          return Text('Documento não encontrado');
                        }
                        var number = snapshot.data!.get('perg');
                        return Text(
                          Question().perguntas[number],
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: mediaquery.width / 2 - 60,
            bottom: 120,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        height: 400,
                        width: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('nomes')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Erro ao carregar os nomes');
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
                                      .map((QueryDocumentSnapshot document) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        setVoto(true, document['nome']);
                                        _timerAtivo = false;
                                        //!
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const WaitVotos()),
                                        );
                                      },
                                      child: Text(document['nome']),
                                      style: ButtonStyle(
                                          //backgroundColor: MaterialStateProperty.all<Color>(),
                                          ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(
                '  Votar  ',
                style: const TextStyle(
                    fontSize: 20, color: Colors.white), // Cor do texto do botão
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurpleAccent), // Cor do botão
              ),
            ),
          ),
        ],
      ),
    );
  }
}
