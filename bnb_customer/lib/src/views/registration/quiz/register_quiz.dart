import 'package:bbblient/src/controller/all_providers/all_providers.dart';
import 'package:bbblient/src/utils/icons.dart';
import 'package:bbblient/src/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_main_theme.dart';
import 'finish.dart';
import 'questions/choose_categories.dart';
import 'questions/personal_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterQuiz extends ConsumerStatefulWidget {
  const RegisterQuiz({Key? key}) : super(key: key);

  @override
  _RegisterQuizState createState() => _RegisterQuizState();
}

class _RegisterQuizState extends ConsumerState<RegisterQuiz> {
  @override
  void initState() {
    super.initState();
  }

  //list of all the quiz pages
  final List<Widget> _pages = [const SingleChildScrollView(child: ProfileDetalis()), const SingleChildScrollView(child: ChooseCategories()), const Finish()];
  //returns the title from current page
  String getTitle(int page) {
    switch (page) {
      case 0:
        return AppLocalizations.of(context)?.first ?? "First...";
      case 1:
        return AppLocalizations.of(context)?.oneMore ?? "One more...";
      case 2:
        return AppLocalizations.of(context)?.finish ?? "🎉  Finish !";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _quizProvider = ref.watch(quizProvider);
    return Scaffold(
        body: ConstrainedContainer(
      child: SafeArea(
          child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: IconButton(
                            onPressed: () {
                              _quizProvider.onBack(context: context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                            ),
                          ),
                        ),
                        Text(
                          getTitle(_quizProvider.currentPage),
                          style: AppTheme.displayLarge.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    PageView(
                      allowImplicitScrolling: false,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _quizProvider.pageController,
                      onPageChanged: (val) {
                        _quizProvider.changePage(context: context, i: val, animatePage: false);
                      },
                      children: _pages,
                    ),
                    if (_quizProvider.currentPage != _pages.length - 1) ...[
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            _quizProvider.onNext(context: context);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: AppTheme.creamBrown,
                            child: const SizedBox(
                              height: 51,
                              width: 51,
                              child: Center(
                                  child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: (MediaQuery.of(context).viewInsets.bottom != 0)
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 1; i <= _pages.length; i++)
                            GestureDetector(
                              onTap: () {
                                _quizProvider.changePage(i: i - 1, context: context, animatePage: true);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 20,
                                width: 20,
                                child: Padding(
                                  padding: EdgeInsets.all((i == _quizProvider.currentPage + 1) ? 0 : 5.0),
                                  child: SvgPicture.asset(
                                    i == _quizProvider.currentPage + 1 ? AppIcons.dotActiveSVG : AppIcons.dotInactiveSVG,
                                    color: AppTheme.creamBrownLight,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
            ),
          ),
        ],
      )),
    ));
  }
}
