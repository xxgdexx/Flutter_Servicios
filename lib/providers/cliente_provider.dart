import 'package:http/http.dart' as http;
import '../models/cliente_model.dart';
import 'dart:convert';
import '../utilidades/util.dart' as util;
import 'dart:async' show Future;

class VEN_ClienteProvider {
  String urlRegistraModifica = "RegistraModifica";
  String urlListado = "Listar";
  String urlListarKey = "Listarkey";
  String urlEliminar = "Eliminar";
  String jsonResultado = "";

  Future<List<Cliente>> listar(Cliente pCliente) async {
    final urlListadoVEN_Cliente = '${util.urlBase}/${util.controlerServicio}/' +
        '${this.urlListado}?${pCliente.toParameter()}';
    var respuesta = await http.get(Uri.parse(urlListadoVEN_Cliente));
    var data = respuesta.body;
    jsonResultado = "[${Cliente().toModelString()}]";
    print(jsonResultado);
    List<Cliente> oListaVEN_Cliente = [];
    if (data != '') {
      oListaVEN_Cliente =
          List<Cliente>.from(json.decode(data).map((x) => Cliente.fromJson(x)));
      jsonResultado = data;
    }
    return oListaVEN_Cliente;
  }

  Future<Cliente> listarKey(int pCodigoCliente) async {
    Cliente oCliente = Cliente();
    oCliente.inicializar();
    final urlquery = '${util.urlBase}/${util.controlerServicio}/' +
        urlListarKey +
        '?' +
        "&pCodigoCliente=" +
        pCodigoCliente.toString();
    final response = await http.get(Uri.parse(urlquery));
    final data = response.body;
    jsonResultado = data;
    if (data != '') {
      oCliente = Cliente.fromJson(json.decode(data));
    }
    return oCliente;
  }

  Future<Cliente> registraModifica(
      Cliente pCliente, String pTipoTransaccion) async {
    Cliente oCliente = Cliente();
    oCliente.inicializar();
    final urlquery = '${util.urlBase}/${util.controlerServicio}/' +
        urlRegistraModifica +
        '?' +
        pCliente.toParameter() +
        "&pTipoTransaccion=" +
        pTipoTransaccion;
    final response = await http.get(Uri.parse(urlquery));
    final data = response.body;
    jsonResultado = data;
    if (data != '') {
      pCliente = Cliente.fromJson(json.decode(data));
    }
    return pCliente;
  }

  Future<Cliente> eliminar(int pCodigoCliente) async {
    Cliente oCliente = Cliente();
    oCliente.inicializar();
    final urlquery = '${util.urlBase}/${util.controlerServicio}/' +
        urlEliminar +
        '?' +
        "&pCodigoCliente=" +
        pCodigoCliente.toString();
    final response = await http.get(Uri.parse(urlquery));
    final data = response.body;
    jsonResultado = data;
    if (data != '') {
      oCliente = Cliente.fromJson(json.decode(data));
    }
    return oCliente;
  }

  Future<Cliente> ListaValidarCamposLlenos(int pCodigoCliente) async {
    Cliente oCliente = Cliente();
    oCliente.inicializar();
    final urlquery = '${util.urlBase}/${util.controlerServicio}/' +
        urlListarKey +
        '?' +
        "&pCodigoCliente=" +
        pCodigoCliente.toString();
    final response = await http.get(Uri.parse(urlquery));
    final data = response.body;
    jsonResultado = data;
    if (data != '') {
      oCliente = Cliente.fromJson(json.decode(data));
    }
    return oCliente;
  }
}
