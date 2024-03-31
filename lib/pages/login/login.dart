import 'package:embrasa2/pages/sala%20espara/wait.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late String name;

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
  }

  @override
  void initState() {
    super.initState();
    name = '';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
              // Salvar nome no Firestore
              if (name == 'del') {
                deleteCollection();
              } else {
                await FirebaseFirestore.instance
                    .collection('nomes')
                    .add({'nome': name});
                //gravar no banco parametros cadastrando
                await FirebaseFirestore.instance
                    .collection('parametros')
                    .doc('fkm2xe8krQ5F0Qsy5OIV')
                    .update({'status': 'aguardando'});
                //!
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
                Text('Integrantes do grupo',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),),
                Text(
                  'Heitor Torrezani \nJulia Dias \nJulia Leite Cardoso\nIago \nJoao Gabriel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}
