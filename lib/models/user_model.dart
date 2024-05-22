import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
// Model é um objeto que guarda estados da classe filha
// no caso aqui a UserModel

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Usuário logado
  User? firebaseUser;
  Map<String, dynamic> userData = {};

  // Variável que indicará quando o UserModel estiver processando alguma informação
  bool isLoading = false;

  // Para acessar o UserModel sem ser pelo ScopedModelDescendant
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  } //Função que é chamada quando o app é aberto

  // Função de Cadastro do Usuário
  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFailure}) {
    isLoading = true;
    // notifica a aplicação/flutter que houve mudança no Model
    notifyListeners();

    // Criando usuário no Firebase
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((auth) async {
      // Caso de sucesso na criação do usuário
      // pegando os dados do usuário
      firebaseUser = auth.user;

      // Para salvar demais informações de cadastro
      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFailure();
      isLoading = false;
      notifyListeners();
    });
  }

  // Função de Login do Usuário
  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFailure}) async {
    isLoading = true;

    // notifica a aplicação/flutter que houve mudança no Model
    notifyListeners();

    // Faz login do usuário no Firebase
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((auth) async {
      firebaseUser = auth.user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFailure();
      isLoading = false;
      notifyListeners();
    });
  }

  // Função de Recuperação de senha do Usuário
  void recoverPass(String email) {
    // envia um e-mail de reset de senha
    _auth.sendPasswordResetEmail(email: email);
  }

  // Função que verifica se o Usuário está logado
  bool isLoogedIn() {
    return firebaseUser != null;
  }

  // Função de Logout do Usuário
  void signOut() async {
    // Faz logout no Firebase
    await _auth.signOut();

    //reseta os dados do usuário
    userData = {};
    firebaseUser = null;

    notifyListeners();
  }

  // Função que salva os dados de cadastro do Usuário
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;

    // Criando uma collection com os dados do usuário no Firebase
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser?.uid)
        .set(userData);
  }

  // Função que retorna os dados de cadastro do Usuário
  Future<void> _loadCurrentUser() async {
    //se o firebaseUser for null, busca o usuário atual
    firebaseUser ??= _auth.currentUser;

    if (firebaseUser != null) {
      DocumentSnapshot<Map<String, dynamic>> docUser = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(firebaseUser!.uid)
          .get();
      userData = docUser.data()!;
    }
    notifyListeners();
  }
}
