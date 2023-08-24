import 'package:currency/domain/currency.dart';
import 'package:currency/services/currency_api_client.dart';
import 'package:currency/views/style.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter", style: appBarTextStyle),
      ),
      body: const AppBody(),
    );
  }
}

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<StatefulWidget> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  CurrencyApiClient client = CurrencyApiClient();
  List<Currency> currenciesTarget = [];
  List<Currency> currenciesBase = [];
  String targetCurrencyCode = "BRL";
  String baseCurrencyCode = "USD";
  String targetCountryCode = "br";
  String baseCountryCode = "us";
  TextEditingController entryController = TextEditingController();
  String result = "Result";

  @override
  void initState() {
    super.initState();

    (() async {
      List<Currency> currenciesTemp = await client.getCurrencies();

      setState(() {
        currenciesTarget = currenciesTemp;
        currenciesBase = currenciesTemp;
      });
    })();
  }

  void onFromChange(String? val) {
    setState(() {
      targetCurrencyCode = val!;
      targetCountryCode = val.substring(1, 2).toLowerCase();
    });
  }

  void onToChange(String? val) {
    setState(() {
      baseCurrencyCode = val!;
      baseCountryCode = val.substring(1, 2).toLowerCase();
    });
  }

  void onCalculatePressed() {
    (() async {
      Currency baseCurrency = currenciesBase
          .where((currency) => currency.code == baseCurrencyCode)
          .first;
      Currency targetCurrency = currenciesTarget
          .where((element) => element.code == targetCurrencyCode)
          .first;
      double exchangeRate =
          await client.getExchangeRate(baseCurrency, targetCurrency);
      double entryValue = double.parse(entryController.value.text);
      setState(() {
        String convertedValue = (entryValue * exchangeRate).toStringAsFixed(2);
        result = "\$ $convertedValue";
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 94, vertical: 24),
      child: Column(children: [
        Text(result, style: bodyTextStyle),
        const SizedBox(
          height: 100,
        ),
        Row(
          children: [
            Text("From: ", style: bodyTextStyle),
            const SizedBox(width: 48),
            DropdownButton<String>(
              onChanged: onFromChange,
              value: targetCurrencyCode,
              items: currenciesTarget
                  .map<DropdownMenuItem<String>>((Currency val) {
                return DropdownMenuItem<String>(
                  value: val.code,
                  child: Text(val.code, style: bodyTextStyle),
                );
              }).toList(),
            )
          ],
        ),
        TextField(
          keyboardType: TextInputType.number,
          style: bodyTextStyle,
          controller: entryController,
        ),
        Row(
          children: [
            Text("To: ", style: bodyTextStyle),
            const SizedBox(width: 76),
            DropdownButton<String>(
              onChanged: onToChange,
              value: baseCurrencyCode,
              items:
                  currenciesBase.map<DropdownMenuItem<String>>((Currency val) {
                return DropdownMenuItem<String>(
                  value: val.code,
                  child: Text(val.code, style: bodyTextStyle),
                );
              }).toList(),
            )
          ],
        ),
        const SizedBox(height: 45),
        ElevatedButton(
          onPressed: onCalculatePressed,
          child: Text("Calculate", style: bodyTextStyle),
        )
      ]),
    );
  }
}
