import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../theme/app_main_theme.dart';

class PriceFilter extends StatefulWidget {
  const PriceFilter({Key? key}) : super(key: key);

  @override
  _PriceFilterState createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  double? priceStart = 100;

  double? priceEnd = 1200;

  final TextEditingController _priceStartController = TextEditingController();
  TextEditingController _priceEndController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceStartController.text = priceStart.toString();
    _priceEndController.text = priceEnd.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "${AppLocalizations.of(context)?.price ?? "Price"}, ₴",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          const Divider(
            color: AppTheme.coolGrey,
          ),
          SfRangeSlider(
            values: SfRangeValues(priceStart, priceEnd),
            max: 2000.00,
            min: 0.00,
            onChanged: (SfRangeValues newValues) {
              setState(() {
                priceStart = newValues.start;
                priceEnd = newValues.end;
                _priceStartController.text = priceStart!.toInt().toString();
                _priceEndController.text = priceEnd!.toInt().toString();
              });
            },
            enableTooltip: true,
            tooltipShape: const SfPaddleTooltipShape(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width / 3,
                child: TextFormField(
                  controller: _priceStartController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      priceStart = double.tryParse(val);
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 30,
                child: Divider(
                  indent: 10,
                  endIndent: 10,
                  thickness: 2,
                ),
              ),
              SizedBox(
                width: size.width / 3,
                child: TextFormField(
                  controller: _priceEndController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      priceStart = double.tryParse(val);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
