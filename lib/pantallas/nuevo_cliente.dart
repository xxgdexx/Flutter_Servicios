import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../providers/cliente_provider.dart';

class NuevoVEN_Cliente extends StatefulWidget {
  String titulo;
  Cliente oCliente = Cliente();
  final _provider = VEN_ClienteProvider();
  int codigoVEN_ClienteSeleccionado = 0;
  String mensaje = "";
  bool validacion = false;
  NuevoVEN_Cliente(this.titulo, this.codigoVEN_ClienteSeleccionado);
  @override
  _NuevoVEN_Cliente createState() => _NuevoVEN_Cliente();
}

class _NuevoVEN_Cliente extends State<NuevoVEN_Cliente> {
  final _tfCodigoCliente = TextEditingController();
  final _tfRazonSocial = TextEditingController();
  final _tfRuc = TextEditingController();
  final _tfDireccion = TextEditingController();
  final _tfContacto = TextEditingController();
  final _tfTelefono = TextEditingController();
  final _tfAnexo = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oCliente.inicializar();
    if (widget.codigoVEN_ClienteSeleccionado > 0) {
      _listarKeyProvider();
    }
  }

  Future<String> _listarKeyProvider() async {
    Cliente oClienteModel = Cliente();
    oClienteModel.inicializar();
    var oClienteModeltmp =
        await widget._provider.listarKey(widget.codigoVEN_ClienteSeleccionado);

    // ignore: avoid_print
    print(oClienteModeltmp);
    setState(() {
      widget.oCliente = oClienteModeltmp;
      if (widget.oCliente.codigoServicio! > 0) {
        widget.mensaje = "Estas actualizando los datos";
        _mostrarDatos();
      }
    });
    return "Procesado";
  }

  void _mostrarDatos() {
    _tfCodigoCliente.text = widget.oCliente.codigoServicio.toString();
    _tfRazonSocial.text = widget.oCliente.nombreCliente.toString();
    _tfRuc.text = widget.oCliente.numeroOrdenServicio.toString();
    _tfDireccion.text = widget.oCliente.fechaProgramada.toString();
    _tfContacto.text = widget.oCliente.linea.toString();
    _tfTelefono.text = widget.oCliente.estado.toString();
    _tfAnexo.text = widget.oCliente.observaciones .toString();
  }

  void _cargarEntidad() {
    widget.oCliente.codigoServicio = int.parse(_tfCodigoCliente.text);
    widget.oCliente.nombreCliente = _tfRazonSocial.text;
    widget.oCliente.numeroOrdenServicio = _tfRuc.text;
    widget.oCliente.fechaProgramada = _tfDireccion.text;
    widget.oCliente.linea = _tfContacto.text;
    widget.oCliente.estado = _tfTelefono.text;
    widget.oCliente.observaciones = _tfAnexo.text;
  }

  bool _validarRegistro() {
    if (_tfCodigoCliente.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar codigoServicio ";
      });
      return false;
    }
    if (_tfRazonSocial.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar nombreCliente ";
      });
      return false;
    }
    if (_tfRuc.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar numeroOrdenServicio ";
      });
      return false;
    }
    if (_tfDireccion.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar fechaProgramada ";
      });
      return false;
    }
    if (_tfContacto.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar linea ";
      });
      return false;
    }
    if (_tfTelefono.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar estado ";
      });
      return false;
    }
    if (_tfAnexo.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar observaciones ";
      });
      return false;
    }

    return true;
  }

  void _grabarRegistro() {
    if (_validarRegistro()) {
      _ejecutar_ClienteGrabadoProvider();
    }
  }

  // ignore: non_constant_identifier_names
  Future<String> _ejecutar_ClienteGrabadoProvider() async {
    String accion = "N";
    if (widget.oCliente.codigoServicio! > 0) {
      accion = "A";
    }
    _cargarEntidad();
    Cliente oClienteModeltmp = Cliente();
    oClienteModeltmp.inicializar();
    var oClienteModeltmpReg =
        await widget._provider.registraModifica(widget.oCliente, accion);
    // ignore: avoid_print
    print(oClienteModeltmpReg);
    setState(() {
      widget.oCliente = oClienteModeltmpReg;
      if (widget.oCliente.codigoServicio! > 0) {
        widget.mensaje = "Grabado correctamente";
      }
      // ignore: avoid_print
      print(widget.oCliente);
    });
    return "Procesado";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro de Servicios " + widget.titulo),
          actions: [
            IconButton(icon: Icon(Icons.save), onPressed: _grabarRegistro),
          ],
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(" Código de Servicio:" +
                  widget.oCliente.codigoServicio.toString()),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                      controller: _tfCodigoCliente,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Codigo de Servicio ",
                        labelText: "Código Servicio",
                      )),
                  TextField(
                      controller: _tfRazonSocial,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Nombre Cliente ",
                        labelText: "Nombre de cliente",
                      )),
                  TextField(
                      controller: _tfRuc,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Numero de orden de Servicio ",
                        labelText: "N° Orden",
                      )),
                  TextField(
                      controller: _tfDireccion,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Fecha Programada ",
                        labelText: "Fecha Programada",
                      )),
                  TextField(
                      controller: _tfContacto,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Linea ",
                        labelText: "Linea",
                      )),
                  TextField(
                      controller: _tfTelefono,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Estado ",
                        labelText: "Estado",
                      )),
                  TextField(
                      controller: _tfAnexo,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Observaciones ",
                        labelText: "Observaciones",
                      )),
                  Text("Mensaje:" + widget.mensaje),
                ],
              ),
            )
          ],
        ));
  }
}
