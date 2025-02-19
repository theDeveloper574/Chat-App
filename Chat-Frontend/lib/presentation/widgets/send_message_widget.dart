import 'package:chatapp/presentation/widgets/textField_widget.dart';
import 'package:flutter/material.dart';

import '../../core/ui.dart';
import 'gap_widget.dart';

class SendMessageWidget extends StatelessWidget {
  final TextEditingController chatCon;
  final Function() onSend;
  const SendMessageWidget({
    super.key,
    required this.chatCon,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextFieldWidget(
              maxLines: 1,
              controller: chatCon,
              hintText: "write message....",
            ),
          ),
          InkWell(
            onTap: onSend,
            // onTap: () {
            //   if (chatCon.text.isNotEmpty) {
            //     sendMessage();
            //   }
            // },
            child: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: AppColors.drawerColor,
                child: Icon(Icons.send),
              ),
            ),
          ),
          const GapWidget(
            width: -12,
          ),
        ],
      ),
    );
  }
}
