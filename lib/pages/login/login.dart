import 'dart:html';

import 'package:embrasa2/glabal/global.dart';
import 'package:embrasa2/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Login extends StatelessWidget {
  Login({super.key});

  String nome = LoginFormState().name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  String name = '';
  

  Future<void> deleteCollection() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot snapshot = await firestore.collection('nomes').get();
    final QuerySnapshot snapshot2 = await firestore.collection('votos').get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
    for (DocumentSnapshot doc in snapshot2.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('deletado com sucesso'),
    ));
  }

  @override
  void initState() {
    super.initState();
    name = '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        left: 15,
        right: 15,
        child: Column(
          children: [
            const Text(
              'Digite seu nome',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (String value) {
                setState(() {
                  name = value;
                });
              },
            ),
          ],
        ),
      ),
      Positioned(
        top: 90,
        left: MediaQuery.of(context).size.width / 2 - 60,
        child: ElevatedButton(
          onPressed: () async {

            if(VariaveisGlobais.listaDeAdms.contains(name)) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Nome invalido'),
                ));
            }
            else if (name == 'del') {
              deleteCollection();
            } else {
              if (name == 'torrezaniHeitor') {
                name = 'Heitor';
              } else if (name == 'cardosoJulia') {
                name = 'Julia Cardoso';
              } else if (name == 'diasJulia') {
                name = 'Julia Dias';
              } else if (name == 'gabrielJoao') {
                name = 'Joao';
              } else if (name == 'iagoOp') {
                name = 'Iago';
              }

              VariaveisGlobais.nomeUsuario = name;

              await FirebaseFirestore.instance
                  .collection('nomes')
                  .add({'nome': name});

              await FirebaseFirestore.instance
                  .collection('parametros')
                  .doc('fkm2xe8krQ5F0Qsy5OIV')
                  .update({'status': 'aguardando'});

              Navigator.pushNamed(context, '/wait');
            }
          },
          child: const Text('ENTRAR'),
        ),
      ),
      Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 200,
            height: 180,
            child: const Column(
              children: [
                Text(
                  'Integrantes do grupo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
                Text(
                  'Heitor Torrezani \nJulia Dias \nJulia Leite Cardoso\nIago \nJoao Gabriel',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ),
          ))
    ]);
  }
}
