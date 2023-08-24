import 'dart:convert';

import 'package:currency/domain/currency.dart';
import 'package:http/http.dart' as http;

class CurrencyApiClient {
  final String apiAuthority = "api.freecurrencyapi.com";
  final MapEntry<String, String> apiKey = const MapEntry(
      "apikey", "fca_live_wJ4a5rokmyxIw54TtYefiw3jjI0XCQOvUd0dchOH");

  Future<List<Currency>> getCurrencies() async {
    Map<String, String> urlArgs = {};
    List<MapEntry<String, String>> urlEntries = [apiKey];
    urlArgs.addEntries(urlEntries);
    Uri getCurrenciesUrl = Uri.https(
      apiAuthority,
      "/v1/currencies",
      urlArgs,
    );

    http.Response response = await http.get(getCurrenciesUrl);

    if (response.statusCode == 200) {
      var currencyObjects = getDataFromResponse(response);
      List<Currency> currencies = [];
      for (var currencyCode in currencyObjects.keys) {
        var currency = currencyObjects[currencyCode];
        currencies.add(
            Currency(currency["symbol"], currency["name"], currency["code"]));
      }
      return currencies;
    } else {
      throw Exception(
          "Something went wrong while connecting with currencies API");
    }
  }

  Future<double> getExchangeRate(
      Currency baseCurrency, Currency targetCurrency) async {
    Map<String, String> urlArgs = {};
    List<MapEntry<String, String>> urlEntries = [
      apiKey,
      MapEntry("base_currency", baseCurrency.code)
    ];
    urlArgs.addEntries(urlEntries);
    Uri getExchangeRateUrl = Uri.https(apiAuthority, "/v1/latest", urlArgs);

    http.Response response = await http.get(getExchangeRateUrl);

    if (response.statusCode == 200) {
      var currencyObjects = getDataFromResponse(response);
      double exchangeRate = 0;
      for (var currencyCode in currencyObjects.keys) {
        if (currencyCode == targetCurrency.code) {
          exchangeRate = currencyObjects[currencyCode];
        }
      }
      return exchangeRate;
    } else {
      throw Exception(
          "Something went wrong while connecting with currencies API");
    }
  }

  dynamic getDataFromResponse(http.Response response) {
    dynamic body = jsonDecode(response.body);
    return body["data"];
  }
}
