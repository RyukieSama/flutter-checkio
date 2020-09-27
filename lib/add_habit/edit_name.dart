import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/app_theme.dart';

class EditNameView extends StatefulWidget {
  final String editValue;
  final int editType;

  const EditNameView({
    Key key,
    this.editValue,
    this.editType,
  }) : super(key: key);

  @override
  _EditNameViewState createState() => _EditNameViewState();
}

class _EditNameViewState extends State<EditNameView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  ///文本内容
  String _value = '';
  TextEditingController editingController;

  AnimationController numAnimationController;
  Animation<double> numAnimation;

  double keyboardHeight = 10;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {

        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          //关闭键盘

        } else {
          //显示键盘
          setState(() {
            keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          });
        }

    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    editingController = TextEditingController(text: widget.editValue);

    numAnimationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    numAnimation = CurvedAnimation(
        parent: numAnimationController, curve: Curves.easeOutBack);
    if (widget.editValue.length > 0) {
      numAnimationController.forward(from: 0.3);
    }
    _value = widget.editValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Text(widget.editType == 1 ? '习惯名字' : '标志',
              style: AppTheme.appTheme.textStyle(
                textColor: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Expanded(
            flex: widget.editType == 1 ? 80 : 40,
            child: SizedBox(),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 32, right: 32),
                child: TextField(
                  strutStyle: StrutStyle(height: 1.5),
                  maxLength: widget.editType == 1 ? 10 : 50,
                  maxLines: widget.editType == 1 ? 1 : 5,
                  minLines: widget.editType == 1 ? 1 : 4,
                  controller: editingController,
                  showCursor: true,
                  autofocus: true,
                  onChanged: (value) async {
                    setState(() {
                      _value = value;
                    });
                    if (value.length == 1) {
                      numAnimationController.forward(from: 0.3);
                    } else if (value.length > 1) {
                      numAnimationController.forward(from: 0.3);
                    } else {
                      numAnimationController.reverse(from: 0.3);
                    }
                  },
                  onSubmitted: (value) async {
                    Navigator.of(context).pop(_value);
                  },
                  cursorColor: AppTheme.appTheme.gradientColorDark(),
                  style: AppTheme.appTheme.textStyle(
                      textColor: Colors.white,
                      fontWeight: widget.editType == 1
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 18),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 16,
                          top: widget.editType == 1 ? 30 : 15,
                          bottom: widget.editType == 1 ? 30 : 15,
                          right: 16),
                      hintText: widget.editType == 1 ? '名字 ...' : '标记 ...',
                      hintStyle: AppTheme.appTheme.textStyle(
                          textColor: Colors.white.withOpacity(0.5),
                          fontWeight: widget.editType == 1
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 18),
                      fillColor:
                          Theme.of(context).primaryColorDark.withOpacity(0.08),
                      counterText: '',
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.08)),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.08)),
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                ),
              ),
              ScaleTransition(
                scale: numAnimation,
                child: Padding(
                    padding: EdgeInsets.only(right: 25),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      width: 50,
                      height: 35,
                      child: Text(
                        '${_value.length}/${widget.editType == 1 ? 10 : 50}',
                        style: TextStyle(
                            color: AppTheme.appTheme.gradientColorDark(),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(right: 30, top: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(_value);
              },
              onDoubleTap: () {},
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: 50,
                height: 50,
                child: SvgPicture.asset(
                  'assets/images/duigou.svg',
                  color: AppTheme.appTheme.gradientColorDark(),
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          Expanded(
            flex: (keyboardHeight + 100).floor(),
            child: SizedBox(),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    editingController.dispose();
    numAnimationController.dispose();
    super.dispose();
  }
}
