import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../providers/cliente_provider.dart';
import './nuevo_cliente.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:json_table/json_table.dart';

class listadoVEN_Cliente extends StatefulWidget {
  String titulo;
  final _provider = new VEN_ClienteProvider();
  List<Cliente> oListaVEN_Cliente = [];
  int codigoVEN_ClienteSeleccionado = 0;
  Cliente oCliente = Cliente();
  String jSonVEN_Cliente = "";
  listadoVEN_Cliente(this.titulo);
  @override
  State<StatefulWidget> createState() => _ListadoVEN_Cliente();
}

class _ListadoVEN_Cliente extends State<listadoVEN_Cliente> {
  final _tfRazonSocial = TextEditingController();
  final _tfRuc = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oCliente.inicializar();
    widget.jSonVEN_Cliente = '[${widget.oCliente.toModelString()}]';
  }

  Future<String> _consultarRegistros() async {
    Cliente pCliente = Cliente();
    pCliente.inicializar();
    pCliente.nombreCliente = _tfRazonSocial.text;
    pCliente.numeroOrdenServicio = _tfRuc.text;

    var oListaVEN_ClienteTmp = await widget._provider.listar(pCliente);
    // ignore: avoid_print
    print(oListaVEN_ClienteTmp);
    setState(() {
      widget.oListaVEN_Cliente = oListaVEN_ClienteTmp;
      widget.jSonVEN_Cliente = widget._provider.jsonResultado;
      if (widget.oListaVEN_Cliente.length == 0) {
        widget.jSonVEN_Cliente = '[${widget.oCliente.toModelString()}]';
      }
    });
    return "Procesado";
  }

  void _nuevoRegistro() {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return NuevoVEN_Cliente("", 0);
    }));
  }

  void _verRegistro(int pCodigoCliente) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return NuevoVEN_Cliente("", pCodigoCliente);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(widget.jSonVEN_Cliente);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Consulta de Servicios "),
          actions: [
            IconButton(
                icon: const Icon(Icons.search), onPressed: _consultarRegistros),
            IconButton(
                icon: const Icon(Icons.assignment_outlined),
                onPressed: _nuevoRegistro),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Para consultar completar el nombre del Servicio y dar click en consultar",
                style: TextStyle(fontSize: 12),
              ),
              TextField(
                  controller: _tfRazonSocial,
                  decoration: const InputDecoration(
                    hintText: "Ingrese Nombre de Cliente ",
                    labelText: "NombreCliente",
                  )),
              TextField(
                  controller: _tfRuc,
                  decoration: const InputDecoration(
                    hintText: "Ingrese N° Orden ",
                    labelText: "N° Orden",
                  )),
              Text(
                "Se encontraron " +
                    widget.oListaVEN_Cliente.length.toString() +
                    " Servicios",
                style: const TextStyle(fontSize: 9),
              ),
              JsonTable(
                json,
                columns: [
                  JsonTableColumn("CodigoServicio", label: "Código"),
                  JsonTableColumn("NombreCliente", label: "Nombre Cliente"),
                  JsonTableColumn("NumeroOrdenServicio", label: "N° orden"),
                  JsonTableColumn("FechaProgramada", label: "Fecha P."),
                  JsonTableColumn("Linea", label: "Linea"),
                  JsonTableColumn("Estado", label: "Estado"),
                  JsonTableColumn("Observaciones", label: "Observaciones"),
                ],
                showColumnToggle: false,
                allowRowHighlight: true,
                rowHighlightColor: Colors.yellow[500]!.withOpacity(0.7),
                paginationRowCount: 10,
                onRowSelect: (index, map) {
                  _verRegistro(int.parse(map["CodigoServicio"].toString()));
                },
              ),
            ],
          ),
        ));
  }
}
