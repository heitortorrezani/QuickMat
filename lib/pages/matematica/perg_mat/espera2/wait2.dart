import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:embrasa2/pages/sala%20espara/wait_votos.dart';
import 'package:flutter/material.dart';

class Wait2 extends StatefulWidget {
  const Wait2({Key? key}) : super(key: key);

  @override
  State<Wait2> createState() => _Wait2State();
}

class _Wait2State extends State<Wait2> {
  // ignore: unused_field
  late Timer _timer;
  bool _timerAtivo = true;
  String statusParametros = '';

  @override
  void initState() {
    super.initState();
    _timerAtivo = true;

    statusUpdate();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerAtivo) {
        iniciarTemporizadorPegarStatus();
      }
    });
  }

  Future<void> statusUpdate() async {
    Future.delayed(const Duration(seconds: 60), () {
      if (_timerAtivo) {
        FirebaseFirestore.instance
            .collection('parametros')
            .doc('fkm2xe8krQ5F0Qsy5OIV')
            .update({'status': 'jogar'});
        print('status update / wait 2');
      }
    });
  }

  Future<void> iniciarTemporizadorPegarStatus() async {
    try {
      DocumentSnapshot statusDoc = await FirebaseFirestore.instance
          .collection('parametros')
          .doc('fkm2xe8krQ5F0Qsy5OIV')
          .get();

      statusParametros = statusDoc.data().toString();

      print(statusParametros);

      if (statusParametros == '{status: jogar}') {
        print('navigator wait votos / wait 2');
        _timerAtivo = false;
        //!
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => WaitVotos()),
        );
      }
    } catch (e) {
      print("Erro ao buscar no Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Esperando')),
      body: SizedBox(
        width: mediaquery.width,
        height: mediaquery.height - kToolbarHeight,
        child: const Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_ZTRc7ZzJD4pU8dKEZb19nNq4bPiyMk3PiZvJ7UllCA&s",
                ),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Esperando host',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
