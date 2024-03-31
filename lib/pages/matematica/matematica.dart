import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:embrasa2/pages/matematica/perg_mat/espera2/wait2.dart';
import 'package:embrasa2/pages/matematica/perg_mat/perg_mat.dart';
import 'package:embrasa2/pages/sala%20espara/wait.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Matematica extends StatefulWidget {
  const Matematica({Key? key}) : super(key: key);

  @override
  State<Matematica> createState() => _MatematicaState();
}

bool _timerAtivo = true;
class _MatematicaState extends State<Matematica> {
  Set<int> numerosSorteados = Set();
  late int randonInt;

  @override
  void initState() {
    super.initState();
    _timerAtivo = true;
    deleteVotos();
    gerarNumero();
  }

  Future<void> deleteVotos() async {
    final FirebaseFirestore firebase = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firebase.collection('votos').get();
    for(DocumentSnapshot doc in snapshot.docs){
      doc.reference.delete();
    }
  }

  void gerarNumero() {
    do {
      randonInt = Random().nextInt(12);
    } while (numerosSorteados.contains(randonInt));
    numerosSorteados.add(randonInt);
  }

  @override
  Widget build(BuildContext context) {
    print('Este é o numero da pergunta: $randonInt');
    Future.delayed(const Duration(seconds: 30), () {
      if (_timerAtivo) {
        _timerAtivo = false;
        FirebaseFirestore.instance
            .collection('parametros')
            .doc('fkm2xe8krQ5F0Qsy5OIV')
            .update({'status': 'aguadando'});
        //!
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Wait2()),
        );
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Para passar para próxima fase responda esta pergunta:'),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 50,
              left: 30,
              child: Text(
                PergMat().perg[randonInt],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
            const Positioned(
              top: 80,
              left: 30,
              child: Text(
                'Digite a resposta aqui',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Positioned(
                top: 110,
                left: 30,
                child: Container(
                  width: 200,
                  child: TextField(
                    onChanged: (String value) {
                      setState(() {
                        if (value == PergMat().resp[randonInt]) {
                          FirebaseFirestore.instance
                              .collection('parametros')
                              .doc('fkm2xe8krQ5F0Qsy5OIV')
                              .update({'status': 'aguadando'});
                          _timerAtivo = false;
                          //!
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Wait()),
                          );
                        }
                      });
                    },
                  ),
                ))
          ],
        ));
  }
}
