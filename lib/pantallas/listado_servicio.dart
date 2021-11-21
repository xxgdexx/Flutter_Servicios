import 'package:flutter/material.dart';
import '../models/servicio_model.dart';
import '../providers/servicio_provider.dart';
import 'nuevo_servicio.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:json_table/json_table.dart';

class listadoVEN_Servicio extends StatefulWidget {
  String titulo;
  final _provider =  VEN_ServicioProvider();
  List<Servicio> oListaVEN_Servicio = [];
  final int codigoVEN_ServicioSeleccionado = 0;
  Servicio oServicio = Servicio();
  String jSonVEN_Servicio = "";
  listadoVEN_Servicio(this.titulo, {Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _ListadoVEN_Servicio();
}

class _ListadoVEN_Servicio extends State<listadoVEN_Servicio> {
  final _tfRazonSocial = TextEditingController();
  final _tfRuc = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oServicio.inicializar();
    widget.jSonVEN_Servicio = '[${widget.oServicio.toModelString()}]';
  }

  Future<String> _consultarRegistros() async {
    Servicio pServicio = Servicio();
    pServicio.inicializar();
    pServicio.nombreCliente = _tfRazonSocial.text;
    pServicio.numeroOrdenServicio = _tfRuc.text;

    var oListaVEN_ServicioTmp = await widget._provider.listar(pServicio);
    // ignore: avoid_print
    print(oListaVEN_ServicioTmp);
    setState(() {
      widget.oListaVEN_Servicio = oListaVEN_ServicioTmp;
      widget.jSonVEN_Servicio = widget._provider.jsonResultado;
      if (widget.oListaVEN_Servicio.length == 0) {
        widget.jSonVEN_Servicio = '[${widget.oServicio.toModelString()}]';
      }
    });
    return "Procesado";
  }

  void _nuevoRegistro() {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return NuevoVEN_Servicio("", 0);
    }));
  }

  void _verRegistro(int pCodigoServicio) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return NuevoVEN_Servicio("", pCodigoServicio);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(widget.jSonVEN_Servicio);
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
                    widget.oListaVEN_Servicio.length.toString() +
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
