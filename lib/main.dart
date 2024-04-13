import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(BankApp());

class BankApp extends StatelessWidget {
  BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //body: ListaTransferencias(),
        body: Dashboard(),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaTransferencias(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[200],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Transferências',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
            ),
            SizedBox(height: 20), // Espaçamento entre os botões
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaContatos(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
                padding: EdgeInsets.symmetric(horizontal: 55, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Contatos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Transferencias

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  FormularioTransferencia({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Nova Transferência',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Editor(
            controlador: _controladorCampoNumeroConta,
            rotulo: 'Numero da Conta',
            dica: '0000',
          ),
          Editor(
            controlador: _controladorCampoValor,
            rotulo: 'Valor',
            dica: '0.00',
            icone: Icons.monetization_on,
          ),
          ElevatedButton(
            child: Text('Confirmar'),
            onPressed: () {
              _criaTransferencia(
                context,
                _controladorCampoNumeroConta,
                _controladorCampoValor,
              );
            },
          ),
        ],
      ),
    );
  }

  void _criaTransferencia(
    BuildContext context,
    controladorCampoNumeroConta,
    controladorCampoValor,
  ) {
    final int? numeroConta = int.tryParse(controladorCampoNumeroConta.text);
    final double? valor = double.tryParse(controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      debugPrint('$transferenciaCriada');
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  Editor({super.key, this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          icon: icone != null
              ? Icon(
                  icone,
                  color: Colors.green,
                )
              : null,
          labelText: rotulo,
          hintStyle: TextStyle(color: Colors.grey),
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTransferencias extends StatefulWidget {
  ListaTransferencias({super.key});
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Transferências',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          final Future<Transferencia?> future = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormularioTransferencia();
              },
            ),
          );
          future.then(
            (transferenciaRecebida) {
              debugPrint('chegou no then do future');
              debugPrint('$transferenciaRecebida');
              if (transferenciaRecebida != null) {
                setState(() {
                  widget._transferencias.add(transferenciaRecebida);
                });
              }
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia, {super.key});

  @override
  Widget build(BuildContext context) {
    // Formata o valor da transferência com máscara BRL
    final valorFormatado = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(_transferencia.valor);

    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: Colors.green),
        title: Text(valorFormatado),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}

// Contatos

class ItemContato extends StatelessWidget {
  final Contato _contato;

  ItemContato(this._contato, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.people, color: Colors.green),
        //title: Text(_contato.nome),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Nome: '),
                Text(_contato.nome),
              ],
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Endereço: '),
                Text(_contato.endereco),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text('Telefone: '),
                Text(_contato.telefone),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text('Email: '),
                Text(_contato.email),
              ],
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text('CPF: '),
                Text(_contato.cpf),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Contato {
  String nome = "";
  String endereco = "";
  String telefone = "";
  String email = "";
  String cpf = "";

  Contato(this.nome, this.endereco, this.telefone, this.email, this.cpf);

  @override
  String toString() {
    return 'Contato{nome: $nome, endereco: $endereco, telefone: $telefone, email: $email, cpf: $cpf}';
  }
}

class ListaContatos extends StatefulWidget {
  ListaContatos({super.key});
  final List<Contato> _contatos = [];

  @override
  State<StatefulWidget> createState() {
    return ListaContatosState();
  }
}

class FormularioContato extends StatelessWidget {
  final TextEditingController _controladorCampoNome = TextEditingController();
  final TextEditingController _controladorCampoEndereco =
      TextEditingController();
  final TextEditingController _controladorCampoTelefone =
      TextEditingController();
  final TextEditingController _controladorCampoEmail = TextEditingController();
  final TextEditingController _controladorCampoCpf = TextEditingController();

  FormularioContato({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Novo Contato',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Editor(
            controlador: _controladorCampoNome,
            //rotulo: 'Nome',
            dica: 'Nome',
          ),
          Editor(
            controlador: _controladorCampoEndereco,
            //rotulo: 'Valor',
            dica: 'Endereço',
          ),
          Editor(controlador: _controladorCampoTelefone, dica: 'Telefone'),
          Editor(controlador: _controladorCampoEmail, dica: 'Email'),
          Editor(
            controlador: _controladorCampoCpf,
            dica: 'Cpf',
          ),
          ElevatedButton(
            child: Text('Confirmar'),
            onPressed: () {
              _criaContato(
                  context,
                  _controladorCampoNome,
                  _controladorCampoEndereco,
                  _controladorCampoTelefone,
                  _controladorCampoEmail,
                  _controladorCampoCpf);
            },
          ),
        ],
      ),
    );
  }

  void _criaContato(
      BuildContext context,
      controladorCampoNome,
      controladorCampoEndereco,
      controladorCampoTelefone,
      controladorCampoEmail,
      controladorCampoCpf) {
    final String? nome = controladorCampoNome.text;
    final String? endereco = controladorCampoEndereco.text;
    final String? telefone = controladorCampoTelefone.text;
    final String? email = controladorCampoEmail.text;
    final String? cpf = controladorCampoCpf.text;
    if (nome != null &&
        endereco != null &&
        telefone != null &&
        email != null &&
        cpf != null) {
      final contatoCriado = Contato(nome, endereco, telefone, email, cpf);
      Navigator.pop(context, contatoCriado);
    }
  }
}

class ListaContatosState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Contatos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget._contatos.length,
        itemBuilder: (context, indice) {
          final contato = widget._contatos[indice];
          return ItemContato(contato);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          final Future<Contato?> future = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormularioContato();
              },
            ),
          );
          future.then(
            (contatoCadastrado) {
              if (contatoCadastrado != null) {
                setState(() {
                  widget._contatos.add(contatoCadastrado);
                });
              }
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
