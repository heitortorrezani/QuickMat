import 'dart:async';

import 'package:embrasa2/pages/matematica/matematica.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaitVotos extends StatefulWidget {
  const WaitVotos({Key? key}) : super(key: key);

  @override
  State<WaitVotos> createState() => _WaitVotosState();
}

class _WaitVotosState extends State<WaitVotos> {
  late Future<Map<String, int>> _quantidadeNomesFuture;
  late Timer timer;
  bool _timerAtivo = true;

  @override
  void initState() {
    super.initState();
    print('cheguei wait votos / wait votos');
    _quantidadeNomesFuture = calcularQuantidadeNomes();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerAtivo) {
        navegar();
      }
    });
  }

  var statusParametros;
  Future<void> navegar() async {
    Future.delayed(const Duration(seconds: 30), () {
      FirebaseFirestore.instance
          .collection('parametros')
          .doc('fkm2xe8krQ5F0Qsy5OIV')
          .update({'status': 'matematica'});
    });
    try {
      DocumentSnapshot statusDoc = await FirebaseFirestore.instance
          .collection('parametros')
          .doc('fkm2xe8krQ5F0Qsy5OIV')
          .get();

      statusParametros = statusDoc.data().toString();

      print(statusParametros);

      if (statusParametros == '{status: matematica}') {
        print('navigator wait votos / wait votos');
        _timerAtivo = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const Matematica()),
        );
      }
    } catch (e) {
      print("Erro ao buscar no Firestore: $e");
    }
  }

  Future<Map<String, int>> calcularQuantidadeNomes() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('votos').get();

    final Map<String, int> quantidadeNomes = {};

    querySnapshot.docs.forEach((document) {
      final nome = document['nome'] as String;
      quantidadeNomes[nome] = (quantidadeNomes[nome] ?? 0) + 1;
    });

    return quantidadeNomes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Espere seus colegas votarem',
        style: TextStyle(
          color: Colors.white,
        ),
      )),
      body: FutureBuilder<Map<String, int>>(
        future: _quantidadeNomesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            final quantidadeNomes = snapshot.data!;
            return ListView(
              children: quantidadeNomes.entries.map((entry) {
                final nome = entry.key;
                final quantidade = entry.value;
                return ListTile(
                  title: Text(
                      '$nome: $quantidade vez${quantidade != 1 ? 'es' : ''}',
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
